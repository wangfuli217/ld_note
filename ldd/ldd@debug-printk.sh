������/proc������ļ�������ͨ��sysfs����絽����Ϣ

debug(�ں��еĵ���֧��)
{
------ �ں��еĵ���֧�� ------
CONFIG_DEBUG_KERNEL = y  
CONFIG_DEBUG_SLAB = y           # �ڴ���������ǳ�ʼ����malloc[0xa5] free[0x6b]
CONFIG_DEBUG_PAGEALLOC = y         # ���ͷ�ʱ��ȫ���ڴ�ҳ���ں˵�ַ�ռ����Ƴ���  ���ٶ�λ�ض����ڴ��𻵴��������λ�á�
CONFIG_DEBUG_SPINLOCK = y       # ����δ��ʼ���������Ĳ����������������ν⿪ͬһ���Ĳ�����
CONFIG_DEBUG_SPINLOCK_SLEEP = y # ӵ��������ʱ��������ͼ
CONFIG_INIT_DEBUG                # ���Ϊ__init(��__initdata)�ķ��Ž�����ϵͳ��ʼ������ģ��װ��֮�󱻶�ʧ��
CONFIG_INIT_INFO                # �����������gdb�����ںˣ�����Ҫ��Щ��Ϣ CONFIG+FRAME_POINTERѡ��
CONFIG_MAGIC_SYSRQ                # ��SysRqħ��

CONFIG_DEBUG_STACKOVERFLOW = y
CONFIG_DEBUG_STACK_USAGE = y    # ջ���

CONFIG_IKCONFIG = y
CONFIG_IKCONFIG_PROC = y         # �����������ں�����״̬�������ں��У���ͨ��/proc���ʡ�

CONFIG_DEBUG_DRIVER = y         # ��Device Drivers�˵��У���������������еĵ�����Ϣ�����԰������ٵײ�֧�ִ����е����⡣
CONFIG_INPUT_EVBUG = y             # ��Device Drivers/Input device support�У������¼��������κζ����������롣

CONFIG_KLLSYMS = y              # Gernel setup /Standard features �൱��gcc -gѡ��
}

