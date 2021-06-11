#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
    /************  [Part One] 指针和数组的关系&指针运算   ******************/
    int array[3] = {1, 2, 3};

    int multi_dim_array[2][5][3] = {
        {
            {111, 112, 113},
            {121, 122, 123},
            {131, 132, 133},
            {141, 142, 143},
            {151, 152, 153},
        },
        {
            {211, 212, 213},
            {221, 222, 223},
            {231, 232, 233},
            {241, 242, 243},
            {251, 252, 253},
        }
    };
    printf("----  Output of [Part One]  ----\n");
    printf("sizeof(int)              =  %lu\n", sizeof(int));

    printf("sizeof(array)            =  %lu\n", sizeof(array));
    printf("sizeof(multi_dim_array)  =  %lu\n", sizeof(multi_dim_array));

    printf("\n[address info]\n  pointer\t\tcontent\n");
    printf("  array \t\t%p\n",  array);
    printf("  array+1\t\t%p\n", array + 1);

    printf("  multi_dim_array\t%p\n",   multi_dim_array);
    printf("  multi_dim_array+1\t%p\n", multi_dim_array + 1);
    printf(" *multi_dim_array\t%p\n", * multi_dim_array);
    printf("**multi_dim_array\t%p\n", **multi_dim_array);

    /*
    Output/输出:
        sizeof(int)              =  4
        sizeof(array)            =  12
        sizeof(multi_dim_array)  =  120
        [address info]
          POINTER		   CONTENT
          array 		0x7fff695a7b30
          array+1		0x7fff695a7b34
          multi_dim_array	0x7fff695a7b40
          multi_dim_array+1	0x7fff695a7b7c
         *multi_dim_array	0x7fff695a7b40
        **multi_dim_array	0x7fff695a7b40
    Explanation/解释：
        (1) 十六进制7c-40 = 60(二进制)
        (2) 在大多数表达式中，数组名是指向数组【第一个元素】的指针【常量】(不可以指向别的地址)。
            但是，有两个例外：
            a) sizeof(array_name)返回整个数组所占用的字节，而不是指针类型占用的字节数。
            b) &array_name返回指向数组的指针(数组指针)，而不是指向数组第一个元素的指针的指针。
        (3) multi_dim_array、*multi_dim_array、**multi_dim_array都是指向数组的指针，
            尽管他们指向的地址都是高维数组的首地址(即具有相同的值)，但是他们指向的数组类型不同。
            [注] array是指向第一个元素的指针，也就是指向int类型的指针。
        (4) 指针做加减法运算时，指针变量的值的变化和其所指向的东西有关。
            特别注意指向数组的指针做加减法的情况。
            multi_dim_array指向的就是5×3的int类型的二维数组，所以：
            multi_dim_array+1转换为multi_dim_array+1*(5*3*4)，其值增加60。
    Adds/补充：
        (1) 两个指针相减的结果的类型是ptrdiff_t，是一种有符号类型。
            注意相减的结果是相差几个指针所指的类型，而不是简单的地址的值相减。
        (2) 如果两个做相减运算的指针不是同一个数组中的元素，其结果为未定义！
        (3) 指针可以做关系运算： > >=   < <=
       【重要】作为函数参数的数组名
            int strlen(char *string);
            int strlen(char string[]);
            等价于int strlen(char string[10]);//函数不为数组参数分配内存空间！！
            所有传递给函数的参数都是通过传值方式进行的，因此传递给函数的是该指针的一份拷贝。
            函数的参数是指针类型，并不是数组，因此执行sizeof(形参)无法得到整个数组所占用的字节数，
            而是指针类型占据的字节数。
            通常的做法是将数组长度通过形参传递。
    */


    /************  [Part Two] 指向数组的指针   ******************/

    int   *p1[10];//指针数组
    int *(p2)[10];//数组指针：指向数组的指针

    /*
    Knowledge/知识点：
        指针数组和数组指针的主要区别方法是 运算符的优先级：()>[]>*。
        p1先和[]结合构成数组的定义，"int *"表明数组元素的类型是int型指针；
        p2先和*结合构成指针的定义，int表明数组元素的类型，这里没有数组名(匿名数组)。
        并且p2的值等于数组的首地址。
       【重要】 声明数组指针时，如果省略数组的长度，则不能在该指针上执行任何指针运算。
                int (*p)[] = matrix;//运算时，将根据空数组的长度调整，也就是与零相乘！、
       【重要】 在使用sizeof计算数组长度(特别是字符数组)时，首要区分该指针是指向数组的指针
                还是普通指向基本类型的指针！
    */



    /************  [Part Three] 字符串数组(指针数组)   ******************/
    char const *kws_ptr[] = {//指针数组形式定义字符串数组
        "do",
        "for",
        "if",
        "register",
        "return",
        "switch",
        "while",
        NULL,
    };
    char const kws_arr[][9] = {//二维数组形式定义字符串数组
        "do",
        "for",
        "if",
        "register",
        "return",
        "switch",
        "while"
    };

    printf("\n\n----  Output of [Part Three]  ----\n");
    printf("sizeof(kws_ptr[2])=%lu, sizeof(void*)=%lu\n",
            sizeof(kws_ptr[2]),
            sizeof(void*)
          );

    printf("Address of kws_ptr[2] = %p.\n"
           "Address of       \"if\" = %p.\n",
           kws_ptr[2], "if");

    printf("Total Bytes of `kws_ptr`: %lu\n", sizeof(kws_ptr));
    printf("Total Bytes of `kws_arr`: %lu\n", sizeof(kws_arr));

    ///遍历字符串指针数组kws_ptr
    char const **kwp;
	for (kwp = kws_ptr; *kwp != NULL; kwp++)
        printf("%s  ", *kwp);


    /*
    Output/输出:
        sizeof(kws_ptr[2])=4, sizeof(void*)=4
        Address of kws_ptr[2] = 0040b243.
        Address of       "if" = 0040b243.
        Total Bytes of `kws_ptr`: 32
        Total Bytes of `kws_arr`: 63
        do  for  if  register  return  switch  while
    Explanation/解释：
        kws_ptr的声明解释：首先和`[]`结合说明kws_ptr是一个数组, 然后数组的类型是指针--指向char const类型。
                           更多细节：`005-高级声明技巧.c`
        由此kws_ptr是一个指针数组, 数组的长度为8, 数组元素为指向字符串常量的指针！
        因此sizeof(kws_ptr[i])==sizeof(void*),
        而kws_ptr是一个指向数组的指针：sizeof(kws_ptr)的结果为整个数组占用的字节数,
        也就是  数组长度×指针占用字节数=8*4=32, 从而数组长度=sizeof(kws_ptr)/sizeof(kws_ptr[i])
       【注意】 使用这种方式声明字符串数组，末尾添加NULL指针是一个技巧，方便于：
                不必获取数组长度就可以遍历所有字符串
       【注意】 kwp是指向字符串常量的指针, kwp++每次移动指针大小的字节数,
                *kwp得到字符串常量的首地址, 字符串常量在表达式中的值是一个【指针常量】(类似于数组名)
       【注意】 kws_ptr的元素指向的这些字符串常量存放在常量区域, 也要以'\0'结束, 这些字符串未必连续存储。
        kws_arr 是一个二维字符数组, 将定义中的那些字符串拷贝给该字符数组
                更多字符细节看`002-不可思议的C风格字符串.c`
                每个字符串拷贝给一个长度为9的字符数组, 因此是连续存储的, 中间相隔若干个'\0'
                kws_arr是指向 长度为9的字符数组 的指针。
       【总结】
                (1) 指针数组形式定义的字符串数组需要一个额外的指针数组进行存储,
                    但是每个字符串常量占据的内存空间只是其本身的长度。
                (2) 二维数组形式定义的字符串数组, 每个字符串的存储空间=最长字符串长度+1('\0')
                    两种形式差别很小！指针数组形式更为紧凑。
                (3) 推荐使用的方式是 `末尾元素为NULL的指针数组`
    */


    return 0;
}