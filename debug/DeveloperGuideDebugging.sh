1. Hello World����Ҳ������(bug)��
   ����ڵ���printf()�ڼ䣬������յ��첽�źţ�����û�д������䷵��ֵ����ô�Ϳ��ܲ����������������
2. �Զ��������Ǳز����ٵġ� --- �Զ����еĲ��ԡ�

bug(debug hacks �����ĵ�)
{
echo 7 > /proc/sys/kernel/printk  # 
mount -o commit=1                 # �ļ�ϵͳ��־�����bug
ethtool -G ethX rx 64 tx 64       # e1000��������Ļ����������bug

�ںˣ�nosmp; e1000 ����NAPI��
EDAC(Error Detection And Correction) bluesmoke:����ڴ�ECCУ������PCI���ߵ�У�����
documentation/drivers/edac.txt documentation/edac.txt
http://bluesmoke.sourceforge.net/

*����ָ���ĳ��� 
(gdb) file app

*��ʾ��ǰ�ĵ���Դ�ļ��� 
(gdb) info source
}

bug(core dump �ֶ�����)
{
ulimit -c
ulimit -c unlimited
ulimit -c 1073741824
gdb -c core.7561 ./a.out

/etc/sysctl.conf
kernel.core_pattern = /var/core/%t-%e-%p-%c.core
%%   %�ַ�����
%p   ��ת����̵Ľ���ID
%u   ��ת����̵���ʵ�û�ID
%g   ��ת����̵���ʵ��ID
%s   ����ת����źű��
%t   ת��ʱ��
%h   ������
%e   ��ִ���ļ�����
%c   ת���ļ��Ĵ�С����
kernel.core_uses_pid = 0 #���Ǹı��ļ�����PID��λ�ã�������ø�ֵΪ1���ļ���ĩβ�ͻ����.PID
                         #��kernel.core_pattern��û��%p��ʱ����Ҫ����kernel.core_uses_pid����1���������Ϊ0.

echo "|/usr/local/sbin/core_helper" > /proc/sys/kernel/core_pattern
kernel.core_pattern = |/usr/local/sbin/core_helper %t-%e-%p-%c.core
kernel.core_uses_pid = 0

core_helper
#!/bin/sh
exec gzip - > /var/core/$1-$2-$3-$4.core.gz

�ּ�man 5 core��ʵ��
}

bug(core dump �Զ�����)
{
/etc/profile
ulimit -S -c unlimited��> /dev/null 2>&1
DAEMON_COREFILE_LIMIT='unlimited'        ##grep /etc/init.d DAEMON_COREFILE_LIMIT -rn ./* ,�������daemon�����б����á� 
fs.suid_dumpable=1
# 0 (default); 1 ("debug") 2 ("suidsafe")

�����ڴ�ת�������ų������ڴ棺
/proc/<PID>/coredump_filter
����0     ����ר���ڴ�
����1     ���������ڴ�
����2     file-backed ר���ڴ�
����3     file-backed �����ڴ�
����4     ELF�ļ�ӳ��

https://sourceware.org/gdb/current/onlinedocs/
man 5 core
getrlimit(RLIMIT_CORE)
signal(7)
1. ����û��Ȩ��дcoredump�ļ���#��������£�core�ڵ�ǰ�ļ��������ɡ��ļ��в���д�룻��ͬ�ļ������ڣ�
2. ��һ��������ͬ���ҿ���д�����ͨ�ļ����ڣ�ͬʱ���ļ���һ��Ӳ������֮������
3. RLIMIT_CORE, RLIMIT_FSIZE, getrlimit, ulimit
4. �ļ�ϵͳû��inode���ļ�ϵͳ�ﵽ�޶�ļ�ϵͳΪֻ���ġ�
5. û��д��Ȩ��
6. set-user-ID, set-group-ID �Լ� /proc/sys/fs/suid_dumpable ������

}

dbg(���Ժ�)
{
��GCC��������ʱ�򣬼���-ggdb3��������������Ϳ��Ե��Ժ��ˡ�
���⣬�����ʹ��������GDB�ĺ�������� ���鿴��صĺꡣ
    info macro �C ����Բ鿴���������Щ�ļ��ﱻ�����ˣ��Լ��궨����ʲô���ġ�
    macro �C ����Բ鿴��չ�������ӡ�
}

dbg(Դ�ļ�)
{
��������ʵ�Ҳ�Ǻܶ�ģ�̫������Ѷ�˵�Ҳ���Դ�ļ����������������Ѵ��������ļ�飺

    �������Ա�Ƿ������-g�����԰���debug��Ϣ��
    ·���Ƿ�������ȷ�ˡ�ʹ��GDB��directory����������Դ�ļ���Ŀ¼��

�����һ������/bin/ls��ʾ����ubuntu�£�
$ apt-get source coreutils
$ sudo apt-get install coreutils-dbgsym
$ gdb /bin/ls
GNU gdb (GDB) 7.1-ubuntu
(gdb) list main
1192    ls.c: No such file or directory.
in ls.c
(gdb) directory ~/src/coreutils-7.4/src/
Source directories searched: /home/hchen/src/coreutils-7.4:$cdir:$cwd
(gdb) list main
1192        }
1193    }
1194
1195    int
1196    main (int argc, char **argv)
1197    {
1198      int i;
1199      struct pending *thispend;
1200      int n_files;
}