printk(klogd, dmesg)
{
------ ͨ����ӡ���� ------
http://www.ibm.com/developerworks/cn/linux/l-kernel-logging-apis/
printk(KERN_DEBUG "Here I am: %s %i\n", __FILE__, __LINE__);    ��ͬ����
printk("<7>" "Here I am: %s %i\n", __FILE__, __LINE__);         ��ͬ����
printk("<7> Here I am: %s %i\n", __FILE__, __LINE__);           ��ͬ����

0. printk�����ܹ����ն���һ�������ʾ��СΪ1024�ֽڵ��ַ�����
printk 1. ��ʾ��־����ĺ��չ��Ϊһ���ַ������ڱ���ʱ��Ԥ�����佫������Ϣ�ı�ƴ����һ�������Ϊʲô��������������ȼ���
          ��ʽ���ִ�֮��û�ж��ŵ�ԭ��
       2. KERN_EMERG"<0>" KERN_ALERT"<1>" KERN_CRIT"<2>" KERN_ERR"<3>" KERN_WARNING"<4>" KERN_NOTICE"<5>" KERN_INFO"<6>" KERN_DEBUG"<7>"
            KERN_EMERG    <0>    ������Ϣ������ϵͳ������ ����ֱ�ӱ����͵�����̨
            KERN_ALERT    <1>    ������������Ĵ���
            KERN_CRIT    <2>    ���ش���Ӳ���������           ���ص�Ӳ�����������ʧ��
            KERN_ERR    <3>    ����״����һ����������������ϣ�  �����������ڱ���Ӳ���Ĵ�����Ϣ
            KERN_WARNING    <4>    ����״�������ܵ��´���      ϵͳ��ȫ��ص���Ϣ���
            KERN_NOTICE    <5>    ���Ǵ��󣬵���һ����Ҫ״��     �����Ҫע������
            KERN_INFO    <6>    ������Ϣ
            KERN_DEBUG    <7>    �����ڵ��Ե���Ϣ
            KERN_DEFAULT    <d>    Ĭ���ں���־����
            KERN_CONT    <c>    ��־�м��������������µ�ʱ��أ�
       
       
       3. δָ�����ȼ���printk�����õ�Ĭ�ϼ�����DEFAULT_MESSAGE_LOGLEVEL �������kernel/printk.c�б�ָ��Ϊһ��������
          #define DEFAULT_MESSAGE_LOGLEVEL CONFIG_DEFAULT_MESSAGE_LOGLEVEL    # kernel/printk.c
          #define CONFIG_DEFAULT_MESSAGE_LOGLEVEL 4                         # include/generated/autoconf.h
       4. ����̨��һ���ַ�ʽ���նˣ�һ�����ڴ�ӡ����һ�����ڴ�ӡ����
       5. �����ȼ�С��console_loglevel�������������ֵ����Ϣ������ʾ������ /proc/sys/kernel [4       4       1       7]
       echo "1       4       1      7" > /proc/sys/kernel/printk
       echo "0[�µĴ�ӡ����]       4       0      7" > /proc/sys/kernel/printk
           #define console_loglevel (console_printk[0])            4     ��ǰ����־����
           #define default_message_loglevel (console_printk[1])    4     δ��ȷָ����־����ʱ��Ĭ����Ϣ����
           #define minimum_console_loglevel (console_printk[2])    1     ��С�������־����
           #define default_console_loglevel (console_printk[3])    7     ����ʱ��Ĭ����־����
           192.168.1.232 [7       4       1       7]
           [rsyslogd]
           rsyslogd 1992 root    1w   REG              253,3    19986    2754435 /var/log/messages
           rsyslogd 1992 root    2w   REG              253,3    24900    2754371 /var/log/cron
           rsyslogd 1992 root    3r   REG                0,3        0 4026532071 /proc/kmsg
           rsyslogd 1992 root    4w   REG              253,3     1037    2754504 /var/log/secure
           rsyslogd 1992 root    5w   REG              253,3     1179    2754424 /var/log/maillog

           console_loglevel �ĳ�ʼֵ��DEFAULT_MESSAGE_LOGLEVEL�����ҿ���ͨ��sys_syslogϵͳ���ý����޸ġ�
           ����klogdʱ����ָ��-c���������޸����������
           
           klogd ��һ��ר�Žػ񲢼�¼ Linux �ں���Ϣ���ػ����̡���klogctl�����л����Ϣͨ��syslog��ʽ��ӡ������
                 syslog�Ĵ�ӡ������/etc/syslog.conf�����ļ���
                 klogd����ָ��-f�������������ָ�����ļ��С������޸�/etc/syslog.conf
                 
           klogd -c 7 ## �޸�/proc/sys/kernel/printk������console_loglevel��ֵ��
           
           busybox -> klogd dmesg
           int klogctl(int type, char *bufp, int len);
               SYSLOG_ACTION_CLOSE (0)    �ر���־��δʵ�֣�
               SYSLOG_ACTION_OPEN (1)    ����־��δʵ�֣�
               SYSLOG_ACTION_READ (2)    ����־��ȡ
               SYSLOG_ACTION_READ_ALL (3)    ����־��ȡ������Ϣ�����ƻ��أ�
               SYSLOG_ACTION_READ_CLEAR (4)    ����־��ȡ�����������Ϣ
               SYSLOG_ACTION_CLEAR (5)    �����������
               SYSLOG_ACTION_CONSOLE_OFF (6)    Disable printks to the console
               SYSLOG_ACTION_CONSOLE_ON (7)    �������̨ printk
               SYSLOG_ACTION_CONSOLE_LEVEL (8)    ����Ϣ��������Ϊ���ƽ���
               SYSLOG_ACTION_SIZE_UNREAD (9)    ������־��δ��ȡ���ַ���
               SYSLOG_ACTION_SIZE_BUFFER (10)    �����ں˻���������С
           
           busybox -> syslogd
            #    dev_log_name = xmalloc_follow_symlinks("/dev/log");
            #    if (dev_log_name) {
            #        safe_strncpy(sunx.sun_path, dev_log_name, sizeof(sunx.sun_path));
            #        free(dev_log_name);
            #    }
            #    unlink(sunx.sun_path);
            #    
            #    sock_fd = xsocket(AF_UNIX, SOCK_DGRAM, 0);
            #    xbind(sock_fd, (struct sockaddr *) &sunx, sizeof(sunx));
            #    chmod("/dev/log", 0666);
            netstat -anp | grep rsyslogd
           unix  21     [ ]         DGRAM                    13302  1992/rsyslogd       /dev/log
           
/dev/log����rsyslogd���̴���������ϵͳ�������̵Ĵ�ӡ����ΪAF_UNIX���͵�DGRAM����socket��
/proc/kmsg�� ��rsyslogd���̼��������������ں˵�printk��ӡ��Ϣ��  
           
           
        6. ���ϵͳͬʱ������klogd��syslogd��������console_loglevelΪ��ֵ���ں˶��Ὣ֮׷�ӵ�/var/log/messages�С�
           ��װsyslogd�����ý��д��� ���klogdû�����У���Щ��Ϣ�Ͳ��ᴫ�ݵ��û��ռ䡣
        7. klogd ���ᱣ��������ͬ����Ϣ�У���ֻ�ᱣ��������ͬ�ĵ�һ�У���������ӡ��һ�е��ظ�������
        8. Linux��Ϣ���������ص��ǣ��������κεط�����printk���������жϴ�������Ҳ���Ե��ã����Ҷ��������Ĵ�Сû�����ƣ�
           Ψһ��ȱ����ǿ��ܶ�ʧĳЩ���ݡ�
}

