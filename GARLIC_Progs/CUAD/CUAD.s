	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"CUAD.c"
	.global	prueba
	.data
	.align	2
	.type	prueba, %object
	.size	prueba, 80
prueba:
	.word	2
	.word	3
	.word	5
	.word	7
	.word	11
	.word	13
	.word	17
	.word	19
	.word	23
	.word	29
	.word	31
	.word	37
	.word	41
	.word	43
	.word	47
	.word	53
	.word	59
	.word	61
	.word	67
	.word	71
	.section	.rodata
	.align	2
.LC0:
	.ascii	"-- Programa CUAD  -  PID (%d) --\012\000"
	.align	2
.LC1:
	.ascii	"Numeros: \000"
	.align	2
.LC2:
	.ascii	"%d \000"
	.align	2
.LC3:
	.ascii	"Suma de numeros a cuadrado entre n: \012 %d\000"
	.align	2
.LC4:
	.ascii	"La size es: %d \012\000"
	.align	2
.LC5:
	.ascii	"La media cuadr\341tica es: %d \012 con %d \012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 80
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #84
	str	r0, [sp, #4]
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bge	.L2
	mov	r3, #0
	str	r3, [sp, #4]
	b	.L3
.L2:
	ldr	r3, [sp, #4]
	cmp	r3, #3
	ble	.L3
	mov	r3, #3
	str	r3, [sp, #4]
.L3:
	bl	GARLIC_pid
	mov	r3, r0
	mov	r1, r3
	ldr	r0, .L12
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	str	r3, [sp, #56]
	mov	r3, #0
	str	r3, [sp, #68]
	ldr	r0, .L12+4
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bne	.L4
	mov	r3, #20
	str	r3, [sp, #76]
	mov	r3, #0
	str	r3, [sp, #72]
	b	.L5
.L6:
	ldr	r2, .L12+8
	ldr	r3, [sp, #72]
	ldr	r3, [r2, r3, lsl #2]
	str	r3, [sp, #32]
	ldr	r3, [sp, #32]
	mov	r1, r3
	ldr	r0, .L12+12
	bl	GARLIC_printf
	ldr	r1, [sp, #32]
	ldr	r2, [sp, #32]
	mul	r3, r2, r1
	str	r3, [sp, #52]
	ldr	r2, [sp, #68]
	ldr	r3, [sp, #52]
	add	r3, r2, r3
	str	r3, [sp, #68]
	ldr	r3, [sp, #72]
	add	r3, r3, #1
	str	r3, [sp, #72]
.L5:
	ldr	r2, [sp, #72]
	ldr	r3, [sp, #76]
	cmp	r2, r3
	blt	.L6
	b	.L7
.L4:
	ldr	r3, [sp, #56]
	ldr	r2, [sp, #56]
	mul	r1, r2, r3
	ldr	r2, [sp, #56]
	mul	r3, r2, r1
	ldr	r2, [sp, #56]
	mul	r1, r3, r2
	ldr	r3, [sp, #56]
	mul	r2, r1, r3
	str	r2, [sp, #76]
	mov	r3, #0
	str	r3, [sp, #72]
	b	.L8
.L9:
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	add	r3, sp, #32
	add	r2, sp, #36
	mov	r1, #100
	bl	GARLIC_divmod
	ldr	r3, [sp, #32]
	mov	r1, r3
	ldr	r0, .L12+12
	bl	GARLIC_printf
	ldr	r1, [sp, #32]
	ldr	r2, [sp, #32]
	mul	r3, r2, r1
	str	r3, [sp, #52]
	ldr	r2, [sp, #68]
	ldr	r3, [sp, #52]
	add	r3, r2, r3
	str	r3, [sp, #68]
	ldr	r3, [sp, #72]
	add	r3, r3, #1
	str	r3, [sp, #72]
.L8:
	ldr	r2, [sp, #72]
	ldr	r3, [sp, #76]
	cmp	r2, r3
	blt	.L9
.L7:
	ldr	r0, [sp, #68]
	ldr	r1, [sp, #76]
	add	r3, sp, #24
	add	r2, sp, #28
	bl	GARLIC_divmod
	ldr	r3, [sp, #28]
	str	r3, [sp, #68]
	ldr	r1, [sp, #68]
	ldr	r0, .L12+16
	bl	GARLIC_printf
	ldr	r3, [sp, #68]
	str	r3, [sp, #64]
	mov	r3, #0
	str	r3, [sp, #48]
	mov	r3, #0
	str	r3, [sp, #60]
.L10:
	ldr	r3, [sp, #64]
	ldr	r2, [sp, #64]
	mul	r1, r2, r3
	ldr	r2, [sp, #68]
	add	r3, r2, r1
	str	r3, [sp, #44]
	ldr	r3, [sp, #64]
	lsl	r3, r3, #1
	str	r3, [sp, #40]
	ldr	r0, [sp, #44]
	ldr	r1, [sp, #40]
	add	r3, sp, #16
	add	r2, sp, #20
	bl	GARLIC_divmod
	ldr	r3, [sp, #20]
	str	r3, [sp, #64]
	ldr	r1, [sp, #32]
	ldr	r2, .L12+20
	mul	r3, r2, r1
	str	r3, [sp, #48]
	ldr	r0, [sp, #48]
	add	r3, sp, #8
	add	r2, sp, #12
	ldr	r1, .L12+20
	bl	GARLIC_divmod
	ldr	r3, [sp, #12]
	str	r3, [sp, #48]
	ldr	r3, [sp, #60]
	add	r3, r3, #1
	str	r3, [sp, #60]
	ldr	r3, [sp, #60]
	cmp	r3, #24
	ble	.L10
	ldr	r1, [sp, #76]
	ldr	r0, .L12+24
	bl	GARLIC_printf
	ldr	r2, [sp, #48]
	ldr	r1, [sp, #64]
	ldr	r0, .L12+28
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #84
	@ sp needed
	ldr	pc, [sp], #4
.L13:
	.align	2
.L12:
	.word	.LC0
	.word	.LC1
	.word	prueba
	.word	.LC2
	.word	.LC3
	.word	100000
	.word	.LC4
	.word	.LC5
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 47) 7.1.0"
