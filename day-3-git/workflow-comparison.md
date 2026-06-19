# Trunk-based
**Số live-long branch**: Chỉ có 1 nhánh chính tồn tại lâu dài, vẫn có nhánh phụ nhưng thời gian tồn tại ngắn và phải merge luôn  

**Phù hợp với scenaro:**
- Team thực hành CI/CD đẩy code lên liên tục
- Có hệ thống test tự động để merge không gây ra lỗi
- Các project đơn giản, có vài người tham gia code và giao tiếp với nhau nhiều để tránh conflic  

**Release cadence:** Tần suất release cao và release nhanh  

**Khó khăn khi áp dụng**: 
- Nếu là app khá lớn thì cần CI/CD mạnh vì code được gửi lên liên tục
- Nếu push code lỗi lên có thể làm sập cả hệ thống
- Code cần được review nhanh vì khi merge là thẳng lên main
- Vì cái gì cũng làm thẳng vào main nên nếu có lỗi cần phải biết nhanh commit nào gây ra lỗi để sửa ngay
- Nếu task làm việc lớn thì khó thực hiện vì thời gian tồn tại của branch phụ không được dài

# Gitflow
**Số long-lived branch**: Có **5 loại nhánh**, trong đó 2 nhánh chính:
- `main`
- `develop`

Và 3 loại nhánh phụ tồn tại ngắn hạn:
- `feature/*`: tách từ `develop`, merge về `develop`
- `release/*`: tách từ `develop`, merge vào `main` và `develop`
- `hotfix/*`: tách từ `main`, merge vào `main` và `develop`

**Phù hợp với scenario:**
- Dự án mà mỗi khi release cần có phiên bản cụ thể
- Nhiều người phát triển song song nhiều tính năng cùng lúc
- Sản phẩm cần giai đoạn test riêng trước khi lên production
- Cần maintain nhiều phiên bản production cùng lúc cho các khách hàng khác nhau


**Release cadence:** Tần suất release theo chu kỳ hoặc lịch có sẵn. Mỗi release được test trên `release/*` branch.

**Khó khăn khi áp dụng:**
- Quy trình phức tạp vì nhiều loại nhánh 
- Code phải merge nhiều gây chậm, khó CI/CD liên tục
- Feature branch sống lâu dễ gây conflict khi merge vào develop
- Release branch nếu để lâu sẽ bị lệch xa develop, merge ngược lại rất khó


# GitHub Flow
**Số long-lived branch**: Chỉ có 1 nhánh chính  `main`. Các nhánh phụ được tạo riêng cho từng thay đổi và sẽ bị xóa sau khi merge.
Nhánh phụ tạo ra khi cần thay đổi tính năng nào đó => tạo pull request => được comment, chỉnh sửa => merge pull request khi đc thông qua => xoá branch

**Phù hợp với scenario:**
- Dự án dùng GitHub làm nền tảng chính
- Quy trình đơn giản, chỉ cần tạo branch và tạo pull request
- Mỗi thay đổi là 1 nhánh riêng biệt, không gộp chung các thay đổi không liên quan
- Muốn deploy ngay sau khi merge vào `main`

**Release cadence:** Tần suất release cao — mỗi lần merge vào `main` là có thể deploy luôn.

**Khó khăn khi áp dụng:**
- Không có nhánh `develop` hay `release` riêng, nếu cần test trước khi chạy thì khó hơn `Git workflow`
- Không có hotfix, sửa lỗi làm y hệt feature: tách nhánh → PR → merge → xóa nhánh
- Nếu merge code lỗi vào `main` và không có test thì có thể lỗi luôn production
- Không phù hợp nếu cần duy trì nhiều phiên bản production song song 