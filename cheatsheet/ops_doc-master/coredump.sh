coredump_i_intro(){ cat - << 'coredump_i_intro'
man core 帮助文档
ubuntu： https://wiki.ubuntu.com/Apport
         https://github.com/rickysarraf/apport

1. 一些信号默认是终止进程运行同时生成转存文件；     coredump_i_signal
2. 转存文件保存了终止进程在内存中的数据镜像         coredump_i_core_noexist
3. 转存文件可以被gdb用来查看进程终止时的状态        
4. 当可执行文件和依赖库被strip之后，gdb只输出地址                      coredump_i_objdump 
   让内核输出上层应用进程崩溃的信息    .config (CONFIG_DEBUG_USER=yes) coredump_i_objdump 
5. 进程在coredump的时候，gdb /bin/sleep /home/core-sleep-2513-6-1613710661
   依赖 可执行文件及环境能否提供足够多的debug信息(no strip)，也依赖 coredump 文件内容； coredump_i_filter
   
[问题]
1. 生成 coredump 文件的限制条件?                             coredump_i_core_noexist
2. 生成 coredump 文件的名称 以及 coredump 文件包含的内容。   coredump_i_filter

# ulimit.txt 对 ulimit 和 prlimit 进行说明
coredump_i_intro
}

coredump_i_signal(){  cat - << 'coredump_i_signal'
以下信号生成core dump
SIGQUIT       SIGILL        SIGABRT       SIGFPE        SIGSEGV      SIGBUS      SIGSYS      SIGTRAP        
SIGXCPU       SIGXFSZ       SIGIOT        SIGUNUSED    
coredump_i_signal
}

coredump_i_getrlimit(){  cat - << 'coredump_i_getrlimit'
设置或者获取进程资源限制
int getrlimit(int resource, struct rlimit *rlim); 
int setrlimit(int resource, const struct rlimit *rlim);
RLIMIT_CORE

prlimit --core=unlimited -p pid
prlimit --core=unlimited --pid=$(cat /proc/$ppid/status | grep PPid | cut -f2)
coredump_i_getrlimit
}

coredump_i_core_noexist(){ cat - << 'coredump_i_core_noexist'
echo "/home/core-%e-%p-%s-%t" > /proc/sys/kernel/core_pattern
core 文件无法生成常见原因 ?

1. 被终止进程没有权限写core文件：被称为core或core.pid，
   1. 对文件夹不具有写权限，
   2. 文件名相同存在且不可以写，
   3. 文件名相同存在且文件不是普通文件
2  已经存在一个core文件，且该文件存在硬链接；
3. 磁盘空间不充足：文件系统没有足够的inode，文件系统为只读文件系统，用户达到存储配额上限
4. 存储core文件的路径目录不存在
5. RLIMIT_CORE和RLIMIT_FSIZE被设置为0
6. PR_SET_DUMPABLE | /proc/sys/fs/suid_dumpable 
7. /proc/sys/kernel/core_pattern 为空，同时/proc/sys/kernel/core_uses_pid为0 没有core文件
   /proc/sys/kernel/core_pattern 为空，同时/proc/sys/kernel/core_uses_pid为0 生成文件为.pid文件
8. 内核没有 CONFIG_COREDUMP 配置选项
coredump_i_core_noexist
}

coredump_i_ulimit(){ cat - << 'coredump_i_ulimit'
ulimint -a      # 用来显示当前shell下的各种用户进程限制
core file size 的值为0，说明当前环境不会产生core文件。
使用ulimit -c，可以设置core文件的大小，从而使得程序崩溃时可以产生core文件
ulimit -c 1024  # 通过查看/proc/<pid>/limits得到core文件的具体大小
ulimit -c unlimit命令，打开core文件的产生，并且不限制core文件的大小
通过ulimit -c 0关闭core文件的产生

如 .bash_profile、/etc/profile或/etc/security/limits.conf。
比如，可以在/etc/profile文件的末尾加上一句：
ulimit -c unlimited
coredump_i_ulimit
}

coredump_i_enable(开启){ cat - << 'coredump_i_enable'
3、开启core dump
　　可以使用命令ulimit开启，也可以在程序中通过setrlimit系统调用开启。
3.1. 终端下执行ulimit -c 查看core文件大小限制 ，一般操作系统默认为0。 
     执行ulimit -c 1024把core文件大小限制在1k， 也可以直接执行ulimit -c unlimited 设置为无限制。

2. 设置core文件保存路径。
   vi 打开/etc/sysctl.conf 文件， 加入kernel.core_pattern = /tmp/corefile/core.%e.%t 保存，
   需要注意的是 要保证用户对/tmp/corefile 有读写权限。%e表示的是应用名称， %t表示生成时间。
   终端执行sysctl -p
   这样几步设置完成后， 执行程序出错的话就会在/tmp/corefile/目录下生成相应的core文件了。
   调试的话 终端执行gdb ./xxx.out /tmp/corefile/core.xxx.xxxx 然后在gdb视图下执行bt即可。

程序中开启core dump，通过如下API可以查看和设置RLIMIT_CORE
#include <sys/resource.h>
int getrlimit(int resource, struct rlimit *rlim);
int setrlimit(int resource, const struct rlimit *rlim);
coredump_i_enable
}

