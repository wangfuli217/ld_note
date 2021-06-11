ioctl(interface)
{

------ ioctl ------
1�����˶�ȡ��д���豸֮�⣬�󲿷�����������Ҫ����һ����������ͨ���豸��������ִ�и������͵�Ӳ�����ơ�  --- ioctl
   1. �����豸����
   2. ��������
   3. ���������Ϣ
   4. �ı䲨����
   5. ִ�����ƻ�
int ioctl(int fd, unsigned long cmd, ...);  ioctl���õķǽṹ���ʵ����ڶ��ں˿����������ڷ�������
...��ͨ����ʾ�ɱ���Ŀ�Ĳ�����
	ϵͳ���ò��������ɱ���Ŀ�Ĳ��������Ǳ�����о�ȷ�����ԭ�ͣ�������Ϊ�û�����ֻ��ͨ��Ӳ��"��"���ܷ������ǡ����ԣ�
	ԭ���е���Щ����Ŀ��ȷ����һ����������ֻ��һ����ѡ������
	ϰ������char *argp���壬�����õ�ֻ��Ϊ���ڱ���ʱ��ֹ�������������ͼ�顣
   
int (*ioctl)(struct inode *inode, struct file *filp, unsigned int cmd, unsigned long arg);

���κ�һ��ϵͳ���÷���ʱ�����ķ���ֵ�����ܱ����ģ�����ֵ����Ϊ��һ�����󣬲������������û��ռ��е�errno������
## ʵ���ϣ���ǰʹ�õ�����libcʵ����Ϊ����Χ��-4095~-1֮�䣬���ҵ��ǣ����ش�ĸ�����Ŷ�����С�Ĵ���Ų���ʮ�����á�


}

ioctl(cmd)
{
------ ѡ��ioctl���� ------
-EINVAL
cmd�ֶΣ� ��8λ�����豸��ص�"����"����8λ��һ�����к��룬���豸����Ψһ�ġ� include/asm/ioctl.h  documentation/ioctl-number.txt

type��������ѡ��һ������(��ס����ϸ�Ķ�ioctl-number.txt)��������������������������롣8λ��(__IOC_TYPEBITS)
number:˳��(˳����)������8λ��(__IOC_NRBITS).
direction�������������漰�����ݴ��䣬���λ�ֶζ������ݴ��䷽�� __IOC_READ __IOC_WRITE __IOC_NONE
size: ���漰���û����ݴ�С������ֶεĿ������ϵ�ṹ��أ�ͨ����13λ��14λ�� __IOC_SIZEBITS

linux/ioctl.h  asm/ioctl.h
��
__IO(type, nr)            ���ڹ����޲�����������
__IOR(type, nr, datatype) ���ڹ�������������ж�ȡ���ݵ�������
__IOW(type, nr, datatype) ���ڹ���д�����ݵ�����
__IOWR(type, nr, datatype) ���ڹ���˫�����ݴ���
��
__IOC_DIR(nr)
__IOC_TYPE(nr)
__IOC_NR(nr)
__IOC_SIZE(nr)
}


-------------- scull ���� --------------
/*
 * Ioctl definitions
 */

/* Use 'k' as magic number */
#define SCULL_IOC_MAGIC  'k'
/* Please use a different 8-bit number in your code */

#define SCULL_IOCRESET    _IO(SCULL_IOC_MAGIC, 0)

/*
 * S means "Set" through a ptr,
 * T means "Tell" directly with the argument value
 * G means "Get": reply by setting through a pointer
 * Q means "Query": response is on the return value
 * X means "eXchange": switch G and S atomically
 * H means "sHift": switch T and Q atomically
 */
