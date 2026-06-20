## Task: `Networking Essentials`

- **Intern**: `Nguyen Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 1 / Day 4`
- **Branch**: `phase-1/week-1/day-4-networking`
- **Submitted at**: `2026-06-20 16:36` (timezone +07)
- **Time spent**: `<7h>`

## 1. Mục tiêu
- Hiểu OSI 7 lớp vs TCP/IP 4 lớp, TCP 3-way handshake, phân biệt TCP vs UDP
- DNS resolution với dig, phân biệt /etc/hosts vs resolv.conf vs systemd-resolved
- Phân tích HTTP/HTTPS với curlƯ -v, openssl s_client, vẽ TLS 1.3 handshake
- Bắt và phân tích packet với tcpdump, hiểu tại sao HTTPS không đọc được payload
- Thực hành port & socket với nc, ss

## 2. Cách chạy

### Part A — Networking primer (notes.md)
Chi tiết trong `notes.md`.

### Part B — DNS lab (dns-lab.md)
```bash
dig google.com
dig +trace @8.8.8.8 google.com
dig MX gmail.com
dig TXT google.com

# Cấu hình /etc/hosts
sudo sh -c 'echo "127.0.0.1   test123" >> /etc/hosts'
ping test123
sudo sed -i '/test123/d' /etc/hosts

# Xem cấu hình DNS
cat /etc/hosts
cat /etc/resolv.conf
resolvectl status
```

### Part C — TLS deep dive (tls-lab.md)
```bash
curl -v https://example.com
openssl s_client -connect example.com:443 -showcerts
```

### Part D — tcpdump capture (tcpdump-lab.md)
```bash
sudo tcpdump -i any -nn -s 0 -w trace.pcap host example.com
curl http://example.com
tcpdump -r trace.pcap -A
```

### Part E — Port & Socket
```bash
# Terminal A
nc -l 9000

# Terminal B 
ss -tlnp | grep 9000

# Terminal C 
nc 127.0.0.1 9000
hello
```

## 3. Kết quả
- Đã trả lời 7 câu Part A vào `notes.md`
- Đã chạy dig, phân tích +trace, cấu hình /etc/hosts và ghi vào `dns-lab.md`
- Đã chạy curl -v, openssl s_client, phân tích TLS handshake và ghi vào `tls-lab.md`
- Đã bắt gói tin HTTP bằng tcpdump, phân tích packet và ghi vào `tcpdump-lab.md`
- Đã chạy nc listener, kiểm tra port bằng ss, gửi dữ liệu qua TCP

## 4. Khó khăn & cách giải quyết
- `dig +trace google.com` báo timeout, không rõ lý do → hỏi AI, biết là firewall chặn outbound UDP 53 → dùng `dig +trace @8.8.8.8`
- chưa hiểu rõ cơ chế TLS handshake TLS 1.3 → tra RFC 8446, đọc output curl -v thực tế để so sánh
- `/etc/hosts` trên WSL tự sinh, sợ sửa xong bị mất → đọc comment trong file, thêm dòng thủ công vẫn giữ nguyên được
- chưa rõ OCSP với SAN là gì trong cert → tra google và xem output thực tế từ openssl s_client để hiểu

## 5. Reference
- RFC 1918 (Private IP Range), RFC 8446 (TLS 1.3)

## 6. Self-check
- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.