#!/usr/bin/env bash

set -euo pipefail

show_usage() {
    echo "Cách dùng: $0 <thư_mục>"
    echo "Tạo bản sao lưu của thư mục được chỉ định"
    echo ""
    echo "Tham số:"
    echo "  <thư_mục>  Đường dẫn đến thư mục cần backup"
    echo ""
    echo "Đầu ra:"
    echo "  Tạo file ~/backups/<tên_thư_mục>-YYYYMMDD-HHMMSS.tar.gz"
    echo "  Hiển thị số lượng file và tổng dung lượng đã sao lưu"
}

# bắt đầu backup
perform_backup() {
    local source_dir="$1"
    local backup_dir="$HOME/backups"
    
    # tạo thư mục backup nếu chưa tồn tại
    mkdir -p "$backup_dir"
    
    # lấy tên thư mục gốc để đặt tên file backup
    local dir_name
    dir_name=$(basename "$source_dir")
    
    # tạo timestamp
    local timestamp
    timestamp=$(date +"%Y%m%d-%H%M%S")
    
    # đặt tên file backup
    local backup_filename="${dir_name}-${timestamp}.tar.gz"
    local backup_path="${backup_dir}/${backup_filename}"
    
    # đếm số file và tổng dung lượng
    local file_count
    local total_size
    
    # đếm số file trong folder
    file_count=$(find "$source_dir" -type f | wc -l)
    
    # tính tổng dung lượng của thư mục
    total_size=$(du -b "$source_dir" | cut -f1)
    
    # tạo file backup
    echo "Đang tạo bản sao lưu: $backup_path"
    tar -czf "$backup_path" -C "$(dirname "$source_dir")" "$dir_name"
    
    # Output
    echo "File sao lưu: $backup_path"
    echo "Số lượng file đã sao lưu: $file_count"
    echo "Tổng dung lượng đã sao lưu: $(numfmt --to=iec "$total_size") ($total_size bytes)"
}


main() {

    # tham số help
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_usage
        return 0
    fi

    # Kiểm tra tham số
    if [ $# -ne 1 ]; then
        echo "Lỗi: Số lượng tham số không hợp lệ" >&2
        show_usage
        return 1
    fi
    
    local target_dir="$1"
    
    # Kiểm tra xem thư mục có tồn tại và là thư mục hay không
    if [ ! -d "$target_dir" ]; then
        echo "Lỗi: Thư mục '$target_dir' không tồn tại hoặc không phải là thư mục" >&2
        show_usage
        return 1
    fi
    
    target_dir="${target_dir%/}"
    
    # chạy hàm backup
    perform_backup "$target_dir"
}

main "$@" && exit_code=0 || exit_code=$?
if [ $exit_code -eq 0 ]; then
    echo "Exit code: 0 (Thành công)"
else
    echo "Exit code: $exit_code (Thất bại)" >&2
fi
exit $exit_code