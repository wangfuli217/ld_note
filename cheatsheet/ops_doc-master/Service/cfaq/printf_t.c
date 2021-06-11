/*
                                            输出宽度和对齐方向     仅限于小数数值类型
key(现代方法 -> 格式输出 printf){ -%m.pX   m:最小字段宽度(整数常量) p:精度(整数常量)    X:转换说明符(字母)
一般地，转换说明可以用%m.pX格式或%-m.pX格式，其中m和p都是整数常量，X是字母。m和p都是可选的，
        如果省略p，则m和p之间的小数点也需要去掉。
    最小字段宽度(minimum field width) m指定了要显示的最少字符数量。
      1. 如果要显示的数值所需的字符数小于m，那么值在字段内是右对齐的；
      2. 如果字符数多于m，那么字段宽度会自动扩展。
      3. 在m前面放上一个负号会导致左对齐。
    精度 (precision) p的含义依赖于转换说明符(conversion specifier)**X**的选择:
      d -- 指定小数点后应该出现的数字的个数
           (如果不足则会添加前导0)；
           如果省略p，则默认为1。
      e -- 指定小数点后数字个数(默认值为6，会添加尾随0)；
           如果p为0则不显示小数点。
      f -- 同e。
      g -- 指定小数点后有效数字的最大数量(不会添加尾随0)；
           如果数值没有小数点后的数字，则不会显示小数点。

printf函数族的转换说明符由字符%和跟随其后的最多5个不同的选项构成：
    1.标志(可选项，可多选)
        -：在字段内左对齐(默认右对齐)
        +：有符号数总是以+或-开头(默认只有负数以-开头)
        ： 有符号数非负数值前加空格(选项会被+选项覆盖)
        #：以0开关的八进制数，以0x或0X开关的十六进制非零数。浮点数始终有小数点。不能删除由g或G转换输出的尾部零
        0：用前导零在数的字段宽度内进行填充。
           如果转换说明是d、i、o、u、x或X，而且指定了精度，那么可以忽略这个选项(此选项会被-选项覆盖)
    2.最小字段宽度(可选项)
    3.精度(可选项)
    4.长度修饰符(可选项)
        h、L
        C99新增：hh、ll、j、z、t
    5.转换说明符(必选项)
        d、i、o、u、x、X、f、e、E、g、G、c、s、p、n
        C99新增：F、a、A

%c：ASCII字符，如果参数给出字符串，则打印第一个字符 
%d：10进制整数 
%i：同%d 
%e：浮点格式（[-]d.精度[+-]dd） 
%E：浮点格式（[-]d.精度E[+-]dd） 
%f：浮点格式（[-]ddd.precision） 
%g：%e或者%f的转换，如果后尾为0，则删除它们 
%G：%E或者%f的转换，如果后尾为0，则删除它们 
%o：8进制 
%s：字符串 
%u：非零正整数 
%x：十六进制 
%X：非零正数，16进制，使用A-F表示10-15 
%%：表示字符"%"

%[flags][min field width][precision][length]conversion specifier
  -----  ---------------  ---------  ------ -------------------
   \             #,*        .#, .*     /             \
    \                                 /               \
   #,0,-,+, ,',I                 hh,h,l,ll,j,z,L    c,d,u,x,X,e,f,g,s,p,%
   -------------                 ---------------    -----------------------
   # | Alternate,                 hh | char,           c | unsigned char,
   0 | zero pad,                   h | short,          d | signed int,
   - | left align,                 l | long,           u | unsigned int,
   + | explicit + - sign,         ll | long long,      x | unsigned hex int,
     | space for + sign,           j | [u]intmax_t,    X | unsigned HEX int,
   ' | locale thousands grouping,  z | size_t,         e | [-]d.ddde±dd double,
   I | Use locale's alt digits     t | ptrdiff_t,      E | [-]d.dddE±dd double,
                                   L | long double,  ---------=====
   if no precision   => 6 decimal places            /  f | [-]d.ddd double,
   if precision = 0  => 0 decimal places      _____/   g | e|f as appropriate,
   if precision = #  => # decimal places               G | E|F as appropriate,
   if flag = #       => always show decimal point      s | string,
                                             ..............------
                                            /          p | pointer,
   if precision      => max field width    /           % | %
*/

