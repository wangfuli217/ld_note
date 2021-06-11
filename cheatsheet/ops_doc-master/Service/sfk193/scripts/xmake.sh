#!/bin/bash
# XMake 0.5 - Cross network make of projects.
# Client script for the Linux/Mac command line.
# 
# Sync sources, compile remote, receive error output,
# forward compiled binaries to target device.
# requires:
#   sfk.exe on your Windows PC, download from
#     stahlworks.com/sfk.exe
#   xmakeserv.sh running on build server (which runs sfk)
# example call:
#   xmake.sh mp9 i686 200 clean
#   meaning: compile product mp9 for architecture i686
#            and target ip .200 from scratch (clean)

# === short parameters ===
export PRODUCT="$1"
export TOOLCHAIN="$2"
export TARGET="$3"
export CLEAN="$4"

if [ "$TOOLCHAIN" = "" ]; then
   echo "usage  : ./xmake.sh product architecture targetip [clean]"
   echo "example: ./xmake.sh mp8 bbb 192.168.1.100"
   echo "         ./xmake.sh mp9 a13 192.168.1.200 clean"
   exit
fi

# parameter "clean" must be 0 or 1
if [ "$CLEAN" = "clean" ]; then
   export CLEAN="1"
else
   export CLEAN="0"
fi

# === dataway defaults ===
# = all source code is edited in: LOCAL_WORK
# = xmakeserv.sh runs on machine: BUILD_SERVER
# = file transfer uses password : TRANSFER_PW
# = your Windows PC running DView is  : LOG_TARGET

export BUILD_SERVER=192.168.1.11:2201
export TRANSFER_PW=mycmdpw123
export LOG_TARGET=192.168.1.100

# === internal inits ===
# = this batch file logs to DView by network text
# = (enable Setup / General / Network text).
# = file sync should be non verbose.
# = sfk uses ftp password from SFK_FTP_PW.

export SFK_LOGTO="term,net:$LOG_TARGET"
export FTPOPT="-nohead -quiet -noprog"
export SFK_FTP_PW="$TRANSFER_PW"

# === auto extend short parms to full parms ===
# = extend product "mp9" to "m9player".
# = extend target "200" to "192.168.1.200".

if [ "$PRODUCT" = "mp8" ]; then
   export PRODUCT="m8player"
fi
if [ "$PRODUCT" = "mp9" ]; then
   export PRODUCT="m9player"
fi

# === show a hello in the network text (SFK_LOGTO) ===

sfk echo "[green]=== xmake: $PRODUCT $TOOLCHAIN for $TARGET with clean=$CLEAN ===[def]" +tolog

# === 1. sync changed files to build server ===

sfk select xmakerem.sh +sft $FTPOPT $BUILD_SERVER cput -yes
sfk select -dir $PRODUCT -subdir :tmp -file :.bak :.tmp +sft $FTPOPT $BUILD_SERVER cput -yes

# === 2. run build on server ===

rm xmakerem.log
sfk sft $FTPOPT $BUILD_SERVER run "bash xmakerem.sh $PRODUCT $TOOLCHAIN $TARGET $CLEAN $LOG_TARGET >xmakerem.log 2>&1" -yes
sfk sft $FTPOPT $BUILD_SERVER get xmakerem.log
cat xmakerem.log

# === 3. confirm completion ===

sfk echo "[green]=== xmake done. ===[def]" +tolog

# === uncomment this to keep script window open ===
# sfk echo "[Magenta]=== waiting for user to close script window. ===[def]" +tolog +then pause
