#include <stdio.h>
#include <stdlib.h>

int main(void){
    int rows = 2, cols = 4;
    int **pp = NULL;
    pp = malloc(sizeof(int*) * rows);
    printf("pp: %p\n", pp);
    int i, j;
    for(i = 0; i < rows; i++){
        // *(pp+i) = malloc(sizeof(int) * cols);
        pp[i] = malloc(sizeof(int) * cols);
        printf("pp[%d]: %p\n",i, pp[i]);
        for(j = 0; j < cols; j++){
            *(*(pp+i)+j) = i * 10 + j;
            printf("pp[%d][%d]: %2d\n", i, j, pp[i][j]);
        }
    }

    for(i = 0; i < rows; i++) free(*(pp+i));
    free(pp);

    return 0;
}