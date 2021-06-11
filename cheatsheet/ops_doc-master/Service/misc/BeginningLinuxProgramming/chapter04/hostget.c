#include <sys/utsname.h>
#include <unistd.h>
#include <stdio.h>

//----------------------------------------------------
//不可否认，有些函数的输出是从文件直接
//读出来的，有些数值，是通过计算得到的
//其实本质上和规约中各个数据的实现是
//不谋而合的。
//----------------------------------------------------

//---------------------------------------------------
//下面这些数值或字符串，也可以通过
//Linux 的指令获得gethostname  uname
//---------------------------------------------------
int main(void)
{
    char computer[256];
    struct utsname uts;

    if(gethostname(computer, 255) != 0 || uname(&uts) < 0)
	{
        fprintf(stderr, "Could not get host information\n");
        exit(1);
    }

    printf("Computer host name is %s\n", computer);
    printf("System is %s on %s hardware\n", uts.sysname, uts.machine);
    printf("Nodename is %s\n", uts.nodename);
    printf("Version is %s, %s\n", uts.release, uts.version);
    exit(0);
}

