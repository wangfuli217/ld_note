#!/bin/sh
#
#       $Id: microc.sh,v 1.4 2009/02/04 10:00:58 dvermeir Exp $
#
#	Usage:	microc basename.mi
#
#	e.g. "microc tst.mi"  to compile tst.mi, resulting in 
#
#	tst.s	assembler source code
#	tst.o	object file
#	tst	executable file
#
# determine basename
base=`basename $1 .mi`
# this checks whether $1 has .mi suffix
[ ${base} = $1 ] && { echo "Usage: microc basename.mi"; exit 1; }
# make sure source file exists
[ -f "$1" ] || { echo "Cannot open \"$1\""; exit 1; }
# compile to assembly code
./micro <$1 >${base}.s || { echo "Errors in compilation of $1"; exit 1; }
# assemble to object file: the --gdwarf2 option generates info for gdb
as --gdwarf2 ${base}.s -o ${base}.o  || { echo "Errors assembling $1.s"; exit 1; }
# link
ld ${base}.o -o ${base} || { echo "Errors linking $1.o"; exit 1; }