syslog(klogctl)
{
----- syslog
syslog ���ã����ں��е��� ./linux/kernel/printk.c �� do_syslog����һ����Խ�С�ĺ��������ܹ���ȡ�Ϳ����ں˻���������
ע���� glibc 2.0 �У����ڴʻ� syslog ʹ�ù��ڹ㷺��������������Ʊ��޸ĳ� klogctl����ָ���Ǹ��ֵ��ú�Ӧ�ó���
syslog �� klogctl�����û��ռ��У���ԭ�ͺ�������Ϊ��

int syslog( int type, char *bufp, int len );
int klogctl( int type, char *bufp, int len ); 
}
          
           
print_dev_t(��ӡ�豸���)
{
------ ��ӡ�豸��� ------
int print_dev_t(char *buff, dev_t dev);
char *format_dev_t(char *buff, dev_t dev);
���豸��Ŵ�ӡ�������Ļ������� print_dev_t  ���ص��Ǵ�ӡ���ַ�����format_dev_t���ص��ǻ�������
print_dev_t���ش�ӡ�ַ�����format_dev_t���ػ�����ָ�롣ע�⻺����char *buffer�Ĵ�СӦ������20B��
}       

           
printk_limit(�ٶ�����)
{
------ �ٶ����� ------
int printk_ratelimit(void)�ڴ�ӡһ�����ܱ��ظ�����Ϣ֮ǰ��Ӧ�����������������
if(printk_ratelimit()) //Ϊ�˱���printk�ظ�������������ϵͳ���ں�ʹ�����º��������������
    printk(KERNEN_NOTICE "Ths printer is still on fire\n");
    
    
printk_delay ֵ��ʾ����printk��Ϣ֮����ӳٺ��������������ĳЩ�����Ŀɶ��ԣ���ע�⣬��������ֵΪ0�������ǲ�����ͨ��/proc���õġ�

printk_ratelimit ��������Ϣ֮���������Сʱ��������ǰ����Ϊÿ 5 ���ڵ�ĳ���ں���Ϣ������
                 �����´���Ϣ֮ǰӦ�õȴ���������
                 
printk_ratelimit_burst�� ��Ϣ�������� printk_ratelimit_burst ����ģ���ǰ����Ϊ 10����
                 �ڽ����ٶ�����֮ǰ���Խ��ܵ���Ϣ����

ע�⣬���ں��У��ٶ��������ɵ����߿��Ƶģ��������� printk ��ʵ�ֵġ����һ�� printk �û�Ҫ������ٶ����ƣ�
��ô���û�����Ҫ����printk_ratelimit������
}    

