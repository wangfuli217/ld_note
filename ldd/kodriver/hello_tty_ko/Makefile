obj-m:=hello5.o
hello5-objs := helloko.o
KERNELBUILD :=/lib/modules/$(shell uname -r)/build
default: 
	make -C $(KERNELBUILD) M=$(shell pwd) modules
clean:
	rm -rf *.o *.ko *.mod.c .*.cmd *.markers *.order *.symvers .tmp_versions
