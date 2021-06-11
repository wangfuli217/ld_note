#include <unistd.h>

int main(void)
{
    if ((write(1, "Here is some data\n", 18)) != 18)
        write(2, "A write error has occurred on file descriptor 1\n",46);
	// 下面的方法和return 0的含义是一样的
	//但是，当不为0的时候，return 错误
	//exit 异常
    exit(0);
}

