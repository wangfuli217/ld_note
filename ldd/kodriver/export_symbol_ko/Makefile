obj-m:=hello.o
hello-objs := helloko.o
KERNELBUILD :=/lib/modules/$(shell uname -r)/build
KBUILD_EXTRA_SYMBOLS +=$(shell pwd)/h1/Module.symvers
export KBUILD_EXTRA_SYMBOLS
default: 
	
	make -C $(KERNELBUILD) M=$(shell pwd) modules
clean:
	rm -rf *.o *.ko *.mod.c .*.cmd *.markers *.order *.symvers .tmp_versions
