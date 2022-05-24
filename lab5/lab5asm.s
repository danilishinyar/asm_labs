.include "../lib/macros.s"

func_define Asm_blurImage
Asm_blurImage:
/**
x0 - inputData adress
x1 - outputData adress
x2 - matrix adress
x3 - width of the image
x4 - height of the image
x5 - amount of channels
x6 - matr_offset
**/
    push_registers
    mov x19, #0 //y
    mov x20, #0 //x
    mov x21, #0 //k
    sub x22, x3, x6 // width - matr_offset
    sub x23, x4, x6 // height - matr_offset
    //mul x7, x6, x3
0:
    mul x24, x20, x5 // x * channels
    add x24, x24, x21 // k + x * channels
    mul x25, x19, x3 // y * width * channels
    mul x25, x25, x5 // y * width * channels
    add x24, x24, x25 // k + x * channels + y * channels * width
    cmp x19, x6 // y <= matr_offset
    ble 1f
    cmp x19, x23 // y >= height - matr_offset
    bge 1f
    cmp x20, x6 // x <= matr_offset
    ble 1f
    cmp x20, x22 // x >= width - matr_offset
    bge 1f
    //push x22
    //push x23
    stp x22, x23, [sp, #-16]!
    bl Asm_calcNewPixel
    //pop x23
    //pop x22
    ldp x22, x23, [sp], #16
    b 2f
1:
    ldrb w26, [x0, x24]
    strb w26, [x1, x24]
    b 2f
2:
    inc x21
    cmp x21, x5
    beq 3f
    b 0b
3:
    mov x21, #0
    inc x20
    cmp x20, x3
    beq 4f
    b 0b
4:
    mov x20, #0
    inc x19
    cmp x19, x4
    beq 5f
    b 0b
5:
    pop_registers
    ret
/**
x0 - input data
x1 - output data
x2 - matrix adress
x3 - width of the image
x4 - height of the image
x5 - number of channels
x6 - matr_offset
x21 - k
x20 - x
x19 - y
x24 - k + x * channels + y * channels * width
**/
Asm_calcNewPixel:
    mov x22, #0 // c
    neg x23, x6 // -matr_offset
    mov x25, x23 // i
    mov x26, x23 // j
10:
    mov x27, x21 // k
    add x28, x20, x26 // x + j
    mul x28, x5, x28 // (x + j) * channels
    add x27, x27, x28 // k + (x + j) * channels
    add x28, x19, x25 // y + i
    mul x28, x28, x5 // (y + i) * channels
    mul x28, x28, x3 // (y + i) * channels * width
    add x27, x27, x28 // k + (x + j) * channels + (y + i) * width * channels
    //mov x27, x24
    //mul x28, x26, x5
    //add x27, x27, x28
    //mul x28, x25, x5
    //mul x28, x25, x3
    //add x27, x27, x28
    mov x28, #0
    add x29, x6, x25 // i + matr_offset
    mov x23, #5
    mul x29, x29, x23 // (i + matr_offset) * 5
    add x28, x29, x28
    add x28, x28, x26
    add x28, x28, x6 // matr_offset + j + (matr_offset + i)*5
    ldrb w23, [x0, x27]
    ldrb w29, [x2, x28]
    mul x23, x23, x29
    add x22, x22, x23
    //madd x22, x23, x29, x22
11:
    inc x26
    cmp x26, x6
    bgt 12f
    b 10b
12:
    neg x26, x6
    inc x25
    cmp x25, x6
    bgt 13f
    b 10b
13:
    //mov x23, #256
    lsr x22, x22, #8
    cmp w22, #255
    blt 14f
    mov w22, #255
    strb w22, [x1, x24]
    ret
14:
    strb w22, [x1, x24]
    ret
.size Asm_blurImage, .-Asm_blurImage







