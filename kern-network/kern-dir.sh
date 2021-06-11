uml(2.6.16)
{
.config
http://uml.devloop.org.uk/kernels.html
UMLִ�У�
������Ҫһ�����ļ�ϵͳ���������ַ��http://fs.devloop.org.uk/���ؼ��ɣ�

ext: http://blog.csdn.net/larryliuqing/article/details/8178958           �����ͱ���
ext: http://blog.csdn.net/ztz0223/article/details/7874759                �����ͱ���
ext: http://www.360doc.com/content/14/1106/10/19184777_423005335.shtml   ����
make mrproper ARCH=um
make defconfig ARCH=um
make menuconfig ARCH=um
make ARCH=um [linux]   # make ARCH -B V=1

dd if=/dev/zero of=root_fs seek=100 count=1 bs=1M
mkfs.ext2 ./root_fs
mkdir /mnt/rootfs
mount -o loop root_fs /mnt/rootfs/

./linux ubd0_fs
./kernel ubda=root_fs mem=128M

$ dd if=/dev/zero of=swap bs=1M count=128
$ ./kernel ubda= root_fs ubdb=swap mem=128M

serial line 0 assigned pty /dev/ptyp1
ճ���û�ϲ�����ն˳�����Ӧ��tty���磺minicom���������£�
host% minicom -o -p /dev/ttyp1

arch/um/os-Linux/mem.c: In function ��create_tmp_file��:
arch/um/os-Linux/mem.c:216: error: implicit declaration of function ��fchmod��
make[1]: *** [arch/um/os-Linux/mem.o] Error 1
make: *** [arch/um/os-Linux] Error 2

�༭�ļ�arch/um/os-Linux/mem.c������ͷ�ļ�#include ���ɡ�
}

uml(tool)
{
ʹ��UML�͹���UML�Ĺ���˵�����£�
UMLd �C ���ڴ���UMLʵ��������ʵ������/�رյĺ�̨����
umlmgr �C���ڹ��������е�UMLʵ����ǰ̨���߳���
UML Builder �C ������ļ�ϵͳӳ������UMLģʽ����ϵͳ��װ����
uml switch2 ���ں�̨������û��ռ������л���
VNUML �C ����XML�����ԣ��������������UML���������糡����
UMLazi �C ���ú����л����������UML�Ĺ����ߡ�
vmon �C ���кͼ�ܶ��UML����������������ߣ���Python ��д��
umvs �C umvs����C++��Bash�ű�д�Ĺ��ߣ����ڹ���UMLʵ������Ӧ�ó����Ŀ���Ǽ�UML�����ú͹�����ʹ����ģ�壬ʹ�ñ�д��ͬ��UML���ø����ס�
MLN - MLN (My Linux Network) ��һ��perl�������ڴ������ļ�����UMLϵͳ���������磬ʹ��������������ú͹�������ס�MLN�������������ͼ򵥵ı�����Ա���������ļ�ϵͳģ�壬����һ����֯��ʽ�洢���ǡ���������ÿ������������������ֹͣ�ű�����һ��������������ֹͣ�����������MLN����һ��ʹ�ü������������硢��Ŀ�����������Խ�����������һ��
Marionnet �C һ����ȫ����������ʵ�飬����UML�������û��Ѻõ�ͼ�ν��档
}

dir()
{
   �׽��֣�
1. һ��Э���� net/socket.c net/protocols.c
   INETЭ���� net/ipv4/core/sock.c net/ipv4/af_inet.c net/ipv4/protocol.c
   �����ں������֧��Ӧ�ó��򿪷��ĺ����ӿڣ�����һϵ�б�׼���������׽��ֽӿڡ��׽���֧�ֶ��ֲ�ͬ���͵�Э���塣
UNIX��Э���塢TCP/IPЭ���塢IPXЭ����ȡ�
   �׽����ְ���3���������ͣ�SOCK_STREAM SOCK_DGRAM SOCK_RAW��ͨ��SOCK_STREAM�׽��ֿ��Է���TCPЭ�飬ͨ��SOCK_DGRAM
�׽��ֿ��Է���UDPЭ�飬ͨ��SOCK_RAW�׽��ֿ���ֱ�ӷ���IPЭ�顣

   �����
2. UDP /net/ipv4/udp.c net/ipv4/datagram.c
   TCP net/ipv4/tcp_input.c net/ipv4/tcp_output.c net/ipv4/tcp.c
   
   �����
3. IPv4 net/ipv4/ip_input.c net/ipv4/ip_output.c net/ipv4/forward.c

  ������·��
4. drivers/net/ppp_generic.c drivers/net/pppoe.c

   �����豸����
5. driver/net   

include/linux/skbuff.h �׽��ֻ���������
net/core/dev.c         dev_queue_xmit
}

