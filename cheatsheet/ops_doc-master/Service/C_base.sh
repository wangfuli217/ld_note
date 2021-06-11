https://cloud.tencent.com/developer/section/1009756 #  C可以一看

extern      声明变量是在其他文件正声明(也可以看做是引用变量)
volatile    说明变量在程序执行中可被隐含地改变
typedef     用以给数据类型取别名(当然还有其他作用)

制作软件是为了达到特定的目的，而软件开发的问题更多的是是解决复杂度问题。往往复杂度带来的性能问题更加严重。然后为了解决复杂度带来的性能问题去引入更高的复杂度，出现恶性循环的可能性非常之大。

https://www.geeksforgeeks.org/understanding-extern-keyword-in-c/
variable(extern){  
extern的作用
  1. 函数和变量可以一次定义多次声明
  2. extern关键字扩大了变量或者函数可见范
  3. 对函数而言，在不指明static的情况下；定义和声明默认都是extern类型的；在函数前添加extern是重复性冗余的。
  4. 当变量使用extern的时候，表明变量只是声明不是定义。
  5. 特殊情况下；当变量使用extern声明又初始化的时候，表明变量也进行了定义。
extern的使用
  1. 定义在.c文件中进行，声明在.h文件中进行。.c文件会引用.h文件
  
C语言中的static和extern关键字都是作用在变量和函数中的, 所以我们会通过变量和函数来分别进行阐述.
关于C语言中的声明和定义:
    1. 函数和变量的声明不会分配内存, 但是定义会分配相应的内存空间
    2. 函数和变量的声明可以有很多次, 但是定义最多只能有一次
    3. 函数的声明和定义方式默认都是 extern 的, 即函数默认是全局的
    4. 变量的声明和定义方式默认都是局部的, 在当前编译单元或者文件内可用
1. 关于函数
前面说了函数的声明和定义默认都是 extern 的, 即全局可见的. 所以在声明和定义的时候, 默认都是 extern的. 下面的代码:
    int add(int a, int b);
在编译器看来, 和下面的代码等价:
    extern int add(int a, int b);
因此, 为了修饰当前文件中的内部函数, static 关键字出场了. 下面的例子:
    static int add(int a, int b);
static修饰的 function 表明这个函数只对于当前文件中的其他函数是可见的, 其他文件中的函数不能够调用.
    
2. 关于变量
使用 static 和 extern 修饰变量的时候, 变量的生命周期是一样的, 不同的是变量的作用域.
一个表格说明关系:
存储类名        生命周期                 作用域
extern          静态(程序结束后释放)     外部(整个程序)
static          静态(程序结束后释放)     内部(仅编译单元，一般指单个源文件)
auto,register   函数调用(调用结束后释放) 无
}

