
    GNU C的一大特色（却不被初学者所知）就是__attribute__机制。__attribute__是用来设置函数属性（Function Attribute）、
变量属性（Variable Attribute）和类型属性（Type Attribute）。
__attribute__书写特征是：__attribute__前后都有两个下划线，并切后面会紧跟一对原括弧，括弧里面是相应的__attribute__参数。
__attribute__语法格式为：
__attribute__ ((attribute-list))
其位置约束为：放于声明的尾部";"之前。


    函数属性可以帮助开发者把一些特性添加到函数声明中，从而可以使编译器在错误检查方面的功能更强大。
__attribute__机制也很容易同非GNU应用程序做到兼容之功效。
    GNU CC需要使用 –Wall编译器来击活该功能，这是控制警告信息的一个很好的方式。

同时使用多个属性

可以在同一个函数声明里使用多个__attribute__，并且实际应用中这种情况是十分常见的。使用方式上，你可以选择两个单独的
__attribute__，或者把它们写在一起，可以参考下面的例子：
/* 把类似printf的消息传递给stderr 并退出 */
extern void die(const char *format, ...)
     __attribute__((noreturn))
     __attribute__((format(printf, 1, 2)));
或者写成
extern void die(const char *format, ...)
     __attribute__((noreturn, format(printf, 1, 2)));
如果带有该属性的自定义函数追加到库的头文件里，那么所以调用该函数的程序都要做相应的检查。

#if __GNUC__ >= 3
#undef   inline
#define  inline         inline __attribute__((always_inline))
#define  __noinline     __attribute__((noinline))
#define  __pure         __attribute__((pure))
#define  __const        __attribute__((const))
#define  __noreturn     __attribute__((noreturn))
#define  __malloc       __attribute__((malloc))
#define  __must_check   __attribute__((warn_unused_result))
#define  __deprecated   __attribute__((deprecated))
#define  __used         __attribute__((used))
#define  __unused       __attribute__((unused))
#define  __packed       __attribute__((packed))
#define  __align(x)     __attribute__((aligned(x)))
#define  __align_max    __attribute__((aligned))
#define  likely(x)      __attribute__((__builtin_expect(!!(x), 1)))
#define  unlikely(x)    __attribute__((__builtin_expect(!!(x), 0)))
#else
#define  inline      
#define  __noinline  
#define  __pure      
#define  __const     
#define  __noreturn  
#define  __malloc    
#define  __must_check
#define  __deprecated
#define  __used      
#define  __unused    
#define  __packed    
#define  __align(x)  
#define  __align_max 
#define  likely(x)   
#define  unlikely(x) 
#endif


inline(内联函数){
1. 编译器会把"内联"函数的全部代码拷贝到调用函数的地方。
   函数很小、很简单且使用的地方不是特别多时。
   如果调用方法传递的函数参数是一个常数时，内联函数特别有用。
2. 内联函数性能和宏一样，同时可以做类型检查。

static inline int foo(void){/*  */}   
从技术角度看，该关键字只是提示----告诉编译器要对给定函数进行内联。

static inline __attribute__((always_inline)) int foo(void){/*   */}
告诉编译器对指定的函数"总是"执行内联操作。

只有最有价值的函数才值得考虑使用内联函数。
}

noinline(避免内联){
1. GCC在最激进的优化模式下，GCC会自动选择看起来合适于优化的函数，并执行优化。
   某些情况下，编程人员会发现GCC自动内联导致函数执行行为不对。其中一个例子就是__builtin_return_address.
   
   __attribute__((noinline)) int foo(void){/*    */}
为了避免GCC自动内联，使用关键字noline   
}

