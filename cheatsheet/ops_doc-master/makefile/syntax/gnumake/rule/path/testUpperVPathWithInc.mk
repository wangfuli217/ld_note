# very important: VPATH is valid in Makefile !!
# so you can look at error and ok .
# and think !

VPATH = ./: ./src:./inc

error : main2.c main.h
	cc     $^   -o main2
#  1)  MAKEFILE's  VPATH  not equil  cc path
#	the output is below :
#	$cc     ./src/main2.c ./inc/main.h   -o main2
#	$./src/main2.c:2:18: fatal error: main.h: No such file or directory
#   cc     ./src/main2.c ./inc/main.h  -I ./inc -o main2

# 2) linux 's PATH not equil cc's path
# test like below
# a) $PATH
# b) sudo cp inc/main.h /usr/local/bin
# c) run make ... and got a same error msg


# cc's path is not equil Makefile's path or Shell's path
# use -I./inc for add ./inc for cc path
ok : main2.c main.h
	cc -I./inc     $^   -o main2

clean :
	-rm main2
