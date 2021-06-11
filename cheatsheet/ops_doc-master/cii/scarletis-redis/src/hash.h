#ifndef HASH_H
#define HASH_H

#include <stdlib.h>

unsigned int dictIntHashFunction(unsigned int key);

void dictSetHashFunctionSeed(uint32_t seed);

uint32_t dictGetHashFunctionSeed(void);

unsigned int dictGenHashFunction(const void *key, int len);

unsigned int dictGenCaseHashFunction(const unsigned char *buf, int len);

#endif
