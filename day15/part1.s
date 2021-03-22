/*
single-stage: 0.849 cpi
  instret = 34008
  cycle = 40055

pipelined: 0.915 cpi
  instret = 34004
  cycle = 37146
*/
        .section .text.vector
        jal x0,_start


        .section .text
_start:
        lui x31,0x2     /* 0x2000 ; the length of ram in bytes */
        addi x30,x31,-4 /* 0x1ffc ; the last word of ram */
        /* input is from halfword [0,N) of ram, for N inputs */
        addi x29,x0,6 /* length of input */
        addi x28,x0,2019 /* last turn */
        lui x27,0x10
        /*

        the in-memory data structure is:

        struct turn {
          short turn0;
          short turn1;
        };
        struct turn dmem[];

        dmem is indexed descending from 0x1ffc, where 0 is at 0x1ffc.

        With this memory arrangement this program can calculate at most the
	(2048-N)th number--day15,part1 only requires the 2020th number.

        */

        /* initialize all values */
        addi x1,x0,-1 /* {0xffff, 0xffff} -- a number that hasn't been spoken yet */
        slli x2,x29,2 /* index */
_init_memory:
        sw x1,0(x2)
        addi x2,x2,4
        blt x2,x31,_init_memory

        /* move the turn-indexed input to number-indexed locations */
        addi x2,x0,0 /* input index */
_read_input:
        slli x3,x2,1
        lh x4,0(x3)

        slli x5,x4,2 /* byte offset */
        sub x5,x30,x5
        sh x2,0(x5) /* N was last spoken at index x2 */

        addi x2,x2,1
        blt x2,x29,_read_input

        addi x2,x2,-1
_turn:
        /* last number spoken is x4 */
        slli x5,x4,2
        sub x5,x30,x5
        /* calculate next N spoken, x4 is the last index of the last N */
        addi x4,x0,0 /* the "default" next N is 0 */

        lh x6,0(x5) /* invariant: can't be -1 */
        lh x8,2(x5)
        beq x8,x1,_not_seen

        sub x4,x6,x8

_not_seen:
        addi x2,x2,1
        slli x7,x4,2
        sub x7,x30,x7
        lw x9,0(x7)
        sh x2,0(x7)
        sh x9,2(x7)

        blt x2,x28,_turn

__done:
        lui x1,0xffff0  /* high memory */
        addi x0,x4,0
        csrrs x2,mcycle,zero
        csrrs x2,minstret,zero
_forever:
        jal x0,_forever
