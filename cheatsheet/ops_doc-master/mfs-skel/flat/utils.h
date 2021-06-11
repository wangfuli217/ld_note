#ifndef _UTILS_H_
#define _UTILS_H_

#include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

#define min(x, y) ({ \
                    typeof(x) _x = (x); \
                    typeof(y) _y = (y); \
                    (void) (&_x == &_y);    \
                    _x < _y ? _x : _y; })

#define max(x, y) ({ \
                    typeof(x) _x = (x); \
                    typeof(y) _y = (y); \
                    (void) (&_x == &_y);    \
                    _x > _y ? _x : _y; })

#define likely(x)       __builtin_expect(!!(x), 1)
#define unlikely(x)     __builtin_expect(!!(x), 0)


#define WATCHDOG_ERR_COUNT_TRIGER 10    /* error count trigger feeddog stop */
#define WATCHDOG_ERR_COUNT_EDGE 5       /* feeddog error  */

#define WATCHDOG_ERR_MOD_TRIGER 2    /* error module trigger feeddog stop */

void parse(int *parc, char *parv[], char *src,int maxpar);
void parseex(int *parc,char *parv[],char *src,int maxpar,char separator);
void ascs2hex(uint8_t *hex,uint8_t *ascs,int srclen);
void str2hex(uint8_t *hex, int *len, char *str);
void hex2str(char *str, uint8_t *hex,int len);
ssize_t xwrite(int fd, const void *buf, size_t count);
int setnonblock(int fd);
FILE* fopen_for_read(const char *path);
void disablewatchdog(void);
void enablewatchdog(int period);


#endif
