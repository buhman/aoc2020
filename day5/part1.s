/*
 instructions 97446
 cycles 98693
*/

        lui s3,1 /* 4096 */
        addi s2,zero,1023 /* lowest seat id */
        addi s1,zero,0    /* highest seat id */
        addi s0,zero,781   /* index */
_loop1:
        beq s0,zero,_exit1
        addi s0,s0,-1

        slli t0,s0,2 /* x4 */
        lw a0,0(t0)
        jal ra,decode_call
        /* returns a1 row, a2 column */

        slli a1,a1,3  /* a1 = a1 * 8 */
        add a1,a1,a2  /* a1 = a1 + a2 */

        slli t0,a1,1  /* halfword address */
        add t1,s3,t0
        sh a1,0(t1)

        blt a1,s2,_lowest  /* a1 < s2 */
        blt s1,a1,_highest /* s1 < a1 */
        jal zero,_loop1
_lowest:
        add s2,zero,a1
        jal zero,_loop1
_highest:
        add s1,zero,a1
        jal zero,_loop1

_exit1:
        lui t0,0xffff0  /* high memory */
        sw s1,0x700(t0)
        sw s2,0x700(t0)

        /* part2 */
        addi t0,s2,0 /* lowest (loop start) */
        /*addi t1,zero,s1 /* highest (loop stop) */
_loop2:
        slli t2,t0,1 /* halfword address */
        add t2,t2,s3
        lh t3,2(t2)  /* the halfword following t2 */
        addi t0,t0,1
        bne t3,t0,_missing
        jal zero,_loop2

_missing:
        lui t1,0xffff0  /* high memory */
        sw t0,0x700(t1)

        csrrs t3,instret,zero
        sw t3,0x700(t1)
_forever:
        jal zero,_forever

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
