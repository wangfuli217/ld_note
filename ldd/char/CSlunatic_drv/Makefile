#用+= 可以实现多个模块同时编译
#obj-m += mod.o
obj-m += cslunatic_drv.o
#设置你嵌入式开发板的内核源码路径，主要是内核的include目录下的头文件
KDIR = /opt/DM8168_DVRRDK_V03.00.00.00/ti_tools/linux_lsp/linux-psp-dvr-04.04.00.01/src/linux-04.04.00.01
#KDIR = libmodules$(shell uname -r)build
PWD = $(shell pwd)

default:
    $(MAKE) -C$(KDIR) CROSS_COMPILE=/opt/armgcc/bin/arm-none-linux-gnueabi- ARCH=arm SUBDIRS=$(PWD) modules

#    $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
clean:    
    $(MAKE) -C$(KDIR) CROSS_COMPILE=/opt/armgcc/bin/arm-none-linux-gnueabi- ARCH=arm SUBDIRS=$(PWD) clean
    rm -rf Module.markers Modules.order Moduke.symvers