/*定义寄存器地址相关的宏*/
//配置寄存器
#define GPC1CON  *((volatile unsigned long *)0xE0200080)
//数据寄存器
#define GPC1DAT  *((volatile unsigned long *)0xE0200084)
//上下拉电阻配置寄存器
#define GPC1PUD  *((volatile unsigned long *)0xE0200088)
//初始化函数
void led_init(void)
{
    //1.配置GPC1_3为输出口
    //GPC1_3对应的配置寄存器的bit位[12:15]
    GPC1CON &= ~(0xf << 12); //bit[12:15]=0000
    GPC1CON |= (1 << 12); //bit[12:15]=0001

    //2.禁止GPC1_3上/下拉电阻
    //GPC1_3对应的bit位bit[6:7]
    GPC1PUD &= ~(0x3 << 6);//bit[6:7] = 00
}

//开灯函数
void led1_on(void)
{
    //GPC1_3
    GPC1DAT |= (1 << 3);
}

//关灯函数
void led1_off(void)
{
    //GPC1_3
    GPC1DAT &= ~(1 << 3);
}






