ifneq ($(KERNELRELEASE), )
	obj-m := kset_sample.o
else
	KERNELRELEASE ?= /lib/modules/$(shell uname -r)/build
	PWD := $(shell pwd)
default:
	$(MAKE) -C $(KERNELRELEASE) M=$(PWD) modules
endif