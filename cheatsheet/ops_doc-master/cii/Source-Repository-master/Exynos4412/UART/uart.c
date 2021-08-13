#include "exynos_4412.h"

/*****ʵ��Ŀ�ģ�ʹ��UART����ʹ�����������֮��ͨ��*****/

/*****ʵ�鲽��*****/

//1.���ҵ�·ͼ�ҳ�UARTʹ�õ��ĸ�����

//2.������Ӧ�ļĴ���

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

void Dealy_Ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<2500;j++);
}

void UART_SEND_BYTE(unsigned char Dat)
{
	while(!(UART2.UTRSTAT2 & (1 << 1)));
	/*****�жϷ��ͻ������Ƿ�Ϊ��*****/
	UART2.UTXH2 = Dat;
	/*****����Ҫ���͵����ݷŵ����ͼĴ���*****/
}

unsigned char UART_REC_BYTE(void)
{
	unsigned char i;

	while(!(UART2.UTRSTAT2 & (1 << 0)));
	/*****�жϽ��ջ������Ƿ���յ�����*****/
	i = UART2.URXH2;
	/*****�����յ������ݶ�ȡ������*****/
	return i;
}

void main(void)
{
	unsigned char Num;

	UART_INIT();

	while(1)
	{
		Num = UART_REC_BYTE();
		UART_SEND_BYTE(Num);
	}
}
