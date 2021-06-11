#include <stdio.h>

void func(int arg1, int arg2){
    int var3, var4;
    printf("func:&arg1..%p &arg2..%p\n", &arg1, &arg2);
    printf("func:&var3..%p &var4..%p\n", &var3, &var4);
}

int main(void){
    int var1, var2;
    printf("main:&var1..%p &var2..%p\n", &var1, &var2);
    func(1, 2);
    return 0;
}

/*
high       ┌──────────┐
           │          │  main的局部变量 var1
0xbfd243e4 ├──────────┤
           │          │  main的局部变量 var2
0xbfd243e0 ├──────────┤
           │    2     │  func的形参 arg2
0xbfd243dc ├──────────┤
           │    1     │  func的形参 arg1
0xbfd243d8 ├──────────┤
           │          │  返回信息
0xbfd243d4 ├──────────┤
           │          │  返回信息
0xbfd243d0 ├──────────┤
           │          │  func的局部变量 var3
0xbfd243cc ├──────────┤
           │          │  func的局部变量 var4
0xbfd243c8 ├──────────┤
           │    │     │
low             V
在调用方，参数 从后往前 按顺序被堆积在栈中(为了支持可变长参数)
和函数调用关联的 返回信息(返回地址等)也被堆积在栈中
一旦函数调用结束，局部变量占用的内存区域就被释放，并且使用返回信息返回到原来地址
调用方 负责从栈中除去调用的参数
在函数调用时，需要为 形参分配 新的内存区域，"C的参数都是传值，向函数内部传递的是实参的副本"，其复制动作，就在这里发生
*/