thread(���̵߳���)
{
info threads
thread <thread_no>

info thread �鿴��ǰ���̵��̡߳�
thread <ID> �л����Ե��߳�Ϊָ��ID���̡߳�
break file.c:100 thread all  ��file.c�ļ���100�д�Ϊ���о���������߳����öϵ㡣
set scheduler-locking off|on|step��������ʵ����ġ���ʹ��step����continue������Ե�ǰ�������̵߳�ʱ��
    �����߳�Ҳ��ͬʱִ�еģ���ôֻ�ñ����Գ���ִ���أ�ͨ���������Ϳ���ʵ���������
    off �������κ��̣߳�Ҳ���������̶߳�ִ�У�����Ĭ��ֵ��
    on ֻ�е�ǰ�����Գ����ִ�С�
    step �ڵ�����ʱ�򣬳���next��һ�����������(��Ϥ������˿���֪��������ʵ��һ�����öϵ�Ȼ��continue����Ϊ)���⣬
    ֻ�е�ǰ�̻߳�ִ�С�

}
http://www.cnblogs.com/yoncan/p/3261798.html
DAEMON_COREFILE_LIMIT(���������������ʱ������coredump �ļ������취)
{
��ϵͳ������ulimit -SHc unlimited ,���򲢲�����corefile�ļ�;�ɴ�������ķ���:
1. ����ʹ����daemon�ķ�ʽ������, daemon��/etc/init.d/functions �϶���ĺ���,������һ����������

daemon() {
......
    # make sure it doesn't core dump anywhere unless requested
    corelimit="ulimit -S -c ${DAEMON_COREFILE_LIMIT:-0}"
......
    # And start it up.
    if [ -z "$user" ]; then
       $cgroup $nice /bin/bash -c "$corelimit >/dev/null 2>&1 ; $*"
    else
       $cgroup $nice runuser -s /bin/bash $user -c "$corelimit >/dev/null 2>&1 ; $*"
    fi
......    
}
����:
�� ��$corelimit����������corefile������,����$DAEMON_COREFILE_LIMIT ������corefile��С������,��Ϊ���ֵû�г�ʼ��,��${DAEMON_COREFILE_LIMIT:-0}ʹ�� DAEMON_COREFILE_LIMIT�Ĵ�СΪ0;
�����ִ�г����ʱ��,�ͻ�����corefile��СΪ0,��ʹ����ϵͳ����ʱʹ����ulimit -SHc unlimited; Ҳû��������;
��ֻҪ��/etc/init.d/functions�����$DAEMON_COREFILE_LIMIT�����ĳ�ʼֵ�ͺ���

# vi /etc/init.d/function
## user define set coredump
DAEMON_COREFILE_LIMIT="unlimited"

# ����limits.conf���ǲ���Ҫ����,��ʾ������
# vim /etc/security/limits.conf
*   soft        core                unlimited
*   hard        core                unlimited
}

bug(gdb)
{
gcc -Wall -O2 -g Դ����
CFLAGS = -Wall -O2 -g
./configure CFLAGS="-Wall -O2 -g"

-Wall : ����ѡ��
-Werror : �����ڸ澯����ʱ�����䵱������������

gdb ��ִ���ļ���
emacs M-x gdb

break ������          b iseq_compile
break �к�            
break �ļ���:�к�     b compile.c:516
break �ļ���:������   
break +ƫ����         b +3
break -ƫ����         
break *��ַ           b *0x08116fd6
break                 #�����ָ���ϵ�λ�ã�������һ�д��������öϵ㡣
info break
info breakpoints
delete <���>         #ɾ���ϵ�
tbreak #��ʱ�ϵ�

break �ϵ� if ����
b iseq_compile if node==0
break 46 if testsize==100
condition �ϵ���
condition �ϵ��� ����

clear
clear ������
clear �к�              #���Դ�ļ���ĳһ�������ϵ����жϵ�
clear �ļ���:�к�
clear �ļ���:������
delete �ϵ����
delete breakpoint        #ɾ�����еĶϵ�

disable                  #��ֹ���жϵ�
disable �ϵ���
disable display ��ʾ���
disable mem �ڴ�����

enable                  #��ֹ���жϵ�
enable �ϵ���
enable once   �ϵ���
enable delete �ϵ���
enable display ��ʾ���
enable mem �ڴ�����



backtrace == where == info stack
backtrace N #bt N ֻ��ʾ��ͷN��֡
backtrace -N #bt -N ֻ��ʾ���N��֡

backtrace full
bt full
backtrace full N
bt full N 
backtrace full -N
bt full -N
������ʾbacktrace����Ҫ��ʾ�ֲ�������


print == p
p argv
p *argv
p argv[0]
p argv[1]

�Գ����к����ĵ���
��gdb) print find_entry��1,0)
���ݽṹ���������Ӷ���
��gdb) print *table_start
���a��һ�����飬10��Ԫ�أ����Ҫ��ʾ�� 
(gdb) print *a@10

info registers # info reg
p $eax

#��ӡ���
p/��ʽ ����
x   ��ʾΪ16������
d   ��ʾΪ10������
u   ��ʾΪ�޷���10����
o   ��ʾΪ8����ֵ
t   ��ʾΪ2������
a   ��ַ
c   ��ʾΪ�ַ�
f   ����С��
s   ��ʾΪ�ַ���
i   ��ʾΪ��������
p/c $eax
p $pc
p $eip

#��ʾ�ڴ�����
x/��ʽ ��ַ
b   �ֽ� 1���ֽ�
h   ���� 2���ֽ�
w   ��   4���ֽ�
g   ˫�� 8���ֽ�

x $pc
x/i $pc

#������
disassemble == disas 
disas                    #�����뵱ǰ��������
disas ���������         #�����������������ں�������������
disas ��ʼ��ַ ������ַ  #������ӿ�ʼ��ַ��������ַ֮��Ĳ���
disassem $pc $pc+50

continue 5 #5�������ϵ㲻ֹͣ

#���ӵ�
watch #Ҫ���ҵ������ںδ����ı��ˣ�����ʹ��watch����
watch <���ʽ> #<���ʽ>�����仯ʱ��ͣ����

watch i != 10

awatch <���ʽ>
rwatch <���ʽ>
delete <���> #ɾ�����ӵ�

#�ı������ֵ
set variable <����>=<���ʽ>

# �����ڴ�ת���ļ�
generate-core-file
gcore #��������ֱ�������ں�ת���ļ�

attach
info proc #������Ϣ

continue ����
step ����
stepi ����
next ����
nexti ����
finish
until              # ִ�е�ָ������
until ��ַ         # ִ�е�ָ������

directory == dir #����Ŀ¼

list      == l   #��ʾ��������
list lineNum ��lineNum��ǰ��Դ������ʾ����
list + �г���ǰ�еĺ��������
list - �г���ǰ�е�ǰ�������
list function
set listsize count
������ʾ���������
show listsize
��ʾ��ӡ���������
list first,last
��ʾ��first��last��Դ������


sharedlibrary share #���ع����ķ���


set history expansion [on|off]
show history expansion
set history filename �ļ���
show history filename 
set history save  [on|off]
show history save
set history size ���� 
show history size

}


intel(hacks��57)
{
����ʱΪgccָ��-fomit-frame-pointerѡ��������ɲ�ʹ��ָ֡��Ķ������ļ�������������£�FP���ϲ�FP��Ϣ���ᱻ��¼��ջ�ϣ�
���Ǽ�ʹ��ˣ�GDBҲ����ȷ���֡��������ΪGDB�Ǹ��ݼ�¼�ڵ�����Ϣ�е�ջʹ����������֡��λ�õġ�

frame <��ֵ> #����ѡ��ջ֡
i frame 1
p sum

info proc mapping
info files
info target
}

hacks(������������)
{
��x86_64�У����κ�ָ���͵Ĳ�������������α��浽rdi,rsi,rdx,rcx,r8,r9�У������Ͳ����ᱣ�浽xmm0,xmm1......�У�
������Щ�Ĵ����Ĳ����ᱻ������ջ�ϣ���ˣ�����GDB��ϣ��ȷ�ϵĺ�����ͷ�ж�֮�󣬲鿴�Ĵ�����ջ���ɻ�ò������ݡ�



}
���Կ�ܣ�
https://en.wikipedia.org/wiki/List_of_unit_testing_frameworks

http://www.tiobe.com/tics/fact-sheet/

13���ƽ�������ڷ������Ѳ�׽�������Ӳ���������9���ر������һ����չ��
debug(13���ƽ����)
{
1. �������
       �ڿ�ʼ���Ժ��޸��κδ���֮ǰ��һ��Ҫ��֤��ȷ���������û�б�׼�ĵ�����˵���ɹ����ģ�
   ��û�������ĵ����������������û�й��ϣ�ֻ�ǲ�������⣬������bug.
2. ����ʧ��
       ������Ҫһ������������ʹ��������ʧ�ܣ�Ȼ�����Թ۲졣���������Ǳز����ٵġ�
   2.1 ���û�п������������Թ����ˣ���ô�ܹ�֪���Ѿ��޸��������أ�
   2.2 Ϊ����ѭ����13"�ûع���������bug�޸�"����Ҫһ������������
   2.3 �������������ʧ�ܵ��������أ����Ӽ����з������ʵ�����ʧ�ܵ����غࣺܶ��������������ϵͳ�򴰿ڹ�������
3. �򻯲�������
   �ų��������õ����أ����ٲ�������������ʱ�䣻ʹ�������������׵��ԡ�
4. ��ȡǡ���Ĵ�����Ϣ
   �����ȳ��ִ����������Ϣ������־��
5. ����Զ��׼�������
   ����Ȩ�ޣ��ڴ��С�����̿ռ����ƣ������������Եȵȡ�
6. �ӽ����з������ʵ
   �Ӳ�����Ա���û�������������������������ԭ���̽����
7. �ֶ���֮
   ����һ���嵥���г�Ǳ�������Լ���ε�������
   ���������ĺ�Դ����������ֿ�
       7.1 ���ٻ����ĸ���
       7.2 ����Դ����ĸ���
   �Ŵ���֮
       7.3 �ڴ����
       7.4 �����Դ�������
       7.5 ͬ������
8. ����Ҫ��bugƥ��
   ��ע��Щ���п����ҵ�bug�ķ��棬��ʹ����ܻ�ʹ�����ǳ���ζ�����һ������Ϥ������
9. һ��ֻ��һ�����
   ������һ��ֻ��һ���޸ģ�Ȼ�������Ƿ������塣���û�����壬�򷵻�ԭ��״̬��
10. ������Ƹ���
11. ���ȫ�¹۵�
    ���������һ�¡�
12. bug�����Լ��޸�
13. �ûع���������bug�޸�
} 

�����������׽������ֱ�ӽ��������ͽ���ֽ�Ϊ����������С�����⡣

debug(����)
{
�ع���ԣ��Զ����еġ�
��Ԫ���Ժ�ϵͳ���ԣ�ϵͳ�����ǽ������Ϊ������в��ԣ�
                    ��Ԫ���Թ�ע������������顣
��Ԫ���� -> �׺в��Ժͺںв���.
�׺в��Ժͺںв��ԣ��ںв��Ե���ҪĿ������֤�����Ԥ�ڹ��ܣ���������ʵ�ʵ�ʵ�֡�
                    �׺в�����Ҫ����ʵ�ֵı߽�����Լ�һЩ"Ū�ɳ�׾�Ĵ���"��          
}

debug(����)
{
1. ����bug:��Ԥ���
2. ż����bug���ڳ��������"���Ź�"���룬��bug��ͼ�ƹ���ʱ��������������Ȼ��������Ҫ���沢�����־�ļ���������Щ������������ù���
    �ҵ���ȷ���ն����������ģ����ü�¼��
3. Heisenbug��Խ���������ԣ���Խ�п��������ض���bug.
   Ҫô��������Դ��������ģ�Ҫô�����ڷǷ�ʹ���ڴ�����ģ�Ҫô�������Ż���������ġ�                    
4. ������bug�����bug�����bug�Ŀ����ԡ�
5. ����bug --- �����������
   �Լ�����������ͬ��bug���ֳ�����(truss��strace)��ʹ�ð�ȫ�����ӡ�
}

