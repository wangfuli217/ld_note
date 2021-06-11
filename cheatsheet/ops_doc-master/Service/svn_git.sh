集中化版本控制系统（CVCS：Centralized Version Control System）

svn checkout/co svn_address      //拉取一个版本库到本地
svn update/up  file or directory //更新最新版本到本地
svn commit/ci  file or directory //提交更改到版本库
Svn采用拷贝-修改-合并（Copy-Modify-Merge）版本控制模型来解决这种冲突问题。这是svn版本控制的核心。

trunk：主干分支，用于保存相对最新比较稳定的代码，
branches：开发分支，用于新功能的开发，bug修复。分支存在的目的就是为了让各种修改从主线上分离出来。当新开发功能稳定之后可以合并到trunk中。
tags：标记，用于标记一个特殊的版本，通常用来标记release版本，一般不会再允许修改。
svn copy svn://XXX/trunk svn://XXX/branches/branch_1
svn copy svn://XXX/branch_1 svn://XXX/tags/tags_release_1

分布式版本控制系统（DVCS：Distributed Version Control System）

git config --global user.name "anonymalias" //用户名
git config --global user.email anonymalias@163.com // 邮箱
git config --global core.editor vim //文本编辑器
git config --global merge.tool vimdiff //差异化分析工具


git init

改命令会在当前目录生成.git目录，当前目录就可以进行版本管理了。可以使用如下命令进行版本管理：

git add file.c file.h
git add README
git commit -m 'initial project version'

从远程仓库克隆
git clone https://github.com/anonymalias/test.git
这里git使用clone命令来完成项目的拉取，和svn的checkout不同。git会将远程仓库中的项目的所有数据都克隆到本地，
和svn拉取文件快照有很大差别。

所有版本库目录下面的文件都可以分为两类：tracked（已跟踪）和untracked（未跟踪），在git下，tracked的文件可以分为
：未修改、已修改、已暂存。和svn版本管理不同的是，git对于修改的tracked文件，要先暂存到暂存区（staged area），
然后再提交到分支中。

untracked          unmodified       modified        staged
    |                 |  edit file->   |  stage file->|
    |  add file->     |                |              |
    |  <-remove file  |    <----------commit--------- |
    |                 |                |              |
1.向版本库添加跟踪文件
git add file
git commit -m 'initial project version'
2.提交修改的文件
和1的操作是一样的，要先通过add命令将修改暂存到暂存区，然后提交到版本库中。
3.移除文件
git rm file
git commit -m 'initial project version'
4.版本状态查看
git status
5.分支的创建，切换，合并
git branch //查看当前版本库的所有分支，带*的是当前分支
git branch b1 //创建新分支b1，从当前分支而来，对于git只是创建一个分支指针
git checkout b1 //切换到分支b1，
git checkout -b b1 //等同于上面两条命令，创建分支并进行切换
git merge b1 //将分支b1合并到当前分支
6. 远程交互
当我们需要拉取远程仓库最新的版本时如下进行如下操作：
git fetch origin
该命令首先找到 origin 对应远程服务器的地址，然后更新最新的数据到本地origin版本库，然后把 origin/master 的指针移到它最新的位置。
git pull 
pull命令相对于fetch命令的区别就是：它拉取最新的分支后，会合并到本地的分支。
下面的命令是将某个分支推送到远程操作上。
git push (远程仓库名) (分支名)