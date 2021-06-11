https://github.com/ztxgithub/git_cplus_summary
https://github.com/15110671453/LibEvent_Linux_BatchFile
https://github.com/bat-battle 扩展

https://github.com/maple2rain/maple2rain.github.com
https://github.com/Wang-Yu-Chao/graysmog.github.io

https://github.com/ztxgithub/git_cplus_summary/tree/master/summary
https://github.com/czs108/Cpp-Primer-5th-Note-CN/tree/master/Chapter-9%20%20Sequential%20Containers
https://github.com/Wang-Yu-Chao/graysmog.github.io/blob/2dd8ebb9458bd2cc0c77a000c61df75f653cabe1/_posts/CPP/sequential-container.md
https://github.com/ZXZxin/ZXNotes/blob/2bbad0803ace94e7b6ea0799bba8289352be7191/C%2B%2B/C%2B%2B/C%2B%2B%E5%9F%BA%E7%A1%80%E7%9F%A5%E8%AF%86%E6%80%BB%E7%BB%93(%E4%B8%80).md
shttps://github.com/xutree/xutree.github.io-src/blob/f7592f0500e5acc71515a8e222ddb786356abfc9/content/articles/C%2B%2B/C%2B%2B_Primer_Chapter_9.md

不要等你把一门语言完全掌握了再开始行动。

https://wandbox.org/ # compile

root/rtu/otdr/dsaa
/root/cppd

因为头文件包含在多个源文件中，所以不应该含有变量或函数的定义。例外是，头文件可以定义类，值在编译时已经确定的const对象和inline函数。
const变量应该在一个文件里定义并且初始化，所以在头文件里为它添加extern声明，以便于多个文件共享。
C++中有些函数可以声明为内联（inline）函数，编译器在遇到内联函数时会尝试直接扩展相关代码而不是进行实际的函数调用。
C++保证，删除0值的指针是安全的。
do while 语句别忘了最后的分号。
给函数的返回值赋值会让人感到惊讶，但当一个函数返回的是一个引用的时候，这是很自然的事情。如果不希望返回值被修改，那么请把返回值声明为const
内联函数应该在头文件里定义，这一点不同于其它函数。
编译器隐式的将在类内定义的函数认为是内联函数。

