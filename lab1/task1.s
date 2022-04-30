//res = a*c/b + d*b/e - c^2/a*d
//a - 16
//b - 16
//c - 32
//d - 16
//e - 32

    	.data
    	.align   3
res:	.skip    8
c:  	.word    8
e:	    .word    8
a:  	.hword   0xffff
b:  	.byte   0x1
d:  	.hword   8

    	.text
    	.align   2
    	.global  _start
    	.type    _start, %function
_start:
	adr 	x0, a
	ldrh	w1, [x0] //a
	adr 	x0, b
	ldrb	w1, [x0] //b
	cbz 	w2, excep //division by null check
	adr 	x0, c
	ldr 	w3, [x0] //c
	adr 	x0, d
	ldrh	w4, [x0] //d
	adr 	x0, e
	ldr 	w5, [x0] //e
	cbz 	w5, excep //division by null check
	umull	x6, w1, w3
	udiv	x6, x6, x2 //a*c/b
	mul 	w7, w2, w4 //d*b
	udiv	w7, w7, w5 //d*b/e
	umull	x8, w3, w3 //c^2
	mul 	w9, w1, w4 //a*d
	cbz 	w9, excep //division by null check
	udiv	x8, x8, x9 //c^2/a*d
	adds	x6, x6, w7, uxtw
	bcs 	excep //addition overflow check
	subs	x6, x6, x8
	bcc 	excep //subtraction check for unsigned
	adr 	x0, res
	str 	x6, [x0]
	mov 	x0, #0
	b        exit

exit:
    mov     x8, #93
    svc     #0

excep:
	mov     x0, #1
    b       exit


.size   _start, .-_start
