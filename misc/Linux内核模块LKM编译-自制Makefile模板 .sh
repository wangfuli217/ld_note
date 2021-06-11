
simple(makefile)
{
   obj-m := module.o
   module-objs := file1.o file2.o
   
   make -C ~/kernel-2.6 M=`pwd` modules
}

key(kernel)
{
    KERNELRELEASE:如果已定义KERNELRELEASE，则说明是从内核构造系统调用的。
    MODULE_NAME:  模块输出名称； 即名为*.ko的输出模块
    MODULE_CONFIG：模块开关名称；make menuconfig 的开关
    CROSS_CONFIG： 交叉编译开关，手动设定这些值。
        KERNELDIR         已编译交叉版本内核位置
        CROSS_COMPILE     gcc交叉编译工具两
        INSTALLDIR        安装位置
    DEBUG：        调试开关。
    
    #### desc ####
    MODULE_NAME =   （模块名）
    MODULE_CONFIG = （在模块编译进内核时的配置选项）
    CROSS_CONFIG = y（是否为交叉编译）
    DEBUG = y       （是否定义调试标志）
    ......
    $(MODULE_NAME)-objs := （若为多文件模块，则在此列出。否则用#屏蔽)
    ......
    ifeq ($(CROSS_CONFIG), y)
    #for Cross-compile
    KERNELDIR = （内核源码路径）
    ARCH = arm（交叉编译时，目标CPU构架名，此处为arm）
    #FIXME:maybe we need absolute path for different user. eg root
    #CROSS_COMPILE = arm-none-linux-gnueabi-
    CROSS_COMPILE = （交叉编译工具路径及前缀）
    INSTALLDIR := （目标模块所安装的根文件系统路径）
    else
    #for Local compile
    ......
    ARCH = x86(这个根据本地构架可能需要修改)
    ......
    endif
}

Makefile(kernel)
{
    MODULE_NAME = hello_linux_simple
    MODULE_CONFIG = CONFIG_HELLO_LINUX_SIMPLE
    CROSS_CONFIG = y
    # Comment/uncomment the following line to disable/enable debugging
    DEBUG = y


    ifneq ($(KERNELRELEASE),)
        # Add your debugging flag (or not) to CFLAGS
        ifeq ($(DEBUG),y)
            DEBFLAGS = -O -g -DDEBUG # "-O" is needed to expand inlines
        else
            DEBFLAGS = -O2
        endif
        
        ccflags-y += $(DEBFLAGS)
    
        obj-$($(MODULE_CONFIG)) := $(MODULE_NAME).o
        #for Multi-files module
        $(MODULE_NAME)-objs := hello_linux_simple_dep.o ex_output.o
    else
        ifeq ($(CROSS_CONFIG), y)
            #for Cross-compile
            KERNELDIR = （内核源码路径）
            ARCH = arm
            #FIXME:maybe we need absolute path for different user. eg root
            #CROSS_COMPILE = arm-none-linux-gnueabi-
            CROSS_COMPILE = （交叉编译工具路径）
            INSTALLDIR := （目标模块所安装的根文件系统路径）
        else
            #for Local compile
            KERNELDIR = ?/lib/modules/$(shell uname -r)/build
            ARCH = x86
            CROSS_COMPILE =
            INSTALLDIR := /
        endif
        ################################
        PWD := $(shell pwd)
        .PHONY: modules modules_install clean
        modules:
            $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(MODULE_CONFIG)=m -C $(KERNELDIR) M=$(PWD) modules
        modules_install: modules
            $(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) $(MODULE_CONFIG)=m -C $(KERNELDIR) INSTALL_MOD_PATH=$(INSTALLDIR) M=$(PWD) modules_install
        clean:
            @rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.symvers *.order .*.o.d modules.builtin
    endif
}

Kconfig(kernel)
{
    config HELLO_LINUX_SIMPLE
    tristate "simple hello_linux module"
    # depends on
    help
    simple hello_linux module
    
    Makefile
    obj-$(CONFIG_HELLO_LINUX_SIMPLE) += hello_linux_simple/
}


key(userspace)
{
    TARGET：       交叉编译工具名称 arm-none-linux-gnueabi
    DEBUG：        调试开关。
    ARCH:          架构：ARM，__I386__，__X86_64__
}

