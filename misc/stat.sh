cat stat  | tr ' ' "\n" | less -N

stat(process)
{
sprintf(buffer, "%d (%s) %c %d %d %d %d %d %u %lu \
%lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
task_pid_nr_ns(task, ns), /*����(�������������̣����߳�)��(task->pid)*/
tcomm, /*Ӧ�ó��������(task->comm)*/
state,/*���̵�״̬��Ϣ(task->state),����μ�http://blog.chinaunix.net/u2/73528/showart_1106510.html*/
ppid,/*������ID*/
pgid,/*�߳���ID*/
sid,/*�Ự��ID*/
tty_nr,/*�ý��̵�tty�ն˵��豸�ţ�INT��34817/256��=���豸�ţ���34817-���豸�ţ�=���豸��*/
tty_pgrp,/*�ն˵Ľ�����ţ���ǰ�����ڸý��������ն˵�ǰ̨����(����shell Ӧ�ó���)��PID*/
task->flags,/*���̱�־λ���鿴�ý��̵�����(������/include/kernel/sched.h��)*/
min_flt,/*�ۼƽ��̵Ĵ�ȱҳ����Copy on��Writeҳ������ҳ��*/
cmin_flt,/*�ý������е��ӽ��̷����Ĵ�ȱҳ�Ĵ���*/
maj_flt,/*��ȱҳ������ӳ���ļ��򽻻��豸�����ҳ������*/
cmaj_flt,/*�ý������е��ӽ��̷�������ȱҳ�Ĵ���*/
cputime_to_clock_t(utime),/*�ý������û�̬���е�ʱ�䣬��λΪjiffies*/
cputime_to_clock_t(stime),/*�ý����ں���̬���е�ʱ�䣬��λΪjiffies*/
cputime_to_clock_t(cutime),/*�ý������е��ӽ������û�̬���е�ʱ���ܺͣ���λΪjiffies*/
cputime_to_clock_t(cstime),/*�ý������е��ӽ������ں�̬���е�ʱ����ܺͣ���λΪjiffies*/
priority,/*���̵Ķ�̬���ȼ�*/
nice,/*���̵ľ�̬���ȼ�*/.
num_threads,/*�ý������ڵ��߳������̵߳ĸ���*/.
start_time,/*�ý��̴�����ʱ��*/.
vsize,/*�ý��̵������ַ�ռ��С*/.
mm ? get_mm_rss(mm) : 0,/*�ý��̵�ǰפ�������ַ�ռ�Ĵ�С*/.
rsslim,/*�ý�����פ�������ַ�ռ�����ֵ*/.
mm ? mm->start_code : 0,/*�ý����������ַ�ռ�Ĵ���ε���ʼ��ַ*/.
mm ? mm->end_code : 0,/*�ý����������ַ�ռ�Ĵ���εĽ�����ַ*/.
mm ? mm->start_stack : 0,/*�ý����������ַ�ռ��ջ�Ľ�����ַ*/.
esp,/*esp(32 λ��ջָ��) �ĵ�ǰֵ, ���ڽ��̵��ں˶�ջҳ�õ���һ��*/.
eip,/*ָ��Ҫִ�е�ָ���ָ��, EIP(32 λָ��ָ��)�ĵ�ǰֵ*/.
/* The signal information here is obsolete.
* It must be decimal for Linux 2.0 compatibility.
* Use /proc/#/status for real-time signals.
*/
task->pending.signal.sig[0] & 0x7fffffffUL,/*�������źŵ�λͼ����¼���͸����̵���ͨ�ź�*/.
task->blocked.sig[0] & 0x7fffffffUL,/*�����źŵ�λͼ*/.
sigign .sig[0] & 0x7fffffffUL,/*���Ե��źŵ�λͼ*/.
sigcatch .sig[0] & 0x7fffffffUL,/*��������źŵ�λͼ*/.
wchan,/*����ý�����˯��״̬����ֵ�������ȵĵ��õ�*/.
0UL,/*��swapped��ҳ��,��ǰû��*/.
0UL,/*�����ӽ��̱�swapped��ҳ���ĺͣ���ǰû��*/.
task->exit_signal,/*�ý��̽���ʱ���򸸽��������͵��ź�*/.
task_cpu(task),/*�������ĸ�CPU��*/.
task->rt_priority,/*ʵʱ���̵�������ȼ���*/.
task->policy,/*���̵ĵ��Ȳ��ԣ�0=��ʵʱ���̣�1=FIFOʵʱ���̣�2=RRʵʱ����*/.
(unsigned long long)delayacct_blkio_ticks(task),/**/.
cputime_to_clock_t(gtime),/**/.
cputime_to_clock_t(cgtime));/**/.
}


stat(proc)
{
��һ�е�CPU��������CPU������Ϣ���ܺ͡������CPUn��n�����֣���ʾ���Ǹ�CPU����Ϣ��������ֻ��һ��CPU��������CPU0��Ҳ����˵�ҵ�ǰ������Ϣ��ͬ��


user �� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣��û�̬��CPUʱ�䣨��λ��jiffies�� �������� niceֵΪ�����̡�1jiffies=0.01��
nice�� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣�niceֵΪ���Ľ�����ռ�õ�CPUʱ�䣨��λ��jiffies��
system �� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣�����ʱ�䣨��λ��jiffies��
idle �� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣���Ӳ��IO�ȴ�ʱ�����������ȴ�ʱ�䣨��λ��jiffies��
iowait �� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣�Ӳ��IO�ȴ�ʱ�䣨��λ��jiffies�� ��
irq�� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣�Ӳ�ж�ʱ�䣨��λ��jiffies��
softirq �� ��ϵͳ������ʼ�ۼƵ���ǰʱ�̣����ж�ʱ�䣨��λ��jiffies��
��2.6.11���˵�8��stealstolen time��which is the time spent in other operating systems when running in a virtualized environment
�� 2.6.24���˵�9�� guest�� which is the time spent running a virtual  CPU  for  guest operating systems under the control of the Linux kernel.

intr:���и����жϵ���Ϣ����һ��Ϊ��ϵͳ�������������������е��жϵĴ�����Ȼ��ÿ������Ӧһ���ض����ж���ϵͳ���������������Ĵ��������ζ�Ӧ����0���жϷ����Ĵ�����1���жϷ����Ĵ�������
ctxt:��������ϵͳ��������CPU�����������Ľ����Ĵ���
btime:�����˴�ϵͳ����������Ϊֹ��ʱ�䣬��λΪ��
processes:��ϵͳ��������������������ĸ���Ŀ
procs_running:��ǰ���ж��е��������Ŀ
procs_blocked:��ǰ���������������Ŀ
���Դ�����ļ���ȡһЩ���������㴦������ʹ���ʡ�
������ʹ���� ��
��/proc/stat����ȡ�ĸ����ݣ��û�ģʽ��user���������ȼ����û�ģʽ��nice�����ں�ģʽ��system���Լ����еĴ�����ʱ�䣨idle�������Ǿ�λ��/proc/stat�ļ��ĵ�һ�С�CPU��������ʹ�����¹�ʽ�����㡣
CPU������   =   100   *��user   +   nice   +   system��/��user   +   nice   +   system   +   idle��
}





