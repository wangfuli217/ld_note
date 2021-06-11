#定义变量
NAME=shell
BIN=$(NAME).bin
ELF=$(NAME).elf
OBJ=vector.o reset.o irq.o main.o nand.o uart.o led.o cmd.o 
BINPATH=/tftpboot
CFLAGS=-nostdlib #编译选项
LDFLAGS=-nostartfiles -nostdlib -Tuart.lds
#将来架构，操作系统变了只需CROSS_COMPILE
CROSS_COMPILE=arm-linux-
CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy
CP=cp

#arm-linux-objcopy -O binary uart.elf uart.bin
$(BIN):$(ELF)
	$(OBJCOPY) -O binary $(ELF) $(BIN)
	$(CP) $(BIN) $(BINPATH)

#uart.bin依赖uart.elf
#问uart.elf又依赖谁呢?
#答：依赖main.o uart.o
#...ld ... main.o uart.o -o uart.elf
$(ELF):$(OBJ)
	$(LD) $(LDFLAGS) -o $(ELF) $(OBJ)

#uart.efl依赖main.o uart.o
#main.o,uart.依赖main.c uart.c
%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

#将.s文件进行编译
%.o:%.s
	$(CC) $(CFLAGS) -c -o $@ $<

#make clean 删除目标文件
clean:
	rm $(BIN) $(ELF) $(OBJ)























