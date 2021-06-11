all:
	rm -rf fcgi-2.4.0
	tar -xvf fcgi-2.4.0.tar.gz
	rm -rf spawn-fcgi-spawn-fcgi-1.6.4
	tar -xvf spawn-fcgi-spawn-fcgi-1.6.4.tar.gz
	cp -r fcgio.cpp fcgi-2.4.0/libfcgi
	cd fcgi-2.4.0;./configure;make;cd -;
	#yum -y install autoreconf
	#yum -y install install autoconf automake libtoo
	cd spawn-fcgi-spawn-fcgi-1.6.4;./autogen.sh;./configure;make;	
	
#直接运行测试程序
#spawn-fcgi-spawn-fcgi-1.6.4/src/spawn-fcgi -f fcgi-2.4.0/examples/echo-cpp -p 8888 -F 10
