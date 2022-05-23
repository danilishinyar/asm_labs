.include "../lib/macros.s"

func_define blurImageAsm
blurImageAsm:
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
0:
    cmp x19, x6 // y <= matr_offset
    ble 1f
    cmp x19, x23 // y >= height - matr_offset
    bge 1f
    cmp x20, x6 // x <= matr_offset
    ble 1f
    cmp x20, x23 // x >= width - matr_offset
    bge 1f
    bl calcNewPixelAsm
    b 2f
1:
    mul x24, x20, x5
    add x24, x24, x21
    mul x25, x19, x3
    mul x25, x25, x5
    add x24, x24, x25// k+x*channels+y*channels*width
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
.size blurImageAsm, .-blurImageAsm
func_define calcNewPixel
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
calcNewPixelAsm:
    mov x22, #0 // c
    mov x23, #0
    sub x23, x23, x6 // -matr_offset
    mov x25, x23 // i
    mov x26, x23 // j
0:
    mov x27, x21
    add x28, x20, x23
    mul x28, x5, x28
    add x27, x27, x28
    add x28, x19, x23
    mul x28, x28, x5
    mul x28, x28, x3
    add x27, x27, x28 // k + (x + j) * channels + (y + i) * width * channels
    mov x28, #0
    add x29, x6, x26
    mov x23, #5
    mul x29, x29, x23
    add x28, x29, x28
    add x28, x28, x25
    add x28, x28, x6 // matr_offset + i + (matr_offset + j)*5
    ldrb w23, [x0, x27]
    ldrb w29, [x2, x28]
    mul x23, x23, x29
    add x22, x22, x23
1:
    inc x26
    cmp x26, x6
    bgt 2f
    b 0b
2:
    mov x26, #0
    inc x25
    cmp x25, x6
    bgt 3f
    b 0b
3:
    mov x23, #255
    udiv x22, x22, x23
    cmp x22, #255
    blt 4f
    mov x22, #255
    strb w22, [x1, x24]
4:
    strb w22, [x1, x24]
    ret
.size calcNewPixelAsm, .-calcNewPixelAsm







