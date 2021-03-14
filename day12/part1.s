/*
cycles: 33415
instructions: 29598
*/

        /* the initial value of sp is the size of dmem in bytes */
        lui sp,0x2 /* 8192 */

/*
create two "jump tables"

the first is a mapping between uppercase ascii characters and instruction addresses:
  E 0 = _east
  F 1 = _forward
  L 7 = _left
  N 9 = _north
  R 13 = _right
  S 14 = _south
  W 18 = _west

the second is a mapping between directions (0,1,2,3) and instruction addresses:
  E 0 = _east
  S 1 = _south
  W 2 = _west
  N 3 = _north

these are built at the same time
        */
        addi sp,sp,-92
        addi x31,sp,16 /* word x31[19] = (sp - 76) */
        addi x30,sp,0  /* word x30[4] = (sp - 92) */

        addi t0,x0,%lo(_east)
        sw t0,0(x31) /* 0 */
        sw t0,0(x30) /* D 0 */

        addi t0,x0,%lo(_forward)
        sw t0,4(x31) /* 1 */

        addi t0,x0,%lo(_left)
        sw t0,28(x31) /* 7 */

        addi t0,x0,%lo(_north)
        sw t0,36(x31) /* 9 */
        sw t0,12(x30) /* D 3 */

        addi t0,x0,%lo(_right)
        sw t0,52(x31) /* 13 */

        addi t0,x0,%lo(_south)
        sw t0,56(x31) /* 14 */
        sw t0,4(x30) /* D 1 */

        addi t0,x0,%lo(_west)
        sw t0,72(x31) /* 18 */
        sw t0,8(x30) /* D 2 */

/* initial state */
        addi x10,x0,0 /* dmem address */
        addi x20,x0,0 /* direction */
        addi x21,x0,0 /* x coordinate */
        addi x22,x0,0 /* y coordinate */

        lui x29,0x1
        addi x29,x29,-1278  /* length of input, in bytes (2818) */

/* top-level input parsing
state:
  dmem address : x10
  token        : x18
*/
_loop:
        lb x18,0(x10)
        addi x10,x10,1
        jal ra,parse_int /* x10 -> (x10, x11) */
        addi x10,x10,1 /* assume but do not verify the presence of a newline delimiter */

        addi t0,x18,-69
        slli t0,t0,2
        add t0,x31,t0
        lw t1,0(t0)
        jalr ra,0(t1) /* x11 -> (state) */

        blt x10,x29,_loop

        /* part1: manhattan distance */
        srai t0,x21,31
        xor t1,t0,x21
        sub t1,t1,t0

        srai t0,x22,31
        xor t2,t0,x22
        sub t2,t2,t0

        add t0,t1,t2

__done:
        lui t1,0xffff0  /* high memory */
        sw t0,0x700(t1)
        csrrs t0,cycle,zero
        sw t0,0x700(t1)
        csrrs t0,instret,zero
        sw t0,0x700(t1)
_forever:
        jal x0,_forever

/*
args:
  n : x11
state:
  direction    : x20
  x coordinate : x21
  y coordinate : x22

    +
    │
- ──┼── +
    │
    -
*/
_north:
        add x22,x22,x11
        jalr x0,0(ra)
_east:
        add x21,x21,x11
        jalr x0,0(ra)
_south:
        sub x22,x22,x11
        jalr x0,0(ra)
_west:
        sub x21,x21,x11
        jalr x0,0(ra)
_left:
        jal x3,_parse_degrees
        sub x20,x20,x12
        jalr x0,0(ra)
_right:
        jal x3,_parse_degrees
        add x20,x20,x12
        jalr x0,0(ra)
_forward:
        andi x20,x20,3 /* x20 % 4 ; where % is the positive modulo */
        slli t0,x20,2
        add t0,x30,t0
        lw t1,0(t0)
        jalr x0,0(t1)

/*
args:
  ( 90,180,270) : x11
returns:
  (  1,  2,  3) : x12
*/
_parse_degrees:
        addi t1,x0,90
        beq x11,t1,_90
        addi t1,x0,180
        beq x11,t1,_180
        addi t1,x0,270
        beq x11,t1,_270
_90:
        addi x12,x0,1
        jalr x0,0(x3)
_180:
        addi x12,x0,2
        jalr x0,0(x3)
_270:
        addi x12,x0,3
        jalr x0,0(x3)

/*
args:
  dmem address : x10
returns:
  dmem address : x10 (first non-decimal character)
  positive integer : x11
*/
parse_int:
        addi x11,x0,0
        addi t1,x0,9
_parse_byte:
        lbu t0,0(x10)
        addi t0,t0,-48
        andi t0,t0,255
        bltu t1,t0,_exit

        /* multiply by 10 */
        slli t2,x11,2
        add t2,t2,x11
        slli x11,t2,1

        /* add decimal digit */
        add x11,x11,t0

        addi x10,x10,1
        jal x0,_parse_byte
_exit:
        jalr x0,0(ra)
