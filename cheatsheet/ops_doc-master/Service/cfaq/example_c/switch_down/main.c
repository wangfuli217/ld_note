#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <stdint.h>

#define __BEGIN do {                                                \
    struct timeval tv;                                              \
    uint64_t t;                                                     \
    gettimeofday(&tv, NULL);                                        \
    t = tv.tv_sec * 1000000 + tv.tv_usec;                           \                                                                
    printf("begin: %llu\n", t);                                     \
} while (0)
    
#define __END do {                                                  \
    struct timeval tv;                                              \
    uint64_t t;                                                     \
    gettimeofday(&tv, NULL);                                        \
    t = tv.tv_sec * 1000000 + tv.tv_usec;                           \ 
    printf("end: %llu\n", t);         \
} while (0)

static int
copy_to(char* to, const char* from, unsigned int len)
{
    unsigned int count;
    
    count = len;
    do {
        *to++=*from++;
    } while (--count);
    
    return len;
}

static int
copy_to_line(char* to, const char* from, unsigned int len)
{
    unsigned int i;
    
    i = (len + 7) / 8;
    switch(len % 8) {
        case 0: do { *to++ = *from++;
        case 7: *to++ = *from++;
        case 6: *to++ = *from++;
        case 5: *to++ = *from++;
        case 4: *to++ = *from++;
        case 3: *to++ = *from++;
        case 2: *to++ = *from++;
        case 1: *to++ = *from++;
                } while (--i);
    }
    
    return 0;
}


int main(int argc, char **argv)
{
	char* from;
    char* to;
    
    from = (char*)malloc(10 * 1024 * 1024);
    to = (char*)malloc(10 * 1024 * 1024);
    memset(from, 1, 1024 * 1024);
    
    __BEGIN;
    copy_to(to, from, 1024 * 1024);
    __END;
 
    __BEGIN;
    copy_to_line(to, from, 1024 * 1024);
    __END;
   
    system("pause");
	return 0;
}
