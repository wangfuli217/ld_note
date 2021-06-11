#include<stdio.h>
#include <unistd.h>
#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>

#define PT_OFFSET 446
#define PT_LEN 16
#define PT_N 4
#define CHECK_POS 510
//Cylinder-Head-Sectoradderess type
typedef struct
{
        unsigned char head:8;
        unsigned char sector:6;
        unsigned short cylinder:10;
} CHS;

void printPT(char *buf);

int main(int argc, char *argv[])
{
        int fd = open(argv[1], O_RDONLY);

        if(fd < 0)
        {
                perror("open");
                exit(1);
        }

        if(lseek(fd,CHECK_POS,SEEK_SET) == -1)
        {
                fprintf(stderr,"lseek to CHECK_POS err %m\n");
                close(fd);
                return -1;
        }
        unsigned char checkbuf[16] = {0};
        if(read(fd,checkbuf,2) != 2)
        {
                fprintf(stderr,"read check info failed %m\n");
                close(fd);
                return -2;
        }

        if(checkbuf[0] != 0x55 || checkbuf[1] != 0xaa)
        {
                fprintf(stderr, "not valid mbr format\n");
                close(fd);
                return -3;
        }
        if(lseek(fd, PT_OFFSET, SEEK_SET) ==-1)
        {
                close(fd);
                perror("lseek");
                exit(1);
        }

        char buf[PT_LEN];
        int i;

        for(i = 0; i < PT_N; i++)
        {
                bzero(buf, PT_LEN);
                if(read(fd, buf, PT_LEN) !=PT_LEN)
                {
                        printf("can't getfull partition table[%d]\n", i);
                        close(fd);
                        exit(1);
                }

                if(buf[1] || buf[2] || buf[3])
                        printPT(buf);
        }

        close(fd);
        return 0;
}

void printPT(char *buf)
{
        switch((unsigned char)buf[0])
        {
                case 0x80:
                        printf("bootable\n");
                        break;
                case 0x00:
                        printf("non-bootable\n");
                        break;
                default:
                        printf("invalid\n");
        }

        CHS chs;
        memcpy(&chs, buf+1, 3);
        printf("from CHSAddr: \n");
        printf("%12s%12s%12s\n","head","sector","cylinder");
        printf("%12d%12d%12d\n",chs.head,chs.sector,chs.cylinder);
        memcpy(&chs, buf+5, 3);

        printf("to CHSAddr: \n");
        printf("%12s%12s%12s\n","head","sector","cylinder");
        printf("%12d%12d%12d\n",chs.head,chs.sector,chs.cylinder);

        printf("partition type:%d\n",(unsigned char)buf[4]);
        printf("LENGTH:%d(sectors)\n\n", *(unsigned int*)&buf[12]);
}