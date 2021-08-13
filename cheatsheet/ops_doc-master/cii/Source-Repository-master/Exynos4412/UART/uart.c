#include "exynos_4412.h"

/*****实验目的：使用UART功能使开发板与电脑之间通信*****/

/*****实验步骤*****/

//1.查找电路图找出UART使用的哪个引脚

//2.设置相应的寄存器

void UART_INIT(void)
{
	/*****1.将GPA1_0和GPA1_1引脚设置成串口功能*****/
	GPA1.CON = GPA1.CON & (~(0xFF << 0)) | (0x22 << 0);
	/*****2.设置数据位位数(8)、停止位个数(1)、校验方式(无)、设置通信方式为正常模式*****/
	UART2.ULCON2 = UART2.ULCON2 & (~(0x7F << 0)) | (0x3 << 0);
	/*****3.选择收发数据的工作模式*****/
	UART2.UCON2 = UART2.UCON2 & (~(0xF << 0)) | (0x5 << 0);
 	/*****4.设置波特率(115200)*****/
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
	/*****判断发送缓冲区是否为空*****/
	UART2.UTXH2 = Dat;
	/*****将需要发送的数据放到发送寄存器*****/
}

unsigned char UART_REC_BYTE(void)
{
	unsigned char i;

	while(!(UART2.UTRSTAT2 & (1 << 0)));
	/*****判断接收缓冲区是否接收到数据*****/
	i = UART2.URXH2;
	/*****将接收到的数据读取并返回*****/
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
