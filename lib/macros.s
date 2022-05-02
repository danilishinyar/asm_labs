.equ    O_RDONLY,       0
.equ    O_WRONLY,       1
.equ    O_RDWR,         2
// RWX for user
.equ    S_IRUSR,        0400
.equ    S_IWUSR,        0200
.equ    S_IXUSR,        0100
.equ    S_IRWXU,        0700
// RWX for group
.equ    S_IRGRP,        0040
.equ    S_IWGRP,        0020
.equ    S_IXGRP,        0010
.equ    S_IRWXG,        0070
// RWX for other
.equ    S_IROTH,        0004
.equ    S_IWOTH,        0002
.equ    S_IXOTH,        0001
.equ    S_IRWXO,        0007
//FILE FLAGS
.equ    O_CREAT,        0x40
.equ    O_TRUNC,        0x200
//mmap flags
.equ    MAP_PRIVATE,    0x02
.equ    MAP_ANONYMOUS,  0x20
.equ    PROT_READ,      0x1
.equ    PROT_WRITE,     0x2
//mremap flags
.set    MREMAP_MAYMOVE, 1

.macro  pop, r
    ldr \r, [sp], #8
.endm


.macro  push, r
    str \r, [sp, #-8]!
.endm


.macro inc, r
    add \r, \r, #1
.endm


.macro dec, r
    sub \r, \r, #1
.endm


.macro func_define, func
    .global \func
    .align  2
    .type   \func, %function
.endm


.macro push_registers
    push x19
    push x20
    push x21
    push x22
    push x23
    push x24
    push x25
    push x26
    push x27
    push x28
    push x29
    push x30
.endm


.macro pop_registers
    pop x30
    pop x29
    pop x28
    pop x27
    pop x26
    pop x25
    pop x24
    pop x23
    pop x22
    pop x21
    pop x20
    pop x19
.endm
