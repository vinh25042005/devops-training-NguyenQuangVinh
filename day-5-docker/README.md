# Day 5 — Docker Fundamentals

- **Intern**: Nguyen Quang Vinh
- **Phase / Week / Day**: Phase 1 / Week 1 / Day 5
- **Branch**: `phase-1/week-1/day-5-docker`
- **Submitted at**: 2026-06-21 (timezone +07)
- **Time spent**: 6h

## 1. Mục tiêu

- Hiểu image layer, cache, union filesystem.
- Viết Dockerfile multi-stage build, non-root user, healthcheck, label OCI.
- Làm quen Docker network, volume (named volume & bind-mount).
- Push image lên Docker Hub.
- Dùng dive phân tích image layer.

## 2. Cách chạy

> **Lưu ý chung:** Nếu port bị chiếm, đổi port host tuỳ ý (vd: `-p 5000:3000`, `-p 9999:80`).

### Part A — Xem image layer

Lý thuyết trong `notes.md`. Thực hành:

```bash
# Pull + xem layer
docker pull nginx:1.27-alpine
docker history nginx:1.27-alpine

# Cài + chạy dive 
wget https://github.com/joschi/dive/releases/download/v0.13.1/dive_0.13.1_linux_amd64.deb
sudo dpkg -i dive_0.13.1_linux_amd64.deb
dive nginx:1.27-alpine
```

### Part B — Build & chạy demo-app

```bash
cd day-5-docker

# Build image
docker build -t demo-app:1.0.0 .

# Kiểm tra size 
docker image ls demo-app

# Chạy container (đổi 3000 nếu bị chiếm)
docker run --rm -p 3000:3000 -e NAME=phase1 demo-app:1.0.0

# Curl lại
curl http://localhost:3000
# → {"msg":"hello from phase1","ts":...}

docker run -d --rm --name test-health -p 3001:3000 demo-app:1.0.0
sleep 35 && docker ps --filter name=test-health
# Cột STATUS hiện "(healthy)"
docker stop test-health
```

### Part C — Network & Volume

Chi tiết command + output trong `network-volume.md`. Tóm tắt:

```bash
# Network: tạo demo-net, chạy app1 + app2, curl cross-container
docker network create demo-net
docker run -d --rm --name app1 --network demo-net -e NAME=app1 demo-app:1.0.0
docker run -d --rm --name app2 --network demo-net -e NAME=app2 demo-app:1.0.0
docker exec app1 wget -qO- http://app2:3000

# Volume: postgres với named volume, restart giữ data
docker volume create pgdata
docker run -d --name postgres-demo -e POSTGRES_PASSWORD=secret123 \
  -v pgdata:/var/lib/postgresql/data postgres:16-alpine
# ... (xem chi tiết trong network-volume.md)

# Bind-mount: nginx mount thư mục site, sửa file thấy ngay
mkdir -p site && echo '<h1>Hello</h1>' > site/index.html
docker run -d --name nginx-demo -p 9090:80 \
  -v $PWD/site:/usr/share/nginx/html nginx:1.27-alpine
curl http://localhost:9090
```

### Part D — Push Docker Hub

```bash
# Login
docker login

# Tag + push
docker tag demo-app:1.0.0 vinh2504/demo-app:1.0.0
docker push vinh2504/demo-app:1.0.0

# Verify 
docker pull vinh2504/demo-app:1.0.0
docker run --rm -p 3000:3000 -e NAME=from-hub vinh2504/demo-app:1.0.0
curl http://localhost:3000
# → {"msg":"hello from from-hub","ts":...}
```

### Part E — Bonus: Scan image + so sánh size

**Scan với docker scout:**

```bash
# Cài docker scout plugin
curl -fsSL https://github.com/docker/scout-cli/releases/download/v1.21.0/docker-scout_1.21.0_linux_amd64.tar.gz \
  -o /tmp/scout.tar.gz
tar xzf /tmp/scout.tar.gz -C ~/.docker/cli-plugins/ docker-scout
chmod +x ~/.docker/cli-plugins/docker-scout

# Scan nhanh
docker scout quickview demo-app:1.0.0
```

Kết quả:
```
Target             │  demo-app:1.0.0  │  1C  19H  8M  4L
Base image         │  node:20-alpine  │  1C  19H  8M  4L
Updated base image │  node:24-alpine  │  0C   1H  5M  2L
```


**Xem chi tiết CVES:**
```bash
docker scout cves demo-app:1.0.0
```
Lỗi critical chủ yếu ở `openssl 3.5.6-r0`:
- CVE-2026-34182 (CRITICAL)
- CVE-2026-45447 (HIGH)
- CVE-2026-7383 (HIGH)

**So sánh size base image:**

| Base image | Size (disk) |
|-----------|-------------|
| `node:20` | 1.59 GB |
| `node:20-slim` | 293 MB |
| `node:20-alpine` | ~48 MB (content) / 193 MB (disk) |


## 3. Kết quả

- Multi-stage build: dùng `node:20` làm build, `node:20-alpine` làm run
- Non-root user: tự tạo `server-user` bằng `adduser -D`, container không chạy root
- HEALTHCHECK: `wget -qO- http://localhost:3000` mỗi 30s, sau ~35s `docker ps` thấy status `(healthy)`
- LABEL OCI: gắn `org.opencontainers.image.title` + `org.opencontainers.image.version`
- Image size: `docker image ls` ra 193MB disk / 48.4MB content → dưới 200MB
- `.dockerignore`: đã thêm, build context nhẹ, không copy file rác vào image
- Cross-container: app1 curl app2 qua `demo-net` → `{"msg":"hello from app2"}`, OK
- Volume persist: tạo DB testdb trong postgres, xóa container, chạy lại → testdb vẫn còn
- Bind-mount: sửa `site/index.html` trên host, curl lại nginx thấy nội dung mới ngay không cần restart
- Push Docker Hub: `vinh2504/demo-app:1.0.0` đã push, pull về máy khác chạy OK
- Bonus scan: docker scout tìm ra 32 lỗi (1C 19H 8M 4L)

**Image link:** https://hub.docker.com/r/vinh2504/demo-app

## 4. Khó khăn & cách giải quyết

- **Dive v0.12.0 bị bug với Docker Engine mới**: Do Docker 25+ dùng OCI format, dive parse thiếu blob < 1024 bytes. → Build dive từ fork joschi (v0.13.1) là chạy được.
- **Alpine apk DNS lỗi transient**: Lúc build bị `DNS: transient error` khi `apk add curl`. → thay curl bằng wget 
- **Port bị chiếm**: Port 8080 và 3000 có thể bận. → Đổi port host linh hoạt (`-p 9090:80`, `-p 4000:3000`).

## 5. Reference
- Dive bug: https://github.com/wagoodman/dive/pull/511

## 6. Self-check

- [x] Code chạy được trên máy sạch (đã verify pull từ Hub)
- [x] README có hướng dẫn run lại
- [x] Không hard-code secret
- [x] Commit message theo Conventional Commits
- [x] Đã review lại code 1 lượt