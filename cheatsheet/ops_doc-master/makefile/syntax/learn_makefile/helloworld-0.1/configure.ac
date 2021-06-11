AC_INIT([helloworld],[0.1])

AC_CONFIG_SRCDIR([src/tt.c])
AM_INIT_AUTOMAKE

AC_CONFIG_HEADERS(config.h)

#dnl 这里是实现自定义参数的部份，见下面的说明
AC_ARG_ENABLE(popo, [ --enable-popo PoPo is present],,enable_popo=no)
if test "$enable_popo" = yes ; then
   echo "PoPo is here!"
   AC_DEFINE(POPO)
else
   echo "PoPo isn't here!"
fi

#检测编译器
AC_PROG_CC

#检测Standard C的头文件
AC_HEADER_STDC

#输出文件，一般来说顶级目录和各子目录都应有Makefile输出
AC_OUTPUT(Makefile src/Makefile) 
