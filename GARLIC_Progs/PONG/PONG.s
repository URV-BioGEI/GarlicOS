	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"PONG.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"-- Programa PONG  -  PID %2(%d) %0--\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #28
	str	r0, [sp, #4]
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bge	.L2
	mov	r3, #0
	str	r3, [sp, #4]
.L2:
	ldr	r3, [sp, #4]
	cmp	r3, #3
	ble	.L3
	mov	r3, #3
	str	r3, [sp, #4]
.L3:
	bl	GARLIC_clear
	bl	GARLIC_pid
	mov	r3, r0
	mov	r1, r3
	ldr	r0, .L11
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #20]
	mov	r3, #0
	str	r3, [sp, #16]
	mov	r3, #1
	str	r3, [sp, #12]
	mov	r3, #1
	str	r3, [sp, #8]
	ldr	r3, [sp, #4]
	mov	r2, #95
	ldr	r1, [sp, #16]
	ldr	r0, [sp, #20]
	bl	GARLIC_printchar
.L10:
	ldr	r3, [sp, #4]
	mov	r0, r3
	bl	GARLIC_delay
	ldr	r3, [sp, #4]
	mov	r2, #0
	ldr	r1, [sp, #16]
	ldr	r0, [sp, #20]
	bl	GARLIC_printchar
	ldr	r2, [sp, #20]
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	str	r3, [sp, #20]
	ldr	r2, [sp, #16]
	ldr	r3, [sp, #8]
	add	r3, r2, r3
	str	r3, [sp, #16]
	ldr	r3, [sp, #20]
	cmp	r3, #31
	beq	.L4
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L5
.L4:
	ldr	r3, [sp, #12]
	rsb	r3, r3, #0
	str	r3, [sp, #12]
.L5:
	ldr	r3, [sp, #16]
	cmp	r3, #23
	beq	.L6
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bne	.L7
.L6:
	ldr	r3, [sp, #8]
	rsb	r3, r3, #0
	str	r3, [sp, #8]
.L7:
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L8
	ldr	r3, [sp, #16]
	cmp	r3, #0
	bne	.L8
	mov	r3, #1
	str	r3, [sp, #16]
	b	.L9
.L8:
	ldr	r3, [sp, #20]
	cmp	r3, #0
	bne	.L9
	ldr	r3, [sp, #16]
	cmp	r3, #1
	bne	.L9
	mov	r3, #0
	str	r3, [sp, #16]
	mov	r3, #1
	str	r3, [sp, #8]
.L9:
	ldr	r3, [sp, #4]
	mov	r2, #95
	ldr	r1, [sp, #16]
	ldr	r0, [sp, #20]
	bl	GARLIC_printchar
	b	.L10
.L12:
	.align	2
.L11:
	.word	.LC0
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
