
## Task: `Day 1 — Linux Fundamentals`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 1 / Day 2`
- **Branch**: `phase-1/week-1/day-2-linux-advanced`
- **Submitted at**: `<2026-06-18 15:35>` (timezone +07)
- **Time spent**: `<5h>`

## 1. Mục tiêu
- Học thêm về quản lý process, phân quyền trong linux
- Viết được systemd để daemonize service
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

### Part C: Permission lab
- Các bước thực hiện được ghi tại permissions-lab.md

### Part D: Monitoring script

```bash
# Cấp quyền thực thi
chmod +x monitor.sh
```
```bash
# Chạy
./monitor.sh
``` 

**Test WARNING (CPU > 80%):****
```bash
# Terminal 1: chạy monitor
./monitor.sh

# Terminal 2: tạo CPU load giả lập
yes > /dev/null &
yes > /dev/null &
yes > /dev/null &
yes > /dev/null &
```
```bash
# Kiểm tra log
cat ~/monitor.log
# Tắt load
killall yes
# Dừng monitor
Ctrl+C
```

### Part D: Monitoring script

File `monitor.sh` + `monitor.service`: theo dõi CPU%, MEM%, top 3 process mỗi 10s.  
CPU > 80% trong 3 sample liên tiếp → WARNING vào `~/monitor.log`.

```bash
# 1. Cài script
sudo mkdir -p /opt/monitor
sudo cp monitor.sh /opt/monitor/
sudo chmod +x /opt/monitor/monitor.sh

# 2. Cài service
sudo cp monitor.service /etc/systemd/system/
sudo systemctl daemon-reload

# 3. Enable + Start
sudo systemctl enable --now monitor

# 4. Verify
systemctl status monitor

# 5. Xem log output và warning
journalctl -u monitor -f
tail -f ~/monitor.log
```

**Tắt service**
```bash
sudo systemctl stop monitor
sudo systemctl disable monitor
sudo rm /etc/systemd/system/monitor.service
sudo systemctl daemon-reload
```

## 3. Kết quả
- Hoàn thành được các yêu cầu của bài
- các hình ảnh kết quả được lưu trong screenshots/

## 4. Khó khăn & cách giải quyết
- chưa biết cách chạy bằng service nên mất thời gian tra cứu và tìm hiểu cách lệnh
- ở part A mất thời gian để hiểu và so sánh sự khác nhau giữa các lệnh

## 5. Reference
- Google
- Hỏi các mô hình AI

## 6. Self-check
- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.