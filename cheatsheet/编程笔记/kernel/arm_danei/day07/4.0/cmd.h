#ifndef __CMD_H
#define __CMD_H

/*功能：字符串比较
 *参数：s1,s2分别为要比较的字符串
  返回值：
        s1 == s2,返回0
        s1 > s2, 返回>0 (1)
        s1 < s2, 返回<0 (-1)
 * */
extern int my_strcmp(char *s1, char *s2);
#endif