pure(纯函数){
    "纯函数"是指不会带来其他影响，其返回值只受函数参数或者nonvolatile全局变量影响。任何参数或全局访问都只支持"只读"模式。
循环优化和消除子表达式的场景可以使用纯函数。纯函数是通过关键字pure来标识的：
__attribute__((pure)) int foo(int val){/*    */}
一个常见的示例是strlen()。只要输入相同，对于多次调用，该函数的返回值都是一样的。因此可以从循环中抽取出来，只调用一次：
    for(i=0; i<strlen(p); i++)
        printf("%c", toupper(p[i]));

如果编译器不知道strlen()是纯函数，它就会在每次循环迭代时都调用该函数；

size_t len;
len = strlen(p);
    for(i=0; i<len; i++)
        printf("%c", toupper(p[i]));
或
while(*p)
    printf("%c", toupper(p[i]));
}

const(常函数){
常函数一种严格的纯函数。常函数不能访问全局变量，参数不能是指针类型。因此，常函数的返回值值和值传递的参数值有关。
和纯函数相比，常函数可以做进一步优化。数学函数，比如abs(),是一种常函数。
__attribute__((const)) int foo(int val) {/*   */}
和纯函数一样，常函数返回void类型也是非法且没有任何意义的。

该属性只能用于带有数值类型参数的函数上。当重复调用带有数值参数的函数时，由于返回值是相同的，所以此时编译器可以进行
优化处理，除第一次需要运算外，其它只需要返回第一次的结果就可以了，进而可以提高效率。该属性主要适用于没有静态状态
（static state）和副作用的一些函数，并且返回值仅仅依赖输入的参数。

extern int square(int n) __attribute__((const));
通过添加__attribute__((const))声明，编译器只调用了函数一次，以后只是直接得到了相同的一个返回值。
}

noreturn(没有返回值的函数){
如果一个函数没有返回值，可能因为他一直调用exit()函数，编程人员可以通过noreturn关键字标识函数没有返回值，
也告诉编译器函数没有返回值。
__attribute__((noreturn)) void foo(int val){/*   */};
编译器知道调用的函数绝对不会有返回值时，还可以做些额外的优化。


该属性通知编译器函数从不返回值，当遇到类似函数需要返回值而却不可能运行到返回值处就已经退出来的情况，该属性可以
避免出现错误信息。C库函数中的abort()和exit()的声明格式就采用了这种格式，如下所示：

extern void exit(int)   __attribute__((noreturn));
extern void abort(void) __attribute__((noreturn));

为了方便理解，大家可以参考如下的例子：
//name: noreturn.c ；测试__attribute__((noreturn))
extern void myexit();
int test(int n)
{
    if (n > 0)
    {
      myexit();
       /* 程序不可能到达这里*/
    }
    else
      return 0;
}
编译显示的输出信息为：
$gcc –Wall –c noreturn.c
noreturn.c: In function "test":
noreturn.c:12: warning: control reaches end of non-void function
警告信息也很好理解，因为你定义了一个有返回值的函数test却有可能没有返回值，程序当然不知道怎么办了！

加上__attribute__((noreturn))则可以很好的处理类似这种问题。把
extern void myexit();
修改为：
extern void myexit() __attribute__((noreturn));
之后，编译不会再出现警告信息。

}

malloc(分配内存的函数)
{
如果函数返回的指针永远都不会"别名指向"已有内存----几乎是确定的，因为函数已经分配了新的内存，并返回指向它的指针----
编程人员可以确定malloc关键字来标识该函数，从而编译器可以执行合适优化。
__attribute__((malloc)) void* get_page(void){/*   */}
}

warn_unused_result(强制使用方检查返回值){
1. 这不是一个优化方案，而是编程辅助。warn_unused_result属性告诉编译器在函数的返回值没有保存或在条件语句中使用时就生成
一条告警信息

__attribute__((warn_unused_result)) int foo(void){/*   */}
read就很适合该属性，这些函数不能返回void
}

deprecated(已废弃){
__attribute__((deprecated)) void foo(void){/*   */}
deprecated属性要求编译器在函数调用时，在调用方生成一个告警信息。
}

