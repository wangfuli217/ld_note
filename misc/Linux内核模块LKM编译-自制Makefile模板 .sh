
simple(makefile)
{
   obj-m := module.o
   module-objs := file1.o file2.o
   
   make -C ~/kernel-2.6 M=`pwd` modules
}

key(kernel)
{
    KERNELRELEASE:����Ѷ���KERNELRELEASE����˵���Ǵ��ں˹���ϵͳ���õġ�
    MODULE_NAME:  ģ��������ƣ� ����Ϊ*.ko�����ģ��
    MODULE_CONFIG��ģ�鿪�����ƣ�make menuconfig �Ŀ���
    CROSS_CONFIG�� ������뿪�أ��ֶ��趨��Щֵ��
        KERNELDIR         �ѱ��뽻��汾�ں�λ��
        CROSS_COMPILE     gcc������빤����
        INSTALLDIR        ��װλ��
    DEBUG��        ���Կ��ء�
    
    #### desc ####
    MODULE_NAME =   ��ģ������
    MODULE_CONFIG = ����ģ�������ں�ʱ������ѡ�
    CROSS_CONFIG = y���Ƿ�Ϊ������룩
    DEBUG = y       ���Ƿ�����Ա�־��
    ......
    $(MODULE_NAME)-objs := ����Ϊ���ļ�ģ�飬���ڴ��г���������#����)
    ......
    ifeq ($(CROSS_CONFIG), y)
    #for Cross-compile
    KERNELDIR = ���ں�Դ��·����
    ARCH = arm���������ʱ��Ŀ��CPU���������˴�Ϊarm��
    #FIXME:maybe we need absolute path for different user. eg root
    #CROSS_COMPILE = arm-none-linux-gnueabi-
    CROSS_COMPILE = ��������빤��·����ǰ׺��
    INSTALLDIR := ��Ŀ��ģ������װ�ĸ��ļ�ϵͳ·����
    else
    #for Local compile
    ......
    ARCH = x86(������ݱ��ع��ܿ�����Ҫ�޸�)
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
            KERNELDIR = ���ں�Դ��·����
            ARCH = arm
            #FIXME:maybe we need absolute path for different user. eg root
            #CROSS_COMPILE = arm-none-linux-gnueabi-
            CROSS_COMPILE = ��������빤��·����
            INSTALLDIR := ��Ŀ��ģ������װ�ĸ��ļ�ϵͳ·����
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
    TARGET��       ������빤������ arm-none-linux-gnueabi
    DEBUG��        ���Կ��ء�
    ARCH:          �ܹ���ARM��__I386__��__X86_64__
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

# ����ʱ��Ҫ�õ����趨ֵ
# 
CFLAGS      = -g  -Wall ${DEBFLAGS} ${ARCHFLAGS}  -Wextra -Wshadow -D_GNU_SOURCE
HEADER_OPS  =
LDFLAGS     = -lpthread -ldl

# ��װʱ��Ҫ�õ��ı���
EXEC_RTU   = rtud
INSTALL     = install
INSTALL_DIR = ${PRJROOT}/rootfs/bin

EXEC_OTDR   = otdrd
EXEC_SLOT   = slotd
EXEC_HOST   = hostd
EXEC_MCUD   = mcud
EXEC_SORD   = sord

# ����ʱ��Ҫ�õ����ļ�
RTU_OBJS    = cfg.o fibre_config.o main.o otdr_proto.o pcqueue.o rtu_report.o slogger.o strerr.o ttyS.o otdr_cache.o\
clocks.o host_proto.o ldproxy.o otdr_main.o otdr_task.o rtu_config.o rtu_tty.o sockets.o tty_proto.o utils.o host.o rtu_monitor.o curvedata.o

OTDR_OBJS = otdrd.o otdr_proto.o strerr.o cfg.o sockets.o slogger.o utils.o clocks.o 

SLOT_OBJS = slotd.o tty_proto.o strerr.o cfg.o ttyS.o slogger.o utils.o clocks.o sockets.o

HOST_OBJS = hostd.o tty_proto.o strerr.o cfg.o ttyS.o slogger.o utils.o clocks.o sockets.o host.o otdr_proto.o

MCUD_OBJS = mcud.o strerr.o utils.o

SORD_OBJS = sord.o strerr.o utils.o otdr_sor.o slogger.o cfg.o

# ����ʱ�õ��Ĺ���
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
## SMDK4X12 Ϊarmv7�汾

./configure --without-pam --without-ssl --build=armv7 --host=arm CC=/opt/arm-2014.05/bin/arm-none-linux-gnueabi-gcc libmonit_cv_setjmp_available=no libmonit_cv_vsnprintf_c99_conformant=no

1��--bulid=armv7 ��һ��Ҫ�ģ�����Ŀ��CPU��arm7�ܹ���
2��--host=arm �����һ��������     
3��CC ����ָ����arm����

--host=arm    ## arm-unknown-none
--bulid=armv7 ## armv7-unknown-none

��ɺ� ��ִ�� make install ����ɣ�Ĭ�ϰ�װ��/usr/local/bin �£�
��ʵmakeͨ���������Ѿ��õ� monit����� monit.rc�ļ��ˣ������Ķ����Դ�Ŀ¼���ҵ���

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
--host=arm-hik_v7a-linux-uclibcgnueabi      ## arm-none-linux-gnueabi-gcc -v | grep target ��Ӧ����
--target=arm-hik_v7a-linux-uclibcgnueabi    ## arm-none-linux-gnueabi-gcc -v | grep target ��Ӧ����
--cache-file=arm-hik_v7a-linux-uclibcgnueabi.cache 
prefix=$HOME/cdvs_bin_for_arm 
--program-prefix="tm-" CFLAGS="${CFLAGS}" CXXFLAGS="${CFLAGS}"


    --srcdir=DIR 
    ���ѡ��԰�װû������.�������'configure'Դ���λ��.һ����˵����ָ����ѡ��,
    ��Ϊ'configure'�ű�һ���Դ���ļ���ͬһ��Ŀ¼��. 
    
    --program-prefix=PREFIX 
    ָ�������ӵ�����װ����������ϵ�ǰ׺.����,ʹ��'--program-prefix=g'��configureһ����Ϊ'tar'
    �ĳ��򽫻�ʹ��װ�ĳ�������Ϊ'gtar'.���������İ�װѡ��һ��ʹ��ʱ,���ѡ��ֻ�е�����
    'Makefile.in'�ļ�ʹ��ʱ�ŻṤ��.
    
    --program-suffix=SUFFIX 
    ָ�������ӵ�����װ����������ϵĺ�׺. 
    
    --program-transform-name=PROGRAM 
    �����PROGRAM��һ��sed�ű�.��һ�����򱻰�װʱ,�������ֽ�����`sed -e PROGRAM`��������װ������. 
 
######## 
    --build
    ����ָ�����Ǳ������������build�Ĺ��̵Ļ����ṹ��������������i386-pc-linux-gnu

    --host
    ����ָ���������ɿ�ִ���ļ������л��� arm-hik_v7a-linux-uclibcgnueabi ��Ҳ���������õĽ�����������ߵ�ǰ׺���������������ļ��е����� ����Щ����һ�µ�

    --target
    ����Ŀ����Ļ�����ͬhost��
######   
    --target=GARGET 
    ָ���������(target to)��ϵͳƽ̨.����Ҫ�ڳ������Թ�����������ͻ������������������.���û��ָ��,Ĭ�Ͻ�ʹ��'--host'ѡ���ֵ. 
    
    --disable-FEATURE 
    һЩ���������ѡ�����ѡ�����ṩΪ����ѡ��ı���ʱ����,����ʹ��Kerberos��֤ϵͳ����һ��ʵ���Եı�������������.���Ĭ�����ṩ��Щ����,����ʹ��'--disable-FEATURE'��������,����'FEATURE'�����Ե�����
}

