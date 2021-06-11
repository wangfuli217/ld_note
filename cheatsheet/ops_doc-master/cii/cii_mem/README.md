# c_tools
tools for C
使用方式：
./configure
make
sudo make install
安装在/usr/local/lib和/usr/local/include
代码中使用，只需要include相应头文件，链接时引入相应库即可。

libtools.a
头文件:tools-util.h
库文件：libtools.a
依赖：-lpthread -lrt
说明：包含assert系列宏，定时器，labmda宏，内存检测函数等。

libcircle_buff.a
头文件：circle_buff.h
库文件：libcircle_buff.a
依赖：-ltools
说明：包含一个循环缓冲区，可在共享内存上或者内存上分配。输出是输入的完整包。数据可能被覆盖。

libm_alloc.a
头文件：m_alloc.h
库文件：libm_alloc.a
依赖：-ltools
说明：包含一个共享内存上的内存分配函数。可以保证数据不会丢失。

libpsignal.a
头文件：psignal.h
库文件：libpsignal.a
依赖：-ltools
说明：包含一个进程间信号通信方式，信号可以携带最多1k参数。支持进程间广播和单播，单播支持等待返回。
