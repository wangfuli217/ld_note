printf("\033[31m The ......\n\033[0m");
printf("\033[2;7;1mHEOO.\n\033[2;7;0m");
printf("\033[41;36msomthe here\n\033[0m");
return 0;

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

Examples of common combinations:
format	output
printf("%08X",32_bit_var);	0000ABCD
printf("%lu",32_bit_var);	43981
printf("%'d",32_bit_var);	43,981
printf("%10s","string");	    string
printf("%*s",10,"string");	    string
printf("%-10s","string");	string    
printf("%-10.10s","truncateiftoolong");	truncateif

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

-：左对齐 
space：正数前面加空格，负数前面加符号，例如12.12，|% f|，显示| 12.120000|，注意前面留了一个空格。例如-12.12，|% f|，显示|-12.120000| 
+：对于数码给予正负号。 
#：给出另一种格式：
%o以8进制显示整数，而%#o则在前面加上零，表明是八进制，例如12，显示014
%x或者%X以16进制的方式显示整数，而%#x或者%#X，在16进制的整数前面加上0x或者0X来表示，例如12，显示0XC
%#e,%#E, %#f，将只以十进制显示
%#g,%#G，将不删除最后无关的补齐0，例如12.1200，将全部显示，而不是12.12。
0：对于数目，不使用空格，而使用0来作为补齐。


log_i__VA_ARGS__(){ cat - <<'log_i__VA_ARGS__'
在宏定义中，...可以代替__VA_ARGS__, __VA_ARGS__可以代替...
... 和 __VA_ARGS__ 之间对应关系
#define PRINT(fmt, ...) printf(fmt, __VA_ARGS__)       // VS
#define PRINT2(fmt, ...) printf(fmt, ## __VA_ARGS__)   // GCC

#define mfs_arg_syslog(priority,format, ...) {\        // STD C
    syslog((priority),(format), __VA_ARGS__); \
    fprintf(stderr,format "\n", __VA_ARGS__); \
}
log_i__VA_ARGS__
}


