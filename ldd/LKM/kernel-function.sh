1. netlink �����첽���ƣ�������ʵ�ֺͿɶ�̬���ӵ��ŵ㡣
2. 896MB���ڵĳ���Ŀɱ�Ѱַ���ڴ������Ϊ�Ͷ��ڴ档�ڴ���亯��kmalloc���ǴӸ���������ڴ�ġ�����896MB��
   �ڴ������Ϊ�߶��ڴ棬ֻ���ڲ�����ʹ�ķ�ʽ����ӳ�����ܱ����ʡ�
3. start_kernel�������Ȼ��ʼ��CPU��ϵͳ��֮�����ڴ�ͽ��̹���ϵͳ��λ�������������ⲿ���ߺ�IO�豸��
   ���һ���Ǽ���init���̡�
Centos��
      POST(�ӵ��Լ�) -> Boot Sequence(BIOS�����������ϵͳ)->Boot Loader(MBR��������¼) -> Kernel(ramdisk) ->
rootfs(���ļ�ϵͳ) ->switchchroot ->/sbin/init(/etc/inittab /etc/init/*.conf) ->�趨���м��� -> ϵͳ��ʼ���ű�
-> �ر�������Ӧ���� -> �����ն�

   
   
   
4. �ں�����Ӳ���ṩ�Ĳ�ͬ�Ķ�ʱ����֧��æ�ȴ���˯�ߵȴ���ʱ����صķ���
   �ں˶�ʱ������jiffies HZ xtinme
   Pentiumʱ���������TSC
   ʵʱ��RTC
5. ���е��߼���ַ�����ں������ַ�������е������ַ����һ�����߼���ַ��

param.h
jiffies.h

loops_per_jiffy(һ��jiffyʱ��������һ���ڲ����ӳ�ѭ���Ĵ���)
{
init/calibrate.c

BogoMIPS=loops_per_jiffy * 1���ڵ�jiffy�� * �ӳ�ѭ�����ĵ�ָ��
        =2394935*HZ*2/(1000000)
        =2394935*250*2/(1000000)
        =119.46
############## loops_per_jiffy  #######################
�����������У��ں˻���㴦������һ��jiffyʱ��������һ���ڲ����ӳ�ѭ���Ĵ�����jiffy�ĺ�������ϵͳ��ʱ��2�������Ľ���֮��ļ����
�������ϣ��ü�����뱻У׼������CPU�Ĵ����ٶȡ�У׼�Ľ�����洢�ڳ�Ϊloops_per_jiffy���ں˱����С�ʹ��loops_per_jiffy��һ����
����ĳ�豸��������ϣ������С��΢�����ӳٵ�ʱ��

Ϊ������ӳ١�ѭ��У׼���룬�����ǿ�һ�¶�����init/calibrate.c�ļ��е�calibrate_delay()�������ú�������ʹ����������õ���
����ľ��ȡ����µĴ���Ƭ��(��һЩע��)��ʾ�˸ú����Ŀ�ʼ���֣��ⲿ�����ڵõ�һ�� loops_per_jiffy�Ĵ���ֵ��
loops_per_jiffy = (1 << 12); /* Initial approximation = 4096 */
printk(KERN_DEBUG "Calibrating delay loop...");
while ((loops_per_jiffy <<= 1) != 0) {
ticks = jiffies;  

  while (ticks == jiffies); /* Wait until the start of the next jiffy */
  ticks = jiffies;

  __delay(loops_per_jiffy);
 
  ticks = jiffies - ticks;
  if (ticks) break;
}

loops_per_jiffy >>= 1; /* This fixes the most significant bit and is
                          the lower-bound of loops_per_jiffy */
                          
�����������ȼٶ�loops_per_jiffy����4096�������ת��Ϊ�������ٶȴ�ԼΪÿ��100����ָ���1 MIPS�������������ȴ�jiffy��ˢ��(1���µĽ��ĵĿ�ʼ)��
����ʼ�����ӳ�ѭ��__delay(loops_per_jiffy)���������ӳ� ѭ��������1��jiffy���ϣ���ʹ����ǰ��loops_per_jiffyֵ(����ǰֵ����1λ)�޸���ǰ
loops_per_jiffy�����λ;�� �򣬸ú�������ͨ������loops_per_jiffyֵ��̽��������λ�����ں˼�������λ������ʼ�����λ��΢���侫�ȣ�

                          
896 MB���ڵĳ���Ŀɱ�Ѱַ���ڴ����򱻳����Ͷ��ڴ档�ڴ���亯��kmalloc()���ǴӸ���������ڴ�ġ�����896 MB���ڴ����򱻳�Ϊ�߶��ڴ棬
ֻ���ڲ�������ķ�ʽ����ӳ�����ܱ����ʡ�
�����������У��ں˻���㲢��ʾ��Щ�ڴ������ܵ�ҳ����
}

