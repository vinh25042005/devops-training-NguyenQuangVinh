# Part A
## 1. Phân biệt log vs metric vs trace (ví dụ cụ thể).
### Log: lưu 1 sự kiện cụ thể, ở mốc thời gian cụ thể
```json
Ví dụ 
2026-06-26 10:23:45.123 ERROR : msg gì đó
```
### Metric: Đo thông số hệ thống như %cpu, ram số request, ...
```json
top - 10:23:45 up 3 days,  2:15,  1 user,  load average: 0.45, 0.30, 0.25
%Cpu(s): 12.5 us,  3.2 sy,  0.0 ni, 83.7 id,  0.3 wa,  0.0 hi,  0.3 si,  0.0 st
```
### trace : Request nào đó đi qua những đâu
- Ví dụ gọi `GET <gì đó>` => API gateway => service => database 


## 2. Pull vs Push base

### Pull base:
- server giám sát chủ động gọi API đến ứng dụng để pull dữ liệu về
- Ưu điểm: 
  - Kiểm soát tốt do tần suất là tự mình quy định
  - Nếu gọi đến ứng dụng mà không phản hồi thì biết luôn là đã chết
- Nhược điểm:
  - Server phải có kết nối thông suốt vào ứng dụng
  - Khó bắt các job chạy thời gian ngắn

### Push base:
- Ứng dụng thu thập và push dữ liệu đến server giám sát
- Ưu điểm: 
  - Cứ khi nào ứng dụng có sự kiện là đều được lưu và đẩy về server giám sát
  - Chỉ cần ứng dụng có quyền gửi dữ liệu ra ngoài là được, không cần cấu hình để reach được vào như pull base
- Nhược điểm:
  - Nếu ứng dụng quá nhiều request thì khiến server giám sát cũng có thể bị sập
  - Khó phân biệt là ứng dụng chết hay là đang không có job thôi
  - Nằm trong ứng dụng nên cần chi phí thêm cho phần cứng để thực hiện push về server

## 3. SLI/SLO/SLA
- SLI: Dữ liệu, chỉ số đo lường thực tế, ví dụ tỷ lệ request thành công là 9000/10000 => SLI=90%
- SLO: Là mục tiêu đề ra cho SLI, ví dụ cho phép 10000 request thì được lỗi 100
- SLA: Thoả  thuận chính thức với khách hàng, thường sẽ đặt dễ đạt được hơn SLO để không vi phạm


## 4. Cardinality nổ
- Cardinality = số lượng tổ hợp unique label values của một metric.
- Cardinality nổ = Khi số tổ hợp này quá lớn
```json
Ví dụ: 
http_requests{method="GET", endpoint="/api", status="123", user_id="12345"}
```
Các metric như method, endpoint, status .... thường có ít giá trị => số tổ hợp ít, nên max của số dòng tăng thêm ít 
Nhưng user_id có thể có rất nhiều => mỗi user request lại thêm 1 dòng log mới => bùng nổ

- Hậu quả: 
 - Tràn ram => chết server monitor
 - Tốn tiền cho hệ thống cloud
 - Querry bị timeout, ko đưa được dữ liệu lên dashboard