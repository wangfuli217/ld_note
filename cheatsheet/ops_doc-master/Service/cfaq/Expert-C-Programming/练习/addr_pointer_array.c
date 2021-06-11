#if 0
int main(void){
    char name_array[] = "test"; 
    char *name = "test";
    printf("name address:%#x\n", name_array);          // name address:0xae87e590  第一个元素char*
    printf("name address:%#x\n", &name_array[0]);      // name address:0xae87e590  第一个元素char*
    printf("name address:%#x\n", &name_array);         // name address:0xae87e590  数组的地址 char[5]*
    printf("name address:%#x\n", name_array+1);        // name address:0xae87e591  + sizeof(char)
    printf("name address:%#x\n", &name_array+1);       // name address:0xae87e595  + sizeof(char[5])
    printf("name address:%#d\n", sizeof(name_array));  // name address:5           sizeof(char[5])
    printf("==============\n");
    printf("name address:%#x\n", name);                // name address:0x4008a2    指针变量的值 char*
    printf("name address:%#x\n", &name[0]);            // name address:0x4008a2    所指空间第一个元素的地址
    printf("name address:%#x\n", &name);               // name address:0xae87e588  指针的地址
    printf("name address:%#x\n", name+1);              // name address:0x4008a3    + sizeof(char)
    printf("name address:%#x\n", &name+1);             // name address:0xae87e590  + sizeof(char*)
    printf("name address:%#d\n", sizeof(name));        // name address:8           sizeof(char*)
    return 0;
}

#endif

#if 1
#include <stdio.h>
#include <stdlib.h>

int main(void){
    int a[3][4] = {{1,2,3,4},{5,6,7,8},{9,10,11,12}};
    // int a[3][4] = {1,2,3,4,5,6,7,8,9,10,11,12};  //same as above

    printf("a           = %p\n", a);
    printf("*a          = %p\n", *a);
    printf("**a        = %d\n", **a);

    printf("a[0]        = %p\n", a[0]);
    printf("&a[0][0]    = %p\n", &a[0][0]);
    printf("a[1]        = %p\n", a[1]);
    printf("&a[1][0]    = %p\n", &a[1][0]);

    printf("*(*(a+2)+3) = %d\n", *(*(a+2)+3)); //same as a[2][3]
    return 0;
}
#endif