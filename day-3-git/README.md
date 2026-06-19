## Task: `Day 3 — Git Advanced`

- **Intern**: `Nguyễn Quang Vinh`
- **Phase / Week / Day**: `Phase 1 / Week 1 / Day 3`
- **Branch**: `phase-1/week-1/day-3-git`
- **Submitted at**: `<2026-06-19 15:49>` (timezone +07)
- **Time spent**: `6h`

## 1. Mục tiêu
- Hiểu cách hoạt động của git
- Chạy để xem thực sự cách lệnh hoạt động như này
- Tìm hiểu 2 workflow phổ biến trunk-based vs GitFlow

## 2. Cách chạy
## Part A — Rebase + cherry-pick + conflict

### Bước 1: Tạo branch `feature-a`, commit 3 file khác nhau

```bash
git checkout main
git checkout -b feature-a

echo "file1" > feature-a-1.txt
git add feature-a-1.txt
git commit -m "docs: file1"

echo "file2" > feature-a-2.txt
git add feature-a-2.txt
git commit -m "docs: file2"

echo "file3" > feature-a-3.txt
git add feature-a-3.txt
git commit -m "docs: file3"

git log --oneline --graph --all
```
### Bước 2:  Tạo branch feature-b, commit 2 lần (cùng file với feature-a)
```bash
git checkout main
git checkout -b feature-b

echo "file1" > feature-a-3.txt
git add feature-a-3.txt
git commit -m "docs: feature-b v1"

echo "file2" > feature-a-3.txt
git add feature-a-3.txt
git commit -m "docs: feature-b v2"

git log --oneline --graph --all
```

### Bước 3: Rebase feature-b lên feature-a → resolve conflict thủ công
```bash
git checkout feature-b
git rebase feature-a
```
Git báo conflic
```bash
CONFLICT (add/add): Merge conflict in feature-a-3.txt
```
Cách xử lý lần lượt conflic được ghi rõ trong phần giải quyết conflic ở file history.md

### Bước 4: Tạo branch hotfix, commit 1 fix
```bash
git checkout main
git checkout -b hotfix

echo "hotfix content" > hotfix.txt
git add hotfix.txt
git commit -m "docs: hotfix"

git log --oneline --graph --all
```

### Bước 5: Cherry-pick commit hotfix sang main và feature-a
 ```bash
 # Lấy SHA của hotfix
git log --oneline hotfix
# Ví dụ: a1b2c3d docs: hotfix

# Cherry-pick lên main
git checkout main
git cherry-pick a1b2c3d

# Cherry-pick lên feature-a
git checkout feature-a
git cherry-pick a1b2c3d

git log --oneline --graph --all
 ```

 ### Bước 6: Squash 3 commit của feature-a thành 1
 ```bash
git checkout feature-a
git log --oneline
git rebase -i HEAD~4
 ```

 Sửa thành:
 ```bash
pick 4bd3175 docs:file1
squash 496fc6c docs:file2
squash 2efe409 docs:file3
pick 4ef78ea docs:hotfix
 ```

## Part B — Tìm lại commit bị "mất" bằng reflog
- **Hướng dẫn chạy part này chi tiết ở trong file reflog-lab.md**

### Part C — git bisect
 **Chi tiết các bước chạy được ghi tại bisect.log**  
 
### Bước 1: Tạo branch `bug-hunt` với 20 commit, trong đó commit 13 là bug
```bash
echo "13" > file-13.txt && echo 'print("hello bug")' > app.py && git add . && git commit -m "chore: commit 13"
```
### Bước 2: Dùng git bisect tìm commit lỗi
```bash
# Bắt đầu bisect
git bisect start
git bisect bad HEAD        
git bisect good HEAD~20
```

Sau mỗi lần chạy thì kiểm tra bằng
```bash
cat app.py
```

- print("hello") → chưa có bug → chạy ```git bisect good```
- print("hello bug") → đã có bug → chạy ```git bisect bad```
- lặp lại đến khi được báo (roughly 0 steps) => đó chính là commit bug
## 3. Kết quả
- Screenshot / log output (kèm trong `./screenshots/`).
- Link demo (nếu có).



## Part D — Pre-commit hook

### Bước 1: Cài đặt pre-commit

# Dùng venv để cài pre-commit do Ubuntu mới không cho cài trực tiếp vào máy
```bash
python3 -m venv ~/venv
~/venv/bin/pip install pre-commit
```
### Bước 2: Tạo file cấu hình .pre-commit-config.yaml như hướng dẫn của bài
### Bước 3: Cài đặt hook vào Git
```bash
~/venv/bin/pre-commit install
```
### Bước 4: Test — tạo file có whitespace cuối dòng
```bash
echo "co space cuoi dong    " > test-whitespace.txt
git add test-whitespace.txt
git commit -m "test: whitespace"
```
Kết quả được lưu tại thư mục ```screenshots```

## 4. Khó khăn & cách giải quyết
- Ở phần lear git branching thì chưa thực sự dùng các lệnh đó bao giờ nên có bài không làm được, phải xem giải của bài đó thì mới hiểu 
- Ở part D do ubuntu mới không cho cài thư viện python trực tiếp nên mất thời gian tìm hiểu để cài được precommit
- Những scenario cần dùng của các workflow chưa biết sau khi đọc lý thuyết, cần lên mạng tham khảo
## 5. Reference
- https://learngitbranching.js.org/?locale=vi
- https://trunkbaseddevelopment.com/
- https://viblo.asia/p/co-ban-ve-gitflow-workflow-4dbZNn6yZYM
- https://docs.github.com/en/get-started/using-github/github-flow
- Dùng AI để tra cứu

## 6. Self-check
- [x] Code chạy được trên máy sạch.
- [x] README có hướng dẫn run lại.
- [x] Không hard-code secret.
- [x] Commit message theo Conventional Commits.
- [x] Đã review lại code 1 lượt.