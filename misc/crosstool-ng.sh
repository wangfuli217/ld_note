

create(����crosstool-ng����Ϊʹ�ð�װ��Ҫ�����)
{
crosstool-ng�����ص�ַ�ǣ�http://ymorin.is-a-geek.org/download/crosstool-ng/
   ֵ��ע����ǣ����������µ�crosstool-ng�Ժ󣬼ǵ��ڵ�http://ymorin.is-a-geek.org/download/crosstool-ng/01-fixes/������û����Ӧ�Ĳ������еû�һ������������

   �����ʹ�õ���1.6.1��
   ʹ��crosstool-ng���밲װһЩ�����õ��������ubuntu�±��밲װ��ʹ��apt����
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

svn    (2011.09.16����)
  ������crosstool-ng����arm-linux���湤�����Ľ��ܣ�����ֶ���װһ��termcap��
}

create(��ѹ���򲹶�������У�����������Ŀ¼��)
{
crosstool-ng��crosstool��ͬ�ĵط�֮һ���ǣ���������һ���������Ϳ���ʹ���ˣ����������ð�װ��
   ������������crosstool-ng-X.Y.Z.tar.bz2��ѹ����Ϊ��׼���Ĺ���Ŀ¼���������Ϊ${CROSSTOOLNG}������������װ�ͱ���Ŀ¼��

mkdir crosstool-ng-X.Y.Z_build     #��α����½���������Ĺ���Ŀ¼
mkdir crosstool-ng-X.Y.Z_install   #crosstool-ng�İ�װĿ¼
cd crosstool-ng-X.Y.Z              #�����ѹ���crosstool-ngĿ¼

patch -p1 <   <�����ļ�>            # ��crosstool-ng�򲹶�������У�

./configure --prefix=${CROSSTOOLNG}/crosstool-ng-X.Y.Z_install

                                   #����crosstool-ng
make                               #����crosstool-ng
make install                       #��װcrosstool-ng
}

config()
{
������ֻ˵˵���armv4t��Ҫ�޸ĵĵط�����Ĺ��ܵ����˰��Ӳ�����˵��
1�������غõ�Դ���·���ͽ���������İ�װ·����
Paths and misc options  --->
  (${HOME}/development/crosstool-ng/src) Local tarballs directory   ����Դ���·��
  (${HOME}/development/x-tools/${CT_TARGET}) Prefix directory  ����������İ�װ·��
���������������ʵ��������޸ġ�

2���޸Ľ����������ԵĹ���
 Target options  --->
           *** Target optimisations ***
           (armv4t) Architecture level
           (arm9tdmi) Emit assembly for CPU   
           (arm920t) Tune for CPU
           
3���ر�JAVA���������������
  ��������ubuntu 9.10����JAVA��������ʱ������Ҳ����host��gcj�����⣬�����Ҳ���JAVA�����Ծ�ֱ�ӹر��ˡ�������ֵ�֪����������ǵ�֪ͨһ������
C compiler  --->
      *** Additional supported languages: ***
      [N] Java
      
4�����ݲο�����,��ֹ�ں�ͷ�ļ���⣨ֻ�𵽽�Լʱ������ã�����1S��ʱ�䣩�����Ƽ����ã�
Operating System  --->
 [N]     Check installed headers
 
5�����ӱ���ʱ�Ĳ��н�����������������Ч�ʣ��ӿ���롣
Paths and misc options  --->
   *** Build behavior ***
   (4) Number of parallel jobs
   �����ֵ���˹���Ӧ��ΪCPU�����������������ҵ�CPU��˫�˵ģ�����������4.
   
6��һЩ���Ի����޸ģ����Բ��޸ģ�
Toolchain options  --->
       *** Tuple completion and aliasing *** 
       (tekkaman) Tuple is vendor string
���������ı�����ǰ׺���ǣ�arm-tekkaman-linux-gnueabi-

C compiler  --->
       (crosstool-NG-${CT_VERSION}-tekkaman) gcc ID string

���ú��Ժ󱣴档

����ں�Դ��İ汾���޸ģ���ֱ���޸�crosstool-ng-1.6.1_buildĿ¼�µ�.config�ļ�����ֹһ�����йصĶ�Ҫ�޸ġ�
�У�
CT_KERNEL_VERSION=
CT_KERNEL_V_2_6_����_��=y
CT_LIBC_GLIBC_MIN_KERNEL=
����ٴ�../crosstool-ng-1.6.1_install/bin/ct-ng menuconfig������޸��ֻḴԭ�������ٴ��ֹ��޸ġ�
��Ҳ����ѡ���޸�crosstool-ng-X.Y.Z_build/config/kernel/linux.in���ļ���ֻ�ǱȽ��鷳��������Գ��׽����ʵ���ڽ����������ں˰汾��   
}

creat(download)
{
Ϊ�ӿ��ٶȣ�������������������Ӧ�����������ѡ����
   ��Ȼcrosstool-ng�����Ҳ����������ʱ����Զ����أ����ǱȽ�����������ε�����������鿴".config"�ļ�������Ԥ�����������µ��������
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

������֮�󣬼ǵý���Щ�������������ʱָ�����ļ��С�
}

build()
{
�塢��ʼ���롣

../crosstool-ng-1.6.1_install/bin/ct-ng bluid

�ҵıʼǱ����˴��40����ӱ�����ɡ�

��������ú�Ľ����������
������λ�ڣ�${������ʱȷ����·��}/x-tools/arm-tekkaman-linux-gnueabi/bin
���ļ�λ�ڣ�${������ʱȷ����·��}/x-tools/arm-tekkaman-linux-gnueabi/arm-tekkaman-linux-gnueabi/lib
}