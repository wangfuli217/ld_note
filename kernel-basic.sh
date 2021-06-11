http://blog.csdn.net/yunsongice/article/details/5538416

gcc()
{
gcc(attribute)
{
Gcc中C语言的扩展用法
#####################  __attribute__  #########################
在我们看文件系统（File Sytems）或页面缓存（Page Cache）管理内容时，会经常遇到struct address_space数据结构，其定义在include/linux/fs.h中。
1 ]
struct  address_space {
    ... ...
}__attribute__((aligned(sizeof(long))));

2 ]
对于关键字__attribute__，在标准的C语言中是没有的。它是Gcc中对C语言的一个扩展用法。关键字__attribute__可以用来设置一个
函数或数据结构定义的属性。对一个函数设置属性的主要目的是使编译器对函数进行可能的优化。对函数设置属性，是在函数原型定义中设置，
如下面一个例子：

void fatal_error() __attribute__ ((noreturn));
noreturn属性告诉编译器，这个函数不返回给调用者，所以编译器就可以忽略所有与执行该函数返回值有关的代码。

3 ]
属性（attributes）也可以用来设置变量和结构体的成员。
struct mong {
char id;
int code __attribute__ ((align(4)));
};
比如还有deprecated、packed、unused等。并且设置变量或结构体的属性，与设置函数的属性有所不同。

__unused__、__noreturn__、__packed__、__aligned__(m)、always_inline、__noinline__、__deprecated__、warn_unused_result、 
visibility("default")、section (".data")、format (printf, 1, 2)、__pure__

FAST_FUNC __attribute__((regparm(3),stdcall))
GCC对C语言的扩展，更多内容请参考链接。http://gcc.gnu.org/onlinedocs/gcc/C-Extensions.html#C-Extensions
}

#####################  关键字替代  #########################
gcc(asm)
{
内嵌汇编
1]
#define barrier() __asm              __volatile__("": : :"memory")

2]
static inline unsigned long long native_read_msr_safe(unsigned int msr,
                                               int *err)
{
      DECLARE_ARGS(val, low, high);
      asm volatile("2: rdmsr ; xor %[err],%[err]\n"
                  "1:\n\t"
                  ".section .fixup,\"ax\"\n\t"
                  "3:  mov %[fault],%[err] ; jmp 1b\n\t"
                  ".previous\n\t"
                  _ASM_EXTABLE(2b, 3b)
                  : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
                  : "c" (msr), [fault] "i" (- EIO));
      return EAX_EDX_VAL(val, low, high);
}
给出的两段代码都使用了嵌入式汇编。但不同的是关键字的形式不一样。一个使用的是__asm__，另外一个是asm。事实上，
两者的含义都一样。也就是__asm__等同于asm，区别在于编译时，若使用了选项-std和-ansi，则关闭了关键字asm，而其替
代关键字__asm__仍然可以使用。
类似的关键字还有__typeof__和__inline__，其等同于typeof和inline。
}
#####################  typeof  #########################
gcc(typeof)
{
#define container_of(ptr,  type,  member) ({             \
      const typeof( ((type *)0)- >member ) *__mptr = (ptr);  \
      (type *)( (char *)__mptr - offsetof(type,member) );})

从字面意思上理解，typeof就是获取其类型，其含义也正是如此。关键字typeof返回的是表达式的类型，使用上类似于关键字sizeof，
但它的返回值是类型，而不是一个大小。
}
#####################  asmlinkage  #########################
gcc(asmlinkage)
{
asmlinkage在内核源码中出现的频率非常高，它是告诉编译器在本地堆栈中传递参数，与之对应的是fastcall；fastcall是告诉编译器在
通用寄存器中传递参数。运行时，直接从通用寄存器中取函数参数，要比在本地堆栈（内存）中取，速度快很多。

fastcall的使用是和平台相关的，asmlinkage和fastcall的定义都在文件arch/x86/include/asm/linkage.h中。
}

