#ifndef _CLOCKS_H_
#define _CLOCKS_H_

#include <inttypes.h>

double monotonic_seconds();
uint64_t monotonic_useconds();
uint64_t monotonic_nseconds();
const char* monotonic_method();
uint32_t monotonic_speed();

#endif
