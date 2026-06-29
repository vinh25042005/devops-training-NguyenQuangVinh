# K8S architecture

## Node - duy trì các pod đang hoạt động và môi trường runtime của k8s
- **pod**: đơn vị nhỏ nhất trong k8s, thực hiện các job, 1 node có thể có nhiều pod
- **kubelet**: nhận yêu cầu từ kebe-api-server giao đến pod
- **kube-proxy**: thực hiện các rules về mạng trong node, giúp các pod giao tiếp với nhau/ ra ngoài,...

## Control panel
- **kube-api-server**: xử lý các yêu cầu quản trị, cấu hình, tương tác trong cụm k8s
- **etcd**: lưu cấu hình của cụm k8s, các trạng thái của pod, node,...
- **kube-scheduler**: phân phối pod đến node dựa trên cpu, ram, ... theo chỉ định của mình
- **controller-manager**: quản lý các tiến trình giám sát trạng thái của cụm k8s

# Kubectl
## `kubectl get`
- liệt kê tài nguyên trong k8s => kubectl get nodes: liệt kê các node trong cụm k8s
```
NAME               STATUS   ROLES           AGE   VERSION
k3d-dev-agent-0    Ready    <none>          21s   v1.35.5+k3s1
k3d-dev-agent-1    Ready    <none>          21s   v1.35.5+k3s1
k3d-dev-server-0   Ready    control-plane   23s   v1.35.5+k3s1
```


## `kubectl run web --image=nginx --port=80` 
- tạo ra 1 pod => tên là web => trong pod chứa container cũng tên là web => chạy ở image nginx => khai báo container dùng port 80
  - `apiserver` kiểm tra các thứ => ghi vào `etcd` => `scheduler` xem `etcd` qua `api-server`, thấy Pod chưa có node => chọn node ghi vào `etcd` => `kubelet` trên node được chọn xem `etcd` thấy Pod web => tạo và chạy container => báo về `apiserver` => `kube-proxy` thêm ip của pod mới vào rule.

## `kubectl expose pod web --type=ClusterIP`
- `kubectl expose` dùng để tạo một **Kubernetes Service**
- tạo 1 service(tên là web) để các pod khác có thể gọi đến pod `web` qua 1 `cluster IP` chỉ pod trong cluster mới gọi đc