Makefile(userspace)
{
CROSS_COMPILE = ${TARGET}-
AS          = ${CROSS_COMPILE}as
AR          = ${CROSS_COMPILE}ar
CC          = ${CROSS_COMPILE}cc
CPP         = ${CC} -E
LD          = ${CROSS_COMPILE}ld
NM          = ${CROSS_COMPILE}nm
OBJCOPY     = ${CROSS_COMPILE}objcopy
OBJDUMP     = ${CROSS_COMPILE}objdump
RANLIB      = ${CROSS_COMPILE}ranlib
SIZE        = ${CROSS_COMPILE}size
STRINGS     = ${CROSS_COMPILE}strings
STRIP       = ${CROSS_COMPILE}strip

export AS AR CC CPP LD NM OBJCOPY OBJDUMP RANLIB SIZE STRINGS STRIP

DEBUG=y

ifeq ($(DEBUG),y)
  DEBFLAGS = -DRTUD_DEBUG -g
else
  DEBFLAGS = 
endif

ARCH=X86_64

ifeq ($(ARCH),ARM)
  ARCHFLAGS = -D__ARM__
endif
ifeq ($(ARCH),I386)
  ARCHFLAGS = -D__I386__
endif
ifeq ($(ARCH),X86_64)
  ARCHFLAGS = -D__X86_64__
endif

# otdr_proto.c 
# gcc otdr_proto.c strerr.c -o otdr_proto -lpthread

# 构建时需要用到的设定值
# 
CFLAGS      = -g  -Wall ${DEBFLAGS} ${ARCHFLAGS}  -Wextra -Wshadow -D_GNU_SOURCE
HEADER_OPS  =
LDFLAGS     = -lpthread -ldl

# 安装时需要用到的变量
EXEC_RTU   = rtud
INSTALL     = install
INSTALL_DIR = ${PRJROOT}/rootfs/bin

EXEC_OTDR   = otdrd
EXEC_SLOT   = slotd
EXEC_HOST   = hostd
EXEC_MCUD   = mcud
EXEC_SORD   = sord

# 构建时需要用到的文件
RTU_OBJS    = cfg.o fibre_config.o main.o otdr_proto.o pcqueue.o rtu_report.o slogger.o strerr.o ttyS.o otdr_cache.o\
clocks.o host_proto.o ldproxy.o otdr_main.o otdr_task.o rtu_config.o rtu_tty.o sockets.o tty_proto.o utils.o host.o rtu_monitor.o curvedata.o

OTDR_OBJS = otdrd.o otdr_proto.o strerr.o cfg.o sockets.o slogger.o utils.o clocks.o 

SLOT_OBJS = slotd.o tty_proto.o strerr.o cfg.o ttyS.o slogger.o utils.o clocks.o sockets.o

HOST_OBJS = hostd.o tty_proto.o strerr.o cfg.o ttyS.o slogger.o utils.o clocks.o sockets.o host.o otdr_proto.o

MCUD_OBJS = mcud.o strerr.o utils.o

SORD_OBJS = sord.o strerr.o utils.o otdr_sor.o slogger.o cfg.o

# 构建时用到的规则
all:rtud otdrd slotd hostd mcud sord

.c.o:
	${CC} ${CFLAGS} ${HEADER_OPS} -c $< ${LDFLAGS} 
    
rtud:${RTU_OBJS}
	${CC} -o  ${EXEC_RTU} ${RTU_OBJS} ${LDFLAGS} 
    
otdrd:${OTDR_OBJS}
	${CC} -o  ${EXEC_OTDR} ${OTDR_OBJS} ${LDFLAGS} 

slotd:${SLOT_OBJS}
	${CC} -o  ${EXEC_SLOT} ${SLOT_OBJS} ${LDFLAGS} 

hostd:${HOST_OBJS}
	${CC} -o  ${EXEC_HOST} ${HOST_OBJS} ${LDFLAGS} 

mcud:${MCUD_OBJS}
	${CC} -o  ${EXEC_MCUD} ${MCUD_OBJS} ${LDFLAGS} 
    
sord:${SORD_OBJS}
	${CC} -o  ${EXEC_SORD} ${SORD_OBJS} ${LDFLAGS} 
    
install:

clean:
	-rm -f *.o ${EXEC_RTU} ${EXEC_OTDR} ${EXEC_SLOT} ${EXEC_HOST} ${EXEC_MCUD} ${EXEC_SORD}

distclean:
}