coredump_i_proc_pattern(){ cat - << 'coredump_i_proc_pattern'
echo 'core.%e.%p' > /proc/sys/kernel/core_pattern 
core文件名最长为128个字节。
这样配置后，产生的core文件中将带有崩溃的程序名、以及它的进程ID。上面的%e和%p会被替换成程序文件名以及进程ID。
可以在core_pattern模板中使用变量还很多，见下面的列表：
    %% 单个%字符
    %c core文件大小限制
    %d dump模式prctl(2)
    %p 所dump进程的进程ID
    %u 所dump进程的实际用户ID
    %g 所dump进程的实际组ID
    %s 导致本次core dump的信号
    %t core dump的时间 (由1970年1月1日计起的秒数)
    %h 主机名
    %e 程序文件名
如果在上述文件名中包含目录分隔符"/"，那么所生成的core文件将会被放到指定的目录中
需要说明的是，在内核中还有一个与coredump相关的设置，就是/proc/sys/kernel/
如果这个文件的内容被配置成1，那么即使core_pattern中没有设置%p，最后生成的core dump文件名仍会加上进程ID。

echo "/data/cores/core_%e_%p_%t" > /proc/sys/kernel/core_pattern
# 将core文件的路径设置为"/data/cores"，要注意该目录必须存在，而且进程具有写权限。文件名的格式设置为"core_%e_%p_%t"，

/usr/libexec/abrt-hook-ccpp %s %c %p %u %g %t e #redhat
将产生的core文件传递给abrt-hook-ccpp程序，该程序是ABRT的一个组件。ABRT就是Automatic Bug Reporting Tool的缩写。
通过该工具，可以更全面的查看core文件的内容.
coredump_i_proc_pattern
}

coredump_i_pipe(){ cat - << 'coredump_i_pipe'
echo "|$PWD/core_pattern_pipe_test %p UID=%u GID=%g sig=%s" > \
               /proc/sys/kernel/core_pattern
1. core文件作为core_pattern_pipe_test的输入，
2. core_pattern_pipe_test作为root用户运行
3. SELinux启动情况下，阻止core_pattern_pipe_test访问/proc/pid文件
4. /proc/[pid]/cwd 为当前进程的工作目录
5. 命令行参数提供了core_pattern_pipe_test文件
coredump_i_pipe
}


coredump_i_pipe_limit(core_pipe_limit){ cat - << 'coredump_i_pipe_limit'
core_pattern_pipe_test可以访问/proc/[pid]文件夹内的数据信息
core_pipe_limit 定义了可以同时存在多少个 core dump进程；如果超过了这个限制，内核将在log中输出，忽略dump
core_pipe_limit不限制并发个数
coredump_i_pipe_limit
}

coredump_i_filter(){ cat - << 'coredump_i_filter'
/proc/[pid]/coredump_filter
bit 0  Dump anonymous private mappings.
bit 1  Dump anonymous shared mappings.
bit 2  Dump file-backed private mappings.
bit 3  Dump file-backed shared mappings.
bit 4 (since Linux 2.6.24)
      Dump ELF headers.
bit 5 (since Linux 2.6.28)
      Dump private huge pages.
bit 6 (since Linux 2.6.28)
      Dump shared huge pages.

子进程继承父进程的coredump_filter属性
echo 0x7 > /proc/self/coredump_filter
coredump_i_filter
}

coredump_i_gdb(){ cat - << 'coredump_i_gdb'
用GDB调试core文件的命令：
gdb  <filename>  <core>  # filename就是产生core文件的可执行文件，croe就是产生的core文件名。
使用 backtrace 或者 bt 打印当前的函数调用栈的所有信息。

    如果要查看某一层的信息，你需要在切换当前的栈，一般来说，程序停止时，最顶层的栈就是当前栈，
如果你要查看栈下面层的详细信息，首先要做的是切换当前栈。
(gdb) f/frame <n>            #  n从0开始，是栈中的编号
(gdb) up <n>                # 向栈的上面移动n层。如无n，向上移动一层
(gdb) down <n>              # 向栈的下面移动n层。如无n，向下移动一层
# 这个命令会打印出更为详细的当前栈层的信息，只不过，大多数都是运行时的内内地址。比如：函数地址，调用函数的地址，被调用函数的地址，目前的函数是由什么样的程序语言写成的、函数参数地址及值、局部变量的地址等等。

(gdb) info f/frame
(gdb) info args             # 打印当前函数的参数名及值
(gdb) info locals           # 打印当前函数中所有局部变量及值
(gdb) info catch            # 打印当前函数中的异常处理信息

如果是多线程环境，则可以使用下面的命令调试：
(gdb) info threads              # 显示当前可调试的所有线程
(gdb) thread <ID>              # 切换当前调试的线程为指定ID的线程
(gdb) thread apply all <command>        # 所有线程执行command
coredump_i_gdb
}

