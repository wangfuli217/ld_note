#include <stdio.h>
#include <ctype.h>
/*
	tr(translate character):转换字符。
	toupper函数tolower函数
	EOF == -1
	tr用来实现转换字符:其实是将一个字符翻译成另一个字符
*/
int main(void)
{
    int ch;

//	   while((ch = getchar()) != EOF) {
//        putchar(tolower(ch));
//    }
			
	#if 1
    while((ch = getchar()) != EOF) {
        putchar(toupper(ch));
    }
	#endif
    exit(0);
}
