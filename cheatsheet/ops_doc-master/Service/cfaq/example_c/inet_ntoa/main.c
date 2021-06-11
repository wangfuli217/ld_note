#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

static unsigned int
__ntohul(unsigned int u)
{
	unsigned int temp = u;
	
	char* p1 = &temp;
	char* p = &u;
	
	p1[0] = p[3];
	p1[1] = p[2];
	p1[2] = p[1];
	p1[3] = p[0];
	
	return *((int*)p1);
}

#define __htohul(u) __ntohul(u)

static char*
inet_ntoa(unsigned int ip) /* ---> host byte order */
{
	static char addr[16];
	
	ip = __ntohul(ip);
	
	//printf("ip: %X\n", ip);
	
	char* p = (char*)&ip;
#ifndef UC
#define UC(b) (((int)(b)) & 0xff)
#endif
	snprintf(addr, 16, "%d.%d.%d.%d", UC(p[3]), UC(p[2]), UC(p[1]), UC(p[0]));
	
	return addr;
}

static uint32_t
inet_aton(const char* ip) /* 转换成net byte order */
{
	uint32_t i[4] = {0};
	uint32_t r = 0;	
	
	sscanf(ip, "%u.%u.%u.%u", &i[0], &i[1], &i[2], &i[3]); /* 192.168.100.154 */
	
	r =  (i[3] << 24) | (i[2] << 16) | (i[1] << 8) | i[0]; /* 154.100.168.192 --> 0x9a64a8c0 */

	return r;
}

int 
main(int argc, char **argv)
{
	char* ip = inet_ntoa(0x9a64a8c0); /* 192.168.100.154 net byte order*/
	
	printf("ip: %s\n", ip);
	
	printf("ip: 0x%x\n", inet_aton(ip));
	
	ip = inet_ntoa(0x87654321);
	
	printf("ip: %s\n", ip);
	
	printf("ipn: %x\n", inet_aton("1.2.3.4"));
	
	system("pause");
	
	return 0;
}
