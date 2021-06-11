#定义各种变量
NAME=uart
BIN=$(NAME).bin
ELF=$(NAME).elf
OBJ=main.o uart.o #注意顺序
BINPATH=/tftpboot
CFLAGS=-nostdlib #编译选项
LDFLAGS=-nostartfiles -nostdlib -Ttext=0x20008000 -e main #链接选项
CROSS_COMPILE=arm-linux-
CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy
CP=cp

#依赖
$(BIN):$(ELF)
	$(OBJCOPY) -O binary $(ELF) $(BIN)
	$(CP) $(BIN) $(BINPATH)

#bin依赖elf
#问：elf从何而来
#答：elf依赖.o
$(ELF):$(OBJ)
	$(LD) $(LDFLAGS) -o $(ELF) $(OBJ)

#elf依赖.o
#问：.o从何而来
#答：.o依赖自己对应的.c
%.o:%.c
	$(CC) $(CFLAGS) -c -o $@ $<

#清除目标文件
clean:
	rm $(BIN) $(ELF) $(OBJ)

















