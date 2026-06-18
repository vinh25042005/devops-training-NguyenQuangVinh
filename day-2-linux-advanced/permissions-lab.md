# Steps reproduce
**Bước 1: Tạo trước group và testuser**
```bash
# Tạo group devops
sudo groupadd devops
# Thêm user hiện tại vào group devops
sudo usermod -aG devops $USER
# Thêm 1 user khác để test ACL
sudo useradd -m testuser
```

**Bước 2: Tạo thư mực share-lab, set các quyền cho thư mục đó**
```bash
sudo mkdir /tmp/shared-lab
sudo chown :devops /tmp/shared-lab
# inherit group devops
sudo chmod 2775 /tmp/shared-lab
```
**Kiểm tra xem file mới có tự inherit không**
```bash
touch /tmp/shared-lab/test.txt
touch /tmp/shared-lab/script.sh
# Kiểm tra
ls -l /tmp/shared-lab/
```

**Bước 3: Tạo file secret.txt — chỉ owner đọc được**

```bash
# Tạo file với nội dung bí mật
echo "bí mật" | sudo tee /tmp/shared-lab/secret.txt

# Set quyền
sudo chmod 700 /tmp/shared-lab/secret.txt

# Kiểm tra
ls -l /tmp/shared-lab/secret.txt
```
**Kiểm tra user khác xem đọc đọc được không**
```bash
# Owner (root) đọc được
sudo cat /tmp/shared-lab/secret.txt
# User khác
sudo -u testuser cat /tmp/shared-lab/secret.txt
```

**Bước 4: Dùng ACL để cho 1 user cụ thể(testuser) chỉ đọc, không ghi**
Cài acl trước  
```bash
sudo apt update
sudo apt install acl -y
```
```bash
# Setfacl cho testuser
sudo setfacl -m u:testuser:r /tmp/shared-lab/secret.txt
```
Kiểm tra lại  ACL đã set
```bash
getfacl /tmp/shared-lab/secret.txt
```
