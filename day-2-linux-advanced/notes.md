# 1.So sánh các signal
- SIGTERM gửi tín hiệu terminate đến process, sau khi process nhận được thì nó sẽ dọn dẹp trước khi tắt, ví dụ như giải phóng bộ nhớ, đóng các file đang mở,.... nghĩa là process biết mình sắp bị kill để dọn dẹp trước khi bị kill
- SIGKILL cũng dùng để đóng process nhưng không phải process tự đóng nó mà do kernel xử lý, process không biết mình sẽ bị đóng, nên các file tạm thời mà process dùng có thể không được xoá đi vì lệnh này kill trực tiếp process đó luôn, chỉ nên dùng SIGKILL khi process bị treo và ko phản hồi lại SIGTERM
- SIGTERM giống kiểu kill <process> còn SIGKILL là kill -9 <process>
- SIGUP sẽ gửi tín hiệu đóng process khi cái thiết bị cuối bị đóng, ví dụ đang chạy lệnh tải 1 cái gì đó ở terminal mà tắt terminal đi SIGUP sẽ được tự động gửi đến cái process tải đó và process sẽ bị kill
- SIGINT gửi tín hiệu đóng process từ bàn phím, chỉ đóng được process không chạy background mà chạy trực tiếp ở terminal, ví dụ khi bấm CTRL+C khi process chạy thì sẽ gửi SIGINT cho process đó

# 2.So sánh các lệnh cho process chạy background
- nohup cần viết vào lệnh chạy trước khi chạy, nó sẽ ignore SIGUP => nếu tắt terminal thì process vẫn chạy bình thường
- disown có thể chạy sau khi process đã chạy, thay vì ignore tín hiệu SIGUP gửi đến process thì nó gỡ cái process ra khỏi danh sách job luôn, SIGUP bây giờ sẽ không được gửi đến process từ shell đang chạy, nhưng nếu nguồn khác gửi SIGUP đến thì nó vẫn bị đóng.
- setsid cần dùng trước khi process chạy, thay vì liên quan đến SIGUP thì nó tạo 1 session chạy mới không liên quan đến terminal đang mở

# 3.Khi nào dùng pkill -f
- khi có nhiều process cùng tên thì pkill sẽ đóng hết các process đó nên cần dùng pkill -f để đóng 1 process cụ thể khớp với command

# 4.Giải thích cột STAT khi chạy ps auxf
- STAT là trạng thái hiện tại của process
- R: running, process đang chạy
- S: sleeping, process đang chờ, có thể là input từ bàn phím, request .....
- D: process đang đợi disk, không thể kill, ví dụ đang đọc/ghi file lớn
- Z: zombie, process đã chết nhưng chưa được dọn
- T: stopped, process bị tạm dừng
- I: kernel thread đang rảnh

# 5.Zombie process
- là process đã dừng, không dùng gì tài nguyên hệ thống nữa nhưng vẫn chiếm 1 PID  
### Cách nhận diện:  
- dùng ps aux và xem cột STAT nào có chữ Z
- dùng top xem có bao nhiêu zombie

### Cách xử lý
- process zombie không thể bị kill, cách duy nhất là kill process cha
```bash
# Cách tìm pid cha (là ppid) của zombie
ps -eo pid,ppid,stat,comm | awk '$3 == "Z"'
```


