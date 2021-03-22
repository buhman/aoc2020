/*
single-stage:
  instret = 36080
  cycle = 42110
pipelined:
  instret = 36077
  cycle = 59970
*/

        .section .text.vector
        jal x0,_start

        .section .text
_start:
        addi x31,x0,200  /* (len(input)) */
        slli x31,x31,2    /* ..as bytes   */

        addi x4,x0,2020  /* desired sum */

        addi x1,x0,-4
_inc10:
        addi x1,x1,4
        beq x1,x31,_forever
        addi x2,x1,4
        lw x10,0(x1)
_loop2:
        lw x11,0(x2)

        add x12,x10,x11
        beq x12,x4,_found
_inc11:
        addi x2,x2,4
        beq x2,x31,_inc10
        jal x0,_loop2

_found:
        /*mul x0,x10,x11*/
        addi x0,x11,0
        addi x0,x10,0
        csrrs x30,minstret,x0
        csrrs x30,mcycle,x0
_forever:
        jal x0,_forever
