        .section .text
        .global _start
_start:
        /*
        lui a0,%hi(__sample)
        addi a0,a0,%lo(__sample)
        */
        lui a0,%hi(__input)
        addi a0,a0,%lo(__input)
        jal ra,parse_dec_int

#define arrival_s0 s0
        addi arrival_s0,a1,0
#define earliest_s1 s1
        addi earliest_s1,zero,-1
#define newline_s2 s2
        addi newline_s2,zero,0xa
#define bus_s3 s3
        addi bus_s3,zero,-1

        addi a0,a0,1
_next_bus:
        jal ra,parse_dec_int

        addi t0,zero,0
_increment_time:
        add t0,t0,a1
        bltu t0,arrival_s0,_increment_time

        bgeu t0,earliest_s1,_ge
        /* if t0 is less than earliest_s1, t0 is the new earliest_s1 */
        addi earliest_s1,t0,0
        addi bus_s3,a1,0

_ge:
_next_char:
        lbu t0,0(a0)
        beq t0,newline_s2,_break
        addi a0,a0,1
        addi t0,t0,-0x30
        bgeu t0,newline_s2,_next_char
        addi a0,a0,-1
        jal zero,_next_bus

_break:
        sub t0,earliest_s1,arrival_s0
        mul t0,bus_s3,t0
        ebreak
