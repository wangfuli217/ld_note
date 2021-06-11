#include "led.h"
#include "cmd.h"
#include "nand.h"

//字符串比较函数定义
int my_strcmp(char *s1, char *s2)
{
    while(*s1) {
        if (*s1 != *s2)
            return *s1 - *s2;
        s1++;
        s2++;
    }  

    if (*s2)
        return -1;
    else
        return 0;
}

//定义初始化命令对象
static cmd_t cmd_list[] = {
    {"ledon", led_on},
    {"ledoff", led_off},
    {"readid", nand_read_id}
};

//遍历匹配命令对象的函数定义
cmd_t *find_cmd(char *input_name)
{
    int num = 
        sizeof(cmd_list) / sizeof(cmd_list[0]);
    int i;

    for (i = 0; i < num; i++) {
        if(!my_strcmp(input_name,
                     cmd_list[i].cmd_name))
        return &cmd_list[i];
    }

    return 0; //出错
}