#include <stdio.h>
#include <limits.h>
#include <locale.h>
#include <wchar.h>
#include <inttypes.h>

// Ff
#define TEST_F 
// Ff
#define TEST_BONUS 
// undefined
#define UNDEFINED 
// 
#define TEST
// LETTRE
#define TEST_C
// STRING 
#define TEST_S
// POINTEUR 
#define TEST_P
// HEXADECIMAL 
#define TEST_X
// OCTAL 
#define TEST_O
// UNSIGNED DECIMAL
#define TEST_U
// POURCENTAGE 
#define TEST_POUR
// SIGNED DECIMAL
#define TEST_D
// UNICODE STRING
#define TEST_WS
// UNICODE LETTRE
#define TEST_WC

int main(void){

#ifdef TEST_F
	printf("\033[1;41m|----------------------------| (Lancement du test f en cours...) |----------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%f||%F|", 1.42, 1.42));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%f||%F|", -1.42, -1.42));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%f||%F|", 1444565444646.6465424242242, 1444565444646.6465424242242));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%f||%F|", -1444565444646.6465424242242454654, -1444565444646.6465424242242454654));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%f||%F|", 0.0, 0.0));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|% f||% F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%+f||%+F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%-5f||%-5F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%25.5f||%25.5F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%-25.5f||%-25.5F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%#f||%#F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%05f||%05F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%025f||%025F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%+025f||%+025F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%0.10f||%0.10F|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%hhf||%hhF|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%hf||%hF|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%lf||%lF|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%llf||%llF|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%jf||%jF|", 42424242.4242424242424242, 424242424242.424242424242));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%zf||%zF|", 42424242.4242424242424242, 424242424242.424242424242));
#endif

#ifdef TEST_BONUS
	printf("\033[1;41m|----------------------------| (Lancement du test * en cours...) |----------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%*d|", 5, 42));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%*d|", -5, 42));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%*d|", 0, 42));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%*c|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%*c|", -15, 0));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%.*d|", 5, 42));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%.*d|", -5, 42));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%.*d|", 0, 42));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%.*s|", 5, "42"));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%.*s|", -5, "42"));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%.*s|", 0, "42"));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%*s|", 5, 0));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%3*p|", 10, 0));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%*.*d|", 0, 3, 0));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%3*d|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%*3d|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%*3d|", 5, 0));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%05.*d|", -15, 42));

#endif
#ifdef UNDEFINED
	printf("\033[1;41m|----------------------------| (Lancement du test bullshit en cours...) |----------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%|"));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|% |"));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|% h|"));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%h|"));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%Z|"));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|% hZ|"));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|% hZ%|"));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|% Z|", "test"));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|% Z |", "test"));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|% Z%s|", "test"));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%%%|", "test"));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%%   %|", "test"));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%ll#x|", 9223372036854775807));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%010s is a string|", "this"));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%05c|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|% Z|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%5+d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%5+d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%-5+d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%-5+d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%zhd|", "4294967296"));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%jzd|", "9223372036854775807"));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%jhd|", "9223372036854775807"));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%lhl|", "9223372036854775807"));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%lhlz|", "9223372036854775807"));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%zj|", "9223372036854775807"));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%lhh|", "2147483647"));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%hhld|", "128"));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m@main_ftprintf: |%####000033..1..#00d|", 256));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m@main_ftprintf: |%####000033..1d|", 256));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m@main_ftprintf: |%###-#000033...12..#0+0d|", 256));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m@main_ftprintf: |%33d|", 256));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m@main_ftprintf: |%+33d|", 256));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m@main_ftprintf: |%-+33d|", 256));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m@main_ftprintf: |%-+33.d|", 256));