types(built-in){
算数类型分为两类：整型(integral type)、浮点型(floating-point type)
bool        boolean                           bool类型的取值是true或false
char        character                         一个char的大小和一个机器字节一样，确保可以存放机器基本字符集中任意字符对应的数字值
wchar_t     wide character                    确保可以存放机器最大扩展字符集中的任意一个字符。
char16_t    Unicode character                 
char32_t    Unicode character                 
short       short integer                     
int         integer                           
long        long integer                      
long long   long integer                      在整型类型大小方面，C++规定short ≤ int ≤ long ≤ long long (long long是C++11定义的类型)
float       single-precision floating-point   单精度(single-precision)
double      double-precision floating-point   双精度(double-precision)
long double extended-precision floating-point 扩展精度(extended-precision)

除去布尔型和扩展字符型，其他整型可以分为带符号（signed）和无符号（unsigned）两种。带符号类型可以表示正数、负数和0，无符号类型只能表示大于等于0的数值。
类型int、short、long和long long都是带符号的，在类型名前面添加unsigned可以得到对应的无符号类型，如unsigned int。
字符型分为char、signed char和unsigned char三种，但是表现形式只有带符号和无符号两种。类型char和signed char并不一样， char的具体形式由编译器（compiler）决定。
}
types(conversions){
进行类型转换时，类型所能表示的值的范围决定了转换的过程。
    把非布尔类型的算术值赋给布尔类型时，初始值为0则结果为false，否则结果为true。
    把布尔值赋给非布尔类型时，初始值为false则结果为0，初始值为true则结果为1。
    把浮点数赋给整数类型时，进行近似处理，结果值仅保留浮点数中的整数部分。
    把整数值赋给浮点类型时，小数部分记为0。如果该整数所占的空间超过了浮点类型的容量，精度可能有损失。
    赋给无符号类型一个超出它表示范围的值时，结果是初始值对无符号类型表示数值总数（8比特大小的unsigned char能表示的数值总数是256）取模后的余数。
    赋给带符号类型一个超出它表示范围的值时，结果是未定义的（undefined）。
避免无法预知和依赖于实现环境的行为。
}
types(literals){
以0开头的整数代表八进制（octal）数，以0x或0X开头的整数代表十六进制（hexadecimal）数。在C++14中，0b或0B开头的整数代表二进制（binary）数。
整型字面值具体的数据类型由它的值和符号决定。
 - Character and character string lierals
| Prefix | Meaning                      | Type     |
| ------ | ---------------------------- | -------- |
| u      | Unicode 16 character         | char16_t |
| U      | Unicode 32 character         | char32_t |
| L      | wide charater                | wchar_t  |
| u8     | utf-8 (string literals only) | char     |

- Integer literals and Floating-point literals
| Suffix | Minimum type | Suffix | Type        |
| ------ | ------------ | ------ | ----------- |
| u/U    | unsigned     | f/F    | float       |
| l/L    | long         | l/L    | long double |
| ll/LL  | long long    |
使用一个长整型字面值时，最好使用大写字母L进行标记，小写字母l和数字1容易混淆。 # 
}
variables(定义){
用花括号初始化变量称为列表初始化（list initialization）。
当用于内置类型的变量时，如果使用了列表初始化并且初始值存在丢失信息的风险，则编译器会报错。
long double ld = 3.1415926536; 
int a{ld}, b = {ld}; // error: narrowing conversion required 
int c(ld), d = ld; // ok: but value will be truncated
建议初始化每一个内置类型的变量。
}
variables(变量声明和定义的关系){
如果想声明一个变量而不定义它，就在变量名前添加关键字extern，并且不要显式地初始化变量。 #
extern int i; // declares but does not define i
int j;      // declares and defines j
extern语句如果包含了初始值就不再是声明了，而变成了定义。

C++支持两种初始化变量的方式：复制初始化和直接初始化。要注意的是，C++中赋值和初始化是两个不同的概念。
}
variables(名字的作用域){
最好在第一次使用变量时再去定义它。这样做更容易找到变量的定义位置，并且也可以赋给它一个比较合理的初始值。 # 
作用域操作符::来覆盖默认的作用域规则。
}
variables(引用){ 别名
引用为对象起了另外一个名字，引用类型引用（refers to）另外一种类型。通过将声明符写成&d的形式来定义引用类型，其中d是变量名称。
int ival = 1024;
int &refVal = ival; // refVal refers to (is another name for) ival
int &refVal2;       // error: a reference must be initialized
定义引用时，程序把引用和它的初始值绑定（bind）在一起，而不是将初始值拷贝给引用。
一旦初始化完成，将无法再令引用重新绑定到另一个对象，因此引用必须初始化。 #
引用只能绑定在对象上，不能与字面值或某个表达式的计算结果绑定在一起。     # 
}
variables(指针){
旧版本程序通常使用NULL（预处理变量，定义于头文件cstdlib中，值为0）给指针赋值，但在C++11中，最好使用nullptr初始化空指针。

建议初始化所有指针。
void*是一种特殊的指针类型，可以存放任意对象的地址，但不能直接操作void*指针所指的对象。
}
const(const的引用){  在全局作用域定义的const常量只是该文件的局部变量，除非在前面加上extern加以全局说明。
把引用绑定在const对象上即为对常量的引用（reference to const）。对常量的引用不能被用作修改它所绑定的对象。
const int ci = 1024;
const int &r1 = ci;     // ok: both reference and underlying object are const
r1 = 42;        // error: r1 is a reference to const
int &r2 = ci;   // error: non const reference to a const object

允许为一个常量引用绑定非常量的对象、字面值或者一般表达式。
double dval = 3.14;
const int &ri = dval;
}
constexpr(C++11){
C++11允许将变量声明为constexpr类型以便由编译器来验证变量的值是否是一个常量表达式。
constexpr int mf = 20;          // 20 is a constant expression
constexpr int limit = mf + 1;   // mf + 1 is a constant expression
constexpr int sz = size();      // ok only if size is a constexpr function
指针和引用都能定义成constexpr，但是初始值受到严格限制。constexpr指针的初始值必须是0、nullptr或者是存储在某个固定地址中的对象。
}
typedef(C++11){
类型别名是某种类型的同义词，传统方法是使用关键字typedef定义类型别名。
typedef double wages; // wages is a synonym for double
C++11使用关键字using进行别名声明（alias declaration），作用是把等号左侧的名字规定成等号右侧类型的别名。
using SI = Sales_item; // SI is a synonym for Sales_item
}
auto(C++11){
C++11新增auto类型说明符，能让编译器自动分析表达式所属的类型。auto定义的变量必须有初始值。
// the type of item is deduced from the type of the result of adding val1 and val2
auto item = val1 + val2;    // item initialized to the result of val1 + val2
编译器推断出来的auto类型有时和初始值的类型并不完全一样。
}
decltype(C++11){
C++11新增decltype类型指示符，作用是选择并返回操作数的数据类型，此过程中编译器不实际计算表达式的值。
decltype(f()) sum = x;  // sum has whatever type f returns

decltype处理顶层const和引用的方式与auto有些不同，如果decltype使用的表达式是一个变量，则decltype返回该变量的类型（包括顶层const和引用）。
const int ci = 0, &cj = ci;
decltype(ci) x = 0;     // x has type const int
decltype(cj) y = x;     // y has type const int& and is bound to x
decltype(cj) z;     // error: z is a reference and must be initialized
}
using(){
使用using声明后就无须再通过专门的前缀去获取所需的名字了。
using std::cout;
程序中使用的每个名字都需要用独立的using声明引入。
头文件中通常不应该包含using声明。
}
string(初始化){
标准库类型string表示可变长的字符序列，定义在头文件string中。
string s1;          // 默认构造函数，s1为空字符串
string s2(s1);      // 将s2初始化为s1的副本
string s2 = s1      // 将s2初始化为s1的副本
string s3("value")  // 将s3初始化为 "value" 的副本
string s3 = "value" // 将s3初始化为 "value" 的副本
string s4(n,'c')    // 将s4初始化为含n个 'c' 的字符串
string的输入操作：
    读取时忽略开头所有的空白符（如空格，换行符，制表符）；
    读取字符直至再次遇到空白符；
    
   getline是读入输入流的下一行，并保存在string对象中。但行中不包含 换行符，getline只要遇到换行符，
即便是输入的第一个字符，getline也会停止读入并返回。如果第一个字符是换行符，则string对象为空。
# string word;
# while(getline(cin,word)){	//输入"ctrl+z"可以结束
# 	cout << word << endl;
# }

}
string(操作){
s.empty()           s为空返回true，否则返回false
s.size()            返回s中的字符个数
s[n]                范围s中位置为n的字符，位置从0开始计数
s1 + s2             连接s1，s2成一个新的字符串
s1 = s2             把s1的内容替换成s2的内容
s1 == s2            比较s1，s2的内容，相等返回true，否则false
!=, <, <=, >, >=    就是这些符号表达的意思

size()返回是string::size_type
因为int类型所能表示的范围实在有限，所以string类型定义了新的配套类型。
如果一个表达式中已经有了size函数就不要再使用int了，这样可以避免混用int和unsigned int可能带来的问题。

# 与字符串字面值的连接
+ 操作符的左右操作数必须有一个是 string 类型
string s6 = "hello" + "world"; //error:两个字面值不能相加 
string s7 = "hello" + "," + s2; //error
为了与C兼容，C++语言中的字符串字面值并不是标准库string的对象。
为了兼容C语言，C++中的所有字符串字面值都由编译器自动在末尾添加一个空字符。

# 下标操作
通过 [] 来取得string对象中的字符。且下标操作可以做左值：
for(string::size_type i=0; i!=s.size(); ++i){
	s[i] = '*';	//注意是 '*'，不是 "*"
}
建议使用C++版本的C标准库头文件。C语言中名称为name.h的头文件，在C++中则被命名为cname。
}
string(旧代码的接口){
1. 允许使用以空字符结束的字符数组来初始化string对象或为string对象赋值。
2. 在string对象的加法运算中，允许使用以空字符结束的字符数组作为其中一个运算对象（不能两个运算对象都是）。
3. 在string对象的复合赋值运算中，允许使用以空字符结束的字符数组作为右侧运算对象。
string提供了一个名为c_str的成员函数，返回const char*类型的指针，指向一个以空字符结束的字符数组，数组的数据和string对象一样。

string s("Hello World");        #  s holds Hello World
char *str = s;                  #  error: can't initialize a char* from a string
const char *str = s.c_str();    #  ok

}
for(C++11){
提供了范围for（range for）语句，可以遍历给定序列中的每个元素并执行某种操作。
for (declaration : expression)
    statement
    expression部分是一个对象，用于表示一个序列。declaration部分负责定义一个变量，
该变量被用于访问序列中的基础元素。每次迭代，declaration部分的变量都会被初始化为expression部分的下一个元素值。
# string str("some string");
# // print the characters in str one character to a line
# for (auto c : str)      // for every char in str
#     cout << c << endl;  // print the current character followed by a newline
如果想在范围for语句中改变string对象中字符的值，必须把循环变量定义成引用类型。
下标运算符接收的输入参数是string::size_type类型的值，表示要访问字符的位置，返回值是该位置上字符的引用。
下标数值从0记起，范围是0至size - 1。使用超出范围的下标将引发不可预知的后果。
}


