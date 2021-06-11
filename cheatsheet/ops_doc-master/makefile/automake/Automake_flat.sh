1. 目录结构：
Helloworld
|-mytest.h
|-mytest.c
|-mymain.c
　　顶级目录helloworld，该目录下存在三个文件。
mytest.h头文件声明了sayhello()方法；
mytest.c中实现了sayhello()方法；
mymain.c中的main调用了sayhello()方法。


2. 执行步骤：
2.1. Autoscan
　　 在helloworld目录下执行autoscan命令，其中生成一个configure.scan的文件。
2.2. 将configure.scan文件更名为configure.in文件
2.3. 打开configure.in文件，修改文件内容

#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
#AC_INIT([2.68])
AC_INIT([hello], [1.0], [**@126.com])  
AC_CONFIG_SRCDIR([mymain.c])  
#AC_CONFIG_HEADERS([config.h])
 
AM_INIT_AUTOMAKE(hello, 1.0) 

# Check for programs
AC_PROG_CC 

# Check for libraries
# Check for header files
# Check for typedefs, structures, and compiler characteristics.
# Check for library functions.
AC_OUTPUT(Makefile)

2.4. 然后分别执行以下两个命令：
aclocal
autoconf
2.5. 在helloworld文件夹下创建一个名为Makefile.am的文件，并输入一下内容： 　　
AUTOMAKE_OPTIONS=foreign
bin_PROGRAMS=hello
hello_SOURCES=mymain.c mytest.c mytest.h
2.6. 执行命令"automake --add-missing"，automake 会根据Makefile.am 文件产生一些文件，其中包含最重要的Makefile.in
2.7. 执行"./configure"命令生成Makefile文件
2.8. 执行"make"命令来编译hello.c程序，从而生成可执行程序hello。生成可执行程序hello后，执行"./hello"。



