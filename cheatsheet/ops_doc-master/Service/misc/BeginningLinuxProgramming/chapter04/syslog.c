#include <syslog.h>
#include <stdio.h>

//----------------------------------------------------
//	��־���漰��һЩ�쳣�����⣬
//	��Ҫ�����ڳ�ʱ���ڸ��ٳ����
//	ִ�У�
//	Ҫ���ٳ�������־����д��������
//	��д��д��ֻ�г����쳣������²�д
//---------------------------------------------------
int main(void)
{
    FILE *f;

    f = fopen("not_here","r");
    if(!f)
        syslog(LOG_ERR|LOG_USER,"oops - %m\n");
    exit(0);
}