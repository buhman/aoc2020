/*
part1:
  12,658 cycles
  10,234 instructions
*/
        addi x31,x0,89 /* length of input (in bytes) */

        /*
        build heap
        */
        addi x1,x0,1
_heap_up1:
        addi x2,x1,0 /* child index */
_heap_up2:
        addi x3,x2,-1
        srli x3,x3,1 /* parent index */

        lbu x4,0(x2) /* child value */
        lbu x5,0(x3) /* parent value */

        blt x4,x5,_parent_larger

        sb x4,0(x3) /* swap parent/child values */
        sb x5,0(x2)

        addi x2,x3,0
        bne x2,x0,_heap_up2
_parent_larger:
        addi x1,x1,1
        blt x1,x31,_heap_up1

        /*
        heap sort
        */
        addi x1,x31,-1 /* end of heap */
_heap_swap:
        lb x3,0(x0)  /* invariant: the (current) largest value in the heap is at 0 */
        lb x4,0(x1) /* .. swap 0 with the value at the end of the heap */
        sb x4,0(x0)
        sb x3,0(x1)

        /* restore heap invariant */
        addi x3,x0,0 /* root index */
_heap_down:
        slli x4,x3,1 /* child0 index */
        addi x4,x4,1
        bge x4,x1,_child0_end
        addi x5,x4,1 /* child1 index */
        addi x6,x3,0 /* swap index */

        lbu x7,0(x3) /* root value */
        lbu x8,0(x4) /* child0 value */
        bge x7,x8,_root_larger0 /* x7 >= x8 */
        addi x6,x4,0 /* child0 is larger */
_root_larger0:
        bge x5,x1,_child1_end
        lbu x9,0(x5) /* child1 value */
        lbu x10,0(x6) /* swap value (child0, or root) */
        bge x10,x9,_swap_larger1
        addi x6,x5,0 /* child1 is larger */
_swap_larger1:
_child1_end:
        beq x6,x3,_swap_root

        lbu x11,0(x6) /* X_X so many loads; rip CPI */
        sb x11,0(x3)
        sb x7,0(x6)

        addi x3,x6,0
        jal x0,_heap_down
_swap_root:
_child0_end:
        addi x1,x1,-1
        bne x1,x0,_heap_swap

        /*
        part1
        */
        addi x10,x0,1 /* 1 */
        addi x11,x0,0 /* number of 1s */
        addi x12,x0,3 /* 3 */
        addi x13,x0,1 /* number of 3s; always starts at 1 */
        addi x1,x0,0 /* index */
        addi x2,x0,0 /* last value */
_part1:
        lbu x3,0(x1) /* value */
        sub x4,x3,x2
        bne x4,x10,_one
        addi x11,x11,1
_one:
        bne x4,x12,_three
        addi x13,x13,1
_three:
        addi x1,x1,1
        addi x2,x3,0
        blt x1,x31,_part1
_part1_end:
        sw x11,1024(x0)
        sw x13,1024(x0)
        addi a0,x11,0
        addi a1,x13,0
        jal ra,mul_call
        sw a0,1024(x0)
        csrrs x1,cycle,zero
        sw x1,1024(x0)
        csrrs x1,instret,zero
        sw x1,1024(x0)
_forever:
        jal x0,_forever
mul_call:
        .include "mul.s"
