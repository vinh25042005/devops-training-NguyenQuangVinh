
## Part A — Networking primer

### Câu 1: So sánh OSI 7 lớp với TCP/IP 4 lớp

**Mô hình OSI  — 7 tầng:**

- **Tầng 7 — Application:** Giao tiếp ứng dụng — HTTP, FTP, SMTP, DNS
- **Tầng 6 — Presentation:** Mã hoá, nén, định dạng dữ liệu — SSL/TLS, JPEG, ASCII
- **Tầng 5 — Session:** Quản lý phiên kết nối — NetBIOS, RPC, SOCKS
- **Tầng 4 — Transport:** Đảm bảo truyền tin end-to-end, kiểm soát lỗi — TCP, UDP
- **Tầng 3 — Network:** Định tuyến, đánh địa chỉ IP — IP, ICMP, ARP, OSPF
- **Tầng 2 — Data Link:** Truyền frame giữa 2 node kề nhau (MAC) — Ethernet, Wi-Fi (802.11), PPP
- **Tầng 1 — Physical:** Truyền bit vật lý qua cáp/sóng — Cáp đồng, cáp quang, sóng RF

**Mô hình TCP/IP — 4 tầng:**

- **Tầng 4 — Application (tương ứng OSI 5+6+7):** — HTTP, DNS, TLS, SSH, FTP
- **Tầng 3 — Transport (tương ứng OSI 4):** Truyền tin end-to-end, kiểm soát luồng — TCP, UDP
- **Tầng 2 — Internet (tương ứng OSI 3):** Định tuyến, địa chỉ IP — IP (IPv4/IPv6), ICMP
- **Tầng 1 — Network Access (tương ứng OSI 1+2):** Vật lý + data link — Ethernet, ARP, Wi-Fi



### Câu 2: TCP 3-way handshake — vẽ ASCII diagram + giải thích cờ SYN/ACK/FIN/RST

**ASCII Diagram — TCP 3-way handshake:**

```
CLIENT (port A)                     SERVER (port 80)
     |                                    |
     |  === 1. Three-way handshake ===    |
     |                                    |
     |     SYN (seq=1000)                 |
     |----------------------------------->|  CLOSED → LISTEN → SYN-RCVD
     |                                    |
     |     SYN-ACK (seq=2000, ack=1001)   |
     |<-----------------------------------|
     |                                    |
     |     ACK (seq=1001, ack=2001)       |
     |----------------------------------->|  → ESTABLISHED
     |                                    |
     |  === 2. Data transfer ===          |
     |                                    |
     |     [HTTP GET / ...]               |
     |----------------------------------->|
     |     [HTTP 200 OK ...]              |
     |<-----------------------------------|
     |                                    |
     |  === 3. Connection teardown ===    |
     |                                    |
     |     FIN (seq=5000)                 |
     |----------------------------------->|  → FIN-WAIT-1 / CLOSE-WAIT
     |                                    |
     |     ACK (ack=5001)                 |
     |<-----------------------------------|  → FIN-WAIT-2
     |                                    |
     |     FIN (seq=7000)                 |
     |<-----------------------------------|  → TIME-WAIT / LAST-ACK
     |                                    |
     |     ACK (ack=7001)                 |
     |----------------------------------->|  → CLOSED
     |                                    |
```

**Giải thích các flags trong TCP header:**

- **SYN (Synchronize):** Dùng để bắt đầu kết nối. Client gửi SYN kèm sequence number (seq) ban đầu để đồng bộ số thứ tự.
- **SYN-ACK (Synchronize-Acknowledge):** Server phản hồi: xác nhận đã nhận SYN của client (ACK = client_seq + 1) và gửi SYN của server (seq riêng).
- **ACK (Acknowledge):** Xác nhận đã nhận gói tin. Luôn có trong hầu hết các gói sau handshake. Giá trị ACK = seq nhận được + 1 (hoặc + payload length).
- **FIN (Finish):** Báo hiệu bên gửi không còn dữ liệu để gửi nữa, muốn đóng kết nối. Cần 2 FIN (mỗi bên 1 cái) và 2 ACK để đóng hoàn toàn (4-way handshake).
- **RST (Reset):** Hủy kết nối đột ngột. Dùng khi: port không có service, kết nối lỗi, hoặc từ chối kết nối. Không cần ACK.
- **PSH (Push):** Yêu cầu gửi dữ liệu ngay lên ứng dụng, không đợi buffer đầy.
- **URG (Urgent):** Dữ liệu khẩn cấp (ít dùng).


### Câu 3: Khi nào chọn UDP thay vì TCP? Ví dụ thực tế

**So sánh TCP vs UDP:**

- **Kết nối:** TCP connection-oriented (có handshake) — UDP connectionless (gửi thẳng)
- **Độ tin cậy:** TCP đảm bảo kiểm tra lỗi / UDP không đảm bảo — gửi xong không quan tâm
- **Thứ tự gói:** TCP đảm bảo đúng thứ tự — UDP không đảm bảo (có thể đến sai thứ tự)
- **Tốc độ:** TCP chậm hơn  — UDP nhanh hơn
- **Broadcast/Multicast:** TCP không hỗ trợ — UDP hỗ trợ
- **Độ trễ:** TCP cao hơn — UDP thấp hơn

