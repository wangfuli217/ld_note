各种工具和库
    file
    valgrind
    libuwind
    ltrace strace
    opprofile
    PCL
二机制格式
    readelf
    objdump
    nm
    libbfd
系统调用
    signalstack
    SIGSEGV
操作系统自带功能
    LD_PROLOAD
处理器自带功能

编译器自带功能
    DWARF(Debug With Arbitrary Record Format)
    LLP64 # Windows 64-bit systems
    LP64  # all other 64-bit systems
                    ILP32   LP64    LLP64   ILP64
        char        8       8       8       8
        short       16      16      16      16
        int         32      32      32      64
        long        32      64      32      64
        long long   64      64      64      64
        pointer     32      64      64      64
        
    全局偏移表GOT：实现PIC的必要数据。在PIC中，使用GOT间接引用对全局数据进行存取。
    程序连接表PLT：实现动态库的必要数据。与GOT同时使用，间接调用动态链接的共享库的函数。
    位置无关代码PIC:可以装载到任意位置执行的代码，数据存取和转移在相对偏移量上进行。
    线程本地存储TLS：任一线程即使使用相同的变量，其实际存储值根据线程本身保持独立，在GCC中使用__thread这个关键字使用TLS
    位置无关可执行程序PIE:
    在POSIX中SIGKILL和SIGSTOP以外的信号可用信号处理器程序。