#####################  UL  #########################
gcc(UL)
{
UL通常用在一个常数的后面，标记为"unsigned long"。使用UL的必要性在于告诉编译器，把这个常数作为长型数据对待。
这可以避免在部分平台上，造成数据溢出。例如，在16位的整数可以表示的范围为-32,768 ~ +32,767；一个无符号整型
表示的范围可以达到65,535。使用UL可以帮助当你使用大数或长的位掩码时，写出的代码与平台无关。

#define GOLDEN_RATIO_PRIME_32 0x9e370001UL
#define GOLDEN_RATIO_PRIME_64 0x9e37fffffffc0001UL

}
#####################  const和volatile #########################
gcc(const和volatile)
{
关键字const的含义不能理解为常量，而是理解为"只读"。如int const*x是一个指针，指向一个const整数。这样，指针可以改变，
但整数值却不能改变。然而int *const x是一个const指针，指向整数，整数的值可以改变，但指针不能改变。
下面代码摘自fs/ext4/inode.c。

关键字volatile标记变量可以改变，而没有告警信息。volatile告诉编译器每次访问时，该变量必须重新加载，而不是从拷贝
或缓存中读取。需要使用volatile的场合有，当我们处理中断寄存器时，或者并发进程之间共享的变量。
}
#####################  __volatile__ #########################
gcc(__volatile__)
{
在嵌入式汇编代码中，经常看到__volatile__修饰符，我们提到__volatile__和volatile实际上是等同的，这里不多作强调。
__volatile__修饰符对汇编代码非常重要。它告诉编译器不要优化内联的汇编代码。通常，编译器认为一些代码是冗余和浪费的，
于是就试图尽可能优化这些汇编代码。
}
#####################  likely()和unlikely() #########################

gcc(likely()和unlikely())
{
unlikely（）和likely（）这两个语句也很常见。
在linux内核源码中，unlikely（）和likely（）是两个宏，它告诉编译器一个暗示。现代的CPU都有提前预测语句执行分支
（branch-prediction heuristics）的功能，预测将要执行的指令，以优化执行速度。unlikely（）和likely（）通过编译器
告诉CPU，某段代码是likely，应被预测；某段代码是unlikely，不应被预测。likely（）和unlikely（）
定义在include/linux/compiler.h。
}

#####################  __init,__initdata,__exit,__exitdata #########################
先看linux内核启动时的一段代码，摘自init/main.c。
asmlinkage void __init  start_kernel(void)

函数start_kernel（）有个修饰符__init。__init实际上是一个宏，只有在linux内核初始化是执行的函数或变量前才使用__init。
编译器将标记为__init的代码段存放在一个特别的内存区域里，这个区域在系统初始化后，就会释放。
同理，__initdata用来标记只在内核初始化使用的数据，__exit和__exitdata用来标记结束或关机的例程。这些通常在设备驱动卸载时使用。


2. 宏函数
宏名之后带括号的宏被认为是宏函数。用法和普通函数一样，只不过在预处理阶段，宏函数会被展开。优点是没有普通函数保存寄存器和参数
传递的开销，展开后的代码有利于CPU cache的利用和指令预测，速度快。缺点是可执行代码体积大。
#define min(X, Y)  ((X) < (Y) ? (X) : (Y))
y = min(1, 2);会被扩展成y = ((1) < (2) ? (1) : (2));
宏特殊用法

1. 字符串化(Stringification)
在宏体中，如果宏参数前加个#，那么在宏体扩展的时候，宏参数会被扩展成字符串的形式。如：
#define WARN_IF(EXP) /     do { if (EXP) /             fprintf (stderr, "Warning: " #EXP "/n"); } /     while (0)
WARN_IF (x == 0);会被扩展成：
do { if (x == 0)    fprintf (stderr, "Warning: " "x == 0" "/n"); }while (0);
这种用法可以用在assert中，如果断言失败，可以将失败的语句输出到反馈信息中

2. 连接(Concatenation)
在宏体中，如果宏体所在标示符中有##，那么在宏体扩展的时候，宏参数会被直接替换到标示符中。如：
#define COMMAND(NAME)  { #NAME, NAME ## _command }struct command{    char *name;    void (*function) (void);};
在宏扩展的时候
struct command commands[] ={    COMMAND (quit),    COMMAND (help),    ...};
会被扩展成：
struct command commands[] ={    { "quit", quit_command },    { "help", help_command },    ...};
这样就节省了大量时间，提高效率。