**Khi nào chọn UDP:**

1. **Ứng dụng real-time, ưu tiên tốc độ > độ tin cậy**
   - Mất vài gói tin không sao, nhưng trễ thì không chấp nhận được. Ví dụ như chơi game, livestream...
2. **Payload nhỏ, chỉ cần 1 request → 1 response**
   - Không cần thiết lập kết nối phức tạp.
3. **Cần broadcast/multicast** — TCP không hỗ trợ.
4. **Tài nguyên hạn chế** — UDP nhẹ hơn, không cần giữ trạng thái kết nối.


**Khi nào bắt buộc dùng TCP?**
- **HTTP/HTTPS** — cần dữ liệu chính xác, không mất byte nào.
- **SSH, FTP, SMTP** — yêu cầu độ tin cậy tuyệt đối.
- **Truyền file lớn** — cần kiểm soát luồng, tránh nghẽn mạng.
- **Cơ sở dữ liệu** (MySQL, PostgreSQL) — đảm bảo toàn vẹn dữ liệu.

---

### Câu 4: CIDR `/24`, `/16`, `/22` — số IP tương ứng?

**Công thức:** Số IP = 2^(32 - prefix_length)

- **/24** (255.255.255.0) — 2⁸ = **256 IP**, dùng được 254 host. Network: .0, Broadcast: .255. Thường dùng cho 1 lớp học / văn phòng nhỏ.
- **/16** (255.255.0.0) — 2¹⁶ = **65,536 IP**, dùng được 65,534 host. Network: x.y.0.0, Broadcast: x.y.255.255. Dùng cho công ty lớn / trường đại học.
- **/22** (255.255.252.0) — 2¹⁰ = **1,024 IP**, dùng được 1,022 host. 4 × /24. Dùng cho công ty vừa.

### Câu 5: Tại sao có private IP range (10/8, 172.16/12, 192.168/16)?
**Lý do tồn tại private IP:**

1. **IPv4 ko đủ:** IPv4 chỉ có ~4.3 tỷ địa chỉ, không đủ cho tất cả thiết bị trên thế giới. Private IP cho phép tái sử dụng cùng dải IP ở nhiều mạng nội bộ khác nhau.

2. **Tiết kiệm địa chỉ công cộng:** Chỉ cần 1 IP public cho cả công ty, các thiết bị bên trong dùng private IP.

3. **Bảo mật:** Private IP không thể truy cập trực tiếp từ Internet → Muốn vào được phải qua NAT/firewall.

4. **Tổ chức nội bộ:** Dễ dàng quản lý, phân chia subnet cho các phòng ban.

### Câu 6: NAT là gì? Phân biệt SNAT vs DNAT

**NAT (Network Address Translation)** — kỹ thuật ánh xạ địa chỉ IP (và port) giữa mạng private và public. Cho phép nhiều thiết bị dùng chung 1 IP public để ra Internet.

**Phân biệt SNAT vs DNAT:**

**SNAT (Source NAT):**
- **Đổi:** địa chỉ **nguồn** (source IP)
- **Mục đích:** Cho máy trong mạng private ra Internet
- **Hướng:** từ trong ra
- **Ví dụ:** Router đổi 192.168.1.10 → 203.0.113.1


**DNAT (Destination NAT):**
- **Đổi:** địa chỉ **đích** (destination IP)
- **Mục đích:** Cho máy ngoài Internet vào mạng private
- **Hướng:** từ ngoài vào
- **Ví dụ:** Router nhận gửi đến 203.0.113.1:80 → chuyển cho 192.168.1.100:80


### Câu 7: Sự khác nhau giữa Forward Proxy và Reverse Proxy

**Forward Proxy (proxy xuôi):**

```
[Client] ---> [Forward Proxy] ---> [Internet] ---> [Server]
```

- Đại diện cho client.
- Client cấu hình để gửi request qua proxy.
- Server không biết client thật là ai, chỉ thấy IP của proxy.
- **Ưu điểm:**
  - **Ẩn danh client** — Nhân viên dùng proxy công ty, server thấy IP công ty
  - **Vượt tường lửa** — Dùng proxy ở Mỹ để xem Netflix Mỹ
  - **Kiểm soát truy cập** — Công ty chặn Facebook, YouTube, LOL
  - **Lọc nội dung** — Trường học chặn site không phù hợp

**Reverse Proxy (proxy ngược):**
```
[Client] ---> [Internet] ---> [Reverse Proxy] ---> [Backend Servers]
```
- Đại diện cho server
- Client tưởng đang nói chuyện trực tiếp với server, thực ra là với proxy.
- Server thật được giấu kín.
- **Ưu điểm:**
  - **Load balancing** — nginx phân phối request đến nhiều app server
  - **SSL termination** — Proxy xử lý HTTPS, backend nhận HTTP plain
  - **Bảo mật** — Giấu backend, chặn DDoS, rate limiting
  - **Serve nhiều site trên 1 IP** — Virtual hosting (1 IP, nhiều domain)