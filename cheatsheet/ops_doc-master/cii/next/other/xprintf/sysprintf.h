#ifndef _SYSPRINTF_H
#define _SYSPRINTF_H
#include "xprintf.h"


void  __xstd_printf(int level, const char * fmt,...);
int __xstd_dump(int level,const char *sczTitle,const void *pciBuf,int nSize);

int strcmp_ex(char const*s1,char const *s2);

#define USER_DEBUG  1
#if USER_DEBUG
//For user debug
//#include "xprintf.h"
#define PRINTF(...) xprintf(__VA_ARGS__)
//#define XPRINTF(...) xprintf(__VA_ARGS__)

#define XPRINTF(__arvs__) __xstd_printf  __arvs__

//#define PRINTF(__arvs__) __xstd_printf __arvs__

#define MEM_DUMP(level,sczTitle,pBuf,nSize) __xstd_dump(level,sczTitle,pBuf,nSize)

#define PRINT6ADDR_U(addr) PRINTF(" %02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x:%02x%02x ", ((uint8_t *)addr)[0], ((uint8_t *)addr)[1], ((uint8_t *)addr)[2], ((uint8_t *)addr)[3], ((uint8_t *)addr)[4], ((uint8_t *)addr)[5], ((uint8_t *)addr)[6], ((uint8_t *)addr)[7], ((uint8_t *)addr)[8], ((uint8_t *)addr)[9], ((uint8_t *)addr)[10], ((uint8_t *)addr)[11], ((uint8_t *)addr)[12], ((uint8_t *)addr)[13], ((uint8_t *)addr)[14], ((uint8_t *)addr)[15])
#define PRINTLLADDR_U(lladdr) PRINTF(" %02x:%02x:%02x:%02x:%02x:%02x ",(lladdr)->addr[0], (lladdr)->addr[1], (lladdr)->addr[2], (lladdr)->addr[3],(lladdr)->addr[4], (lladdr)->addr[5])

#else
#define PRINTF(...)
#define XPRINTF(...)
#define MEM_DUMP(...)
#define PRINT6ADDR_U(addr)
#define PRINTLLADDR_U(addr)
#endif





#endif








