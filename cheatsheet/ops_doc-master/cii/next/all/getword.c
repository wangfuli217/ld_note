#include<ctype.h>
#include<string.h>
#include<stdio.h>
#include"assert.h"
#include"getword.h"

int
getword(FILE *fp, 
        char *buf,
        ssize_t size,
        int first(int c), 
        int rest(int c))
{
    int i = 0, c;

    assert(fp && buf && size > 1 && first && rest);
    c = getc(fp);

    for(; c !=EOF; c = getc(fp))
        if(first(c)){
            
            //<store c in buf if it fits>
            {
                if(i < size - 1)
                    buf[i++] = c;
            }
            c = getc(fp);
            break;
        }

    for(; c != EOF && rest(c); c = getc(fp)){
        //<store c in buf if it fits>
        if(i < size - 1)
            buf[i++] = c;
    }

    if(i < size)
        buf[i] = '\0';
    else
        buf[size-1] = '\0';

    if(c != EOF)
        ungetc(c, fp);
    return i > 0;
}
