#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <assert.h>
#include "getword.h"


//fist = isalpha
//rest = isalpha || c == '_' 
int getword(FILE *fp, char *buf, int size, 
			int (*first)(int c), int (*rest)(int c))
{
	int i = 0,c;
	
	assert(fp && buf && size > 1 && first && rest);	
	c = getc(fp);
	for (;c != EOF; c = getc(fp))
	{
		//字符满足开始条件,则开始存储字符 
		if(first(c))
		{
			if (i < size - 1)
			{
				buf[i] = c;
				i++;
			}
			c = getc(fp);
			break;		
		}
	}
	//字符满足后接条件 
	for (; c != EOF && rest(c); c = getc(fp))
	{
		if (i < size - 1)
		{
			buf[i] = c;
			i++;
		}
		//i >= size的字符串从fp流中取下，但未保存。
		//如abbcc，size太小则为abb，保证word从流中完全去除，保证下一个word正确 
	}
	if (i < size)
		buf[i] = '\0';
	else
		buf[size - 1] = '\0'; 
	if ( c != EOF)
		ungetc(c,fp);	//不属于rest集合，归还给文件流 
	return i; //采集到的字符个数 

}
