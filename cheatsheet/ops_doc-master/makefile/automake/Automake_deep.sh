1. 目录结构
helloworld
|head
||-mytest.h
||-mytest.c
|src
||-mymain.c

顶级目录helloworld，该目录下存在两个目录src和head。Head目录中，mytest.h头文件声明了sayhello()方法；
mytest.c中实现了sayhello()方法；src目 录中的mymain.c中的main调用了sayhello()方法。

2. 执行步骤
2.1.  在顶层目录下运行autoscan产生configure.scan文件
2.2.  将configure.scan文件更名为configure.in文件
2.3.  打开configure.in文件，修改文件内容

#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
 
#AC_INIT([2.68])
AC_INIT([hello], [1.0], [**@126.com])  6 AC_CONFIG_SRCDIR([src/mymain.c])  7 #AC_CONFIG_HEADERS([config.h])
 
AM_INIT_AUTOMAKE(hello, 1.0) 
 
 # Check for programs
AC_PROG_CC 
#使用静态库编译，需要此宏定义
AC_PROG_RAMLIB 

# Check for libraries
# Check for header files
# Check for typedefs, structures, and compiler characteristics.
# Check for library functions.

AC_OUTPUT(Makefile head/Makefile src/Makefile)


2.4.  然后分别执行以下两个命令： 
aclocal
autoconf

2.5.  在head文件夹下创建Makefile.am文件，内容如下：
AUTOMAKE_OPTIONS=foreign
noinst_LIBRARIES=libmytest.a
libmytest_a_SOURCES=mytest.h mytest.c

2.6.  在src文件夹下创建Makefile.am文件，内容如下：
AUTOMAKE_OPTIONS=foreign
bin_PROGRAMS=hello
hello_SOURCES=mymain.c
hello_LDADD=../head/libmytest.a

2.7.  在helloworld文件夹下创建Makefile.am文件，内容如下：
AUTOMAKE_OPTIONS=foreign
SUBDIRS=head src

2.8.  执行命令"automake –add-missing"，automake会根据Makefile.am 文件产生一些文件，其中包含最重要的Makefile.in
2.9.  执行"make"命令来编译hello.c程序，从而生成可执行程序hello。生成可执行程序hello后，执行"./hello"。

