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