gdb(����һ������)
{ 
####����һ������
gdb �����ļ���
�� 
gdb -q				 # -q��ʾ����ʾ�汾��Ϣ������q��quit�˳�gdb
(gdb)file �ļ������� # 
shell ls             # ����ڵ��Թ�����Ҫ����linux����������gdb����ʾ��������shell����  
search get_sum       # search (�ַ���)�� forward(�ַ���)��������ӵ�ǰ�������ҵ�һ��ƥ����ַ�  
recerse-search main  # reverse-search (�ַ���)���������ӵ�ǰ����ǰ���ҵ�һ��ƥ����ַ���
    
###Core�ļ�
gdb exec_file core_file
��
gdb exec_file
core-file core_file

http://blog.csdn.net/unix21/article/details/9628933
                      
���г���                    run [arg]           F5
��������                    start [arg]         F10
��ͣ                        Ctrl-C              Ctrl-Alt-Break
��������                    cont                F5
                                                
step-over                   next                F10
step-into                   step                F11
step-out                    finish              Shift + F11
                                                
�ϵ�                        break file:lineno   
���ٶϵ�                    watch file:lineno   
�۲�ϵ�                    watch expr          
                                                
ջ����                      bt, where           
������ʽ                  print expr          
��ʾ���ʽ                  display expr        
                                                
���ñ���                    set var var=expr    
���û�������                set env var=[val]   
                                                
��ʾ��������                disassemble         
�ڻ���������ִ��step-over   nexti               F10
�ڻ���������ִ��step-into   stepi               F11
                                                
�����ϵ�                    condition bnum      
�¼��ϵ�                    handle,signal       
�쳣�ϵ�                    catch function      
�����ϵ�                    break function      
��ʱ�ϵ�                    tbreak              
�г����жϵ�                info breakpoints    
                                                
���������ӵ��ϵ�            commands bnum       
�����������                printf              
                                                
���Һ���                    info functions expr 
���ú���                    call expr           
�޸ĺ�������ֵ              return expr         
                                                
�������                    whatis arg     #���������ʾĳ������������         
�����������                ptype arg      #��whatis�Ĺ��ܸ�ǿ���������ṩһ���ṹ�Ķ���    
����ڴ�����                x arg               
ѡ��ջ֡                    frame arg           
���ջ֡                    info frame          

}

list(){
####List ָ��
list                 # ��ʾ10�д��룬���ٴ����и�������ʾ��������10�д���  
list 5,10            # ��ʾ��5�е���10�еĴ���  
list test.c:5,10     # ��ʾԴ�ļ�test.c�еĵ�5�е���10�еĴ��룬���Ժ��ж��Դ�ļ��ĳ���ʱʹ��  
list get_sun         # ��ʾget_sum������Χ�Ĵ���  
list test.c:get_sum  # ��ʾԴ�ļ�testc��get_sum������Χ�Ĵ��룬�ڵ��Զ��Դ�ļ��ĳ���ʱʹ�� 
}
gdb(signal)
{
gdbͨ�����Բ�׽�����͸����Ĵ�����źţ�ͨ����׽�źţ����Ϳɾ��������������еĽ���Ҫ��Щʲô���������磬��CTRL-C���ж��źŷ��͸�gdb��ͨ���ͻ���ֹgdb��������������ж�gdb��������Ŀ����Ҫ�ж�gdb�������еĳ�����ˣ�gdbҪץס���źŲ�ֹͣ���������еĳ��������Ϳ���ִ��ĳЩ���Բ�����
Handle����ɿ����źŵĴ�����������������һ�����ź�������һ���ǽ��ܵ��ź�ʱ����ʲô�����ֿ��ܵĲ����ǣ�
nostop ���յ��ź�ʱ����Ҫ�������͸�����Ҳ��Ҫֹͣ����
stop ���ܵ��ź�ʱֹͣ�����ִ�У��Ӷ����������ԣ���ʾһ����ʾ�ѽ��ܵ��źŵ���Ϣ����ֹʹ����Ϣ���⣩
print ���ܵ��ź�ʱ��ʾһ����Ϣ
noprint ���ܵ��ź�ʱ��Ҫ��ʾ��Ϣ�����������Ų�ֹͣ�������У�
pass ���źŷ��͸����򣬴Ӷ�������ĳ���ȥ��������ֹͣ���л��ȡ��Ķ�����
nopass ֹͣ�������У�����Ҫ���źŷ��͸�����
���磬�ٶ���ػ�SIGPIPE�źţ��Է�ֹ���ڵ��Եĳ�����ܵ����źţ�����ֻҪ���ź�һ�����Ҫ��ó���ֹͣ����֪ͨ�㡣Ҫ�����һ���񣬿������������
��gdb) handle SIGPIPE stop print
��ע�⣬UN�����ź������ǲ��ô�д��ĸ����������źű������ź��������ĳ���Ҫִ���κ��źŴ������������Ҫ�ܹ��������źŴ������Ϊ�ˣ�����Ҫһ���ܽ��źŷ��͸�����ļ�㷽���������signal��������񡣸�����Ĳ�����һ�����ֻ���һ�����֣���SIGINT���ٶ���ĳ����ѽ�һ��ר�õ�SIGINT���������룬��CTRL-C���ź�2���źŴ���������óɲ�ȡĳ����������Ҫ����Ը��źŴ���������������һ���ϵ㲢ʹ���������
��gdb�� signal 2
continuing with signal SIGINT��
�ó������ִ�У���������������źţ����Ҵ������ʼ���С�

}
Դ���������(source code debugger) �������ӵ����� (symbolic debugger)
gcc -g : ���Է���(debug symbol) ������Ϣ(symbolic information)

gdb factorial 
run 1  #�൱��factorial 1������1Ϊ���ݸ�factorial�ĵ�һ������
bt��backtrace��where����ջ���١�
backtrace(ջ֡)
{
#5427 0x00000000004005be in factorial (n=-256653) at factorial.c:14
��ǰջ֡�ı��Ϊ0��main()�����ı����ߡ�
down��up����ջ֡��������ƶ���

}