MIPS(ÿ�봦��İ��򼶵Ļ�������ָ����)
{
    MIPS(Million Instructions Per Second)�����ֳ�����ָ��ƽ��ִ���ٶ� Million Instructions Per Second����д��ÿ�봦��İ��򼶵�
��������ָ���������Ǻ���CPU�ٶȵ�һ��ָ�ꡣ����һ��Intel 80386 ���Կ���ÿ�봦��3����5�����������ָ������ǿ���˵80386
��3��5MIPS��CPU��MIPSֻ�Ǻ���CPU���ܵ�ָ�ꡣ
    ��Ϊʱ����CPU��������ÿһ������ִ��һ��ָ�����1Mips/MHzһ���CPU�ļ��޾���1Mips/MHz������һ����ʱ����1����Σ�ָ��ִ��
1��������������ڵ�ָ������ָ���ָ������ָ��Ứ��������ʱ�䣬���ڵ�51��Ƭ����12ָ�����ڵģ�����Ϊ1/12MIPS/MHz����������
CPU��������ˮ�߽ṹ��һ���������ֶ�֮���ܹ�����1Mips/MHz���ֲܿ��ɣ�PIC��һЩ��Ƭ�������԰쵽��
}

HZ_Jiffies(ϵͳ��ʱ�����Կɱ�̵�Ƶ���жϴ�������HZ)
{
time_after(jiffies, timeout)
time_before(jiffies, timeout)
time_after_eq(jiffies, timeout)
time_before_eq(jiffies, timeout)
jiffies jiffies_64
##################### HZ��Jiffies #########################
����ϵͳ��ʱ�����Կɱ�̵�Ƶ���жϴ���������Ƶ�ʼ�Ϊÿ��Ķ�ʱ������������Ӧ���ں˱���HZ��ѡ����ʵ�HZֵ��ҪȨ�⡣HZֵ�󣬶�ʱ�����ʱ���С��
��˽��̵��ȵ�׼ȷ�Ի���ߡ����ǣ�HZֵԽ��Ҳ�ᵼ�¿����͵�Դ���ĸ��࣬��Ϊ����Ĵ��������ڽ����ķ��ڶ�ʱ���ж��������С�
    HZ��ֵȡ������ϵ�ܹ�����x86ϵͳ�ϣ���2.4�ں��У���ֵĬ������Ϊ100����2.6�ں��У���ֵ��Ϊ1000������2.6.13�У����ֱ����͵���250��
�ڻ���ARM��ƽ̨�ϣ�2.6�ں˽�HZ����Ϊ100����Ŀǰ���ں��У������ڱ����ں�ʱͨ�����ò˵�ѡ��һ��HZֵ����ѡ���Ĭ��ֵȡ������ϵ�ܹ��İ汾��
jiffies������¼��ϵͳ����������ϵͳ��ʱ���Ѿ������Ĵ������ں�ÿ���ӽ�jiffies��������HZ�Ρ���ˣ�����HZֵΪ100��ϵͳ��1��jiffy����10ms��
������HZΪ1000��ϵͳ��1��jiffy��Ϊ1ms��
}

check_bugs(������������ϵ�ܹ���ص�Bug)
{
x86��/include/asm/x86/bugs.h      cpu_idle()
arm��/include/asm-generic/bugs.h  �պ���
}

initrd(������������صĳ�פ�ڴ��������̾���)
{
������
initrd= 

make config
INITRAMFS_SOURCE ѡ��ֱ�ӱ����ںˣ���Ҫ�ṩcpioѹ�������ļ������߰���initramfs��Ŀ¼����

mkinitramfs ���Դ���һ��initramfs����
documentation/filesystems/ramfsrootfs-initramfs.txt

}

