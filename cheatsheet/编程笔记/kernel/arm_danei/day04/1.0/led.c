//定义寄存器地址信息
//控制配置寄存器
#define GPC1CON *((volatile unsigned long *)0xE0200080)
#define GPC1DATA *((volatile unsigned long *)0xE0200084)
#define GPC1PUD *((volatile unsigned long *)0xE0200088)

//声明
void delay(unsigned long n);

//LED开关灯函数:程序的真正入口
void led_test(void)
{
    //1.配置GPC1_3为输出口
    GPC1CON &= ~(0xf << 12); //GPC1CON &= 0xfff00fff
    GPC1CON |= (1 << 12);

    //2.禁止GPC1_3上,下拉电阻功能
    GPC1PUD &= ~(0x3 << 6);

    //3.GPC1_3输出1或者0实现开灯和关灯
    while(1) {
        //3.1.亮
        GPC1DATA |= (1 << 3);
        
        //延时
        delay(100000);

        //3.2.灭
        GPC1DATA &= ~(1 << 3); 
        
        //延时
        delay(100000);
    }
}

//延时函数
void delay(unsigned long n)
{
    unsigned long i = n;

    for (; i != 0; i--);
}












