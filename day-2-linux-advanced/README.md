
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
```bash
#Cài nginx
sudo apt update
sudo apt install nginx -y
```
```bash
# Kiểm tra đã chạy chưa
systemctl status nginx
# → Active: active (running)
# Test thử
curl http://localhost
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