�û�ģʽ�Ĵ���������ȱҳ�����ں�ģʽ�Ĵ���������
jiffies(ϵͳ����������ʱ���Ѵ����Ĵ���)
{
1. IDE drivers/ide/ide.c ��һֱ��ѯ������������æ״̬                               jiffies����ʵ��
2. jiffies����ת�� (jiffies - stream->start)/HZ  drivers/usb/host/ehci-sched.c      jiffiesת����
3. jiffies_64 drivers/cpufreq/cpufreq_stat.c �ļ��ж���� cpufreq_stats_update()    jiffies_64����ʵ��

����ʱ+æ�ȴ���  timeout = jiffies+HZ; while(time_before(jiffies, timeout)) continue; =>  ����ʱ+˯�ߵȴ�
����ʱ+˯�ߵȴ��� schedule_timeout(timeout); [ wait_event_timeout() ���������ʱ����ִ�� �� msleep(˯��ָ������ʱ��) ]
      ��ʱ��API��init_timer() DEFINE_TIMER() add_timer() mod_timer() del_timer() timer_pending()
      �û�̬��   clock_settime() �� clock_gettime() �������ں˶�ʱ������
                 setitime() �� getitime() ����һ�������ź����ض��ĳ�ʱ����      
����ʱ+æ�ȴ���  mdelay(����) udelay(΢��) ndelay(����) ����ʱAPIʹ��loops_per_jiffiesֵ��������Ҫ����ѭ���Ĵ���
����ʱ+˯�ߵȴ���

##################### ����ʱ jiffies ����ʱ #########################
    ���ֳ���ʱ�������������ڽ��������ġ�˯�ߵȴ����������ж������ģ���Ϊ�ж������Ĳ�����ִ��schedule()��˯��(4.2�ڸ������ж������Ŀ�������
������������)�����ж��н��ж�ʱ���æ�ȴ��ǿ��еģ����ǽ��г�ʱ���æ������Ϊ������������С����жϽ�ֹʱ��
���г�ʱ���æ�ȴ�Ҳ���������ɡ�

    Ϊ��֧���ڽ�����ĳʱ�̽���ĳ������ں�Ҳ�ṩ�˶�ʱ��API������ͨ��init_timer()��̬����һ����ʱ����Ҳ����ͨ��DEFINE_TIMER()��̬������ʱ����
Ȼ�󣬽��������ĵ�ַ�Ͳ����󶨸�һ��timer_list����ʹ��add_timer()ע�������ɣ�

    ���ں��У�С��jiffy����ʱ����Ϊ�Ƕ���ʱ��������ʱ�ڽ��̻��ж������Ķ����ܷ��������ڲ�����ʹ�û���jiffy�ķ���ʵ�ֶ���ʱ��֮ǰ���۵�˯�ߵȴ�
�����������ڶ̵ĳ�ʱ����������£�Ψһ�Ľ��;������æ�ȴ���
    æ�ȴ���ʵ�ַ����ǲ���������ִ��һ��ָ���ʱ�䣬Ϊ����ʱ��ִ��һ��������ָ���ǰ�Ŀ�֪���ں˻������������н��в���������ֵ�洢��
loops_per_jiffy�����С�����ʱAPI��ʹ����loops_per_jiffyֵ������������Ҫ����ѭ����������Ϊ��ʵ�����ֽ�����1΢�����ʱ��USB������������������
(drivers/usb/host/ehci-hcd.c)�����udelay()����udelay()���ڲ�����loops_per_jiffy��

}

TSC(Pentium)
{
TSC���Ŵ����������ٶȵı����ı仯���仯����������ͼ�����
rdtsc(low_tsc_tick0, high_tsc_tick0);
printk("hello world");
rdtsc(low_tsc_tick1, high_tsc_tick1);
exec_time = low_tsc_tick1 - low_tsc_tick0;

#####################  Pentiumʱ���������  #########################
����ʱ���������(TSC)��Pentium���ݴ������е�һ��������������¼�������������������ĵ�ʱ��������������TSC���Ŵ������������ʵı����ı仯���仯��
����ṩ�˷ǳ��ߵľ�ȷ�ȡ�TSCͨ�������������ͼ����롣ʹ��rdtscָ��ɲ���ĳ�δ����ִ��ʱ�䣬�侫�ȴﵽ΢�뼶��TSC�Ľ��Ŀ��Ա�ת��Ϊ�룬
�����ǽ������CPUʱ������(�ɴ��ں˱���cpu_khz��ȡ)��
}

