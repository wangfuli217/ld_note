http://www.tinylab.org/testing-debugging-and-optimization-of-code-summary

validation(env){
 $ uname -a
 Linux falcon 2.6.22-14-generic #1 SMP Tue Feb 12 07:42:25 UTC 2008 i686 GNU/Linux
 $ echo $SHELL
 /bin/bash
 $ /bin/bash --version | grep bash
 GNU bash, version 3.2.25(1)-release (i486-pc-linux-gnu)
 $ gcc --version | grep gcc
 gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)
 $ cat /proc/cpuinfo | grep "model name"
 model name      : Intel(R) Pentium(R) 4 CPU 2.80GHz
---------------------------------------

2.1 测试程序的运行时间 time
time pstree 2>&1 >/dev/null
2.2 函数调用关系图 calltree
calltree -b -np -m *.c
# https://sourceforge.net/projects/schilytools/files/calltree/
2.3 性能测试工具 gprof & kprof
gprof是一个命令行的工具，而KDE桌面环境下的kprof则给出了图形化的输出，

对于非KDE环境，可以使用Gprof2Dot把gprof输出转换成图形化结果。
关于dot格式的输出，也可以可以考虑通过dot命令把结果转成jpg等格式，例如：
    $ dot -Tjpg test.dot -o test.jp
}