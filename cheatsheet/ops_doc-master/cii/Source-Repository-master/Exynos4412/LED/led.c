#include "exynos_4412.h"

/*****���ڼĴ����ķ�װ*****/

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
	/*��GPX2_7�ܽ����ó��������*/
	while(1)
	{
		GPX2.DAT = GPX2.DAT | (1 << 7);
		/*GPX2_7����ߵ�ƽ*/
		Dealy_Ms(1000);
		/*��ʱ*/
		GPX2.DAT = GPX2.DAT & (~(1 << 7));
		/*GPX2_7����͵�ƽ*/
		Dealy_Ms(1000);
		/*��ʱ*/
	}
}



