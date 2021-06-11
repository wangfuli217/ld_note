/*  This code, useupper.c, accepts a file name as an argument
    and will respond with an error if called incorrectly.  */

#include <unistd.h>
#include <stdio.h>

// execl("./upper", "upper", 0);	执行的命令---	执行的文件----	参数
//	fprintf	将字符写进对应的文件中
//	sprintf	将字符格式化写进对应字符串中
//	printf	将字符格式化输出到屏幕上，
int main(int argc, char *argv[])
{
    char *filename;

    if(argc != 2) 
	{
        fprintf(stderr, "usage: useupper file\n");
        exit(1);
    }
	//	参数的第二个参数是个文件名
    filename = argv[1];

/*  That done, we reopen the standard input, again checking for any errors as we do so,
    and then use execl to call upper.  */

    if(!freopen(filename, "r", stdin)) {
        fprintf(stderr, "could not redirect stdin to file %s\n", filename);
        exit(2);
    }
//upper中的getchar也能够读取文件中的内容
    execl("./upper", "upper", 0);

/*  Don't forget that execl replaces the current process;
    provided there is no error, the remaining lines are not executed.  */

    fprintf(stderr, "could not exec upper!\n");
    exit(3);
}
