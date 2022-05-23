.include "../lib/macros.s"


func_define fill_zeroes
fill_zeroes:            //x3-adr x2-n
    push_registers
    mov x19, #0
    mul x20, x2, x2
0:
    lsl x22, x19, #2
    fsub s0, s0, s0
    str s0, [x3, x22]
    inc x19
    cmp x19, x20
    beq 1f
    b   0b
1:
    pop_registers
    ret
.size fill_zeroes, .-fill_zeroes


func_define add_matr
add_matr:
    push_registers      //x0-first matr x1-second matr x2-matr size x3-res matr
    mov x19, #0         //i
    mov x20, #0         //j
1:
    mov x21, x19
    mul x21, x21, x2
    add x21, x21, x20
    lsl x21, x21, #2
    ldr s22, [x0, x21]
    ldr s23, [x1, x21]
    fadd s22, s23, s22
    str s22, [x3, x21]
2:
    inc x20
    cmp x20, x2
    beq 3f
    b 1b
3:
    mov x20, #0
    inc x19
    cmp x19, x2
    beq 4f
    b 1b
4:
    mov x0, x3
    pop_registers
    ret
.size add_matr, .-add_matr



func_define sub_matr
sub_matr:
    push_registers      //x0-first matr x1-second matr x2-matr size x3-res matr
    mov x19, #0         //i
    mov x20, #0         //j
1:
    mov x21, x19
    mul x21, x21, x2
    add x21, x21, x20
    lsl x21, x21, #2
    ldr s22, [x0, x21]
    ldr s23, [x1, x21]
    fsub s22, s22, s23
    str s22, [x3, x21]
2:
    inc x20
    cmp x20, x2
    beq 3f
    b 1b
3:
    mov x20, #0
    inc x19
    cmp x19, x2
    beq 4f
    b 1b
4:
    mov x0, x3
    pop_registers
    ret
.size sub_matr, .-sub_matr


func_define mul_matr
mul_matr:
    push_registers      //x0-first matr x1-second matr x2-matr size x3-res matr
    bl fill_zeroes
    mov x19, #0         //k
    mov x20, #0         //j
    mov x21, #0         //i
2:
    mov x22, x21
    mul x22, x22, x2
    add x22, x22, x19
    lsl x22, x22, #2
    ldr s0, [x0, x22]
    mov x22, x19
    mul x22, x22, x2
    add x22, x20, x22
    lsl x22, x22, #2
    ldr s1, [x1, x22]
    mov x22, x21
    mul x22, x22, x2
    add x22, x22, x20
    lsl x22, x22, #2
    ldr s2, [x3, x22]
    fmul s0, s0, s1
    fadd s0, s0, s2
    str s0, [x3, x22]
3:
    inc x19
    cmp x19, x2
    beq 4f
    b 2b
4:
    mov x19, #0
    inc x20
    cmp x20, x2
    beq 5f
    b 2b
5:
    mov x20, #0
    inc x21
    cmp x21, x2
    beq 6f
    b 2b
6:
    mov x0, x3
    pop_registers
    ret
.size mul_matr, .-mul_matr