func(对于返回一组复杂数据，通常的办法有些什么){
1. 最常用的方法是，调用者分配空间，传递给处理函数。由处理函数反向填写结构内容。
   好处是，调用者可以选择把空间分配在栈上还是堆上。
   缺点是，你很难让调用者定义不定的数据结构。尤其是在结构里还有对别的结构的引用。
2. 由函数自己分配内存，交给调用者去释放
   缺点呢？内存只能从堆上分配；而且增加了内存泄露的隐患；设计角度上讲，也不太干净。
   对于复杂数据结构，这个方法也无能为力。C 语言里并没有所谓析构函数的说法。
3. 在函数内部开一块静态空间，用于数据返回。
   问题是函数不可重入，且有线程安全问题。
   个人不看好在 C 语言中使用多线程解决问题。多线程也是违背 Unix 哲学的。如果你有几件事情需要协调起来做，使用多进程
4. c是可以传结构体的。c中对于不定的结构体，可以用void指针。
}
variable(define){
变量定义
    什么是定义：所谓的定义就是创建一个对象，为这个对象分配一块内存并给它取上一个名字，这个名字就是我们经常所说的变量名或对象名。
    一个变量或对象在一定的区域内（比如函数内，全局等）只能被定义一次，如果定义多次，编译器会提示你重复定义同一个变量或对象。
}
variable(declare){
变量声明    
    告诉编译器，这个名字已经匹配到一块内存上了,下面的代码用到变量或对象是在别的地方定义的。声明可以出现多次。
    告诉编译器，我这个名字我先预定了，别的地方再也不能用它来作为变量名或对象名。
    
    int i；                               变量的声明
    extern int i；(关于extern ，后面解释) 变量的定义
    void fun(int i, char c);              函数的声明
    void fun(int i, char c) {}            函数的定义
}
variable(auto){
编译器在默认的缺省情况下，所有变量都是auto 的。
}
variable(register){
    请求编译器尽可能的将变量存在CPU 内部寄存器中而不是通过内存寻址访问以提高效率。注意是尽可能，不是绝对。
    register 变量必须是能被 CPU 寄存器所接受的类型
    register 变量必须是一个单个的值，并且其长度应小于或等于整型的长度
    register 变量可能不存放在内存中，所以不能用取址运算符"&"来获取 register 变量的地址
}
variable(static){
    静态全局变量，作用域仅限于变量被定义的文件中，其他文件即使用 extern 声明也没法使用他。
    准确地说作用域是从定义之处开始，到文件结尾处结束，在定义之处前面的那些代码行也不能使用它。
}
variable(float){
float 变量与"零值"进行比较
    A), if(fTestVal == 0.0); if(fTestVal != 0.0);                                        # NO
    B), if((fTestVal >= -EPSINON) && (fTestVal <= EPSINON)); //EPSINON 为定义好的精度。  # OK
    不要在很大的浮点数和很小的浮点数之间进行运算，比如：10000000000.00 + 0.00000000001这样计算后的结果可能会让你大吃一惊。
}
variable(pointer){
    A), if(p == 0); if(p != 0);        # 整形
    B), if(p); if(!p);                 # 布尔
    C), if(NULL == p); if(NULL != p);  # 指针
    为什么要这么写呢？是怕漏写一个"="号:if(p = NULL) ，这个表达式编译器当然会认为是正确的。
}
variable(void){
void真正发挥的作用在于：
    对函数返回的限定; 如果函数没有返回值,那么应声明为 void 类型
    对函数参数的限定; 如果函数无参数,那么应声明其参数为 void
    
    ANSI
        void * pvoid;
        pvoid++; //ANSI ：错误
        pvoid += 1; //ANSI ：错误
        int *pint;
        pint++; //ANSI：正确
    GNU:指定 void * 的算法操作与char * 一致
        void * pvoid;
        pvoid++; //GNU ：正确
        pvoid += 1; //GNU ：正确
    void 的出现只是为了一种抽象的需要，如果你正确地理解了面向对象中 “抽象基类” 的概念，也很容易理解void 数据类型。
    正如不能给抽象基类定义一个实例，我们也不能定义一个void （让我们类比的称void 为“ 抽象数据类型”）变量。
    
    任何类型的指针都可以直接赋值给 void ，无需进行强制类型转换。
}
variable(const){
    const int Max=100;
    int Array[Max];
    const修饰的Max 仍然是变量，只不过是只读属性罢了。
    注意：const修饰的只读变量必须在定义的同时初始化。
    
    修饰一般变量
        只读变量在定义时，修饰符 const 可以用在类型说明符前，也可以用在类型说明符后。例如:
        int const i=2;    // 正确
        const int j=2;    // 正确
    修饰数组
        定义或说明一个只读数组可采用如下格式:
        int const a[5]={1, 2, 3, 4, 5};    // 正确
        const int b[5]={1, 2, 3, 4, 5};    // 正确
    修饰指针
        const int *p;       //const 修饰*p,p 是指针，*p是指针指向的对象，不可变
        int const *p;       //const修饰*p,p 是指针，*p是指针指向的对象，不可变
        int *const p;       //const修饰p，p不可变，p指向的对象可变
        const int *const p; // 前一个const修饰*p,后一个const修饰p，指针p 和p 指向的对象都不可变
    修饰函数的参数
        当不希望这个参数值被函数体内意外改变时，const 修饰符也可以修饰函数的参数，从而防止了使用者的一些无意的或错误的修改。
        void Fun(const int i);
    修饰函数的返回值
        const 修饰符也可以修饰函数的返回值，返回值不可被改变。例如:
        const int Fun (void);
        
    在另一连接文件中引用const只读变量：
    extern const int i; // 正确的声明
    extern const int j=10; //错误！只读变量的值不能改变。
}
variable(volatile){
   遇到这个关键字声明的变量，编译器对访问该变量的代码就不再进行优化，从而可以提供对特殊地址的稳定访问。
}
variable(struct|class){
在C++ 里struct 关键字与class 关键字一般可以通用，只有一个很小的区别。struct 的成员默认情况下属性是public 的，而 class 成员却是private 的。
}
variable(union){
    union 主要用来压缩空间。如果一些数据不可能在同一时间同时被用到，则可以使用union。
    大端模式（Big_endian）：字数据的高字节存储在低地址中，而字数据的低字节则存放在高地址中。
    小端模式（Little_endian）：字数据的高字节存储在高地址中，而字数据的低字节则存放在低地址中。
enum
    一般的定义方式如下：
        enum enum_type_name
        {
            ENUM_CONST_1,
            ENUM_CONST_2,
            ...
            ENUM_CONST_n
        } enum_variable_name;
    其中 enum_type_name 是自定义的一种数据类型名，而 emun_varaiable_name 类型是对一个变量取值范围的限定，而花括号内是它的取值范围，
    及 enum_type_name 类型的变量 emun_varaiable_name 只能取值为花括号内的任何一个值，如果赋给该类型变量的值不在列表中，则会报错
    或警告。

    1. #define 宏常量是在预编译阶段进行简单替换，枚举常量则是在编译的时候确定其值。
    2. 一般在编译器里，可以调试枚举常量，但是不能调试宏常量。
    3. 枚举可以一次定义大量相关的常量，但是 #define 宏一次只能定义一个。
}
variable(typedef){
typedef的真正意思是给一个已经存在的数据类型（注意：是类型不是变量）取一个别名，而非定义一个新的数据类型。
    typedef struct student
    {
        //code
    }Stu_st,*Stu_pst;// 命名规则请参考本章前面部分
    这时候，下方的定义中(1)和(2)没有区别，(3)、(4)和(5)没有区别。
    struct student stu1;    // (1)
    Stu_st stu1;    // (2)
    struct student *stu2;    // (3)
    Stu_pst stu2;    // (4)
    Stu_st *stu2;    // (5)
}
preprocess(define){
预处理器支持文本宏替换
#define identifier replacement-list(optional)           1
#define identifier( parameters ) replacement-list       2
#define identifier( parameters, ... ) replacement-list  3
#define identifier( ... ) replacement-list              4
#undef identifier                                       5

#define 指令
#define指令定义的标识符作为一个宏。如果标识符已经被定义为任何类型的宏，那么该程序是格式不正确的，除非定义相同。

类似于对象的宏
类似于对象的宏将每个定义的标识符替换为替换列表

函数式的宏
参数的数量必须与宏定义中参数的数量相同或程序不合格。
#define指令的版本(2)定义了一个简单的函数式宏。
#define指令的版本(3)定义了一个具有可变数量参数的函数式宏。可以使用__VA_ARGS__标识符访问附加参数，然后使用标识符来替换标识符，然后使用标识符替换它们。
#define指令的版本(4)定义了一个类似函数的宏，其中包含可变数量的参数，但没有常规参数。只能使用__VA_ARGS__标识符访问参数，然后使用标识符替换标识符，并将标识符替换。

在函数式宏中，#替换列表中的标识符之前的运算符通过参数替换运行标识符，并将结果封装在引号中，从而有效地创建字符串文字。

##在替换列表中的任何两个连续标识符之间的运算符运行两个标识符上的参数替换，然后连接结果。
}
https://github.com/supnovx/howtos/blob/da787dd4b7092c2f8502b8cae44068d1c3ed9602/program/macro.md
preprocess(__VA_ARGS__){ -- 详细见log.sh
1. ... 和 __VA_ARGS__ 之间对应关系
宏可以使用...传入不定个数参数，...只能作为最后一个形参。 在Visual Studio 2013上测试，只能在...形参处传入__VA_ARGS__。 
例如下面的例子第3行，会报参数不够的错误，ABCD(__VA_ARGS__)认为只传了一个参数。 但GCC没有这种限制，下面的例子会编译成功。
#define ABCD(a, b, c, d, ...) d
#define EFGH(...) ABCD(__VA_ARGS__)
EFGH(a, b, c, d, e)

2. __VA_ARGS__ 和 逗号
标准C要求不定参数...必须传入至少一个参数。但是在GCC和VS上都做了扩展。 如果传入0个参数，VS会自动把__VA_ARGS__前面的逗号移除掉；
而GCC则支持这种特殊语法 ## __VA_ARGS__，当参数个数为0时移除前面的逗号。
#define PRINT(fmt, ...) printf(fmt, __VA_ARGS__)
PRINT("string") // VS  => printf("string")
PRINT("string") // GCC => printf("string", ) => error
#define PRINT2(fmt, ...) printf(fmt, ## __VA_ARGS__)
PRINT2("string") // VS => printf("string") VS can support this special ## syntax
PRINT2("string") // GCC=> printf("string")

但__VA_ARGS__后面的逗号不会自动移除，因此要传入至少一个参数，如下面的ARGS_N_HELPER。 这种情况在VS中不存在，
因为VS只允许在...处传入__VA_ARGS__，...是最后一个参数， __VA_ARGS__也应该是最后一个，其后不会有逗号。
#define ARGS_N(...) ARGS_N_HELPER(__VA_ARGS__, arg_end, 4, 3, 2, 1)
#define ARGS_N_HELPER(arg_end, a4, a3, a2, a1, N, ...) N

3. 宏扩展多条语句
宏如果扩展成多条语句，为避免出错应该用do { ... } while (0)将多条语句包裹起来。 另外宏的每个参数应该都只使用一次，
且每个参数都用小括号括起。
#define ABCD() foo(); bar()
if (expr) ABCD(); // unexpected, fine when modify to #define ABCD() do { foo(); bar(); } while (0)
#define CALL(a) (f1(a), f2(a)) // use parameter `a` twice
CALL(foo()) // expanded to: (f1(foo()), f2(foo()), but expected behavior may be 'a=foo(), f1(a), f2(a)'

4. 总结
注意：有些编译器提供了一个允许##出现在逗号之后和__VA_ARGS__之前的扩展，在这种情况下，
当__VA_ARGS__非空时，##什么也不做，但
当__VA_ARGS__为空时删除逗号：这使得可以定义宏等fprintf (stderr, format, ##__VA_ARGS__)
}

preprocess(stringification){ 参数字符化
    宏函数中，替换列表中的标识符如果前面带有#操作符，会用传入的参数对其进行替换， 
然后用双引号将替换后的结果括起来转换成字符串字面量。
这里的替换只会简单的用传入的参数直接替换，不会对参数中存在的宏进行彻底展开。
#define TOKEN_STRING(a) #a
#define MAX_SIZE 64
TOKEN_STRING(MAX_SIZE) // will produce "MAX_SIZE" not "64"

    转换成字符串的过程中，预处理器会对引号以及反斜杠进行转义，并且移除开头和末尾的空白，
并将内容内部的空白都压缩到只剩一个空白符(内容内部的内嵌字符串字面量中的空白不会压缩).
 
如果转换的结果不是一个合法的字符串字面量，则该操作的行为是未定义的。
如果有一个标志符的前面有#操作，后面有##操作，#和##的操作顺序是未定义的。
 
#define showlist(...) puts(#__VA_ARGS__)
showlist(1, "x", int); // expands to puts("1, \"x\", int")
}

preprocess(token pasting){

如果替换列表中的两个标志符中间有##操作符，首先会用传入的参数对这两个标志符进行替换， 然后将替换后的结果连接起来形成一个token。
这里的替换只会简单的用传入的参数直接替换，不会对参数中存在的宏进行彻底展开。 这种操作称为token粘贴，只有能连接成一个合法的token，这个操作才是合法的。
例如将两个标志符拼接成一个更长的标志符； 将数字拼接成一个更长的数值；将+和=拼接成+=等等。

不能用将/和*拼接成注释，因为注释在处理宏替换之前已经从代码中移除了。 
如果拼接的结果不是一个合法的token，则##操作的行为是未定义的。
拼接的结果如果是宏，会像其他宏一样继续进行宏替换。 另外，连续多个##操作的执行顺序是未定义的。

有些编译器如GCC允许##出现在逗号和__VA_ARGS__之间，它允许对变成参数...传入0个参数， 此时__VA_ARGS__前面的逗号会被编译器移除；
如果传入的参数不是0个，这个特殊的##操作会被忽略。 这个扩展的操作使得定义这样的宏fprintf(stderr, format, ##VA_ARGS)成为可能。

// gcc version of separating first arg and rest args
#define VARGS_FIRSTARG(...) _FIRSTARG_HELPER(__VA_ARGS__, ellipsis)
#define VARGS_RESTARGS(...) _RESTARGS_HELPER_EX(_VARGS_ONE_OR_MORE(__VA_ARGS__), __VA_ARGS__)
#define _FIRSTARG_HELPER(first, ...) first
#define _RESTARGS_OF_ONE1ARG(first) 
#define _RESTARGS_OF_MOREARG(first, ...) , __VA_ARGS__
#define _RESTARGS_HELPER(tail, ...) _RESTARGS_OF_##tail(__VA_ARGS__)
#define _RESTARGS_HELPER_EX(tail, ...) _RESTARGS_HELPER(tail, __VA_ARGS__)
#define _VARGS_MAX8_ARGS(a1, a2, a3, a4, a5, a6, a7, a8, ...) a8
#define _VARGS_MORETOKS6(m) m, m, m, m, m, m  
#define _VARGS_ONE_OR_MORE(...) _VARGS_MAX8_ARGS(__VA_ARGS__, _VARGS_MORETOKS6(MOREARG), ONE1ARG, ellipsis)

// gcc version of counting the number of arguments
#define VARGS_N(...) _VARGS_N_HELPER(0, ## __VA_ARGS__, 5, 4, 3, 2, 1, 0)
#define _VARGS_N_HELPER(a0, a1, a2, a3, a4, a5, N, ...) N
}
preprocess(elif){
预处理器支持条件编译源文件的各个部分
#if expression
#ifdef expression
#ifndef expression
#elif expression
#else
#endif

有条件的评估
#if, #elif
  表达式是一个常量表达式，仅使用文字和标识符，使用#define伪指令定义。任何标识符(不是字面值，使用#define指令未定义)都会计为0。
  表达式可以包含表单defined标识符或defined (标识符中的一元运算符)，1如果标识符是使用#define伪指令定义的，则返回标识符 ，否则返回0 如果表达式计算为非零值，则包含受控代码块并以其他方式跳过。如果任何使用的标识符不是一个常量，它将被替换为​0​。

#ifdef, #ifndef
  检查标识符是否使用#define伪指令定义 。
  #ifdef标识符实质上等同于#if defined(标识符)。
  #ifndef标识符实质上等同于#if !defined(标识符)。

实例说明
#if #ifdef #ifndef expression [1] must exist
// code block
#elif expression              [2] none or more
// code block
#else                         [3] none or one
// code block
#endif                        [4] must exist

// valid combination
[1][4]:          #if #endif
[1][3][4]:       #if #else #endif
[1][2]...[3][4]: #if #elif ... #else #endif
[1][2]...[4]:    #if #elif ... #endif

// #if #elif can use logic operators !, && and ||
#if !defined(ABCD) && (EFGH == 0 || !IJKL || defined(MNOP))
#endif

#undef ABCD
#if defined(ABCD)  // false
#if !defined(ABCD) // true
#if (ABCD == 0)    // true - undefined macro evaluates to 0
#if (ABCD)         // fasle
#if (!ABCD)        // true - undefined macro evaluates to 0

const int num = 23;
#define NUM 23
#if (num)          // false - num is not a macro and not a literal, evaluates to 0
#if (num == 0)     // true  - num is not a macro and not a literal, evaluates to 0
#if (NUM)          // true  - NUM is a macro and can evaluate to a integer literal 23
#if (NUM == 0)     // false - NUM is a macro and can evaluate to a integer literal 23
}
preprocess(error){
显示给定的错误消息并呈现程序格式不正确。
#error error_message
遇到#error指令后，实现将显示诊断消息 error_message 并呈现程序不合格（编译停止）。
error_message 可以包含几个不一定用引号引起来的单词。
}
preprocess(){
预处理名称
    #define 宏定义
    #undef 撤销已定义过的宏名
    #include 使编译程序将另一源文件嵌入到带有#include 的源文件中
    #if #else #elif #endif
        #if 的一般含义是如果#if 后面的常量表达式为true ，则编译它与#endif 之间的代码，否则跳过这些代码。
        命令#endif 标识一个#if 块的结束。
        #else命令的功能有点象C语言中的else ，#else 建立另一选择（在#if 失败的情况下）。
        #elif 命令意义与else if 相同，它形成一个if else-if 阶梯状语句，可进行多种编译选择。

    #ifdef #ifndef
    用#ifdef 与#ifndef 命令分别表示“如果有定义”及“如果无定义”，是条件编译的另一种方法。

    #line 改变当前行数和文件名称，它们是在编译程序中预先定义的标识符命令的基本形式如下：
        #line number["filename"]
    #error 编译程序时，只要遇到#error 就会生成一个编译错误提示消息，并停止编译
    #pragma 为实现时定义的命令，它允许向编译程序传送各种指令例如，编译程序可能有一种选择，它支持对程序执行的跟踪。
        可用#pragma 语句指定一个跟踪选择。
define
    #define BSC //
    #define BMC /*
    #define EMC */
    D),BSC my single-line comment
    E),BMC my multi-line comment EMC
    D)和E) 都错误，为什么呢？因为注释先于预处理指令被处理, 当这两行被展开成//… 或
    /*…*/ 时, 注释已处理完毕, 此时再出现//… 或/*…*/ 自然错误. 因此, 试图用宏开始或结束一段注释是不行的。