#endif
#ifdef TEST

	static int	i = 42;

	printf("\n\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|s: %s, p: %p, d:%d|", "a string", &i, 42));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%10RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%#10RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%010RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%+10RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%-10RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%#10.5RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%010.5RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%+10.5RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%-10.5RR|"));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m@moulitest: |%#.1x %#.10x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m@moulitest: |%#.x %#.0x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m@moulitest: |%.x %.0x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m@moulitest: |%5.x %5.0x|", 0, 0));

#endif
#ifdef TEST_C
	printf("\033[1;41m|-------------------------| (Lancement du test LETTRE en cours...) |-------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%05.c|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%05.c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%hhc|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%hc|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%llc|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%jc|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%zc|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%+c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%#c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%-c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%15c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%-15c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%.2c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|% c|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%c|", "coucou"));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%05.c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%015c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%-015c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%-0c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%.12c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%.0c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%-12.3c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%-3.1c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%12.1c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%3.1c|", '4'));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%-c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%3c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%-3c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%.2c|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%5.5c|", "N"));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%7.5c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|%.5c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m|%.15c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 36 => \033[0m|%15c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 37 => \033[0m|%5c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 38 => \033[0m|%-5.5c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 39 => \033[0m|%-15.5c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 40 => \033[0m|%-.5c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 41 => \033[0m|%-15c|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 42 => \033[0m|%c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 43 => \033[0m|%-c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 44 => \033[0m|%5.5c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 45 => \033[0m|%15.5c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 46 => \033[0m|%.5c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 47 => \033[0m|%15c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 48 => \033[0m|%-5.5c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 49 => \033[0m|%-15.5c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 50 => \033[0m|%-.5c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 51 => \033[0m|%-15c|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 52 => \033[0m|%15c|", "bonjour"));

#endif
#ifdef TEST_S

	printf("\033[1;41m|-------------------------| (Lancement du test STRING en cours...) |-------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%05.s|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%05.s|", "42"));
	printf("{%d}\n", printf("\033[1;32mTest 2b => \033[0m|%05.2s|", "42"));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%hhs|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%hs|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%lls|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%js|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%zs|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|% s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%+s|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%#s|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%#s|", "hola"));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%-s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%5.5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%15.5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%.5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 17b => \033[0m|%.15s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%15s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 18b => \033[0m|%5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%-5.5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%-15.5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%-.5s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%-15s|", "Number 42"));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%-s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%5.5s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%15.5s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%.5s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%15s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%-5.5s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%-15.5s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%-.5s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%-15s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%s|", "coucou"));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|%05.s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 34b => \033[0m|%5.s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m|%015s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 36 => \033[0m|%-015s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 37 => \033[0m|%-0s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 38 => \033[0m|%.12s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 39 => \033[0m|%.0s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 40 => \033[0m|%-12.1s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 41 => \033[0m|%-3.2s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 42 => \033[0m|%12.1s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 43 => \033[0m|%3.2s|", "salut"));
	printf("{%d}\n", printf("\033[1;32mTest 44 => \033[0m|%-s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 45 => \033[0m|%3s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 46 => \033[0m|%-3s|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 47 => \033[0m|%.2s|", "salut"));

#endif
#ifdef TEST_P

	printf("\033[1;41m|-----------------------| (Lancement du test POINTEUR en cours...) |-----------------------|\033[0m\n");
	i = 42;
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 0 => \033[0m|%5p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%05p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%9.2p|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%#9.2p|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%.0p|, |%.p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%.1p|, |%.2p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%.3p|, |%.5p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%10.5p|, |%5.10p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%-10.5p|, |%-5.10p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 7b => \033[0m|%10.5p|, |%5.10p|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 8b => \033[0m|%-10.5p|, |%-5.10p|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%p|", &i));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%-5p|", &i));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%lp|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%5p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%.0p|, |%.p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%.1p|, |%.2p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%.3p|, |%.5p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%10.5p|, |%10.5p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%-10.5p|, |%-10.5p|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%p|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%-5p|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%5p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%#05p|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%#05p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%#5p|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%#-5p|", 0));

#endif
#ifdef TEST_X

	printf("\033[1;41m|-----------------------| (Lancement du test HEXADECIMAL en cours...) |-----------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%+x|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|% x|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%x|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%hhx|", (unsigned char)42));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%hx|", (unsigned short)42));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%lx|", (unsigned long)42));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%llx|", (unsigned long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%jx|", (uintmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%zx|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%X|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%hhX|", (unsigned char)42));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%hX|", (unsigned short)42));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%lX|", (unsigned long)42));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%llX|", (unsigned long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%jX|", (uintmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%zX|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%#12x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%#2x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%#5X|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%#2X|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%-5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%6.9x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%-9.5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%#-9.5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%#9.5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%#-9.5x|", 2));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%#9.5x|", 2));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%-9.1x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%05x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%0.5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%.5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%09.5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%09.3x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|%09.2x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m|%#-9.5x|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 36 => \033[0m|%#.x, %#.0x|", 0, 42));
	printf("{%d}\n", printf("\033[1;32mTest 37 => \033[0m|%.x, %.2x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 38 => \033[0m|%.x, %.0x|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 39 => \033[0m|%.x, %.2x|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 40 => \033[0m|%.x, %.2x, %x|", 0, -02, 02));
	printf("{%d}\n", printf("\033[1;32mTest 41 => \033[0m|%05x|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 42 => \033[0m|%9.2x|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 43 => \033[0m|%#9.2x|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 44 => \033[0m|%.0x|, |%.x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 45 => \033[0m|%.1x|, |%.1x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 46 => \033[0m|%.5x|, |%.5x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 47 => \033[0m|%10.5x|, |%10.5x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 48 => \033[0m|%-10.5x|, |%-10.5x|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 49 => \033[0m|%x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 50 => \033[0m|%-5x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 51 => \033[0m|%x|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 52 => \033[0m|%5x|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 53 => \033[0m|%#05x|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 54 => \033[0m|%#05x|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 55 => \033[0m|%#5x|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 56 => \033[0m|%-#5x|", 0));

#endif
#ifdef TEST_O

	printf("\033[1;41m|-----------------------| (Lancement du test OCTAL en cours...) |-----------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|% o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%+o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%#o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%#.o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%#.o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%o|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%hho|", (unsigned char)42));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%ho|", (unsigned short)42));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%lo|", (unsigned long)42));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%llo|", (unsigned long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%jo|", (uintmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%zo|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%O|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%hhO|", (unsigned char)42));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%hO|", (unsigned short)42));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%lO|", (unsigned long)42));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%llO|", (unsigned long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%jO|", (uintmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%zO|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%#5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 20b => \033[0m|%#8o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%-5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%6.9o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%-9.5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%#-9.5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%-9.1o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%05o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%0.5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%.5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%09.5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%09.3o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%09.2o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%o|", -1));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%#9.o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|%.o, %.0o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m|%.o, %.2o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 36 => \033[0m|%.o, %.0o|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 37 => \033[0m|%.o, %.2o|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 38 => \033[0m|%.o, %.0o|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 39 => \033[0m|%.o, %.2o|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 40 => \033[0m|%.o, %.2o, %o|", 0, -02, 02));
	printf("{%d}\n", printf("\033[1;32mTest 41 => \033[0m|%05o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 42 => \033[0m|%9.2o|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 43 => \033[0m|%#9.2o|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 44 => \033[0m|%.0o|, |%.o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 45 => \033[0m|%.1o|, |%.1o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 46 => \033[0m|%.5o|, |%.5o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 47 => \033[0m|%10.5o|, |%10.5o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 48 => \033[0m|%-10.5o|, |%-10.5o|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 49 => \033[0m|%o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 50 => \033[0m|%-5o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 51 => \033[0m|%o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 52 => \033[0m|%5o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 53 => \033[0m|%#05o|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 54 => \033[0m|%#05o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 55 => \033[0m|%#5o|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 56 => \033[0m|%-#5o|", 0));

#endif
#ifdef TEST_U

	printf("\033[1;41m|-----------------------| (Lancement du test UNSIGNED DECIMAL en cours...) |-----------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%.u, %.0u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%.u, %.0u|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%#u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%hu|", (unsigned short)42));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%hhu|", (unsigned char)42));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%lu|", (unsigned long)42));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%llu|", (unsigned long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%ju|", (uintmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%zu|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%0u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%05.2u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%-9u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%U|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%hU|", (unsigned short)42));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%hhU|", (unsigned char)42));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%lU|", (unsigned long)42));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%llU|", (unsigned long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%jU|", (uintmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%zU|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%U|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%0U|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%05.2U|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%-9U|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%05.9u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%-0u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%-0.u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%-0.5u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%09.5u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%-9.5u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%-5.9u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%5.u|", (unsigned int)42));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|%.u, %.0u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m|%.u, %.2u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 36 => \033[0m|%.u, %.0u|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 37 => \033[0m|%.u, %.2u|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 38 => \033[0m|%.u, %.0u|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 39 => \033[0m|%.u, %.2u|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 40 => \033[0m|%.u, %.2u, %u|", 0, -02, 02));
	printf("{%d}\n", printf("\033[1;32mTest 41 => \033[0m|%05u|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 42 => \033[0m|%9.2u|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 43 => \033[0m|%#9.2u|", 1234));
	printf("{%d}\n", printf("\033[1;32mTest 44 => \033[0m|%.0u|, |%.u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 45 => \033[0m|%.1u|, |%.1u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 46 => \033[0m|%.5u|, |%.5u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 47 => \033[0m|%10.5u|, |%10.5u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 48 => \033[0m|%-10.5u|, |%-10.5u|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 49 => \033[0m|%u|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 50 => \033[0m|%-5u|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 51 => \033[0m|%u|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 52 => \033[0m|%5u|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 53 => \033[0m|%#05u|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 54 => \033[0m|%#05u|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 55 => \033[0m|%#5u|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 56 => \033[0m|%-#5u|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 57 => \033[0m|%lu|", LONG_MAX));
	printf("{%d}\n", printf("\033[1;32mTest 58 => \033[0m|%u|", -523));
	printf("{%d}\n", printf("\033[1;32mTest 59 => \033[0m|%lu|", LONG_MIN - 1));
	printf("{%d}\n", printf("\033[1;32mTest 60 => \033[0m|%lu|", LONG_MIN));
	printf("{%d}\n", printf("\033[1;32mTest 61 => \033[0m|%lu|", LONG_MIN + 1));

#endif
#ifdef TEST_POUR

	printf("\033[1;41m|-------------------------| (Lancement du test POURCENTAGE en cours...) |-------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%%|"));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%hh%|"));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%h%|"));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%l%|"));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%ll%|"));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%j%|"));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%z%|"));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%5%|"));
	printf("{%d}\n", printf("\033[1;32mTest 8b => \033[0m|%.5%|"));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%05%|"));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%0.5%|"));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%+-10.2%|"));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%+ -10.2%|"));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%0+-10.2%|"));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%+010.2z%|"));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%+010.2%z%d|", 42));

