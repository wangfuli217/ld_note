#include <stdio.h>
#include <stdlib.h>
#include "headerfile.h"
int complicated2(int input) {
    int tmp = plusfive(input);
    tmp = timestwo(tmp);
    return tmp;
}