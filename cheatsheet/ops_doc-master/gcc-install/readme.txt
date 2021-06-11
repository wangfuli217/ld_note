http://joelinoff.com/blog/?p=1604


$ # Download the scripts using wget.
$ mkdir /opt/gcc-4.9.2
$ cd /opt/gcc-4.9.2
$ wget http://projects.joelinoff.com/gcc-4.9.2/bld.sh
$ wget http://projects.joelinoff.com/gcc-4.9.2/Makefile
$ chmod a+x bld.sh
$ make
[output snipped]
$ # The compiler is installed in /opt/gcc-4.9.2/rtf/bin


$ # Note that LD_LIBRARY_PATH must be used unless the
$ # compiler is installed in standard place.
$ export PATH="/opt/gcc-4.9.2/bin:${PATH}"
$ export LD_LIBRARY_PATH="/opt/gcc/4.9.2/lib64:/opt/gcc-4.9.2/lib:${LD_LIBRARY_PATH}"
$ cat >test.cc <<EOF
#include <iostream>
using namespace std;
main() {
  cout << "Hello, World!" << endl;
}
EOF
$ g++ -o test.exe -g -Wall test.cc
$ ./test.exe
Hello, World!


http://www.hellogcc.org/?p=34118
P.S.：
（1）编译libiconv时可能会有“'gets' undeclared here“错误，请参考这篇文章。
（2）如果机器是64位的，但是缺少32位的库文件。这样在编译gcc时会出现错误：“configure: error: 
I suspect your system does not have 32-bit developement libraries (libc and headers). If 
you have them, rerun configure with –enable-multilib. If you do not have them, and want to 
build a 64-bit-only compiler, rerun configure with –disable-multilib.”。提示需要配置“--disable-multilib”。