# Part C — Network & Volume

## 1. Tạo bridge network `demo-net`

```bash
docker network create demo-net
docker network ls | grep demo-net
```

Kết quả:
```
577252aa048c   demo-net   bridge    local
```

## 2. Chạy 2 container app1, app2 trong cùng network — curl từ app1 sang app2

```bash
# Chạy app1
docker run -d --rm --name app1 --network demo-net -e NAME=app1 demo-app:1.0.0

# Chạy app2
docker run -d --rm --name app2 --network demo-net -e NAME=app2 demo-app:1.0.0

# Từ app1 curl sang app2 
docker exec app1 wget -qO- http://app2:3000
```

Kết quả curl từ app1 sang app2:
```json
{"msg":"hello from app2","ts":1782007071379}
```

```bash
# Từ app2 curl sang app1
docker exec app2 wget -qO- http://app1:3000
```

Kết quả curl từ app2 sang app1:
```json
{"msg":"hello from app1","ts":1782007071548}
```

## 3. Postgres 16 Alpine với named volume — test data persist

**Bước 1: Tạo volume và chạy postgres**
```bash
docker volume create pgdata

docker run -d --name postgres-demo \
  -e POSTGRES_PASSWORD=secret123 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine
```

**Bước 2: Tạo database test để có dữ liệu**
```bash
docker exec postgres-demo psql -U postgres -c "CREATE DATABASE testdb;"
```
Kết quả: `CREATE DATABASE`

```bash
docker exec postgres-demo psql -U postgres -c "\l"
```
Kết quả — thấy 4 database trong đó có `testdb`:
```
   Name    |  Owner   | Encoding | ...
-----------+----------+----------+-----
 postgres  | postgres | UTF8     |
 template0 | postgres | UTF8     |
 template1 | postgres | UTF8     |
 testdb    | postgres | UTF8     |
```

**Bước 3: Dừng và xóa container, chạy lại với cùng volume**
```bash
docker stop postgres-demo
docker rm postgres-demo

docker run -d --name postgres-demo \
  -e POSTGRES_PASSWORD=secret123 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:16-alpine
```

**Bước 4: Kiểm tra database còn không**
```bash
docker exec postgres-demo psql -U postgres -c "SELECT datname FROM pg_database WHERE datname='testdb';"
```
Kết quả:
```
 datname
---------
 testdb
(1 row)
```

## 4. Bind-mount với nginx — sửa file trên host, reload thấy thay đổi

**Bước 1: Tạo thư mục + file HTML trên host**
```bash
mkdir -p site
echo '<h1>Hello Docker Volume!</h1>' > site/index.html
```

**Bước 2: Chạy nginx với bind-mount**
```bash
docker run -d --name nginx-demo -p 9090:80 \
  -v $PWD/site:/usr/share/nginx/html \
  nginx:1.27-alpine
```

**Bước 3: Curl lần đầu**
```bash
curl -s http://localhost:9090
```
Kết quả:
```html
<h1>Hello Docker Volume!</h1>
```

**Bước 4: Sửa file trên host**
```bash
echo '<h1>Updated from host! No restart needed!</h1>' > site/index.html
```

**Bước 5: Curl lại**
```bash
curl -s http://localhost:9090
```
Kết quả:
```html
<h1>Updated from host! No restart needed!</h1>
```
