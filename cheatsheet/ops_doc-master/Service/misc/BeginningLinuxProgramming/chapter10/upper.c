#include <stdio.h>
#include <ctype.h>
/*
	tr(translate character):ת���ַ���
	toupper����tolower����
	EOF == -1
	tr����ʵ��ת���ַ�:��ʵ�ǽ�һ���ַ��������һ���ַ�
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
