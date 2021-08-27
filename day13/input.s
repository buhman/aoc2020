        .section .rodata

        .global __input
__input:
        .incbin "input.txt"

        .global __sample
__sample:
        .incbin "sample.txt"
