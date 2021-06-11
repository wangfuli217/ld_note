http://mp.weixin.qq.com/s?src=3&timestamp=1489985335&ver=1&signature=V-NSaVpqkPFm98fJar4RlRl3EZJ5SR5jX7ZwXr0Z8m*leINL5KkOjwfmFlqfMBfBoHQTwF8Vc1bncL51q3lSXHiCkdCGjLgLOziCKBGBOrDtHaw1ddgKbShJXXmlfUWxi8ZyfTEOK5uGvfDwHN9s6j7omJihVx5Hiphtds87fV8=
http://os.51cto.com/art/201703/534075.htm

1. 最少4-6GB内存
2. 最新版ubuntu 16.04
3. 磁盘剩余空间至少60~80GB
4. 在创建之间先安装软件包
5. 下载最新的yocto稳定分支

apt-get update
    apt-get install wget git-core unzip make gcc g++ build-essential subversion sed autoconf automake texi2html texinfo coreutils diffstat python-pysqlite2 docbook-utils libsdl1.2-dev libxml-parser-perl libgl1-mesa-dev libglu1-mesa-dev xsltproc desktop-file-utils chrpath groff libtool xterm gawk fop
    
    git clone -b morty git://git.yoctoproject.org/poky.git
    