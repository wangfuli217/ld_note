#include <stdarg.h>
#include <time.h>
#include <stdio.h>
void logprintf(const char* format,...){
	va_list arg;
	va_start(arg,format);
	char buf[500];
	vsnprintf(buf,sizeof(buf),format,arg);		//自动加\0
	
	time_t sec;
	time(&sec);
	struct tm* localtm;
	localtm=localtime(&sec);
	printf("%d-%d-%d %d:%d:%d =>%s",localtm->tm_year+1900,localtm->tm_mon+1,localtm->tm_mday,
									localtm->tm_hour,localtm->tm_min,localtm->tm_sec,
									buf);
}
int main(int argc, const char *argv[])
{
	logprintf("%s\n","this is test");		
	return 0;
}
