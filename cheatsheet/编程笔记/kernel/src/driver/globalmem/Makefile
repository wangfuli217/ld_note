#obj-m += globalmem_2minor.o
#obj-m += globalmem.o
obj-m += globalfifo.o

#EXTRA_CFLAGS = -g -O0

build:	kernel_modules
kernel_modules:
	make -C /lib/modules/$(shell uname -r)/build M=$(CURDIR) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(CURDIR) clean