cross_compile(monit)
{
## SMDK4X12 为armv7版本

./configure --without-pam --without-ssl --build=armv7 --host=arm CC=/opt/arm-2014.05/bin/arm-none-linux-gnueabi-gcc libmonit_cv_setjmp_available=no libmonit_cv_vsnprintf_c99_conformant=no

1：--bulid=armv7 是一定要的，表明目标CPU是arm7架构，
2：--host=arm 配合上一个参数。     
3：CC 参数指定了arm交叉

--host=arm    ## arm-unknown-none
--bulid=armv7 ## armv7-unknown-none

完成后 再执行 make install 命令即可，默认安装到/usr/local/bin 下，
其实make通过后我们已经得到 monit命令和 monit.rc文件了，其他的都可以从目录中找到。

host=x86_64-unknown-linux-gnu
build=x86_64-unknown-linux-gnu

System types:
  --build=BUILD     configure for building on BUILD [guessed]
  --host=HOST       cross-compile to build programs to run on HOST [BUILD]
}


configure(key)
{
CC=arm-hik_v7a-linux-uclibcgnueabi-gcc 
CXX=arm-hik_v7a-linux-uclibcgnueabi-c++ 
LD=arm-hik_v7a-linux-uclibcgnueabi-ld 
AR=arm-hik_v7a-linux-uclibcgnueabi-ar 
AS=arm-hik_v7a-linux-uclibcgnueabi-as 
NM=arm-hik_v7a-linux-uclibcgnueabi-nm 
STRIP= RANLIB=arm-hik_v7a-linux-uclibcgnueabi-strip  
OBJDUMP=arm-hik_v7a-linux-uclibcgnueabi-objdump 
../configure --build=i386-pc-linux-gnu 
--host=arm-hik_v7a-linux-uclibcgnueabi      ## arm-none-linux-gnueabi-gcc -v | grep target 对应名称
--target=arm-hik_v7a-linux-uclibcgnueabi    ## arm-none-linux-gnueabi-gcc -v | grep target 对应名称
--cache-file=arm-hik_v7a-linux-uclibcgnueabi.cache 
prefix=$HOME/cdvs_bin_for_arm 
--program-prefix="tm-" CFLAGS="${CFLAGS}" CXXFLAGS="${CFLAGS}"


    --srcdir=DIR 
    这个选项对安装没有作用.他会告诉'configure'源码的位置.一般来说不用指定此选项,
    因为'configure'脚本一般和源码文件在同一个目录下. 
    
    --program-prefix=PREFIX 
    指定将被加到所安装程序的名字上的前缀.例如,使用'--program-prefix=g'来configure一个名为'tar'
    的程序将会使安装的程序被命名为'gtar'.当和其他的安装选项一起使用时,这个选项只有当他被
    'Makefile.in'文件使用时才会工作.
    
    --program-suffix=SUFFIX 
    指定将被加到所安装程序的名字上的后缀. 
    
    --program-transform-name=PROGRAM 
    这里的PROGRAM是一个sed脚本.当一个程序被安装时,他的名字将经过`sed -e PROGRAM`来产生安装的名字. 
 
######## 
    --build
    参数指定的是编译器完成整个build的工程的机器结构在这里我们输入i386-pc-linux-gnu

    --host
    参数指定最终生成可执行文件的运行环境 arm-hik_v7a-linux-uclibcgnueabi （也就是我们用的交叉编译器工具的前缀——即编译器的文件夹的名字 ）这些都是一致的

    --target
    参数目标机的环境等同host。
######   
    --target=GARGET 
    指定软件面向(target to)的系统平台.这主要在程序语言工具如编译器和汇编器上下文中起作用.如果没有指定,默认将使用'--host'选项的值. 
    
    --disable-FEATURE 
    一些软件包可以选择这个选项来提供为大型选项的编译时配置,例如使用Kerberos认证系统或者一个实验性的编译器最优配置.如果默认是提供这些特性,可以使用'--disable-FEATURE'来禁用它,这里'FEATURE'是特性的名字
}

