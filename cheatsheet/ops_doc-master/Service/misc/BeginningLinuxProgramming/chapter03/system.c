#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
//-----------------------------------------------------
//	ÿ�ζ�ȡ��д��һ���ַ�����ȡ���ַ�����
//	ǡ�õ���Ҫ��ȥ���ַ��ĸ������������
//   ˵��:��ȡʧ��
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

