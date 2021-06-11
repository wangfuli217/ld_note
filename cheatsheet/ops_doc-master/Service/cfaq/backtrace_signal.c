#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <execinfo.h>
#include <signal.h>
#include <errno.h>

// 由于信号处理句柄中无法使用格式化输出函数, 因此预定义一个信号详细信息列表
static char m_sig_msgs[32][128];
static int m_msg_len[32];

void sig_hdr(int sig_num, siginfo_t *info, void *ucontext)
{
    // 注意信号处理句柄中唯一可用的I/O函数是write和read
    write(STDERR_FILENO, "recv signal: ", 13);
    write(STDERR_FILENO, m_sig_msgs[info->si_signo], m_msg_len[info->si_signo]);
    write(STDERR_FILENO, "\n", 1);
    void *buf[128];

    // 1.backtrace
    int size = backtrace(buf, 128);
    if (size >= 128) {
        char msg[] = "Warning: backtrace maybe truncated.\n";
        write(STDERR_FILENO, msg, sizeof(msg));
    }

    // 2.backtrace_symbols_fd
    // 由于backtrace返回的数组的第一项永远是backtrace函数自身产生的堆栈, 因此可以忽略数组第一项
    backtrace_symbols_fd(buf + 1, size - 1, STDERR_FILENO);

    // 3.exit
    exit(EXIT_FAILURE);
}

void crash()
{
    char *p  =NULL;
    *p = 0; // 引发SIGESEG
}

void func4()
{
    printf("start %s+++++\n", __FUNCTION__);
    crash();
    printf("finish %s-----\n", __FUNCTION__);
}


void func3()
{
    printf("start %s+++++\n", __FUNCTION__);
    func4();
    printf("finish %s-----\n", __FUNCTION__);
}


void func2()
{
    printf("start %s+++++\n", __FUNCTION__);
    func3();
    printf("finish %s-----\n", __FUNCTION__);
}


void func1()
{
    printf("start %s+++++\n", __FUNCTION__);
    func2();
    printf("finish %s-----\n", __FUNCTION__);
}

int main()
{
    // 初始化信号详细信息描述列表
    int i = 0;
    for (i = 0; i < 32; ++i) {
        int sp_res = snprintf(m_sig_msgs[i], 128, "%d(%s)", i, strsignal(i));
        if (sp_res >= 128) {
            fprintf(stderr, "sig %d describe overflow\n", i);
        }
        m_msg_len[i] = sp_res;
    }

    // 设置信号处理句柄
    struct sigaction sigact;
    sigact.sa_sigaction = sig_hdr;
    sigact.sa_flags = SA_RESTART | SA_SIGINFO;
    if (sigaction(SIGSEGV, &sigact, (struct sigaction *)NULL) != 0) {
        int err = errno;
        fprintf(stderr, "sigaction() failed, detail: %s, error.\n", strerror(err));
        exit(EXIT_FAILURE);
    }

    // 引发异常中断
    func1();

    return 0;
}
/*
gcc -g -Wall -rdynamic backtrace_signal.c -o test
 ./test
[root@agent109 cfaq]# addr2line -e test 0x400c57
/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/cfaq/backtrace_signal.c:40
[root@agent109 cfaq]# addr2line -e test 0x400c81
/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/cfaq/backtrace_signal.c:47
[root@agent109 cfaq]# addr2line -e test 0x400cbf
/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/cfaq/backtrace_signal.c:55
[root@agent109 cfaq]# addr2line -e test 0x400cfd
/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/cfaq/backtrace_signal.c:63
[root@agent109 cfaq]# addr2line -e test 0x400d3b
/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/cfaq/backtrace_signal.c:71
[root@agent109 cfaq]# addr2line -e test 0x400e6d
/root/rtu/otdr/crosstool/cheatsheet/ops_doc-master/Service/cfaq/backtrace_signal.c:99
[root@agent109 cfaq]#
*/