#include <stdlib.h>
#include "util.h"
uint64_t bkdr_hash(const char* str){
    if(NULL == str){
        return 0;
    }
    uint64_t seed = 1313131313;
    uint64_t hash = 0;
    while(*str){
        hash = hash * seed + (*str++);
    }
    return hash;
}

void pack_string(conn *c, const char *str) {
    int len;

    len = strlen(str);
    if (len + 2 > c->wsize) {
        /* ought to be always enough. just fail for simplicity */
        str = "SERVER_ERROR output line too long";
        len = strlen(str);
    }

    strcpy(c->wbuf, str);
    strcat(c->wbuf, "\r\n");
    c->wbytes = len + 2;

    return;
}

void out_string(conn *c, const char *str) {
    pack_string(c, str);
    c->wcurr = c->wbuf;
    c->state = conn_write;
    c->write_and_go = conn_read;
    return;
}

static int isprime(int m) {
    if (m < 1)
        return 0;
    int i;
    for (i = 2; i < m; i++) {
        if (m % i == 0) {
            return 0;
        }
    }
    return 1;
}

int bigger_prime(int m){
    int i;
    for(i= m; ; i++){
        if(isprime(i)){
            return i;
        }
    }
}