log_i_args(){ cat - <<'log_i_args'
在宏定义中，##args可以代替args..., args...可以代替##args

从args... 到 ##args
#define otdr_main_err( fmt, args...) do { rtu_errex(MOD_OTDR_MAIN_DP, fmt, ##args); } while(0)

从args... 到 ##args
#define rtu_errex(mod, fmt, args...) \
    log_writeex(RTU_ERR, mod, __func__, __LINE__, fmt, ##args)

在宏定义中，##args可以代替C声明中的...
从 ##args 到 ...
void log_writeex(int prio, uint32_t module, const char *func, int line, const char *fmt, ...)

在宏定义中，args... 到##args，而##args被解释为printf的...可变参数
# define bb_debug_msg(fmt, args...) fprintf(stderr, fmt, ## args)
log_i_args
}


log_i_printf(){ cat - <<'log_i_printf'

在宏声明中，可以使用...到__VA_ARGS__转向下列函数
int printf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
int sprintf(char *str, const char *format, ...);
int snprintf(char *str, size_t size, const char *format, ...);
       
void syslog(int priority, const char *format, ...);
log_i_printf
}

log_i_va_list(){ cat - <<'log_i_va_list'
在C定义中，... 总是 转向 va_list
void log_writeex(int prio, uint32_t module, const char *func, int line, const char *fmt, ...)
    va_list ap;
    uint8_t dp;
    const char *desc = rtu_mod_name_desc(module, &dp);

    if (prio > dp)
    return;

    va_start(ap, fmt);
    dologex(prio, desc, func, line, fmt, ap);
    va_end(ap);
}

api(va_list到vprintf,vfprintf,vsprintf,vsnprintf,vsyslog){

在C定义中，可以使用...到 va_list转向下列函数
int vprintf(const char *format, va_list ap);
int vfprintf(FILE *stream, const char *format, va_list ap);
int vsprintf(char *str, const char *format, va_list ap);
int vsnprintf(char *str, size_t size, const char *format, va_list ap);

void vsyslog(int priority, const char *format, va_list ap);
log_i_va_list
}


log_i_TRACE_strcat(){  cat - <<'log_i_TRACE'
    宏插入到字符串常量
-- 输出变量名以及变量的值，要求变量名具有很好可读性
方法1.
#define PRINT(FORMAT,VALUE) \  
        printf("the value is "FORMAT"\n",VALUE); 
方法2.
#define PRINT(FORMAT,VALUE) \  
        printf("the value of "#VALUE" is "FORMAT"\n",VALUE);
log_i_TRACE
}

log_i_TRACE_file(){  cat - <<'log_i_TRACE_file'
单文件调试
#define TRACE(format, ...) printf (format, ##__VA_ARGS__)
__LINE__：在源代码中插入当前源代码行号；
__FILE__：在源文件中插入当前源文件名；
__DATE__：在源文件中插入当前的编译日期
__TIME__：在源文件中插入当前编译时间；
__STDC__：当要求程序严格遵循ANSI C标准时该标识被赋值为1；
__cplusplus：当编写C++程序时该标识符被定义。

#define  TRACE(format,...) printf("FILE: "__FILE__", LINE: %d: "format"\n", __LINE__, ##__VA_ARGS__)
---------------------------------------
#define DBG(format, args...) fprintf(stderr, "[%s|%s@%s,%d] " format "\n", APP_NAME, __FUNCTION__, __FILE__, __LINE__, ##args);
log_i_TRACE_file
}

TRACE(TRACE&DPRINT){

#ifdef TRACE 
#define TRACE(format, ...)   printf (format, ##__VA_ARGS__)
#define DPRINT(fmt, args...) fprintf(stderr, "[DPRINT...][%s %d] "fmt"\n", __FILE__, __LINE__, ##args);
#else 
#define TRACE(format, ...) 
#define DPRINT(fmt, ...) 
#endif
}

log_i_TRACE_level(){ cat - <<'log_i_TRACE_level'
支持level
#include <stdio.h>  
 
#define LOG_DEBUG "DEBUG"  
#define LOG_TRACE "TRACE"  
#define LOG_ERROR "ERROR"  
#define LOG_INFO  "INFOR"  
#define LOG_CRIT  "CRTCL"  
 
#define LOG(level, format, ...) \  
    do{\  
        fprintf(stderr, "[%s|%s@%s,%d] " format "\n", \  
            level, __func__, __FILE__, __LINE__, ##__VA_ARGS__ ); \  
    } while (0)  
  
int main(){  
    LOG(LOG_DEBUG, "a=%d", 10);  
    return 0;  
}
log_i_TRACE_level
}

log_i_TRACE_switch(){ cat - <<'log_i_TRACE_switch'

#define DPRINT(fmt, args...)  if( d_print ) printf(fmt,##args);
log_i_TRACE_switch
}

TRACE(变量控制|自定义log函数){

#include <stdio.h>  
#define lU_DEBUG_PREFIX "##########"  
 
#define LU_DEBUG_CMD 0x01  
#define LU_DEBUG_DATA 0x02  
#define LU_DEBUG_ERROR 0x04  
 
#define LU_PRINTF_cmd(msg...) do{if(lu_debugs & LU_DEBUG_CMD)printf(lU_DEBUG_PREFIX msg);}while(0)  
#define LU_PRINTF_data(msg...) do{if(lu_debugs & LU_DEBUG_DATA)printf(lU_DEBUG_PREFIX msg);}while(0)  
#define LU_PRINTF_error(msg...) do{if(lu_debugs & LU_DEBUG_ERROR)printf(lU_DEBUG_PREFIX msg);}while(0)  
 
 
#define lu_printf(level, msg...) LU_PRINTF_##level(msg)  
#define lu_printf2(...) printf(__VA_ARGS__)  
#define lu_printf3(...) lu_printf(__VA_ARGS__)  
static int lu_printf4_format(int prio, const char *fmt, ...);  
#define lu_printf4(prio, fmt...) lu_printf4_format(prio, fmt)  

int lu_debugs;  
  
int main(int argc, char *argv[])  
{  
    lu_debugs |= LU_DEBUG_CMD | LU_DEBUG_DATA | LU_DEBUG_ERROR;  
    printf("lu_debugs = %p\n", lu_debugs);  
    lu_printf(LU_DEBUG_CMD,"this is cmd\n");  
    lu_printf(LU_DEBUG_DATA,"this is data\n");  
    lu_printf(LU_DEBUG_ERROR,"this is error\n");  
    lu_debugs &= ~(LU_DEBUG_CMD | LU_DEBUG_DATA);  
    printf("lu_debugs = %p\n", lu_debugs);  
    lu_printf(LU_DEBUG_CMD,"this is cmd\n");  
    lu_printf(LU_DEBUG_DATA,"this is data\n");  
    lu_printf(LU_DEBUG_ERROR,"this is error\n");  
    lu_printf2("aa%d,%s,%dbbbbb\n", 20, "eeeeeee", 100);  
    lu_debugs |= LU_DEBUG_CMD | LU_DEBUG_DATA | LU_DEBUG_ERROR;  
    printf("lu_debugs = %p\n", lu_debugs);  
    lu_printf3(LU_DEBUG_CMD,"this is cmd \n");  
    lu_printf3(LU_DEBUG_DATA,"this is data\n");  
    lu_printf3(LU_DEBUG_ERROR,"this is error\n");  
    lu_printf4(0,"luther %s ,%d ,%d\n", "gliethttp", 1, 2);  
    return 0;  
}  

#include <stdarg.h>  
static int lu_printf4_format(int prio, const char *fmt, ...)  
{  
#define LOG_BUF_SIZE (4096)  
    va_list ap;  
    char buf[LOG_BUF_SIZE];   
  
    va_start(ap, fmt);  
    vsnprintf(buf, LOG_BUF_SIZE, fmt, ap);  
    va_end(ap);  
  
    printf("<%d>: %s", prio, buf);  
    printf("------------------------\n");  
    printf(buf);  
}  
 
#define ENTER() LOGD("enter into %s", __FUNCTION__)  
#define LOGD(...) ((void)LOG(LOG_DEBUG, LOG_TAG, __VA_ARGS__))  
#define LOG(priority, tag, ...) \  
    LOG_PRI(ANDROID_##priority, tag, __VA_ARGS__)  
#define LOG_PRI(priority, tag, ...) \  
    android_printLog(priority, tag, __VA_ARGS__)  
#define android_printLog(prio, tag, fmt...) \  
    __android_log_print(prio, tag, fmt)  
}

TRACE(){
char LogLastMsg[128]; // all info of the last log, all the info to log last time    
int Log2Stderr = LOG_ERR; //control Loging to stderr    
/**  
 * @Synopsis  a log func demo   
 *      demo for how  user defined module log info  
 *  
 * @Param priority: level of log, LOG_ERR, LOG_DEBUG etc.  
 * @Param errno:    errno  
 * @Param fmt:  format of message to log  
 * @Param ...:  args follow by fmt  
 */    
void mylog(int priority, int errno, char* fmt, ...)    
{    
    DPRINT("mylog Begin...");    
    char priVc[][8] = {"Emerg", "Alert", "Crit", "Error", "Warning", "Notice", "Info", "Debug"};    
    
    char* priPt = priority < 0 || priority >= sizeof(priVc)/sizeof(priVc[0]) ?    
        "Unknow priority!" : priVc[priority];    
    
    char *errMsg = errno <= 0 ? NULL : (const char*)strerror(errno);    
    {    
        va_list argPt;    
        unsigned Ln;    
    
        va_start(argPt, fmt); 
        Ln = snprintf(LogLastMsg, sizeof(LogLastMsg), "[mylog...][%s]: ", priPt);    
        Ln += vsnprintf(LogLastMsg + Ln, sizeof(LogLastMsg) - Ln, fmt, argPt);    
        if (NULL != errMsg) {
            Ln += snprintf(LogLastMsg + Ln, sizeof(LogLastMsg) - Ln, "%d:%s", errno, errMsg);    
        }    
        va_end(argPt);    
    }    
       
    if (priority < LOG_ERR || priority <= Log2Stderr){    
        fprintf(stderr, "%s\n", LogLastMsg);    
    }    
    DPRINT("log to stderr");    
    
    syslog(priority, "%s", LogLastMsg);    
    
    if (priority <= LOG_ERR)    {    
        exit(-1);    
    }    
    return ;    
}
}
log4me(深入理解log机制){
1. 最简单的log
    printf("I'm a message\n");
    
2. 增加有用信息
    printf("%s %s %d: I'm a message\n", time, __FILE__, __LINE__);
    
3. 简化调用：封装
    #define printf0(message) \
    printf("%s %s %d %s", time, __FILE__, __LINE__, message);

    printf0("I'm a message\n");
4. 设定等级：TraceLevel
    printf0("Normal: I'm a normal message\n");
    printf0("Warning: I'm a warning message\n");
    printf0("Error: I'm an error message\n");
    
--------------------------------------- 进一步

    enum TraceLevel {
        Normal,
        Warning,
        Error
    };
    void printf1(TraceLevel level, const char *message) {
        char *levelString[] = {
            "Normal: ",
            "Warning: ",
            "Error: "
        }
        printf0("%s %s", message, levelString[level]);
    }
    printf1(Normal, "I'm a normal message\n");
    printf1(Warning, "I'm a warning message\n");
    printf1(Error, "I'm an error message\n");
---------------------------------------  进一步
    void printf_out(const char *message) {
    printf1(Normal, message);
    }
    void printf_warn(const char *message) {
        printf1(Warning, message);
    }
    void printf_error(const char *message) {
        printf1(Error, message);
    }
    printf_out("I'm a normal message\n");
    printf_warn("I'm a warning message\n");
    printf_error("I'm an error message\n");
---------------------------------------  再进一步
    TraceLevel getLevel1();
    void printf2(TraceLevel level, const char *message) {
        if (level >= getLevel1())
            printf1(level, message);
    }
    printf2(Normal, "I'm a normal message\n");
    printf2(Warning, "I'm a warning message\n");
    printf2(Error, "I'm an error message\n");
    
5. 多一些控制：Marker
    和很多命令的-verbose参数一样。由于都是Normal类型的log，
所以不能够用前面的TraceLevel，这时需要引入另外一层控制：
    const int SUB     = 0;
    const int TRACE_1 = 1 << 0;
    const int TRACE_2 = 1 << 1;
    const int TRACE_3 = 1 << 2;
    int getMarker1();
    void printf3(int marker, TraceLevel level, const char *message) {
        if (marker == 0 || marker & getMarker1() != 0)
            printf2(level, message);
    }
    printf3(SUB, Normal, "I'm a normal message\n");
    printf3(TRACE_1, Normal, "I'm a normal message\n");
    printf3(TRACE_2, Normal, "I'm a normal message\n");
6. 改变目的地：Appender
    class Appender {
        void printf(TraceLevel level, const char *message) = 0;
    };
    class ConsoleAppender: public Appender {/* overwrite printf */};
    class FileAppender: public Appender {/* overwrite printf */};
    class EventLogAppender: public Appender {/* overwrite printf */};
    
    std::vector<Appender *> &getAppenders();
    void printf4(int marker, TraceLevel level, const char *message) {
        if (marker == 0 || marker & getMarker1() != 0) {
            if (level >= getLevel1()) {
                std::vector<Appender *>::iterator it = getAppenders.begin();
                for (; it != getAppenders.end(); it++)
                    (*it)->printf(level, message);
        }
    }
    printf4(SUB, Normal, "I'm a normal message\n");
    printf4(TRACE_1, Normal, "I'm a normal message\n");
    printf4(TRACE_2, Normal, "I'm a normal message\n");

7. 模块独立控制：Category
    随着程序规模越来越大，一个程序所包含的模块也越来越多，有时你并不想要一个全局的配置，
而是需要每一个模块可以独立的进行配置，

    TraceLevel getLevel2(const char *cat);
    int getMarker2(const char *cat);
    std::vector<Appender *> &getAppenders2(const char *cat);
    void printf5(const char *cat, int marder, TraceLevel level,
        const char *message) {
        if (marker == 0 || marker & getMarker2(cat) != 0) {
            if (level >= getLevel2(cat)) {
                std::vector<Appender *>::iterator it = getAppenders(cat).begin();
                for (; it != getAppenders.end(cat); it++)
                    (*it)->printf(level, message);
        }
    }
    printf5("Library1", SUB, Normal, "I'm a normal message\n");
    printf5("Library1", TRACE_1, Normal, "I'm a normal message\n");
    printf5("Library1", TRACE_2, Normal, "I'm a normal message\n");
对比前一节的代码，可以发现这里除了增加一个参数const char *cat以外，其它完全一样。但正是这个参数的出现，
才让每一个模块可以独立的配置。这种模块间独立进行配置的方法我们称为Category。

8. 配置文件
Category: Library1          -> for Library1 category
    TraceLevel : Warning    -> only Warning and Error messages are allowed
    Markers    : TRACE_1    -> only TRACE_1 is allowed
    Appenders  :
        ConsoleAppender     -> write to console
        FileAppender:       -> write to file
            filePath: C:\temp\log\trace_lib1.log

Category: Library2          -> for Library2 category
...
那么在什么时机读取这个配置文件？一般有这样几种方式：

1. 程序启动时载入logConfig.ini，如果配置不常改变时可以采用这种方式，最简单。
2. 创建一个新线程，间隔一段时间检查logConfig.ini是否已经改变，如果改变则重新读取。这种方法比较复杂，
   可能会影响效率，而且间隔的时间也不好设置。
3. 处理每一个log之前先检测logConfig.ini，如果有改变则重新读取。
4. 最后一种方法结合了前两种方法的优点，还是在处理每个log之前检测，但不同的是再加上一个时间间隔，、
   如果超过时间间隔才会真的去检测，而如果在间隔内，则直接忽略。这种方法更加高效且消耗资源最少。
}

log(使用stdarg.h -> 征服C指针-前桥和弥){

#include <stdio.h>
#include <stdarg.h>
#include <assert.h>

void tiny_printf(char *format, ...) {
    int i;
    va_list ap;

    va_start(ap, format);
    for ((i = 0; format[i] != '\0'; i++)) {
        switch ((format[i])) {
            case 's':
                printf("%s ", va_arg(ap, char*));
                break;
            case 'd':
                printf("%d ", va_arg(ap, int));
                break;
            default:
                assert(0);
        }
    }
    va_end(ap);
}

int main(void){
    tiny_printf("sdd", "result..", 3, 5);
    return 0;
}

1. 头文件stdarg.h提供了一组方便使用可变长参数的宏
2. va_list一般是这样定义typedef char *va_list;
3. va_start(ap, format)意味着使指针ap指向参数format的下一个位置
4. 宏va_arg()指定ap和参数类型，就可以顺序的取出可变长部分的参数
5. va_end(ap);是一个空定义的宏，只因标准里指出了对于va_start()的函数需要写va_end()
-------------------------------------------------------------------------------
在决定开发可变长参数的函数前，思考一下是否真有必要


}

log(实现DEBUG_WRITE-> 征服C指针-前桥和弥){

#define DEBUG
#ifdef DEBUG
#define DEBUG_WRITE(arg) debug_write arg
#else
#define DEBUG_WRITE(arg)
#endif

#define SNAP_INT(arg) fprintf(stderr, #arg "..%d\n", arg)

void debug_write(char *format, ...){
    va_list ap;
    va_start(ap, format);
    vfprintf(stderr, format, ap);
    va_end(ap);
}

int main(void){
    DEBUG_WRITE(("\n%s..%d\n", "debug_write", 10));
    int hoge = 4;
    SNAP_INT(hoge);
    return 0;
}
    使用DEBUG_WRITE应加 两重括号，使用gcc时
    gcc -DDEBUG ...将会加上DEBUG的宏定义
    vfprintf(stderr, format, ap);输出到stderr不会有缓冲
    #define SNAP_INT(arg) fprintf(stderr, #arg "..%d\n", arg)，#arg将输出原文，其后只有空格，将合并两个字符串
}

log(可变参数在编译器中的处理){
我们知道va_start,va_arg,va_end是在stdarg.h中被定义成宏的, 由于1)硬件平台的不同 2)编译器的不同,所以定义的宏也有所不同,下面看一下VC++6.0中stdarg.h里的代码（文件的路径为VC安装目录下的\vc98\include\stdarg.h）

typedef char *     va_list;
 #define _INTSIZEOF(n) ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1) )
 #define va_start(ap,v)     ( ap = (va_list)&v + _INTSIZEOF(v) )
 #define va_arg(ap,t)       ( *(t *)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)) )
 #define va_end(ap)         ( ap = (va_list)0 )

下面我们解释这些代码的含义：
    首先把va_list被定义成char*，这是因为在我们目前所用的PC机上，字符指针类型可以用来存储内存单元地址。
而在有的机器上va_list是被定义成void*的
    定义_INTSIZEOF(n)主要是为了某些需要内存的对齐的系统.这个宏的目的是为了得到最后一个固定参数的实际内存大小。
在我的机器上直接用sizeof运算符来代替，对程序的运行结构也没有影响。（后文将看到我自己的实现）。
    va_start的定义为&v+_INTSIZEOF(v), 这里&v是最后一个固定参数的起始地址，再加上其实际占用大小后，
就得到了第一个可变参数的起始内存地址。所以我们运行va_start(ap, v)以后,ap指向第一个可变参数在的内存地址,
有了这个地址，以后的事情就简单了。
这里要知道两个事情：
    在intel+windows的机器上，函数栈的方向是向下的，栈顶指针的内存地址低于栈底指针，
所以先进栈的数据是存放在内存的高地址处。
    在VC等绝大多数C编译器中，默认情况下，参数进栈的顺序是由右向左的，因此，参数进栈
以后的内存模型如下图所示：最后一个固定参数的地址位于第一个可变参数之下，并且是连续存储的。

            |--------------------------|
            |     最后一个可变参数     |        ->高内存地址处
            |--------------------------|
            |--------------------------|
            |     第N个可变参数        |        ->va_arg(arg_ptr,int)后arg_ptr所指的地方,
            |                          |        即第N个可变参数的地址。
            |--------------------------|    
            |--------------------------|
            |     第一个可变参数       |        ->va_start(arg_ptr,start)后arg_ptr所指的地方
            |                          |        即第一个可变参数的地址
            |--------------------------|    
            |--------------------------|
            |                          |
            |     最后一个固定参数     |        -> start的起始地址
            |--------------------------|          .................
            |--------------------------|
            |                          | 
            |--------------------------|      -> 低内存地址处
    + 'va_arg()':有了'va_start'的良好基础，我们取得了第一个可变参数的地址，在va_arg()里的任务就是
根据指定的参数类型取得本参数的值，并且把指针调到下一个参数的起始地址。因此，现在再来看'va_arg()'
的实现就应该心中有数了： 
#define va_arg(ap,t) \ 
  ( *(t *)((ap += _INTSIZEOF(t)) - _INTSIZEOF(t)) ) 
- 这个宏做了两个事情， 
    - 用用户输入的类型名对参数地址进行强制类型转换，得到用户所需要的值 
    - 计算出本参数的实际大小，将指针调到本参数的结尾，也就是下一个参数的首地址，以便后续处理。 
+ 'va_end'宏的解释：x86平台定义为'ap=(char*)0;'使ap不再 指向堆栈,而是跟NULL一样.有些直接定义为'((void*)0)',
这样编译器不会为'va_end'产生代码,例如gcc在linux的x86平台就是这样定义的. 在这里大家要注意一个问题:由于参数的
地址用于'va_start'宏,所以参数不能声明为寄存器变量或作为函数或数组类型. 关于'va_start, va_arg, va_end'的描述
就是这些了,我们要注意的 是不同的操作系统和硬件平台的定义有些不同,但原理却是相似的.

四、小结:
---------------------------------------
标准C库的中的三个宏的作用只是用来确定可变参数列表中每个参数的内存地址，编译器是不知道参数的实际数目的。
在实际应用的代码中，程序员必须自己考虑确定参数数目的办法，如
    在固定参数中设标志– printf函数就是用这个办法。后面也有例子。
    在预先设定一个特殊的结束标记，就是说多输入一个可变参数，调用时要将最后一个可变参数的值设置成这个特殊的值，在函数体中根据这个值判断是否达到参数的结尾。本文前面的代码就是采用这个办法.
    无论采用哪种办法，程序员都应该在文档中告诉调用者自己的约定。
实现可变参数的要点就是想办法取得每个参数的地址，取得地址的办法由以下几个因素决定：
    函数栈的生长方向
    参数的入栈顺序
    CPU的对齐方式
    内存地址的表达方式
    结合源代码，我们可以看出va_list的实现是由④决定的，_INTSIZEOF(n)的引入则是由③决定的，他和①②又一起决定了va_start的实现，最后va_end的存在则是良好编程风格的体现，将不再使用的指针设为NULL,这样可以防止以后的误操作。
取得地址后，再结合参数的类型，程序员就可以正确的处理参数了。理解了以上要点，相信稍有经验的读者就可以写出适合于自己机器的实现来
}

log(橡皮鸭程序调试法){
一旦一个问题被充分地描述了他的细节，那么解决方法也是显而易见的。

1. 找一个橡皮鸭子。你可以去借，去偷，去抢，去买，自己制作……反正你要搞到一个橡皮鸭子。
2. 把这个橡皮鸭子放在你跟前。标准做法是放在你的桌子上，电脑显示器边，或是键盘边，反正是你的跟前，面朝你。
3. 然后，打开你的源代码。不管是电脑里的还是打印出来的。
4. 对着那只橡皮鸭子，把你写下的所有代码，一行一行地，精心地，向这只橡皮鸭子解释清楚。记住，这是解释，你需要解释出你的想法，思路，观点。不然，那只能算是表述，而不是解释。
5. 当你在向这只始终保持沉默的橡皮鸭子解释的过程中，你会发现你的想法，观点，或思路和实际的代码相偏离了，于是你也就找到了代码中的bug。
6. 找到了BUG，一定要记得感谢一下那个橡皮鸭子哦。
}