coredump_i_objdump(){ cat - << 'coredump_i_objdump'
[coredump文件提供绝对地址]
./gdb /persist/busybox.nosuid  /home/core-busybox.nosuid-3029-6-1613713336 
(gdb) bt
#0  0xb6d7a7b4 in ?? () from /lib/libc.so.6
#1  0xb6ddfc7e in nanosleep () from /lib/libc.so.6
#2  0x00504068 in sleep_main ()
#3  0xbecfdf32 in ?? ()

1. 可执行文件: 绝对地址到相对地址计算
 0x00504068 -> printf "%x\n" $[0x00504068-0x0047b000] # 89068
2. 库文件：对地址到相对地址计算
 0xb6ddfc7e -> printf "%x\n" $[0xb6ddfc7e-0xb6d63000] # 7cc7e

[通过maps地址段，计算出相对(库或者可执行文件)地址]
cat /proc/[pid]/maps
0047b000-0054f000 r-xp 00000000 00:1c 451        /persist/busybox.nosuid
00550000-00552000 r--p 000d4000 00:1c 451        /persist/busybox.nosuid
00552000-00553000 rw-p 000d6000 00:1c 451        /persist/busybox.nosuid
b6d63000-b6e54000 r-xp 00000000 00:11 13584      /lib/libc-2.28.so
b6e54000-b6e64000 ---p 000f1000 00:11 13584      /lib/libc-2.28.so
b6e64000-b6e66000 r--p 000f1000 00:11 13584      /lib/libc-2.28.so
b6e66000-b6e67000 rw-p 000f3000 00:11 13584      /lib/libc-2.28.so
b6e67000-b6e6a000 rw-p 00000000 00:00 0 

1. 可执行文件: 崩溃地址跟踪
[在对应库或者可执行文件中找 相对地址位置]
arm-oe-linux-gnueabi-objdump busybox.nosuid -SD > busybox.txt
grep 89068 busybox.txt # vim busybox.txt 找 89068               -> sleep_main

2. 库文件：崩溃地址跟踪
arm-oe-linux-gnueabi-objdump  -S libc-2.28.so > libc-2.28.so.txt
grep 7cc7e libc-2.28.so.txt # vim libc-2.28.so.txt 找 7cc7e     -><__nanosleep>:

poky/build/tmp-glibc/work/armv7at2hf-neon-oe-linux-gnueabi
coredump_i_objdump
}

coredump_t_at_fwd(){ cat - << 'coredump_t_at_fwd'
coredump文件默认存储位置与可执行文件在同一目录下，文件名为core。                                     # no 后面是需要执行的，yes后面是当前满足条件的。
                                                                                                 no  # echo "/home/core-%e-%p-%s-%t" > /proc/sys/kernel/core_pattern
core 文件无法生成常见原因 ?                                                                      
1. 被终止进程没有权限写core文件：被称为core或core.pid，                                          ok  # 908 root      0:00 /usr/bin/twt_atfwd_v2
   1. 对文件夹不具有写权限，                                                                     
   2. 文件名相同存在且不可以写，                                                                 
   3. 文件名相同存在且文件不是普通文件                                                           
2  已经存在一个core文件，且该文件存在硬链接；                                                    
3. 磁盘空间不充足：文件系统没有足够的inode，文件系统为只读文件系统，用户达到存储配额上限         no  # mount -o remount,rw / 
4. 存储core文件的路径目录不存在                                                                  
5. RLIMIT_CORE和RLIMIT_FSIZE被设置为0                                                            no  # coredump_i_config 永久设置
6. PR_SET_DUMPABLE | /proc/sys/fs/suid_dumpable                                                  yes # 0 (default) 1 ("debug")  2 ("suidsafe")
7. /proc/sys/kernel/core_pattern 为空，同时/proc/sys/kernel/core_uses_pid为0 没有core文件        yes 
   /proc/sys/kernel/core_pattern 为空，同时/proc/sys/kernel/core_uses_pid为0 生成文件为.pid文件  
8. 内核没有CONFIG_COREDUMP配置选项                                                               ok # grep CONFIG_COREDUMP ./work/sdxprairie-oe-linux-gnueabi/linux-msm/4.14-r0/build/.config
coredump_t_at_fwd
}


