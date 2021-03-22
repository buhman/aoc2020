/*
single-stage:
  instret = 30116
  cycle = 36146

  0.833 instructions/cycle

pipelined:
  instret = 30113
  cycle = 36214

  0.831 instructions/cycle
*/

        .section .text.vector
        jal x0,_start

        .section .text
_start:
        addi x31,x0,200  /* (len(input)) */
        slli x31,x31,2    /* ..as bytes   */

        addi x4,x0,2020  /* desired sum */

        addi x1,x0,0
        bge x1,x31,_forever
_loop1:
        addi x2,x1,4
        lw x10,0(x1)
_loop2:
        lw x11,0(x2)

        add x12,x10,x11
        beq x12,x4,_found
        addi x2,x2,4
        blt x2,x31,_loop2

        addi x1,x1,4
        blt x1,x31,_loop1

_forever:
        jal x0,_forever

_found:
        /*mul x0,x10,x11*/
        addi x0,x11,0
        addi x0,x10,0
        csrrs x30,minstret,x0
        csrrs x30,mcycle,x0
        jal x0,_forever