#endif
#ifdef TEST_D

	printf("\033[1;41m|-------------------------| (Lancement du test SIGNED DECIMAL en cours...) |-------------------------|\033[0m\n");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%ld|", LONG_MAX));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%ld|", LONG_MIN));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%4.3i|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%-3.1i|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%-4.1i|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%-4d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%.d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%+d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|% d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%05.1d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%05.1zd|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%09.5d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%09.3d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%09.2d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%.5d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%.5d|", 400000));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%-.5d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|% .5d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%+.5d|", 42));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%.5d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%-.5d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|% .5d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%+.5d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%+d|", +42));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%.5hhd|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%.5hhd|", (char)40));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%-.5hhd|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|% .5hhd|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%+.5hhd|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%.5hhd|", (char)-42));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%-.5hhd|", (char)-42));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|% .5hhd|", (char)-42));
	printf("{%d}\n", printf("\033[1;32mTest 35 => \033[0m|%+.5hhd|", (char)-42));
	printf("{%d}\n", printf("\033[1;32mTest 36 => \033[0m|%15hhd|", (char)-42));
	printf("{%d}\n", printf("\033[1;32mTest 37 => \033[0m|%15hhd|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 38 => \033[0m|%1hhd|", (char)400000));
	printf("{%d}\n", printf("\033[1;32mTest 39 => \033[0m|%15.4d|", -42));
	printf("{%d}\n", printf("\033[1;32mTest 40 => \033[0m|%8.4d|", -424242424));
	printf("{%d}\n", printf("\033[1;32mTest 41 => \033[0m|%hd|", (short)33000));
	printf("{%d}\n", printf("\033[1;32mTest 42 => \033[0m|%+hhd|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 43 => \033[0m|%+hhd|", (char)-42));
	printf("{%d}\n", printf("\033[1;32mTest 44 => \033[0m|%+hhd|", (char)400000));
	printf("{%d}\n", printf("\033[1;32mTest 45 => \033[0m|%+hhd|", (char)-400000));
	printf("{%d}\n", printf("\033[1;32mTest 46 => \033[0m|%ld|", (long)42));
	printf("{%d}\n", printf("\033[1;32mTest 47 => \033[0m|%lld|", (long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 48 => \033[0m|%jd|", (intmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 49 => \033[0m|%zd|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 50 => \033[0m|%hD|", (short)42));
	printf("{%d}\n", printf("\033[1;32mTest 51 => \033[0m|%hhD|", (char)42));
	printf("{%d}\n", printf("\033[1;32mTest 52 => \033[0m|%lD|", (long)42));
	printf("{%d}\n", printf("\033[1;32mTest 53 => \033[0m|%llD|", (long long)42));
	printf("{%d}\n", printf("\033[1;32mTest 54 => \033[0m|%jD|", (intmax_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 55 => \033[0m|%zD|", (size_t)42));
	printf("{%d}\n", printf("\033[1;32mTest 56 => \033[0m|%10.5d|, |%10.5d|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 56 => \033[0m|abcdefg%0.0d|abcde", 012));
	printf("{%d}\n", printf("\033[1;32mTest 57 => \033[0m|abcdefg%00.0d|abcde", 0));
	printf("{%d}\n", printf("\033[1;32mTest 58 => \033[0m|abcdefg%00.d|abcde", 0));
	printf("{%d}\n", printf("\033[1;32mTest 59 => \033[0m|abcdefg%00d|abcde", 0));
	printf("{%d}\n", printf("\033[1;32mTest 60 => \033[0m|abcdefg%.d|abcde", 0));
	printf("{%d}\n", printf("\033[1;32mTest 61 => \033[0m|abcdefg%.0d|abcde", 0));
	printf("{%d}\n", printf("\033[1;32mTest 62 => \033[0mOKLM"));
	printf("{%d}\n", printf("\033[1;32mTest 63 => \033[0m"));
	printf("{%d}\n", printf("\033[1;32mTest 64 => \033[0m|%05.1d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 65 => \033[0m|%05.1zd|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 66 => \033[0m|%09.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 67 => \033[0m|%09.3d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 68 => \033[0m|%09.2d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 69 => \033[0m|%.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 70 => \033[0m|%.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 71 => \033[0m|%-.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 72 => \033[0m|% .5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 73 => \033[0m|%+.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 74 => \033[0m|%.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 75 => \033[0m|%-.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 76 => \033[0m|% .5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 77 => \033[0m|%+.5d|", 0));
	printf("{%d}\n", printf("\033[1;32mTest 78 => \033[0m|%.d, %.0d|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 79 => \033[0m|%.d, %.2d|", 0, 0));
	printf("{%d}\n", printf("\033[1;32mTest 80 => \033[0m|%.d, %.0d|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 81 => \033[0m|%.d, %.2d|", 42, 42));
	printf("{%d}\n", printf("\033[1;32mTest 82 => \033[0m|%d, %d, %d|", 0, -02, 02));

#endif
#ifdef TEST_WS

	printf("\033[1;41m|-------------------------| (Lancement du test UNICODE S en cours...) |-------------------------|\033[0m\n");
	setlocale(LC_ALL, "");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%05.S|", L"42 c est cool"));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%.4S|", L"我¼是一只猫。"));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%15.6S|", L"我¼是一只猫。"));
	printf("{%d}\n", printf("\033[1;32mTest 3b => \033[0m|%-15.5S|", L"我是一只猫。"));
	printf("{%d}\n", printf("\033[1;32mTest 3c => \033[0m|%15.5S|", L"᳄᳄᳄᳄᳄᳄"));
	printf("{%d}\n", printf("\033[1;32mTest 3d => \033[0m|%-15.5S|", L"᳄᳄᳄᳄᳄᳄"));
	printf("{%d}\n", printf("\033[1;32mTest 3e => \033[0m|%-45.25S|", L"᳄ ᳄ ᳄ ᳄ ᳄ ᳄ "));
	printf("{%d}\n", printf("\033[1;32mTest 3f => \033[0m|%-45.25S|", L"᳄ ᳄ ᳄ ᳄ ᳄ ᳄ "));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%4.15S|", L"我是一只猫。"));
	printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%4.S|", L"我是一只猫。"));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%4.1S|", L"Jambon"));
	printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S%S|", L"Α α", L"Β β", L"Γ γ", L"Δ δ", L"Ε ε", L"Ζ ζ", L"Η η", L"Θ θ", L"Ι ι", L"Κ κ", L"Λ λ", L"Μ μ", L"Ν ν", L"Ξ ξ", L"Ο ο", L"Π π", L"Ρ ρ", L"Σ σ", L"Τ τ", L"Υ υ", L"Φ φ", L"Χ χ", L"Ψ ψ", L"Ω ω", L""));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%S|", L"猫"));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%zd|", L"᳄"));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%S|", L"᳄"));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%S|", L"ƜƜƜƜƜƜ"));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%S|", L"∰ J'aime∰ les∰ poneys∰ roses∰ "));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%S|", L"é é é é é"));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%S|", L"𖣐 𖣐 𖣐 𖣐 𖣐"));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%S|", L"🧀 🧀 🧀 🧀 🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%22.4S|", L"🧀 🧀 🧀 🧀 🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 16b => \033[0m|%-022.4S|", L"🧀 🧀 🧀 🧀 🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%4.22S|", L"😐  😐 "));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%4S|", L"😐  😐 "));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%.22S|", L"😐  😐 "));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%S|", L"NULL"));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%0.0S|", L"᳄ "));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%0.5S|", L"᳄ ᳄ "));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%#-+ 0.0S|", L"🧀 🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%#-+ 0.12S|", L"🧀 🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%#-+ 5.12S|", L"🧀 🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%hhS|", L"🧀 "));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%5.12S|", L""));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%5S|", L""));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%5.12S|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%5S|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 31 => \033[0m|%8S|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 32 => \033[0m|%.2S|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 33 => \033[0m|%8.2S|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 34 => \033[0m|%-8.2S|", NULL));