############  必要的编译知识:compile.h ######### 
所有的内核代码，基本都包含了include/linux/compiler.h这个文件，所以它是基础，涵盖了分析内核所需要的一些列编译知识，本博就分析分析这个文件里的代码：

#ifndef __LINUX_COMPILER_H
#define __LINUX_COMPILER_H

############  必要的编译知识:__ASSEMBLY__ ######### 
#ifndef __ASSEMBLY__

首先印入眼帘的是对__ASSEMBLY__这个宏的判断，这个变量实际是在编译汇编代码的时候，由编译器使用-D这样的参数加进去的，gcc会把这个宏定义为1。用在这里，
是因为汇编代码里，不会用到类似于__user这样的属性（关于 __user这样的属性是怎么回子事，本博后面会提到），因为这样的属性是在定义函数参数的时候加的，
这样避免不必要的宏在编译汇编代码时候的引用。

############  必要的编译知识:__CHECKER__ ######### 
#ifdef __CHECKER__
接下来是一个对__CHECKER__这个宏的判断，这里需要讲的东西比较多，是本博的重点。
        
当编译内核代码的时候，使用make C=1或C=2的时候，会调用一个叫Sparse的工具，这个工具对内核代码进行检查，怎么检查呢，就是靠对那些声明过Sparse这个工具
所能识别的特性的内核函数或是变量进行检查。在调用Sparse这个工具的同时，在Sparse代码里，会加上#define __CHECKER__ 1的字样。换句话说，就是，如果使用
Sparse对代码进行检查，那么内核代码就会定义__CHECKER__宏，否则就不定义。具体解释请访问：http://linux.die.net/man/1/sparse

############  必要的编译知识:__user ######### 
例如：
# define __user  __attribute__((noderef, address_space(1)))
这个宏是重点，用来检查是否属于用户空间！这里就能看出来，类似于__attribute__((noderef, address_space(1)))这样的属性就是Sparse这个工具所能识别的了。

其他的那些个属性是用来检查什么的呢，我一个个地做介绍。
__user 这个特性，即__attribute__((noderef, address_space(1)))，是用来修饰一个变量的，这个变量必须是非解除参考
（__attribute__((noderef))——no dereference）的，即这个变量地址必须是有效的，而且变量所在的地址空间必须是1（__attribute__((address_space(1)))），
即用户程序空间的。这里Sparse工具把程序空间分成了3个部分，0表示normal space，即普通地址空间，对内核代码来说，当然就是内核空间地址了。
1表示用户地址空间，这个不用多讲，还有一个2，表示是设备地址映射空间，例如硬件设备的寄存器在内核里所映射的地址空间。

所以在内核函数里，有一个copy_to_user的函数（我们在系统调用博文中会详细介绍），函数的参数定义就使用了这种方式。当然，这种特性检查，
只有当机器上安装了Sparse这个工具，而且进行了编译的时候调用，才能起作用的。

############  必要的编译知识:__kernel ######### 
# define __kernel /* default address space */
根据定义，就是检查是否处于内核空间。其为默认的地址空间，即0，我想定义成__attribute__((noderef, address_space(0)))也是没有问题的。

############  必要的编译知识:__safe ######### 
# define __safe  __attribute__((safe))

这个定义在sparse里也有，内核代码是在2.6.6-rc1版本变到2.6.6-rc2的时候被Linus加入的，原因是这样的：

有人发现在代码编译的时候，编译器对变量的检查有些苛刻，导致代码在编译的时候老是出问题（我这里没有去检查是编译不通过还是有警告信息，因为现在的编译器已经不是当年的编译器了，代码也不是当年的代码）。比如说这样一个例子，
 int test( struct a * a, struct b * b, struct c * c ) {
  return a->a + b->b + c->c;
 }

这个编译的时候会有问题，因为没有检查参数是否为空，就直接进行调用。但是呢，在内核里，有好多函数，当它们被调用的时候，这些个参数必定不为空，所以根本用不着去对这些个参数进行非空的检查，所以就增加了一个__safe的属性，如果这样声明变量，
 int test( struct a * __safe a, struct b * __safe b, struct c * __safe c ) {
  return a->a + b->b + c->c;
 }

编译就没有问题了。

############  必要的编译知识:__force __nocast __iomem ######### 

