# Rancher Manager

## Cài đặt

### 1. Tạo file Docker Compose

```yaml
# docker-compose.yml
services:
  rancher-server:
    image: rancher/rancher:v2.14.2
    container_name: rancher-server
    restart: unless-stopped
    privileged: true
    ports:
      - "8081:80"
      - "8443:443"
    volumes:
      - ./data:/var/lib/rancher
```

### 2. Khởi động Rancher

```bash
docker compose up -d
```

Kiểm tra container đã chạy:

```bash
docker ps | grep rancher
```

### 3. Lấy mật khẩu admin

```bash
docker exec rancher-server reset-password
```

### 4. Truy cập Rancher UI

Mở trình duyệt: **https://localhost:8443**

> ⚠️ Trình duyệt cảnh báo SSL (cert tự sinh) → bấm **Advanced → Proceed to localhost**.

Đăng nhập:
- Username: `admin`
- Password: (từ lệnh `reset-password` ở trên)

## Import cluster vào Rancher

### 1. Trên Rancher UI

Vào **☰ → Cluster Management → Import Existing** → chọn **Generic** → đặt tên (vd: `k3d-dev`) → **Create**.

### 2. Kết nối Rancher vào network của cluster

Nếu cluster k3d chạy trên cùng máy, cần nối Rancher vào chung Docker network:

```bash
# Tìm network của k3d
docker network ls | grep k3d

# Kết nối Rancher vào network đó
docker network connect <k3d-network> rancher-server
```

### 3. Lấy IP của Rancher trong network đó

```bash
docker inspect rancher-server | grep -A 10 "<k3d-network>"
```

Ghi lại `"IPAddress"` (vd: `172.20.0.6`).

### 4. Import cluster từ terminal

Thay `<rancher-ip>` bằng IP ở bước 3 và `<token>` bằng token từ Rancher UI:

```bash
curl --insecure -sfL https://<rancher-ip>:443/v3/import/<token>.yaml | kubectl apply -f -
```

### 5. Sửa server-url

Sau khi import, vào **Rancher UI → ☰ → Global Settings** → tìm **`server-url`** → sửa thành `https://<rancher-ip>:443`.

### 6. Kiểm tra

```bash
kubectl get pods -n cattle-system -w
```

Đợi pod `cattle-cluster-agent` chuyển sang `Running 1/1`. Trên Rancher UI, cluster sẽ chuyển từ `Pending` sang `Active`.

## Khởi động lại sau khi reboot máy

Rancher có `restart: unless-stopped` nên sẽ tự động chạy khi Docker khởi động. Chỉ cần đảm bảo Docker Desktop (hoặc Docker Engine) được bật.

## Truy cập từ máy khác cùng mạng LAN

### 1. Lấy IP của máy Windows

Trên máy chủ, mở Command Prompt hoặc PowerShell:

```powershell
ipconfig
```

Tìm dòng `IPv4 Address` của adapter Wi-Fi (vd: `192.168.100.17`).

### 2. Sửa server-url trong Rancher UI

Vào **Rancher UI → ☰ → Global Settings** → tìm **`server-url`** → Edit → sửa thành:

```
https://<IP-máy-bạn>:8443
```

(ví dụ: `https://192.168.100.17:8443`) → **Save**.

### 3. Lấy IP của WSL

Trong WSL:

```bash
hostname -I
```

(ví dụ: `192.168.150.47`)

### 4. Thêm port proxy (Windows → WSL)

Mở **PowerShell Run as Administrator**, chạy:

```powershell
netsh interface portproxy add v4tov4 listenport=8443 listenaddress=0.0.0.0 connectport=8443 connectaddress=<WSL-IP>
```

(ví dụ: `connectaddress=192.168.150.47`)

### 5. Mở firewall Windows

Cùng PowerShell Admin đó:

```powershell
New-NetFirewallRule -DisplayName "Rancher 8443" -Direction Inbound -Protocol TCP -LocalPort 8443 -Action Allow
```

### 6. sửa file hosts

Mỗi máy muốn truy cập, mở Notepad **Run as Administrator**, sửa file:

```
C:\Windows\System32\drivers\etc\hosts
```

Thêm dòng:

```
<IP-máy-bạn>   vinh.rancher
```

(ví dụ: `192.168.100.17   vinh.rancher`)

Sau đó vào trình duyệt: **https://vinh.rancher:8443**

### 7. Kiểm tra

```bash
# Trên WSL, kiểm tra port đang listen
ss -tlnp | grep 8443

# Kiểm tra port proxy trên Windows (PowerShell)
netsh interface portproxy show all
```

## Dừng Rancher

```bash
docker compose down    # dừng hẳn
docker compose stop    # dừng tạm
```

## Xoá hoàn toàn

```bash
docker compose down -v
rm -rf data/
```
