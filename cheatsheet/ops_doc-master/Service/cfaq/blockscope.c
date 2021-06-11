#include <stdio.h>

#if 0
int main(void){
    int a = 2,b = 1;
    if(a > b){
        int temp = a;
        a = b;
        b = temp;
    }
    printf("a = %d, b = %d\n",a,b);
    return 0;
}
#endif

#if 0
// error: 'temp' undeclared (first use in this function) 
int main(void){
    int a = 2,b = 1;
    if(a > b){
        int temp = a;
        a = b;
        b = temp;
    }
    printf("temp = %d\n",temp);
    printf("a = %d, b = %d\n",a,b);
    return 0;
}
#endif