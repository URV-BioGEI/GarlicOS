	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"TERNS.c"
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
	.ascii	"-- Programa TERNS --\012\000"
	.align	2
.LC1:
	.ascii	"TERNA %d : ( %d,\000"
	.align	2
.LC2:
	.ascii	" %d, %d )\012\000"
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
	add	r2, r3, #1
	mov	r3, r2
	lsl	r3, r3, #5
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #4
	str	r3, [sp, #20]
	mov	r3, #0
	str	r3, [sp, #36]
	mov	r3, #0
	str	r3, [sp, #32]
	ldr	r0, .L15
	bl	GARLIC_printf
	mov	r3, #2
	str	r3, [sp, #24]
	b	.L6
.L12:
	mov	r3, #1
	str	r3, [sp, #28]
	b	.L7
.L11:
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #24]
	mul	r0, r3, r2
	ldr	r3, [sp, #28]
	ldr	r1, [sp, #28]
	mul	r2, r1, r3
	sub	r3, r0, r2
	str	r3, [sp, #16]
	ldr	r3, [sp, #24]
	lsl	r1, r3, #1
	ldr	r2, [sp, #28]
	mul	r3, r2, r1
	str	r3, [sp, #12]
	ldr	r3, [sp, #24]
	ldr	r2, [sp, #24]
	mul	r0, r3, r2
	ldr	r3, [sp, #28]
	ldr	r1, [sp, #28]
	mul	r2, r1, r3
	add	r3, r0, r2
	str	r3, [sp, #36]
	ldr	r2, [sp, #36]
	ldr	r3, [sp, #20]
	cmp	r2, r3
	bhi	.L14
	ldr	r1, [sp, #12]
	ldr	r0, [sp, #16]
	bl	mcd
	mov	r3, r0
	ldr	r1, [sp, #36]
	mov	r0, r3
	bl	mcd
	mov	r3, r0
	cmp	r3, #0
	beq	.L10
	ldr	r3, [sp, #32]
	add	r3, r3, #1
	str	r3, [sp, #32]
	ldr	r2, [sp, #16]
	ldr	r1, [sp, #32]
	ldr	r0, .L15+4
	bl	GARLIC_printf
	ldr	r2, [sp, #36]
	ldr	r1, [sp, #12]
	ldr	r0, .L15+8
	bl	GARLIC_printf
.L10:
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L7:
	ldr	r2, [sp, #28]
	ldr	r3, [sp, #24]
	cmp	r2, r3
	blt	.L11
	b	.L9
.L14:
	nop
.L9:
	ldr	r3, [sp, #24]
	add	r3, r3, #1
	str	r3, [sp, #24]
.L6:
	ldr	r2, [sp, #36]
	ldr	r3, [sp, #20]
	cmp	r2, r3
	bcc	.L12
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #44
	@ sp needed
	ldr	pc, [sp], #4
.L16:
	.align	2
.L15:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 47) 7.1.0"
