#!/bin/bash
PREFIX=`pwd`/../../obj/libpcap-1.3.0
CURPATH=`pwd`
tar -xvf libpcap-1.3.0.tar.gz
cd libpcap-1.3.0
./configure --prefix $PREFIX
make
make install
make clean
cd $CURPATH
rm -rf libpcap-1.3.0
