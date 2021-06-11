obj-m:=poll.o
KERNELBUILD :=/lib/modules/$(shell uname -r)/build
default: 
	make -C $(KERNELBUILD) M=$(shell pwd) modules
	$(CC)  app_write.c -o app_write
	$(CC)  app_read.c -o app_read
	rm -rf *.mod.c  *.mod.o  *.o
	rm -rf .*.ko.cmd  .*.mod.o.cmd  .*.o.cmd  .tmp_versions
clean:
	rm -rf app_write app_read *.o *.ko *.mod.c .*.cmd *.markers *.order *.symvers .tmp_versions