breakpoint(�ϵ�����)
{
�жϵ�(line breakpoint)  ������Դ������ָ����ʱ����ͣ����
�����ϵ�(function breakpoint) ������ָ�������ĵ�һ��ʱ����ͣ����
�����ϵ�(conditional breakpoint) ����ض���������Ϊ�棬����ͣ����
�¼��ϵ�(event breakpoint) �������ض��¼�ʱ��ʹ���������ͣģʽ��֧�ֵ��¼��������Բ���ϵͳ��signals��C++��exception.

break (�к�)                         # �ڵ�ĳ�����ö˵�  
break (������)                       # ��ĳ�����������öϵ�  
break �кŻ�����if��������         # ����������ʱ�ж���ִͣ��  
break 7 if i==99                     # �������е�i����99ʱ�ڵ�7���ж�  
watch �������ʽ                     # ���������ʽ��ֵ�����ı�ʱ�ж�  
watch i==99(��i����99ʱ���ʽ��ֵ��0��Ϊ1�������ж�)     //ע:�����ڳ������е�����������֮��ſ����ô˷���  
info breakpoints                     # �鿴��ǰ���еĶϵ�,Num��ʾ�ϵ�ı��,Typeָ������  
/*
����Ϊbreakpoints˵�����жϡ�
*Dispָʾ�жϵ�����Чһ�κ��Ƿ��ʧȥ���ã��������Ϊdis,������Ϊkeep��
*Enb������ǰ�жϵ��Ƿ���Ч,��Ϊy,����Ϊn��
*Address��ʾ�ж��������ڴ��ַ��
*What�г��жϷ������ĸ������ĵڼ��С�
*/
disable �ϵ���      # ʹ����ϵ�ʧЧ  
enable  �ϵ���      # ʹ����ϵ�ָ�  
clear ��������������  # ɾ�����������еĶϵ�   
clear �к�            # ɾ�����еĶϵ�  
clear ������          # ɾ���ú����Ķϵ�  
delete  �ϵ���      # ɾ��ָ����ŵĶϵ㡣���һ��Ҫɾ������ϵ㣬�����ϵ��Կո����
}

run(ִ�п���)
{
run       run������г��򣬿���ͨ�������в����򻷾����������ƺ͸������г���Ļ�����
start     start������г���ֱ��main()�ĵ�һ�У�Ȼ��ֹͣ�����ִ�У������Ͳ�����������main�������ļ����������һ��������ʽ�Ķ˵��ˡ�
pause     ���ж�һ���������еĳ�����ĳЩ�������У�����Ctrl-C�򵥻�Pause�������á�
continue  ʹ��ͣ�ĳ���ָ�ִ�С�
}

step(����ִ��)
{
step-into   (GDB)step
step-over   (GDB)next
step-out    (GDB)finish
}

print(�����ͱ��ʽ)
{
print n
��δ�ӡ������ֵ��(print var) 
��δ�ӡ�����ĵ�ַ��(print &var) 
��δ�ӡ��ַ������ֵ��(print *address) 

print ��������ʽ��������������  # ��ӡ��������ʽ��ǰ��ֵ
print i<n                         # ���ʽΪ��ֵΪ1,��Ϊ0
print ������ֵ������������������  # �Ա������и�ֵ
print�����ʽ��Ҫ��ӡ��ֵ�ĸ����� # ��ӡ�Ա��ʽֵ��ʼ��n����
/*
ע:�������У�print ��������ʽ��ֵΪ��ʱ����ִ������Ĵ��룬����ֱ�ӷ���ֵ
*/
whatis����������ʽ     # ��ʾĳ����������ʽ�ġ���������
set variable ������ֵ��  # ��������ֵ
print i=200��            # ��ͬ�ڡ�set variable i=200

display
}
��β鿴��ǰ���е��ļ����У�(backtrace) 
��β鿴ָ���ļ��Ĵ��룿(list file:N) 
�������ִ���굱ǰ�ĺ��������ǲ�����ִ��������Ӧ�ó���(finish) 
��������Ƕ��ļ��ģ�������λ��ָ���ļ���ָ���л��ߺ�����(list file:N) 
���ѭ�������ܶ࣬���ִ���굱ǰ��ѭ����(until)


debug(�����ڴ��ʹ�ã�valgrind memcheck �����ڴ�й¶���)
{
1. �ڴ�й¶��            ��ʧ�������˵���ĳ����䡣
2. �ڴ������Ĵ���ʹ��  ����ͷ�һ���ڴ�顢���ͷ�һ���ڴ��֮���ַ��ʻ����ͷ�һ����δ������ڴ��
3. ���������            �ѷ����ڴ��ⲿ���ڴ汻��д���ƻ���
4. ��ȡδ��ʼ�����ڴ�    δ��ʼ���ı����������޷�Ԥ�ϵ�ֵ��

Purify Insure++ Valgrind �� BoundsChecker
Purify��BoundsCheckerʹ�ó�������ʱ�Ķ�������װ���м�飻
Insure++ʹ��Դ�����װ
Valgrind���������ִ�г��򣬲����������ڴ�����

bug(�ڴ�)
{
�ڴ�й¶
�������ͷŵ��ڴ�
����ͷ�ͬһ���ڴ�λ��
�ͷŴ�δ������ڴ�
����C�е�malloc()/free()��C++�е�new/delete
������ʹ��delete,��û��ʹ��delete[]
����Խ�����
���ʴ�δ������ڴ�
��ȡδ��ʼ�����ڴ�
����д��ָ��
}

valgrind --tool=memcheck --leak-check=yes ./main1
valgrind -v --tool=memcheck --leak-check=yes ./main1

/* main1.c */
��Ч�ڴ��д���ʣ�
==25653== Invalid write of size 4
==25653==    at 0x40054E: main (main1.c:10)

����δ��ʼ�����ڴ�Ķ�ȡ����
==25653== Use of uninitialised value of size 8
==25653==    at 0x3CCF6437DB: _itoa_word (in /lib64/libc-2.12.so)
25653������pid.

����ڴ�й¶
==25653== 400 bytes in 1 blocks are definitely lost in loss record 1 of 1
==25653==    at 0x4A0717A: malloc (vg_replace_malloc.c:298)

/* mem_alloc_bug.c */
���ڴ����ô���
==25298== Invalid read of size 1
==25298==    at 0x3CCF670E60: _IO_file_xsputn@@GLIBC_2.2.5 (in /lib64/libc-2.12.so)
==25298==    by 0x3CCF6476E7: vfprintf (in /lib64/libc-2.12.so)
==25298==    by 0x3CCF64EAC9: printf (in /lib64/libc-2.12.so)
==25298==    by 0x4005C4: main (mem_alloc_bug.c:18)

���ڴ����-�ͷŵĲ���������
==26130== Invalid free() / delete / delete[] / realloc()
==26130==    at 0x4A06B54: free (vg_replace_malloc.c:529)

����ڴ�й¶
==25298== 5 bytes in 1 blocks are definitely lost in loss record 1 of 1
==25298==    at 0x4A0717A: malloc (vg_replace_malloc.c:298)

1. �������ֲ���²���ϵͳ��ʱ
2. �������ʱ
3. ��ʼ����һ��"��ֵ�"bugʱ��
4. Ϊ�ع���Ե�һ���֡�

}