rtc(ʵʱ��)
{
1. ��ȡ�����þ���ʱ�䣬��ʱ�Ӹ���ʱ�����жϣ�
2. ����Ƶ��Ϊ2~8192Hz֮����������ж�
3. ���ø澯�ź�

xtime���ڱ���ǽ��ʱ�ӡ�
do_gettimeofday(��ȡǽ��ʱ��)

#####################  rtc  #########################
�û��ռ�Ҳ����һϵ�п��Է���ǽ��ʱ��ĺ�����������
����(1) time()���ú�����������ʱ�䣬����¼�Ԫ(1970��1��1��00:00:00)��������������;
����(2) localtime()���Է�ɢ����ʽ��������ʱ��;
����(3) mktime()������localtime()�����ķ�����;
����(4) gettimeofday()��������ƽ̨֧�֣��ú�������΢�뾫�ȷ�������ʱ�䡣
}

mutex_spinlock(˯�ߵȴ���æ�ȴ�)
{
���ȴ���mutex ˯�ߵȴ�    ����������
�̵ȴ���spinlock æ�ȴ�   �ж�������

#####################  ������ �� ������  #########################
����������ȷ����ͬʱֻ��һ���߳̽����ٽ���������������ٽ������̱߳��벻ͣ��ԭ�ش�ת��ֱ����1���߳��ͷ���������ע�⣺������˵���̲߳����ں��̣߳�
����ִ�е��̡߳�����������ͬ���ǣ��������ڽ���һ����ռ�õ��ٽ���֮ǰ����ԭ�ش�ת������ʹ��ǰ�߳̽���˯��״̬��
���Ҫ�ȴ���ʱ��ϳ���������������������ʣ���Ϊ������������CPU��Դ����ʹ�û�����ĳ��ϣ�����2�ν����л�ʱ�䶼�ɱ���Ϊ�ǳ�ʱ�䣬���һ���������
�����߳�˯�ߣ������䱻����ʱ������Ҫ���л�������
������ˣ��ںܶ�����£�����ʹ�����������ǻ����������˵�����ף�
����(1) ����ٽ�����Ҫ˯�ߣ�ֻ��ʹ�û����壬��Ϊ�ڻ������������е��ȡ���ռ�Լ��ڵȴ�������˯�߶��ǷǷ���;
����(2) ���ڻ�����������پ���������½���ǰ�߳�����˯��״̬����ˣ����жϴ������У�ֻ��ʹ����������

������ӿڴ����˾ɵ��ź����ӿ�(semaphore)��������ӿ��Ǵ�-rt���ݻ������ģ���2.6.16�ں��б����������ںˡ�
����������ˣ����Ǿɵ��ź�����Ȼ���ں˺����������й㷺ʹ�á��ź����ӿڵĻ����÷����£�
static DEFINE_MUTEX(mymutex);       spinlock_t mylock = SPIN_LOCK_UNLOCKED;     static DECLARE_MUTEX(mysem);
mutex_lock(&mymutex);               spin_lock(&mylock);                         down(&mysem);
mutex_unlock(&mymutex);             spin_unlock(&mylock);                       up(&mysem); 

�ж����ν�ʹ���жϺͽ��̼�Ĳ������ٷ�����

[����������]->[����������+�ж�������]->[����������+�ж�������+��ռ]->[����������+�ж�������+��ռ+SMP]
 ����Ҫ����    local_irq_save                spin_lock_irqsave            spin_lock_irqsave
               local_irq_restore             spin_unlock_irqrestore       spin_unlock_irqrestore

��Դ�ٽ�������

(1) ����ռ�ںˣ���CPU����´����ڽ��������ĵ��ٽ���;
����Ҫ������

(2) ����ռ�ںˣ���CPU����´����ڽ��̺��ж������ĵ��ٽ���;    [�ж����ٽ���]
Ϊ�˱����ٽ�����������Ҫ��ֹ�жϡ�
          ����������������ж������ľ����ٽ���                              �����������������ж������ľ����ٽ���
local_irq_save(flags);     /* Disable Interrupts */                       local_irq_disable();     /* Disable Interrupts */
/* ... Critical Section ... */                                             /* ... Critical Section ... */
local_irq_restore(flags);  /* Restore state to what it was at Point A */  local_irq_enable();  /* Enable Interrupts */

(3) ����ռ�ںˣ���CPU����´����ڽ��̺��ж������ĵ��ٽ���;    [�ж�+��ռ���ٽ���]
  spin_lock_irqsave(&mylock, flags);
  /* ... Critical Section ... */
  /* Restore interrupt state to what it was at Point A */
  spin_unlock_irqrestore(&mylock, flags);
  
ͨ���ں�ȫ�ֱ���ά����ֻ���ڼ�����ֵΪ0��ʱ����ռ�ŷ������á�
  preempt_disable()
  preempt_enable()
  
(4) ����ռ�ںˣ�SMP����´����ڽ��̺��ж������ĵ��ٽ�����     [SMP+�ж�+��ռ���ٽ���] 
  spin_lock_irqsave(&mylock, flags);
  /* ... Critical Section ... */
  /*
    - Restore interrupt state and preemption to what it
      was at Point A for the local CPU
    - Release the lock
   */
  spin_unlock_irqrestore(&mylock, flags);
  
    ��SMPϵͳ�ϣ���ȡ������ʱ��������CPU�ϵ��жϱ���ֹ����ˣ�һ�����������ĵ�ִ�е�Ԫ(ͼ2-4�е�ִ�е�ԪA)��һ��CPU�����е�ͬʱ��һ���жϴ�����
������������һ��CPU�ϡ��Ǳ�CPU�ϵ��жϴ��������������ȴ���CPU�ϵĽ��������Ĵ����˳��ٽ������ж���������Ҫ����spin_lock()/spin_unlock()
  
������irq�������⣬������Ҳ�еװ벿(BH)���塣��������ȡ��ʱ��
spin_lock_bh()���ֹ�װ벿����spin_unlock_bh()����������ͷ�ʱ����ʹ�ܵװ벿��  
  
}

