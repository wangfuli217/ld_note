#include "exynos_4412.h"

/*****ʵ��Ŀ�ģ�ʹ�ÿ��Ź���ʱ��������λ�źţ��۲�ι���벻ι������������*****/

/*****ʵ�鲽��*****/

void Dealy_Ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<2500;j++);
}

void main(void)
{
	unsigned int i;

	/*1.����һ��Ԥ��Ƶֵ = 100000000 / (255 + 1) = 390625HZ*/
	WDT.WTCON = WDT.WTCON | (0xFF << 8);
	/*2.���ö���Ԥ��Ƶֵ = 390625 / 128 =  3052HZ*/
	WDT.WTCON = WDT.WTCON | (0x3 << 3);
	/*3.ʹ�ܿ��Ź���ʱ���ܹ�������λ�ź�*/
	WDT.WTCON = WDT.WTCON | 1;
	/*4.���ݼ�����������ֵ  ι��*/
	WDT.WTCNT = 3052*10;
	/*5.�򿪿��Ź���ʱ��*/
	WDT.WTCON = WDT.WTCON | (1 << 5);

	/*��ʼ��LED*/
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
		/*ι��*/
		WDT.WTCNT = 3052*10;
	}
}
