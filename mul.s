/*
multiply

  a0 = a0 * a1
  return to ra

*/
        addi t0,zero,0
_mul_loop:
        beq a1,zero,_mul_ret
        addi a1,a1,-1
        add t0,t0,a0
        jal zero,_mul_loop
_mul_ret:
        add a0,zero,t0
        jalr zero,0(ra)