不过到目前为止，在现在的代码里没有发现有使用__safe这个定义的地方，不知道是不是编译器现在已经支持这种特殊的情况了，所以就不用再加这样的代码了。
# define __force __attribute__((force))
表示所定义的变量类型是可以做强制类型转换的，在进行Sparse分析的时候，是不用报告警信息的。
# define __nocast __attribute__((nocast))
这里表示这个变量的参数类型与实际参数类型一定得对得上才行，要不就在Sparse的时候生产告警信息。
# define __iomem __attribute__((noderef, address_space(2)))
这个定义与__user一样，不过这里的变量地址需要在设备地址映射空间。

############  必要的编译知识:__acquires __releases ######### 
# define __acquires(x) __attribute__((context(x,0,1)))
# define __releases(x) __attribute__((context(x,1,0)))
这是一对相互关联的函数定义，第一句表示参数x在执行之前，引用计数必须为0，执行后，引用计数必须为1，第二句则正好相反，这个定义是用在修饰函数定义
的变量的。

############  必要的编译知识:__acquire __release ######### 
# define __acquire(x) __context__(x,1)
# define __release(x) __context__(x,-1)
这是一对相互关联的函数定义，第一句表示要增加变量x的计数，增加量为1，第二句则正好相反，这个是用来函数执行的过程中。

以上四句如果在代码中出现了不平衡的状况，那么在Sparse的检测中就会报警。当然，Sparse的检测只是一个手段，而且是静态检查代码的手段，所以它的帮助有限，
有可能把正确的认为是错误的而发出告警。要是对以上四句的意思还是不太了解的话，请在源代码里搜一下相关符号的用法就能知道了。这第一组与第二组，
在本质上，是没什么区别的，只是使用的位置上，有所区别罢了。

############  必要的编译知识:__cond_lock ######### 
# define __cond_lock(x,c) ((c) ? ({ __acquire(x); 1; }) : 0)

这句话的意思就是条件锁。当c这个值不为0时，则让计数值加1，并返回值为1。不过这里我有一个疑问，有一个__cond_lock定义，但没有定义相应的
__cond_unlock，那么在变量的释放上，就没办法做到一致。而且spin_trylock()这个函数的定义，它就用了 __cond_lock，而且里面又用了_spin_trylock函数，
在_spin_trylock函数里，再经过几次调用，就会使用到 __acquire函数，这样的话，相当于一个操作，就进行了两次计算，会导致Sparse的检测出现告警信息，
经过写代码进行实验，验证了我的判断，确实会出现告警信息，如果我写两遍unlock指令，就没有告警信息了，但这是与程序的运行是不一致的。


extern void __chk_user_ptr(const volatile void __user *);
extern void __chk_io_ptr(const volatile void __iomem *);

这两句比较有意思。只是定义了函数，但是代码里没有函数的实现。这样做的目的，就是在进行Sparse的时候，让Sparse给代码做必要的参数类型检查，在实际的编译过程中，并不需要这两个函数的实现。

#define notrace __attribute__((no_instrument_function))

这一句，是定义了一个属性，这个属性可以用来修饰一个函数，指定这个函数不被跟踪。在gcc编译器里面，实现了一个非常强大的功能，如果在编译的时候把一个相应的选择项打开，那么就可以在执行完程序的时候，用一些工具来显示整个函数被调用的过程，这样就不需要让程序员手动在所有的函数里一点点添加能显示函数被调用过程的语句，这样耗时耗力，还容易出错。那么对应在应用程序方面，可以使用Graphviz这个工具来进行显示，至于使用说明与软件实现的原理可以自己在网上查一查，很容易查到。对应于内核，因为内核一直是在运行阶段，所以就不能使用这套东西了，内核是在自己的内部实现了一个ftrace的机制，编译内核的时候，如果打开这个选项，那么通过挂载一个debugfs的文件系统来进行相应内容的显示，具体的操作步骤，可以参看内核源码所带的文档。那上面说了这么多，与notrace这个属性有什么关系呢？因为在进行函数调用流程的显示过程中，是使用了两个特殊的函数的，当函数被调用与函数被执行完返回之前，都会分别调用这两个特别的函数。如果不把这两个函数的函数指定为不被跟踪的属性，那么整个跟踪的过程 就会陷入一个无限循环当中。

