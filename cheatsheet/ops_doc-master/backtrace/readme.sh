http://blog.chinaunix.net/uid-24774106-id-3457205.html #三种方法说明文档
http://www.acsu.buffalo.edu/~charngda/backtrace.html （强烈推荐）

http://blog.csdn.net/littlefang/article/details/41280569  
在这里简单罗列一下文中提到的四个方案：
方法1 GCC内置函数__builtin_return_address
方法2 Glibc中的backtrace函数
方法3 Jeff Muizelaar实现的增强backtrace，除了函数名，还能获得代码行号
方法4 libunwind

__BUILTIN_RETURN_ADDRESS()
{
EASIEST APPROACH: __BUILTIN_RETURN_ADDRESS
GCC has a built-in function to retrieve call stack trace is addresses. For example

    void do_backtrace()  
    {  
        printf("Frame 0: PC=%p\n", __builtin_return_address(0));  
        printf("Frame 1: PC=%p\n", __builtin_return_address(1));  
        printf("Frame 2: PC=%p\n", __builtin_return_address(2));  
        printf("Frame 3: PC=%p\n", __builtin_return_address(3));  
    }  
__builtin_return_address(0) is always current function is address. On the other hand,
__builtin_return_address(1), __builtin_return_address(2), ... may not be available on all platforms.

WHAT TO DO WITH THESE ADDRESSES ?
    Addresses can be mapped to the binary executable or dynamic link libraries. This is always doable even if
the binary executable has been stripped off the symbols.
To see the mapping during runtime, parse the following plain-text file on the /proc file system:

/proc/self/maps

A utility called pmap can do the same.
If the address belongs to a DLL, it is possible to obtain the function name since DLLs are usually not stripped.
Addresses can be mapped to function names. Even if a binary executable is compiled without -g option, it still contains function names. To see the function names in the binary executable, do

nm -C -n a.out

To see the function names programmatically in the binary executable during run-time, read later paragraphs.
Addresses can be mapped to line numbers in source files. This extra information (in DWARF format) is added to the binary executable if it is compiled with -g option. To see line numbers in source files, do
objdump -WL a.out
objdump --dwarf=decodedline a.out
or even better:
addr2line -ifC a.out 0x123456
where 0x123456 is the address of interest. To see line numbers in source files programmatically during run-time, read later paragraphs. 

}

BACKTRACE()
{
    backtrace and backtrace_symbols are functions in Glibc. To use backtrace_symbols, one must compile 
the program with -rdynamic option.
    One does not need to compile with -g option (but -rdynamic option cannot be used together with 
-static option) since backtrace_symbols cannot retrieve line number information. Actually, one can 
even strip off the symbols, and the backtrace_symbols will still work. This is because when -rdynamic 
is used, all global symbols are also stored in .dynsym section in the ELF-formatted executable binary, 
and this section cannot be stripped away. (To see the content of .dynsym section, use readelf -s a.out 
command, or readelf -p .dynstr a.outcommand.)

backtrace_symbols obtains symbol information from .dynsym section.

    (The main purpose of .dynsym section is for dynamic link libraries to expose their symbols so the 
runtime linker ld.so can find them.)

Here is the sample program:

void do_backtrace()  
{  
    #define BACKTRACE_SIZ 100  
    void    *array[BACKTRACE_SIZ];  
    size_t  size, i;  
    char    **strings; 
    size = backtrace(array, BACKTRACE_SIZ);  
    strings = backtrace_symbols(array, size);  
    for (i = 0; i < size; ++i) 
        printf("%p : %s\n", array[i], strings[i]);  
 
    free(strings);  
}
For C++ programs, to get demangled names, use abi::__cxa_demangle (include the headercxxabi.h)

}

BACKTRACE()
{
APPROACH 3: IMPROVED BACKTRACE
The backtrace_symbols in Glibc uses dladdr to obtain function names, but it cannot retrieve line numbers. Jeff Muizelaar has an improved version here which can do line numbers.

If the user program is compiled without any special command-line options, then one can obtain function names (of course, provided the binary executable is not stripped.) Better yet, -rdynamic compiler option is not needed.

If the user program is compiled with -g option, one can obtain both line numbers and function names.

Note that to compile Jeff Muizelaar is backtrace_symbols implementation, make sure the following two macros are defined and appears as the first two lines of a user program (they must precede before all #include ...):

#define __USE_GNU
#define _GNU_SOURCE

and one needs Binary File Descriptor (BFD) library, which is now part of GNU binutils when linking Jeff is code to the user program.

}


LIBUNWIND()
{
libunwind does pretty much what the original backtrace/backtrace_symbols do. Its main purpose, however, is to unwind the stack programmatically (even more powerful thansetjmp/longjmp pair) through unw_step and unw_resume calls. One can also peek and modify the saved register values on stack via unw_get_reg, unw_get_freg, unw_set_reg, and unw_set_freg calls.

If one just wants to retrieve the backtrace, use the following code:

#include <libunwind.h>  
  
void do_backtrace()  
{  
    unw_cursor_t    cursor;  
    unw_context_t   context;  
    unw_getcontext(&context);  
    unw_init_local(&cursor, &context);  
  
    while (unw_step(&cursor) > 0) {  
        unw_word_t  offset, pc;  
        char        fname[64];  
        unw_get_reg(&cursor, UNW_REG_IP, &pc);  
        fname[0] = '\0';  
        (void) unw_get_proc_name(&cursor, fname, sizeof(fname), &offset);  
        printf ("%p : (%s+0x%x) [%p]\n", pc, fname, offset, pc);  
    }  
}  

and linked the user program with -lunwind -lunwind-x86_64. 
There is no need to compile the user program with -g option.

}



