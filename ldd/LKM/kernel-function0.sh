make -C ${CB_KSRC_DIR} O=${CB_KBUILD_DIR} ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- kernel_defconfig 
make -C ${CB_KSRC_DIR} O=${CB_KBUILD_DIR} ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- -j4 INSTALL_MOD_PATH=${CB_TARGET_DIR} uImage modules


request_module()
{
http://blog.csdn.net/liukun321/article/details/7057442
# cat /proc/sys/kernel/modprobe
# /sbin/modprobe
# ����Ҳ������/proc/sys/kernel/modprobe����µ�modprobeӦ�ó���·��,�����/sbin/modprobe���ں�Ĭ��·��.

��2.6�ں��У�����ʹ�á�request_module(const char *fmt,...)�����������ں�ģ�飨ע�⣺ǰ�����ģ�鶼��ͨ��
    insmod��modprobe��ʵ�ֵģ�������������Ա����ͨ������::
request_module(module_name);
��
request_module("char-major-%d-%d",MAJOR(dev),MINOR(dev));
�����������ں�ģ�顣
   ��linux�ں��У����б�ʾΪ__init�ĺ��������ӵ�ʱ�����.init.text��������ڣ����⣬���е�__init�����ڶ�
.initcall.init�л�������һ�ݺ���ָ�룬�ڳ�ʼ��ʱ���ں˻�ͨ����Щָ�������Щ__init���������ڳ�ʼ����ɺ�
�ͷ�init����(.init.text,.initcall.init��)��

>>>>>>> ǳ��request_module�ں�����ֱ�������û��ռ����/sbin/modprobe
    ��soundcore_open��/dev/dsp�ڵ㺯���л���õ������:
        request_module("sound-slot-%i", unit>>4);
    ����,���ʾ,��linuxϵͳ���û��ռ����/sbin/modprobe����������Ϊsound-slot-0.koģ��
    #define request_module(mod...) __request_module(true, mod)
    #define request_module_nowait(mod...) __request_module(false, mod)
}

    
    
http://www.cnblogs.com/hoys/archive/2012/03/13/2395232.html
>>>>>>>  ʹ��call_usermodehelper��Linux�ں���ֱ�������û��ռ����(ת)
ϵͳ��ʼ��ʱkernel_init���ں�̬����������Ӧ�ó��������ϵͳ��ʼ��.  �ں˸ո�����ʱ��ֻ���ں�̬�Ĵ��룬������init�����У����ں�̬������һЩ
��ʼ��ϵͳ�ĳ��򣬲Ų����˹������û��ռ�Ľ��̡�

static noinline int init_post(void) //���ں��﷢��ϵͳ���ã�ִ���û��ռ��Ӧ�ó�����Щ�����Զ���rootȨ�����С�
����ں��Դ������û��ռ���򣬴Ӷ������˵�һ���Լ��������û��ռ����һ���û��ռ��init���򣬻�����һ��shell�����û���¼ϵͳ�á�������
�����������û��ռ�ĳ�����Զ���᷵�ء�Ҳ����˵����������²��ᵽpanic��һ����ϵͳִ�е������Linux Kernel�ĳ�ʼ��������ˡ�

��ʱ���жϺ��ж������Ľ��̵��Ȼ��ƣ������Ÿ����߳��ڸ���CPU�ϵ����С��жϴ������ʱ������������ϵͳ�ϣ�һЩ�ں��߳����ں�̬���У�������Զ
��������û�̬������Ҳ����û���û�̬���ڴ�ռ䡣�������Ե�ַ�ռ���ǹ����ں˵����Ե�ַ�ռ䡣һЩ�û�����ͨ�����û�̬���С�
��ʱ��Ϊϵͳ���ö������ں�̬�������ں��ṩ��ϵͳ���ô�������
       ����ʱ�����ǵ��ں�ģ������ں��߳�ϣ���ܹ������û��ռ�Ľ��̣�����ϵͳ����֮��init_post��������������
       �磬һ���������ں˵õ��������豸�ţ�Ȼ����Ҫʹ��mknod�������Ӧ���豸�ļ����Թ��û����ø��豸��
       �磬һ���ں��߳�����֪������͵͵���и�����Ȩ�ĺ��ų��򡣵ȵ�֮�������

