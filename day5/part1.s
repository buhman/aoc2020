        addi s1,zero,0   /* highest seat id */
        addi s0,zero,781   /* index */
_loop:
        beq s0,zero,_forever
        addi s0,s0,-1

        slli t0,s0,2 /* x4 */
        lw a0,0(t0)
        jal ra,decode_call
        /* returns a1 row, a2 column */

        slli a1,a1,3  /* a1 = a1 * 8 */
        add a1,a1,a2  /* a1 = a1 + a2 */

        blt a1,s1,_loop
        add s1,zero,a1
        jal zero,_loop

_forever:
        lui t0,0xffff0
        sw s1,0x700(t0)
_forever1:
        jal zero,_forever1

/*
  arg a0 seat id

  return a1 row, a2 column
*/
decode_call:
        /* row */
        addi t2,zero,7   /* word bit-index */
        addi t3,zero,127
        addi t4,zero,0
        jal sp,_bsp_walk
        addi a1,t3,0     /* s1 = bsp row */

        /* column */
        addi t2,zero,3   /* word bit-index */
        addi t3,zero,7
        addi t4,zero,0
        jal sp,_bsp_walk
        addi a2,t3,0     /* s2 = bsp column */

        jalr zero,0(ra)

_bsp_walk:
        andi t6,a0,1

        addi t5,t3,1
        sub t5,t5,t4  /* midpoint = rs1 - rs2  */
        srli t5,t5,1
        bne t6,zero,_upper
_lower:
        sub t3,t3,t5
        jal zero,_lu_end
_upper:
        add t4,t4,t5
_lu_end:
        srli a0,a0,1
        addi t2,t2,-1
        bne t2,zero,_bsp_walk
        jalr zero,0(sp)