sequential(){
    顺序容器（sequential container）为程序员提供了控制元素存储和访问顺序的能力。这种顺序不依赖于元素的值，
而是与元素加入容器时的位置相对应。与之相对的，有序和无序关联容器，则根据关键字的值来存储元素。
- vector：可变大小数组。支持快速随机访问。在尾部之外的位置插入或删除元素可能很慢。
- deque：双端队列。支持快速随机访问。在头尾位置插入／删除元素速度很快。
- list：双向链表。只支持双向顺序访问。在list中任何位置进行插入／删除操作速度都很快。
- forward_list：单向链表。只支持单向顺序访问。在链表任何位置进行插入／删除操作速度都很快。
- array：固定大小数组。支持快速随机访问。不能添加或删除元素。(相比内置数组更安全、更容易使用)
- string：与vector相似的容器，专门用于保存字符。
}
vector(){ 对象的集合
要使用vector，需包含适当的头文件和using声明：
#include <vector>
using std::vector;
注意：vector能容纳绝大多数类型的对象作为其元素，但是因为引用不是对象，所以不存在包含引用的vector。
vector的size成员函数，返回的类型也是size_type，但是是由特定的类型定义的，如：vector<int>::size_type是正确的，vector::size_type是错误的。
vector对象的小标运算符可用于访问已存在的元素，而不能用于添加元素

2. 定义和初始化vector对象
#include <vector>
using namespace std;
vector<T> v1;               //v1是一个空vector，他潜在的元素是T类型的，执行默认初始化
vector<T> v2(v1);           //v2包含v1所有元素的副本        
vector<T> v2 = v1;          //等价于v2(v1)
vector<T> v3(n, val);       //v3包含了n个重复的元素，每个元素的值都是val
vector<T> v4(n);            //v4包含了n个重复地执行了默认值初始化的对象
vector<T> v5{a, b, c};      //v5包含了初始值个数的元素，每个元素被赋予了相应的初始值
vector<T> v5 = {a, b, c};   //与上式等价
vector<T> v6(begin(T_arr), end(T_arr));//使用数组初始化vector对象，T_arr是数组
vector<T> v7(T_arr + n, T_arr + m);    //使用数组T_arr的部分元素初始化vector对象，前提是n与m的范围是合法的

初始化vector对象时如果使用圆括号，可以说提供的值是用来构造（construct）vector对象的；
如果使用的是花括号，则是在列表初始化（list initialize）该vector对象。
}

