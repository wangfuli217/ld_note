 #include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
	char 	buf[512] = {0};
    char    buf2[512] = {0};
    char    buf3[512] = {0};
    char    buf4[512] = {0};
	int 	pos = 0;
	int 	year = 0;
    double  progress = 0;
	
	{
		sscanf("123456 ", "%s", buf);
		printf("%s\n", buf);
	}
	
	{
		sscanf("123456 ", "%4s", buf);
		printf("%s\n", buf);
	}
	
	{ //取到指定字符为止的字符串。如在下例中，取遇到空格为止字符串。
		sscanf("123456 abcdedf", "%[^ ]", buf);
		printf("%s\n", buf);
	}
	
	{ //取仅包含指定字符集的字符串。如在下例中，取仅包含1到9和小写字母的字符串。
		sscanf("123456abcdedfBCDEF", "%[1-9a-z]", buf);
		printf("%s\n", buf);
	}
	
	{ //取到指定字符集为止的字符串。如在下例中，取遇到大写字母为止的字符串。
		sscanf("123456abcdedfBCDEF", "%[^A-Z]", buf);
		printf("%s\n", buf);
	}
	
	{//给定一个字符串iios/12DDWDFF@122，获取 / 和 @ 之间的字符串，先将 "iios/"过滤掉，再将非'@'的一串内容送到buf中
		sscanf("iios/12DDWDFF@122", "%*[^/]/%[^@]", buf);
		printf("%s\n", buf);
	}
	
	{//给定一个字符串““hello, world”，仅保留world。（注意：“，”之后有一空格） %*s表示第一个匹配到的%s被过滤掉，即hello被过滤了
		sscanf("hello, world", "%*s%s", buf);
		printf("%s\n", buf);		
	}
	
    {   
        //sscanf("progress is : 22.97 %", "%s %s %s %f %s", buf, buf2, buf3, &progress, buf4); 这里progress 是float类型的变量
        sscanf("progress is : 22.97 %", "%s %s %s %lf %s", buf, buf2, buf3, &progress, buf4);
        printf("buf: %s\n", buf);
        printf("buf2: %s\n", buf2);
        printf("buf3: %s\n", buf3);
         printf("buf4: %s\n", buf4);
        printf("progress: %lf\n", progress);
    }
    
	struct date_t {
		char 	month;
		char 	day;
		short 	year;
	};
	
	date_t current_date = {0};
	sscanf("$TIME:20120228","$TIME:%4u%2u%2u",
                &current_date.year, 
                &current_date.month, &current_date.day);
	
	printf("month: %d\n", current_date.month);
	printf("day: %d\n", current_date.day);
	printf("year: %d\n", current_date.year);
	
	/*原因就在于：%u提取的month是32位无符号整型，函数会把目的地址当作一个32位整形的地址，因此就杯具了，
	 * DATE_T结构体占用4字节，里面&current_date.month实际是指向第1个字节的地址，如果被当作指向unsigned int的地址，
	 * 把月份month=0x0000 0002的值拷贝过去，前面提取的占用高2字节的year就会被覆盖掉，然后本来提取的year的值变成了0x0000*/

 
	struct date_t_2 {
		int 	month;
		int 	day;
		short 	year;
	};

	date_t_2 current_date_2 = {0};
	sscanf("$TIME:20120228","$TIME:%4d%2d%2d",
                &current_date_2.year, 
                &current_date_2.month, &current_date_2.day);
	
	printf("month: %d\n", current_date_2.month);
	printf("day: %d\n", current_date_2.day);
	printf("year: %d\n", current_date_2.year);
	
	{
		sscanf("Log_20150429_1.log", "Log_%d_%d.log", &year, &pos);
		printf("Date: %d\n", year);
		printf("Pos: %d\n", pos);
	}
	
	
	system("pause");
	
	return 0;
}
