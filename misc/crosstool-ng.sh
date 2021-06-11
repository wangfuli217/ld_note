

create(下载crosstool-ng，并为使用安装必要的软件)
{
crosstool-ng的下载地址是：http://ymorin.is-a-geek.org/download/crosstool-ng/
   值得注意的是，下载里最新的crosstool-ng以后，记得在到http://ymorin.is-a-geek.org/download/crosstool-ng/01-fixes/看看有没有相应的补丁，有得话一起下载下来。

   我这次使用的是1.6.1。
   使用crosstool-ng必须安装一些开发用的软件，在ubuntu下必须安装（使用apt）：
libncurses5-dev
bison
flex
texinfo
automake
libtool
patch
gcj
cvs
cvsd
gawk

svn    (2011.09.16补充)
  根据用crosstool-ng建立arm-linux交叉工具链的介绍，最好手动安装一下termcap。
}

create(解压、打补丁（如果有）并建立工作目录。)
{
crosstool-ng和crosstool不同的地方之一就是：她并不是一下载下来就可以使用了，必须先配置安装。
   将下载下来的crosstool-ng-X.Y.Z.tar.bz2解压到你为她准备的工作目录（这里假设为${CROSSTOOLNG}），并建立安装和编译目录。

mkdir crosstool-ng-X.Y.Z_build     #这次编译新交叉编译器的工作目录
mkdir crosstool-ng-X.Y.Z_install   #crosstool-ng的安装目录
cd crosstool-ng-X.Y.Z              #进入解压后的crosstool-ng目录

patch -p1 <   <补丁文件>            # 给crosstool-ng打补丁（如果有）

./configure --prefix=${CROSSTOOLNG}/crosstool-ng-X.Y.Z_install

                                   #配置crosstool-ng
make                               #编译crosstool-ng
make install                       #安装crosstool-ng
}

config()
{
下面我只说说针对armv4t需要修改的地方，别的构架等有了板子测试再说：
1、已下载好的源码包路径和交叉编译器的安装路径。
Paths and misc options  --->
  (${HOME}/development/crosstool-ng/src) Local tarballs directory   保存源码包路径
  (${HOME}/development/x-tools/${CT_TARGET}) Prefix directory  交叉编译器的安装路径
这两个请依据你的实际情况来修改。

2、修改交叉编译器针对的构架
 Target options  --->
           *** Target optimisations ***
           (armv4t) Architecture level
           (arm9tdmi) Emit assembly for CPU   
           (arm920t) Tune for CPU
           
3、关闭JAVA编译器，避免错误。
  我这里用ubuntu 9.10编译JAVA编译器的时候会出错，也许是host的gcj的问题，反正我不用JAVA，所以就直接关闭了。如果有兄弟知道如何修正记得通知一声！！
C compiler  --->
      *** Additional supported languages: ***
      [N] Java
      
4、根据参考资料,禁止内核头文件检测（只起到节约时间的作用（不到1S的时间），不推荐禁用）
Operating System  --->
 [N]     Check installed headers
 
5、增加编译时的并行进程数，以增加运行效率，加快编译。
Paths and misc options  --->
   *** Build behavior ***
   (4) Number of parallel jobs
   这个数值不宜过大，应该为CPU数量的两倍。由于我的CPU是双核的，所以我填了4.
   
6、一些个性化的修改（可以不修改）
Toolchain options  --->
       *** Tuple completion and aliasing *** 
       (tekkaman) Tuple is vendor string
这样产生的编译器前缀就是：arm-tekkaman-linux-gnueabi-

C compiler  --->
       (crosstool-NG-${CT_VERSION}-tekkaman) gcc ID string

配置好以后保存。

最后，内核源码的版本号修改，请直接修改crosstool-ng-1.6.1_build目录下的.config文件，不止一处，有关的都要修改。
有：
CT_KERNEL_VERSION=
CT_KERNEL_V_2_6_？？_？=y
CT_LIBC_GLIBC_MIN_KERNEL=
如果再次../crosstool-ng-1.6.1_install/bin/ct-ng menuconfig，这个修改又会复原，必须再次手工修改。
你也可以选择修改crosstool-ng-X.Y.Z_build/config/kernel/linux.in等文件，只是比较麻烦，但这可以彻底解决，实现在界面中增加内核版本。   
}

creat(download)
{
为加快速度，根据配置自行下载相应的软件包。（选做）
   虽然crosstool-ng发现找不到软件包的时候会自动下载，但是比较慢。根据这次的配置情况（查看".config"文件），我预先下载了以下的软件包：
binutils-2.19.1.tar.bz2
glibc-2.9.tar.gz         
dmalloc-5.5.2.tgz       
glibc-ports-2.9.tar.bz2  
mpfr-2.4.2.tar.bz2
duma_2_5_15.tar.gz      
gmp-4.3.1.tar.bz2        
ncurses-5.7.tar.gz
ecj-latest.jar      
libelf-0.8.12.tar.gz     
sstrip.c
gcc-4.3.2.tar.bz2       
linux-2.6.33.1.tar.bz2  
strace-4.5.19.tar.bz2
gdb-6.8.tar.bz2        
ltrace_0.5.3.orig.tar.gz

下载完之后，记得将这些软件包放在配置时指定的文件夹。
}

build()
{
五、开始编译。

../crosstool-ng-1.6.1_install/bin/ct-ng bluid

我的笔记本用了大概40多分钟编译完成。

六、编译好后的交叉编译器。
编译器位于：${你配置时确定的路径}/x-tools/arm-tekkaman-linux-gnueabi/bin
库文件位于：${你配置时确定的路径}/x-tools/arm-tekkaman-linux-gnueabi/arm-tekkaman-linux-gnueabi/lib
}