.include "macros.s"

func_define read_str //reads string     x0-fd, x1-where to read, x2-string size
read_str:
    push_registers
    mov x8, #63
    svc #0
    pop_registers
    ret
    .size read_str, .-read_str


func_define dynamic_read
.equ    str_size, 10
dynamic_read:
    push_registers
    mov x19, x0
    mov x0, #0      //addr=NULL (it decides itself where to put our string)
    mov x1, str_size//size
    mov x2, PROT_READ | PROT_WRITE
    mov x3, MAP_PRIVATE | MAP_ANONYMOUS //to map some memory filled with zeroes (we are not reading from any file)
    mov x4, #-1     //as man says it should be -1 (fd)
    mov x5, #0      //offset
    mov x8, #222    //mmap
    svc #0
    mov x20, x0     //adress where we allocated memory
    mov x21, x0     //pointer
    mov x22, #0     //counter
    mov x23, str_size  //size to compare with counter
1:
    mov x0, x19
    mov x1, x21
    mov x2, #1
    mov x8, #63
    svc #0
    cbz x0, 2f
    ldrb    w24, [x21]//check if symbol is \n
    cmp w24, '\n'
    beq 4f
    inc x21
    inc x22
    cmp x22, x23
    bne 1b          //else we should expand memory (mremap)
    mov x25, x23
    add x23, x23, str_size
    mov x0, x20     //old adress
    mov x1, x25     //old size
    mov x2, x23     //new size
    mov x3, MREMAP_MAYMOVE
    mov x4, #0
    mov x8, #216    //mremap
    svc #0
    mov x20, x0     //new adress
    mov x21, x0     //new pointer
    add x21, x21, x25//offset
    b   1b
2:
    ldrb    wzr, [x21]
3:
    mov x1, x20 //x0 would be adress of allocated mem
    mov x0, x22
    pop_registers
    ret
4:
    inc x22
    b 2b
    .size dynamic_read, .-dynamic_read
