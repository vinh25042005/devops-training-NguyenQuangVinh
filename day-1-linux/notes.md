ls: đưa ra thông tin về folder
cd: đổi thu mực làm việc
pwd: in ra đường dẫn folder hiện tại
mkdir: tạo folder mới
rm: xoá file/folder
cp: sao chép file/folder
mv: di chuyển file/folder
touch: tạo mới một hoặc nhiều file trống, nếu touch vào file đã tồn tại thì chỉ cập nhật thời gian truy cập
cat: xem nội dung file
less: xem nội dung file(cuộn được)
head: xem 10 dòng đầu file
tail: xem 10 dòng cuối file
grep: tìm kiếm trong file hoặc trong output của lệnh khác
find: tìm file/folder
xargs: lấyđầu ra từ một lệnh thành arguments cho một lệnh khác
awk: đọc và xử lý dữ liệu để hiển thị theo 1 quy tắc nào đó
sort: sắp xếp các dòng trong file
uniq: lọc các dòng bị trùng
wc: đếm số dòng, số từ, số ký tự và số byte trong file văn bản
tee: đọc dữ liệu đầu vào, ghi nó đồng thời ra màn hình và lưu vào file
nice: thiết lập độ ưu tên của cpu cho 1 process 
ps: hiện tiến trình đang chạy
top: hiện tiến trình và tài nguyên hệ thống
htop: giống top nhưng có giao diện
kill: dừng tiến trình 
df: xem thông tin disk của toàn bộ hệ thống
du: xem dung lượng của các thư mục và file cụ thể trong hệ thống
free: xem thông tin về ram
uptime: xem thời gian hệ thống đã chạy
uname: xem thông tin hệ điều hành
who: xem người dùng đang đăng nhập
chmod: thay đổi quyền sử dụng 
chown: đối quyền sở hữu
tar: nén/giải nén file thành archive
zip: nén file/folder thành zip
unzip: giải nén file zip
ssh: kết nối đến máy chủ từ xa an toàn
scp: copy file/folder qua ssh
rsyn: đồng bộ file/folder
ln: tạo liên kết cứng tham chiếu đến file trên đĩa, xoá file gốc thì vẫn xem đc qua file được tạo ra
ln -s: tạo liên kết đến file khác, nên nếu xoá file gốc thì file được tạo ra cũng không xem được
env: xem tên biến map với môi trường
export: tạo/đánh dấu biến môi trường 
source: thực thi script thay đổi cấu hình
curl: truyền dữ liệu qua url
wget: tải file từ internet
which: xem vị trí file thực thi của command 
echo: in ra màn hình 