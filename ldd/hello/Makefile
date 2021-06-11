ifneq ($(KERNELRELEASE), )
	obj-m := hello.o
else
	KERNELDIR ?= /lib/modules/$(shell uname -r)/build
	PWD := $(shell pwd)
default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
endif

clean:  
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions *.unsigned *.symvers *.order

# obj-m := hello.o  
# KERNELDR := /usr/src/linux-2.6.26  
# PWD := $(shell pwd)  
# modules:  
#     $(MAKE) -C $(KERNELDR) M=$(PWD) modules  
# moduels_install:  
#     $(MAKE) -C $(KERNELDR) M=$(PWD) modules_install  
# clean:  
#     rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions