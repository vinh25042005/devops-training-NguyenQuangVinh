## Task: `Day 9 - AWS Essentials`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 4`
- **Branch**: `phase-1/week-2/day-4-aws-basics`
- **Submitted at**: `2026-06-26 15:14` (timezone +07)
- **Time spent**: `4h`

## 1. Mục tiêu

- Hiểu IAM: user, group, role, policy, trust policy, identity policy, resource policy.
- Thực hành S3: static website hosting, bucket policy, presigned URL.
- Nắm kiến trúc VPC: public/private subnet, IGW, NAT GW, ALB, route table.

## 2. Kết quả

### Part B — Lab IAM
- Tạo group `s3-readonly` + managed policy `AmazonS3ReadOnlyAccess`.
- Test: `s3 ls` thành công, `s3 cp` Access Denied.
- Disable access key sau khi xong.
- Output: `iam-lab/transcript.log`.

### Part C — S3 Static Site
- Tạo bucket `vinh-static-1275182` (block public access OFF).
- Truy cập website endpoint thành công.

### Part D — Presigned URL
- Tạo bucket `private-presigned-13572` (block public access ON).
- Test: tải được file trong 5 phút, hết hạn thì expired.


## 4. Khó khăn & cách giải quyết
- CloudFront tạo distribution bị chặn do account chưa verify
- Presigned URL báo `NoSuchKey` => Kiểm tra `aws s3 ls`, upload lại file đúng tên 



## 6. Self-check
- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.