cross_compile(boa)
{
���ص�ַ: http://www.boa.org/
tar xzf boa-0.94.13.tar.gz
./configure

CC = /home/tekkamanninja/working/source/2.95.3/bin/arm-linux-gcc
CPP = /home/tekkamanninja/working/source/2.95.3/bin/arm-linux-gcc -E

[tekkamanninja@Tekkaman-Ninja src]$ make
[tekkamanninja@Tekkaman-Ninja src]$ /home/tekkamanninja/working/source/2.95.3/bin/arm-linux-strip boa
[tekkamanninja@Tekkaman-Ninja src]$ cp boa /home/tekkamanninja/working/nfs/rootfs/bin/

## ����Boa
[tekkamanninja@Tekkaman-Ninja source]$ cd ../nfs/rootfs/etc/
[tekkamanninja@Tekkaman-Ninja etc]$ mkdir boa
[tekkamanninja@Tekkaman-Ninja etc]$ chmod 777 boa/
[tekkamanninja@Tekkaman-Ninja etc]$ cd boa
[tekkamanninja@Tekkaman-Ninja boa]$ kwrite boa.conf

1��Group���޸�
�޸� Group nogroup
Ϊ Group user�����������е��飩
�޸� User nobody
Ϊ User boa ��user���е�һ����Ա��
������Ŀ����������趨��һ��Ҫ���ڵ�����û���

adduser -g user boa

2��ScriptAlias���޸�

�޸� ScriptAlias /cgi-bin/  /usr/lib/cgi-bin/
Ϊ ScriptAlias /cgi-bin/  /var/www/cgi-bin/

����������CGI��Ŀ¼����Ҳ�������óɱ��Ŀ¼�������û��ļ����µ�ĳ��Ŀ¼��

3��ServerName������
�޸� #ServerName www.your.org.here
Ϊ ServerName www.your.org.here
ע�⣺����Ĭ��Ϊδ�򿪣�ִ��Boa���쳣�˳�����ʾ"gethostbyname::No such file or directory",���Ա���򿪡�����Ĭ�����ü��ɡ���Ҳ��������Ϊ���Լ���Ҫ�����֡�����������Ϊ��ServerName tekkaman2440
���⣬����Ҫ��
��mime.types�ļ�����/etcĿ¼�£�ͨ�����Դ�linux������ /etcĿ¼��ֱ�Ӹ��Ƽ��ɡ�
���������ú�boa.conf�������йأ�
������־�ļ�����Ŀ¼/var/log/boa
����HTML�ĵ�����Ŀ¼/var/www
����CGI�ű�����¼ /var/www/cgi-bin


cp /etc/mime.types etc/

boa

�������boaû�����У�������ڿ������/var/log/boa/error_log�ļ�����ԭ��

[tekkamanninja@Tekkaman-Ninja source]$ vi helloworldCGI.c
[tekkamanninja@Tekkaman-Ninja source]$ cp helloworldCGI ../nfs/rootfs/var/www/cgi-bin/

3.����
���������
   http://192.168.1.2/cgi-bin/helloworldCGI

��ҳ���� Hello,world. ���Գɹ���
}


