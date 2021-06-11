obj-m:=mmap.o
KERNELBUILD :=/lib/modules/$(shell uname -r)/build
default: 
	make -C $(KERNELBUILD) M=$(shell pwd) modules
	$(CC)  tmmap.c -o tmmap
	rm -rf *.mod.c  *.mod.o  *.o
	rm -rf .*.ko.cmd  .*.mod.o.cmd  .*.o.cmd  .tmp_versions
clean:
	rm -rf tmmap *.o *.ko *.mod.c .*.cmd *.markers *.order *.symvers .tmp_versions
