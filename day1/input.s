        .section .rodata

        .global __input
__input:
        .word 990
        .incbin "input.txt"

        .global __sample
__sample:
        .word 26
        .incbin "sample.txt"
