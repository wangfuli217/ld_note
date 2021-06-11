/*************************************************************************
	> File Name: time_main.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Fri 28 Nov 2014 03:57:02 PM CST
 ************************************************************************/

#include<stdio.h>
#include <time.h>
#include <sys/time.h>

int main(int argc,char *argv[])
{

	//get seconds from 1970year
	time_t now;
	now = time(NULL);
	printf("now:%ld\n", now);
	time(&now);
	printf("now:%ld\n", now);

	//print string time
	printf("ctime:%s\n",ctime(&now));


	char *wday[]={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
	time_t timep;
	struct tm *p;
	time(&timep);
	p=gmtime(&timep); //get world time
	printf("%d-%d-%d ",(1900+p->tm_year), (1+p->tm_mon),p->tm_mday);
	printf("%s;%d:%d:%d\n", wday[p->tm_wday], p->tm_hour, p->tm_min, p->tm_sec);
	printf("asctime:%s\n",asctime(p));

	p=localtime(&timep); //get local time
	printf("%d-%d-%d ", (1900+p->tm_year),( 1+p->tm_mon), p->tm_mday);
	printf("%s;%d:%d:%d\n", wday[p->tm_wday],p->tm_hour, p->tm_min, p->tm_sec);

	//get seconds
	timep = mktime(p);
	printf("time()->localtime()->mktime():%ld\n",timep);

	//#include <sys/time.h>
	struct timeval tv;
	struct timezone tz;
	gettimeofday (&tv , &tz);
	printf("tv_sec; %ld\n", tv.tv_sec) ;
	printf("tv_usec; %ld\n",tv.tv_usec);
	printf("tz_minuteswest; %d\n", tz.tz_minuteswest);  //difference Greenwich
	printf("tz_dsttime, %d\n",tz.tz_dsttime);
	return 0;
}
