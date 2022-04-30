.arch armv8-a

	.data
	.align 2
a:	.word 11
b:	.word 3



	.text
	.align 2
	.global _start
	.type _start, %function
_start:
	adr 	x0, a
	ldr	w1, [x0]
	adr	x0, b
	ldr	w2, [x0]
	mul	w3, w1, w2
	mov	x0, #0
	mov	x8, #93
	svc	#0
	.size _start, .-_start

