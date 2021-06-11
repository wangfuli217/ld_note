#include <termios.h>
#include <stdio.h>

#define PASSWORD_LEN 8

//这里解说的是密码形式的设定，也就是讲的，输入的是密码东西
//这些东西是别人看不到的
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
