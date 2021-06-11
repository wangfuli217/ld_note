#include <errno.h>
#include <inttypes.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "massert.h"



#define STRERR_BUFF_SIZE 100

typedef struct errent 
{
    int num;
    const char* str;
} errent;

static pthread_key_t strerrstorage;

static void strerr_storage_free(void *ptr) 
{
    if (ptr!=NULL) {
        free(ptr);
    }
}

static void strerr_storage_init(void) 
{
    zassert(pthread_key_create(&strerrstorage,strerr_storage_free));
    zassert(pthread_setspecific(strerrstorage,NULL));
}

static void* strerr_storage_get(void) 
{
    uint8_t *buff;
    buff = pthread_getspecific(strerrstorage);
    if (buff==NULL) {
        buff = malloc(STRERR_BUFF_SIZE);
        passert(buff);
        zassert(pthread_setspecific(strerrstorage,buff));
    }
    return buff;
}

char* strerr(int error) 
{    
    char *buff = NULL;        
    buff = strerr_storage_get();    
    strerror_r(error, buff, STRERR_BUFF_SIZE);    
    return buff;
}

void strerr_init(void) 
{
    strerr_storage_init();
}

//test
//gcc -o strerr_test strerr.c  -lpthread
//./strerr_test
#if 0
int main(void)
{
    int i = 0;

    for(i=0 ; i< 257; i++)
    {
        printf("%d:%s\n", i, otdr_strerr(i));
    }

    strerr_init();
    for(i=35 ; i< 133; i++)
    {
        printf("%d:%s\n", i, strerr(i));
    }

    return 0;
}
#endif
