# Cách tìm commit bị mất


**Giả lập mất commit**
```bash
echo "commit bi mat" > lost.txt
git add lost.txt
git commit -m "docs: lost commit"
git reset --hard HEAD~1
```
**Chạy reflog**
```bash
git reflog
```
Sau đó sẽ thấy được
```bash
2abbebf (HEAD -> feature-a) HEAD@{0}: reset: moving to HEAD~1
bb3d6d5 HEAD@{1}: commit: docs: lost commit
=> bb3d6d5 là SHA của commit bị mất
```
**Copy SHA của commit bị mất rồi tạo branch từ cái đó**
```bash
git checkout -b recovered bb3d6d5
```
**Kết quả**  
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* bb3d6d5 (HEAD -> recovered) docs: lost commit

Đã restore đc commit về branch recovered