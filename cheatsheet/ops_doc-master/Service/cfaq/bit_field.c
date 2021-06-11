/**
1.位域结构体
结构体中的冒号表示位域。
位域出现的原因是由于某些信息的存储表示只需要几个bit位就可以表示而不需要一个完整的字节，同时也是为了节省存储空间和方便处理。
其表示形式为：
struct 位域结构名
{
    类型说明符  位域名：位域长度
}

例如：
struct  bit_struct
{
    int  bit1:3;
    int  bit2:5;
    int  bit3:7;
}data;
其中bit_struct表示位域结构体，bit1、bit2、bit3表示对应的位域，data表示位域结构体定义的变量。
整个位域结构体占用2个字节，bit1占3位，bit2占5位，bit1和bit2共用一个字节，bit3占7位，独占一个字节。
2.规则说明
    位域必须存储在同一个类型中，不能跨类型，同时也说明位域的长度不会超过所定义类型的长度。
如果一个定义类型单元里所剩空间无法存放下一个域，则下一个域应该从下一单元开始存放。
例如：所定义的类型是int类型，一共32为，目前用掉了25位还剩下7位，这时要存储一个8位的位域元素，
那么这个元素就只能从下一个int类型的单元开始而不会在前面一个int类型中占7为后面的int类型中占1位。
    如果位域的位域长度为0表示是个空域，同时下一个域应当从下一个字节单元开始存放。
    使用无名的位域来作为填充和调整位置，切记该位域是不能被使用的。
    位域的本质上就是一种结构体类型，不同的是其成员是按二进制位来分配的。
*/

/***********************************************************
 * Function         :  验证位域
 * Result           :  a = 1, b = -2, c = 3, d = -2, e = -4
 *                     a = 3, b = 0, c = 7, d = -1, e = -3
 * Result Analysis  : 之所以出现负数的原因是由于int型默认是有符号型的，所以两位的位域赋值2时就会溢出，
 *                    成为10，高位是表示符号，1表示负号。10取反加1之后就是10，也就是2，所以值是-2
 * Create Data      : 2015-12-16
 * Author           : ***
 * Others           : 
 * Modified Data    :
 * Modifier         :
 * Modify Reason    :
 * *******************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct bit_st
{
    int a:3; // 第一个字节的0~2位
    int  :0; // 这里是说明的第二点，空域。下一个位域b将会从下一个字节开始，位3~7为全0。
    
    int b:2; // 下一个字节也就是第二个字节的0~1位
    int c:5; // 第二个字节紧接b之后的2~6位
    int d:2; // 这里是说明的第一点，d占用第三个字节的0~1位，因为前面一个字节只剩下一位不能存放d，所以另起一个字节存放。
    int  :2; // 这里说明的是第三点，d域后的两个位2~3不能使用。
    int e:3; // 存放在第三个字节的第4~6位
} data, *pData;


int main()
{       
    data.a = 1;
    data.b = 2; // 注意此处b只占2位，所以取值范围为-2~1，超过-2或者1就出现错误，所以赋值时注意位域的范围
    data.c = 3; 
    data.d = 2; 
    data.e = 4;

    printf("a = %d, b = %d, c = %d, d = %d, e = %d\r\n",
        data.a, data.b, data.c, data.d, data.e); // 结构体操作

    pData = &data;
    pData->a = 3;
    pData->b &= 1;
    pData->c |= 5;
    pData->d ^= 1;
     pData->e = 5;

    printf("a = %d, b = %d, c = %d, d = %d, e = %d\r\n",
           pData->a, pData->b, pData->c, pData->d, pData->e); // 结构体指针操作
    printf("sizeof data=%d\n", sizeof(data));
    
     return 0;
}
