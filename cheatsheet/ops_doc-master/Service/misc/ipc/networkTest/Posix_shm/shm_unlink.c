/*************************************************************************
	> File Name: shm_unlink.c
	> Author: liujizhou
	> Mail: jizhouyou@126.com 
	> Created Time: Sun 06 Mar 2016 10:06:25 PM CST
 ************************************************************************/

#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>
int main(int agrc, char* argv[])
{
	shm_unlink(argv[1]);
	return 0;
}
