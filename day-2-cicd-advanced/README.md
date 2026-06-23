## Task: `Day 7 (W2-D2) — CI/CD Advanced`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 2 / Day 2`
- **Branch**: `day7-cicd-advanced`
- **Repo**: [vinh25042005/demo-app](https://github.com/vinh25042005/demo-app/tree/day7-cicd-advanced)
- **Submitted at**: `2026-06-23` (UTC+7)
- **Time spent**: `6h`

## 1. Mục tiêu
- Matrix build (multi version): chạy test song song trên nhiều tổ hợp Node + OS.
- Reusable workflow / template: tách logic build ra file riêng, gọi lại từ CI pipeline.
- Environment + manual approval: thiết lập staging & production environment, bật required reviewer cho production.
- Pipeline cho cả MR (merge request) và tag (release).

## 2. Cách chạy

### 2.1. Clone & setup
```bash
git clone https://github.com/vinh25042005/demo-app.git
cd demo-app
git checkout day7-cicd-advanced
```

### 2.2. Tạo environment trên GitHub
- Vào Repo > Settings > Environments.
- Tạo `staging` (không cần approval).
- Tạo `production`, bật **Required reviewers** = chính bạn.

### 2.3. Trigger pipeline
```bash
# Push lên main để trigger CI + staging deploy
git push origin main

# Tạo tag để trigger release + production deploy
git tag v1.0.0
git push origin v1.0.0
```

## 3. Kết quả

### Part A - Matrix Build
Job `test` chạy song song trên ma trận `node [18, 20, 22]` x `os [ubuntu-22.04, ubuntu-24.04]`. Dùng `exclude` loại bỏ combo `{ node: 18, os: ubuntu-24.04 }` -> còn 5 combo.

```yaml
strategy:
  fail-fast: false
  matrix:
    node: [18, 20, 22]
    os:   [ubuntu-22.04, ubuntu-24.04]
    exclude:
      - { node: 18, os: ubuntu-24.04 }
```

Screenshot: `./screenshots/matrix-runs.png`

### Part B - Reusable Workflow
File `.github/workflows/reusable-build.yml` nhận input `image_name` + `image_tag`. `ci.yml` gọi qua `uses: ./.github/workflows/reusable-build.yml`.

### Part C - Environment + Approval
- `deploy-staging`: chạy ngay khi merge vào `main`, không cần approval.
- `deploy-production`: chạy khi tag `v*.*.*`, **chờ approval** từ required reviewer.

Screenshot: `./screenshots/production-approval.png`

### Part D - Tag-based Release
Trigger: `on: push: tags: ['v*.*.*']`. Tự sinh release note bằng `softprops/action-gh-release`. Image tag: `ghcr.io/vinh25042005/demo-app:${{ github.ref_name }}`.

Release đã tạo: [v4.0.0](https://github.com/vinh25042005/demo-app/releases/tag/v4.0.0)
Package: [ghcr.io/vinh25042005/demo-app](https://github.com/users/vinh25042005/packages/container/package/demo-app)

Screenshot: `./screenshots/release-page.png`

### Part E - Failure Scenarios
Trả lời trong file `notes.md`:

## 4. Khó khăn & cách giải quyết
- Chưa rõ về phần tag, release phải đọc thêm để hiểu
- Trivy scan ra nhiều lỗi của npm package nên cần skip để pipeline xanh

## 5. Reference
- [Reusable workflows (GitHub)](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
- [Environments & secrets](https://docs.github.com/en/actions/deployment/targeting-different-environments)

## 6. Self-check
- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.