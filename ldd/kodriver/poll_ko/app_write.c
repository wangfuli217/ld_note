/*
 * =====================================================================================
 *
 *       Filename:  app_write.c
 *
 *    Description:  :wq
 *
 *        Version:  1.0
 *        Created:  2014年11月30日 23时07分24秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <string.h>

int main()
{
    FILE *fp = NULL;
    char Buf[128];


    /*打开设备文件*/
    fp = fopen("/dev/memdev0","r+");
    if (fp == NULL)
    {
        perror("/dev/memdev0");
        return -1;
    }

    /*写入设备*/
    strcpy(Buf,"memdev write!");
    printf("Write BUF: %s\n",Buf);
    fwrite(Buf, sizeof(Buf), 1, fp);

    sleep(5);
    fclose(fp);

    return 0;

}
