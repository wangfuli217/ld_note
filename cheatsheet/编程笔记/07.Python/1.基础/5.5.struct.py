# struct.pack
    struct.pack用于将Python的值根据格式符，转换为字符串（因为Python中没有字节(Byte)类型，可以把这里的字符串理解为
字节流，或字节数组）。其函数原型为：struct.pack(fmt, v1, v2, …)，参数fmt是格式字符串，关于格式字符串的相关信息
在下面有所介绍。v1, v2, …表示要转换的python值。

import struct

a = 20
b = 400
 
str = struct.pack("ii", a, b)  #转换后的str虽然是字符串类型，但相当于其他语言中的字节流（字节数组），可以在网络上传输
print 'length:', len(str)
print str
print repr(str)

    格式符”i”表示转换为int，’ii’表示有两个int变量。进行转换后的结果长度为8个字节（int类型占用4个字节，两个int为8个字节），
可以看到输出的结果是乱码，因为结果是二进制数据，所以显示为乱码。可以使用python的内置函数repr来获取可识别的字符串，
其中十六进制的0x00000014, 0x00001009分别表示20和400。

# struct.unpack
    struct.unpack做的工作刚好与struct.pack相反，用于将字节流转换成python数据类型。它的函数原型为：struct.unpack(fmt, string)，
该函数返回一个元组。
str = struct.pack("ii", 20, 400)
a1, a2 = struct.unpack("ii", str)
print 'a1:', a1
print 'a2:', a2


>>> record = 'raymond   \x32\x12\x08\x01\x08' 
>>> name, serialnum, school, gradelevel = unpack('<10sHHb', record)
>>> from collections import namedtuple 
>>> Student = namedtuple('Student', 'name serialnum school gradelevel') 
>>> Student._make(unpack('<10sHHb', record)) 
Student(name='raymond   ', serialnum=4658, school=264, gradelevel=8)

# struct.calcsize
struct.calcsize用于计算格式字符串所对应的结果的长度，如：struct.calcsize(‘ii’)，返回8。因为两个int类型所占用的长度是8个字节。

# struct.pack_into, struct.unpack_from
这两个函数在Python手册中有所介绍，但没有给出如何使用的例子。其实它们在实际应用中用的并不多。
import struct
from ctypes import create_string_buffer
 
buf = create_string_buffer(12)
print repr(buf.raw)
 
struct.pack_into("iii", buf, 0, 1, 2, -1)
print repr(buf.raw)
 
print struct.unpack_from('iii', buf, 0)

#------------------------------------------------
在Python手册中，给出了C语言中常用类型与Python类型对应的格式符：
格式符  C语言类型          Python类型            Standard size
x       pad byte            no value             1
c       char                string of length 1   1
b       signed char         integer              1
B       unsigned char       integer              1
?       _Bool               bool                 1
h       short               integer              2
H       unsigned short      integer              2
i       int                 integer              4
I       unsigned int        integer or long      4
l       long                integer              4
L       unsigned long       long                 4
q       long long           long                 8
Q       unsigned long long  long                 8
f       float               float                4
d       double              float                8
s       char[]              string               
p       char[]              string               
P       void *              long                 

#------------------------------------------------------------------------------
Character   Byte order              Size and alignment
@           native                  native         凑够4个字节
=           native                  standard       按原字节数
<           little-endian           standard       按原字节数
>           big-endian              standard       按原字节数
!           network (= big-endian)  standard       按原字节数
