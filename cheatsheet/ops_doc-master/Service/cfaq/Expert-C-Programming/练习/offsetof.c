#include <stdio.h>
#include <stddef.h>

typedef struct{
    int int1;
    double double1;
    char char1;
    double double2;
} Hoge;

int main(void){
    printf("offset of int1 in Hoge: %d\n", offsetof(Hoge, int1));
    printf("offset of double1 in Hoge: %d\n", offsetof(Hoge, double1));
    printf("offset of char1 in Hoge: %d\n", offsetof(Hoge, char1));
    printf("offset of double2 in Hoge: %d\n", offsetof(Hoge, double2));
    return 0;
}

/*
sizeof()后的结果为24，char1后面空出一块来，根据CPU特征，对于不同类型的可配置地址受到一定限制，
编译器会适当进行边界调整(布局对齐)，在结构体内插入合适的填充物，使int,double等被配置在4的
倍数的地址上
*/