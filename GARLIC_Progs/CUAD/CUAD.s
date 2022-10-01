	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"CUAD.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"-- Programa CUAD  -  PID (%d) --\012\000"
	.align	2
.LC1:
	.ascii	"%d \000"
	.align	2
.LC2:
	.ascii	"\012 %d <-Suma de numeros a cuadrado entre n. \000"
	.align	2
.LC3:
	.ascii	"La size es: %d \012\000"
	.align	2
.LC4:
	.ascii	"La media cuadr\341tica es: %d \012 con %d \012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 88
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #92
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
	ldr	r0, .L8
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	str	r3, [sp, #68]
	ldr	r3, [sp, #68]
	str	r3, [sp, #64]
	ldr	r3, [sp, #68]
	ldr	r2, [sp, #68]
	mul	r3, r2, r3
	ldr	r2, [sp, #68]
	mul	r3, r2, r3
	ldr	r2, [sp, #68]
	mul	r3, r2, r3
	ldr	r2, [sp, #68]
	mul	r3, r2, r3
	str	r3, [sp, #64]
	mov	r3, #0
	str	r3, [sp, #80]
	mov	r3, #0
	str	r3, [sp, #84]
	b	.L4
.L5:
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	add	r3, sp, #36
	add	r2, sp, #40
	mov	r1, #100
	bl	GARLIC_divmod
	ldr	r3, [sp, #36]
	mov	r1, r3
	ldr	r0, .L8+4
	bl	GARLIC_printf
	ldr	r3, [sp, #36]
	ldr	r2, [sp, #36]
	mul	r3, r2, r3
	str	r3, [sp, #60]
	ldr	r2, [sp, #80]
	ldr	r3, [sp, #60]
	add	r3, r2, r3
	str	r3, [sp, #80]
	ldr	r3, [sp, #84]
	add	r3, r3, #1
	str	r3, [sp, #84]
.L4:
	ldr	r2, [sp, #84]
	ldr	r3, [sp, #64]
	cmp	r2, r3
	blt	.L5
	ldr	r0, [sp, #80]
	ldr	r1, [sp, #64]
	add	r3, sp, #28
	add	r2, sp, #32
	bl	GARLIC_divmod
	ldr	r3, [sp, #32]
	str	r3, [sp, #80]
	ldr	r1, [sp, #80]
	ldr	r0, .L8+8
	bl	GARLIC_printf
	ldr	r3, [sp, #80]
	str	r3, [sp, #76]
	mov	r3, #0
	str	r3, [sp, #56]
	mov	r3, #0
	str	r3, [sp, #72]
.L6:
	ldr	r3, [sp, #76]
	ldr	r2, [sp, #76]
	mul	r2, r3, r2
	ldr	r3, [sp, #80]
	add	r3, r2, r3
	str	r3, [sp, #52]
	ldr	r3, [sp, #76]
	lsl	r3, r3, #1
	str	r3, [sp, #48]
	ldr	r0, [sp, #52]
	ldr	r1, [sp, #48]
	add	r3, sp, #20
	add	r2, sp, #24
	bl	GARLIC_divmod
	ldr	r3, [sp, #24]
	str	r3, [sp, #76]
	ldr	r3, [sp, #36]
	ldr	r2, .L8+12
	mul	r3, r2, r3
	str	r3, [sp, #56]
	ldr	r0, [sp, #56]
	add	r3, sp, #12
	add	r2, sp, #16
	ldr	r1, .L8+12
	bl	GARLIC_divmod
	ldr	r3, [sp, #16]
	str	r3, [sp, #56]
	ldr	r3, [sp, #72]
	add	r3, r3, #1
	str	r3, [sp, #72]
	ldr	r3, [sp, #72]
	cmp	r3, #24
	ble	.L6
	mov	r3, #0
	str	r3, [sp, #44]
	ldr	r1, [sp, #64]
	ldr	r0, .L8+16
	bl	GARLIC_printf
	ldr	r2, [sp, #56]
	ldr	r1, [sp, #76]
	ldr	r0, .L8+20
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #92
	@ sp needed
	ldr	pc, [sp], #4
.L9:
	.align	2
.L8:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	100000
	.word	.LC3
	.word	.LC4
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
