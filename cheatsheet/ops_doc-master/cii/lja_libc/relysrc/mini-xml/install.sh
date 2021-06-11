#!/bin/bash
PREFIX=`pwd`/../../obj/mxml-2.7
CURPATH=`pwd`
tar -xvf mxml-2.7.tar.gz
cd mxml-2.7
./configure --prefix $PREFIX 
make
make install
make clean
cd $CURPATH
rm -rf mxml-2.7
