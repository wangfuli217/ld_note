#!/bin/bash
#
# XMakeRem 0.5 - Cross network make of projects.
# Compile command script.
# 
# Compile on build server, send error output to your PC,
# forward compiled binaries to target device.
#
# This is edited on your Windows PC, and on every change
# sent again to the build server, to allow easy editing
# of all XMake scripts in one place.
#
# Store and edit this using UNIX LINE ENDINGS (LF only).
# While editing in DView check the line end info after :file:.
# If it shows [crlf] click on the gray arrows nearby.

# === parameters and dataway ===
export PRODUCT=$1
export TOOLCHAIN=$2
export TARGET=$3
export CLEAN=$4
export LOG_TARGET=$5
export UPDATE_PW=mybinpw456

# === expand short parameters ===
if [ "$CLEAN" -eq "1" ]; then
   export CLEAN="clean"
else
   export CLEAN=""
fi

# === internal inits ===
if [ "$LOG_TARGET" = "" ]; then
   export SFK_LOGTO="term"
else
   export SFK_LOGTO="term,net:$LOG_TARGET"
fi
export FTPOPT="-nohead -quiet -noprog"
export TONETLOG="sfk filt -srep _\xe2\x80\x3f_\q_ -high Red error +tolog"
export SFK_FTP_PW=$UPDATE_PW
if [ ! -d $PRODUCT ]; then
   sfk echo "[Red]no product dir found: $PRODUCT[def]" +tolog
   exit
fi

# define output binaries, clean them up first
export BINARY=bin$TOOLCHAIN/$PRODUCT
rm $BINARY
rm $PRODUCT.new

# === 1. run whatever build system exists ===

sfk echo "[green]=== xmakerem: $PRODUCT $TOOLCHAIN $CLEAN for $TARGET ===[def]" +tolog
cd $PRODUCT
bash 01-make-all.sh $TOOLCHAIN $CLEAN 2>&1 | $TONETLOG
if [ ! -f $BINARY ]; then
   sfk echo "[Red]build failed, no binary: $BINARY[def]" +tolog
   exit
fi

# === 2. send output binary to target ===
# = in this example, target reacts on an update file like m9player.new,
# = replacing it's own binary by that, re-running itself.
# = an sfk sftserv must be running on the target.

sfk echo "[green]=== update target $TARGET ===[def]" +tolog
cp $BINARY $PRODUCT.new | $TONETLOG
sfk sft $TARGET put $PRODUCT.new | $TONETLOG

sfk echo "[green]=== xmakerem done. ===[def]" +tolog
