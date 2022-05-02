.include "../lib/macros.s"
    .data
errmes1:
    .string "Usage: (set file as value of MY_ENV env var) "
    .equ    errlen1, .-errmes1
errmes2:
    .string "\n"
    .equ    errlen2, .-errmes2
mes:
    .string "Enter text:\n"
    .equ    meslen, .-mes
mes_ext:
    .string "\n Check output in file\n"
    .equ    mes_ext_len, .-mes_ext
env_name:
    .string "MY_ENV"
    .equ    env_name_len, .-env_name
    .text
    .align  2
    .global _start
    .type   _start, %function
_start:
    ldr x0, [sp]            //check if input of filename is correct
    cmp x0, #1
    beq 2f
1:
    mov x0, #2
    adr x1, errmes1
    mov x2, errlen1
    mov x8, #64
    svc #0
    mov x0, #2
    adr x1, errmes2
    mov x2, errlen2
    mov x8, #64
    svc #0
    mov x0, #1
    b   3f
2:
    mov x0, #2
    adr x1, mes
    mov x2, meslen
    mov x8, #64
    svc #0
    mov x8, #24
6:
    ldr x0, [sp, x8]       //filename adress
    adr x2, env_name
    b   4f
3:
    mov x8, #93
    svc #0
4:
    ldrb w3, [x0]
    ldrb w4, [x2]
    cmp w3, '='
    beq   7f
    cmp w3, w4
    bne 5f
    inc x0
    inc x2
    b   4b
5:
    add x8, x8, #8
    cmp x8, #216
    beq 1b
    b   6b
7:
    inc x0
    bl  main
    b   3b
    .size   _start, .-_start
    .type   main, %function
    .text
    .align  2
    .equ    filename, 16
    .equ    fd, 24
    .equ    adrs, 48
    .equ    wc, 32
    .equ    tmp, 40
    .equ    len, 56
    .equ    buf, 64
main:                       //open file x0-adress of filename
    stp x29, x30, [sp]
    mov x29, sp
    str x0, [x29, filename]
    mov x1, x0
    mov x0, #-100
    mov x2, O_WRONLY | O_CREAT | O_TRUNC
    mov x3, S_IRUSR
    mov x8, #56
    svc #0
    cmp x0, #0
    bge 0f
    bl  writeerr
    b   4f
0:
    str x0, [x29, fd]
    mov x0, #0
    str x0, [x29, wc]
1:
    mov x0, #0
    bl  dynamic_read //now x0-pointer to string we just have read x1-len
    str x0, [x29, len]
    str x1, [x29, adrs]
    cmp x0, #0
    beq 3f
    bgt 5f
5:
    ldrb    w0, [x1], #1
    cbz w0, 12f             //end of string (\0)
    cmp w0, ' '             //skip spaces
    beq 5b
    cmp w0, '\t'
    beq 5b
    cmp w0, '\n'
    beq 12f
    b   6f
6:
    sub x2, x1, #1          //beginning of the word
7:                          //read the word
    ldrb    w0, [x1], #1
    cbz w0, 8f              //end of string (\0)
    cmp w0, '\n'
    beq 8f
    cmp w0, '\t'
    beq 8f
    cmp w0, ' '
    beq 8f
    b   7b
8:
    sub x5, x1, #1          //end of the word (symbol right after the word)
    sub x3, x5, x2          //word len
    mov x4, x2              //beginning of the word
9:                          //x2-beg x5-fin
    ldrb    w7, [x5, #-1]!
    ldrb    w6, [x2], #1
    cmp w7, w6
    bne 11f
    cmp x2, x5
    bge 10f
    b   9b
11:
    dec x1
    b   5b
10:
    ldr w7, [x29, wc]
    cbz w7, 13f
    b   14f
13:
    mov w7, #1
    str w8, [x29, wc]
    mov x7, x1
    ldr x0, [x29, fd]
    mov x2, x3
    mov x1, x4
    mov x8, #64
    svc #0
    mov x1, x7
    dec x1
    b   5b
14:
    mov x7, x1
    mov w0, ' '
    str w0, [x29, tmp]
    ldr x0, [x29, fd]
    mov x2, #1
    mov x1, x29
    add x1, x1, tmp
    mov x8, #64
    svc #0
    ldr x0, [x29, fd]
    mov x2, x3
    mov x1, x4
    mov x8, #64
    svc #0
    mov x1, x7
    dec x1
    b   5b
12:
    mov w0, #0
    str w0, [x29, wc]
    mov w0, '\n'
    str w0, [x29, tmp]
    ldr x0, [x29, fd]
    mov x2, #1
    mov x1, x29
    add x1, x1, tmp
    mov x8, #64
    svc #0
    b   15f
15:
    ldr x0, [x29, adrs]
    ldr x1, [x29, len]
    mov x8, #215
    svc #0
    b 1b
3:
    ldr x0, [x29, fd]
    mov x8, #57
    svc #0
    mov x0, #0
4:                          //reestablish stack adress
    ldp x29, x30, [sp]
    mov x16, buf
    add sp, sp, x16
    mov x0, #2
    adr x1, mes_ext
    mov x2, mes_ext_len
    mov x8, #64
    svc #0
    ret
    .size   main, .-main
    .type   writeerr, %function
    .data
nofile:
    .string "No such file or directory\n"
    .equ    nofilelen, .-nofile
permission:
    .string "Permission denied\n"
    .equ    permissionlen, .-permission
unknown:
    .string "Unknown error\n"
    .equ    unknownlen, .-unknown
    .text
    .align  2
writeerr:
    cmp x0, #-2
    bne 0f
    adr x1, nofile
    mov x2, nofilelen
    b   2f
0:
    cmp x0, #-13
    bne 1f
    adr x1, permission
    mov x2, permissionlen
    b   2f
1:
    adr x1, unknown
    mov x2, unknownlen
2:
    mov x0, #2
    mov x8, #64
    svc #0
    ret
    .size   writeerr, .-writeerr


