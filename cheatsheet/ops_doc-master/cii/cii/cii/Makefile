VPATH = src:include

LIB_DIR = lib

INCLUDE_DIR = include

LIB = $(LIB_DIR)/libcii.a

objects = arith.o assert.o except.o memchk.o atom.o\
		  arena.o list.o dlist.o table.o set.o array.o\
		  seq.o ring.o bit.o sparsearray.o fmt.o\
		  bst.o stack.o str.o text.o digraph.o\
		  indexminpq.o

all: $(objects)
	ar crs $(LIB) $(objects)

arith.o: arith.c arith.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

except.o: except.c except.h assert.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

assert.o: assert.c assert.h except.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

memchk.o: memchk.c mem.h assert.h except.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

atom.o: atom.c atom.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

arena.o: arena.c arena.h assert.h except.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

list.o: list.c list.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

dlist.o: dlist.c dlist.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

table.o: table.c table.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

set.o: set.c set.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

array.o: array.c array.h arrayrep.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

seq.o: seq.c seq.h array.h arrayrep.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

ring.o: ring.c ring.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

bit.o: bit.c bit.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

sparsearray.o: sparsearray.c sparsearray.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

fmt.o: fmt.c fmt.h assert.h mem.h except.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

bst.o: bst.c bst.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

stack.o: stack.c stack.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

str.o: str.c str.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

text.o: text.c text.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

indexminpq.o: indexminpq.c indexminpq.h assert.h mem.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

digraph.o: digraph.c digraph.h assert.h mem.h arena.h
	gcc -pg -g -c $< -I$(INCLUDE_DIR)

clean:
	rm *.o
	rm $(LIB)
