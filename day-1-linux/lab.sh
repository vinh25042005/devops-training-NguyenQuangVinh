echo "5 process tốn ram nhất"
ps aux --sort=-%mem | head -6 | awk '{print $2, $11, $4}' 
echo -e "\nĐếm số file .log trong /var/log"
find /var/log -maxdepth 2 -name "*.log" | wc -l
echo -e "\n Tìm 10 IP xuất hiện nhiều nhất trong /var/log/auth.log"
grep -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}" /var/log/auth.log | sort | uniq -c | sort -rn | head -10
echo -e "\n Lấy hostname + kernel version + uptime và lưu vào system-info.txt"
{
    echo "host=$(hostname)"
    echo "kernel=$(uname)"
    echo "uptime=$(uptime | sed 's/up //')"
} > system-info.txt