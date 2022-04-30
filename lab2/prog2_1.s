// Comb sort of digonals parallel to the secondary diagonal of square matrix


    .data
    .align  3
n:
    .byte   4
matrix:
    .quad    1, 2, 3, 4
    .quad    5, 6, 7, 8
    .quad    9, 10, 11, 12
    .quad    13, 14, 15, 16

aboba:
    .byte   order

    .text
    .align  2
    .global _start
    .type   _start, %function


_start:
    adr     x0, n
    ldrb    w1, [x0]
    adr     x0, aboba
    ldrb    w18, [x0]
    mov     x3, #0          // counter "i"
    mov     x4, #-1         // counter "j"
    adr     x2, matrix      // matrix adress
    mov     x5, x1          // n - 1
    sub     x5, x5, #1

L0:                         // for(i = 1; i < n-1; ++i)
    add     x3, x3, #1      // i + 1
    cmp     x3, x5          // i < n - 1
    bge     exit
    mov     x6, x3          // x6 - gap = i
    mov     x7, #1          // x7 - swap1 = 1
    mov     x15, #1         // x15 - swap2 = 1
    b       L1

L1:                         // while(gap > 1 || swap1 || swap2)
    mov     x4, #-1         // j = 0
    cmp     x6, #1
    bgt     L4
    cmp     x7, #1
    beq     L4
    cmp     x15, #1
    beq     L4
    b       L0

L4:
    bl      gap_calc        // gap = gap / 1.28
    mov     x7, #0          // swap1 = 0
    mov     x15, #0         // swap2 = 0
    mov     x8, #0
    add     x8, x8, x3
    sub     x8, x8, x6      // x8 - (i - gap)
    b       L2

gap_calc:                   // gap = gap / 1.28
    mov     x0, #100
    mul     x6, x6, x0      // gap * 100
    mov     x0, #128
    udiv    x6, x6, x0      // gap / 128
    cmp     x6, #0
    beq     add_1
    ret

add_1:
    mov     x6, #1
    ret

L2:                         // for (j = 0; j <= i - gap; ++j)
    add     x4, x4, #1      // j + 1
    cmp     x4, x8          // j <= i - gap
    bgt     L1
    mov     x9, #0
    add     x9, x4, x6      // x9 - k = j + gap
    b       locate_and_compare

locate_and_compare:
    mov     x10, #0
    mov     x11, #0
    mul     x11, x5, x4
    add     x10, x11, x3
    lsl     x10, x10, #3    // j(n-1) + i
    mov     x11, #0
    mul     x11, x5, x9
    add     x11, x11, x3
    lsl     x11, x11, #3    // k(n-1) + i
    ldr     x12, [x2, x10]
    ldr     x13, [x2, x11]
    bl      swap_up
    mov     x0, x1
    mul     x0, x0, x0
    sub     x0, x0, #1
    lsl     x0, x0, #3
    sub     x10, x0, x10
    sub     x11, x0, x11
    ldr     x12, [x2, x10]
    ldr     x13, [x2, x11]
    bl      swap_down
    b       L2

swap_up:
    cmp     x19, #1
    beq     dec_up
    b       inc_up

dec_up:
    cmp     x13, x12
    blt     real_swap_up
    ret

inc_up:
    cmp     x12, x13
    blt     real_swap_up
    ret

real_swap_up:
    mov     x0, x12
    str     x13, [x2, x10]
    str     x0, [x2, x11]
    mov     x7, #1
    ret

swap_down:
    cmp     x19, #1
    beq     dec_down
    b       inc_down

dec_down:
    cmp     x12, x13
    blt     real_swap_down
    ret

inc_down:
    cmp     x13, x12
    blt     real_swap_down
    ret

real_swap_down:
    mov     x0, x12
    str     x13, [x2, x10]
    str     x0, [x2, x11]
    mov     x15, #1
    ret

exit:
    mov     x0, #0
    mov     x8, #93
    svc     #0
.size       _start, .-_start

