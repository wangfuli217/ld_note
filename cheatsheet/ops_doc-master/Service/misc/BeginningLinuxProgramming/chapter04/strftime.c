#include <time.h>
#include <stdio.h>

//-----------------------------------------------------
//��ʽ�����ڵĺ���strftime	:����ֵת�����ַ���
//��ʽ�����ڵĺ���strptime:���ַ���ת���ɽṹ��struct tm
//-----------------------------------------------------
int main(void)
{
    struct tm *tm_ptr, timestruct;
    time_t the_time;
    char buf[256];
    char *result;

	memset(buf,0,256);
	//ϵͳ��ʱ��
    (void) time(&the_time);
	//��ȡ��ǰ��ʱ��
    tm_ptr = localtime(&the_time);
	//��ʽ�����ں�ʱ��
    strftime(buf, 256, "%A %d %B, %I:%S %p", tm_ptr);

    printf("strftime gives: %s\n", buf);

    strcpy(buf,"Mon 26 July 1999, 17:53 will do fine");

    printf("calling strptime with: %s\n", buf);
    tm_ptr = &timestruct;
	
    strptime(buf,"%a %d %b %Y, %R", tm_ptr);
    printf("strptime consumed up to: %s\n", buf);

    printf("strptime gives:\n");
    printf("date: %02d/%02d/%02d\n", 
        tm_ptr->tm_year, tm_ptr->tm_mon+1, tm_ptr->tm_mday);
    printf("time: %02d:%02d\n",
        tm_ptr->tm_hour, tm_ptr->tm_min);
    exit(0);
}
