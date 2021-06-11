#include <iostream>
#include "MurmurHash3.h"
#include <string.h>
#include <stdio.h>
#include <stdint.h>

using namespace std;

int main() {
    char key[64] = "chenbo";

    uint32_t i_32;
    unsigned long long i_64;

    unsigned __int128 i_128;

    MurmurHash3_x86_32(key, strlen(key), 0, &i_32);

    printf("STR:%u\n", i_32);

    return 0;
}
