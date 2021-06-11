#!/bin/bash
#需要预先安装有libnet和libpcap
PREFIX=`pwd`/../../obj/libnids-1.24
CURPATH=`pwd`
LIBPCAP= `pwd`/../../obj/libpcap-1.3.0
LIBNET=`pwd`/../../obj/libnet-1.1.2.1
tar -xvf libnids-1.24.tar.gz
cd libnids-1.24
./configure --prefix=$PREFIX --with-libpcap=$LIBPCAP  --with-libnet=$LIBNET  --disable-libglib

make 
make install
make clean
cd $CURPATH
rm -rf libnids-1.24
