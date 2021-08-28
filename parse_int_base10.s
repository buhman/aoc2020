        .section .text
        .global parse_int_base10
parse_int_base10:
        /* arg: r0 (char * s) */
        mov r1, #0 /* return: integer num */

        mov r3, #10 /* num multiplier */

_loop:
        ldrb r4, [r0], #1

        /* parse digit */
        sub r4, r4, #0x30
        cmp r4, #9
        mulls r1, r3, r1
        addls r1, r4, r1

        bls _loop

        bx lr