BIOS��x86�ں˵�ĳЩ������Ƶ֡�������������APM�߼���Դ����Ȳ���x86�ں���ȷʹ����BIOS����������ض��Ĺ��ܣ�
     ��������������ں������Ĳ�����ʽ��ȡ����BIOS����ʼ��IO����ַ���жϼ���ʵģʽ���ں˴����������ڼ����
     ʹ��BIOS���ã��������ϵͳ�ڴ�ӳ�������
       
      �ں˵ĺܶಿ����ʵģʽ�´�BIOS�ռ���Ϣ�����ڱ���ģʽ�����������ڼ�������ռ�����Ϣ��
      1. ʵģʽ���ں˴������BIOS���񣬽����ص���Ϣ�����������ڴ�ĵ�һҳ����Щ��arch/x86/bootĿ¼�µ�Դ������ɣ�
         ��ҳ���������ּ�Documentation/i386/zeropage.txt
      2. ���ں�ת�򱣻�ģʽ�󣬵�������ҳ֮ǰ����ȡ�����ݴ�����ں˵����ݽṹ�У�������/arch/x86/kernel/setup_32.c
      3. ����ģʽ���ں����������������к���ʹ�ñ������Ϣ��
      
      ��2.6.23�ں˿�ʼ��i386����������󲿷���C��д�ˣ�2.3.23֮ǰ������Ϊarch/i386/boot/setup.S������/arch/x86/boot/memory.c
      �л�������ģʽ���ڷ�����arch/x86/boot/pm.c������setup.S
      
      BootloaderҲ����BIOS��������Ķ�LILO��GRUB��SYSLINUX��Դ���룬�ᷢ��Ϊ�˴������豸�ж�ȡ�ں�ӳ��
      Ҫ0x13���жϵ�Ƶ�����á�

 BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000008e400 (usable)
 BIOS-e820: 000000000008e400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
ʵģʽ�µĳ�ʼ������ͨ��ʹ��BIOS��int 0x15����ִ��0xe820�ź�������ȡϵͳ���ڴ�ӳ����Ϣ��
�ڴ�ӳ����Ϣ�а�����Ԥ���ĺͿ��õ��ڴ棬�ں˽����ʹ����Щ��Ϣ��������õ��ڴ�ء�
 
 
 desc()
 {
 1. ����Ӵ���ǰ���"+"; 
   ɾ���Ĵ���ǰ�������"-"; 
   arch/your-arch/��x86����ʱ��your-arch��Ӧ�ľ���x86��Ϊarm����ʱ��your-arch��Ӧ�ľ���arm��
   *��X��Ϊͨ�����time*.h����ʾtime.h,timer.h,times.h, timex.h
   -> ������ʱ��������������ں˵�����֮�䣬Ŀ���Ǹ���ע��
   pci_[map|unmap|dma_sync]_single()�����pci_map_single() pci_unmap_sigle() pci_dma_sync_sigle() 
 
lwn.net
kerneltrap.org 

patch
cd /usr/src/linux-x.y.z/               #linux-x.y.z.tar.bz2Ҳ��/usr/src
bzip2 -dc ../x.y.z-mm2.bz2 | patch -pl #x.y.z-mm2.bz2��/usr/src

ʹ��-Eѡ�������GCC����Ԥ���봦��Դ���롣Ԥ����������ͷ�ļ�����չ����������Ϊ��չ���궨���ڶ��Ƕ�׵�ͷ�ļ��������Ծ��
��Ҫ�����������Ԥ����drivers/char/mydrv.c��������չ�������ļ�mydrv.i:
gcc -E drivers/char/mydrv.c -D__KERNEL__ -Iinclude -Iinclude/asm/-x86/mach-default > mydrv.i
ʹ��-Iѡ�����ָ����Ĵ�����������include��·��
ʹ��-Sѡ�������GCC��������б�
������������Ϊdrivers/char/mydrv.c�����Ļ���ļ�mydrv.s
gcc -S drivers/char/mydrv.c -D__KERNEL__ -Iinclude -Ianother/include/path 

 }
 
 
