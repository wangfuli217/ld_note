#include <stdlib.h>
#include <stdio.h>

extern char **environ;

//Linux����ϵͳ��ϵͳ��������һ���ļ��У����ļ�����ȫ����ϵͳ����
//���ǣ���ϵͳ������ʱ����Щȫ�ֱ���ȫ��������һ��ȫ�ֵ�
//ȫ�ֱ����У�����ʵ����һ����ά���ַ�������

int main(void)
{
    char **env = environ;

    while(*env) 
	{
        printf("%s\n",*env);
        env++;
    }
    exit(0);
}
