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

export AS AR CC CPP LD NM OBJCOPY OBJDUMP RANLIB SIZE STRINGS STRIP
################################################################################
VERSION = 1
PATCHLEVEL = 0
SUBLEVEL = 1
EXTRAVERSION =
NAME = wangfl

COMPNOY = www.xianleidi.com
BUILD_DATE = $(shell date +%Y-%m-%d_%X)

REV = $(shell LANG=C svn info | grep 'Rev:' | cut -d ' ' -f4)

################################################################################
ifeq ($(USE_DEBUG),yes)
  DEBFLAGS = -DRTUD_DEBUG -g
else
  DEBFLAGS = 
endif

ARCH=X86_64

ifeq ($(ARCH),ARM)
  ARCHFLAGS = -D__ARM__
endif
ifeq ($(ARCH),I386)
  ARCHFLAGS = -D__I386__
endif
ifeq ($(ARCH),X86_64)
  ARCHFLAGS = -D__X86_64__
endif

ifeq ($(SVNVERSION),yes)
  RTUDRELEASE = "rtud ${VERSION}.${PATCHLEVEL}.${SUBLEVEL} @ svn ${REV} @${COMPNOY} build at ${BUILD_DATE}"
else
  RTUDRELEASE = "\"rtud ${VERSION}.${PATCHLEVEL}.${SUBLEVEL} @${COMPNOY} build at ${BUILD_DATE}\""
endif


################################################################################
# 构建时需要用到的设定值
# 
CFLAGS      = -g  -Wall ${DEBFLAGS} ${ARCHFLAGS} -Wextra -Wshadow -D_GNU_SOURCE
HEADER_OPS  =
LDFLAGS     = -lpthread -ldl

# 安装时需要用到的变量
EXEC_RTU   = rtud
INSTALL     = install
INSTALL_DIR = ${PRJROOT}/rootfs/bin

# 构建时需要用到的文件
RTU_OBJS    = cfg.o main.o  slogger.o clocks.o sockets.o  utils.o  strerr.o

# 构建时用到的规则
all:rtud 

# 应用程序版本信息
main.o : main.c
	${CC} ${CFLAGS} ${HEADER_OPS} -c $< ${LDFLAGS} -DRTUDRELEASE=${RTUDRELEASE}

.c.o:
	${CC} ${CFLAGS} ${HEADER_OPS} -c $< ${LDFLAGS} 

rtud:${RTU_OBJS}
	${CC} -o  ${EXEC_RTU} ${RTU_OBJS} ${LDFLAGS} 


.PHONY: clean
.PHONY: install

clean:
	-rm -f *.o ${EXEC_RTU}

install:
	
