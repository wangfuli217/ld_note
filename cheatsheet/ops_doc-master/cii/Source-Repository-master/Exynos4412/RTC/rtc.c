#include "exynos_4412.h"

void Dealy_Ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<2500;j++);
}

void UART_INIT(void)
{
	/*****1.��GPA1_0��GPA1_1�������óɴ��ڹ���*****/
	GPA1.CON = GPA1.CON & (~(0xFF << 0)) | (0x22 << 0);
	/*****2.��������λλ��(8)��ֹͣλ����(1)��У�鷽ʽ(��)������ͨ�ŷ�ʽΪ����ģʽ*****/
	UART2.ULCON2 = UART2.ULCON2 & (~(0x7F << 0)) | (0x3 << 0);
	/*****3.ѡ���շ����ݵĹ���ģʽ*****/
	UART2.UCON2 = UART2.UCON2 & (~(0xF << 0)) | (0x5 << 0);
 	/*****4.���ò�����(115200)*****/
	UART2.UBRDIV2 = UART2.UBRDIV2 & (~(0xFFFF << 0)) | (53 << 0);
	UART2.UFRACVAL2 = UART2.UFRACVAL2 & (~(0xF << 0)) | (5 << 0);
}

void UART_SEND_BYTE(unsigned char Dat)
{
	while(!(UART2.UTRSTAT2 & (1 << 1)));
	/*****�жϷ��ͻ������Ƿ�Ϊ��*****/
	UART2.UTXH2 = Dat;
	/*****����Ҫ���͵����ݷŵ����ͼĴ���*****/
	if (Dat == '\n')
		UART_SEND_BYTE('\r');
}

void UART_SEND_STR(unsigned char  *Pstr)
{
	while(*Pstr != '\0')
		UART_SEND_BYTE(*Pstr++);
}

void main(void)
{
	unsigned int Old_Time;

	/*1.��RTC����λ���޸�ʱ��*/
	RTCCON = RTCCON | 1;
	/*2.����ʱ����Ϣ*/
	RTC.BCDYEAR = 0x016;
	RTC.BCDMON  = 0x05;
	RTC.BCDDAY  = 0x3;
	RTC.BCDWEEK = 0x25;
	RTC.BCDHOUR = 0x16;
	RTC.BCDMIN  = 0x21;
	RTC.BCDSEC  = 0x0;
	/*3.�ر�RTC����λ*/
	RTCCON = RTCCON & (~1);

	UART_INIT();

	while(1)
	{
		/*ʱ����Ϣ�и���*/
		if(RTC.BCDSEC != Old_Time)
		{
			UART_SEND_BYTE(RTC.BCDYEAR);
			UART_SEND_BYTE(RTC.BCDMON);
			UART_SEND_BYTE(RTC.BCDWEEK);
			UART_SEND_BYTE(RTC.BCDDAY);
			UART_SEND_BYTE(RTC.BCDHOUR);
			UART_SEND_BYTE(RTC.BCDMIN);
			UART_SEND_BYTE(RTC.BCDSEC);
			Old_Time = RTC.BCDSEC;
		}
	}
}