family()
{
PF_UNIX
PF_INET
PF_IPX
PF_PACKET:�׽���ֱ�ӷ��������豸
PF_NETLINK���ں����û�̬����֮�佻������
}

.config()
{
��������һ��
/lib/modules/2.6.32-279.el6.x86_64/build/.config
/boot/config-2.6.32-279.el6.x86_64



}

kallsyms(���ں���ͨ��/proc/kallsyms��÷��ŵĵ�ַ)
{
��ע�ļ�
---------------------------------------------------------------------------
/usr/src/kernels/2.6.32-279.el6.x86_64/scripts/kallsyms
/proc/kallsyms

    ��������
���������ں�����ȫ���Եģ�������Ϊ��д��ĸ����T��U�ȡ�
A(Absolute):���ŵ�ֵ�Ǿ���ֵ�������ڽ�һ�����ӹ����в��ᱻ�ı�
b(BSS):������δ��ʼ����������BSS��
c(Common):��ͨ���ţ���δ��ʼ������
d(Data):�����ڳ�ʼ��������
g(Global):�������Сobject���ڳ�ʼ��������
i(Inderect):��ֱ�������������ŵķ���
n(Debugging):���Է���
r(Read only):������ֻ��������
s(Small):�������Сobject����δ��ʼ��������
t(Text):�����ڴ����
u:����δ����

Linux�ں˷��ű�/proc/kallsyms���γɹ���
---------------------------------------------------------------------------
./scripts/kallsyms.c��������System.map          �û�̬��������   kallsyms����
./scripts/kallsyms.c����vmlinux(.tmp_vmlinux)����kallsyms.S(.tmp_kallsyms.S)��Ȼ���ں˱�������н�kallsyms.S
(�ں˷��ű�)�����ں˾���uImage

./kernel/kallsyms.c��������/proc/kallsyms       �ں�̬��������
�ں�������./kernel/kallsyms.c����uImage�γ�/proc/kallsyms

/proc/kallsyms�������ں��еĺ�������(����û��EXPORT_SYMBOL)��ȫ�ֱ���(��EXPORT_SYMBOL������ȫ�ֱ���)


CONFIG_KALLSYMS
---------------------------------------------------------------------------
��2.6�ں��У�Ϊ�˸��õص����ںˣ�������kallsyms��kallsyms��ȡ���ں��õ������к�����ַ(ȫ�ֵġ���̬��)�ͷ�ջ����
������ַ������һ�����ݿ飬��Ϊֻ���������ӽ�kernel image���൱���ں��д���һ��System.map����Ҫ����CONFIG_KALLSYMS

.config
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y ���ű��а������еı���(����û����EXPORT_SYMBOL�����ı���)
CONFIG_KALLSYMS_EXTRA_PASS=y

make menuconfig
General setup  --->  
    [*] Configure standard kernel features (for small systems)  --->
        [*]   Load all symbols for debugging/ksymoops
        [*]     Include all symbols in kallsyms
        [*]     Do an extra kallsyms pass  

ע: ����CONFIG_KALLSYMS_ALL֮�󣬾Ͳ���Ҫ�޸�all_symbol��̬����Ϊ1��


arch/arm/kernel/vmlinux.lds.S
---------------------------------------------------------------------------
                   |--------------------|
                   |                    |
                   |                    |
                   ~                    ~
                   |                    |
                   |                    |
0xc05d 1dc0        |--------------------| _end
                   |                    |
                   |                    |
                   |    BSS             |
                   |                    |
                   |                    |
0xc05a 4500        |--------------------| __bss_start
                   |                    |
0xc05a 44e8        |--------------------| _edata
                   |                    |
                   |                    |
                   |    DATA            |
                   |                    |
                   |                    |
0xc058 2000        |--------------------| __data_start  init_thread_union
                   |                    |
0xc058 1000 _etext |--------------------|
                   |                    |
                   | rodata             |
                   |                    |
0xc056 d000        |--------------------| __start_rodata
                   |                    |
                   |                    |
                   | Real text          |
                   |                    |
                   |                    |
0xc02a 6000   TEXT |--------------------| _text        __init_end    
                   |                    |
                   | Exit code and data | DISCARD ���section���ں���ɳ�ʼ����
                   |                    |         �ᱻ�ͷŵ�
0xc002 30d4        |--------------------| _einittext
                   |                    |
                   | Init code and data |
                   |                    |
0xc000 8000 _stext |--------------------|<------------ __init_begin
                   |                    |
0xc000 0000        |--------------------|

}