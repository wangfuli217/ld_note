sources = main.c
# replace .c with .d in $(sources) and ==> $(deps)
deps = $(sources:.c=.d)

# $$$$ in makefile ==> $$ in shell
# \1 match first ()
$(deps) : %.d : %.c
	cc -MM $< > $@.$$$$;	\
	sed 's,\($*\)\.o[ :]*,\1.o $@ :,g' < $@.$$$$ > $@;	\
	rm -f $@.$$$$

# error
#  without ";"
#  cc / sed / rm will run in different shell, so $$$$ 
#  
# error information :
# 
#$(deps) : %.d : %.c
#	cc -MM $< > $@.$$$$
#	sed 's,\($*\)\.o[ :]*,\1.o $@ :,g' < $@.$$$$ > $@
#	rm -f $@.$$$$


#$ make
#cc -MM main.c > main.d.$$
#sed 's,\(main\)\.o[ :]*,\1.o main.d :,g' < main.d.$$ > main.d
#/bin/sh: 1: cannot open main.d.16365: No such file
#make: *** [main.d] Error 2

#$ ls
#hello.txt  inc.h  main.c  main.d.16362  main.h  Makefile