used(把函数标识为已使用){
在某些情况下，编译器不可见的一些代码调用了某个特定的函数。给函数添加used属性使得编译器可以告诉程序该函数，即使
该函数看起来似乎从未被引用：
static __attribute__((used)) void foo(void){/*   */}
因此，编译器会输出生成的汇编代码，不会显示函数没有被使用的告警信息。

}

unused(把函数或参数标识为未使用的){
unused属性告诉编译器给定函数或函数参数是未使用的，不要发出任何相关的告警信息：
int foo (long __attribute__((unused)) value) {/*   */}
当你通过-W或-Wunused选项编译，并且希望捕获未使用的函数参数，但在某些情况下有些函数需要匹配预定义的签名，
在这种情况下就可以使用unused属性。
}

packed(对结构体进行紧凑存储-aligned属性使被设置的对象占用更多的空间，相反的，使用packed可以减小对象占用的空间){

packed属性告诉编译器的 一个类型或变量应该在内存中进行紧凑存储，使用尽可能少的空间，可能不依赖对其需求。
如果在结构体或联合体上制定该属性，就需要对所有变量进行紧凑存储。如果只对某个变量指定该属性，就只会紧凑存储该特定对象。
以下使用方式会对结构体中的所有变量进行紧凑存储，尽可能占用最小的空间：
struct __attribute__((packed)) foo {... ...};

static struct swsusp_header { 
char reserved[PAGE_SIZE - 20 - sizeof(swp_entry_t)]; 
swp_entry_t image; 
char orig_sig[10]; 
char sig[10]; 
} __attribute__((packed, aligned(PAGE_SIZE))) swsusp_header;

}

aligned(增加变量的对齐-aligned属性使被设置的对象占用更多的空间，相反的，使用packed可以减小对象占用的空间){
除了支持变量紧凑存储，GCC还支持编程人员为给定变量指定最小的对齐方式。
这样，GCC就会对指定的变量按大于等于指定值进行对齐，这与体系结构和ABI所指定的最小对齐方式相反。
beard_length最小对齐方式是32个字节。
int beard_length __attribute__((aligned(32))) = 0; #
除了指定特定最小的对齐值外，GCC把给定类型按最小对其之中的最大值进行分配，这样可以适用于所有的数据类型。
GCC把parrot_height按其使用最大值进行对齐，很可能是按照double类型进行对齐。
short parrot_height __attribute__((aligned)) = 5;  #

char __nosavedata swsusp_pg_dir[PAGE_SIZE] __attribute__ ((aligned (PAGE_SIZE)));

}

asm(把全局变量放到寄存器中){
register int *foo asm("ebx");
}

likely(分支注释){
GCC支持编程人员对表达式的期望值进行标注(annotate)----举个例子：告诉编译器某个条件语句是真还是假。
GCC可以执行块重新排序和其他优化措施，从优化条件分支的性能。

#define likely(x)       __builtin_expect(!!(x), 1)
#define unlikely(x)     __builtin_expect(!!(x), 0)
}

typeof(获取表达式类型){
GCC提供了typeof()关键字，可以获取给定表达式的类型。从语义上看，该关键字的工作方式和sizeof类似。
比如，一下表达式返回x指向的对象的类型：
typeof(*x);
可以通过以下表达式声明数组
typeof(*x) y[42];

安全宏
#define min(x, y) ({ \
    typeof(x) _x = (x); \
    typeof(y) _y = (y); \
    (void) (&_x == &_y);    \
    _x < _y ? _x : _y; })

#define max(x, y) ({ \
    typeof(x) _x = (x); \
    typeof(y) _y = (y); \
    (void) (&_x == &_y);    \
    _x > _y ? _x : _y; })
    
}

alginof(获取类型的对齐方式){
GCC提供了关键字alignof来获取给定对象的对齐方式。其值是架构和ABI特有的。
如果当前架构并没有需要的对齐方式，关键字会返回ABI推荐的对齐方式。否则，关键字会返回最小的对齐值。
其语法和sizeof完全相同
__alignof__(int);
}

