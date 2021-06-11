#include <signal.h>
#include <stdio.h>
#include <unistd.h>

void ouch(int sig)
{
    printf("OUCH! - I got signal %d\n", sig);
}

int main(void)
{
    struct sigaction act;

	//	�ź�sigemptyset�������ź�Ϊ�գ�
    act.sa_handler = ouch;
    sigemptyset(&act.sa_mask);
    act.sa_flags = 0;

    sigaction(SIGINT, &act, 0);

  while(1) 
  {
    printf("Hello World!\n");
    sleep(1);
  }
}
//	 sigemptyset(&act.sa_mask);�� (void) signal(SIGINT, ouch);�����ǲ�һ���ģ��ܵ���˵
//	sigemptyset�ǲ���ϵͳ����ģ�signal��C���Ա�׼��ģ�
//	signal���յ�һ��Ctrl-C��ʱ�򣬾�ִ��������жϴ��룻
//	sigemptyset���յ�һ��Ctrl-C��ʱ�򣬾�ִ��������жϴ��룻
//	signal�����ܽ��ܵ�һ���źţ����ڶ��źŵ�ʱ�򣬾ͽ��������ź�
//	sigemptyset���ܵ�һ��Ctrl-C��ʱ�򣬾�ִ������Ĵ��룬�����Ƕ�εġ