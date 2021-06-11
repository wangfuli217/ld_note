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
