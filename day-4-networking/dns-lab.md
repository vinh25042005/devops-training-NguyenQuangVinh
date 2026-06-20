## 1. Giải thích output của `dig +trace google.com`


```bash
$ dig google.com

;; ANSWER SECTION:
google.com.             68      IN      A       74.125.68.139
google.com.             68      IN      A       74.125.68.101
google.com.             68      IN      A       74.125.68.138
google.com.             68      IN      A       74.125.68.113
google.com.             68      IN      A       74.125.68.102
google.com.             68      IN      A       74.125.68.100

;; SERVER: 10.255.255.254#53(10.255.255.254)
```

```bash
$ dig +trace google.com

;; communications error to 10.255.255.254#53: timed out
;; no servers could be reached
```

### Giải thích:

**`dig google.com` (không +trace):**
- Gửi query đến DNS resolver `10.255.255.254` (modem/router của nhà mạng).
- Resolver tự trả kết quả: google.com có 6 IP (74.125.68.x) 
- TTL = 68s — thời gian cache kết quả này.

**`dig +trace google.com` (bị timeout):**
- `+trace` bỏ qua DNS resolver, bắt dig tự đi hỏi trực tiếp root servers
- Ra ngoài Internet qua port 53 (UDP) để hỏi root → TLD → authoritative.
- Gói tin bị chặn (firewall/router chặn outbound DNS) vì dùng UDP 53 đi ra ngoài 

### Cách khắc phục — dùng `dig` với +trace qua public DNS:

```bash
# Dùng Google DNS (8.8.8.8) làm resolver cho +trace
dig +trace @8.8.8.8 google.com
```