https://blog.csdn.net/changexhao/article/details/78321295 # Linux�ں˵�����ܹ����
https://blog.csdn.net/fivedoumi/article/details/7521242   # �������Linux�ں�
https://www.linuxidc.com/Linux/2013-10/92120p5.htm        # ���ĵ�Linux�ں�ר��
instance(){
���ز���ѹ�ں˵�����Ŀ¼
	~$ tar xjvf linux-3.0.4.tar.bz2
    
�����ں�    
    ~/linux-3.0.4
    $sudo apt-get install libncurses5-dev
    ~/linux-3.0.4
    $sudo make menuconfig    
   
����
   ~/linux-3.0.4$sudo make -j4
   
��װ
	~/linux-3.0.4$sudo make modules_install
	~/linux-3.0.4$sudo make install
    
1.�������ں�ʱ���ɵ��ں˾���bzImage������/bootĿ¼�£����������������Ϊvmlinuz-3.0.4�����ʹ��x86��cpu����þ���λ��arch/x86/boot/Ŀ¼�£��������ڱ�����ں�Դ���£���
2.��~/linux-3.0.4/Ŀ¼�µ�System.map������/boot/Ŀ¼�£���������ΪSystem.map-3.0.4�����ļ��д�����ں˵ķ��ű�
3.��~/linux-3.0.4/Ŀ¼�µ�.config������/boot/Ŀ¼�£���������Ϊconfig-3.0.4��   

����initrd.img�ļ�
    ~/linux-3.0.4$sudo mkinitramfs 3.0.4 -o /boot/initrd.img-3.0.4  

����grub
���һ�����Ǹ���grub�����˵���ʹ�����������������Զ����������˵���
	sudo update-grub2
}

compile(��װ�����ܽ�){
��׼:
make && make modules && make install && make modules_install

��һ�����µİ汾������������ں�:
zcat /proc/config.gz >.config && make && make modules && make install && make modules_install

�������:
make ARCH={TARGET-ARCHITERCTURE} CROSS_COMPILE={COMPILER};
make ARCH={TARGET-ARCHITERCTURE} CROSS_COMPILE={COMPILER} modules && make install && make modules_install
}


