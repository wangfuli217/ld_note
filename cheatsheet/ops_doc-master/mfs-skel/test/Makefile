CROSS_COMPILE = ${TARGET}-
AS          = ${CROSS_COMPILE}as
AR          = ${CROSS_COMPILE}ar
CC          = ${CROSS_COMPILE}gcc
CPP         = ${CC} -E
LD          = ${CROSS_COMPILE}ld
NM          = ${CROSS_COMPILE}nm
OBJCOPY     = ${CROSS_COMPILE}objcopy
OBJDUMP     = ${CROSS_COMPILE}objdump
RANLIB      = ${CROSS_COMPILE}ranlib
SIZE        = ${CROSS_COMPILE}size
STRINGS     = ${CROSS_COMPILE}strings
STRIP       = ${CROSS_COMPILE}strip

CFLAGS      = -g -Wall ${DEBFLAGS} ${ARCHFLAGS} -Wextra -Wshadow -D_GNU_SOURCE
HEADER_OPS  =
LDFLAGS     = -lrt -lpthread

OBJS    = clocks.o crc.o strerr.o delayrun.o mfstest_clocks.o mfstest_crc32.o mfstest_datapack.o mfstest_delayrun.o random.o


all: mfstest_clocks  mfstest_crc32 mfstest_datapack mfstest_delayrun stats random

.c.o:
	${CC} ${CFLAGS} ${HEADER_OPS} -c $< ${LDFLAGS} 

mfstest_clocks: $(OBJS)
	${CC} -o  mfstest_clocks clocks.o mfstest_clocks.o ${LDFLAGS}

mfstest_crc32: $(OBJS)
	${CC} -o  mfstest_crc32 crc.o mfstest_crc32.o clocks.o ${LDFLAGS}
    
mfstest_datapack: $(OBJS)
	${CC} -o  mfstest_datapack mfstest_datapack.o ${LDFLAGS}
    
mfstest_delayrun: $(OBJS)
	${CC} ${LDFLAGS}  mfstest_delayrun.o clocks.o strerr.o delayrun.o -o mfstest_delayrun
    
stats: 
	${CC} ${LDFLAGS} -DTEST stats.c -o stats
    
random: 
	${CC} ${LDFLAGS} -DTEST random.c clocks.c -o random
    
.PHONY: clean
clean:
	-rm -f *.o *.i mfstest_clocks  mfstest_crc32 mfstest_datapack mfstest_delayrun stats random core tags