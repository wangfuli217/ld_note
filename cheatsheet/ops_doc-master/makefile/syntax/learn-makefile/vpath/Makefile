#VPATH = ./src:./header

vpath %.h ./header
vpath %.c ./src

objects = main.o

main: $(objects)
	cc -o main $(objects)

main.o: main.c defs.h

.PHONY: clean
clean:
	-rm main $(objects)

