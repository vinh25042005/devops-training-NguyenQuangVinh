## Câu 1: State file là gì? Vì sao không được commit lên Git?

**State file** (`terraform.tfstate`) là file JSON chứa trạng thái của hạ tầng mà Terraform quản lý.

Nó lưu:
- ID của từng resource trên cloud (vd: EC2 instance ID, VPC ID)
- Các thuộc tính của resource (IP, DNS name, tags)
- Quan hệ giữa các resource 
- Metadata của Terraform (version, serial)

**Vì sao không được commit state lên Git?**
- **Chứa secrets:** State lưu cả password, API keys, private keys nếu resource có
- **Dễ conflict:** Nếu 2 người cùng apply, state thay đổi → merge Git rất khó vì file phức tạp


## Câu 2: So sánh `terraform plan` vs `terraform apply` vs `terraform refresh`

**`terraform plan`**
- Xem trước những thay đổi sẽ được thực hiện
- Không tạo/sửa/xoá gì thật — chỉ đọc
- So sánh: code (`.tf`) vs state (`.tfstate`) vs thực tế (cloud)

**`terraform apply`**
- Thực thi những thay đổi đã được plan
- Tạo resource mới, sửa resource cũ, xoá resource không còn trong code
- Sau khi chạy xong → cập nhật state

**`terraform refresh`**
- Cập nhật state với thực tế trên cloud
- Không thay đổi gì hạ tầng — chỉ đồng bộ state


## Câu 3: Tại sao nên dùng remote backend (S3 + DynamoDB lock)?

**local backend:**
- State lưu trên máy local → chỉ 1 người dùng được
- Nhiều người không thể làm việc chung

**Remote backend với S3 + DynamoDB giải quyết:**

**S3 lưu state:**
- State được lưu trên cloud, ai cũng truy cập được
- S3 có versioning → có thể rollback state cũ nếu hỏng

**DynamoDB khoá state:**
- DynamoDB table dùng để lock state khi có người đang apply
- Nếu chạy `terraform apply`, DynamoDB ghi lock → người khác chạy apply cùng lúc sẽ bị từ chối
- Tránh 2 người cùng modify state 

## Câu 4: So sánh module local vs registry

**Module local:**`
- Tự viết, tuỳ chỉnh thoải mái
- Chỉ dùng trong project hiện tại

**Module registry:**
- Do cộng đồng hoặc HashiCorp viết sẵn
- Ai cũng dùng được


**Khi nào dùng cái nào?**
- Cần kiểm soát hoàn toàn → local module
- Cần nhanh, đã có sẵn → registry module
- Nên kết hợp: registry module cho hạ tầng chuẩn, local module cho logic riêng


## Câu 5: `count` vs `for_each` — khi nào dùng cái nào?

**Giống nhau:** Cả hai đều tạo nhiều resource từ 1 block resource


- count là số nguyên
- Truy cập từng cái bằng `count.index` (0, 1, 2...)
- Kết quả là một list resource: `aws_subnet.public[0]`, `aws_subnet.public[1]`
- Khi xoá phần tử ở giữa list → các index bị đẩy lên → Terraform thay đổi sai resource


- for_each dùng map hoặc set
- Truy cập bằng `each.key` và `each.value`
- Kết quả là một map resource: `aws_subnet.this["a"]`, `aws_subnet.this["b"]`
- Khi xoá phần tử → không ảnh hưởng các phần tử khác

- **Dùng count khi:**
  - Các resource giống hệt nhau, chỉ khác số thứ tự

- **Dùng for_each khi:**
  - Các resource có thuộc tính khác nhau 

## Câu 6: Drift là gì? Cách phát hiện & xử lý?

Drift là **hạ tầng thực tế khác với state** 

**Cách phát hiện drift:**

1. **`terraform plan`** 
   - Nếu state khác thực tế → plan sẽ hiện `~` (update in-place) dù code không thay đổi
   - Ví dụ: `~ instance_type = "t3.micro" -> "t2.micro"` — dù code vẫn là `t3.micro`

2. **`terraform refresh`**
   - Cập nhật state với thực tế
   - Sau đó chạy `terraform plan` để so sánh code vs state xem có khác không

**Cách xử lý drift:**

- Chạy `terraform refresh` để state khớp thực tế
- Sửa code `.tf` cho khớp với state
- Hoặc dùng `terraform import` nếu resource được tạo ngoài Terraform

