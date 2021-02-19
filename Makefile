ARCH = -march=rv32i -mabi=ilp32
CFLAGS = -ffreestanding -nostdlib -mpreferred-stack-boundary=3 -Og

TARGET = riscv32-unknown-elf-
CC = $(TARGET)gcc
AS = $(TARGET)as
LD = $(TARGET)ld
OBJCOPY = $(TARGET)objcopy
OBJDUMP = $(TARGET)objdump

elfs := $(patsubst %.c,%.elf,$(wildcard *.c))

all: $(elfs)

%.elf: %.s Makefile
	$(AS) $(ARCH) $< -o $@

%.elf: %.c Makefile
	$(CC) $(ARCH) $(CFLAGS) $< -o $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.hex: %.bin
	python binhex.py $< > $@

clean:
	rm -f *.o *.elf *.bin *.out

dump: $(F)
	$(OBJDUMP) --disassembler-options=numeric,no-aliases -d $<

hex: $(F)
	cat $(F)

.SUFFIXES:
.INTERMEDIATE:
.PRECIOUS: %.c %.o %.elf %.bin %.hex
.PHONY: all clean
