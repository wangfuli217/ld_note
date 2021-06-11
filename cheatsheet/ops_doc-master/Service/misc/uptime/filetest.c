/*************************************************************************
	> File Name: filetest/filetest.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Wed 18 Oct 2017 10:03:28 AM CST
 ************************************************************************/

#include<stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

static struct tm local_tm;
static time_t now;

int get_system_uptime(double *time)
{
	if (time == NULL)
		return -1;


	/* chdir to the proc filesystem to make things easier */

	char buffer[4096 + 1];
	int fd, len;

	fd = open("/proc/uptime", O_RDONLY);
	if(fd < 0 )
	{
		perror("/proc/uptime");
		return -1;
	}
	len = read(fd, buffer, sizeof(buffer) - 1);
	close(fd);
	buffer[len] = '\0';

	*time = atof(buffer);
	return 0;
}
int get_system()
{
	time(&now);
	tzset();
	localtime_r(&now,&local_tm);
}
int main(int argc,char *argv[])
{
	double uptime;
	char buf[2048];
	if(argc == 2 && strcmp(argv[1],"-d") == 0)
			daemon(0,0);
	while(1)
	{
		get_system_uptime(&uptime);
		get_system();
		sprintf(buf,"%lf %04d-%02d-%02d %02d:%02d:%02d\n",uptime,local_tm.tm_year + 1900,local_tm.tm_mon + 1,local_tm.tm_mday,local_tm.tm_hour,local_tm.tm_min,local_tm.tm_sec);
		printf("%s",buf);
		FILE *fp = fopen("/home/sysuser/runtime.txt","a+");
		fwrite(buf,1,strlen(buf),fp);
		fclose(fp);
		sleep(60);
	}

}
