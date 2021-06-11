#ifndef __CMD_H
#define __CMD_H

//声明描述shell命令的数据结构
typedef struct _cmd {
    char *cmd_name; //命令的名称
    void (*cmd_func)(void);//命令对应的方法
}cmd_t;

/* 功能：根据用户输入的命令，找到对应的命令对象
 * 参数：input_cmd指向用户输入的命令
 * 返回值：返回这个命令对应的命令对象的指针
 * */
extern cmd_t *find_cmd(char *input_cmd);


/* 功能：用于字符串的比较
 * 参数：s1,s2指向要比较的字符串首地址
 * 返回值：
 *      s1 == s2:返回0
 *      s1 > s2:返回>0
 *      s1 < s2:返回<0
 * */
extern int my_strcmp(char *s1, char *s2);

#endif
