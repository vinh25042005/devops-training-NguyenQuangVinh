
**Git log sau bước 1**
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* 2efe409 (HEAD -> feature-a) docs:file3
* 496fc6c docs:file2
* 4bd3175 docs:file1
* 64c6ae5 (origin/main, main) Initial commit

**Git log sau bước 2**
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* b5eb04b (HEAD -> feature-b) docs: feature-b v2
* 597a039 docs: feature-b v1
| * 2efe409 (feature-a) docs:file3
| * 496fc6c docs:file2
| * 4bd3175 docs:file1
|/  
* 64c6ae5 (origin/main, main) Initial commit

**Confliec ở bước rebase**  

vinh2@vi:~/work/git-lab$ git rebase feature-a
Auto-merging feature-a-3.txt
CONFLICT (add/add): Merge conflict in feature-a-3.txt
error: could not apply 597a039... docs: feature-b v1
hint: Resolve all conflicts manually, mark them as resolved with
hint: "git add/rm <conflicted_files>", then run "git rebase --continue".
hint: You can instead skip this commit: run "git rebase --skip".
hint: To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply 597a039... docs: feature-b v1

**Cách giải quyết**
- sửa nội dung file feature-a-3 thành file3 + file1
- sau khi giải quyết thì lại conflic với commit lần 2 trên granch B, tiếp tục giải quyết bằng cách sửa file thành file1 + file2 + file3

**Git log sau bước 3**
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* a44287f (HEAD -> feature-b) docs: feature-b v2
* 8b92bc2 docs: feature-b v1
* 2efe409 (feature-a) docs:file3
* 496fc6c docs:file2
* 4bd3175 docs:file1
* 64c6ae5 (origin/main, main) Initial commit

**Git log sau bước 4**
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* 240eace (HEAD -> hotfix) docs:hotfix
| * a44287f (feature-b) docs: feature-b v2
| * 8b92bc2 docs: feature-b v1
| * 2efe409 (feature-a) docs:file3
| * 496fc6c docs:file2
| * 4bd3175 docs:file1
|/  
* 64c6ae5 (origin/main, main) Initial commit

**Git log sau bước 5**
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* 4ef78ea (HEAD -> feature-a) docs:hotfix
| * ea63bbc (main) docs:hotfix
| | * 240eace (hotfix) docs:hotfix
| |/  
| | * a44287f (feature-b) docs: feature-b v2
| | * 8b92bc2 docs: feature-b v1
| |/  
|/|   
* | 2efe409 docs:file3
* | 496fc6c docs:file2
* | 4bd3175 docs:file1
|/  
* 64c6ae5 (origin/main) Initial commit

**Git log sau bước 6**
vinh2@vi:~/work/git-lab$ git log --oneline --graph --all
* 2abbebf (HEAD -> feature-a) docs:hotfix
* b9828c4 docs: gộp 3 commmit
| * ea63bbc (main) docs:hotfix
|/  
| * 240eace (hotfix) docs:hotfix
|/  
| * a44287f (feature-b) docs: feature-b v2
| * 8b92bc2 docs: feature-b v1
| * 2efe409 docs:file3
| * 496fc6c docs:file2
| * 4bd3175 docs:file1
|/  
* 64c6ae5 (origin/main) Initial commit
