/*************************************************************************
	> File Name: reboot.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Wed 05 Jul 2017 04:31:00 PM CST
 ************************************************************************/

#include<stdio.h>
#include <sys/reboot.h>

int main()
{
	reboot(RB_AUTOBOOT);
}