valgrind()
{
http://blog.csdn.net/unix21/article/details/9330571
http://www.ibm.com/developerworks/cn/linux/l-cn-valgrind/

Valgrind��������һЩ���ߣ�
    Memcheck������valgrindӦ����㷺�Ĺ��ߣ�һ�����������ڴ��������ܹ����ֿ����о�������ڴ����ʹ����������磺ʹ��δ��ʼ�����ڴ棬ʹ���Ѿ��ͷ��˵��ڴ棬�ڴ����Խ��ȡ���Ҳ�Ǳ��Ľ��ص���ܵĲ��֡�
    Callgrind������Ҫ�����������к������ù����г��ֵ����⡣
    Cachegrind������Ҫ�����������л���ʹ�ó��ֵ����⡣
    Helgrind������Ҫ���������̳߳����г��ֵľ������⡣
    Massif������Ҫ�����������ж�ջʹ���г��ֵ����⡣
    Extension����������core�ṩ�Ĺ��ܣ��Լ���д�ض����ڴ���Թ���
    
Valgrind ʹ��
�÷�: valgrind [options] prog-and-args [options]: ����ѡ�����������Valgrind����
    -tool=<name> ��õ�ѡ����� valgrind����Ϊtoolname�Ĺ��ߡ�Ĭ��memcheck��
    h �Chelp ��ʾ������Ϣ��
    -version ��ʾvalgrind�ں˵İ汾��ÿ�����߶��и��Եİ汾��
    q �Cquiet ���������У�ֻ��ӡ������Ϣ��
    v �Cverbose ����ϸ����Ϣ, ���Ӵ�����ͳ�ơ�
    -trace-children=no|yes �������߳�? [no]
    -track-fds=no|yes ���ٴ򿪵��ļ�������[no]
    -time-stamp=no|yes ����ʱ�����LOG��Ϣ? [no]
    -log-fd=<number> ���LOG���������ļ� [2=stderr]
    -log-file=<file> ���������Ϣд�뵽filename.PID���ļ��PID�����г���Ľ���ID
    -log-file-exactly=<file> ���LOG��Ϣ�� file
    -log-file-qualifier=<VAR> ȡ�û���������ֵ����Ϊ�����Ϣ���ļ����� [none]
    -log-socket=ipaddr:port ���LOG��socket ��ipaddr:port

LOG��Ϣ���

    -xml=yes ����Ϣ��xml��ʽ�����ֻ��memcheck����
    -num-callers=<number> show <number> callers in stack traces [12]
    -error-limit=no|yes ���̫�������ֹͣ��ʾ�´���? [yes]
    -error-exitcode=<number> ������ִ����򷵻ش������ [0=disable]
    -db-attach=no|yes �����ִ���valgrind���Զ�����������gdb��[no]
    -db-command=<command> ������������������ѡ��[gdb -nw %f %p]

������Memcheck���ߵ����ѡ�

    -leak-check=no|summary|full Ҫ���leak������ϸ��Ϣ? [summary]
    -leak-resolution=low|med|high how much bt merging in leak check [low]
    -show-reachable=no|yes show reachable blocks in leak check? [no]

ʹ��δ��ʼ�����ڴ� (Use of uninitialised memory) 
ʹ���Ѿ��ͷ��˵��ڴ� (Reading/writing memory after it has been free��d) 
ʹ�ó��� malloc������ڴ�ռ�(Reading/writing off the end of malloc��d blocks) 
�Զ�ջ�ķǷ����� (Reading/writing inappropriate areas on the stack) 
����Ŀռ��Ƿ����ͷ� (Memory leaks �C where pointers to malloc��d blocks are lost forever) malloc/free/new/delete
������ͷ��ڴ��ƥ��(Mismatched use of malloc/new/new [] vs free/delete/delete []) 
src��dst���ص�(Overlapping src and dst pointers in memcpy() and related functions)

}

massif-visualizer()
{
��װmassif-visualizer
massif-visualizer��ubuntu�µ�ͼ�λ���������
http://get.ubuntusoft.com/app/massif-visualizer
��Ŀ��ҳ��
https://projects.kde.org/projects/extragear/sdk/massif-visualizer
massif-visualizer���أ�
http://tel.mirrors.163.com/ubuntu/pool/universe/m/massif-visualizer/
�������ϸ��Ϣ��
http://packages.ubuntu.com/massif-visualizer

}


debug(�����ڴ��ʹ�ã�valgrind massif ���������ڴ汻��Щ������ռ��)
{
1. ����Ƿ��д���ڴ�й¶
   ��ʹ���˹����ڴ�ĳ��������ڴ����������ϵͳ���е��ڴ�й¶������й¶��������ֻ�м����ֽڣ�����ȫ���Ժ��ԡ�
2. ����Ԥ�ڵ��ڴ�ʹ��
   ��װ�������Թ��߽���ʵ�ʲ���֮ǰ��ɡ�
   Redis������Щ��װ���롣
3. �ö�������������ڴ�ʹ����ʱ��ı仯
    top
4. ����ʹ���ڴ�����ݽṹ

�Զ����� (�����󲿷��ڴ汻��Щ���ݽṹռ����)
/usr/local/bin/valgrind --tool=massif ./testmalloc n 100000 8
/usr/local/bin/valgrind --tool=massif ./genindex input1.txt input1.txt input1.txt input1.txt  > log

testmalloc: -DUSE_NEW
genindex:   -DFIX_LINES -DCLEAR_INDEX

���massif.out.26512ΪPostscript�ļ���
ms_print massif.out.26512

���nginx,redis,memcached,firefox
valgrind --tool=massif /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
valgrind --tool=massif /usr/local/memcached/bin/memcached -d -m 64 -uroot -l 0.0.0.0 -p 11211 -c 1024
valgrind --tool=massif /usr/redis-2.8.1/src/redis-server
valgrind --tool=massif /usr/bin/firefox

ʵ����
valgrind --smc-check=all --trace-children=yes --tool=massif --pages-as-heap=yes \ --detailed-freq=1000000 optg64/dist/bin/firefox -P cad20 -no-remote

g++ -g -o genindex_fix -DFIX_LINES genindex.cc                                           # �������
valgrind --tool=massif ./genindex_fix input1.txt input1.txt input1.txt input1.txt > log  # ���г���
ms_print massif.out.2511                                                                 # �������ͳ����Ϣ

g++ -g -o genindex_fix_index -DFIX_LINES -DCLEAR_INDEX genindex.cc                             # �������
valgrind --tool=massif ./genindex_fix_index input1.txt input1.txt input1.txt input1.txt > log  # ���г���
ms_print massif.out.2535                                                                       # �������ͳ����Ϣ


}

