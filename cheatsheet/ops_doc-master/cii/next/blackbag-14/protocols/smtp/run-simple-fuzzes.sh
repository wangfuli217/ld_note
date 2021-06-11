#!/bin/sh

WAIT=1

for N in fuzz*gen.case
do
	sleep $WAIT
	echo $N
	bkb blit -k
	$N
done
