#KERNELDIR=/usr/src/linux-headers-3.2.0-39-generic-pae
#KERNELDIR=/usr/src/kernels/3.10.0-957.5.1.el7.x86_64
KERNELDIR=/usr/src/kernels/3.10.0-693.el7.x86_64

PWD:=$(shell pwd)
obj-m :=hidep.o
modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)  modules
clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c *.order *.symvers
