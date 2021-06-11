sources = main.c
objects = main.o

main : $(objects)
	gcc -o main $(objects)

# single target , multiple prerequisites 
# not good!
#$(objects) : $(sources) main.h
#	gcc -c $(sources)


main.o : $(sources) main.h
	gcc -c $(sources)

# maybe like below  ---------- maybe ERROR
#	$touch cleanA
#	$make cleanA
#	$make: `cleanA' is up to date.
cleanA :
	@rm $(objects) main
	

#[PHONY target]  ---------- OK
.PHONY : clean
clean :
	@rm $(objects) main
	@echo "OK"
# if $(objects) main not exist, error information as below :
#	$ make clean
#	$rm: cannot remove ‘main.o’: No such file or directory
#	$rm: cannot remove ‘main’: No such file or directory
#	$make: [clean] Error 1
#	@echo "OK"  will not be executed

.PHONY : noerrclean
noerrclean :
	-@rm $(objects) main
	@echo "OK"
#	$ make noerrclean
#	$rm: cannot remove ‘main.o’: No such file or directory
#	$rm: cannot remove ‘main’: No such file or directory
#	$make: [noerrclean] Error 1 (ignored)
#	$OK