#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)

这两句是一对对应关系。__builtin_expect(expr, c)这个函数是新版gcc支持的，它是用来作代码优化的，用来告诉编译器，expr的期，非常有可能是c，这样在gcc生成对应的汇编代码的时候，会把相应的可能执行的代码都放在一起，这样能少执行代码的跳转。为什么这样能提高CPU的执行效率呢？因为CPU在执行的时候，都是有预先取指令的机制的，把将要执行的指令取出一部分出来准备执行。CPU不知道程序的逻辑，所以都是从可程序程序里挨着取的，如果这个时候，能不做跳转，则CPU预先取出的指令都可以接着使用，反之，则预先取出来的指令都是没有用的。还有个问题是需要注意的，在__builtin_expect的定义中，以前的版本是没有!!这个符号的，这个符号的作用其实就是负负得正，为什么要这样做呢？就是为了保证非零的x的值，后来都为1，如果为零的0值，后来都为0，仅此而已。

#ifndef barrier
# define barrier() __memory_barrier()
#endif

这里表示如果没有定义barrier函数，则定义barrier()函数为__memory_barrier()。但在内核代码里，是会包含 compiler-gcc.h这个文件的，所以在这个文件里，定义barrier()为__asm__ __volatile__("": : :"memory")。barrier翻译成中文就是屏障的意思，为什么要一个屏障呢？这是因为CPU在执行的过程中，为了优化指令，可能会对部分指令以它自己认为最优的方式进行执行，这个执行的顺序并不一定是按照程序在源码内写的顺序。编译器也有可能在生成二进制指令的时候，也进行一些优化。这样就有可能在多CPU，多线程或是互斥锁的执行中遇到问题。那么这个内存屏障可以看作是一条线，内存屏障用在这里，就是为了保证屏障以上的操作，不会影响到屏障以下的操作。然后再看看这个屏障怎么实现的。__asm__表示后面的东西都是汇编指令，当然，这是一种在C语言中嵌入汇编的方法，语法有其特殊性，我在这里只讲跟这条指令有关的。__volatile__表示不对此处的汇编指令做优化，这样就会保证这里代码的正确性。""表示这里是个空指令，那么既然是空指令，则所对应的指令所需要的输入与输出都没有。在gcc中规定，如果以这种方式嵌入汇编，如果输出没有，则需要两个冒号来代替输出操作数的位置，所以需要加两个::，这时的指令就为"" : :。然后再加上为分隔输入而加入的冒号，再加上空的输入，即为"" : : :。后面的memory是gcc中的一个特殊的语法，加上它，gcc编译器则会产生一个动作，这个动作使gcc不保留在寄存器内内存的值，并且对相应的内存不会做存储与加载的优化处理，这个动作不产生额外的代码，这个行为是由gcc编译器来保证完成的。

#ifndef RELOC_HIDE
# define RELOC_HIDE(ptr, off)     /
  ({ unsigned long __ptr;     /
     __ptr = (unsigned long) (ptr);    /
    (typeof(ptr)) (__ptr + (off)); })
#endif

接下来好多定义都没有实现，可以看一看注释就知道了，所以这里就不多说了。唉，不过再插一句，__deprecated属性的实现是为deprecated。

#define noinline_for_stack noinline

#ifndef __always_inline
#define __always_inline inline
#endif

这里noinline与inline属性是两个对立的属性，从词面的意思就非常好理解了。

#ifndef __cold
#define __cold
#endif

从注释中就可以看出来，如果一个函数的属性为__cold，那么编译器就会认为这个函数几乎是不可能被调用的，在进行代码优化的时候，就会考虑到这一点。不过我没有看到在gcc里支持这个属性的说明。

#ifndef __section
# define __section(S) __attribute__ ((__section__(#S)))
#endif

这个比较容易理解了，用来修饰一个函数是放在哪个区域里的，不使用编译器默认的方式。这个区域的名字由定义者自己取，格式就是__section__加上用户输入的参数。

#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))

这个函数的定义很有意思，它就是访问这个x参数所对应的东西一次，它是这样做的：先取得这个x的地址，然后把这个地址进行变换，转换成一个指向这个地址类型的指针，然后再取得这个指针所指向的内容。这样就达到了访问一次的目的。




