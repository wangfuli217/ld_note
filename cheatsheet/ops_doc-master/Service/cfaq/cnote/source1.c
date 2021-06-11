#include <stdio.h>
#include <stdlib.h>
#include "headerfile.h"
int complicated1(int input) {
    int tmp = timestwo(input);
    tmp = plusfive(tmp);
    return tmp;
}