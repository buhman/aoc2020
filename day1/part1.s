        addi x31,x0,200  /* (len(input)) */
        slli x31,x31,2    /* ..as bytes   */

        addi x4,x0,2020  /* desired sum */

        addi x1,x0,-4
.inc10:
        addi x1,x1,4
        beq x1,x31,.stop
        addi x2,x1,4
        lw x10,0(x1)
.loop2:
        lw x11,0(x2)

        add x12,x10,x11
        beq x12,x4,.found
.inc11:
        addi x2,x2,4
        beq x2,x31,.inc10
        jal x0,.loop2

.found:
        mul x12,x10,x11
        sw x12,1020(x0)
        addi x30,x0,2040
        sw x12,8(x30)
.stop:
        jal x0,0
