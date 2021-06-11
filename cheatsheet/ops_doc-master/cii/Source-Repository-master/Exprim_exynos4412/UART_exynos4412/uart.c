#include "exynos_4412.h"

/* UART是先发LSB
 * 和校验 VS 奇偶校验
 * 停止位更主要的作用是校正时钟，防止有累计误差
 * UART一次只能发送1byte。
 */

/* GPA1_0	Rx;
 * GPA1_1	Tx
 * ULCON2	8bit，无校验
 * UCON2	
 * UBRDIV2
 * UFRACVAL2 
 * UTXH2
 *
 */

void delay(int num){
	int timer=num;
	while(timer--);
}
void uart_tx_str(char* send){
	int i=0;
	while(UART2.UTRSTAT2&0x2&&send[i]!='\0'){
	//while(send[i]!='\0'){
			UART2.UTXH2=send[i];
			i++;
			delay(0xfff);
	}
}

void uart_rx_byte(char& rcv){
	while(1){
		if(UART2.UTRSTAT2&0x1){
			*rcv=UART2.URXH2;
		}
	}
}

void uart_tx_byte(char send){
		
}


int main()
{
	
	GPA1.CON=GPA1.CON&(0xff)|(0x22);
	
	UART2.ULCON2=UART2.ULCON2&(~(0xff))|(0x3);	//000_0011	
	
	UART2.UCON2=UART2.UCON2&(~(0xf))|(0x5);		//_0101

	UART2.UBRDIV2=53;							//53.253

	UART2.UFRACVAL2=4;
	int timer=0xfffff;
	char mark[]="xj#";
	while(1){
		UART2.UTXH2=10;
		delay(timer);
		UART2.UTXH2=13;
		delay(timer);
		uarttx(mark);
#if 0
//		char rcv[100]={0};		//会调用memset
		char rcv[100];
		uartrx(rcv);
		delay(timer);
		uarttx(rcv);
#endif 
	}
	return 0;
}