pragma
    #pragma message("消息文本")
        能够在编译信息输出窗口中输出相应的信息，这对于源代码信息的控制是非常重要的。
        当编译器遇到这条指令时就在编译输出窗口中将消息文本打印出来。
    #pragma code_seg( ["section-name"[,"section-class"] ] )
        它能够设置程序中函数代码存放的代码段，当我们开发驱动程序的时候就会使用到它。
    #pragma once
        只要在头文件的最开始加入这条指令就能够保证头文件被编译一次。
    #pragma hdrstop
        预编译头文件到此为止，后面的头文件不进行预编译。
    #pragma resource
        #pragma resource "*.dfm" 表示把*.dfm 文件中的资源加入工程。*.dfm 中包括窗体外观的定义
    #pragma warning
        #pragma warning( disable : 4507 34; once : 4385; error : 164 )
        等价于：
        #pragma warning(disable:4507 34) // 不显示4507和34号警告信息
        #pragma warning(once:4385) // 4385号警告信息仅报告一次
        #pragma warning(error:164) // 把164 号警告信息作为一个错误。
        同时这个pragma warning 也支持如下格式：
        #pragma warning( push [ ,n ] )
        #pragma warning( pop )
        这里n 代表一个警告等级(1---4) 。
        #pragma warning( push )保存所有警告信息的现有的警告状态。
        #pragma warning( push, n) 保存所有警告信息的现有的警告状态，并且把全局警告
        等级设定为n 。
        #pragma warning( pop ) 向栈中弹出最后一个警告信息，在入栈和出栈之间所作的
        一切改动取消。例如：
        #pragma warning( push )
        #pragma warning( disable : 4705 )
        #pragma warning( disable : 4706 )
        #pragma warning( disable : 4707 )
        //.......
        #pragma warning( pop )
        在这段代码的最后，重新保存所有的警告信息(包括4705，4706和4707)。
    #pragma comment(...)该指令将一个注释记录放入一个对象文件或可执行文件中。
        常用的lib 关键字，可以帮我们连入一个库文件。 比如：
        #pragma comment(lib, "user32.lib")
        该指令用来将user32.lib 库文件加入到本工程中。
        linker: 将一个链接选项放入目标文件中, 你可以使用这个指令来代替由命令行传入的或者在开发环境中设置的链接选项, 你可以指定/include 选项来强制包含某个对象, 例如:
        #pragma comment(linker, "/include:__mySymbol")
    #pragma pack 来改变编译器的默认对齐方式
        使用指令#pragma pack (n)，编译器将按照n 个字节对齐。
        使用指令#pragma pack () ，编译器将取消自定义字节对齐方式。
        在#pragma pack (n)和#pragma pack () 之间的代码按n个字节对齐。
