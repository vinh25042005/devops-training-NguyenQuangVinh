# Cài Helm & Ingress NGINX

## 1. Cài Helm CLI

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

Kiểm tra:

```bash
helm version
```

## 2. Cài Ingress NGINX Controller bằng Helm

Thêm Helm repo:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

Cài đặt:

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace
```

Kiểm tra:

```bash
kubectl get pods -n ingress-nginx
```

Đợi pod `ingress-nginx-controller-xxx` chuyển sang `Running 1/1`.
