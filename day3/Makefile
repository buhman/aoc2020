ARCH = -march=rv32i -mabi=ilp32
CFLAGS = -Os -g $(ARCH)
TARGET = riscv32-unknown-elf-
CC = $(TARGET)gcc
AS = $(TARGET)as
M4 = m4

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.s: %.s.in
	$(M4) $< > $@

%.o: %.s
	$(AS) -g $(ARCH) $< -o $@

a.out: day3.o input.o
	$(CC) $(CFLAGS) -nostdlib $^ -o a.out

clean:
	rm -f *.o a.out

.SUFFIXES:
.INTERMEDIATE:
.PHONY: all clean
