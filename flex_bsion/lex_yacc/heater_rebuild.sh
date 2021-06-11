#!/bin/sh
rm -f a.out lex.yy.c y.tab.c
lex heater.l
bison -d heater.y
mv heater.tab.h y.tab.h
mv heater.tab.c  y.tab.c
gcc lex.yy.c y.tab.c -o heater
cat heater.conf | ./heater
