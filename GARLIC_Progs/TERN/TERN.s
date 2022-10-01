	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"TERN.c"
	.text
	.align	2
	.global	mcd
	.syntax unified
	.arm
	.fpu softvfp
	.type	mcd, %function
mcd:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #28
	str	r0, [sp, #4]
	str	r1, [sp]
	b	.L2
.L3:
	ldr	r3, [sp]
	str	r3, [sp, #20]
	add	r3, sp, #12
	add	r2, sp, #16
	ldr	r1, [sp]
	ldr	r0, [sp, #4]
	bl	GARLIC_divmod
	ldr	r3, [sp, #12]
	str	r3, [sp]
	ldr	r3, [sp, #20]
	str	r3, [sp, #4]
.L2:
	ldr	r3, [sp]
	cmp	r3, #0
	bne	.L3
	ldr	r3, [sp, #4]
	mov	r0, r3
	add	sp, sp, #28
	@ sp needed
	ldr	pc, [sp], #4
	.size	mcd, .-mcd
	.section	.rodata
	.align	2
.LC0:
	.ascii	"%0-- %1Programa TERNS%0 --\012\000"
	.align	2
.LC1:
	.ascii	"%0TERNA %d: (%1 %d%0,\000"
	.align	2
.LC2:
	.ascii	"%2 %d%0,%3 %d %0)\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #44
	str	r0, [sp, #4]
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	mov	r2, #2000
	mul	r3, r2, r3
	str	r3, [sp, #16]
	mov	r3, #0
	str	r3, [sp, #36]
	mov	r3, #0
	str	r3, [sp, #32]
	mov	r3, #0
	str	r3, [sp, #28]
	ldr	r0, .L14
	bl	GARLIC_printf
	mov	r3, #2
	str	r3, [sp, #20]
	b	.L6
.L12:
	mov	r3, #1
	str	r3, [sp, #24]
	b	.L7
.L10:
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #20]
	mul	r2, r3, r2
	ldr	r3, [sp, #24]
	ldr	r1, [sp, #24]
	mul	r3, r1, r3
	sub	r3, r2, r3
	str	r3, [sp, #12]
	ldr	r3, [sp, #20]
	lsl	r3, r3, #1
	ldr	r2, [sp, #24]
	mul	r3, r2, r3
	str	r3, [sp, #8]
	ldr	r3, [sp, #20]
	ldr	r2, [sp, #20]
	mul	r2, r3, r2
	ldr	r3, [sp, #24]
	ldr	r1, [sp, #24]
	mul	r3, r1, r3
	add	r3, r2, r3
	str	r3, [sp, #36]
	ldr	r2, [sp, #36]
	ldr	r3, [sp, #16]
	cmp	r2, r3
	bls	.L8
	mov	r3, #1
	str	r3, [sp, #28]
.L8:
	ldr	r1, [sp, #8]
	ldr	r0, [sp, #12]
	bl	mcd
	mov	r3, r0
	ldr	r1, [sp, #36]
	mov	r0, r3
	bl	mcd
	mov	r3, r0
	cmp	r3, #1
	bne	.L9
	ldr	r3, [sp, #32]
	add	r3, r3, #1
	str	r3, [sp, #32]
	ldr	r3, [sp, #4]
	rsb	r3, r3, #3
	mov	r0, r3
	bl	GARLIC_delay
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #32]
	ldr	r0, .L14+4
	bl	GARLIC_printf
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #8]
	ldr	r0, .L14+8
	bl	GARLIC_printf
.L9:
	ldr	r3, [sp, #24]
	add	r3, r3, #1
	str	r3, [sp, #24]
.L7:
	ldr	r2, [sp, #24]
	ldr	r3, [sp, #20]
	cmp	r2, r3
	blt	.L10
	ldr	r3, [sp, #20]
	add	r3, r3, #1
	str	r3, [sp, #20]
.L6:
	ldr	r2, [sp, #36]
	ldr	r3, [sp, #16]
	cmp	r2, r3
	bcs	.L11
	ldr	r3, [sp, #28]
	cmp	r3, #0
	beq	.L12
.L11:
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #44
	@ sp needed
	ldr	pc, [sp], #4
.L15:
	.align	2
.L14:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
