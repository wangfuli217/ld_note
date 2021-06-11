#ifndef __CMD_H
#define __CMD_H

//声明描述命令相关的数据结构
typedef struct _cmd {
    char *cmd_name;//命令的名称
    void (*cmd_func)(void);//命令对应的函数
}cmd_t;

/*功能：字符串比较
 *参数：s1,s2分别为要比较的字符串
  返回值：
        s1 == s2,返回0
        s1 > s2, 返回>0 (1)
        s1 < s2, 返回<0 (-1)
 * */
extern int my_strcmp(char *s1, char *s2);

//遍历匹配命令对象
extern cmd_t *find_cmd(char *cmd_name);

#endif








