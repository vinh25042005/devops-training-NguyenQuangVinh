# 1. CI / CD / Continuous Deployment khác nhau thế nào?
- CI: Tự động build + test khi push code lên repo, giúp phát hiện lỗi sớm ngay khi code vừa push, đảm bảo code trên repo luôn xanh
- CD (Continuous Delivery): Sau khi đã qua được bước CI, tự build image, package, ..... để đảm bảo có thể deploy lên các môi trường, giảm thời gian đưa code lên production, sau khi đã test thì cần người deploy lên production thật.
- CDeploy: Gần tương tự CD nhưng tự động hoá, mọi code push lên repo đều được đưa thẳng lên production mà không cần duyệt thủ công, nhưng cần nhiều điều kiện sản phẩm sẽ trực tiếp đến tay khách hàng

# 2. DORA 4 key metrics
Là các chỉ số về hiệu suất delivery của 1 sản phẩm/ 1 team

## 4 Metrics:
- **Deployment frequency:** Tần suất deploy thành công lên production (số deploy/ngày, tuần, ...) => tần suất thường xuyên thì dễ review, test code hơn
- **Lead time for changes:** Thời gian từ khi push code đến khi deploy lên production => càng ngắn thì code càng được đưa lên production nhanh cho khách hàng
- **Change failure rate:** Tỷ lệ deploy gây ra bug, đo bằng % số deploy cần sửa 
- **Time to restore service:** Thời gian cần để khắc phục khi có bug => cần thấp nhất có thể

# 3. Pipeline as Code có ưu điểm gì so với cấu hình UI?
- Pipeline as Code thì có thể biết ai sửa cái gì lúc nào khi sửa pipeline thì mọi người trong team đều xem và review được
- Pipeline as Code tiện trong việc copy từ repo này sang repo khác
- Chỉ cần file pipeline đưa lên repo là tự chạy, không cần bấm nút gì
- Roll back về pipeline cũ dễ hơn, ở UI thì phải nhớ config cũ

# 4. Khi nào dùng runs-on: self-hosted vs ubuntu-latest?

## Dùng `ubuntu-latest` khi:
- Dự án đơn giản
- Chỉ cần các tool có sẵn mà Github cung cấp
- Không cần truy cập vào mạng nội bộ 

## Dùng `self-hosted` khi:
- Cần truy cập vào mạng nội bộ (VPN, DB riêng, ...)
- Cần phần mềm đặc thù mà Github không cung cấp sẵn
- Cần kiểm soát bảo mật, không muốn code doanh nghiệp chạy trên máy GitHub
