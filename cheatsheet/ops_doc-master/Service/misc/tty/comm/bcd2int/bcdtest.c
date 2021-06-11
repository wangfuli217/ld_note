/*************************************************************************
	> File Name: bcdtest.c
	> Author: suchao.wang
	> Mail: suchao.wang@advantech.com.cn 
	> Created Time: Tue 16 May 2017 06:47:27 PM CST
 ************************************************************************/

#include<stdio.h>
#include <ctype.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>

void showhex(uint8_t *buf,int len)
{
	int i=0;
	for(i =0;i<len;i++)
	{
		printf("%02x ",buf[i]);
	}
	printf("\n");
	for(i =0;i<len;i++)
	{
		printf("%d ",buf[i]);
	}
	printf("\n");

}
static inline uint8_t bcd2bin(uint8_t val)
{
	return (val & 0x0f) + (val >> 4) * 10;
}

//二进制转为BCD码
static inline uint8_t bin2bcd(uint8_t val)
{
	return ((val / 10) << 4) + val % 10;
}

int bin2bcds(uint8_t val_bin[],uint8_t val_bcd[],int len)
{
	int i,j =(len+1)/2;
	for(i =0;i<j;i++)
	{
		val_bcd[i*3] = bin2bcd(val_bin[i*2]/10);
		val_bcd[i*3+1] =  (bin2bcd(val_bin[i*2]%10)<<4)+(bin2bcd(val_bin[i*2+1]/100));
		val_bcd[i*3+2] =  bin2bcd(val_bin[i*2+1]%100);
	}
}

int bcd2bins(uint8_t val_bcd[],uint8_t val_bin[],int len)
{
	int i,j =(len+2)/3;
	for(i =0;i<j;i++)
	{
		val_bin[i*2] = (bcd2bin(val_bcd[i*3])*10) + ((val_bcd[i*3+1]>>4)&0xf);
		val_bin[i*2+1] = ((val_bcd[i*3+1]&0xf) * 100) + (bcd2bin(val_bcd[i*3+2]));
	}
}


int main()
{
	char dst[6];
	uint32_t addr;
	char *ip="192.168.1.56";
	addr = inet_addr(ip);
	printf("%x\n",addr); //3801a8c0
	showhex((char *)&addr,sizeof(addr));
	bin2bcds((char *)&addr,dst,sizeof(addr));
	showhex((char *)dst,sizeof(dst));

	uint32_t addrr = 0;
	bcd2bins(dst,(char *)&addrr,sizeof(dst));
	showhex((char *)&addrr,sizeof(addrr));
	printf("%s\n",inet_ntoa(*(struct in_addr*)&addrr));
}
