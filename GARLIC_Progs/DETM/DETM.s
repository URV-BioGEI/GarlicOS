	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"DETM.c"
	.global	__aeabi_i2f
	.global	__aeabi_f2d
	.section	.rodata
	.align	2
.LC0:
	.ascii	"\011\011\011A(%d,%d) =%8.4f\012\000"
	.global	__aeabi_fmul
	.global	__aeabi_fsub
	.global	__aeabi_fdiv
	.align	2
.LC1:
	.ascii	"\012\012\000"
	.align	2
.LC2:
	.ascii	"\011\011\011DETERMINANT = %f\012\000"
	.align	2
.LC3:
	.ascii	"\011\011\011-------------------------\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 136
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	sub	sp, sp, #144
	str	r0, [sp, #12]
	ldr	r3, [sp, #12]
	cmp	r3, #0
	bge	.L2
	mov	r3, #0
	str	r3, [sp, #12]
	b	.L3
.L2:
	ldr	r3, [sp, #12]
	cmp	r3, #3
	ble	.L3
	mov	r3, #3
	str	r3, [sp, #12]
.L3:
	ldr	r3, [sp, #12]
	add	r3, r3, #2
	str	r3, [sp, #124]
	ldr	r3, [sp, #124]
	sub	r3, r3, #1
	str	r3, [sp, #120]
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
	ldr	r0, .L19
	smull	r2, r3, r1, r0
	asr	r2, r3, #2
	asr	r3, r1, #31
	sub	r2, r2, r3
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r3, r3, #1
	sub	r2, r1, r3
	mov	r0, r2
	bl	__aeabi_i2f
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
	str	r1, [r3, #-128]	@ float
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
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r3, [r3, #-128]	@ float
	mov	r0, r3
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	strd	r2, [sp]
	ldr	r2, [sp, #136]
	ldr	r1, [sp, #140]
	ldr	r0, .L19+4
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
	ldr	r3, [sp, #40]	@ float
	str	r3, [sp, #128]	@ float
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
	ldr	r0, [r3]	@ float
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r3, [r3, #-128]	@ float
	mov	r1, r3
	bl	__aeabi_fmul
	mov	r3, r0
	mov	r4, r3
	ldr	r2, [sp, #132]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r0, [r3, #-128]	@ float
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #132]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	ldr	r3, [r3, #-128]	@ float
	mov	r1, r3
	bl	__aeabi_fmul
	mov	r3, r0
	mov	r1, r3
	mov	r0, r4
	bl	__aeabi_fsub
	mov	r3, r0
	mov	r0, r3
	ldr	r2, [sp, #132]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #3
	add	r2, sp, #144
	add	r3, r2, r3
	sub	r3, r3, #128
	ldr	r3, [r3]	@ float
	mov	r1, r3
	bl	__aeabi_fdiv
	mov	r3, r0
	mov	r1, r3
	ldr	r2, [sp, #140]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	ldr	r2, [sp, #136]
	add	r3, r3, r2
	lsl	r3, r3, #2
	add	r2, sp, #144
	add	r3, r2, r3
	str	r1, [r3, #-128]	@ float
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
	ldr	r3, [r3, #-128]	@ float
	mov	r1, r3
	ldr	r0, [sp, #128]	@ float
	bl	__aeabi_fmul
	mov	r3, r0
	str	r3, [sp, #128]	@ float
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L12:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #120]
	cmp	r2, r3
	ble	.L17
	ldr	r0, .L19+8
	bl	GARLIC_printf
	ldr	r0, [sp, #128]	@ float
	bl	__aeabi_f2d
	mov	r2, r0
	mov	r3, r1
	ldr	r0, .L19+12
	bl	GARLIC_printf
	ldr	r0, .L19+16
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #144
	@ sp needed
	pop	{r4, pc}
.L20:
	.align	2
.L19:
	.word	1717986919
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 47) 7.1.0"
