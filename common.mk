ARCH = -march=rv32im -mabi=ilp32
ASFLAGS = -g

TARGET = riscv32-unknown-elf-
CC = $(TARGET)gcc
AS = $(TARGET)as
LD = $(TARGET)ld
OBJCOPY = $(TARGET)objcopy
OBJDUMP = $(TARGET)objdump

%.o: %.S
	$(CC) $(ARCH) $(ASFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ARCH) $(ASFLAGS) $< -o $@

a.out:
	$(LD) $^ -o $@

clean:
	rm -f *.o *.out *.hex *.elf

.SUFFIXES:
.INTERMEDIATE:
.PRECIOUS: %.elf %.imem
.PHONY: all clean %.dump