#define SCULL_IOCSQUANTUM _IOW(SCULL_IOC_MAGIC,  1, int)
#define SCULL_IOCSQSET    _IOW(SCULL_IOC_MAGIC,  2, int)
#define SCULL_IOCTQUANTUM _IO(SCULL_IOC_MAGIC,   3)
#define SCULL_IOCTQSET    _IO(SCULL_IOC_MAGIC,   4)
#define SCULL_IOCGQUANTUM _IOR(SCULL_IOC_MAGIC,  5, int)
#define SCULL_IOCGQSET    _IOR(SCULL_IOC_MAGIC,  6, int)
#define SCULL_IOCQQUANTUM _IO(SCULL_IOC_MAGIC,   7)
#define SCULL_IOCQQSET    _IO(SCULL_IOC_MAGIC,   8)
#define SCULL_IOCXQUANTUM _IOWR(SCULL_IOC_MAGIC, 9, int)
#define SCULL_IOCXQSET    _IOWR(SCULL_IOC_MAGIC,10, int)
#define SCULL_IOCHQUANTUM _IO(SCULL_IOC_MAGIC,  11)
#define SCULL_IOCHQSET    _IO(SCULL_IOC_MAGIC,  12)

/*
 * The other entities only have "Tell" and "Query", because they're
 * not printed in the book, and there's no need to have all six.
 * (The previous stuff was only there to show different ways to do it.
 */
#define SCULL_P_IOCTSIZE _IO(SCULL_IOC_MAGIC,   13)
#define SCULL_P_IOCQSIZE _IO(SCULL_IOC_MAGIC,   14)
/* ... more to come */

#define SCULL_IOC_MAXNR 14

------ ����ֵ ------
����Ų�ƥ�䣺 -ENVAl(��ʶ) �� -ENOTTY(POSIX)

------ Ԥ�������� ------
1. �������κ��ļ�������
2. ֻ������ͨ�ļ�������
3. �ض����ļ�ϵͳ���͵�����

FIOCLEX������ִ��ʱ�رձ�ʶ(File IOctl Close on EXec).�����������ʶ֮�󣬵����ý���ִ��һ���½����ǣ��ļ������������ر�
FIONCLEX�����ִ��ʱ�رձ�ʶ(File IOctl Not Close on EXec)������ָ�ͨ�����ļ���Ϊ������������FIOCLEX���������Ĺ�����
FIOASYNC�����û�λ�ļ��첽֪ͨ��ע�����Linux 2.2.4�汾���ں˶�����ȷ��ʹ��������������޸�O_SYNC��ʶ��
FIOQSIZE�������ļ���Ŀ¼�Ĵ�С�����������豸�ļ�ʱ���ᵼ��ENOTTY����ķ��ء�
FIONBIO��File IOctl Non-Blocking IO

��Unix�Ŀ�����Ա��Կ���IO����������ʱ��������Ϊ�ļ����豸�ǲ�ͬ�ġ���ʱ����ioctlʵ����ص�Ψһ�豸�����նˣ�
��Ҳ������Ϊʲô�Ƿ���ioctl����ı�׼����ֵ��-ENOTTY�����������Ȼ��ͬ�ˣ�����fcntl����Ϊ�������ݶ�������������

------ ʹ��ioctl���� ------
asm/uaccess.h
int access_ok(int type, congst void *addr, unsigned long size);
type: VERIFY_READ �� VERIFY_WRITE��ȡ����Ҫִ�еĶ����Ƕ�ȡ����д���û��ռ��ڴ�����
addr���û��ռ��ַ
size���ֽ���
����ֵ��1��ʶ�ɹ���0��ʶʧ�ܡ������Ҫ���أ�����-EFAULT.


------ ȫ�ܺ����� ------
capget
capset
CAP_DAC_OVERRIDE, CAP_NET_ADMIN, CAP_SYS_MODULE, CAP_SYS_RAWIO, CAP_SYS_ADMIN, CAP_SYS_TTY_CONFIG
sys/sched.h
int capable(int capability);

------ ��ioctl���豸���� ------
�豸���ƣ�ͼ����ʾ��




