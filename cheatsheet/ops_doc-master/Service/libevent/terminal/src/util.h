#ifndef UTIL_H
#define UTIL_H
#include <stdlib.h>
#include <stdint.h>
#include "terminal_define.h"
uint64_t bkdr_hash(const char* str);

void pack_string(conn *c, const char *str);

void out_string(conn *c, const char *str);

int bigger_prime(int m);
#endif //UTIL_H
