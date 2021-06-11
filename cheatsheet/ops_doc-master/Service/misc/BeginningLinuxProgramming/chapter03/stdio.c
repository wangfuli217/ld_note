#include <stdio.h>

//---------------------------------------------------
//		一个一个字符搬移来实现文件的搬移
//  		前面也讲过用write 和read 函数进行数据搬移
//		其实，还可以用到mv 命令进行搬移

// 文件的结束，一般文件是以EOF结束的，该值是一个
//负值。fgetc和write的读取的没有太大的差别
// 其本质上，都是返回值小于0 
//---------------------------------------------------
int main(void)
{
    int c;
    FILE *in, *out;

    in = fopen("file.in","r");
    out = fopen("file.out","w");

    while((c = fgetc(in)) != EOF)
    {
	  fputc(c,out);
	  printf("%c",c);
    }
    printf("%d",EOF);  //EOF ==-1

    exit(0);
}