cross_compile(lighttpd)
{
tar xjvf lighttpd-1.4.18.tar.bz2
CC=/home/tekkamanninja/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-gcc ./configure -prefix=/lighttpd  -host=arm-9tdmi-linux-gnu --disable-FEUTARE -disable-ipv6 -disable-lfs  

make
make install

[tekkamanninja@Tekkaman-Ninja lighttpd-1.4.18]$ cp doc/lighttpd.conf  /home/tekkamanninja/working/nfs/rootfs/etc/

[tekkamanninja@Tekkaman-Ninja lighttpd-1.4.18]$ kwrite  /home/tekkamanninja/working/nfs/rootfs/etc/lighttpd.conf 

�����޸ĵĵط��У�

    server.document-root        = "/srv/www/htdocs/"
��Ϊserver.document-root        = "/home/lighttpd/html/"

������Լ����壬�����������web����ĸ�Ŀ¼��

����һ����䣬��ȻǶ��ʽ������Сϵͳ�¿����޷�����
#$HTTP["url"] =~ "\.pdf$" {
#  server.range-requests = "disable"
#}

����������Ҫ��Щ��̬�⣺
[tekkamanninja@Tekkaman-Ninja lighttpd-1.4.18]$ ~/working/gcc4.1.1/gcc-4.1.1-glibc-2.3.2/arm-9tdmi-linux-gnu/bin/arm-9tdmi-linux-gnu-readelf -d src/lighttpd

������̬�⣺
�����������
adduser -g user lighttpd
HOST ������
[root@Tekkaman-Ninja lighttpd]# mkdir html
[root@Tekkaman-Ninja lighttpd]# chmod 777 html/
[root@Tekkaman-Ninja lighttpd]# mkdir  ../../var/log/lighttpd
[root@Tekkaman-Ninja lighttpd]# chmod 777 ../../var/log/lighttpd

����ֲ�õĳ�������Ŀ¼�����а�����bin��sbin��lib��shareĿ¼����������������ļ�ϵͳ�ĸ�Ŀ¼�£�
[root@Tekkaman-Ninja lighttpd]# mv /lighttpd   /home/tekkamanninja/working/nfs/

�ġ����г���
�ڿ������ϲ�����
[root@~]#/lighttpd/sbin/lighttpd -f /etc/lighttpd.conf

}
