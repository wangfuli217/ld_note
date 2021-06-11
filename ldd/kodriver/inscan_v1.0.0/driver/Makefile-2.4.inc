#
#
# Inscan -- LINUX device driver Makefile
#
# Copyright (c) 2004-2006 involuser
#
#VERSION=2
#REL=0
#RELEASE=CAN4LINUX-$(VERSION)_$(REL)
#DVERSION=$(VERSION).$(REL)

LINUXTARGET=LINUXOS

KVERSION= $(shell uname -r)

CONFIG := $(shell uname -n)

CTAGS =	ctags --c-types=dtvf
CTAGS =	elvtags -tsevl

TITLE = Involuser CAN driver inscan

TARGET=INS_CAN
TARGET_MATCHED = false
CAN_MAJOR  :=  $(shell awk '$$2=="inscan" {print $$1}' /proc/devices)

#location of the compiled objects and the final driver module
OBJDIR = .

DEBUG=DEBUG=1
DEBUG=NODEBUG


DEFS = -DCAN_SYSCLK=8 -DINVOLUSER  -DMODULE



ifeq "$(LINUXTARGET)" "LINUXOS"
#use normal Linux OS
LIBS   =

CAN_MODULE = inscan.o

PROJECTHOME=$(shell pwd)
INSTALLHOME=/usr/src
endif
###########################################################################





TOOLS=

BOLD		= "\033[1m"
BOLD		= "\033[0;31m"
NBOLD		= "\033[0m"

ECHO		= /bin/echo -e

COMPILE	= $(ECHO) "--- Compiling "$(BOLD)$<$(NBOLD)" for $(TARGET) on $(LINUXTARGET) ..." ; \
	  $(TOOLS)gcc
DEPEND	= $(ECHO) "--- Checking dependencies..." ; $(TOOLS)$(CPP)
RLINK	= $(ECHO) "--- Linking (relocatable) "$(BOLD)$@$(NBOLD)"..." ;\
	  $(TOOLS)ld -r
LINK	= $(ECHO) "--- Linking "$(BOLD)$@$(NBOLD)"..." ; $(TOOLS)gcc
YACC	= $(ECHO) --- Running bison on $(BOLD)$<$(NBOLD)...; bison -d -y
LEX	= $(ECHO) --- Running flex on $(BOLD)$<$(NBOLD)...; flex

CC	= $(COMPILE)

all: $(CAN_MODULE)


# should be for all Kernels > 2.2.17 ???
# for each kernel ther is a set of kernel specific headers in
# /lib/modules/`uname -r`/build/include
#
ifeq "$(LINUXTARGET)" "LINUXOS"
ifeq "$(findstring 2.4., $(KVERSION))" ""
 INCLUDES = -Isrc
 INCLUDES = -I.
else
 INCLUDES = -Isrc -I/lib/modules/`uname -r`/build/include
 INCLUDES = -I. -I/lib/modules/`uname -r`/build/include
endif
endif

# That are the finally used flags for compiling the sources
CFLAGS = -Wall -D__KERNEL__ -DLINUX -O2 -Wstrict-prototypes -fomit-frame-pointer $(DEFS) $(OPTIONS) $(INCLUDES) -DVERSION=\"inscan-2.14\"


VPATH=src
# all the files to be compiled into object code
OBJS	=	\
	    core.o		\
	    open.o		\
	    read.o		\
	    write.o		\
	    ioctl.o		\
	    select.o	\
	    close.o		\
	    debug.o		\
	    error.o		\
	    util.o		\
	    sysctl.o	\
	    async.o	\


OBJS += sja1000funcs.o	    \
        ins_pci.o   \
        ins_isa.o  


$(CAN_MODULE):  $(addprefix $(OBJDIR)/,$(OBJS)) $(OBJDIR)
	@$(RLINK) -o $@ $(addprefix $(OBJDIR)/,$(OBJS))
$(OBJDIR)/core.o: core.c can4linux.h defs.h
	@echo "Kernel: $(KVERSION);" 
	@$(COMPILE) -c $ -D__KERNEL__ -DLINUX -O2 -Wstrict-prototypes -fomit-frame-pointer $(DEFS) $(OPTIONS) $(INCLUDES) -DVERSION=\"$(DVERSION)_$(TARGET)\" $(INCLUDES) -o $@ $<
$(OBJDIR)/open.o: open.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/read.o: read.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/write.o: write.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/ioctl.o: ioctl.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/select.o: select.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS)  $(INCLUDES) -o $@ $<
$(OBJDIR)/async.o: async.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS)  $(INCLUDES) -o $@ $<
$(OBJDIR)/close.o: close.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/sja1000funcs.o: sja1000funcs.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/util.o: util.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/sysctl.o: sysctl.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/error.o: error.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/debug.o: debug.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/ins_pci.o: ins_pci.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<
$(OBJDIR)/ins_isa.o: ins_isa.c can4linux.h defs.h
	@$(COMPILE) -c $(CFLAGS) $(INCLUDES) -o $@ $<




# load host specific CAN configuration
config:
	@echo "Loading etc/$(CONFIG).conf CAN configuration"
	utils/cansetup etc/$(CONFIG).conf
	echo 0 >/proc/sys/Can/dbgMask


#unload the CAN driver module
uninstall:
	@echo "Removing Driver Module from Kernel"
	$(shell if grep inscan /proc/modules > /dev/null ; then \
	 rmmod inscan ; fi)


clean:
	-rm -f tags
	-rm -f *.o *.ko
	-rm -f .*.cmd *.mod.c
	-rm -rf .tmp_versions
	-rm -rf *~

nodes:
	@echo "Creating devices file for Involuser PCI CAN driver..."
	@rm -rf /dev/can*
	-mknod /dev/can0 c $(CAN_MAJOR) 0
	-mknod /dev/can1 c $(CAN_MAJOR) 1
	-mknod /dev/can2 c $(CAN_MAJOR) 2
	-mknod /dev/can3 c $(CAN_MAJOR) 3
	-mknod /dev/can4 c $(CAN_MAJOR) 4
	-mknod /dev/can5 c $(CAN_MAJOR) 5
	-mknod /dev/can6 c $(CAN_MAJOR) 6
	-mknod /dev/can7 c $(CAN_MAJOR) 7
	chmod 666 /dev/can[0-7]

install:
	-@rm -rf  /lib/modules/$(shell uname -r)/kernel/drivers/inscan
	@mkdir /lib/modules/$(shell uname -r)/kernel/drivers/inscan
	@echo "insmod inscan.o driver into kernel"
	$(shell [ -f inscan.o ]  && cp ./inscan.o /lib/modules/$(shell uname -r)/kernel/drivers/inscan/ && depmod && modprobe inscan)
 