vector(数组){
可以使用数组来初始化vector对象，但是需要指明要拷贝区域的首元素地址和尾后地址。
int int_arr[] = {0, 1, 2, 3, 4, 5};
vector<int> ivec(begin(int_arr), end(int_arr));
}
iterator(){ 
first 和 last，或 beg 和 end -> [ first, last )
因为end返回的迭代器并不实际指向某个元素，所以不能对其进行递增或者解引用的操作。
在for或者其他循环语句的判断条件中，最好使用!=而不是<。所有标准库容器的迭代器都定义了==和!=，但是只有其中少数同时定义了<运算符。

如果vector或string对象是常量，则只能使用const_iterator迭代器，该迭代器只能读元素，不能写元素。
begin和end返回的迭代器具体类型由对象是否是常量决定，如果对象是常量，则返回const_iterator；如果对象不是常量，则返回iterator。
C++11新增了cbegin和cend函数，不论vector或string对象是否为常量，都返回const_iterator迭代器。


1. *iter 返回迭代器 iter 所指向的元素的引用
2. iter->mem 对 iter 进行解引用，获取指定元素中名为 mem 的成员。等效于 (*iter).mem
3. ++iter iter++ 给 iter 加 1，使其指向容器里的下一个元素
4. --iter iter-- 给 iter 减 1，使其指向容器里的前一个元素
5. iter1 == iter2 
6. iter1 != iter2  比较两个迭代器是否相等（或不等）。当两个迭代器指向同一个容器中的同一个元素，
                或者当它们都指向同一个容器的超出
                
在支持随机访问的两个容器vector和deque中，还支持另外一些更加灵活地运算：
6. iter + n 
7. iter - n  n，将产生指向容器中前面（后面）第 n 个元素的迭代器。新计算出来的迭代器必须指向容器中的元素或超出容器末端的下一位置
8. iter1 += iter2 
9. iter1 -= iter2 这里迭代器加减法的复合赋值运算：将 iter1 加上或减去 iter2 的运算结果赋给 iter1
10. iter1 - iter2 两个迭代器的减法，其运算结果加上右边的迭代器即得左边的迭代器。这两个迭代器必须指向同一个容器中的元素或超出容器末端的下一位置
11. >, >=, <, <= 迭代器的关系操作符。当一个迭代器指向的元素在容器中位于另一个迭代器指向的元素之前，则前一个迭代器小于后一

difference_type类型用来表示两个迭代器间的距离，这是一种带符号整数类型。
}
rvalue_lvalue(){
    C++的表达式分为右值（rvalue）和左值（lvalue）。当一个对象被用作右值的时候，用的是对象的值（内容）；
当对象被用作左值时，用的是对象的地址。需要右值的地方可以用左值代替，反之则不行。
    赋值运算符需要一个非常量左值作为其左侧运算对象，返回结果也是一个左值。
    取地址符作用于左值运算对象，返回指向该运算对象的指针，该指针是一个右值。
    内置解引用运算符、下标运算符、迭代器解引用运算符、string和vector的下标运算符都返回左值。
    内置类型和迭代器的递增递减运算符作用于左值运算对象。前置版本返回左值，后置版本返回右值。
}
conversions(){
命名的强制类型转换(named cast)形式如下：
    cast-name<type>(expression);
其中type是转换的目标类型，expression是要转换的值。如果type是引用类型，则转换结果是左值。
cast-name是static_cast、dynamic_cast、const_cast和reinterpret_cast中的一种，用来指定转换的方式。
    dynamic_cast支持运行时类型识别。
    任何具有明确定义的类型转换，只要不包含底层const，都能使用static_cast。
    const_cast只能改变运算对象的底层const，不能改变表达式的类型。同时也只有const_cast能改变表达式的常量属性。const_cast常常用于函数重载。
    reinterpret_cast通常为运算对象的位模式提供底层上的重新解释。
    
早期版本的C++语言中，显式类型转换包含两种形式：
type (expression);    // function-style cast notation
(type) expression;    // C-language-style cast notation
}
except(try语句块和异常处理){
    异常（exception）是指程序运行时的反常行为，这些行为超出了函数正常功能的范围。
当程序的某一部分检测到一个它无法处理的问题时，需要使用异常处理（exception handling）。

异常处理机制包括throw表达式（throw expression）、try语句块（try block）和异常类（exception class）。
    异常检测部分使用throw表达式表示它遇到了无法处理的问题（throw引发了异常）。
    异常处理部分使用try语句块处理异常。try语句块以关键字try开始，并以一个或多个catch子句（catch clause）结束。try语句块中代码抛出的异常通常会被某个catch子句处理，catch子句也被称作异常处理代码（exception handler）。
    异常类用于在throw表达式和相关的catch子句之间传递异常的具体信息。
    
throw表达式（A throw Expression）
    throw表达式包含关键字throw和紧随其后的一个表达式，其中表达式的类型就是抛出的异常类型。
    
try语句块的通用形式：
    try {
        program-statements
    } 
    catch (exception-declaration) {
        handler-statements
    } 
    catch (exception-declaration) {
        handler-statements
    } // . . .

try语句块中的program-statements组成程序的正常逻辑，其内部声明的变量在块外无法访问，即使在catch子句中也不行。

exception -- bad_cast
          -- bad_alloc
          -- runtime_error
            |-- overflow_error
             -- underflow_error
             -- range_error
          -- logic_error
            |-- domain_error
             -- invalid_argument
             -- out_of_range
             -- length_error
    只能以默认初始化的方式初始化exception、bad_alloc和bad_cast对象，不允许为这些对象提供初始值。
其他异常类的对象在初始化时必须提供一个string或一个C风格字符串，通常表示异常信息。
what成员函数可以返回该字符串的string副本。
}
func(){
1. 函数的返回类型不能是数组类型或者函数类型，但可以是指向数组或函数的指针。
int main(int argc, char *argv[]) { /*...*/ } 
int main(int argc, char **argv) { /*...*/ }

要想声明一个可以指向某种函数的指针，只需要用指针替换函数名称即可。
bool lengthCompare(const string &, const string &);
bool (*pf)(const string &, const string &); // uninitialized

可以直接使用指向函数的指针来调用函数，无须提前解引用指针。
pf = lengthCompare; // pf now points to the function named lengthCompare
pf = &lengthCompare; // equivalent assignment: address-of operator is optional

bool b1 = pf("hello", "goodbye");       // calls lengthCompare
bool b2 = (*pf)("hello", "goodbye");    // equivalent call
bool b3 = lengthCompare("hello", "goodbye");    // equivalent call

对于重载函数，编译器通过指针类型决定函数版本，指针类型必须与重载函数中的某一个精确匹配。
void ff(int*);
void ff(unsigned int);
void (*pf1)(unsigned int) = ff; // pf1 points to ff(unsigned)
}
class(成员函数中名字的解析顺序){
成员函数中名字的解析顺序：
    在成员函数内查找该名字的声明，只有在函数使用之前出现的声明才会被考虑。
    如果在成员函数内没有找到，则会在类内继续查找，这时会考虑类的所有成员。
    如果类内也没有找到，会在成员函数定义之前的作用域查找。

// it is generally a bad idea to use the same name for a parameter and a member
int height;   // defines a name subsequently used inside Screen
class Screen
{
public:
    typedef std::string::size_type pos;
    void dummy_fcn(pos height){
        cursor = width * height;  // which height? the parameter
    }
    
private:
    pos cursor = 0;
    pos height = 0, width = 0;
};

可以通过作用域运算符::或显式this指针来强制访问被隐藏的类成员。
# bad practice: names local to member functions shouldn't hide member names
void Screen::dummy_fcn(pos height) {
    cursor = width * this->height;  // member height
    // alternative way to indicate the member
    cursor = width * Screen::height;  // member height
}

# good practice: don't use a member name for a parameter or other local variable
void Screen::dummy_fcn(pos ht) {
    cursor = width * height;  // member height
}
}
class(构造函数初始值列表){  定义如何进行初始化的成员函数称为构造函数。
如果没有在构造函数初始值列表中显式初始化成员，该成员会在构造函数体之前执行默认初始化。
如果成员是const、引用，或者是某种未定义默认构造函数的类类型，必须在初始值列表中将其初始化。
class ConstRef{
public:
    ConstRef(int ii);
private:
    int i;
    const int ci;
    int &ri;
};
// ok: explicitly initialize reference and const members
ConstRef::ConstRef(int ii): i(ii), ci(ii), ri(i) { }
最好令构造函数初始值的顺序与成员声明的顺序一致，并且尽量避免使用某些成员初始化其他成员。
如果一个构造函数为所有参数都提供了默认实参，则它实际上也定义了默认构造函数。
}
class(inline){
    成员函数(member function)的声明必须在类的内部，定义则既可以在类的内部也可以在类的外部。
定义在类内部的函数是隐式的内联函数。