atomic_op(ԭ�Ӳ���)
{

#####################  ԭ�Ӳ���  #########################
ԭ�Ӳ�����ʹ�ý�ȷ���������ü������ᱻ������ִ�е�Ԫ���������Ҳ������ʹ����ȥ������һ���ͱ��������ۡ�

�����ں�Ҳ֧��set_bit()��clear_bit()��test_and_set_bit()���������ǿ�����ԭ�ӵ�λ�޸ġ��鿴include/asm-your-arch/atomic.h
�ļ����Կ�����������ϵ�ܹ���֧�ֵ�ԭ�Ӳ�����
}

rwlock_t(�������Ķ�д������)
{

#####################  ����д��  #########################
��һ���ض��Ĳ��������������������Ķ���д�����塣���ÿ��ִ�е�Ԫ�ڷ����ٽ�����ʱ��Ҫô�Ƕ�Ҫô��д��������ݽṹ���������Ƕ�����ͬʱ���ж���д������
��ô����������õ�ѡ�����������߳�ͬʱ�����ٽ������������������������壺

rwlock_t myrwlock = RW_LOCK_UNLOCKED;   rwlock_t myrwlock = RW_LOCK_UNLOCKED;
read_lock(&myrwlock);                   write_lock(&myrwlock);    
read_unlock(&myrwlock);                 write_unlock(&myrwlock);  

net/ipx/ipx_route.c�е�IPX·�ɴ�����ʹ�ö���д������ʵʾ����һ������ipx_routes_lock�Ķ���д��������IPX ·�ɱ�Ĳ������ʡ�Ҫͨ������·�ɱ�ʵ�ְ�ת��
��ִ�е�Ԫ��Ҫ�����������Ҫ��Ӻ�ɾ��·�ɱ�����ڵ�ִ�е�Ԫ�����ȡд��������ͨ����·�ɱ������ȸ� ��·�ɱ�������ö࣬ʹ�ö���д����������ܡ�

��д����irq����
read_lock_irqsave()��       write_lock_irqsave()
read_unlock_ irqrestore()�� write_unlock_irqrestore()
}

