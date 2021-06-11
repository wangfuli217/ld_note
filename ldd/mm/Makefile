obj-m:= mm.o
# KDIR is the location of the kernel source.  The current standard is
# to link to the associated source tree from the directory containing
# the compiled modules.
KDIR:=/lib/modules/$(shell uname - r)/build
# PWD is the current working directory and the location of our module
# source files.
PWD:=$(shell pwd)
# default is the default make target.  The rule here says to run make
# with a working directory of the directory containing the kernel
# source and compile only the modules in the PWD (local) directory.
default:
$ (MAKE) - C $ (KDIR) M=$(PWD) modules clean:
rm - rf *.o *.ko *.mod.c
