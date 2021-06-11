#!/bin/bash
PREFIX=`pwd`/../../obj/libnet-1.1.2.1
CURPATH=`pwd`
tar -xvf libnet-1.1.2.1.tar.gz
cd libnet
./configure --prefix $PREFIX
make 
make install
make clean
cd $CURPATH
rm -rf libnet
