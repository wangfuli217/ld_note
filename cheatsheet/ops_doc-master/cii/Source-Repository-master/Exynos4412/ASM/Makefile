TARGET=asm
all:
	arm-none-eabi-gcc-4.6.2 -O0 -g -c -o $(TARGET).o $(TARGET).s
	arm-none-eabi-ld		$(TARGET).o -Ttext 0x40008000 -o $(TARGET).elf
	arm-none-eabi-objcopy   -O binary -S  $(TARGET).elf  $(TARGET).bin
	arm-none-eabi-objdump   -D $(TARGET).elf >$(TARGET).dis 
clean:
	rm -rf *.o *.elf *.dis *.bin
