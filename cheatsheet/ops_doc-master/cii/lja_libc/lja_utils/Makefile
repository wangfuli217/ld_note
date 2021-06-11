# @file makefile
# @brief 多功能通用Makefile。可以生成动态库、静态库、可执行文件，导出头文件
# @author LJA
# @version 0.0.2
# @date 2012-11-11
# @changetime: 2014-05-07

-include  ../Makefile.pub

##########################################################
#                    必须设置的变量                      
#
# 这些变量不能为空，否则Make时无法正常运行
#
##########################################################
#编译动作，
#  ar: 编译静态库  so: 编译动态库 lib: 动态库和静态库 app: 编译可执行文件
#  export: 只导出目标文件,不需要编译过程
#  unexport: 将导出到目标目录的文件，从目标目录中删除
#  只能指定一个动作，ar so lib app export只能选择一个
#
#
#  如果不指定动作，可以直接执行 
#  make static; make dynamic; make lib; make app; make export; make unexport
ACTION = lib

#目标名称，如果设置为XXX，那么:
# 得到的静态库为: libXXX.a
# 得到的动态库为: libXXX.so
# 得到的可执行文件为: XXX
TARGET = lja_utils

#编译器 
CC = gcc 

#连接器
LD = ld

#归档,静态库
AR = ar

#源代码文件后缀，可以指定多个后缀
#    注意: 目前不会根据后缀的不同而采用不同的编译
#    SUFFIX将被排序去重
#    指编译当前目录下.SUFFIX文件
#    SUFFIX的值不能够使d和o，因为中间生成的会使用这两个后缀
# 例:c
SUFFIX = c
#源码子目录，只能是当前路径下目录
#子目录下的源码的中间文件生在在OBJ_DIR目录下的同名目录中
#OBJ_DIR目录下的同名目录将会自动创建
SUB_SRC_DIR = 

##########################################################
#                    可选的变量
#
# 这些变量根据实际的需求进行设置，如果为空，使用默认值
#
##########################################################
#最终目标被复制到指定放置的路径，可以指定多个路径
#当前目录下会一直保存一份目标文件
#例:TARGET_DIR1 TARGET_DIR2
TARGET_DIR = ../out/lib

#文件导出
#将$(EXPORT_FILE)中指定的文件复制到$(EXPORT_FILE)目录中
#    如果$(EXPORT_FILE)不为空，$(EXPORT_FILE_DIR)为空，提示error
#    如果$(EXPORT_FILE)为空，$(EXPORT_FILE_DIR)为空，不做操作
#    如果$(EXPORT HEAD_DIR)中有多个目录，文件被复制到其中的每一个目录下
#    EXPORT_FILE和EXPORT_FILE_DIR将被排序去重
#    如果文件路径中包含目录，会在导出位置创建相应的目录
EXPORT_FILE = lja_utils.h
EXPORT_FILE_DIR =  ../out/include

#编译选项
CFLAGS += 

#在$(CC)中使用的连接选项
#    当前的链接过程使用的是$(CC),由$(CC)自行调用链接器进行链接
#    一般情况下，这样已经足够了
#    以后如果有需要，改成直接使用$(LD)进行链接的方式
LDFLAGS +=

#中间文件存放路径，只能指定一个路径，默认为当前路径
#例:obj
#Now it is defined in Makefile.pub
#OBJ_DIR =

#头文件路径，可以指定多个路径，当前路径始终包含在内
#例: ../include
HEAD_DIR += 

#连接库路径
#例: ../lib 
LIB_DIR +=
#动态连接库,
#例m
DY_LIB += 
#静态连接库,
#例:cunit
ST_LIB += 

#进入其中执行Make的子目录
#    如果指定了子目录，首先按照指定的顺序到子目录下执行make
#    可以指定多个目录，如果目录重复出现，那么每遇到一次就会进入执行一次
#    为了防止无限的循环Make，这里只允许当前路径下目录,只允许如下样式的目录
#        aaa 或者 aaa/
#
#    当前目录中目标的编译在子目录中的Make完成后进行
#    当前Makefile中的变量不会传递到子Makefile中
#
#    虽然需要在每个子目录中设置Makefilek看起来似乎有些麻烦
#    但我认为这样是有必要的，这样我们可以掌控每个Make的行为
SUB_MAKE_DIR = 

# 在当前的Make结束之后，进入下面的目录进行make
# 其他要求与SUB_MAKE_DIR相同
# 不同的是SUB_MAKE_DIR是在当前目录的make之前进行make
# LAST_SUB_MAKE_DIR是在当前目录的make结束后进行make
LAST_SUB_MAKE_DIR = 

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#     实现部分！
#
#     除非知道正在做什么，否则不要修改接下来的任意一个字符!
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-include ../Makefile.func
-include ../Makefile.lib

