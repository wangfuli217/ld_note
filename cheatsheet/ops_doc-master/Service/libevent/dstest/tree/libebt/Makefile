CFLAGS = -Wall -g -O0

all:
	gcc ${CFLAGS} -I. -c ebt.c -lpthread -DDEBUG

clean:
	rm -f *.o *.fifo

codestyle:
	@indent -kr -i4 -ts4 -sob -ss -sc -npsl -pcs -bs -l200 -nut -npro -brf *.[ch]   
	-rm -f *.c~ 
	-rm -f *.h~

.PHONY: clean
.PHONY: codestyle
