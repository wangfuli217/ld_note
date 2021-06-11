#include <stdio.h>
#include <string.h>

int digit(char ch){
    if(isdigit(ch)) return ch - 48;
    if(isupper(ch)) return ch - 65 + 10;
    if(islower(ch)) return ch - 97 + 10;
    return 0;
}
int trans(char *in_data, int radix){
    int i, ret = 0, len = strlen(in_data);
    for(i = 0; i < len; i++){
        ret = ret * radix + digit(in_data[i]);
    }
    return ret;
}

int main(){
    printf("from bin: %d\n", trans("1001100",2));
    printf("from oct: %d\n", trans("75765",8));
    printf("from hex: %d\n", trans("B4",16));
    printf("from hex: %d\n", trans("b4",16));
    printf("from den: %d\n", trans("180",10));

    return 0;
}