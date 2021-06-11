/*
   ctime函数演示
   */
#include<stdio.h>
#include<time.h>
int main()
{
	time_t tm=0;
	time(&tm);
	printf("%s",ctime(&tm));
	struct tm *p_tm=gmtime(&tm);
	printf("%s",asctime(p_tm));
	p_tm=localtime(&tm);
	printf("%s",asctime(p_tm));
	return 0;
}
