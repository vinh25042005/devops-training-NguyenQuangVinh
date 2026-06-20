# TLS Lab

## 1. Phân tích output `curl -v https://example.com`

```bash
curl -v https://example.com
```

### Output:

```
* Host example.com:443 was resolved.
* IPv6: 2606:4700:10::ac42:93f3, 2606:4700:10::6814:179a
* IPv4: 172.66.147.243, 104.20.23.154           <--- (1) DNS resolution
*   Trying 172.66.147.243:443...
* Connected to example.com (172.66.147.243) port 443  <--- (2) TCP connect
* ALPN: curl offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.3 (IN), TLS handshake, Encrypted Extensions (8):
* TLSv1.3 (IN), TLS handshake, Certificate (11):
* TLSv1.3 (IN), TLS handshake, CERT verify (15):
* TLSv1.3 (IN), TLS handshake, Finished (20):
* TLSv1.3 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.3 (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / TLS_AES_256_GCM_SHA384 / X25519 / id-ecPublicKey  <--- (3) TLS handshake
* ALPN: server accepted h2
* Server certificate:
*  subject: CN=example.com
*  start date: May 31 21:39:12 2026 GMT
*  expire date: Aug 29 21:41:26 2026 GMT
*  subjectAltName: host "example.com" matched cert's "example.com"
*  issuer: C=US; O=SSL Corporation; CN=Cloudflare TLS Issuing ECC CA 3
*  SSL certificate verify ok.
* using HTTP/2
> GET / HTTP/2                                      <--- (4) HTTP request
> Host: example.com
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/2 200                                        <--- (5) HTTP response
< date: Sat, 20 Jun 2026 02:52:50 GMT
< content-type: text/html
< server: cloudflare
< last-modified: Fri, 19 Jun 2026 18:46:03 GMT
```

## 2. Xem cert chain với `openssl s_client`

```bash
openssl s_client -connect example.com:443 -showcerts
```

### Output:

```
Certificate chain
 0 s:CN = example.com
   i:C = US, O = SSL Corporation, CN = Cloudflare TLS Issuing ECC CA 3
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: ecdsa-with-SHA256
   v:NotBefore: May 31 21:39:12 2026 GMT; NotAfter: Aug 29 21:41:26 2026 GMT

 1 s:C = US, O = SSL Corporation, CN = Cloudflare TLS Issuing ECC CA 3
   i:C = US, O = SSL Corporation, CN = SSL.com TLS Transit ECC CA R2
   a:PKEY: id-ecPublicKey, 256 (bit); sigalg: ecdsa-with-SHA384
   v:NotBefore: May 29 19:49:45 2025 GMT; NotAfter: May 27 19:49:44 2035 GMT

 2 s:C = US, O = SSL Corporation, CN = SSL.com TLS Transit ECC CA R2
   i:C = US, O = SSL Corporation, CN = SSL.com TLS ECC Root CA 2022
   a:PKEY: id-ecPublicKey, 384 (bit); sigalg: ecdsa-with-SHA384
   v:NotBefore: Oct 21 17:02:23 2022 GMT; NotAfter: Oct 17 17:02:22 2037 GMT

 3 s:C = US, O = SSL Corporation, CN = SSL.com TLS ECC Root CA 2022
   i:C = GB, ST = Greater Manchester, L = Salford, O = Comodo CA Limited, CN = AAA Certificate Services
   a:PKEY: id-ecPublicKey, 384 (bit); sigalg: RSA-SHA256
   v:NotBefore: Aug  1 00:00:00 2025 GMT; NotAfter: Dec 31 23:59:59 2028 GMT
```

### Giải thích cert chain:

```
AAA Certificate Services (Comodo) — Root CA 
    └── SSL.com TLS ECC Root CA 2022 
         └── SSL.com TLS Transit ECC CA R2 
              └── Cloudflare TLS Issuing ECC CA 3 
                   └── example.com (Leaf) 
```

---

## 3. TLS 1.3 Handshake 
```
TLS 1.3 (1-RTT):
Client                                   Server
  │                                        │
  │──── ClientHello + KeyShare ---------->│
  │<──── ServerHello + KeyShare + Cert + Finished ──│  ← 1 RTT
  │──── Finished ────────────────────────>│
  │════ Data transfer (encrypted) ════════│
```

## 4. SNI, ALPN, OCSP, SAN là gì?

### SNI — Server Name Indication

- 1 server (1 IP) có thể host nhiều domain. SNI cho phép client gửi kèm tên domain trong ClientHello để server biết gửi đúng certificate.
- Trong output curl: nằm trong dòng `TLSv1.3 (OUT), TLS handshake, Client hello (1)` — không hiện trực tiếp tên domain nhưng thực chất nó được gửi ở bước đó.

### ALPN — Application-Layer Protocol Negotiation

- Client và server cần thoả thuận dùng HTTP/1.1 hay HTTP/2. ALPN giúp làm việc này ngay trong TLS handshake, không cần thêm kết nối nào.
- Trong output curl:
  ```
  * ALPN: curl offers h2,http/1.1   → client đề xuất
  * ALPN: server accepted h2        → server chọn HTTP/2
  ```
- openssl s_client mặc định không bật ALPN nên hay hiện `No ALPN negotiated`.

### OCSP — Online Certificate Status Protocol

- Certificate có thể bị thu hồi trước hạn (lộ key, hết dùng...). OCSP cho client hỏi CA để kiểm tra cert còn hợp lệ không, thay vì tải cả danh sách thu hồi (CRL) về.
- **OCSP Stapling:** Server chủ động lấy OCSP response từ CA gửi kèm trong handshake, client khỏi phải tự đi hỏi.
- Trong output curl: dòng `SSL certificate verify ok` nghĩa là OCSP check pass.

### SAN — Subject Alternative Name

- 1 certificate có thể dùng cho nhiều domain. SAN là trường liệt kê tất cả domain mà cert đó hợp lệ.
- SAN đã thay thế CN (Common Name) cũ thành tiêu chuẩn chính.
- Trong output curl:
  ```
  * subjectAltName: host "example.com" matched cert's "example.com"
  ```
  Domain mình gọi nằm trong SAN → cert hợp lệ.