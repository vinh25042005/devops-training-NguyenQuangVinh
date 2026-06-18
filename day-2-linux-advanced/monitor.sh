#!/bin/bash

LOG_FILE="$HOME/monitor.log"
WARNING_COUNT=0
CPU_THRESHOLD=80
SLEEP_SEC=10

# Trap SIGINT 
cleanup() {
    echo ""
    echo "[$(date)] Monitor stopped." | tee -a "$LOG_FILE"
    exit 0
}
trap cleanup SIGINT

# Lấy %cpu 
get_cpu_usage() {
    top -bn2 -d 1 | grep "Cpu(s)" | tail -1 | awk '{print int(100 - $8)}'
}
# Lấy %mem
get_mem_usage() {
    free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}'
}

# Lấy top 3 process tốn CPU
get_top_processes() {
    local CORES=$(nproc)
    top -bn1 -o %CPU | grep -A3 "PID USER" | tail -3 | awk -v c="$CORES" '{printf "  PID %s CPU %.1f%% MEM %s%%\n", $1, $9/c, $10}'
}

while true; do
    CPU=$(get_cpu_usage)
    MEM=$(get_mem_usage)

    echo "──────────────────────────────────────"
    echo "[$(date)] CPU: ${CPU}% | MEM: ${MEM}%"
    echo "Top 3 process tốn CPU:"
    get_top_processes

    # Kiểm tra ngưỡng
    if [ "$CPU" -gt "$CPU_THRESHOLD" ]; then
        WARNING_COUNT=$((WARNING_COUNT + 1))
        echo "   CPU > ${CPU_THRESHOLD}% (lần ${WARNING_COUNT}/3)"

        if [ "$WARNING_COUNT" -ge 3 ]; then
            echo "[$(date)] WARNING: CPU > ${CPU_THRESHOLD}% trong 3 sample liên tiếp! CPU=${CPU}%, MEM=${MEM}%" >> "$LOG_FILE"
            WARNING_COUNT=0
        fi
    else
        WARNING_COUNT=0
    fi

    sleep $SLEEP_SEC
done