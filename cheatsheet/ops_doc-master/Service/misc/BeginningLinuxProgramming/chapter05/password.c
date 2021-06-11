#include <termios.h>
#include <stdio.h>

#define PASSWORD_LEN 8

//�����˵����������ʽ���趨��Ҳ���ǽ��ģ�����������붫��
//��Щ�����Ǳ��˿�������
int main(void)
{
    struct termios initialrsettings, newrsettings;
    char password[PASSWORD_LEN + 1];
    tcgetattr(fileno(stdin), &initialrsettings);
    newrsettings = initialrsettings;
    newrsettings.c_lflag &= ~ECHO;

    printf("Enter password: ");
    if(tcsetattr(fileno(stdin), TCSAFLUSH, &newrsettings) != 0) 
	{
        fprintf(stderr,"Could not set attributes\n");
    }
    else 
	{
        fgets(password, PASSWORD_LEN, stdin);
        tcsetattr(fileno(stdin), TCSANOW, &initialrsettings);
        fprintf(stdout, "\nYou entered %s\n", password);
    }
    exit(0);
}
