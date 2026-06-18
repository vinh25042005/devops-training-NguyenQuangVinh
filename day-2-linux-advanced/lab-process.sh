#!/bin/bash

# tạo process sleep 300
echo "Tạo process sleep 300..."
sleep 300 &
PID=$!
echo "PID = $PID"

# xem thông tin process
echo ""
echo "Thông tin process:"
ps -p $PID -o pid,ppid,stat,comm

# gửi tín hiệu SIGTERM
echo ""
echo "Gửi SIGTERM..."
kill $PID
wait $PID 2>/dev/null

# kiểm tra exit code
echo "Exit code = $?"