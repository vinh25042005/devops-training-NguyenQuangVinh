# Part D — Alert
## 3 alert rule cho web app
- Errors: tỷ lệ request lỗi quá nhiều
- Saturation: mức độ tiêu thụ tài nguyên hệ thống, như %CPU, %RAM, %DISK
- Latency: thời gian cần để giải quyết request, nên dùng p50,, p95,... p50 là 50% request nhanh hơn số đó, p95 là 95% request nhanh hơn số đó, tốt hơn nữa thì dùng apdex score

## Noise vs Actionable alert
- Noise là những alert gần như vô dụng, khi nhận không biết phải làm gì, ví dụ:
    - Đặt mốc quá thấp như CPU > 50%
    - Lặp đi lặp lại như disk > 70% trong nhiều ngày => thường bị bỏ qua
    - Thời gian quá ngắn, ví dụ CPU > 95% 5s cũng alert, xong lại hết

- Actionable là khi có alert thường sẽ biết phải làm gì ngay, ví dụ
    - Có hướng dẫn khi alert xảy ra cần phải làm gì
    - Đặt mốc hợp lý, ví dụ 5% request lỗi trong thời gian ngắn
    - Tránh alert nhất thời, ví dụ CPU>95% trong vài phút