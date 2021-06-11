#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
//-----------------------------------------------------
//	每次读取，写入一个字符，读取的字符个数
//	恰好等于要读去的字符的个数，如果不等
//   说明:读取失败
//-----------------------------------------------------


int main(void)
{
    char c; 
    int in, out;

    in = open("file.in", O_RDONLY); 
    out = open("file.out", O_WRONLY|O_CREAT, S_IRUSR|S_IWUSR);
    while(read(in,&c,1) == 1)
        write(out,&c,1);

    exit(0);
}

