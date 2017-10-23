	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"detm.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"-- Programa DETM  -  PID (%d) --\012\000"
	.align	2
.LC1:
	.ascii	"(%d)\011Element: %d\012\000"
	.align	2
.LC2:
	.ascii	"(%d)\011DETERMINANT = %d\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 144
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #148
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
	ldr	r3, [sp, #4]
	add	r3, r3, #2
	str	r3, [sp, #124]
	ldr	r3, [sp, #124]
	sub	r3, r3, #1
	str	r3, [sp, #120]
	bl	GARLIC_pid
	mov	r3, r0
	mov	r1, r3
	ldr	r0, .L19
	bl	GARLIC_printf
	mov	r3, #1
	str	r3, [sp, #140]
	b	.L4
.L7:
	mov	r3, #1
	str	r3, [sp, #136]
	b	.L5
.L6:
	bl	GARLIC_random
	mov	r1, r0
	ldr	r0, .L19+4
	smull	r2, r3, r1, r0
	asr	r2, r3, #2
	asr	r3, r1, #31
	sub	r2, r2, r3
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #1
	sub	r2, r1, r3
	mov	r1, r2
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	str	r1, [r3, #-128]
	ldr	r3, [sp, #136]
	add	r3, r3, #1
	str	r3, [sp, #136]
.L5:
	ldr	r2, [sp, #136]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	ble	.L6
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L4:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	ble	.L7
	mov	r3, #1
	str	r3, [sp, #140]
	b	.L8
.L11:
	mov	r3, #1
	str	r3, [sp, #136]
	b	.L9
.L10:
	bl	GARLIC_pid
	mov	r1, r0
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r3, [r3, #-128]
	mov	r2, r3
	ldr	r0, .L19+8
	bl	GARLIC_printf
	ldr	r3, [sp, #136]
	add	r3, r3, #1
	str	r3, [sp, #136]
.L9:
	ldr	r2, [sp, #136]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	ble	.L10
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L8:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	ble	.L11
	ldr	r3, [sp, #40]
	str	r3, [sp, #128]
	mov	r3, #1
	str	r3, [sp, #132]
	b	.L12
.L17:
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #116]
	ldr	r3, [sp, #116]
	str	r3, [sp, #140]
	b	.L13
.L16:
	ldr	r3, [sp, #116]
	str	r3, [sp, #136]
	b	.L14
.L15:
	ldr	r2, [sp, #132]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r2, sp, #144
	add	r3, r2, r3
	sub	r3, r3, #128
	ldr	r0, [r3]
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r3, [r3, #-128]
	mul	r1, r3, r0
	ldr	r2, [sp, #132]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r0, [r3, #-128]
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #132]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r2, [r3, #-128]
	mul	r3, r0, r2
	sub	r0, r1, r3
	ldr	r2, [sp, #132]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r2, sp, #144
	add	r3, r2, r3
	sub	r3, r3, #128
	ldr	r1, [r3]
	add	r3, sp, #8
	add	r2, sp, #12
	bl	GARLIC_divmod
	ldr	r1, [sp, #12]
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	str	r1, [r3, #-128]
	ldr	r3, [sp, #136]
	add	r3, r3, #1
	str	r3, [sp, #136]
.L14:
	ldr	r2, [sp, #136]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	ble	.L15
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L13:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	ble	.L16
	ldr	r3, [sp, #132]
	add	r2, r3, #1
	ldr	r3, [sp, #132]
	add	r1, r3, #1
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	add	r3, r3, r1
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r1, [r3, #-128]
	ldr	r2, [sp, #128]
	mul	r3, r2, r1
	str	r3, [sp, #128]
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L12:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #120]
	cmp	r2, r3
	ble	.L17
	bl	GARLIC_pid
	mov	r3, r0
	ldr	r2, [sp, #128]
	mov	r1, r3
	ldr	r0, .L19+12
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #148
	@ sp needed
	ldr	pc, [sp], #4
.L20:
	.align	2
.L19:
	.word	.LC0
	.word	1717986919
	.word	.LC1
	.word	.LC2
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 47) 7.1.0"