    定义在类内部的成员函数是自动内联的。inline成员函数该与类定义在同一个头文件中。
如果需要显式声明内联成员函数，建议只在类外部定义的位置说明inline。

当成员函数定义在类外时，返回类型中使用的名字位于类的作用域之外，此时返回类型必须指明它是哪个类的成员。
}
class(const){
    C++允许在成员函数的参数列表后面添加关键字const，表示this是一个指向常量的指针。
使用关键字const的成员函数被称作常量成员函数(const member function)。
std::string Sales_data::isbn(const Sales_data *const this)
{ 
    return this->isbn;
}
常量对象和指向常量对象的引用或指针都只能调用常量成员函数.

double Sales_data::avg_price() const { 
    if (units_sold) 
        return revenue / units_sold; 
    else 
        return 0; 
}
}
class(explicit){
explicit关键字只对接受一个实参的构造函数有效。
只能在类内声明构造函数时使用explicit关键字，在类外定义时不能重复。

在要求隐式转换的程序上下文中，可以通过将构造函数声明为explicit的加以阻止。
class Sales_data{
public:
    Sales_data() = default;
    Sales_data(const std::string &s, unsigned n, double p):
        bookNo(s), units_sold(n), revenue(p*n) { }
    explicit Sales_data(const std::string &s): bookNo(s) { }
    explicit Sales_data(std::istream&);
    // remaining members as before
};
}
class(static){
在类外部定义静态成员时，不能重复static关键字，其只能用于类内部的声明语句。

