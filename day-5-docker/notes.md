# Day 5 — Docker Fundamentals: Part A (Image Internals)

## 1. Image gồm những lớp gì? Vì sao layer được cache?

- Mỗi lệnh trong Dockerfile (như `FROM`, `RUN`, `COPY`) tạo ra một **lớp (layer)** riêng biệt.
- Các layer này xếp chồng lên nhau, chỉ có thể đọc (read-only). Khi chạy container, Docker thêm một lớp mỏng có thể ghi (read-write) lên trên cùng — đó là container layer.
- Khi mình sửa file trong container, thực chất Docker dùng kỹ thuật **copy-on-write**: file cũ ở layer read-only được copy lên container layer rồi sửa ở đó. File gốc bên dưới không bị ảnh hưởng.
- Nhờ kiến trúc layer này, nhiều image có thể dùng chung layer. Ví dụ mình có 2 image cùng base `node:20-alpine` thì layer của `node:20-alpine` chỉ lưu 1 lần trên disk, tiết kiệm rất nhiều dung lượng.

**Vì sao layer được cache?**

- Khi build image, Docker chạy từng lệnh từ trên xuống. Trước khi chạy, nó kiểm tra xem lệnh đó đã từng chạy chưa và kết quả có còn hợp lệ không. Nếu có, Docker **dùng lại layer cũ** thay vì chạy lại 
- Cache giúp build nhanh hơn rất nhiều, nhất là khi đang phát triển và build đi build lại.
- Nếu mình sửa 1 file source code, thì lệnh `COPY` sẽ không cache được nữa, và tất cả lệnh bên dưới nó cũng phải chạy lại.
- Vì vậy người ta khuyên đặt lệnh ít thay đổi lên trên (như cài package), lệnh hay thay đổi xuống dưới 

## 2. Sự khác nhau giữa COPY và ADD

- Cả 2 đều dùng để đưa file từ máy host vào trong image.
- Nhưng **COPY** thì đơn giản — nó chỉ copy file/thư mục vào image. Không làm gì khác.
- **ADD** thì làm được nhiều hơn nhưng cũng nguy hiểm hơn:
  - ADD tự động giải nén file `.tar`, `.tar.gz` vào thư mục đích — đôi khi mình không muốn nó tự giải nén.
  - ADD có thể tải file từ URL trên mạng. Nhưng không nên dùng cái này vì file tải về không được dọn dẹp, làm image to hơn, khó cache. Thay vào đó nên dùng `RUN curl` hoặc `RUN wget`.
- Chỉ dùng ADD khi cần giải nén tar tự động, còn lại luôn dùng COPY. COPY rõ ràng, dễ hiểu, không gây bất ngờ.

---

## 3. CMD vs ENTRYPOINT — khi nào dùng cái nào?

- **CMD**: đặt lệnh mặc định khi chạy container. Có thể bị ghi đè dễ dàng bằng cách gõ thêm lệnh sau `docker run`.
  - Ví dụ: `docker run ubuntu sleep 10` — chữ `sleep 10` ghi đè CMD mặc định.
- **ENTRYPOINT**: đặt lệnh chính của container, khó bị ghi đè hơn. Muốn ghi đè phải dùng `--entrypoint`.
- Khi dùng chung cả 2: **ENTRYPOINT là lệnh chính, CMD là tham số mặc định cho lệnh đó**.

Ví dụ từ thực tế (nginx official image):
```
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
```
- Chạy `docker run nginx` → thực thi `nginx -g "daemon off;"` (CMD làm tham số cho ENTRYPOINT).
- Chạy `docker run nginx -t` → thực thi `nginx -t` (ghi đè CMD, nhưng ENTRYPOINT vẫn là nginx).
- Chạy `docker run --entrypoint sh nginx` → thực thi `sh` (ghi đè cả ENTRYPOINT).

**Khi nào dùng:**
- Nếu container là 1 app cố định, muốn người dùng chỉ thay đổi tham số → ENTRYPOINT + CMD.
- Nếu muốn container linh hoạt, có thể chạy nhiều lệnh khác nhau → chỉ dùng CMD.
- Nếu cần script khởi tạo (tạo config, check database...) trước khi chạy app chính → ENTRYPOINT là script setup, CMD là app.

---

## 4. Tại sao nên có .dockerignore?

  - **Build nhanh hơn**: Không gửi file lớn lên docker daemon
  - **Tránh lộ secret**: file `.env`, key, password không bị vô tình copy vào image.
  - **Image nhỏ hơn**: không chứa file rác như `.git`, `README`, log...

---

## 5. EXPOSE thực sự làm gì? Có tự mở port không?

- EXPOSE không tự động mở port hay publish port ra ngoài host.
- EXPOSE giống kiểu ghi chú là container đang chạy ở port nào thôi


## 6. Tại sao không nên chạy container as root?

  - Nếu app trong container bị hack, hacker có toàn quyền root bên trong container. 
  - Trên Linux, root trong container (UID 0) trùng với root trên host,  nếu kernel có lỗ hổng, hacker có thể leo ra ngoài host với quyền root thật.
  - Vì vậy nên để project nào thì user đó chạy, không nên dùng quyền root

---

## Thực hành: docker history

Pull nginx alpine và xem các layer:

```
docker pull nginx:1.27-alpine
docker history nginx:1.27-alpine
```

Kết quả hiện ra từng layer, cột `CREATED BY` cho biết layer đó được tạo bởi lệnh gì, cột `SIZE` cho biết layer đó chiếm bao nhiêu dung lượng. 
## Thực hành: dive 

```
# Cài dive
wget https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.deb
sudo dpkg -i dive_0.12.0_linux_amd64.deb

dive nginx:1.27-alpine
```

Đã thử 3 cách nhưng dive vẫn bị bug, tìm hiểu issue trên github https://github.com/wagoodman/dive/pull/511 thì lý do là docker engine mới có format layer khác với các dive kiểm tra kiểu cũ nên lỗi 

- Cách fix: dùng bản dive được build từ  joschi's fork
```
# Tải bản v0.13.1 từ fork joschi
wget https://github.com/joschi/dive/releases/download/v0.13.1/dive_0.13.1_linux_amd64.deb
sudo dpkg -i dive_0.13.1_linux_amd64.deb

dive nginx:1.27-alpine
```