CONFIG_CMDLINE(Linux�ں�ǿ��ʹ�������õ�cmdline)
 {
  CONFIG_CMDLINE�ṩ�����ں������в����������ں�ʱ��
  
  ��������������һЩ���⣬��Ҫ��cmdline��cmdline�ڲ�ͬ��ƽ̨���в�ͬ�ĸķ����еĵ���������һ�������У��е�ʹ�õ���uboot����Ҫ�������������ж������������ֶ��޸ģ�Ҳ�е�ƽ̨��ʹ�õ���uboot�ı��ֶ�ȡ�����ļ���ȡcmdline������������һЩƽ̨��sdcard����ϵͳ����emmc����ϵͳ���޸�cmdline�ķ�������һ���������һ�û�п��ǵ��û��и�cmdline������
һЩ�����ǲ����õģ�
1. ��Ҫ��ubootԴ��ſ��Ը�cmdline�Ĳ����ã�
2. ��Ҫ�ֶ��ж�uboot�������ֶ���cmdline�Ĳ����ã�

���õķ�����
1. ��cmdline�ŵ�Android�̼��У���дAndroid�̼���ͬʱcmdlineҲ�Ѿ����úã�����Ҫ�ٲ����������Ϳ��������豸��

�����������������û�н�cmdline�ŵ�һ�������Ĵ洢�ռ���������д�̼�ʱ�Ͱ�cmdline���úõĻ���Ŀ�����������kernel�ϣ��ں��ǵ�һ���õ�cmdline�ģ�Ҳֻ������Ҫ���ã��ں˵�����������һ�������ں�����������ѡ��CONFIG_CMDLINE��������ֻ��һ����̥��һ������»�����Ҫʹ��bootloader���ݹ�����cmdline��
1. ǿ���ں�ʹ�������õ�cmdline
make menuconfig 
-> Boot options 
-> Kernel command line type (***) ( ) 
Use bootloader kernel arguments if available ( ) 
Extend bootloader kernel arguments (X) Always use the default kernel command string

Ƕ��ʽ�豸�ϵ�����װ�����ͨ������"����"������֧�������ļ������ƵĻ��ƣ���ˣ�����x86��ϵ�ṹ�ṩ��
CONFIG_CMDLINE����ں�����ѡ�ͨ�������û������ڱ����ں�ʱ�ṩ�ں������С�
 }

 uboot(uboot��linux֮��Ĳ�������)
 {
U-boot���Linux Kernel���ݺܶ�������磺���ڣ�RAM��videofb�ȡ���Linux kernelҲ���ȡ�ʹ�����Щ����������֮��ͨ��struct tag
�����ݲ�����U-boot��Ҫ���ݸ�kernel�Ķ���������struct tag���ݽṹ�У�����kernelʱ��������ṹ��������ַ����kernel��
Linux kernelͨ�������ַ����parse_tags���������ݹ����Ĳ�����

������Ҫ��U-boot����RAM��Linux kernel��ȡRAM����Ϊ������˵����
1��u-boot��kernel��RAM����
./common/cmd_bootm.c�ļ��У�ָUboot�ĸ�Ŀ¼����bootm�����Ӧ��do_bootm������������uImage����Ϣ����OS��Linuxʱ��
����./lib_arm/bootm.c�ļ��е�do_bootm_linux����������Linux kernel��
��do_bootm_linux�����У�
void do_bootm_linux (cmd_tbl_t *cmdtp, int flag, int argc, char *argv[],\
ulong addr, ulong *len_ptr, int verify)

2��Kernel��ȡU-boot���ݵ���ز���
����Linux Kernel��ARMƽ̨����ʱ����ִ��arch/arm/kernel/head.S�����ļ������arch/arm/kernel/head- common.S��
arch/arm/mm/proc-arm920.S�еĺ�������������start_kernel��
���У�setup_arch������arch/arm/kernel/setup.c�ļ���ʵ�֣����£�
void __init setup_arch(char **cmdline_p)

 }
 
 setupparam(Kernel �汾�ţ�3.4.55)
 {
һ kernelͨ�ò���
��������ͨ�ò�����kernel��������һ��data�Σ���.ini.setup�Ρ���arch/arm/kernel/vmlinux.lds�У�
.init.data : {
  *(.init.data) *(.cpuinit.data) *(.meminit.data) *(.init.rodata) *(.cpuinit.rodata) *(.meminit.rodata) . = ALIGN(32); __dtb_star
 . = ALIGN(16); __setup_start = .; *(.init.setup) __setup_end = .;
  __initcall_start = .; *(.initcallearly.init) __initcall0_start = .; *(.initcall0.init) *(.initcall0s.init) __initcall1_start =
  __con_initcall_start = .; *(.con_initcall.init) __con_initcall_end = .;
  __security_initcall_start = .; *(.security_initcall.init) __security_initcall_end = .;
  . = ALIGN(4); __initramfs_start = .; *(.init.ramfs) . = ALIGN(8); *(.init.ramfs.info)
 }

���Կ���init.setup����ʼ__setup_start�ͽ���__setup_end��
.init.setup���д�ŵľ���kernelͨ�ò����Ͷ�Ӧ��������ӳ�����include/linux/init.h��

���Կ����궨��__setup�Լ�early_param������obs_kernel_param�ṹ�壬�ýṹ���Ų����Ͷ�Ӧ�������������.init.setup���С�
���������������ļ��е��øú궨�壬������ʱ�ͻ��������˳�򽫶����obs_kernel_param�ŵ�.init.setup���С�

__setup_console_setup����ʱ�ͻ����ӵ�.init.setup���У�kernel����ʱ�ͻ����cmdline�еĲ�������.init.setup����obs_kernel_param��name�Աȡ�
ƥ�������console-setup�������ò�����console_setup�Ĳ�������cmdline��console��ֵ�����Ǻ�����������Ĵ�������ˡ�

 }
 
 tracepoint(http://blog.csdn.net/arethe/article/details/6293505)
 {
   �����е�׷�ٵ��ṩ��������ʱ����̽�⺯���Ĺ��ӡ�׷�ٵ���Դ򿪣�������̽�⺯������رգ�û������̽�⺯������
���ڹر�״̬��׷�ٵ㲻�������κ�Ч��������������һ��ʱ�俪�������һ����֧����������
�Ϳռ俪������instrumented function[��֪����η������]��β�����Ӽ����������õĴ��룬�ڶ�����������һ�����ݽṹ����
���һ��׷�ٵ㱻�򿪣���ôÿ��׷�ٵ㱻ִ��ʱ����������ӵ�̽�⺯���������ڵ����ߵ�ִ���������С�̽�⺯��ִ�н�����
�����ص������ߣ���׷�ٵ����ִ�У���
    �����ڴ����е���Ҫλ�ð���׷�ٵ㡣�������������Ĺ��Ӻ������ܹ�������������Ĳ�����ԭ�Ϳ����ڶ���׷�ٵ��ͷ�ļ����ҵ���

׷�ٵ������������ϵͳ׷�ٲ���������ͳ�ơ�
 ÿ��׷�ٵ㶼����2��Ԫ�أ�
- ׷�ٵ㶨�塣λ��ͷ�ļ��С�
- ׷�ٵ�������λ��C�ļ��С�
ʹ��׷�ٵ�ʱ����Ҫ����ͷ�ļ�linux/tracepoint.h.
���磬���ļ�[include/trace/subsys.h]�У�
#include <linux/tracepoint.h>

DECLARE_TRACE(subsys_eventname,
TP_PROTO(int firstarg, struct task_struct *p),
TP_ARGS(firstarg, p));
���ļ�[subsys/file.c](���׷�������ĵط�)�У�
#include <trace/subsys.h>

DEFINE_TRACE(subsys_eventname);

void somefct(void)

 }
 
CONFIG_NO_HZ(�޽����ں�����)
{
2.6.21�ں�֧���޽��ĵ��ںˣ��������ϵͳ�ĸ��ض�̬������ʱ���жϡ�
}

CONFIG_SMP(�ں�֧�ֶ�CPU){}
CONFIG_PREEMPT(�ں�֧����ռ){}
CONFIG_DEBUG_SPINLOCK(�ҳ�����������){}
CONFIG_SYSCTL(/proc/sys�ļ�ϵͳ����){}

http://book.51cto.com/art/200912/169070.htm
ARMǶ��ʽLinuxϵͳ�������
arch(��ֲ)
{
20.1 Linux�ں���ֲҪ��
20.2 ƽ̨��ش���ṹ
20.3 ����Ŀ��ƽ̨���̿��
20.3.1 �������˵���
20.3.2 ���ú�������ļ��Ķ�Ӧ��ϵ
20.3.3 ���Թ��̿��
20.4.1 ARM��������ؽṹ
20.4.2 ����machine_desc�ṹ
20.4.3 ���봦����
20.4.4 ���붨ʱ���ṹ
20.4.5 ���Դ���ṹ
20.5.1 ��������ʼ��
20.5.2 �˿�ӳ��
20.5.3 �жϴ���
20.5.4 ��ʱ������
20.5.5 �������մ���
}
arch(mach-xxx��ͬ������, arch-xxx��ͬƽ̨���)
{
    archĿ¼��ÿ��ƽ̨�Ĵ��붼���������ں˴�����ͬ��Ŀ¼�ṹ����arch/armĿ¼Ϊ������Ŀ¼��mm��lib��kernel��boot
Ŀ¼���ں�Ŀ¼�¶�ӦĿ¼�Ĺ�����ͬ�����⣬����һЩ���ַ���mach��ͷ��Ŀ¼����Ӧ��ͬ�������ض��Ĵ��롣��archĿ¼
�ṹ���Կ�����ƽ̨��صĴ��붼��ŵ�archĿ¼�£�����ʹ�����ں�Ŀ¼��ͬ�Ľṹ��

    ��ֲ�ں˵��µ�ƽ̨��Ҫ�������޸�archĿ¼�¶�Ӧ��ϵ�ṹ�Ĵ��롣һ����˵�����е���ϵ�ṹ�ṩ�������Ĵ����ܣ�
��ֲֻ��Ҫ���մ����ܱ�д��Ӧ����Ӳ��ƽ̨�Ĵ��뼴�ɡ��ڱ�д��������У���Ҫ�ο�Ӳ������ư���ͼֽ���������ߡ�
�����ֲ�ȡ�

    ��arch/armĿ¼����������Ŀ¼���ļ���������mach�ַ�����ͷ����Ŀ¼���ĳ���ض���ARM�ں˴���������ļ���
��mach-s3c2410Ŀ¼���S3C2410��S3C2440��ص��ļ������⣬��machĿ¼�»���������ض�������Ӳ���Ĵ��롣

    bootĿ¼�����ARM�ں�ͨ�õ�������ص��ļ���kernel����ARM��������ص��ں˴��룻mmĿ¼����ARM��������ص��ڴ�
�����ִ��롣������ЩĿ¼�Ĵ���һ�㲻��Ҫ�޸ģ����Ǵ�����������ĵط���ֻҪ�ǻ���ARM�ں˵Ĵ���һ�㶼ʹ����ͬ��
�ں˹�����롣

    ͨ������ARM��������ϵĿ¼�Ľṹ���������mini2440������Ĵ�����Ҫ���޸�Kconfig�ļ���Makeifle�ļ����Լ���
mach-s3c2410Ŀ¼��������ض�Ӳ���Ĵ��롣

�������˵���
�޸�arch/arm/mach-s3c2410/Kconfig�ļ�����endmenu֮ǰ������������ݣ�
    config ARCH_MINI2440     // ���������ƺ궨��  
    bool "mini2440"        // ����������  
    select CPU_S3C2440     // ������ʹ�õĴ���������  
    help  
        Say Y here if you are using the mini2440.    // ������

���ú�������ļ��Ķ�Ӧ��ϵ
    �����ú�������ļ���Ӧ��ϵ֮ǰ�����Ƚ���һ���յĴ����ļ�����arch/arm/mach-s3c 2410Ŀ¼�½���mach-mini2440.c�ļ���
���ڴ����mini2440��������صĴ��롣
    ����mach-mini2440.c�ļ����޸�arch/arm/mach-s3c2410/Makefile�ļ������ļ�������mach-mini2440.c�ļ��ı�����Ϣ��
    obj-$(CONFIG_ARCH_MINI2440) += mach-mini2440.o 
        
make ARCH=arm CROSS_COMPILE=arm-linux- menuconfig
Load an Alternate Configuration File�˵������������"arch/arm/ configs/s3c2410_defconfig"
����System Types�˵����S3C24XX Implementations�˵���
make ARCH=arm CROSS_COMPILE=arm-linux- bzImage
       

����Ŀ��ƽ̨������
������ں˴��������������Ӵ�����ʾvmlinux.lds�ļ�����ʧ�ܡ� 

ARM��������ؽṹ
arch/arm/kernel/vmlinux.lds
ASSERT((__proc_info_end - __proc_info_begin), "missing CPU support")
    

��arch/armĿ¼������__proc_info_begin��ţ�
    $ grep -nR '__proc_info_begin' *   

    machine_desc�ṹ�����˴�������ϵ�ṹ��š������ڴ��С�����������ơ�I/O����������ʱ���������ȡ�
ÿ��ARM�˵Ĵ�����������ʵ��һ��machine_desc�ṹ���ں˴����ʹ�øýṹ��    
}

arch(file)
{
Kconfig   
// ѡ��˵������ļ�  
Kconfig.debug  Makefile   
// makeʹ�õ������ļ�  
boot   
// ARM������ͨ����������  
common     
// ARM������ͨ�ú���  
configs    
// ����ARM�������ĸ��ֿ���������  
kernel     
// ARM�������ں���ش���  
lib        
// ARM�������õ��Ŀ⺯��  
mach-aaec2000  mach-clps711x  mach-clps7500  mach-ebsa110  mach-epxa10db  mach-footbridge  mach-h720x  
mach-imx  mach-integrator  mach-iop3xx  mach-ixp2000       
// Intel IXP2xxxϵ�����紦����  
mach-ixp4xx        
// Intel IXp4xxϵ�����紦����  
mach-l7200  mach-lh7a40x  mach-omap1  mach-pxa   
// Intel PXAϵ�д�����  
mach-rpc  mach-s3c2410   
// ����S3C24xxϵ�д�����  
mach-sa1100  mach-shark  mach-versatile  mm         
// ARM�������ڴ溯����ش���  
nwfpe  oprofile  plat-omap  tools  // ���빤��  vfp
}