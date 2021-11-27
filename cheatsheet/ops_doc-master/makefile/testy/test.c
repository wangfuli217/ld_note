#include <stdio.h>
#include <stdlib.h>
#include "bar.h"
#include "foo.h"

int main(int argc, char *argv[]){
    printf("hello main\n");
    bar();
    foo();
}