cross_compile(boa)
{
下载地址: http://www.boa.org/
tar xzf boa-0.94.13.tar.gz
./configure

CC = /home/tekkamanninja/working/source/2.95.3/bin/arm-linux-gcc
CPP = /home/tekkamanninja/working/source/2.95.3/bin/arm-linux-gcc -E

[tekkamanninja@Tekkaman-Ninja src]$ make
[tekkamanninja@Tekkaman-Ninja src]$ /home/tekkamanninja/working/source/2.95.3/bin/arm-linux-strip boa
[tekkamanninja@Tekkaman-Ninja src]$ cp boa /home/tekkamanninja/working/nfs/rootfs/bin/

## 配置Boa
[tekkamanninja@Tekkaman-Ninja source]$ cd ../nfs/rootfs/etc/
[tekkamanninja@Tekkaman-Ninja etc]$ mkdir boa
[tekkamanninja@Tekkaman-Ninja etc]$ chmod 777 boa/
[tekkamanninja@Tekkaman-Ninja etc]$ cd boa
[tekkamanninja@Tekkaman-Ninja boa]$ kwrite boa.conf

1、Group的修改
修改 Group nogroup
为 Group user（开发板上有的组）
修改 User nobody
为 User boa （user组中的一个成员）
根据你的开发板的情况设定。一定要存在的组和用户。

adduser -g user boa

2、ScriptAlias的修改

修改 ScriptAlias /cgi-bin/  /usr/lib/cgi-bin/
为 ScriptAlias /cgi-bin/  /var/www/cgi-bin/

这是在设置CGI的目录，你也可以设置成别的目录。比如用户文件夹下的某个目录。

3、ServerName的设置
修改 #ServerName www.your.org.here
为 ServerName www.your.org.here
注意：该项默认为未打开，执行Boa会异常退出，提示"gethostbyname::No such file or directory",所以必须打开。其它默认设置即可。你也可以设置为你自己想要的名字。比如我设置为：ServerName tekkaman2440
此外，还需要：
将mime.types文件复制/etc目录下，通常可以从linux主机的 /etc目录下直接复制即可。
（以下配置和boa.conf的配置有关）
创建日志文件所在目录/var/log/boa
创建HTML文档的主目录/var/www
创建CGI脚本所在录 /var/www/cgi-bin


cp /etc/mime.types etc/

boa

如果发现boa没有运行，则可以在开发板的/var/log/boa/error_log文件中找原因。

[tekkamanninja@Tekkaman-Ninja source]$ vi helloworldCGI.c
[tekkamanninja@Tekkaman-Ninja source]$ cp helloworldCGI ../nfs/rootfs/var/www/cgi-bin/

3.测试
浏览器输入
   http://192.168.1.2/cgi-bin/helloworldCGI

网页出现 Hello,world. 调试成功！
}


cross_compile(lighttpd)
{
tar xjvf lighttpd-1.4.18.tar.bz2
CC=/home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-gcc ./configure -prefix=/lighttpd  -host=arm-9tdmi-linux-gnu --disable-FEUTARE -disable-ipv6 -disable-lfs  

make
make install

[tekkamanninja@Tekkaman-Ninja lighttpd-1.4.18]$ cp doc/lighttpd.conf  /home/tekkamanninja/working/nfs/rootfs/etc/

[tekkamanninja@Tekkaman-Ninja lighttpd-1.4.18]$ kwrite  /home/tekkamanninja/working/nfs/rootfs/etc/lighttpd.conf 

必需修改的地方有：

    server.document-root        = "/srv/www/htdocs/"
改为server.document-root        = "/home/lighttpd/html/"

你可以自己定义，这里就是设置web服务的根目录。

屏蔽一下语句，不然嵌入式这样的小系统下可能无法启动
#$HTTP["url"] =~ "\.pdf$" {
#  server.range-requests = "disable"
#}

开看程序需要那些动态库：
[tekkamanninja@Tekkaman-Ninja lighttpd-1.4.18]$ ~/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-readelf -d src/lighttpd

拷贝动态库：
开发板操作：
adduser -g user lighttpd
HOST 操作：
[root@Tekkaman-Ninja lighttpd]# mkdir html
[root@Tekkaman-Ninja lighttpd]# chmod 777 html/
[root@Tekkaman-Ninja lighttpd]# mkdir  ../../var/log/lighttpd
[root@Tekkaman-Ninja lighttpd]# chmod 777 ../../var/log/lighttpd

将移植好的程序（整个目录，其中包含了bin、sbin、lib和share目录）拷贝到开发板根文件系统的根目录下：
[root@Tekkaman-Ninja lighttpd]# mv /lighttpd   /home/tekkamanninja/working/nfs/

四、运行程序
在开发板上操作：
[root@~]#/lighttpd/sbin/lighttpd -f /etc/lighttpd.conf

}