#运算符 它可以把语言符号转化为字符串。
    #define SQR(x) printf("The square of x is %d.\n", ((x)*(x)));
    如果这样使用宏：
    SQR(8);
    则输出为：
    The square of x is 64.
    注意到没有，引号中的字符 x 被当作普通文本来处理，而不是被当作一个可以被替换的语言符号。
    #define SQR(x) printf("The square of "#x" is %d.\n", ((x)*(x)));
##预算符
    ##运算符可以用于宏函数的替换部分。这个运算符把两个语言符号组
    合成单个语言符号。看例子：
    #define XNAME(n) x ## n
    如果这样使用宏：
    XNAME(8)
    则会被展开成这样：
    x8
    看明白了没？##就是个粘合剂，将前后两部分粘合起来。
}
variable(pointor|array){
指针 
    1. 保存数据的地址，任何存入指针变量p 的数据都会被当作地址来处理。p 本身的地址由编译器另外存储，存储在哪里，我们并不知道。
    2. 间接访问数据，首先取得指针变量 p 的内容，把它作为地址，然后从这个地址提取数据或向这个地址写入数据。指针可以以指针的形
       式访问*(p+i)；也可以以下标的形式访问 p[i]。但其本质都是先取p 的内容然后加上i*sizeof( 类型)个byte 作为数据的真正地址。
    3. 通常用于动态数据结构
    4. 相关的函数为malloc 和free 。
    5. 通常指向匿名数据（当然也可指向具名数据）
数组
    1. 保存数据，数组名a 代表的是数组首元素的首地址而不是数组的首地址。&a才是整个数组的首地址。a 本身的地址由编译器另外存储，存储在哪里，我们并不知道。
    2. 直接访问数据，数组名 a 是整个数组的名字，数组内每个元素并没有名字。只能通过“具名+匿名”的方式来访问其某个元素，不能把
       数组当一个整体来进行读写操作。数组可以以指针的形式访问*(a+i)；也可以以下标的形式访问a[i]。但其本质都是a 所代表的数组首
       元素的首地址加上i*sizeof( 类型) 个byte 作为数据的真正地址。
    3. 通常用于存储固定数目且数据类型相同的元素。
    4. 隐式分配和删除
    5. 自身即为数组名
指针数组
    首先它是一个数组，数组的元素都是指针，数组占多少个字节由数组本身决定。它是“储存指针的数组”的简称。
数组指针
    首先它是一个指针，它指向一个数组。在32位系统下永远是占4 个字节，至于它指向的数组占多少字节，不知道。它是“指向数组的指针”的简称。

    A)，int *p1[10];   数组其包含 10个指向int 类型数据的指针，即指针数组。
    B)，int (*p2)[10]; 它指向一个包含10个int 类型数据的数组，即数组指针。
    “[] ”的优先级比“* ”要高。p1先与“[] ”结合，构成一个数组的定义，数组名为 p1，int *修饰的是数组的内容，即数组的每个元素。
    int (*)[10] p2-----也许应该这么定义数组指针。
