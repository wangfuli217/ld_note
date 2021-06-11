#include <unistd.h>


//----------------------------------------------------
// 读取标准输入的文字信息，将信息输出
//或变成错误输出来
//----------------------------------------------------
int main(void)
{
    char buffer[128];
    int nread;
		
	//公司中在界面的打印信息，就是通过读取输入的，然后将读取的信息发送到
	//输入的串口中。
    nread = read(0, buffer, 128);
    if (nread == -1)
        write(2, "A read error has occurred\n", 26);

	/*如果当前读到的值大于128个字节，那么，对以后的字节作为命令输入*/
    if ((write(1,buffer,nread)) != nread)
        write(2, "A write error has occurred\n",27);

    exit(0);
}

