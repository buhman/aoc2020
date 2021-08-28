ARCH = -mthumb-interwork -march=armv4t
override CFLAGS += -Wall -mtune=arm7tdmi -ffreestanding -nostdlib -g
ASFLAGS = -g

TARGET = arm-none-eabi-
CC = $(TARGET)gcc
AS = $(TARGET)as
LD = $(TARGET)ld
OBJCOPY = $(TARGET)objcopy
OBJDUMP = $(TARGET)objdump

%.o: %.S
	$(CC) $(ARCH) $(ASFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ARCH) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(ARCH) $(CFLAGS) $< -o $@

dump:
	arm-none-eabi-objdump -M reg-names-raw -D -j .text $(F)

a.out:
	$(LD) $^ -o $@

clean:
	rm -f *.o *.out *.hex *.elf

.SUFFIXES:
.INTERMEDIATE:
.PHONY: all clean dump