offsetof(结构体中成员变量的偏移){
#define offsetof(type,number) __built_offsetof(type number)
}

__builtin_return_address(获取函数的返回地址){
void *__builtin_return_address(unsigned int level);
}

case(条件范围){
  case low ... high:
  
  switch(val){
  case 1...10:
  /*  */
  break;
  case 11...20:
  /*  */
  break;
  default:
  /*....*/
  }

}

array(零长度的数组){

    struct iso_block_store 
    { 
    atomic_t refcount; 
    size_t data_size; 
    quadlet_t data[0]; 
    };
}

__builtin_prefetch(预抓取){
另一种重要的性能改进方法是把必需的数据缓存在接近处理器的地方。缓存可以显著减少访问数据花费的时间。大多数现代处理器都有三类内存：
    一级缓存通常支持单周期访问
    二级缓存支持两周期访问
    系统内存支持更长的访问时间

为了尽可能减少访问延时并由此提高性能，最好把数据放在最近的内存中。手工执行这个任务称为预抓取。GCC 通过内置函数 __builtin_prefetch 
支持数据的手工预抓取。在需要数据之前，使用这个函数把数据放到缓存中。如下所示，__builtin_prefetch 函数接收三个参数：
    数据的地址
    rw 参数，使用它指明预抓取数据是为了执行读操作，还是执行写操作
    locality 参数，使用它指定在使用数据之后数据应该留在缓存中，还是应该清除

void __builtin_prefetch( const void *addr, int rw, int locality );
Linux 内核经常使用预抓取。通常是通过宏和包装器函数使用预抓取。清单 6 是一个辅助函数示例，它使用内置函数的包装器
（见 ./linux/include/linux/prefetch.h）。这个函数为流操作实现预抓取机制。使用这个函数通常可以减少缓存缺失和停顿，
从而提高性能。

}

format(检查函数声明和函数实际调用参数之间的格式化字符串是否匹配){
该__attribute__属性可以给被声明的函数加上类似printf或者scanf的特征，它可以使编译器检查函数声明和函数实际调用参数之间的格式化字符串是否匹配。该功能十分有用，尤其是处理一些很难发现的bug。

format的语法格式为：
format (archetype, string-index, first-to-check)

format属性告诉编译器，按照printf, scanf, strftime或strfmon的参数表格式规则对该函数的参数进行检查。“archetype”指定是哪种风格；“string-index”指定传入函数的第几个参数是格式化字符串；“first-to-check”指定从函数的第几个参数开始按上述规则进行检查。
具体使用格式如下：
__attribute__((format(printf,m,n)))
__attribute__((format(scanf,m,n)))

其中参数m与n的含义为：
m：第几个参数为格式化字符串（format string）；
n：参数集合中的第一个，即参数“…”里的第一个参数在函数参数总数排在第几，注意，有时函数参数里还有“隐身”的呢，后面会提到；

在使用上，__attribute__((format(printf,m,n)))是常用的，而另一种却很少见到。下面举例说明，其中myprint为自己定义的一个带有可变参数的函数，其功能类似于printf：
//m=1；n=2
extern void myprint(const char *format,...) __attribute__((format(printf,1,2)));
//m=2；n=3
extern void myprint(int l，const char *format,...) __attribute__((format(printf,2,3)));

需要特别注意的是，如果myprint是一个函数的成员函数，那么m和n的值可有点“悬乎”了，例如：
//m=3；n=4
extern void myprint(int l，const char *format,...) __attribute__((format(printf,3,4)));

}

constructor(destructor){
若函数被设定为constructor属性，则该函数会在main()函数执行之前被自动的执行。类似的，若函数被设定为destructor属性，则该函数会在main()函数执行之后或者exit()被调用后被自动的执行。拥有此类属性的函数经常隐式的用在程序的初始化数据方面。

这两个属性还没有在面向对象C中实现。
}