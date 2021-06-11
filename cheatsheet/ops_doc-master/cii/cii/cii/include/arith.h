#ifndef ARITH_INCLUDE
#define ARITH_INCLUDE

extern int arith_max(int x, int y); // 整数参数的最小值和最大值
extern int arith_min(int x, int y);
// x/y
// x%y
// 当两个操作数符号不同时，由C语言内建运算符所得出的返回值取决于具体编译器的实现。
// 当一个操作数为负数时，这种语义使得整数除法可以向零舍入，也可以向负无穷大舍入。
// -13/5 = -2 则，-13%5 -> -13-(-13/5)*5 = -13-(-2)*5 = -3
// -13/5 = -3 则，-13%5 -> -13-(-3)*5 = 2
extern int arith_div(int x, int y); // x除以y获得的商
extern int arith_mod(int x, int y); // x除以y获得的余数
extern int arith_ceiling(int x, int y); // 
extern int arith_floor(int x, int y);

#endif /*ARITH_INCLUDE*/
