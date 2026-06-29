# Deployment
## deploy app nginx 3 replica

```bash
kubectl create deployment demo-app --image=nginx --replicas=3
# Kiểm tra
kubectl get pods
```

```
vinh2@vi:~/work/devops-training-NguyenQuangVinh$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
demo-app-69cd59fbf4-8zl68   1/1     Running   0          89s
demo-app-69cd59fbf4-f5hj5   1/1     Running   0          89s
demo-app-69cd59fbf4-lnn4p   1/1     Running   0          89s
```

## rolling update lên v2
```bash
kubectl set image deployment/demo-app nginx=nginx:alpine
```

## roleback
```bash
# Xem lịch sử các revision
kubectl rollout history deployment/demo-app

# Rollback về revision trước (từ alpine về latest)
kubectl rollout undo deployment/demo-app
```

# Ingress

## 1. Cài ingress-nginx

- k3d có sẵn Traefik xung đột với ingress-nginx cần cài nên xoá đi và tạo lại cluster
```bash
k3d cluster delete dev
k3d cluster create dev --agents 2 -p "8080:80@loadbalancer" --k3s-arg "--disable=traefik@server:0"
```
- tải file yaml chứa các resources liên quan đến ingress-nginx do đội K8S viết và apply lên cluster
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml
```
- Lệnh tạo ra 1 `Namespace` riêng cho ingress, chứa các pod, service, config, ... cần thiết

## 2. Tạo deployment và service cho deployment
```bash
kubectl create deployment demo-app --image=nginx --replicas=3
kubectl expose deployment demo-app --port=80
```

## 3. Tạo ingress resource
```bash
kubectl apply -f day-2-deployment/manifests/ingress.yaml

#kiểm tra 
kubectl get ingress
```

## 4. Thêm domain vào host
```bash
echo "127.0.0.1 app.local" | sudo tee -a /etc/hosts
```

## 5. Kiểm tra

```bash
curl http://app.local:8080
```

```bash
# log của Ingress Controller
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller --tail=5

# log của pod demo-app
kubectl logs -l app=demo-app --tail=5
```
```json
vinh2@vi:~/work/devops-training-NguyenQuangVinh$ kubectl logs -n ingress-nginx deployment/ingress-nginx-controller --tail=5
172.20.0.5 - - [29/Jun/2026:10:39:41 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" 77 0.001 [default-demo-app-80] [] 10.42.2.3:80 896 0.001 200 c3e4ebb03409c633c55cefe6e0f8218e
10.42.0.3 - - [29/Jun/2026:10:39:49 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" 77 0.002 [default-demo-app-80] [] 10.42.1.5:80 896 0.001 200 4f0dd1e7dbf66b0f3fe9a22a514ce9f0
I0629 10:39:56.007590       7 status.go:304] "updating Ingress status" namespace="default" ingress="demo-app-ingress" currentValue=null newValue=[{"ip":"172.20.0.2"}]
I0629 10:39:56.011110       7 event.go:377] Event(v1.ObjectReference{Kind:"Ingress", Namespace:"default", Name:"demo-app-ingress", UID:"b83baa6e-45b9-4e58-b9ae-9bd777331e7d", APIVersion:"networking.k8s.io/v1", ResourceVersion:"816", FieldPath:""}): type: 'Normal' reason: 'Sync' Scheduled for sync
10.42.1.3 - - [29/Jun/2026:10:42:33 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" 77 0.001 [default-demo-app-80] [] 10.42.1.5:80 896 0.001 200 eb8800bb7fd42861e7f6c686e1b3eb86
vinh2@vi:~/work/devops-training-NguyenQuangVinh$ kubectl logs -l app=demo-app --tail=5
2026/06/29 10:38:44 [notice] 1#1: start worker process 41
2026/06/29 10:38:44 [notice] 1#1: start worker process 42
2026/06/29 10:38:44 [notice] 1#1: start worker process 43
2026/06/29 10:38:44 [notice] 1#1: start worker process 44
10.42.2.5 - - [29/Jun/2026:10:39:39 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" "10.42.1.3"
2026/06/29 10:38:46 [notice] 1#1: start worker process 41
2026/06/29 10:38:46 [notice] 1#1: start worker process 42
2026/06/29 10:38:46 [notice] 1#1: start worker process 43
2026/06/29 10:38:46 [notice] 1#1: start worker process 44
10.42.2.5 - - [29/Jun/2026:10:39:41 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" "172.20.0.5"
2026/06/29 10:38:43 [notice] 1#1: start worker process 42
2026/06/29 10:38:43 [notice] 1#1: start worker process 43
2026/06/29 10:38:43 [notice] 1#1: start worker process 44
10.42.2.5 - - [29/Jun/2026:10:39:49 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" "10.42.0.3"
10.42.2.5 - - [29/Jun/2026:10:42:33 +0000] "GET / HTTP/1.1" 200 896 "-" "curl/8.5.0" "10.42.1.3"
vinh2@vi:~/work/devops-training-NguyenQuangVinh$ 
```

```
# tóm tắt
curl http://app.local:8080
         │
         ▼  TCP 127.0.0.1:8080
k3d loadbalancer (172.20.0.5)
         │
         ▼ 
Ingress Controller (10.42.2.5)
  Log: "172.20.0.5 → GET / → 200"
  Log: "[default-demo-app-80]" ← match ingress rule
         │ forward đến Service demo-app:80
         ▼
Pod demo-app (10.42.1.5:80)
  Log: "10.42.2.5 → GET / → 200" ← nhận request từ ingress controller
         │
         ▼
Trả về "Welcome to nginx!" 
```
