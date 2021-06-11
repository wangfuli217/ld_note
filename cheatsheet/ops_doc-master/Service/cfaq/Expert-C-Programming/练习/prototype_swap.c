#include <malloc.h>
#include <string.h>
#include <stdio.h>

void swap(void *vp1, void *vp2, int size){
    char buffer[size];
    /* char* buffer = malloc(size);*/
    memcpy(buffer, vp1, size);
    memcpy(vp1, vp2, size);
    memcpy(vp2, buffer, size);
    /* free(buffer);*/
}

int main(){
    int x=10, y=7;
    swap(&x,&y,sizeof(int));
    printf("%d %d\n", x, y);

    double a = 23.0, b = 34.0;
    swap(&a, &b, sizeof(double));
    printf("%lf %lf", a, b);
    
    char *husband = strdup("Fred");
    char *wife = strdup("Wilma");
    swap(&husband, &wife, sizeof(char*));
    printf("%s %s", husband, wife);
    free(husband);
    free(wife);
}