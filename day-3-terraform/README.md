## Task: `Day 8 (W2-D3) — Terraform Basics`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 3`
- **Branch**: `phase-1/week-2/day-3-terraform`
- **Submitted at**: `2026-06-26 10:18` (timezone +07)
- **Time spent**: `6h`

## 1. Mục tiêu

- Hiểu IaC declarative với Terraform
- Nắm được: provider, resource, variable, output, state, data source
- Provision hạ tầng cơ bản trên AWS (VPC + EC2 + nginx)

## 2. Cách chạy

### Part B — Local-only (1-local)

```bash
cd 1-local
terraform init
terraform plan
terraform apply -auto-approve
# sửa length = 2 → 3 trong main.tf
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

### Part C — AWS (2-aws)

```bash
cd 2-aws
cp terraform.tfvars.example terraform.tfvars
# sửa my_ip = ip thật
terraform init
terraform plan
terraform apply -auto-approve
curl http://$(terraform output -raw public_ip)
terraform destroy -auto-approve
```

## 3. Kết quả

- VPC `10.20.0.0/16` + 2 public subnet (2 AZ) + IGW + Route Table + SG + EC2 t3.micro + Elastic IP + nginx "hello from ip-..."
- Remote backend: S3 bucket `tfstate-vinh-1782202788` + DynamoDB `tfstate-lock` + state migrated

## 4. Khó khăn & cách giải quyết

- **Quên `terraform init` sau khi thêm data source mới** → gặp lỗi `Inconsistent dependency lock file`, chạy `terraform init -upgrade` để tải provider `cloudinit`
- **Chưa tạo `outputs.tf`** → `terraform output` không ra gì, phải tạo file outputs.tf rồi apply lại
## 5. Self-check

- [x] Code chạy được trên máy sạch
- [x] README có hướng dẫn run lại
- [x] Không hard-code secret (dùng `terraform.tfvars` + `.gitignore`)
- [x] Commit message theo Conventional Commits
- [x] Đã review lại code 1 lượt