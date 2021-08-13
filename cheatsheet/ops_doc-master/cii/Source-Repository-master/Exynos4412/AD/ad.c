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

unsigned char UART_REC_BYTE(void)
{
	unsigned char i;

	while(!(UART2.UTRSTAT2 & (1 << 0)));
	/*****�жϽ��ջ������Ƿ���յ�����*****/
	i = UART2.URXH2;
	/*****�����յ������ݶ�ȡ������*****/
	return i;
}

/*1ʵ��Ŀ�ģ�ʹ��ADת����������λ���������ѹ*/

/*2ʵ�鲽��*/

/*AD��ʼ��*/
void AD_INIT(void)
{
	/*1.ѡ��AD��ͨ��Ϊͨ��3*/
	 ADCMUX =  ADCMUX & (~(0xF)) | 0x3;
	/*2.ѡ��ADת������Ϊ12λ*/
	 ADCCON = ADCCON | (1 << 16);
	/*3.ʹ��Ԥ��Ƶ*/
	 ADCCON = ADCCON | (1 << 14);
	/*4.���÷�Ƶֵ = 100000000 / (19 + 1) = 5M*/
	 ADCCON = ADCCON & (~(0xFF << 6)) | (19 << 6);
	/*5.ѡ��AD����ģʽ*/
	 ADCCON = ADCCON & (~(1 << 2));
	/*6.ѡ��ʼת���Ĵ�����ʽ*/
	 ADCCON = ADCCON & (~(1 << 1));
}
/*��ȡADֵ*/
unsigned int Get_AD_Value(void)
{
	unsigned int AD;
	/*1.��ʼת��*/
	ADCCON = ADCCON | 1;
	/*2.�ж��Ƿ�ת�����*/
	while(!(ADCCON & (1 << 15)));
	/*3.��ȡת�����*/
	AD = ADCDAT & 0xFFF;
	/*4.��ת���������Ϊʵ�ʵĵ�ѹֵ��mV��*/
	AD = AD * 0.44;
	return AD;
}

/*��ʮ������ת�����ַ���*/
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
