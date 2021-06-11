#include "exynos_4412.h"

/*****关于寄存器的封装*****/

//#define GPX2CON  (*(volatile unsigned int *)0x11000c40)
//#define GPX2DAT  (*(volatile unsigned int *)0x11000c44)

/*
typedef struct
{
	unsigned int CON;
	unsigned int DAT;
	unsigned int PUD;
	unsigned int DRV;
}gpx2;

#define GPX2 (*(volatile gpx2 *)0x11000c40)
*/


void Dealy_Ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<2500;j++);
}

void main(void)
{
	GPX2.CON = GPX2.CON & (~(0xf << 28)) | (1 << 28);
	/*将GPX2_7管脚设置成输出功能*/
	while(1)
	{
		GPX2.DAT = GPX2.DAT | (1 << 7);
		/*GPX2_7输出高电平*/
		Dealy_Ms(1000);
		/*延时*/
		GPX2.DAT = GPX2.DAT & (~(1 << 7));
		/*GPX2_7输出低电平*/
		Dealy_Ms(1000);
		/*延时*/
	}
}



