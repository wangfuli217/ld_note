
压缩
tar 解压命令
    tar -zxvf nmap-3.45.tgz    将这个解压到nmap-3.45这个目录里


zip FileName.zip DirName    # 压缩
unzip ***.zip   # 解压文件到当前目录



# 打包某目录(便于上传、下载)
    zip -q -r html.zip /home/Blinux/html
    zip -q -r html.zip * # 在要打包的目录下
    # -r表示递归压缩子目录下所有文件.

    tar zcf commbook_20140416.tgz * --exclude=logs  --exclude=log   --exclude=nohup.out  # --exclude 不打包某目录、文件
    tar zcf mobile_20140416.tgz mobile/ --exclude=run.log  --exclude=run.log.*   --exclude=nohup.out  # --exclude 可以用*号匹配符

# 解压
    unzip test.zip
    # 把 myfile.zip 文件解压到 /home/sunny/
    unzip -o -d /home/sunny myfile.zip
    # -o:不提示的情况下覆盖文件；
    # -d:-d /home/sunny 指明将文件解压缩到/home/sunny目录下；

    # 解出 all.tar 包中所有文件，-x 是解开的意思
    tar -xf all.tar