#endif
#ifdef TEST_WC
	printf("\033[1;41m|-------------------------| (Lancement du test UNICODE C en cours...) |-------------------------|\033[0m\n");
	setlocale(LC_ALL, "");
	printf("\033[1;32m|-----| LE VRAI |-----|\033[0m\n");
	printf("{%d}\n", printf("\033[1;32mTest 1 => \033[0m|%05.C|", L'l'));
	printf("{%d}\n", printf("\033[1;32mTest 2 => \033[0m|%.4C|", L'我'));
	printf("{%d}\n", printf("\033[1;32mTest 3 => \033[0m|%15.5C|", L'我'));
	printf("{%d}\n", printf("\033[1;32mTest 3b => \033[0m|%-15.5C|", L'我'));
	printf("{%d}\n", printf("\033[1;32mTest 3c => \033[0m|%15.5C|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 3d => \033[0m|%-15.5C|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 3e => \033[0m|%-45.25C|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 3f => \033[0m|%-45.25C|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 4 => \033[0m|%4.15C|", L'我'));
	//printf("{%d}\n", printf("\033[1;32mTest 5 => \033[0m|%4.4C|", '我'));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%4.1C|", L'Jambon'));
	printf("{%d}\n", printf("\033[1;32mTest 6 => \033[0m|%4.1C|", L'Merci'));
	//printf("{%d}\n", printf("\033[1;32mTest 7 => \033[0m|%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C%C|", L'Α α', L'Β β', L'Γ γ', L'Δ δ', L'Ε ε', L'Ζ ζ', L'Η η', L'Θ θ', L'Ι ι', L'Κ κ', L'Λ λ', L'Μ μ', L'Ν ν', L'Ξ ξ', L'Ο ο', L'Π π', L'Ρ ρ', L'Σ σ', L'Τ τ', L'Υ υ', L'Φ φ', L'Χ χ', L'Ψ ψ', L'Ω ω', L''));
	printf("{%d}\n", printf("\033[1;32mTest 8 => \033[0m|%C|", L'猫'));
	printf("{%d}\n", printf("\033[1;32mTest 9 => \033[0m|%zd|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 10 => \033[0m|%C|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 11 => \033[0m|%C|", L'Ɯ'));
	printf("{%d}\n", printf("\033[1;32mTest 12 => \033[0m|%C|", L'∰'));
	printf("{%d}\n", printf("\033[1;32mTest 13 => \033[0m|%C|", L'é'));
	printf("{%d}\n", printf("\033[1;32mTest 14 => \033[0m|%C|", L'𖣐'));
	printf("{%d}\n", printf("\033[1;32mTest 15 => \033[0m|%C|", L'🧀'));
	printf("{%d}\n", printf("\033[1;32mTest 16 => \033[0m|%22.4C|", L'🧀'));
	printf("{%d}\n", printf("\033[1;32mTest 16b => \033[0m|%-022.4C|", L'🧀'));
	printf("{%d}\n", printf("\033[1;32mTest 17 => \033[0m|%4.22C|", L'😐'));
	printf("{%d}\n", printf("\033[1;32mTest 18 => \033[0m|%4C|", L'😐'));
	printf("{%d}\n", printf("\033[1;32mTest 19 => \033[0m|%.22C|", L'😐'));
	printf("{%d}\n", printf("\033[1;32mTest 20 => \033[0m|%C|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 21 => \033[0m|%0.0C|", L'᳄'));
	printf("{%d}\n", printf("\033[1;32mTest 22 => \033[0m|%0.5C|", L'᳄ ᳄ '));
	printf("{%d}\n", printf("\033[1;32mTest 23 => \033[0m|%#-+ 0.0C|", L'🧀 🧀 '));
	printf("{%d}\n", printf("\033[1;32mTest 24 => \033[0m|%#-+ 0.12C|", L'🧀'));
	printf("{%d}\n", printf("\033[1;32mTest 25 => \033[0m|%#-+ 5.12C|", L'🧀'));
	printf("{%d}\n", printf("\033[1;32mTest 26 => \033[0m|%hhC|", L'🧀'));
	printf("{%d}\n", printf("\033[1;32mTest 27 => \033[0m|%5.12C|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 28 => \033[0m|%5C|", 'a'));
	printf("{%d}\n", printf("\033[1;32mTest 29 => \033[0m|%5.12C|", NULL));
	printf("{%d}\n", printf("\033[1;32mTest 30 => \033[0m|%5C|", NULL));
#endif
    return 0;
}