#include <stdio.h>
#include <stdlib.h>

int main(){
    int a, i;
    srand(time(NULL));
    for(i = 0; i < 5; i++){
        a = rand() % 51 + 50;
        printf("%d\n", a);
    }
    return 0;
}