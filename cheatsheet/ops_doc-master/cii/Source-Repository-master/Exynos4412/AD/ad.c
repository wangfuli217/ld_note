#include "exynos_4412.h"

unsigned int  g_AD_Value;
unsigned char g_AD_Value_Str[20] = "AD value is 0000mv";

void Dealy_Ms(unsigned int Time)
{
	unsigned int i,j;

	for(i=0;i<Time;i++)
		for(j=0;j<2500;j++);
}

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

void UART_SEND_BYTE(unsigned char Dat)
{
	while(!(UART2.UTRSTAT2 & (1 << 1)));
	/*****判断发送缓冲区是否为空*****/
	UART2.UTXH2 = Dat;
	/*****将需要发送的数据放到发送寄存器*****/
	if (Dat == '\n')
		UART_SEND_BYTE('\r');
}

void UART_SEND_STR(unsigned char  *Pstr)
{
	while(*Pstr != '\0')
		UART_SEND_BYTE(*Pstr++);
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

/*1实验目的：使用AD转换器测量电位器的输出电压*/

/*2实验步骤*/

/*AD初始化*/
void AD_INIT(void)
{
	/*1.选择AD的通道为通道3*/
	 ADCMUX =  ADCMUX & (~(0xF)) | 0x3;
	/*2.选择AD转换精度为12位*/
	 ADCCON = ADCCON | (1 << 16);
	/*3.使能预分频*/
	 ADCCON = ADCCON | (1 << 14);
	/*4.设置分频值 = 100000000 / (19 + 1) = 5M*/
	 ADCCON = ADCCON & (~(0xFF << 6)) | (19 << 6);
	/*5.选择AD工作模式*/
	 ADCCON = ADCCON & (~(1 << 2));
	/*6.选择开始转换的触发方式*/
	 ADCCON = ADCCON & (~(1 << 1));
}
/*获取AD值*/
unsigned int Get_AD_Value(void)
{
	unsigned int AD;
	/*1.开始转换*/
	ADCCON = ADCCON | 1;
	/*2.判断是否转换完成*/
	while(!(ADCCON & (1 << 15)));
	/*3.读取转换结果*/
	AD = ADCDAT & 0xFFF;
	/*4.将转换结果换算为实际的电压值（mV）*/
	AD = AD * 0.44;
	return AD;
}

/*将十进制数转换成字符串*/
void AD_To_Str(unsigned int UintDat)
{
	g_AD_Value_Str[12] = (UintDat/1000) + '0';
	g_AD_Value_Str[13] = (((UintDat%1000))/100) + '0';
	g_AD_Value_Str[14] = ((UintDat%100)/10) + '0';
	g_AD_Value_Str[15] = (UintDat%10) + '0';
}

void main(void)
{
	UART_INIT();
	AD_INIT();

	while(1)
	{
		g_AD_Value = Get_AD_Value();
		AD_To_Str(g_AD_Value);
		UART_SEND_STR(g_AD_Value_Str);
		Dealy_Ms(1000);
	}
}
