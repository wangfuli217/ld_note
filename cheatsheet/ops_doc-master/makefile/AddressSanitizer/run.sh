#!/bin/sh
#set -x

#export ASAN_SYMBOLIZER_PATH=/usr/bin/llvm-symbolizer-3.5
#export MUDFLAP_OPTIONS="-viol-abort -check-initialization"

for f in bin/*; do
	if [ ! -x $f ]; then
		continue
	fi
	OUT=$f.out
	echo -n "run $f: "
	$f > $OUT 2>&1
	if [ $? -eq 0 ]; then
		echo "PASS"
	else
		echo "ERROR DETECTED $OUT"
	fi
done

