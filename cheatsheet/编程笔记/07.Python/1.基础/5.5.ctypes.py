CTypes；ctypes模块提供了和C语言兼容的数据类型和函数来加载dll文件，因此在调用时不需对源文件做任何的修改。也正是如此奠定了这种方法的简单性。

add.c
//sample C file to add 2 numbers - int and floats

#include <stdio.h>

int add_int(int, int);
float add_float(float, float);

int add_int(int num1, int num2){
    return num1 + num2;

}
float add_float(float num1, float num2){
    return num1 + num2;

}
# --------------------------------------- # 
gcc -shared -Wl,-soname,adder -o adder.so -fPIC add.c

# --------------------------------------- # 
from ctypes import *

#load the shared object file
adder = CDLL('./adder.so')

#Find sum of integers
res_int = adder.add_int(4,5)
print "Sum of 4 and 5 = " + str(res_int)

#Find sum of floats
a = c_float(5.5)
b = c_float(4.1)

add_float = adder.add_float
add_float.restype = c_float
print "Sum of 5.5 and 4.1 = ", str(add_float(a, b))

# --------------------------------------- # 
ctypes type     c type                                  Python type
c_char          char                                    1-character string
c_wchar         wchar_t                                 1-character unicode string
c_byte          char                                    int/long
c_ubyte         unsigned char                           int/long
c_short         short                                   int/long
c_ushort        unsigned short                          int/long
c_int           int                                     int/long
c_uint          unsigned int                            int/long
c_long          long                                    int/long
c_ulong         unsigned long                           int/long
c_longlong      __int64 or long long                    int/long
c_ulonglong     unsigned __int64 or unsigned long long  int/long
c_float         float                                   float
c_double        double                                  float
c_char_p        char * (NUL terminated)                 string or None
c_wchar_p       wchar_t * (NUL terminated)              unicode or None
c_void_p        void * 	int/long or None

表 1 中的第一列是在 ctypes 库中定义的变量类型，
第二列是 C 语言定义的变量类型，
第三列是 Python 语言在不使用 ctypes 时定义的变量类型。

清单 1. ctypes 简单类型
>>> from ctypes import *               # 导入 ctypes 库中所有模块
>>> i = c_int(45)                        # 定义一个 int 型变量，值为 45 
>>> i.value                               # 打印变量的值
45 
>>> i.value = 56                         # 改变该变量的值为 56 
>>> i.value                               # 打印变量的新值
56
清单 1. ctypes 字符串类型
从下面的例子可以更明显地看出 ctypes 里的变量类型和 C 语言变量类型的相似性：
>>> p = create_string_buffer(10)      # 定义一个可变字符串变量，长度为 10 
 >>> p.raw                                  # 初始值是全 0，即 C 语言中的字符串结束符’ \0 ’
'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'
 >>> p.value = "Student"                 # 字符串赋值
 >>> p.raw                                  # 后三个字符仍是’ \0 ’
'Student\x00\x00\x00'
 >>> p.value = "Big"                      # 再次赋值
 >>> p.raw                                   # 只有前三个字符被修改，第四个字符被修改为’ \0 ’
'Big\x00ent\x00\x00\x00'
下面例子说明了指针操作：
清单 3. ctypes 使用 C 语言指针
>>> i = c_int(999)                                 # 定义 int 类型变量 i，值为 999 
>>> pi = pointer(i)                                # 定义指针，指向变量 i 
>>> pi.contents                                     # 打印指针所指的内容
c_long(999) 
>>> pi.contents = c_long(1000)                   # 通过指针改变变量 i 的值
>>> pi.contents                                     # 打印指针所指的内容
c_long(1000)
清单 4. ctypes 使用 C 语言数组和结构体
>>> class POINT(Structure):                 # 定义一个结构，内含两个成员变量 x，y，均为 int 型
...     _fields_ = [("x", c_int), 
...                 ("y", c_int)] 
... 
>>> point = POINT(2,5)                       # 定义一个 POINT 类型的变量，初始值为 x=2, y=5 
>>> print point.x, point.y                     # 打印变量
2 5 
>>> point = POINT(y=5)                             # 重新定义一个 POINT 类型变量，x 取默认值
>>> print point.x, point.y                     # 打印变量
0 5 
>>> POINT_ARRAY = POINT * 3                    # 定义 POINT_ARRAY 为 POINT 的数组类型
# 定义一个 POINT 数组，内含三个 POINT 变量
>>> pa = POINT_ARRAY(POINT(7, 7), POINT(8, 8), POINT(9, 9))   
>>> for p in pa: print p.x, p.y                # 打印 POINT 数组中每个成员的值
... 
7 7 
8 8 
9 9
# https://docs.python.org/2/library/ctypes.html