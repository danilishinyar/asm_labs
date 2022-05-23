    .arch armv8-a
    .include "../lib/macros.s"
    .data
usage:
    .string "Usage: %s file\n"
errmsg:
    .string "Error occured\n"
dimerr:
    .string "Dimension of matrix must be less or equal 20 and bigger than 0\n"
formint:
    .string "%d"
formfloat:
    .string "%f"
outf:
    .string "%.1f"
space:
    .string " "
newstr:
    .string "\n"
mode:
    .string "r"
not_enough:
    .string "Not enough data or incorrect data type\n"
too_many:
    .string "Too many data\n"
    .text
    .align 2
    .global main
    .type   main,       %function
    .equ    progname,   16
    .equ    filename,   24
    .equ    fd,         32
    .equ    n,          40
    .equ    A,          48
    .equ    B,          56
    .equ    C,          64
    .equ    D,          72
    .equ    E,          80
    .equ    F,          88
    .equ    G,          96
    .equ    H,          104
    .equ    tmp,        112
    .equ    res,        120
    .equ    matrsz,     128
    .equ    stacksz,    136
    .equ    offset,     144
main:                       //check usage
    push_registers
    cmp w0, #2//argc
    beq 0f
    ldr x2, [x1]//argv(progname first)
    adr x0, stderr//error output pointer
    ldr x0, [x0]
    adr x1, usage
    bl  fprintf
    mov w0, #1
    b ext
0:                          //open file
    ldr x0, [x1]
    mov x20, x0
    ldr x0, [x1, #8]
    mov x21, x0
    adr x1, mode
    bl  fopen
    cbnz    x0, 1f
    //ldr x0, [x1, #8]
    bl  perror
    mov w0, #1
    b   ext
1:                          //read n
    push    x0
    push    x0
    mov x2, sp
    adr x1, formint
    bl  fscanf
    cmp w0, #1
    beq 2f
    pop x0
    pop x0
    bl fclose
    adr x0, stderr
    ldr x0, [x0]
    adr x1, errmsg
    bl  fprintf
    mov w0, #1
    b   ext
2:                          //form stack frame
    pop x22
    pop x24
    mov x19, x22
    cmp x22, #20
    bgt 3f
    cmp x22, #0
    ble 3f
    mul x22, x22, x22
    lsl x22, x22, #2
    mov x26, #10
    mul x22, x22, x26
    add x23, x22, offset
    sub sp, sp, x23
    stp x29, x30, [sp]
    mov x29, sp
    str x20, [x29, progname]
    str x21, [x29, filename]
    str x24, [x29, fd]
    str x19, [x29, n]
    str x22, [x29, stacksz]
    mul x19, x19, x19
    lsl x19, x19, #2
    str x19, [x29, matrsz]
    mov x27, x29
    add x27, x29, offset    //pointer to beginning of matrix
    mov x1, x29
    add x1, x1, A
    mov x2, x27
    mov x3, #0
    b 15f
15:                         //abcdefgh-adr in frame
    cmp x3, #10
    beq 4f
    str x2, [x1]
    add x2, x2, x19
    add x1, x1, #8
    inc x3
    b 15b
3:
    adr x0, stderr          //dim error
    ldr x0, [x0]
    adr x1, dimerr
    bl fprintf
    mov w0, #1
    b ext
4:                          //read matr from file
    ldr x19, [x29, n]
    mov x20, #0             //i
    mov x21, #0             //j
    mov x22, #0             //matr counter
    b 5f
5:
    ldr x0, [x29, fd]
    adr x1, formfloat
    mov x23, x20
    mul x23, x23, x19
    add x23, x23, x21
    lsl x23, x23, #2
    ldr x24, [x29, matrsz]
    mul x24, x22, x24
    add x23, x24, x23
    add x23, x27, x23
    mov x2, x23
    bl fscanf
    cmp w0, #1
    beq 6f
    adr x0, stderr
    ldr x0, [x0]
    adr x1, not_enough
    bl fprintf
    b 17f
6:
    inc x21
    cmp x21, x19
    beq 7f
    b   5b
7:
    mov x21, #0
    inc x20
    cmp x20, x19
    beq 8f
    b 5b
8:
    mov x20, #0
    inc x22
    cmp x22, #8
    beq 14f
    b 5b
16:                             //calculating our expression
    ldr x2, [x29, n]
    ldr x3, [x29, res]
    bl fill_zeroes
    /* f * (g + h) */
    ldr x0, [x29, G]
    ldr x1, [x29, H]
    ldr x3, [x29, G]
    bl add_matr
    ldr x0, [x29, F]
    ldr x1, [x29, G]
    ldr x3, [x29, tmp]
    bl mul_matr
    ldr x0, [x29, tmp]
    ldr x3, [x29, res]
    ldr x1, [x29, res]
    bl add_matr
    /* a * (d - e) */
    ldr x0, [x29, D]
    ldr x1, [x29, E]
    ldr x3, [x29, D]
    bl sub_matr
    ldr x0, [x29, A]
    ldr x1, [x29, D]
    ldr x3, [x29, tmp]
    bl mul_matr
    ldr x3, [x29, res]
    ldr x1, [x29, res]
    bl add_matr
    /* a * (b - c) */
    ldr x0, [x29, B]
    ldr x1, [x29, C]
    ldr x3, [x29, B]
    bl sub_matr
    ldr x0, [x29, A]
    ldr x1, [x29, B]
    ldr x3, [x29, tmp]
    bl mul_matr
    ldr x3, [x29, res]
    ldr x1, [x29, res]
    bl add_matr
    b 9f
9:                              //ptint res matr
    ldr x27, [x29, res]
    ldr x19, [x29, n]
    mov x20, #0                 //i
    mov x21, #0                 //j
    b 10f
14:                             //check if there is more data in file
    ldr x0, [x29, fd]
    adr x1, formfloat
    mov x2, x27
    add x2, x2, tmp
    bl fscanf
    cmp w0, #1
    bne 16b
    adr x0, stderr
    ldr x0, [x0]
    adr x1, too_many
    bl  fprintf
    b 17f
10:
    mov x22, x20
    mul x22, x22, x19
    add x22, x21, x22
    lsl x22, x22, #2
    add x22, x22, x27
    adr x0, outf
    ldr s22, [x22]
    fcvt d0, s22                //cast to 64 bits float (because of printf)
    bl printf
    b 11f
11:
    inc x21
    cmp x21, x19
    beq 12f
    adr x0, space
    bl printf
    b   10b
12:
    adr x0, newstr
    bl printf
    mov x21, #0
    inc x20
    cmp x20, x19
    beq 13f
    b 10b
13:
    mov w0, #0
    b 18f
17:
    mov w0, #1
    b 18f
18:
    ldr x1, [sp, stacksz]
    add x1, x1, offset
    ldp x29, x30, [sp]
    add sp, sp, x1
    b ext
ext:
    pop_registers
    ret
    .size   main, .-main
