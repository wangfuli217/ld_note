#!/bin/sh

VERBS="helo ehlo mail rcpt data"
CHARS="21 23 24 7e 25 27 2e 256e 2573 26 2a 2b 2d 5c 2f 3c 3e 3c3e 00 3d 3f 5b 5d 5b5d 5e 60 7b 7d 7b7d 7c"
WDTHS="1 101 257 1025 4097 8193 20000"

rm -f fuzz*gen.case

#for V in $VERBS
#do
#	for C in $CHARS
#	do
#		ln -s simplefuzz.sh fuzz-${V}-${C}-gen.case 2>&1 
#	done
#done

for V in $VERBS
do
  for C in $CHARS
  do
        for W in $WDTHS
	do
	        ln -s simplefuzz.sh fuzz-${V}-long-${C}-${W}-gen.case 
	done
  done
done
