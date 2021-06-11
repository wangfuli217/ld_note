#!/bin/sh
rm -f lexer
lex lex_man.L
gcc lex.yy.c -o lexer -ll
./lexer
