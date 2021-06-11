//定义寄存器地址信息
//控制配置寄存器
#define GPC1CON *((volatile unsigned long *)0xE0200060)
#define GPC1DATA *((volatile unsigned long *)0xE0200064)
#define GPC1PUD *((volatile unsigned long *)0xE0200068)
void led_init(void)
{
    //1.配置GPC1_3为输出口
    GPC1CON &= ~(0xf << 12);
    GPC1CON |= (1 << 12);
    //2.禁止GPC1_3上,下拉电阻功能
    GPC1PUD &= ~(0x3 << 6);
}
void led_on(void)
{
        //亮
        GPC1DATA |= (1 << 3);
}
void led_off(void)
{
        //灭
        GPC1DATA &= ~(1 << 3); 
}
