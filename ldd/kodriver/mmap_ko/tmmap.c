/*
 * =====================================================================================
 *
 *       Filename:  tdrv.c
 *
 *    Description:  
 *
 *        Version:  1.0
 *        Created:  2014年11月30日 18时16分52秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:   (), 
 *        Company:  
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>

#define  max_num  4096
#define MEM_IOC_MAGIC 'x' //定义类型
#define MEM_IOCSET 			_IOW(MEM_IOC_MAGIC,0,int)
#define MEM_IOCGQSET 	_IOR(MEM_IOC_MAGIC, 1, int)
int main(int argc,char *argv[])
{
    int fd;
    int ret;
    unsigned char *rwc,*rrc;
    unsigned int *map;
    unsigned char ** newmap;
    rwc=malloc(sizeof(unsigned char));
    rrc=malloc(sizeof(unsigned char));
    *rwc=50;
    *rrc=30;
    fd=open("/dev/drvio1",O_RDWR);
    if(fd<0)
    	{
    		perror("open /dev/drvio1\n");
    		return -1;
    	}
    ret=write(fd,rwc,sizeof(rwc));
    ret=read(fd,rrc,sizeof(rrc));
    printf("rwc =%d\nrrc =%d\n",*rwc,*rrc);
    *rwc=10;
    ret=write(fd,rwc,sizeof(rwc));
    ret=read(fd,rrc,sizeof(rrc));
    printf("rwc =%d\nrrc =%d\n",*rwc,*rrc);
    ioctl(fd,MEM_IOCSET,0);
    if((map=(unsigned int *)mmap(NULL,max_num,PROT_READ|PROT_WRITE,MAP_SHARED,fd,0))==MAP_FAILED)
       {
        printf("mmap error!\n");
       }
    memset(map,'c',max_num);
    strcpy((void *)map,"Welcome");
    ioctl(fd,MEM_IOCSET,0);
    munmap(map,4096);
    map=NULL;
    close(fd);
    return 0;
}