seqlock(д���ڶ���������)
{

#####################  ˳����(seqlock)  #########################
д���ڶ��Ķ���д������һ��������д�����ȶ�������ö������£��������ǳ����á�ǰ�����۵�jiffies_64��������ʹ��˳������һ�����ӡ�д�̲߳��صȴ�
һ���Ѿ������ٽ����Ķ�����ˣ����߳�Ҳ��ᷢ�����ǽ����ٽ����Ĳ���ʧ�ܣ������Ҫ���ԣ�
# u64 get_jiffies_64(void) /* Defined in kernel/time.c */
# {
#   unsigned long seq;
#   u64 ret;
#   do {
#     seq = read_seqbegin(&xtime_lock);
#     ret = jiffies_64;
#   } while (read_seqretry(&xtime_lock, seq));
#   return ret;
# }
д�߻�ʹ��write_seqlock()��write_sequnlock()�����ٽ�����
}

RCU(��ԶԶ����д����)
{

#####################  �������ơ�����(RCU)  #########################
�û���������߶�����Զ����д����ʱ�����ܡ�����������Ƕ��̲߳���Ҫ����������д�߳� ���ø��Ӹ��ӣ����ǻ������ݽṹ��һ�ݸ�����ִ�и��²�����
��������߿�����ָ�롣Ϊ��ȷ���������ڽ��еĶ���������ɣ�ԭ�Ӹ�����һֱ�����ֵ����� CPU�ϵ���һ���������л���ʹ��RCU������ܸ��ӣ���ˣ�
ֻ����ȷ����ȷʵ��Ҫʹ����������ǰ�ĵ�����ԭ���ʱ�򣬲�����ѡ������ include/linux/ rcupdate.h�ļ��ж�����RCU�����ݽṹ�ͽӿں�����
Documentation/RCU/*�ṩ�˷ḻ���ĵ���

fs/dcache.c�ļ��а���һ��RCU��ʹ��ʾ������Linux�У�ÿ���ļ�����һ��Ŀ¼�����Ϣ(dentry�ṹ��)��Ԫ������Ϣ(����� inode��)��ʵ�ʵ�����(�����
���ݿ���)������ÿ�β���һ���ļ���ʱ���ļ�·���е�����ᱻ��������Ӧ��dentry�ᱻ��ȡ��Ϊ�˼���δ���Ĳ� ����dentry�ṹ�屻�����ڳ�Ϊdcache��
���ݽṹ�С��κ�ʱ�򣬶�dcache���в��ҵ�������Զ����dcache�ĸ��²�������ˣ��� dcache�ķ���������RCUԭ����б�����


���磬ͨ����/proc/sys/kernel/printk�ļ�����һ���µ�ֵ�����Ըı��ں�printk��־�ļ������ʵ�ó���(�� ps)��ϵͳ���ܼ��ӹ���(��sysstat)����ͨ��
פ����/proc�е��ļ�����ȡ��Ϣ�ġ�
}


ZONE()
{
ZONE_DMA        
ZONE_NORMAL     kmalloc(�ں�) ֱ��ͨ��page����       kzalloc(�û�̬)
ZONE_HIGH       kmap��kunmap  ӳ���ȡ��ӳ��         vmalloc����ϴ�ռ�[������������������һ���������ڴ�]

1. �󱸻����� look aside buffer
2. slab
3. mempool
##################### �ڴ���� #########################
����һЩ�豸�������������ʶ���ڴ����Ĵ��ڣ����⣬�������������Ҫ�ڴ���亯���ķ��񡣱������ǽ���Ҫ�����������㡣

�����ں˻��Է�ҳ��ʽ��֯�����ڴ棬��ҳ��С��ȡ���ھ������ϵ�ܹ����ڻ���x86�Ļ����ϣ����СΪ4096B�������ڴ��е�ÿһҳ����һ����֮��Ӧ��
struct page(������include/linux/ mm_types.h�ļ���)��

�� ����32λx86ϵͳ�ϣ�Ĭ�ϵ��ں����ûὫ4 GB�ĵ�ַ�ռ�ֳɸ��û��ռ��3 GB�������ڴ�ռ�͸��ں˿ռ��1 GB�Ŀռ�(��ͼ2-5��ʾ)��
�⵼���ں��ܴ���Ĵ����ڴ���1 GB�����ơ���ʵ����ǣ�����Ϊ896 MB����Ϊ��ַ�ռ��128 MB�Ѿ����ں����ݽṹռ�ݡ�ͨ���ı�3GB/1GB�ķָ��ߣ�
���Էſ�������ƣ��������ڼ������û����������ַ�ռ�Ĵ�С�����ڴ��ܼ��͵�Ӧ�ó����п��ܻ����һЩ���⡣

�ں�������ӳ�����896 MB�����ڴ�ĵ�ַ�������ַ֮���������ƫ��;�����ں˵�ַ�������߼���ַ����֧��"�߶��ڴ�"������£���ͨ���ض��ķ�ʽӳ��
��Щ���������Ӧ�������ַ���ں˽��ܷ��ʳ���896 MB���ڴ档���е��߼���ַ�����ں������ַ�������е������ַ����һ�����߼���ַ��

������ˣ��������µ��ڴ�����
����(1) ZONE_DMA(С��16 MB)����������ֱ���ڴ����(DMA)�����ڴ�ͳ��ISA�豸��24����ַ�ߣ�ֻ�ܷ��ʿ�ʼ��16 MB����ˣ��ں˽������׸�����Щ�豸��
����(2) ZONE_NORMAL(16��896 MB),�����ַ����Ҳ�������Ͷ��ڴ档���ڵͶ��ڴ�ҳ��struct page�ṹ�е�"����"�ֶΰ����˶�Ӧ���߼���ַ��
��  (3) ZONE_HIGH(����896 MB)��������ͨ��kmap()ӳ��ҳΪ�����ַ����ܷ��ʡ�(ͨ��kunmap()��ȥ��ӳ�䡣)��Ӧ���ں˵�ַΪ�����ַ�����߼���ַ��
�����Ӧ��ҳδ��ӳ�䣬���ڸ߶��ڴ�ҳ��struct page�ṹ���"����"�ֶν�ָ��NULL��

����kmalloc()��һ�����ڴ�ZONE_NORMAL���򷵻������ڴ���ڴ���亯������ԭ�����£�
����void *kmalloc(int count, int flags);
����count��Ҫ������ֽ�����flags��һ��ģʽ˵������֧�ֵ����б�־����include/linux./gfp.h�ļ���(gfp��get free page����д)������Ϊ���ñ�־��
����(1) GFP_KERNEL�����������������������ڴ档���ָ���˸ñ�־��kmalloc()��������˯�ߣ��Եȴ�����ҳ���ͷš�
����(2) GFP_ATOMIC�����ж�������������ȡ�ڴ档������ģʽ�£�kmalloc()���������˯�ߵȴ����Ի�ÿ���ҳ�����GFP_ATOMIC����ɹ��Ŀ����Ա���GFP_KERNEL�͡�
��������kmalloc()���ص��ڴ汣������ǰ�����ݣ�������¶���û��ռ�ɵ��ᵼ�°�ȫ���⣬������ǿ���ʹ��kzalloc()��ñ����Ϊ0���ڴ�
���������Ҫ�������ڴ滺����������Ҳ��Ҫ���ڴ�������������ϵ��������vmalloc()����kmalloc()��
����void *vmalloc(unsigned long count);
����count��Ҫ���������ڴ��С���ú��������ں������ַ��
��  vmalloc()��Ҫ��kmalloc()����ķ���ռ䣬���������������Ҳ��ܴ��ж������ĵ��á����⣬������vmalloc()���ص������ϲ��������ڴ�ִ��DMA��
���豸��ʱ�������ܵ�������������ͨ����ʹ��vmalloc()������ϴ�����������л�������

}

mempool()
{

}

slab()
{

}


look_aside_buffer(�󱸻�����)
{

}

HZ                  include/asm-your-arch/param.h         ÿ���ӵ�ϵͳʱ�ӽ�����
loops_per_jiffy     init/main.c                           ��������1��jiffyʱ����ִ���ⲿ�ӳ�ѭ���Ĵ���
timer_list          include/linux/timer.h                 ���ڴ��δ������ִ�еĺ�������ڵ�ַ
timeval             include/linux/time.h                  ʱ���
spinlock_t          include/linux/spinlock_types.h        ����ȷ�����е�һ�߳̽���ĳ�ٽ�����æ�ȴ���
semaphore           include/asm-your-arch/semaphore.h     һ������ָ��������ִ�����������ٽ����Ŀ�˯�ߵ�������
mutex               include/linux/mutex.h                 ����ź������½ֿ�
rwlock_t            include/linux/spinlock_types.h        ��-д������
page                include/linux/mm_types.h              �����ڴ�ҳ���ں˵ı�ʾ


time_after           include/linux/jiffies.h               ��Ŀǰ��juffiesֵ��ָ���Ľ�����ֵ���жԱ� 
time_after_eq                                               
time_before                                                 
time_before_eq                                              
schedule_timeout     kernel/timer.c                         ��ָ���ĳ�ʱ��������Ƚ���ִ��
wait_event_timeout   include/linux/wait.h                   ���ض�����Ϊ���ʱ������ָ�ִ��
DEFINE_TIMER         include/linux/timer.h                  ��̬����һ����ʱ��
init_timer           kernel/timer.c                         ��̬����һ����ʱ��
add_timer            include/linux/timer.h                  ����ʱʱ�䵽����ȶ�ʱ��ִ��
mod_timer            kernel/timer.c                         �޸Ķ�ʱ���ĵ���ʱ��
timer_pending        include/linux/timer.h                  ��鵱ǰ�Ƿ��ж�ʱ���ȴ�ִ��
udelay               include/asm-yourarch/delay.h           æ�ȴ�ָ����΢����
                     arch/your-arch/lib/delay.c             
rdtsc                include/asm-x86/msr.h                  ���pentium���ݴ������ϵ�TSC��ֵ
do_gettimeofday      kernel/time.c                          ���ǽ��ʱ��
local_irq_disable    include/asm-your-arch/system.h         ��ֹ��CPU�ϵ��ж�
local_irq_enable     include/asm-your-arch/system.h         ���ñ�CPU�ϵ��ж�
local_irq_save       include/asm-your-arch/system.h         �����ж�״̬����ֹ�ж�
local_irq_restore    include/asm-your-arch/system.h         ���ж�״̬�ָ�����Ӧ��local_irq_save()������ʱ��״̬
spin_lock            include/linux/spinlock.h[kernel/spinlock.c]  ��ȡ������
spin_unlock          include/linux/spinlock.h[kernel/spinlock.c]  �ͷ�������
spin_lock_irqsave    include/linux/spinlock.h[kernel/spinlock.c]  �����ж�״̬����ֹ��CPU�ϵ��жϺ���ռ����ס�ٽ����Է�ֹ������CPU���� 
spin_lock_irqrestore include/linux/spinlock.h[kernel/spinlock.c]   �ָ��ж�״̬��������ռ���ͷ���
DEFINE_MUTEX         include/mutex.h                           ��̬����һ��������
mutex_init           include/mutex.h                           ��̬����һ��������
mutex_lock           kernel/mutex.c                            ��ȡ������
mutex_unlock         kernel/mutex.c                            �ͷŻ�����
DECLARE_MUTEX        include/asm-your-arch/semaphore.h         ��̬����һ���ź���
init_MUTEX           include/asm-your-arch/semaphore.h         ��̬����һ���ź���
up                   arch/your-arch/kernel/semaphore.c         ��ȡ�ź���
down                 arch/your-arch/kernel/semaphore.c         �ͷ��ź���
atomic_inc           include/asm-your-arch/atomic.h            ִ��������������ԭ�Ӳ���  
atomic_inc_and_test    
atomic_dec             
atomic_dec_and_test    
clear_bit              
set_bit                
test_bit               
test_and_set_bit       
read_lock            include/linux/spinlock.h                 �������Ķ�д������
read_unlock          kernel/spinlock.c  
write_lock             
write_unlock           
write_lock_irqsave     
write_unlock_irqrestore 
down_read             kernel/rwsem.c                           �ź����Ķ�д���� 
up_read                
down_write             
up_write               
read_seqbegin         include/linux/seqlock.h                  seqlock����   
read_seqretry          
write_seqlock          
write_sequnlock        
kmalloc               include/linux/slab.h mm/slab.c          ��ZONE_NORMAL���������������ڴ�
kzalloc                include/linux/slab.h mm/util.c         ����kmalloc�����ڴ棬����������
kfree                  mm/slab.c                              �ͷ�kmalloc������ڴ�
vmalloc                mm/vmalloc.c                           ������������������һ���������ڴ�








