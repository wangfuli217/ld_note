#!/bin/bash
#
# a simple script that will install libevent into some PREFIX you specify
# script looks for a ~/usr and ~/local if you don't specify anything
#

LEVER=1.4.8
LEFILE=libevent-$LEVER-stable.tar.gz
LEDIR=libevent-$LEVER-stable

if [ ! -f  local_libevent_installer.sh ]; then
  echo "You should be running this from the zunkfs directory so I can create the handy file needed for the Makefile"
  exit
fi

if [ -z $PREFIX ]; then
  cd $HOME
  TARGET_OPTIONS="usr local"

  for I in $TARGET_OPTIONS; do
    if [ -d ./$I ] ; then
      TARGET=$I
    fi
  done

  if [ -z $TARGET ] ; then
    echo "I couldn't find a TARGET in ~ (options considered: $TARGET_OPTIONS)"
    exit
  fi
  PREFIX=$HOME/$TARGET
fi

if [ ! -d $PREFIX ]; then
  echo "$PREFIX does not exist.  How sad.  I can't continue without some sort of target"
  echo "Try running me like: "
  echo "  mkdir ~/usr"
  echo "  PREFIX=~/usr ./local_libevent_installer.sh"
fi

echo "I am about to install $LEFILE using PREFIX=$PREFIX"
read -p "Continue (y/n)?"
if [ $REPLY != "y" ]; then
  echo "Exiting..."
  exit 1
fi

cd $PREFIX
sleep 1

if [ ! -d src ] ; then
  mkdir src
fi

cd src

if [ ! -f $LEFILE ] ; then
  echo "Starting download of $LEFILE"
  wget --quiet http://monkey.org/~provos/$LEFILE
  echo "download done"
fi

if [ ! -d $LEDIR ] ; then
  tar xvfz $LEFILE
fi

cd $LEDIR
./configure --prefix=$PREFIX/
make clean
make
make install

echo 
echo "-----------------------------------------"
echo "Go and set the following environment variable somewhere (.bashrc perhaps)"
echo "export LIBEVENT_PREFIX=$PREFIX"
