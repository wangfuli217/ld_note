#
# test.c
#   +--> func_a.c
#   |
#   +--> func_b.c
#

CC = gcc
CFLAGS = -Wall

BIN = test
SRC = test.c func_a.c func_b.c
OBJ = $(SRC:.c=.o)
DEP = $(SRC:.c=.c.d)


all: $(BIN)
	@echo "Build ... $(BIN)"
	@echo ""

$(BIN): $(OBJ)
	$(CC) $(OBJ) -o $(BIN)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.c.d: %.c
	@echo "$@ \\" >  $@
	@$(CC) -M $<   >> $@ || rm $@

-include $(DEP)

clean:
	rm -f $(BIN) $(OBJ) $(DEP)

