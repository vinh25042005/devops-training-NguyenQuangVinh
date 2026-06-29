# K8S architecture

## Node - duy trì các pod đang hoạt động và môi trường runtime của k8s
- **pod**: đơn vị nhỏ nhất trong k8s, thực hiện các job, 1 node có thể có nhiều pod
- **kubelet**: nhận yêu cầu từ kebe-api-server giao đến pod
- **kube-proxy**: thực hiện các rules về mạng trong node, giúp các pod giao tiếp với nhau/ ra ngoài,...

## Control panel
- **kube-api-server**: xử lý các yêu cầu quản trị, cấu hình, tương tác trong cụm k8s