debug(����������⣺valgrind callgrind)
{
1. ��Callgrind���г����������ݽ���д��callgrind.out.<id>�ļ��С�
2. ����callgrind annotate callgrind.out.<id> ��������һ���������棬����KCachegrind���鿴���
gcc -o isort -O isort.c
valgrind --tool=callgrind ./isort -i 100 1000
callgrind_annotate callgrind.out.31612

callgrind_annotate
--tree=both : ��ʾ���������г�ÿ�������ĵ������Լ������õ�����������
--auto=yes  : �����ע�͵�Դ�ļ�

yum install kdesdk-4.3.4-4.el6.x86_64 
kcachegrind callgrind.out.31612 #ͼ�ΰ�

./filebug s xxx.log 2000000
}

debug(����������⣺VTune)
{
����(gprof)�͵���ͼ(������Quantify)
VTune     ��ҵIntel
Quantify  ��ҵIBM
}

debug(����������⣺gprof)
{
1. ����һ���С���ȵ�������Ĳ���������ȷ���������������У�û�б��������õ���ȷ�����ֵ��
   �Ƿ����ܹ�������������Ĳ���������
   �����Ƿ�������ȷ�Ľ����
   �Ƿ��ܹ��޸Ĳ����������۲������ģ���������ݺͻ�����Ӱ�죿
   ���������Ƿ�ȷʵ���ɳ�������ģ�������ĳЩ�������صĸ����ã�������������ɷ����������ڴ�ͣ�
   �Ƿ�ʹ�����ʺ������ģ���������ݵ���ȷ�㷨��
2. �ü򵥹���time����������ʱ�������������С֮��Ĺ�����ȷ������ʹ������ȷ���㷨
   ʹ�ü򵥵�ʱ�����������
   ������������
   ʹ�����������п�������
   ���������ȷ��
   ��������չ�Ĳ�������
   �ų��Բ��������ĸ���
       1. ����ʱ��̣� 2. �ļ�IO�� 3. ϵͳ���ã� 4. û���㹻���ڴ� 5. CPUʱ��Ƶ�ʲ��ȶ� 6. �������̡�
   �㷨��ʵ��֮��Ĳ���

3. ѡ��һ���ܹ���ʾ��Ҫ������ʱƿ���Ĳ�������������������������ʶ�����ƿ����ԭ��

gprof��callgrind��Quantify��
gprof�����������ÿ������ռ�ö೤ʱ�䣬�Լ�ÿ���������������õĴ��������⣬�������ʹ�õ�����Ϣ����ģ�
       �����Կ��������ÿ���������õ�ʱ�䡣
1. ��-gd��־���벢���ӳ���
2. ���г��������ļ����ݽ���д��gmon.out�ļ���
3. ����gprof <program> gmon.out���������������档
ȱ�㣺1.���������ò���ϵͳ������ʱ�䣬���ҿ����޷�������⡣
      2. ������������뼫��ؽ����˳���������ٶȡ�
      
gcc -Wall -O -o isort -pg isort.c
./isort -i 10 100000  
gprof isort gmon.out > report.txt

<ƽ��ͼ>
Each sample counts as 0.01 seconds.
       ������ʱ��  �������ñ������õ�ʱ��    �����������к����ÿ�����û��ѵ�ƽ��ʱ��
  %   cumulative   self              self     total
 time   seconds   seconds    calls  ns/call  ns/call  name
 36.17      1.14     1.14 90000000    12.62    29.04  insert_value
 29.45      2.06     0.92 450000000     2.05     2.05  less
 17.60      2.61     0.55 190000000     2.91     2.91  swap
 10.88      2.95     0.34 10000000    34.17   295.49  isort
  4.16      3.09     0.13                             main
  2.24      3.16     0.07                             frame_dummy
ȷ��������ʱ��cumulative seconds�Ȳ������0.01��߳�4����������

<����ͼ> ��������֯
index % time    self  children    called     name
                                                 <spontaneous>
[1]     97.8    0.13    2.95                 main [1]
                0.34    2.61 10000000/10000000     isort [2]
-----------------------------------------------
ÿ���鴦��һ����������ʾ�ú����ĵ������Լ�����Ƶ�ʣ����������õ���ʱ�䣬�����õ��Ӻ�������Щ�Ӻ������������õ�ʱ�䡣

}

debug(���Բ��г���helgrind)
{
1. ��C��C++��д�Ŀ��ڲ�ͬ���������еĶ�·ͨ�ų���
2. ���̳߳���
3. ���źŻ��жϴ������

�����߲飡 --- ����������
1. ʹ�û������Թ��������Ҿ���������
2. ʹ����־�ļ������Ҿ���������
   2.1 �Բ��д�����в�װʱ��һ��Ҫʹ���̰߳�ȫ��ԭ�Ӻ�����������������Եľ��ǲ�װ���룬������ʵ�ʴ���
   2.2 printf()��fprintf()���ڴ��������ϵͳ�Ͽɿ���������ÿ��IO�����棬��������fflush().
       ������stderr��δ����ģ�������ʺ�������¼��C++������ʺ�������¼�ġ���Ϊ�����ܲ���
       ���Բ�ͬ�̵߳İ�ȫ������ı������
   2.3 ��ת����ͳ����е��߳���Ϣʱ��Ӧʹ��ʱ�����
   2.4 ����������Բ��г���һ�ֺõķ����Ǵ����������ߣ������ٺ�������ٻ����������������Զ�����һЩ������Ϣ��
   2.5 ��ĳЩ�����ʹ�ö�����������ģ��ر��������ʹ�ö��ԣ���־������úܴ��ʱ��

�����߲飡 --- ��������
1. ѭ����������
2. Э�鲻ƥ��

gdb -> Ctrl-C  ->  info stack; frame; list 12,5; info threads; thread 1; 

Thread Checker ��ҵ��� Intel

valgrind --tool=helgrind ./beancounter_deadlock
}