setconsole(�ض������̨��Ϣ)
{
------ �ض������̨��Ϣ ------        
�ں˿��Խ���Ϣ���͵�һ��ָ�����������̨��Ĭ������£�"����̨"���ǵ�ǰ�������նˡ�
�������κ�һ������̨�ϵ���ioctl(TIOCLINUX)��ָ��������Ϣ�����������նˡ�

setconsole������ָ��ϵͳ�նˡ�
setconsole [serial][ttya][ttyb]
������
    serial ��ʹ��PROM�նˡ�
    ttya,cua0��ttyS0 ��ʹ�õڣ��������豸��Ϊ�նˡ�
    ttyb,cua1��ttyS1 ��ʹ�õڣ��������豸��Ϊ�նˡ�
    video ��ʹ�������ϵ��ֿ���Ϊ�նˡ�

    setconsole ttyS0
}


------ ��Ϣ��α���¼ ------    
printk��������Ϣд��һ������Ϊ__LOG_BUF_LEN�ֽڵ�ѭ���������У�
---- ���ǿ��������ں�ʱΪ__LOG_BUF_LENָ��4KB-1MB֮���ֵ��
Ȼ�󣬸ú����ỽ���κ��ڵȴ���Ϣ�Ľ��̣�����Щ˯����syslogϵͳ�����ϵĽ��У��������ڶ�ȡ/proc/kmsg�Ľ��̡�

/proc/kmsg���ж�����ʱ����־�������б���ȡ�����ݾͲ��ٱ�����
syslogϵͳ����ȷ��ͨ��ѡ�����־���ݱ�����Щ���ݣ��Ա���������Ҳ��ʹ�á�


------ �����͹ر���Ϣ ------    
1������ͨ���ں�������ɾ��������һ����ĸ�����������ÿһ����ӡ��䡣
2���ڱ���ǰ�޸�CFLAGS�����������һ�ν���������Ϣ��
3��ͬ���Ĵ�ӡ���������ں˴�����Ҳ�������û�������ʹ�ã���ˣ�������Щ����ĵ�����Ϣ��
   ��������Ͳ��Գ��������ͬ���ķ�ʽ�����й���
----  ͷ�ļ�
/*
 * Macros to help debugging
 */

#undef PDEBUG             /* ȡ����PDEBUG�Ķ��壬�Է�ֹ�ظ����� */
#ifdef SCULL_DEBUG
#  ifdef __KERNEL__
     /* �����򿪵��ԣ��������ں˿ռ� */
#    define PDEBUG(fmt, args...) printk( KERN_DEBUG "scull: " fmt, ## args)
#  else
     /* ���������û��ռ� */
#    define PDEBUG(fmt, args...) fprintf(stderr, fmt, ## args)
#  endif
#else
#  define PDEBUG(fmt, args...) /* ���Կ��عرգ������κ����� */
#endif

#undef PDEBUGG
#define PDEBUGG(fmt, args...) /* �����κ����飬�����Ǹ�ռλ�� */

#DEBUG = y

----  Makefile
# Add your debugging flag (or not) to EXTRA_CFLAGS
ifeq ($(DEBUG),y)
  DEBFLAGS = -O -g -DSCULL_DEBUG # "-O" is needed to expand inlines
else
  DEBFLAGS = -O2
endif

EXTRA_CFLAGS += $(DEBFLAGS)



