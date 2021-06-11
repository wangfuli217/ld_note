obj-m += simple_blk.o
KDIR := /lib/modules/$(shell uname -r)/build
EXTRA_CFLAGS = -g -O0 -std=gnu99

build:	kernel_modules
kernel_modules:
	make -C $(KDIR) M=$(CURDIR) modules
