#include <stdlib.h>
#include <stdio.h>

/*system��execl��һ�������ڣ�systemִ���Ժ��Զ��ص�ԭ�ȵĳ���ռ��С�
system �����Լ�������ռ䣬��������һ��ִ��һ�³���
Ȼ����execl�Ͳ�һ���ˣ����Ὣ���˵Ŀռ俴���Լ��Ŀռ䣬��
����ִ���Ժ�ĳ������*/
int main(void)
{
    printf("Running ps with system\n");
    system("ps -ax");
    printf("Done.\n");
    exit(0);
}

