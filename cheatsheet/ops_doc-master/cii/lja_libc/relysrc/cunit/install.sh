#!/bin/bash
PREFIX=`pwd`/../../obj/CUnit-2.1-2
if [[ ! -d $PREFIX ]]; then
    mkdir -p $PREFIX
fi
CURPATH=`pwd`
tar -xjvf CUnit-2.1-2-src.tar.bz2
cd CUnit-2.1-2
./configure --prefix $PREFIX
make 
make install
make clean
cd $CURPATH
rm -rf CUnit-2.1-2
