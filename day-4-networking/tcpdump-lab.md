# Day 4 — TCPDump Lab

## 1. Các lệnh đã chạy

```bash
# Terminal 1 — capture
sudo tcpdump -i any -nn -s 0 -w trace.pcap host example.com

# Terminal 2 — curl HTTP (không HTTPS) để thấy payload
curl http://example.com

# Ctrl+C ở terminal 1, sau đó đọc file
tcpdump -r trace.pcap -nn      # danh sách packet
tcpdump -r trace.pcap -A       # payload ASCII
```

## 2. Thứ tự các packet

Kết quả từ file `trace.pcap` (curl http://example.com → Cloudflare CDN):

1. **SYN** — `192.168.150.47:42636 → 172.66.147.243:80 [S]` — Client gửi yêu cầu kết nối TCP
2. **SYN-ACK** — `172.66.147.243:80 → 192.168.150.47:42636 [S.]` — Server đồng ý
3. **ACK** — `192.168.150.47:42636 → 172.66.147.243:80 [.]` — Bắt tay xong (ESTABLISHED)
4. **HTTP GET** — `[P.], seq 1:75, length 74` — Gửi request HTTP — **thấy payload**
5. **ACK** — `172.66.147.243:80 → 192.168.150.47:42636 [.]` — Server xác nhận
6. **HTTP 200 OK** — `[P.], seq 1:870, length 869` — Server trả HTML — **thấy payload**
7. **HTTP chunked** — `[P.], seq 870:875, length 5` — Kết thúc chunked transfer
8. **ACK** — `192.168.150.47:42636 → 172.66.147.243:80 [.]` — Client xác nhận
9. **ACK** — `192.168.150.47:42636 → 172.66.147.243:80 [.]` — Client xác nhận tiếp
10. **FIN** — `[F.], seq 75, ack 875` — Client bắt đầu đóng kết nối
11. **FIN-ACK** — `[F.], seq 875, ack 76` — Server đóng
12. **ACK** — `[.], ack 876` — Kết nối đóng hoàn toàn

## 3. Bắt được request đầy đủ chưa?

**Có — bắt được đầy đủ.** Vì dùng HTTP (port 80) không mã hoá.

Request 
```
GET / HTTP/1.1
Host: example.com
User-Agent: curl/8.5.0
Accept: */*
```

Response :
```
HTTP/1.1 200 OK
Date: Sat, 20 Jun 2026 08:12:15 GMT
Content-Type: text/html
Server: cloudflare
cf-cache-status: HIT

<!doctype html><html lang="en"><head>
<title>Example Domain</title>
...
```

## 4. Tại sao HTTPS không bắt được payload?

Nếu dùng `https://example.com` (port 443), tcpdump chỉ thấy:

```
1. [SYN]              → TCP connect
2. [SYN, ACK]
3. [ACK]
4. [Client Hello]     → TLS handshake (không thấy nội dung)
5. [Server Hello]     → TLS handshake
6. ...TLS tiếp...
7. [Application Data] → Đã mã hoá, không đọc được
8. [Application Data] → Không đọc được gì
```

**Lý do:**
- HTTPS = HTTP + TLS. TLS mã hoá toàn bộ HTTP request/response trước khi gửi.
- Sau TLS handshake, client và server có chung session key, mọi dữ liệu đều được mã hoá.
- Tcpdump chỉ thấy `Application Data` — không đọc được nội dung nếu không có private key server.