debug(����̵���)
{
UNIX��   PATH��LD_LIBRARY_PATH�����ڶ�λ��̬���������⡣    env
Windows��PATH, LIB��INCLUDE     ����ʹ��PATH�������ҳ����DLL�� set

1. ���ذ�װ����       ���ض�̬��汾
2. ��ǰ����Ŀ¼����   �����ļ����ִ���ļ�����Ŀ¼
3. ����ID����         /tmp/myprog.<pid>
4. �������͵���Ҳ��bug

���ٽ��̣�
1. ��top��������
2. ps������Ӧ�ó���Ķ������
    ps -u someone -H pid,cmd
3. ʹ��/oric/<pid>/�����ʽ���
4. ʹ��strace|truss���ٶԲ���ϵͳ�ĵ���
    strace������������Զ����������
    �ļ�IO����OS������δ����Ĵ�����жϣ�OS���õ�Ƶ�ʣ��ڴ����/�ͷ�/ӳ�䡣
    
�����ӽ���
set follow-fork-mode
mode:
  child                           # ������fork()��������̻���븸����
  parent                          # ������fork()��������̻�����ӳ���
  
set detach-on-fork mode
mode:
  on(Ĭ��)                        # ֻ���Ը����̻��ӽ��̵�����һ��(����follow-fork-mode������)
  off                             # ���ӽ��̶���gdb�Ŀ���֮��,����һ��������������(����follow-fork-mode������),��һ������ͣ��
info inferiors                    # ��ʾ������Ϣ
inferior num                      # ѡ��num�Ž���
add-inferior [-copies n] [-exec executable] # ����µĵ��Խ���,������file executable�������inferior��ִ���ļ���  
remove-inferiors infno

fork+exec
����follow-fork-mode child��
catch exec                        # ���Բ���execve������ĵ���,�Ӷ����뱻ִ�еĳ���
}

debug(��������������)
{
1. ��ʧ����������
2. ������ʧ�ķ���
3. ����˳������
4. C++���ź����Ƹı�
5. ���ŷ�����
6. ����C��C++����    "extern C"
7. ���ж������ķ���

1. ϵͳ�ⲻƥ��
2. �����ļ���ƥ��
3. ����ʱ����
4. ȷ���������汾
}

debug(�߼�����)
{
gdb 
break C::foo #��ĳ�Ա����
break C::foo(int) #��ĳ�Ա����
break 'C::foo(int) #'��ʾ����ʹ��Tab��ʾ���غ���
ptype C
info functions C::foo

handle SIGUSR1 print nostop pass
handle SIGUSR1 noprint nostop nopass
info signals

ulimit -c 100000
gdb answer core.4805


�޸ı���
start "Foofoo, foobar and Bar" foo bar
break 22
print n
set var n=3
print str+n
continue

���ú���
call captialize_str(copy, "and")

�޸ĺ�������ֵ
return 40

��ֹ��������
return 0

�������ظ�ִ�и������
jump 25

������޸��ڴ�����
whatis print x set var

}

debug(��д���Ե��ԵĴ���)
{
ע�ͣ�
1. ����ǩ����ע�ͣ�
   ����Ҫ��ʲô��˵�������������ӿ�ʹ���ϵļ��裻�ڴ���䣻�����ã���¼������֪���������ʱ���а취��
2. �����а취��ע��
3. �Բ�ȷ���Ĵ����ע��

������ֲ�ı�����
1. ��ϸѡ������
2. ��Ҫʹ��"������ͷ"�Ľṹ
3. ��Ҫѹ�����룻
4. Ϊ���ӱ�ʾʽʹ����ʱ����

����ʹ��Ԥ�������꣺
1. ʹ�ó�����ö��������ꡣ
2. ʹ�ú���������Ԥ��������
3. �����봦�������
gcc -E main.c > main.post.c
4. ʹ�ù��ܸ�ǿ��Ԥ������
m4 

�ṩ������Ժ���
1. ��ʾ�û��������������
2. �Լ�����
3. Ϊ��������һ���������Ա��������

Ϊ�º������׼��
1. ������־�ļ�


}

debug(��̬�������ü����ù���)
{
lint
splint UNIX
PC-lint ��ҵ

ulimit -- ���úͲ鿴�û���ʹ�õ���Դ�������
nm -- ��ʾĿ���ļ��ķ��ű���Ϣ
ldd �C��ʾ��̬���������Ϣ
pstack��Solaris�� Linux���� procstack��AIX��-- ��ӡʮ�����Ƶ�ַ�ͷ�������
pmap(Solaris, Linux), procmap(AIX) �C��ӡ��ַ�ռ�ӳ��
pldd(Solaris), procldd(AIX) ���г����̼��صĿ�
pfiles(Solaris), procfiles(AIX)-- �����йص������ļ�������
prstat(Solaris), ps -e -o user,pid,ppid,tid,time,%cpu,cmd --sort=%cpu(Linux)-- ���ÿ���̵߳Ĵ�����
ps �C������̵�״̬
iostat �C�������봦��Ԫ�����봦������ͳ�ƺ����� / ����豸�ͷ���ͳ��
pwdx��Linux��Solaris���� pid ��ʾ��ǰ����Ŀ¼
top��Linux��Solaris��HP����topas��AIX��


/usr/bin/gcore
/usr/bin/gdb
/usr/bin/gdb-add-index
/usr/bin/gdbtui
/usr/bin/gstack
/usr/bin/pstack
}


