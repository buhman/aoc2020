        .section .text
        .global parse_dec_int
parse_dec_int:
#define buf a0
#define n a1
#define table a2
#define c a3
#define const_9 a4
        lui table,%hi(_0)
        addi table,table,%lo(_0)
        addi const_9,zero,9
        addi n,zero,0
_begin:
        lbu c,0(buf)
        addi c,c,-48
        bltu const_9,c,_exit
        addi buf,buf,1
        slli t1,n,3
        slli n,n,1
        add n,n,t1
        slli c,c,3
        add t0,table,c
        jalr zero,0(t0)
_0:
        addi n,n,0
        jal zero,_begin
_1:
        addi n,n,1
        jal zero,_begin
_2:
        addi n,n,2
        jal zero,_begin
_3:
        addi n,n,3
        jal zero,_begin
_4:
        addi n,n,4
        jal zero,_begin
_5:
        addi n,n,5
        jal zero,_begin
_6:
        addi n,n,6
        jal zero,_begin
_7:
        addi n,n,7
        jal zero,_begin
_8:
        addi n,n,8
        jal zero,_begin
_9:
        addi n,n,9
        jal zero,_begin
_exit:
        jalr zero,0(ra)
