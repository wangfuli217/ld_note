#include "exynos_4412.h"
#include "debug.h"

/*
 * P2725 最高的转换速率是1MSPS，相应的时钟是5MHz
 * P2728 5个时钟周期转换一次 
 *
 */ 
#define TIMER 		0xff111
#define VCC 		1.8					//V


void delay(unsigned int x){
	unsigned int timer=x;
	while(timer--);
}

int main()
{
	/* ADCCON */
	/* 1. 设置转换精度ADCCON[16] */

#ifdef BITS10
	ADCCON|=(0x0<<16);
#else
	ADCCON|=(0x1<<16);
#endif 
	/* 2. 使能预分频ADCCON[14] */
	ADCCON|=(0x1<<14);
	
	/* 3. 设置预分频ADCCON[13:6] */
	ADCCON=ADCCON&(~(0xff<<6))|(19<<6);		//PRSCVL==19	
	
	/* 4. 设置为正常工作/待机模式ADCCON[2] */
	ADCCON=ADCCON&(~(0x1<<2));
	
	/* 5. 关闭通过读触发一次转换ADCCON[1] */
	ADCCON=ADCCON&(~(0x1<<1));
	
	detobin(ADCCON);
	
	/* ADCDAT */
	/* reset value是随机值，读回来之后应该将高位清零 */

	/* ADCMUX */
	/* 选择通道ADCMUX[3:0]，这个芯片的多通道是分时复用的 */
	ADCMUX=0x3;
	
	while(1){
		/* 触发一次转换ADCCON[0] */
		ADCCON|=(0x1);

		/* 等待转换完成ADCCON[15] */
		while(!(ADCCON&(0x1<<15)));
		detobin(ADCCON&(0x1<<15));

		/* 读取转换结果ADCDAT[11:0] */
		detobin(ADCDAT);
		unsigned int res=ADCDAT&(0xfff);
		detobin(res);
		
		/* 变换为实际电压,并打印 */
#ifdef BITS10
		res=res*1000*VCC/(0x1<<10);	
#else
		res=res*1000*VCC/(0x1<<12);	
#endif 
		/* 打印转换结果 */
		printf("vol:%lu mV\n",res);	//不要先算除法，有舍入误差
		
		/* 延时 */
		delay(TIMER);
	}
	return 0;
}
