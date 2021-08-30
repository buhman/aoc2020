        .section .text
#ifdef _START
        .global _start
_start:
#endif
        .global day1_part1
day1_part1:
        mov fp, sp
        str lr, [sp, #-4]!

        /*ldr r0, =__sample*/
        ldr r0, =__input
        ldr r10, [r0], #4 /* size of input */
        add r10, r10, r0 /* end of r0 */
        ldr r7, =#2020 /* goal number */

        /* parsed input */
        add r9, sp, #0

_next_int:
        bl parse_int_base10
        str r1, [sp, #-4]!

        cmp r10, r0
        bhi _next_int

        mov r8, r9
_outer_loop:
        ldr r0, [r8, #-4]!
        bl compare
        cmp r3, r7
        bne _outer_loop

        /* part1: multiply */
_mul:
        mul r10, r0, r1
#ifdef _START
_stop:
        b _stop
#else
        mov sp, fp
        ldr lr, [fp, #-4]!
        mov r0, r10
        bx lr
#endif

compare:
        /* arg: r0 (int) */
        mov r2, r9
_compare_loop:
        ldr r1, [r2, #-4]!

        add r3, r1, r0
        cmp r3, r7

        cmpne r2, sp /* stack grows down */
        bhi _compare_loop

        bx lr
