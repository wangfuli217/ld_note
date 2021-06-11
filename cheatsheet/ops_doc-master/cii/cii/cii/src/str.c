#include<string.h>
#include<limits.h>
#include<stdarg.h>
#include<stdio.h>
#include"assert.h"
#include"mem.h"
#include"str.h"

/**
 * 上面的idx宏按字符串起始偏移从1开始, 其实更自然
 * 但和C的习惯冲突, 怕引起混乱产生bug, 所以
 * 用下面的从0开始的宏, 好在这个idx和convert的设计
 * 把索引的和位置的绑定分离, 改动起来很方便
 */
//#define idx(i, len) ((i) <= 0 ? (i) + (len) : (i) - 1)
/*#define convert(s, i, j) do{ int len; \
    assert(s); len = strlen(s); \
    i = idx(i, len); j = idx(j, len); \
    if (i > j){ int t = i; i = j; j = t;} \
    assert(i >= 0 && j <= len);}while(0)*/

#define idx(i, len) ((i) < 0 ? (i) + (len) : (i))

#define convert(s, i, j) do{ int len; \
    assert(s); len = strlen(s); \
    i = idx(i, len); j = idx(j, len); \
    if (i > j){ int t = i; i = j; j = t;} \
    assert(i >= 0 && j <= len);}while(0)


char *str_sub (const char *s, ssize_t i, ssize_t j){
    char *str, *p;
    convert(s, i, j);

    p = str = ALLOC(j - i + 1);
    while(i < j){
        *p++ = s[i++];
    }
    *p = '\0';
    return str;
}


char *str_dup(const char *s, ssize_t i, ssize_t j, ssize_t n){
    int k;
    char *str, *p;

    assert(n >= 0);
    convert(s, i, j);
    p = str = ALLOC(n * (j - i) + 1);
    if(i < j){
        while(n-- > 0){
            for(k = i; k < j; k++){
                *p++ = s[k];
            }
        }
    }
    *p = '\0';
    return str;
}


char *str_cat(const char *s1, ssize_t i1, ssize_t j1,
    const char *s2, ssize_t i2, ssize_t j2){
    char *str, *p;

    convert(s1, i1, j1);
    convert(s2, i2, j2);
    p = str = ALLOC(j1 - i1 + j2 - i2 + 1);
    while(i1 < j1){
        *p++ = s1[i1++];
    }
    while(i2 < j2){
        *p++ = s2[i2++];
    }
    *p = '\0';
    return str;
}


char *str_cat_v(const char *s,...){
    char *str, *p;
    const char *save = s;
    int i, j;
    ssize_t len = 0;

    va_list ap;
    va_start(ap, s);
    /**
     * len <- the length of the result
     */
    while(s){
        i = va_arg(ap, int);
        j = va_arg(ap, int);
        convert(s, i, j);
        len += j - i;
        s = va_arg(ap, const char *);
    }
    va_end(ap);

    p = str = ALLOC(len + 1);
    s = save;

    va_start(ap, s);
    /**
     * copy each s[i:j] to p, increment p
     */
    while(s){
        i = va_arg(ap, int);
        j = va_arg(ap, int);
        convert(s, i, j);
        while(i < j){
            *p++ = s[i++];
        }
        s = va_arg(ap, const char *);
    }
    va_end(ap);
    *p = '\0';
    return str;
}


char *str_reverse(const char *s, ssize_t i, ssize_t j){
    char *str, *p;
    convert(s, i, j);

    p = str = ALLOC(j - i + 1);
    while(i < j){
        *p++ = s[--j];
    }
    *p = '\0';
    return str;
}


char *str_map(const char *s, ssize_t i, ssize_t j,
    const char *from, const char *to){
    static char map[256] = {0};
    char * str = NULL, *p;
    if(from && to){
        /**
         *rebuild map
         */
        unsigned c;
        for(c = 0; c < sizeof(map); c++){
            map[c] = c;
        }
        while(*from && *to){
            map[(unsigned char)(*from++)] = *to++;
        }
        assert('\0'== *from && '\0' == *to);
    }else{
        assert(NULL == from && NULL == to && NULL == s);
        assert(map['a']);
    }

    if(s){
        /**
         *map s[i:j] into a new string
         */
        convert(s, i, j);
        p = str = ALLOC(j - i + 1);
        while(i < j){
            *p++ = map[(unsigned char)s[i++]];
        }
        *p = '\0';
    }
    return str;
}

ssize_t
str_pos
(const char *s, ssize_t i)
{
    ssize_t len;
    assert(s);

    len = strlen(s);
    i = idx(i, len);
    /**
     * 
    assert(i >= 0 && i <= len);
    return i + 1;
     */
    assert(i >= 0 && i < len);
    return i;
}


ssize_t 
str_len
(const char *s, ssize_t i, ssize_t j)
{
    convert(s, i, j);
    return j - i;
}


