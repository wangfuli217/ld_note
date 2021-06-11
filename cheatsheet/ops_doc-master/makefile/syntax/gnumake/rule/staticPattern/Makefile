# ---------------- 1
object = main.o tools.o

all : $(object)

# 1
# TARGET : TARGET_PATTERN : PREQUE_PATTERN
#$(object) : %.o : %.c
#	cc    -c -o $@ $?

clean :
	@rm -f *.o


# ================  2
# TARGET : TARGET_PATTERN : PREQUE_PATTERN
object2 = main.o tools.o hello.txt
all2 : $(object2)

# filter
$(filter %.o, $(object2)) : %.o : %.c
	cc    -c -o $@ $?

# PREQUE_PATTERN can be empty
$(filter %.txt, $(object2)) : %.txt :
	echo "hello $@" > $@


# ================== 3
#

object3 = helloWorld helloEarth helloYou
all3 : $(object3)
$(object3) : hello% : %
	@echo "ni hao"
World :
	@echo "World,"
Earth :
	@echo "Earth,"
You :
	@echo "You,"
