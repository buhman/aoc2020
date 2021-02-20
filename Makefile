ARCH = -march=rv32i -mabi=ilp32
CFLAGS = -ffreestanding -nostdlib -mpreferred-stack-boundary=3 -Og

TARGET = riscv32-unknown-elf-
CC = $(TARGET)gcc
AS = $(TARGET)as
LD = $(TARGET)ld
OBJCOPY = $(TARGET)objcopy
OBJDUMP = $(TARGET)objdump

I  = day5/part1.imem
I += day5/input.dmem
I  = day10/part1.imem
I += day10/input.dmem

all: $(I)

%.elf: %.s Makefile
	$(AS) $(ARCH) $< -o $@

%.elf: %.c Makefile
	$(CC) $(ARCH) $(CFLAGS) $< -o $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.imem: %.bin
	python binhex.py $< 256 > $@

%.dmem: %.txt %.py
	python $(dir $<)input.py $< 2048 > $@

clean:
	rm -f */*.o */*.elf */*.bin */*.out */*.imem */*.dmem */*.hex

dump: $(F)
	$(OBJDUMP) --disassembler-options=numeric,no-aliases -d $<

hex: $(F)
	cat $(F)

.SUFFIXES:
.INTERMEDIATE:
.PRECIOUS: %.c %.o %.elf %.bin %.hex
.PHONY: all clean