image(){
vmlinux��
һ����ѹ���ģ���̬���ӵģ���ִ�еģ�����bootable��Linux kernel�ļ�������������vmlinuz���м䲽�衣

vmlinuz��
һ��ѹ���ģ���bootable��Linux kernel�ļ���vmlinuz��Linux kernel�ļ�����ʷ���֣���ʵ���Ͼ���zImage��bzImage��

[root@Fedora boot]# file vmlinuz-4.0.4-301.fc22.x86_64
vmlinuz-4.0.4-301.fc22.x86_64: Linux kernel x86 boot executable bzImage, version 4.0.4-301.fc22.x86_64 (mockbuild@bkernel02.phx2.fedoraproject.o, RO-rootFS, swap_dev 0x5, Normal VGA
zImage��
��������640k�ڴ��Linux kernel�ļ���

bzImage��
Big zImage�������ڸ����ڴ��Linux kernel�ļ���

�ܽ�һ�£������ִ�Linuxϵͳʱ��ʵ�����еļ�ΪbzImage kernel�ļ���
}

mkimage(){
[uboot�ľ���·��]/tools/mkimage -A arm -O linux -C gzip -a 0x20008000 -e 0x20008000 -d linux.bin.gz uImage # ����ľ���·����/usr/local/uboot
vmlinux linux.bin linux.bin.gz uImage(uboot������image)
mkimage -a -e
-a���������ں˵����е�ַ��-e����������ڵ�ַ��

Usage: ./mkimage -l image
-l ==> list image header information
./mkimage -A arch -O os -T type -C comp -a addr -e ep -n name -d data_file[:data_file...] image
-A ==> set architecture to 'arch'
-O ==> set operating system to 'os'
-T ==> set image type to 'type'
-C ==> set compression type 'comp'
-a ==> set load address to 'addr' (hex)
-e ==> set entry point to 'ep' (hex)
-n ==> set image name to 'name'
-d ==> use image data from 'datafile'
-x ==> set XIP (execute in place)
����˵����

-A ָ��CPU����ϵ�ṹ��
ȡֵ ��ʾ����ϵ�ṹ
alpha Alpha
arm A RM
x86 Intel x86
ia64 IA64
mips MIPS
mips64 MIPS 64 Bit
ppc PowerPC
s390 IBM S390
sh SuperH
sparc SPARC
sparc64 SPARC 64 Bit
m68k MC68000

-O ָ������ϵͳ���ͣ�����ȡ����ֵ��
openbsd��netbsd��freebsd��4_4bsd��linux��svr4��esix��solaris��irix��sco��dell��ncr��lynxos��vxworks��psos��qnx��u-boot��rtems��artos

-T ָ��ӳ�����ͣ�����ȡ����ֵ��
standalone��kernel��ramdisk��multi��firmware��script��filesystem

-C ָ��ӳ��ѹ����ʽ������ȡ����ֵ��
none ��ѹ��
gzip ��gzip��ѹ����ʽ
bzip2 ��bzip2��ѹ����ʽ

-a ָ��ӳ�����ڴ��еļ��ص�ַ��ӳ�����ص��ڴ���ʱ��Ҫ������mkimage����ӳ��ʱ�����������ָ���ĵ�ֵַ������
-e ָ��ӳ�����е���ڵ��ַ�������ַ����-a����ָ����ֵ����0x40����Ϊǰ���и�mkimage��ӵ�0x40���ֽڵ�ͷ��
-n ָ��ӳ����
-d ָ������ӳ���Դ�ļ�
}

make���������ں�Makefile��ִ�С�Makefile�������̿��ƺ����ÿ��ơ�
���̿���ͨ�����������������ã����ÿ���ͨ��Kconfig����.config�������á�

make���̿��ƣ�����λ�õ��趨���ں˰汾���趨���ں˵Ĺ����������
make���ÿ��ƣ�.config�ļ������� [make menuconfig; make xconfig; make config]

��scripts/kconfig/���ɿ�ִ���ļ���
make config;      conf       autoconfig.h
make nconfig;     nconfig    autoconfig.h
make menuconfig;  mconfig    autoconfig.h
make xconfig;     xconfig    autoconfig.h
make gconfig;     gconfig    autoconfig.h  

https://www.linuxidc.com/Linux/2013-10/92120.htm # ���ĵ�Linux�ں�ר��

help(����˵��){
    make ARCH=x86_64 defconfig
    make ARCH=x86_64 help
    make ARCH=arm help
    make CC="ccache gcc"
    make CC="ccache distcc"

    ������ʾ��Ϣ�Ĺ���Ŀ�꣺�ű���������Щ��Ϣȷ���ں˰汾��Ϣ��
    kernelrelease: ���ڽ�ϵͳȷ������ʾ��ǰ�ں˰汾��
    kernelversion: ������Makefile��ʾ��ǰ�ں˰汾����kernelrelease����Ŀ�겻ͬ���ǣ�
                   ������ʹ���κλ�������ѡ���汾�ļ��ĸ�����Ϣ

    
    ��� 
    clean:     ɾ���ں˹���ϵͳ�����󲿷��ļ������ǣ������ں����ã���Ȼ�ܹ������ⲿģ�顣
    mrproper:  ɾ���ں˹���ϵͳ�����������ļ������������ļ��͸��ֱ����ļ���
    distclean :�ָ�ϵͳ����ԭʼ��״̬������mrproper�⣬����ɾ������patch����cscope��tag��
               ִ��mrproper������һ�У���ɾ���༭�������ļ��Ͳ��������ļ���

    make M=dir clean
    
1�����.config�����ڣ�����make config/menuconfigʱ��ȱʡ�����ɹ̻��ڸ���Kconfig�ļ��и���Ŀ��ȱʡֵ������
2. ���.config���ڣ�����make config/menuconfigʱ��ȱʡ���ü��ǵ�ǰ.config�����ã��������ý������޸�,.config�������¡�
3. �ڰ�һ���ϰ汾kernel��.config�ļ�������һ���°汾��kernelԴ�����ļ��к�Ҫִ�С�make oldconfig��������������Ǽ��
   ���е�.config�ļ���Kconfig�ļ��Ĺ����Ƿ�һ�£����һ�£���ʲô��������������ʾ�û���ЩԴ�������е�ѡ����.config�ļ�û�С�
    
    ����   %config, config, menuconfig, xconfig gconfig nconfig [����Kconfig���Բ�ͬ�����������ںˡ�]
           oldconfig         ʹ�û��ڵ�ǰ��.config�ļ������ں����ã�����ʾ�ں���ӵ���ѡ�
                             CONFIG_IKCONFIG_PROC  /proc/config.gz > .config
                             # make oldconfig�������Ǳ��ݵ�ǰ.config�ļ�Ϊ.config.old��
                             # ����make config/menuconfig���ò��������ڻָ���ǰ��.config
                             = ���ı����棬������Ĭ�ϵ������ǻ������еı��������ļ���
           silentoldconfig  ��oldconfig��ͬ�����ǳ�������ѡ����򲻴�ӡ�κζ���
һ������һ�����Թ��������ã�����Ψһ��Ҫ���ľ��Ǹ������°汾�ں���ӵ�ѡ���������
Ҫ������һ�㣬Ӧ��ʹ��make oldconfig �� make silentoldconfig��ʽ��
                            = ��oldconfig���ƣ����ǲ�����ʾ�����ļ������е�����Ļش�
           olddefconfig     = ��silentoldconfig���ƣ�����Щ�����Ѿ������ǵ�Ĭ��ֵѡ��
           randconfig       ʹ��������ɵ��ں�����
           defconfig        ʹ������ѡ���Ĭ��ֵ�����ں����á�Ĭ��ֵ������arch/$ARCH/defconfig�ļ���
           # arch/arm/defconfig��һ��ȱʡ�������ļ���make defconfigʱ���������ļ����ɵ�ǰ��.config��
                            = ���ѡ��ᴴ��һ���Ե�ǰϵͳ�ܹ�Ϊ������Ĭ�������ļ���
            ${PLATFORM}defconfig = ����һ��ʹ��arch/$ARCH/configs/${PLATFORM}defconfig�е�ֵ�������ļ���
           allmodconfig     �����ں����ã������п��ܵ�ѡ�����ģ��
           allyesconfig     ��������ѡ��ȫ��ѡ���ǵ��ں�����
           allnoconfig      ��������ѡ��ȫ��ѡ�����ں�����
randconfig��allmodconfig��allyesconfig��allnoconfigĿ��Ҳʹ�û�������KCONFIG_ALLCONFIG������������ָ��һ���ļ������ļ���������ѡ��ֵ�б�
���û��KCONFIG_ALLCONFIG����������ϵͳ����鶥��buildĿ¼�е������ļ���allmod.config,allno.config,allrandom.config,allyes.config��
�����������һ���ļ����ڣ�����ϵͳ��������Ϊǿ��ʹ�õ�ѡ��ֵ�б�
           localmodconfig - ���ѡ�����ݵ�ǰ�Ѽ���ģ���б��ϵͳ���������������ļ���
           localyesconfig - �����п�װ��ģ�飨LKM����������ں�(

           make xxx_defconfig
# arch/arm/configs�ļ��������������Ϊxxx_defconfig�������ļ����������make xxx_defconfig����ǰ.config�ļ�����xxx_defconfig�ļ����ɡ�

    ����   all            ����vmlinux�ں�ӳ����ں�ģ�飻
	       vmlinux        ����vmlinux�ں�ӳ�񣻲������κοɼ���ģ��
		   modules        �����ں�ģ��
           
           dir/              ����ָ��Ŀ¼������Ŀ¼�µ������ļ� 
           dir/file.[o|i|s]  ������ָ�����ļ�
           dir/file.ko        �������б�����ļ������������ӳ�ָ��ģ��
           
    ��װ   headers_install��װ�ں�ͷ�ļ�/ģ��
		   modules_install��װ�ں�ͷ�ļ�/ģ��
           
           make M=dir modules_install
           
    V=0    ���߹���ϵͳ�Ծ�̬��ʽ���У�������ʾ��ǰ���ڹ������ļ������ǹ����ļ������������ѡ���ǹ���ϵͳ��Ĭ����Ϊ��
    V=1    �˱������߹���ϵͳ�����෽ʽ���У�����ʾ���ڹ��������ļ�����������
    O=dir  ���߹���ϵͳ�������ļ������dirĿ¼�У������ں������ļ���
    make O=~/linux/linux-2.6.30
    C=1    ʹ�ں˹���ϵͳ��sparse���߼�����н���������CԴ�ļ����Է�ֹ������̴���
    C=2     ǿ��ʹ��sparse���߼������CԴ�ļ�
    -j      �ദ��������ִ��
    
    Դ�����
        tags               ���ɴ��������������Ҫ���ļ�
           TAGS
           cscope   
    ��̬����
          checkstack   ��鲢�����ں˴���
          namespacecheck
          headers_check	   
    �ں˴��      %pkg    �Բ�ͬ�İ�װ��ʽ�����ں�
    �ĵ�ת��      %doc    ��kernel�ĵ�ת�ɲ�ͬ��ʽ 
    
    ������أ���armΪ����
            bzImage  ����һ��������arch/i386/boot/bzImage�ļ��ڵ�ѹ���ں˾��񣬱�ѡ����i386�ܹ�����ʱ��Ĭ�Ϲ���Ŀ��
            zImage  ����ѹ�����ں�ӳ��
            uImage  ����ѹ����u-boot���������ں�ӳ��
            bzdisk  ����һ�����̾��񣬲�д��/dev/fd0�豸
            fdimage ��arch/i386/boot/fdimage����һ�������������̾���Ϊʹ������������ϵͳ�б��밲װmtools����
            isoimage ��arch/i386/boot/image.iso����һ��������CD-ROM����Ϊʹ������������ϵͳ�б��밲װsyslinux����
            install ʹ�÷��а��ṩ��/sbin/installkernel����װ�ںˣ����ᰲװ�ں�ģ�飬�˲�����Ҫʹ��modules_install����Ŀ����ɡ�
            
    ģ��
make M=dir clean            Delete all automatically generated files
make M=dir modules          Make all modules in specified dir
make M=dir                  Same as 'make M=dir modules'
make M=drivers/usb/serial   #����.ko�ļ������ܸ�Ŀ¼���ж��.ko�ļ�
make M=dir modules_install

make dir/                   ���뵥��Ŀ¼,����������Ŀ¼��
make drivers/usb/serial     #����.o�ļ�

make dir/file.[ois]         ���뵥���ļ�
make dir/file.ko            ���뵥��ģ��
make drivers/usb/serial/visor.ko #�����ض���ģ���ļ�

��������Ĺ���Ŀ¼
    rpm         ���ȹ����ںˣ�Ȼ�����ɿɹ���װ��RPM��
    rpm-pkg     ���������ں�Դ�����RPMԴ���
    binrpm-pkg  ���������ѱ����ں˺�ģ���RPM��
    deb-pkg     ���������ѱ����ں˺�ģ���Debain��ʽ�İ�
    tar-pkg     ���������ѱ����ں˺�ģ���tarball tar��ʽ
    targz-pkg   ���������ѱ����ں˺�ģ���tarball targz��ʽ
    tarbz2-pkg  ���������ѱ����ں˺�ģ���tarball tarbz2��ʽ

���������ĵ��Ĺ���Ŀ¼
xmldocs��psdocs��pdfdocs��htmldocs��mandocs

    
--------ƽ̨��صı���
��������ѡ��
LDFLAGS ͨ��$(LD)ѡ��
LDFLAGS_MODULE ����ģ��ʱ����������ѡ��
LDFLAGS_vmlinux ����vmlinuxʱ��ѡ��
OBJCOPYFLAGS objcopy flags
AFLAGS $(AS) ��������ѡ��
CFLAGS $(CC) ������ѡ��
CFLAGS_KERNEL $(CC) built-in ѡ��
CFLAGS_MODULE $(CC) modulesѡ��     

make V=0|1 [targets] 0 => quiet build (default), 1 => verbose build
make V=2 [targets] 2 => give reason for rebuild of target
make O=dir [targets] Locate all output files in "dir", including .config
make C=1 [targets] Check all c source with $CHECK (sparse by default)
make C=2 [targets] Force check of all c source with $CHECK
make -C=KERNELDIR M=dir modules �����ⲿģ��
make -C=KERNELDIR SUBDIRS=dir modules ͬ�ϣ�SUBDIRS���ȼ�����M

}

key(�ؼ���)
{
	1. ���ɵ�zImage�ں˵�λ����arch/arm/bootĿ¼��
	2. �ں˸�Ŀ¼�µ�vmlinuxӳ���ļ����ں�Makefile��Ĭ��Ŀ�ꡣ
	3. ���ǿ��Կ�һ��vmlinux��arch/i386/boot/compressed/vmlinux����file�����
		��������Ҳ��elf��ִ���ļ���ֻ��û��main��������.
	4. ��Kconfigϵͳ����.config��Kbuild ������.config����ָ����Ŀ�ꡣ
	   Kconfig���Կ���Kbuildִ�еĹ����п��Դ򿪵�ѡ��ȫ�����ϣ���.config����Kconfigѡ��ϵĵ���ѡ��ϡ�
	   Kconfig��ɢ���ں�Դ����ĸ���Ŀ¼�С�
	5. .config��Makefile�������ļ�����ͨ��make *configͨ���������ɵġ�Makefile��Kconfig��ʾ��Makefile���������ÿ��ء�
	   .config��Makefile�����ļ������ÿ����Ӽ���make��������Makefileִ�д�����롣
	6. scriptsĿ¼�µı�������ļ�����Ŀ¼�µ�C�����������������������Ҫ������  

key(patch)
{
Document/applying-patchs.txt

�ں˲����ļ����ڽ��ں˴�һ���ض��汾��������һ���汾��
1���ȶ����ں˲���Ӧ�������ں˰汾������ζ��2.6.29.5����ֻ��Ӧ����2.6.29�汾�ںˣ�
   2.6.29.5�ں˲�������Ӧ����2.6.29�ں˻������İ汾��
2�����ں˰汾����ֻ��Ӧ������һ�����ں˰汾������ζ��2.6.30����ֻ��Ӧ����2.6.29�汾���ں�
   ����Ӧ����2.6.29.y�ں˰汾�������ں˰汾
3�������������ں˴�һ���ض��汾���µ���һ���汾�����������߰����µ��ȶ��汾��������һ���汾
�������Ƚ����ںˣ�Ȼ����������

���磺
ftp.kernel.org/pub/linux/v2.6/incr
2.6.29.4 -> 2.6.29.6 #��Ҫ2.6.29.4 �� 2.6.29.5 �� 2.6.29.4 �� 2.6.29.6�Ĳ�����

���磺
2.6.22.9 -> 2.6.23.9 #2.6.22.9��Ҫ������2.6.22 Ȼ��������2.6.23.��������2.6.23.9
bzcat ../patch-2.6.22.9.bz2|patch -p1 -R #ʹ��R������˼��ȡ���������������ǾͰ�22.9 ���� 22
zcat ../patch-2.6.23.gz|patch -p1 #��������������2.6.23
bzcat ../patch-2.6.23.11.bz2|patch -p1 # ��������������2.6.23.11 ��������stable�����°档

���磺

}   
key(upgrade)
{
����ӿ�ʵ��
basename `readlnk /sys/class/net/eth0/device/driver/module`
find -type f -name Makefile | xargs grep e1000
make menuconfig # /E1000

USB�ӿ�ʵ��
ls /sys/class/tty/  | grep USB
basename `readlink /sys/class/tty/ttyUSB0/device/driver/module`
find -name -type f -name Makefile | grep xargs grep pl2303

#!/bin/bash
#
# find_all_modules.sh
#

for i in `find /sys/ -name modalias -exec cat {} \ ; ` ; do
    /sbin/modprobe --config /dev/null --show-depends $i ;
done | rev | cut -f 1 -d '/' | rev | sort -u    

PCI����ʵ��
lspci | grep -i ethernet
cd /sys/bus/pci/devices/ && ls
cd 0000:06:04.0
cat vendor #0x10ec
cat device #0x8139
grep -i 0x10ec include/linux/pci_ids.h
grep -i 0x8139 include/linux/pci_ids.h

grep -Rl PCI_VENDOR_ID_REALTEK *

}

}

doc(Linux�ں˵�Makefile)
{
http://cxd2014.github.io/2015/11/11/Linux-Makefile/

doc(����)
{
Linux��Makefile�У������֣�

Makefile ����Makefile�ļ�
1. .config �ں������ļ�
2. arch/$(ARCH)/Makefile �ܹ���ص�Makefile
3. scripts/Makefile.* ����kbuild��Makefiles�ļ���ͨ�ù����
4. kbuild Makefiles �ں�����500���������ļ�
5. ����Makefile��ȡ�������ں�ʱ�õ���.config�ļ���

    ����Makefile�������������Ҫ�ļ���vmlinux�����е��ں�ӳ�񣩺�modules���κ�ģ���ļ�����
    ��ͨ���ݹ�����ں�Դ��������Ŀ¼�¹���Ŀ�ꡣ
    ��Ҫ�������Ŀ¼�б��������ں����ã�����Makefile�������һ��arch/$(ARCH)/Makefile�ܹ��µ�Makefile�ļ���
����ܹ��µ�Makefile�ṩ�ܹ���ص���Ϣ������Makefile��
    ÿ����Ŀ¼����һ��kbuild Makefile��ִ�д����洫��������������kbuild Makefileʹ��.config�ļ�����Ϣ��
����kbuild����built-in�����ã���modular��ģ�飩Ŀ������Ҫ���ļ��б�
    scripts/Makefile.*�������и���kbuild makefiles�ļ��������ں�ʱ����Ҫ�Ķ���͹���ȵȡ�
}

doc(˭��ʲô)
{
    �ں�Makefile�ļ����ڲ�ͬ���������ֲ�ͬ�Ĺ�ϵ��
    
    Users�����ں˵��ˡ���Щ��ʹ������make menuconfig����make�������ͨ�������Ķ����߱༭�κ��ں�Makefile�ļ�
�����κ�Դ���ļ�����
    Normal developers����ĳһ���Ե������豸�������ļ�ϵͳ������Э�顣��Щ����Ҫά�����ǹ�������ϵͳ��kbuild Makefile
�ļ���Ϊ����Ч������Щ����������Ҫ�˽��ں�����Makefile�ṹ��֪ʶ����kbuild�����ӿڵ�ϸ��֪ʶ��
    Arch developers���������ܹ���ϵ���ˣ�����is64����sparc�ܹ����ܹ���������Ҫ�˽⡡arch Makefile��kbuild Makefiles��
    Kbuild developers�����ں˹���ϵͳ������ˣ���Щ����Ҫ�˽������ں�Makefiles��ϸ�ڡ�
    ����ĵ���Ŀ�������Normal developers��Arch developers��
}

doc(kbuild�ļ�)
{
�ں��еĴ����Makefile�ļ���kbuild Makefiles����kbuild�Ļ��������½���kbuild makefiles��ʹ�õ��﷨֪ʶ��
kbuild�ļ�����ѡ������Makefile����KbuildҲ����ʹ�ã���Makefile��Kbuildͬʱ����ʱKbuild�ᱻʹ�á�

doc_kbuild(Ŀ�궨��)
{
Ŀ�궨����kbuild Makefile����Ҫ���֣����ģ�����������Щ�ļ������룬��Щ�������ѡ���Щ��Ŀ¼��ݹ���롣

��򵥵�kbuild makefile����һ�У�

obj-y += foo.o
������kbuild���Ŀ¼��һ������Ϊfoo.o��Ŀ�꣬���Ŀ������foo.c����foo.S�ļ������롣 
���foo.o��������Ϊģ�飬ʹ��obj-m���������������Ӿ���ʹ�ã�

obj-$(CONFIG_FOO) += foo.o
$(CONFIG_FOO)����Ϊy�����ã�����m��ģ�飩�� ���CONFIG_FOO�Ȳ���y��m,����ļ����ᱻ��������ӡ�
}

doc_kbuild(����Ŀ�� - obj-y)
{
    kbuild Makefileͨ��$(obj-y)�б�ָ��Ŀ���ļ����뵽vmlinux����Щ�б��������ں����á�

    Kbuild��������$(obj-y)�ļ���Ȼ�����$(LD) -r����Щ�ļ����Ϊbuilt-in.o�ļ���built-in.o�Ժ�ᱻ��Makefile���ӵ�
vmlinux�С�

    $(obj-y)�ļ���˳����������ģ��б��е��ļ������ظ�����һ��ʵ���ᱻ���ӵ�built-in.o�У�ʣ�µĻᱻ���ԡ�

    ����˳����������ģ���ΪĳЩ����module_init() / __initcall������ʱ�ᰴ���ǳ��ֵ�˳�򱻵��á�����Ҫ��ס�ı�����
˳����ܡ����磺��ı�SCSI�������ļ��˳�򣬵��´��̱����±�š�

# #drivers/isdn/i4l/Makefile
# # Makefile for the kernel ISDN subsystem and device drivers.
# # �ںˡ�ISDN����ϵͳ���豸������Makefile
# # Each configuration option enables a list of files.
# # ÿһ������ѡ��ʹ��һ���б��е��ļ�
# obj-$(CONFIG_ISDN_I4L)         += isdn.o
# obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
}

doc_kbuild(�ɼ��ص�Ŀ�� - obj-m)
{
$(obj-m)ָ��Ŀ���ļ�������Ϊ�ɼ��ص��ں˵�ģ�顣

һ��ģ�������һ��Դ�ļ����߼���Դ�ļ�������ɡ���ֻ��һ��Դ�ļ�ʱ��kbuild makefile�򵥵�ʹ��$(obj-m)�����롣����:

#drivers/isdn/i4l/Makefile
obj-$(CONFIG_ISDN_PPP_BSDCOMP) += isdn_bsdcomp.o
ע�⣺�������$(CONFIG_ISDN_PPP_BSDCOMP)��ֵΪm

����ں�ģ�����ɼ���Դ�ļ�������ɵģ�����ʹ��������ͬ�ķ�������ģ�飬����kbuild��Ҫ֪����ЩĿ���ļ�������Ҫ�����ģ���У������㲻�ò�ͨ������$(<module_name>-y)������������������:

#drivers/isdn/i4l/Makefile
obj-$(CONFIG_ISDN_I4L) += isdn.o
isdn-y := isdn_net_lib.o isdn_v110.o isdn_common.o
����������У�ģ��������isdn.o��Kbuild�����$(isdn-y)�г�������Ŀ���ļ�Ȼ��ִ��$(LD) -rʹ��Щ�ļ�����isdn.o�ļ���

����kbuild����ʶ��$(<module_name>-y)���ϳ�Ŀ�꣬�����ʹ��CONFIG_���ŵ�ֵ��ȷ��ĳЩĿ���ļ��Ƿ���Ϊ�ϳ�Ŀ���һ���֡�����:

����kbuild����ʶ��$(<module_name>-y)���ϳ�Ŀ�꣬�����ʹ��CONFIG_���ŵ�ֵ��ȷ��ĳЩĿ���ļ��Ƿ���Ϊ�ϳ�Ŀ���һ���֡�����:

#fs/ext2/Makefile
    obj-$(CONFIG_EXT2_FS) += ext2.o
	ext2-y := balloc.o dir.o file.o ialloc.o inode.o ioctl.o \
			namei.o super.o symlink.o
    ext2-$(CONFIG_EXT2_FS_XATTR) += xattr.o xattr_user.o \
			xattr_trusted.o
����������У�xattr.o, xattr_user.o �� xattr_trusted.oֻ�Ǻϳ�Ŀ��ext2.o��һ���ֵ�$(CONFIG_EXT2_FS_XATTR)��ֵ��yʱ��

ע�⣺��Ȼ���������Ŀ�굽�ں���ȥ�������﷨Ҳ�ǿ����õġ���ˣ����CONFIG_EXT2_FS=y��kbuild�����һ��ext2.o�ļ�Ȼ�����ӵ�built-in.o�ļ��У��������������ġ�
}

doc_kbuild(���ļ� - lib-y)
{
obj-*�г���Ŀ���ļ�����ģ����ߺϳ�Ϊ�ض�Ŀ¼�µ�built-in.o�ļ���Ҳ�п��ܱ��ϳ�Ϊһ����lib.a��
lib-y�г��������ļ����ϳ�Ϊ��Ŀ¼�µ�һ�����ļ��� 
obj-y�г���Ŀ���ļ������������ļ����ᱻ�����ڿ��У���Ϊ���ǻ����κ�ʱ�򱻷��ʡ� 
Ϊ�˱���һ����lib-m�г����ļ��������lib.a�ļ��С�

ע����ͬ��kbuild��makefile������ļ���built-in�ļ��к�һ���ֵ����ļ��С� �����ͬ��Ŀ¼����ͬʱ����built-in.o�ļ���lib.a�ļ�����:

#arch/x86/lib/Makefile
lib-y    := delay.o
������delay.o����lib.a���ļ�������kbuild����ʶ������һ��lib.a�ļ������룬 ���Ŀ¼�ᱻ��Ϊlibs-y���μ���6.3�ڡ�

lib-yһ�������ʹ����lib/��arch/*/libĿ¼�С�

}

doc_kbuild(Descending down in directories)
{
һ��Makefile�ļ�ֻ������뱾Ŀ¼�µ�Ŀ�꣬��Ŀ¼�µ��ļ�����Ŀ¼�µ�Makefiles���𡣱���ϵͳ���Զ��ݹ������Ŀ¼������make������Ҫ֪����һ�㡣

Ҫ������һ��obj-y��obj-m�ᱻʹ�á�ext2�ֲ���һ��������Ŀ¼�У�fs/Ŀ¼�µ�Makefile����kbuildʹ��������������Ŀ¼������:

#fs/Makefile
obj-$(CONFIG_EXT2_FS) += ext2/
���CONFIG_EXT2_FS������Ϊy����m����Ӧ��obj-�����ᱻ���ã�Ȼ��kbuild�����ext2Ŀ¼��Kbuildֻ��ʹ����Щ��Ϣ�������Ƿ���Ҫ�����Ŀ¼��Ȼ����Ŀ¼�е�Makefileָ����Щ��Ҫ����Ϊģ�飬��Щ��Ҫ����Ϊbuilt-in��

ʹ��CONFIG_����ָ��Ŀ¼�����Ƿǳ��õ������������ʹkbuild������ЩCONFIG_ѡ���y ��m��Ŀ¼��
}


doc_kbuild(�����־)
{
ccflags-y, asflags-y��ldflags-y

��������־ֻ�����ڱ������kbuild makefile�ļ����������������ݹ����ʱ����cc���������� ��ld����������ʱ�� 
ע�⣺������ǰʹ�õ�EXTRA_CFLAGS, EXTRA_AFLAGS��EXTRA_LDFLAGS������־��������Ȼ����ʹ�õ��ǹ�ʱ�ˡ�

ccflags-yָ��$(CC)�ı���ѡ�����:

# drivers/acpi/Makefile
ccflags-y := -Os
ccflags-$(CONFIG_ACPI_DEBUG) += -DACPI_DEBUG_OUTPUT
��������Ǳ�Ҫ����Ϊ����Makefileӵ��$(KBUILD_CFLAGS)�������������ļ�����ʹ����������־��

asflags-yָ��$(AS)�ı���ѡ�����:

#arch/sparc/kernel/Makefile
asflags-y := -ansi
ldflags-yָ��$(LD)�ı���ѡ�����:

#arch/cris/boot/compressed/Makefile
ldflags-y += -T $(srctree)/$(src)/decompress_$(arch-y).lds
subdir-ccflags-y,subdir-asflags-y

��������־��ccflags-y��asflags-y���ơ���ͬ����subdir-ǰ׺�ı�����kbuild���ڵ�Ŀ¼�Լ���Ŀ¼����Ч�� 
ʹ��subdir-*ָ����ѡ��ᱻ���뵽��Щʹ����û����Ŀ¼�ı���֮ǰ������:

subdir-ccflags-y := -Werror
CFLAGS_$@,AFLAGS_$@

CFLAGS_$@��AFLAGS_$@ֻӦ���ڵ�ǰkbuild��makefile�ļ��� 
$(CFLAGS_$@)��$(CC)��Ե����ļ���ѡ�$@����ĳ��Ŀ���ļ�������:

# drivers/scsi/Makefile
CFLAGS_aha152x.o =   -DAHA152X_STAT -DAUTOCONF
CFLAGS_gdth.o    = # -DDEBUG_GDTH=2 -D__SERIAL__ -D__COM2__ \
		     -DGDTH_STATISTICS
�����е���ָ��aha152x.o��gdth.o�ļ��ı���ѡ�

$(AFLAGS_$@)Ӧ���ڻ���ļ�������:

# arch/arm/kernel/Makefile
AFLAGS_head.o        := -DTEXT_OFFSET=$(TEXT_OFFSET)
AFLAGS_crunch-bits.o := -Wa,-mcpu=ep9312
AFLAGS_iwmmxt.o      := -Wa,-mcpu=iwmmxt
}

doc_kbuild(��������)
{
Kbuild�������·�ʽ���������ļ���

���б�����ļ������� *.c �� *.h��
CONFIG_ѡ��Ӧ�������б����ļ�
������Ӧ���ڱ���Ŀ��
��ˣ������ı�$(CC)�ı���ѡ��������Ӱ����ļ����ᱻ���±��롣
}

doc_kbuild(CC֧�ֵĺ���)
{
�ں˿���ʹ�ò�ͬ�汾��$(CC)���룬ÿһ�ֱ��������Լ����Ժ�ѡ�kbuild�ṩ�����ļ��$(CC)��Чѡ��Ĺ��ܣ�$(CC)ͨ����gcc �������������������ñ�����Ҳ�ǿ��Եġ�

as-option 
as-option���ڼ��$(CC) �C ��ʹ�ñ������������ļ�(*.S)ʱ �C ֧�ָ���ѡ������һ��ѡ�֧��ʱ����ָ���ڶ���ѡ�����:

#arch/sh/Makefile
cflags-y += $(call as-option,-Wa$(comma)-isa=$(isa-y),)
������������У�cflags-y��ʹ��-Wa$(comma)-isa=$(isa-y)ѡ�$(CC)֧������ѡ��ʱ���ڶ��������ǿ�ѡ�ģ�����֧�ֵ�һ�����������ᱻʹ�á�

cc-ldoption 
cc-ldoption���ڼ�鵱$(CC)����Ŀ���ļ����Ƿ�֧�ָ���ѡ������֧�ֵ�һ��ѡ��ʱ�ڶ���ѡ��ᱻʹ�á�����:

#arch/i386/kernel/Makefile
vsyscall-flags += $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
������������У�vsyscall-flags��ʹ��-Wl$(comma)--hash-style=sysv���$(CC)֧�������ڶ��������ǿ�ѡ�ģ�����֧�ֵ�һ�����������ᱻʹ�á�
}

}

doc(�ܹ���ص�Makefiles)
{
����Makefile�ڽ��뵥����Ŀ¼ǰ���û�������һЩ׼������������ͨ�ò��֣���arch/$(ARCH)/Makefile�����ܹ���ص�kbuild����ѡ�����arch/$(ARCH)/Makefile��Ҫ���ü��������Ͷ��弸��Ŀ�ꡣ

��kbuild����ʱ����ѭ���漸�����裨��ţ���

�����ں�=>����.config�ļ�
���ں˰汾�Ŵ����include/linux/version.h�ļ��С�
����ȫ�������Ⱦ�����ΪĿ����׼��,�����Ⱦ�������arch/$(ARCH)/Makefile�ļ���ָ��
�ݹ����������Ϊinit-* core* drivers-* net-* libs-*��Ŀ¼��������Ŀ�ꡣ����������ֵ��arch/$(ARCH)/Makefile�ļ��б���չ
����Ŀ���ļ������ӣ����������ļ�vmlinux����Դ���Ŀ¼�¡�����Ϊhead-y��Ŀ���һ�������ӣ�������arch/$(ARCH)/Makefile�ļ�ָ��
���ܹ���صĲ������κα�Ҫ�ĺ��ڴ�����������bootimage�ļ������������������¼,׼��initrdӳ���ļ��ȵȡ�
}

doc(���ñ�������ϱ���˼ܹ�)
{

LDFLAGS �Cͨ��$(LD)ѡ��˱�־�������е����������ĵط���

#arch/s390/Makefile
LDFLAGS         := -m elf_s390
ע��: ldflags-y�������ڽ�һ�����ƶ��������־��ʹ�ü�3.7�¡�

LDFLAGS_MODULE �C$(LD)����ģ��ʱ��ѡ�� 
LDFLAGS_MODULE���ڵ�$(LD)����.koģ���ļ�ʱ��Ĭ��ѡ����-r�ض�λ�����

LDFLAGS_vmlinux �C$(LD)����vmlinuxʱ��ѡ��

LDFLAGS_vmlinuxָ������ѡ��ݸ��������������յ�vmlinuxӳ����LDFLAGS_$@��һ��������

#arch/i386/Makefile
LDFLAGS_vmlinux := -e stext
OBJCOPYFLAGS �Cobjcopyѡ��

��$(call if_changed,objcopy)���ڷ����.o�ļ�ʱOBJCOPYFLAGSָ����ѡ��ᱻʹ�á�$(call if_changed,objcopy)������������vmlinux��ԭʼ�������ļ���

#arch/s390/Makefile
OBJCOPYFLAGS := -O binary

#arch/s390/boot/Makefile
$(obj)/image: vmlinux FORCE
	$(call if_changed,objcopy)
�����������$(obj)/image�ļ���vmlinux�Ķ����ư汾��$(call if_changed,xxx)���÷����ں���˵����

KBUILD_AFLAGS �C$(AS)�����ѡ��

Ĭ��ֵ������Makefile�ļ��������ÿһ�ּܹ�������չ�����޸�����:

#arch/sparc64/Makefile
KBUILD_AFLAGS += -m64 -mcpu=ultrasparc
KBUILD_CFLAGS �C$(CC)������ѡ��

Ĭ��ֵ������Makefile�ļ����������ÿһ�ּܹ�������չ�����޸ģ�ͨ��KBUILD_CFLAGS��ֵ���������á�����:

#arch/i386/Makefile
cflags-$(CONFIG_M386) += -march=i386
KBUILD_CFLAGS += $(cflags-y)
�ܶ�ܹ�Makefiles�ļ���̬����Ŀ���������������֧�ֵ�ѡ�

#arch/i386/Makefile
...
cflags-$(CONFIG_MPENTIUMII)     += $(call cc-option,\
				-march=pentium2,-march=i686)
...
# Disable unit-at-a-time mode ...
KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time)
...
��һ���������õ�����ѡ�ѡ��ʱչ��Ϊy������ɡ�
}

doc(List directories to visit when descending)
{

һ���ܹ�Makefile��϶���Makefile���������ָ����������vmlinux�ļ���ע��ģ��ͼܹ�û����ϵ������ģ����붼�Ǽܹ��޹صġ�

head-y, init-y, core-y, libs-y, drivers-y, net-y

$(head-y)�г��������ӵ�vmlinux��Ŀ��
$(libs-y)�г�lib.a���ļ����õ�Ŀ¼ 
ʣ�µı����г�built-in.oĿ���ļ����õ�Ŀ¼

$(init-y)Ŀ������$(head-y)����,ʣ�µ�������˳�����У� 
$(core-y), $(libs-y), $(drivers-y)��$(net-y).

����Makefile����������ͨĿ¼��ֵ��arch/$(ARCH)/Makefileֻ��Ӽܹ���ص�Ŀ¼����:

#arch/sparc64/Makefile
core-y += arch/sparc64/kernel/
libs-y += arch/sparc64/prom/ arch/sparc64/lib/
drivers-$(CONFIG_OPROFILE)  += arch/sparc64/oprofile/
}

}


clean_mrproper(���)
{
	�ں˳�ʼ�� make distclean. make mrproper
	---------------------------------------------------------------------
    
    clean:ɾ���󲿷ֲ������ļ������ǣ���Ȼ�ܹ������ⲿģ�顣
    mrproper:ɾ�����в������ļ��������ļ�
    distclean :�ָ�ϵͳ����ԭʼ��״̬������mrproper�⣬����ɾ������patch��cscope��tag��
}

kconfig(����)
{
�ں�����   kconfig
           make menuconfig. make gconfig. make xconfig #����Kconfig���Բ�ͬ�����������ںˡ�
---------------------------------------------------------------------
		   ��script/kconfig/Makefile�п��Բ�ѯ��xconfig��menconfig��gconfig���󣻸������ִ����֮��Ӧ�Ķ������ļ���
		   arch/$(ARCH)/configsĿ¼���ͻᷢ�������SoC������Զ��������ļ���
		   make s2c6400_defconfig 
		   
		   .config ֻ�ǹ��������ں�������ں�����Ŀ¼�� kconfig���÷�ʽ
		   y ��Ӧ�Ķ������ļ���vmlinux����
		   m ��Ϊģ��ִ�б���
		  
		   mconfͨ��.config�����ļ�����autoconf.hͷ�ļ�����ͨ��script/kconfig/confdata.c��conf_write_autoconf()������֪autoconf.h�����ɹ��̡�
		   .config�����ļ���include/linux/autoconf.h������һ����
		   .config ���������ļ���λ�����ӣ��������Ƿ���Դ����Ϊ��λִ�а�����
		   �ں�������.config�ļ�Ϊ�������ɵ�autoconf.h����Ԥ����׶ξ����Ƿ����#ifdef��䡣
		   
		   ����kconfig����ں����ã���׼���þ��������ں����õ�.config�ļ��󣬼��ɹ����ںˡ�

--------------------------------- [Kconfig] ------------------------------------		   
Kconfig ��Ӧ�����ں����ý׶Σ�����ʹ�����make menuconfig��������ʹ��Kconfigϵͳ��Kconfig��������������ɣ�

     scripts/kconfig/*					Kconfig�ļ���������
     kconfig  							�����ں�Դ����Ŀ¼�е�kconfig�ļ�
     arch/$(ARCH)/configs/*_defconfig	����ƽ̨��ȱʡ�����ļ�
	 
��Kconfigϵͳ����.config��Kbuild ������.config����ָ����Ŀ�ꡣ

--------------------------------- [run] ------------------------------------
scripts/kconfig/*          kconfig��������
kconfig                    �����ں�Դ����Ŀ¼�������ļ�
arch/$(ARCH)/defconfig     archȱʡ�����ļ�	 

}


kbuild(����)
{
�ں˹���   kbuild
           make all. make zImage. make modules
---------------------------------------------------------------------


--------------------------------- [Kbuild] ------------------------------------	
Kbuild ���ں�Makefile��ϵ�ص㣬��Ӧ�ں˱���׶Σ���5��������ɣ�

	 ����Makefile				���ݲ�ͬ��ƽ̨���Ը���target���ಢ������Ӧ�Ĺ���Makefile����Ŀ��
	 .config					�ں������ļ�
	 arch/$(ARCH)/Makefile		����ƽ̨��ص�Makefile
	 scripts/Makefile.*			ͨ�ù����ļ����������е�Kbuild Makefiles����������ÿ��ԴӺ�׺���е�֪��
	 ����Ŀ¼�µ�Makefile �ļ�	�����ϲ�Ŀ¼��Makefile���ã�ִ�����ϲ㴫������������

--------------------------------- [scripts] ------------------------------------
������scriptsĿ¼�µı�������ļ�����Ŀ¼�µ�C�����������������������Ҫ�����á��о����£�

    Kbuild.include		���õĶ����ļ�������������Makefile.*�����ļ��Ͷ���Makefile����
    Makefile.build		�ṩ����built-in.o, lib.a�ȵĹ���
    Makefile.lib		����������obj-y��obj-m�����е�Ŀ¼subdir-ym��ʹ�õĹ���
    Makefile.host		�������빤�ߣ�hostprog-y���ı������
    Makefile.clean		�ں�Դ��Ŀ¼�������
    Makefile.headerinst	�ں�ͷ�ļ���װʱʹ�õĹ���
    Makefile.modinst	�ں�ģ�鰲װ����
    Makefile.modpost	ģ�����ĵڶ��׶�,��.o��.mod����.koʱʹ�õĹ���	 
����Makefile ��Ҫ�Ǹ������vmlinux(�ں��ļ�)��*.ko(�ں�ģ���ļ�) �ı��롣���� Makefile ��ȡ.config �ļ���������.config 
�ļ�ȷ��������Щ��Ŀ¼����ͨ���ݹ����·�����Ŀ¼����ʽ��ɡ�����Makefileͬʱ����.config �ļ�ԭ�ⲻ���İ���һ������ܹ�
��Makefile�������������� arch/$(ARCH)/Makefile���üܹ�Makefile �򶥲�Makefile �ṩ��ܹ����ر���Ϣ��

ÿһ����Ŀ¼����һ��Makefile �ļ�������ִ�д����ϲ�Ŀ¼���������������Ŀ¼�� Makefile Ҳ��.config �ļ�����ȡ��Ϣ��
�����ں˱���������ļ��б�
}
	 
	 
install(��װ)
{
    �ں˰�װ   make install, make modules_install
    ---------------------------------------------------------------------
}	 
	 
run(make����)
{
[include $(srctree)/scripts/Kbuild.include]
Makefile.include ���������ڹ����ں˵Ĺ�ͬ��������ֽű���
Makefile�ж�����ͬ�����͸��ֽű�������Kbuild.include���ҵ���Ҳ�ɼ���scriptĿ¼�ڵ��ļ�

[include $(srctree)/arch/$(SRCARCH)/Makefile]
�����˸��ṹ��Makefile��Makefile���Ժ󹹽��ں˵Ĺ����и���Դ����ṹ����ִ�б��롣

[arch/arm/Makefile] -> [arch/arm/boot/Makefile] -> [arch/arm/boot/compressed/Makefile]
����KBUILD_IMAGE := zImage

cmd_objcopy = $(OBJCOPY) $(OBJCOPYFLAGS) $(OBJCOPYFLAGS_$(@F)) $< $@ <script/Makefile.lib>
���ں˱������ɵ�$(obj)/compressed/vmlinuxִ��objcopy������������������ŵĶ����ƾ���

[arch/arm/boot/compressed/Makefile]
��gzipѹ����������ŵ�vmlinux�ļ����Ӷ�����pigg.gz�������ø������ṹ���������ű�($(obj)/vmlinux.lds)ִ�����ӡ�
}

create(vmlinux->bzImage)
{
    ��kbuild����ʱ����ѭ���漸�����裨��ţ���

    1. �����ں�=>����.config�ļ�
    2. ���ں˰汾�Ŵ����include/linux/version.h�ļ��С�
    3. ����ȫ�������Ⱦ�����ΪĿ����׼��,�����Ⱦ�������arch/$(ARCH)/Makefile�ļ���ָ��
    4. �ݹ����������Ϊinit-* core* drivers-* net-* libs-*��Ŀ¼��������Ŀ�ꡣ����������ֵ��arch/$(ARCH)/Makefile�ļ��б���չ
    5. ����Ŀ���ļ������ӣ����������ļ�vmlinux����Դ���Ŀ¼�¡�����Ϊhead-y��Ŀ���һ�������ӣ�������arch/$(ARCH)/Makefile�ļ�ָ��
    6. ���ܹ���صĲ������κα�Ҫ�ĺ��ڴ�����������bootimage�ļ������������������¼,׼��initrdӳ���ļ��ȵȡ�


	����Makefile ��Ҫ�Ǹ������vmlinux(�ں��ļ�)��*.ko(�ں�ģ���ļ�) �ı��롣
	���� Makefile ��ȡ.config �ļ���������.config �ļ�ȷ��������Щ��Ŀ¼����ͨ���ݹ����·�����Ŀ¼����ʽ��ɡ�
	����Makefileͬʱ����.config �ļ�ԭ�ⲻ���İ���һ������ܹ���Makefile�������������� arch/$(ARCH)/Makefile��
	    �üܹ�Makefile �򶥲�Makefile �ṩ��ܹ����ر���Ϣ��

    ÿһ����Ŀ¼����һ��Makefile �ļ�������ִ�д����ϲ�Ŀ¼�������������
	��Ŀ¼�� Makefile Ҳ��.config �ļ�����ȡ��Ϣ�������ں˱���������ļ��б�
	
        1. �ǰ��ں˵�Դ��������.o�ļ���Ȼ�����ӣ���һ�������ӵ���arch/i386/kernel/head.S�����ɵ���vmlinux��
    ע�������������б�����ַ����32λҳѰַ��ʽ�ı���ģʽ�µ������ַ��ͨ����3G���ϡ�
        2. ��vmlinux objcopy ��arch/i386/boot/compressed/vmlinux.bin��֮�����ѹ���������Ϊ���ݱ����
    piggy.o����ʱ���ڱ�����������piggy.o�����������ʲôstartup_32��
        3. ��head.o,misc.o��piggy.o��������arch/i386/boot/compressed/vmlinux����һ�������ӵ���
    arch/i386/boot/compressed/head.S����ʱarch/i386/kernel/head.S�е�startup_32��
    ѹ������Ϊһ����ͨ�����ݣ����������������ˡ�ע������ĵ�ַ����32λ��Ѱַ��ʽ��
    ����ģʽ�µ����Ե�ַ��
    
    
	1.������vmlinux.����һ��elf��ִ���ļ�
	2.Ȼ��objcopy��arch/i386/boot/compressed/vmlinux.bin��ȥ����ԭelf�ļ��е�һЩ���õ�section����Ϣ��
	3.gzip��ѹ��Ϊarch/i386/boot/compressed/vmlinux.bin.gz
	4.��ѹ���ļ���Ϊ���ݶ����ӳ�arch/i386/boot/compressed/piggy.o
	5.���ӣ�arch/i386/boot/compressed/vmlinux = head.o+misc.o+piggy.o����head.o��misc.o��������ѹ���ġ�
	6.objcopy��arch/i386/boot/vmlinux.bin��ȥ����ԭelf�ļ��е�һЩ���õ�section����Ϣ��
	7.��arch/i386/boot/tools/build.c����ƴ��bzImage = bootsect+setup+vmlinux.bin���̺ø��ӡ�
}

make_script(run)
{
config %config: scripts_basic outputmakefile FORCE
       $(Q)mkdir -p include/linux include/config
       $(Q)$(MAKE) $(build)=scripts/kconfig $@
���õ�ԭ��������ָ����Ŀ��"menuconfig"ƥ����"%config"��
��������Ŀ����scripts_basic ��outputmakefile���Լ�FORCE��Ҳ����˵���������3������Ŀ���
�������������Ż�ִ�����������ָ����Ŀ��"menuconfig"��

make_script(scripts_basic)
{
scripts_basic:
       $(Q)$(MAKE) $(build)=scripts/basic
��û������Ŀ�꣬����ֱ��ִ�������µ�ָ�ֻҪ��ָ��չ�������Ǿ�֪��make����ʲô���������бȽϲ���չ������$(build)��
���Ķ�����scripts/Kbuild.include�У� 

build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
����չ�����ǣ�
make -f scripts/Makefile.build obj= scripts/basic

Ҳ����make ����ִ��scripts/Makefile.build�ļ����Ҳ���obj= scripts/basic�����ڽ���ִ��scripts/Makefile.build�ļ���ʱ��
scripts/Makefile.build�ֻ�ͨ���������������������Ӧ�ļ����µ�Makefile�ļ���scripts/basic/Makefile�������л����Ҫ
�����Ŀ�ꡣ

make_script(Makefile_host)
{
��ȷ�����Ŀ���Ժ�ͨ��Ŀ����������������һЩscripts/Makefile.*�ļ�������scripts/basic/Makefile���������£�
hostprogs-y := fixdep docproc hash
always      := $(hostprogs-y)
# fixdep is needed to compile other host programs
$(addprefix $(obj)/,$(filter-out fixdep,$(always))): $(obj)/fixdep

����scripts/Makefile.build�����scripts/Makefile.host����Ӧ��������£�

# Do not include host rules unless needed

ifneq ($(hostprogs-y)$(hostprogs-m),)
include scripts/Makefile.host
endif
}

����scripts/Makefile.build�����include scripts/Makefile.lib�ȱ���Ĺ������ļ�������Щ�ļ��Ĺ�ͬ��������ɶ�
scripts/basic/Makefile��ָ���ĳ�����롣

����Makefile.build�Ľ���ִ��ǣ���˶��Makefile.*�ļ������̽�Ϊ���ӣ�����ƪ���޷�һ��һ��ָ��ķ�������Ȥ�Ķ��߿���
���з�����
}
make_script(outputmakefile)
{
make�������ù���
PHONY += outputmakefile
# outputmakefile generates a Makefile in the output directory, if using a
# separate output directory. This allows convenient use of make in the
# output directory.

outputmakefile:
ifneq ($(KBUILD_SRC),)
    $(Q)ln -fsn $(srctree) source
    $(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
        $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
endif

���������ǿ��Կ�����outputmakefile�ǵ�KBUILD_SRC ��Ϊ��(ָ��O=dir���������Ŀ¼��Դ����Ŀ¼�ֿ�)ʱ�������Ŀ¼����
Makefileʱ��ִ������ģ�
���������Դ���Ŀ¼��ִ��make menuconfig����ʱ�����Ŀ���ǿյģ�ʲô��������
�������ָ����O=dirʱ���ͻ�ִ��Դ��Ŀ¼�µ�scripts/mkmakefile��������ָ����Ŀ¼�²���һ��Makefile����������ָ����
Ŀ¼�¿�ʼ���롣
}

make_script(FORCE)
{
FORCE
����һ�����ں�Makefile���洦�ɼ���αĿ�꣬���Ķ����ڶ���Makefile�����
PHONY += FORCE
FORCE:

 
�Ǹ���ȫ�Ŀ�Ŀ�꣬����ΪʲôҪ����һ�������Ŀ�Ŀ�꣬�������Ŀ�꽫����Ϊ����Ŀ���أ�ԭ�����£�
����ΪFORCE ��һ��û�������������Ŀ�꣬������������Ӧ�ļ���αĿ�ꡣ��makeִ�д˹���ʱ���ܻ���ΪFORCE�����ڣ�
����������Ŀ�꣬��������һ��ǿ��Ŀ�ꡣҲ����˵������һ����ִ�У�make ����Ϊ����Ŀ���Ѿ���ִ�в����¹��ˡ�
������Ϊһ�����������ʱ�����������ܱ���Ϊ�����¹��ģ������Ϊ�������ڵĹ����ж���������ܻᱻִ�С�
���Կ�����ô˵��ֻҪִ����������FORCE��Ŀ�꣬��Ŀ���µ�����ر�ִ�С�

��make���������3��Ŀ��֮�󣬾Ϳ�ʼִ�����������ģ�������
    $(Q)mkdir -p include/linux include/config
    ����ܺ���⣬���ǽ�������������ļ��С�Ȼ��
    $(Q)$(MAKE) $(build)=scripts/kconfig $@
    ����������������$(Q)$(MAKE) $(build)=�ṹ��ͬ������չ���õ���
    make -f scripts/Makefile.build obj=scripts/kconfig menuconfig
    �������ָ���Ч����ʹmake ����ִ��scripts/Makefile.build�ļ����Ҳ���obj=scripts/kconfig menuconfig��
    ����Makefile.build�������Ӧ�ļ����µ�Makefile�ļ���scripts/kconfig /Makefile���������scripts/kconfig/Makefile
    �µ�Ŀ�꣺
    menuconfig: $(obj)/mconf
            $< $(Kconfig)

���Ŀ�������������$(obj)/mconf��ͨ��������֪����ʵ�Ƕ�Ӧ���¹���
mconf-objs  := mconf.o zconf.tab.o $(lxdialog)
����
ifeq ($(MAKECMDGOALS),menuconfig)
    hostprogs-y += mconf
endif

Ҳ���Ǳ������ɱ���ʹ�õ�mconf�����������Ŀ���ͨ��scripts/kconfig/Makefile�ж�Kconfig�Ķ����֪�����ִ�У�
mconf arch/$(SRCARCH)/Kconfig
������conf��xconf�ȶ������ƵĹ��̣������ܽ���������make %config ʱ���ں˸�Ŀ¼�Ķ���Makefile����ʱ�����
scripts/kconfig �еĹ��߳���conf/mconf/qconf �ȸ����arch/$(SRCARCH)/Kconfig �ļ����н��������Kconfig 
��ͨ��source��ǵ��ø���Ŀ¼�µ�Kconfig�ļ�������һ��Kconfig����ʹ�ù��߳��򹹽��������ں˵����ý��档
�����ý����󣬹��߳���ͻ��������ǳ�����.config�ļ���

}

}

module(��ӵ��ں�)
{
�������Ѿ�д����һ�����TI ��AM33XXоƬ�� LED������������Ϊam33xx_led.c��
��1��       ������Դ��am33xx_led.c���ļ����Ƶ�linux-X.Y.Z/drivers/charĿ¼��
��2��       �ڸ�Ŀ¼�µ�Kconfig�ļ������LED����������ѡ�
config AM33XX_LED
       bool "Support for am33xx led drivers"
       depends on  SOC_OMAPAM33XX
       default n
       ---help---
          Say Y here if you want to support for AM33XX LED drivers.
��3��     �ڸ�Ŀ¼�µ�Makefile�ļ�����Ӷ�LED�����ı��룺
obj-$(CONFIG_AM33XX_LED)   +=  am33xx_led.o
������Ϳ�����make menuconfig��ʱ�򿴵��������ѡ������������ˡ�
��Ȼ�����������ֻ��һ����˼������Kconfig�ļ���Makefile����ϸ�﷨����ο��ں��ĵ���
Documentation/kbuild/makefile.txt

}

		   