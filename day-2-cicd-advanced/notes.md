# Part E 

## 1. Khi pipeline thất bại ở step `push`, làm sao retry nhanh không build lại?

**Dùng `docker save` + artifact — build 1 lần, push riêng, retry push không cần build lại.**

```bash
# Job 1: Build + save + upload artifact
build-job:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - run: docker build -t ghcr.io/${{ github.repository_owner }}/demo-app:sha-${{ github.sha }} .
    - run: docker save -o /tmp/image.tar ghcr.io/${{ github.repository_owner }}/demo-app:sha-${{ github.sha }}
    - uses: actions/upload-artifact@v4
      with:
        name: docker-image
        path: /tmp/image.tar

# Job 2: Download artifact + push (chỉ retry job này nếu fail)
push-job:
  needs: build-job
  runs-on: ubuntu-latest
  steps:
    - uses: actions/download-artifact@v4
      with:
        name: docker-image
    - run: docker load -i image.tar
    - run: docker push ghcr.io/${{ github.repository_owner }}/demo-app:sha-${{ github.sha }}
```

→ Nếu `push` fail, retry `push-job` → chỉ load + push, không build lại.

## 2. Cách debug 1 job mà chỉ fail trên runner (không tái hiện local)?

Nguyên nhân: Runner khác môi trường local

**Giải pháp: Bật debug log (`ACTIONS_STEP_DEBUG`).**

**Cách làm:**

Vào GitHub repo → Settings → Secrets and variables → Actions → New repository secret:

- name: `ACTIONS_STEP_DEBUG` 
- secret: true

Sau đó chạy lại workflow → log in ra chi tiết từng step: command được chạy, output, biến môi trường, thời gian thực thi.
![debug_runner](./screenshots/debug_runner.png)

## 3. So sánh `needs` vs `if` vs `concurrency` group

**`needs`** — Kiểm soát thứ tự chạy job.
- Job chỉ chạy sau khi job trong `needs` thành công.
- Ví dụ: `build-and-push` cần `test` pass trước → `needs: test`

**`if`** — Kiểm soát có chạy job hay không.
- Job chạy nếu điều kiện đúng, không quan tâm `needs`.
- Ví dụ: Job `deploy-prod` chỉ chạy khi push tag → `if: startsWith(github.ref, 'refs/tags/v')`

**`concurrency`** — Giới hạn số workflow chạy cùng lúc.
- Nếu group đang chạy → cancel workflow cũ hoặc queue.
- Ví dụ: Cùng lúc chỉ 1 deploy lên production → `concurrency: group: production`

## 4. Tại sao nên dùng OIDC để auth AWS thay vì static access key?

**OIDC:**
- Token tự động hết hạn sau vài phút, không lưu lâu dài.
- Role AWS gắn với từng repo/branch cụ thể
- Không cần rotate key định kỳ.

**Static Access Key:** 
- Key tồn tại vĩnh viễn đến khi revoke — nếu leak là mất AWS.
- Key có quyền như nhau cho mọi workflow, khó kiểm soát.
- Phải rotate định kỳ, dễ quên.

