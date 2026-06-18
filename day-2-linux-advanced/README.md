
## Task: `Day 1 — Linux Fundamentals`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 1 / Day 2`
- **Branch**: `phase-1/week-1/day-2-linux-advanced`
- **Submitted at**: `<2026-06-17 17:16>` (timezone +07)
- **Time spent**: `<4h>`

## 1. Mục tiêu

## 2. Cách chạy

### Part A - Process & Signal
```bash
# Cấp quyền thực thi
chmod +x lab-process.sh
```
```bash
#Chạy lab-process.sh để xem demo về process và signal
./lab-process.sh
```

### Part B - systemd service
File `webapp.service`: chạy Python HTTP server trên port 8080

>  **Trước khi chạy:** Mở file `webapp.service`, sửa dòng `User=vinh2` thành username theo 
```bash
whoami
```

```bash
# 1. Tạo thư mục và file HTML
sudo mkdir -p /opt/webapp
echo '<h1>Web app đã lên!</h1>' | sudo tee index.html

# 2. Copy service file vào systemd
sudo cp webapp.service /etc/systemd/system/

# 3. Load lại cấu hình
sudo systemctl daemon-reload

# 4. Enable + Start
sudo systemctl enable --now webapp

# 5. Verify
systemctl status webapp
curl http://localhost:8080
```

Test auto-restart  
```bash
# Lấy PID hiện tại
MAINPID=$(systemctl show -p MainPID webapp | cut -d= -f2)
echo "PID hiện tại: $MAINPID"

# Kill process
sudo kill -9 $MAINPID
sleep 4

# Kiểm tra service đã restart với PID mới
systemctl status webapp
curl http://localhost:8080
```
Nếu port 8080 đã bị dùng: sửa dòng ExecStart=... 8080 trong webapp.service thành port khác, rồi chạy:  
```bash
sudo cp webapp.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl restart webapp
curl http://localhost:<port mới>
```
Tắt web app
```bash
sudo systemctl stop webapp
sudo systemctl disable webapp
sudo rm webapp.service
sudo systemctl daemon-reload
```
## 3. Kết quả


## 4. Khó khăn & cách giải quyết


## 5. Reference
- Google
- AI deepseek

## 6. Self-check
- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.