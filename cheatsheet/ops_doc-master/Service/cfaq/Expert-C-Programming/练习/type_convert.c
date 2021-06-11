//非负数的转换:多byte转成少byte时，发生 截断(丢失高位)
#include <stdio.h>

int main(void){
    short s = 321; /*00000001 01000001*/
    char ch = s;
    printf("%c", ch);
}

#if 0
//非负数的转换:少byte转成多byte时，原值按位拷贝，高位用0补
#include <stdio.h>

int main(void){
    char ch = 'A'; /*01000001*/
    short s = ch;
    printf("%d", s);
}
#endif

#if 0
// 负数转换:多byte转成少byte时(截位最高位为1时)，情况不确定(window/linux C是 截断，成为 负数 )
#include <stdio.h>

int main(void){
    int i = 98305; /*00000000 00000001 10000000 00000001*/
    short s = i;
    printf("%d", s); /* -32767 */
}
#endif

#if 0
// 负数转换:少byte转成多byte时，原值按位拷贝，高位用1补（可以和上面[非负数的少转多]
//统一描述为不足的高位以符号位补[称为 符号扩展]）short s=-1; int i=s;
#include <stdio.h>

int main(void){
    short s = -1; /*11111111 11111111*/
    int i = s;
    printf("%d", i); /* -1 */
}
#endif

#if 0
//整型与浮点型转换:直接进行赋值，而类型不同，因此会先计算出来值，然后转换一种类型表示出来，底层byte pattern发生变化
#include <stdio.h>

int main(){
    short s = 5;
    float f = s;
    printf("%f", f);
}
#endif

#if 0
// 将内存中byte强制为某类型:总的来说就是 字节拷贝，大小尾系统 没有 区别，因为 地址&总指向 最低 字节

// int i = 98305; short s = *(short*)&i; 保留低位，丢失高位
#include <stdio.h>

int main(){
    int i = 98305; /*00000000 00000001 10000000 00000001*/
    short s = *(short*)&i;
    printf("%x %d %x", s, s, i); /*ffff8001 -32767 18001*/
}
#endif

#if 0
// int i = 1078523331; float f = *(float*)&i; 意义完全不同，变成极小的数(见下节float表示)
#include <stdio.h>

int main(){
    int i = 1078523331; /*01000000 01001000 11110101 11000011*/
    float f = *(float*)&i;
    printf("%f", f); /*3.14*/
}
#endif

#if 0
// 如何得到i = 1078523331
#include <stdio.h>
union ufloat {
    float f;
    int i;
};

int main(){
    union ufloat uf;
    uf.f = 3.14;
    printf("%d", uf.i);
}
// double d = 3.1416; char c = *(char*)&d; 保留1byte低位，其余丢失
#endif

#if 0
#include <stdio.h>

int main(){
    double d = 3.1416;
    char c = *(char*)&d;
    printf("%c", c);
}
// short s = 45; double d = *(double*)&s; 比较危险，越界访问s后面6byte空间
#endif