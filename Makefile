#ARCH = -march=rv32i -mabi=ilp32
ARCH = -march=rv32im -mabi=ilp32
CFLAGS = -ffreestanding -nostdlib -mpreferred-stack-boundary=4 -Og

TARGET = riscv32-unknown-elf-
CC = $(TARGET)gcc
AS = $(TARGET)as
LD = $(TARGET)ld
OBJCOPY = $(TARGET)objcopy
OBJDUMP = $(TARGET)objdump

elfs := $(patsubst %.c,%.elf,$(wildcard *.c))

all: $(elfs)

%.elf: %.s Makefile
	$(AS) $(ARCHM) $< -o $@

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