int
str_cmp
(const char *s1, ssize_t i1, ssize_t j1,
    const char *s2, ssize_t i2, ssize_t j2)
{
    convert(s1, i1, j1);
    convert(s2, i2, j2);

    s1 += i1;
    s2 += i2;

    if((j1 - i1) < (j2 - i2)){
        int cond = strncmp(s1, s2, j1 - i1);
        return 0 == cond ? -1 : cond;
    }else if((j1 - i1) > (j2 - i2)){
        int cond = strncmp(s1, s2, j2 - i2);
        return 0 == cond ? 1 : cond;
    }else{
        return strncmp(s1, s2, j1 - i1);
    }
}


ssize_t
str_chr
(const char *s, ssize_t i, ssize_t j, int c)
{
    convert(s, i, j);
    for(;i < j; i++){
        if(c == s[i]){
            return i;
        }
    }
    return -1;
}


ssize_t
str_rchr
(const char *s, ssize_t i, ssize_t j, int c)
{
    /*
    convert(s, i, j);
    for(;i < j; j--){
        if(c == s[j]){
            return j;
        }
    }
    return -1;*/
    /**
     * 不直接复用str_chr的方法是为了保证
     * 搜索范围统一, 否则搜索范围整体向j偏了1
     */
    convert(s, i, j);
    while(j > i){
        if(c == s[--j]){
            return j;
        }
    }
    return -1;
}


ssize_t
str_upto
(const char *s, ssize_t i, ssize_t j, const char *set)
{
    assert(set);
    convert(s, i, j);
    for(;i < j; i++){
        if(strchr(set, s[i])){
            return i;
        }
    }
    return -1;
}


ssize_t
str_rupto
(const char *s, ssize_t i, ssize_t j, const char *set)
{
    assert(set);
    convert(s, i, j);
    while(i < j){
        if(strchr(set, s[--j])){
            return j;
        }
    }
    return -1;
}


ssize_t
str_find
(const char *s, ssize_t i, ssize_t j, const char *str)
{
    ssize_t len;
    convert(s, i, j);
    assert(str);

    len = strlen(str);
    if(0 == len){
        return i;
    }else if(1 == len){
        for(; i < j; i++){
            if(s[i] == *str){
                return i;
            }
        }
    }else {
        for(;i + len <= j; i++){
            /**
             * s[i...] == str[0..len-1]
             */
            if(strncmp(&s[i], str, len) == 0){
                return i;
            }
        }
    }

    return -1;
}



ssize_t
str_rfind
(const char *s, ssize_t i, ssize_t j, const char *str)
{
    ssize_t len;
    convert(s, i, j);
    assert(str);

    len = strlen(str);
    if(0 == len){
        return j;
    }else if(1 == len){
        while(j > i){
            if(s[--j] == *str){
                return j;
            }
        }
    }else {
        for(;j - len >= i; j--){
            if(strncmp(&s[j - len], str, len) == 0){
                return j;
            }
        }
    }

    return -1;
}


ssize_t
str_any
(const char *s, ssize_t i, const char *set)
{
    ssize_t len;

    assert(s);
    assert(set);
    len = strlen(s);
    i = idx(i, len);
    assert(i >=0 && i < len);
    if(i < len && strchr(set, s[i])){
        return i + 1;
    }
    return -1;
}



ssize_t
str_many
(const char *s, ssize_t i, ssize_t j, const char *set)
{
    assert(set);
    convert(s, i, j);
    if(i < j && strchr(set, s[i])){
        do{
            i++;
        }while(i < j && strchr(set, s[i]));
        return i;
    }
    return -1;
}


ssize_t
str_rmany
(const char *s, ssize_t i, ssize_t j, const char *set)
{
    assert(set);
    convert(s, i, j);
    if(j > i && strchr(set, s[j])){
        do{
            --j;
        }while(j >= i && strchr(set, s[j]));
        return j + 1;
    }
    return -1;
}


ssize_t
str_match
(const char *s, ssize_t i, ssize_t j, const char *str)
{
    ssize_t len;

    convert(s, i, j);
    assert(str);
    len = strlen(str);

    if(0 == len){
        return i;
    }else if(1 == len){
        if(i < j && s[i] == *str){
            return i + 1;
        }
    }else if(i + len <= j &&
            strncmp(&s[i], str, len) == 0){
        return i + len;
    }
    return -1;
}



ssize_t 
str_rmatch
(const char *s, ssize_t i, ssize_t j, const char *str)
{
    ssize_t len;

    convert(s, i, j);
    assert(str);
    len = strlen(str);

    if(0 == len){
        return j;
    }else if(1 == len){
        if(j > i && s[j] == *str){
            return j;
        }
    }else if(j - len >= i &&
            strncmp(&s[j - len], str, len) == 0){
        return j - len;
    }
    return -1;
}

