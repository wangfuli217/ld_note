#include "exynos_4412.h"

/*****实验目的：使用看门狗定时器产生复位信号，观察喂狗与不喂狗的运行现象*****/

/*****实验步骤*****/

void Dealy_Ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<2500;j++);
}

void main(void)
{
	unsigned int i;

	/*1.设置一级预分频值 = 100000000 / (255 + 1) = 390625HZ*/
	WDT.WTCON = WDT.WTCON | (0xFF << 8);
	/*2.设置二级预分频值 = 390625 / 128 =  3052HZ*/
	WDT.WTCON = WDT.WTCON | (0x3 << 3);
	/*3.使能看门狗定时器能够产生复位信号*/
	WDT.WTCON = WDT.WTCON | 1;
	/*4.给递减计数器赋初值  喂狗*/
	WDT.WTCNT = 3052*10;
	/*5.打开看门狗定时器*/
	WDT.WTCON = WDT.WTCON | (1 << 5);

	/*初始化LED*/
	GPX2.CON = GPX2.CON & (~(0xf << 28)) | (1 << 28);

	while(1)
	{
		for(i=0;i<5;i++)
		{
			/*LED_ON*/
			GPX2.DAT = GPX2.DAT | (1 << 7);
			Dealy_Ms(500);
			/*LED_OFF*/
			GPX2.DAT = GPX2.DAT & (~(1 << 7));
			Dealy_Ms(500);
		}
		/*喂狗*/
		WDT.WTCNT = 3052*10;
	}
}
