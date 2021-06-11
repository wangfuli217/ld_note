#include "cmd.h"
#include "led.h"
#include "nand.h"

//s1 = "hello", s2 = "hallo"
int my_strcmp(char *s1, char *s2)
{
    while(*s1) {
        if(*s1 != *s2)
            return *s1 - *s2;
        s1++;
        s2++;
    }
    if (*s2)
        return -1;
    else
        return 0;
}

//都nand数据命令函数
void cmd_nandread(void)
{
    //指定内存的一个起始地址
    unsigned char *ptr = (unsigned char *)0x20018000;
    int i;
    char itoa_buf[11];

    //将nand0地址的数据都到内存0x20018000,大小为1页
    nand_read_page(ptr, 0);

    uart_puts("\n nand read data:\n");
    for (i = 0; i < 2048; i++) {
        if (!(i%4))
            uart_puts("\n");
        itoa(itoa_buf, *(ptr + i)); //转换
        uart_puts(itoa_buf);
        uart_puts(" "); //两个数据用空格间隔开
    }
}

#define KERNEL_SIZE 0xC00000 //操作系统的大小
#define PAGE_SIZE   2048 //页大小
void cmd_bootlinux(void)
{
    //目标：将Nand从6M开始，拷贝12M数据到内存0x20008000
    //最终从0x20008000启动操作系统
    //1.完成拷贝
    unsigned char *ptr = (unsigned char *)0x20008000;
    unsigned int src_addr = 0x600000; //Nand的起始地址
    int i;
    //数据类型：void (*)(int, int, unsigned int)
    void (*linux_start)(int, int, unsigned int);//函数指针变量
    
    for (i = 0; i < KERNEL_SIZE/PAGE_SIZE;i++) {
        nand_read_page(ptr, src_addr); //读1页
        src_addr += 2048; //更新读位置
        ptr += 2048;      //更新写位置
        uart_puts(".");   //调试信息
    }
    //2.启动操作系统
    //明确：操作系统的入口地址就是0x20008000
    //明确：shell需要给操作系统传递0，2456,0三个参数
    //新数据类型：void (*)(int,int,unsigned int)类似int
    linux_start = (void(*)(int,int,unsigned int))0x20008000;
    uart_puts("\n boot linux...\n");
    linux_start(0, 2456, 0); //让CPU到0x20008000运行
}

//根据用户操作的硬件定义和初始化操作命令对象
static cmd_t cmd_list[] = {
    {"ledon", led1_on}, //初始化第一个命令对象
    {"ledoff", led1_off},//初始化第二个命令对象
    {"readid", nand_read_id}, //初始化第三个命令对象
    {"nandread", cmd_nandread}, //初始化第四个命令对象
    {"bootlinux", cmd_bootlinux} //初始化第五个命令对象
};

//main.c:
//cmd_t *cmd;
//uart_gets(buf); //buf = "ledon" 
//cmd = find_cmd(buf) 
//结果：cmd = &cmd_list[0];
//调用对应函数：cmd->cmd_func();
cmd_t *find_cmd(char *input_cmd)
{
   int num = 
       sizeof(cmd_list) / sizeof(cmd_list[0]);
   int i;

   for (i = 0; i < num; i++) {
        if (my_strcmp(input_cmd, 
                    cmd_list[i].cmd_name) == 0) {
            //找到对应的命令
            return &cmd_list[i];
        } 
   }
   return 0;
}








