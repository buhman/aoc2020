ARCH = -mthumb-interwork -march=armv4t
override CFLAGS += -Wall -mtune=arm7tdmi -ffreestanding -nostdlib -g
#DEFS = -D_START
ASFLAGS = -g

TARGET = arm-none-eabi-
CC = $(TARGET)gcc
AS = $(TARGET)as
LD = $(TARGET)ld
AR = $(TARGET)ar
OBJCOPY = $(TARGET)objcopy
OBJDUMP = $(TARGET)objdump

%.o: %.S
	$(CC) $(ARCH) $(ASFLAGS) $(DEFS) -c $< -o $@

%.o: %.s
	$(AS) $(ARCH) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(ARCH) $(CFLAGS) $(DEFS) $< -o $@

dump:
	arm-none-eabi-objdump -M reg-names-raw -D -j .text $(F)

a.out:
	$(LD) $^ -o $@

%.a:
	$(AR) rcs $@ $^

clean:
	rm -f *.o *.out *.hex *.elf

.SUFFIXES:
.INTERMEDIATE:
.PHONY: all clean dump
