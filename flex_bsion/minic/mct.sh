#!/bin/sh
#
#	Usage:	mct basename
#
#	e.g. "mct tst"  to compile tst.c, 
#
#	No output except errors on stderr.
#
#	First make sure source file exists
#
if [ ! -f "$1.c" ] 
then
	echo "Cannot open \"$1.c\""
	exit 1
fi
#
./minic $1 <$1.c