    由于静态数据成员不属于类的任何一个对象，因此它们并不是在创建类对象时被定义的。
通常情况下，不应该在类内部初始化静态成员。而必须在类外部定义并初始化每个静态成员。
一个静态成员只能被定义一次。一旦它被定义，就会一直存在于程序的整个生命周期中。
// define and initialize a static class member
double Account::interestRate = initRate();
}
friend(){
类可以允许其他类或函数访问它的非公有成员，方法是使用关键字friend将其他类或函数声明为它的友元。
class Sales_data 
{
    // friend declarations for nonmember Sales_data operations added
    friend Sales_data add(const Sales_data&, const Sales_data&);
    friend std::istream &read(std::istream&, Sales_data&);
    friend std::ostream &print(std::ostream&, const Sales_data&);
    
    // other members and access specifiers as before
public:
    Sales_data() = default;
    Sales_data(const std::string &s, unsigned n, double p):
    bookNo(s), units_sold(n), revenue(p*n) { }
    Sales_data(const std::string &s): bookNo(s) { }
    Sales_data(std::istream&);
    std::string isbn() const { return bookNo; }
    Sales_data &combine(const Sales_data&);
    
private:
    std::string bookNo;
    unsigned units_sold = 0;
    double revenue = 0.0;
};

// declarations for nonmember parts of the Sales_data interface
Sales_data add(const Sales_data&, const Sales_data&);
std::istream &read(std::istream&, Sales_data&);
std::ostream &print(std::ostream&, const Sales_data&);
友元声明只能出现在类定义的内部，具体位置不限。友元不是类的成员，也不受它所在区域访问级别的约束。
通常情况下，最好在类定义开始或结束前的位置集中声明友元。
封装的好处：
    确保用户代码不会无意间破坏封装对象的状态。
    被封装的类的具体实现细节可以随时改变，而无须调整用户级别的代码。
}
frined(友元再探){

    除了普通函数，类还可以把其他类或其他类的成员函数声明为友元。友元类的成员函数可以访问
此类包括非公有成员在内的所有成员。
class Screen {
    // Window_mgr members can access the private parts of class Screen
    friend class Window_mgr;
    // ... rest of the Screen class
};
友元函数可以直接定义在类的内部，这种函数是隐式内联的。但是必须在类外部提供相应声明令函数可见。
struct X{
    friend void f() { /* friend function can be defined in the class body */ }
    X() { f(); }   // error: no declaration for f
    void g();
    void h();
};
void X::g() { return f(); }     # error: f hasn't been declared
void f();                       # declares the function defined inside X
void X::h() { return f(); }     # ok: declaration for f is now in scope

友元关系不存在传递性。
把其他类的成员函数声明为友元时，必须明确指定该函数所属的类名。
class Screen
{
    // Window_mgr::clear must have been declared before class Screen
    friend void Window_mgr::clear(ScreenIndex);
    // ... rest of the Screen class
};
如果类想把一组重载函数声明为友元，需要对这组函数中的每一个分别声明。
}
mutable(){
    使用关键字mutable可以声明可变数据成员(mutable data member)。可变数据成员永远不会是const的，
即使它在const对象内。因此const成员函数可以修改可变成员的值。

class Screen {
public:
    void some_member() const;
private:
    mutable size_t access_ctr;  // may change even in a const object
    // other members as before
};

void Screen::some_member() const{
    ++access_ctr;   // keep a count of the calls to any member function
    // whatever other work this member needs to do
}

提供类内初始值时，必须使用=或花括号形式。
}
class(返回*this的成员函数){
const成员函数如果以引用形式返回*this，则返回类型是常量引用。
    通过区分成员函数是否为const的，可以对其进行重载。在常量对象上只能调用const版本的函数；
在非常量对象上，尽管两个版本都能调用，但会选择非常量版本。
class Screen 
{
public:
    // display overloaded on whether the object is const or not
    Screen &display(std::ostream &os)
    { do_display(os); return *this; }
    const Screen &display(std::ostream &os) const
    { do_display(os); return *this; }
    
private:
    // function to do the work of displaying a Screen
    void do_display(std::ostream &os) const
    { return; }
    // other members as before
};

Screen myScreen(5,3);
const Screen blank(5, 3);
myScreen.set('#').display(cout);    // calls non const version
blank.display(cout);    // calls const version
}


key(C CPP Java){
1. c++ 比较适用于高性能,高响应,但开发效率与 java 相比较较低.其得益于内存布局的紧凑性,以及内存的局部性.
2. c++ 其中之一重要思想是用对象来管理资源(RAII)
3. c++ 是唯一能够实现自动化资源管理, c 语言是靠程序员显式释放资源, 而像其他现代语言(java) 只是基于垃圾
       收集自动清理内存,但不能自动清理其他啊资源(网络连接,文件符,数据库连接)
}

