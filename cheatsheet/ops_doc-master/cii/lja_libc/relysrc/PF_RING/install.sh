#!/bin/bash
PREFIX=`pwd`/../../obj/PF_RING-5.5.2
CURPATH=`pwd`
tar -xvf PF_RING-5.5.2.tar.gz
cd PF_RING-5.5.2/userland/lib
./configure --prefix $PREFIX
make
make install
make clean
cd $CURPATH
rm -rf PF_RING-5.5.2
