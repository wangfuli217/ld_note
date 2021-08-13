#include "exynos_4412.h"

/*
 * 递减频率=1/PCLK/(prescalar value+1)/(Division_factor)
 */ 

int main()
{
	/* 1. 设置一级分频，频率=100M / (255+1) = 390625 */
	WDT.WTCON|=(0xff<<8);

	/* 2. 设置二级分频 频率 =100M*/
	/* 3. 关闭中断功能*/
	/* 4. 使看门狗定时器在递减到0后产生复位信号 */
	/* 5. 初始化计数器中的值*/
	/* 6. 使能看门狗定时器 开始倒计时*/
	while(1){
		
	}
	return 0;
}
