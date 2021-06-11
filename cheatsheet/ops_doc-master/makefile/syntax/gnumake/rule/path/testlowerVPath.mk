# very important: vpath is valid only in Makefile !!
# so you can look at error and ok .
# and think !

vpath %.h ./inc


# 1)  change order will cause use:  two/two.c or three/two.c
# 2)  vpath can be placed every where
vpath %.c ./one ./three ./two 
#vpath %.c ./one
#vpath %.c ./two
#vpath %.c ./three

main3 : one.c two.c main.h
	@echo $^
	cc -I./inc     $^   -o main3

clean :
	-rm main3

# place here , works ok
#vpath %.c ./three