数组参数
    数组参数                      等效的指针参数
    数组的数组：char a[3][4]      数组的指针：char (*p)[10]
    指针数组：char *a[5]          指针的指针：char **p
    C 语言中，当一维数组作为函数参数的时候，编译器总是把它解析成一个指向其首元素首地址的指针。这条规则并不是递归的，也就是说只有
    一维数组才是如此，当数组超过一维时，将第一维改写为指向数组首元素首地址的指针之后，后面的维再也不可改写。
}
macro(libc){
C还定义了如下几个宏： 
    _LINE_ 表示正在编译的文件的行号
    _FILE_ 表示正在编译的文件的名字    
    _DATE_ 表示编译时刻的日期字符串，例如："25 Dec 2007"
    _TIME_ 表示编译时刻的时间字符串，例如："12:30:55"
    _STDC_ 判断该文件是不是定义成标准C程序
}
func(main){
    1. void 和 int 表明声明不同的主函数返回值，不声明则默认返回值为int整型。
    2. int main可移植性强。
    3. C语言从来没声明过void main，只声明过main()。
    4. 抛弃一切用void main编写C程序的习惯！
void main() { /* ... */ } 和 main() { /* ... */ }   摒弃 (考虑系统调用exit和bash编程返回状态) 系统需要
int main() { /* ... */ }                            可接受
int main(int argc, char* argv[]) { /* ... */ }      推荐
    
}

convert(int){
转换 \ddd \xddd
    \ddd  ddd表示1~3个八进制数字，这个转义符表示的字符就是给定的八进制值所代表的字符
    \xddd 与上例类似，只是八进制数换成了16进制数。
    printf("\x123456\n"); 计算机将\x1234看成了整体，因为超出了255，而无法显示，16进制的56在ascii中正好是V
    printf("\123456\n");  S456其中8进制123在ascii中正好是S，456不进行翻译。
}