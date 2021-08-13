#include "exynos_4412.h"
/* APB-PCLK	source clock
 * 8bit prescaler :0~255 
 * second level divider:2,4,8,16	
 * TCNTB:period
 * TCMPB:high time
 * down-counter 递减计数器，从TCNTO里面的值开始减
 * 和周期有关的两个reg:TCNTB的值，TCNTO的递减周期,停止递减就不产生波形了
 */


int main()
{
	/*1.将GPD0_0设置成PWM(TOUT0)功能  GPD0CON[3:0]*/
	GPD0.CON=GPD0.CON&(~(0xf))|(0x2);

	/*2.设置Timer0的一级预分频  TCFG0[7:0]*/
	PWM.TCFG0=PWM.TCFG0&(~(0xff))|(99);	

	/*3.设置Timer0的二级预分频  TCFG1[3:0]*/
	PWM.TCFG1=PWM.TCFG1&(~(0xf))|(0x0);

	/*4.设置Timer0的为自动重装载  TCON[3]*/
	PWM.TCON|=(0x1<<3);	
		
	/*5.设置Timer0的周期  TCNTB0*/
	PWM.TCNTB0=100;				

	/*6.设置Timer0的高电平时间  TCMPB0*/
	PWM.TCMPB0=80;		

	/*7.手动的将TCNTB0中的值更新到递减计数器  TCON[1]*/
	PWM.TCON|=(0x1<<1);	

	/*8.关闭手动更新  TCON[1]*/
	PWM.TCON&=(~(0x1<<1));

	/*9.使能递减计数器开始倒计时  TCON[0]*/
	PWM.TCON|=(0x1);

	while(1);
	return 0;
}
