#include <time.h>
#include <stdio.h>
#include <unistd.h>

//-----------------------------------------------------
//	��ʵ�ú�������Ҫ���û���sleep()
// 	ÿ��2�룬��ִ�г��򣬳����ִ��
// 	�Ϻܼ򵥣���ʵ�漰���˽���֮���
//	���ȵ�֪ʶld
//-----------------------------------------------------
int main(void)
{
    int i;
    time_t the_time;

    for(i = 1; i <= 10; i++)
	{
        the_time = time((time_t *)0);
        printf("The time is %ld\n", the_time);
		 printf("The Time is %s",ctime(&the_time));
        sleep(2);
    }
    exit(0);
}
