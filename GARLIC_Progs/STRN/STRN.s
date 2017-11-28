	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"STRN.c"
	.section	.rodata
	.align	2
.LC0:
	.ascii	"*Introdueix un string*\012\000"
	.align	2
.LC1:
	.ascii	"\012Longitud de l'string: %d\000"
	.align	2
.LC2:
	.ascii	"\012Valor de l'string:\012%s\000"
	.align	2
.LC3:
	.ascii	"\012arg=0: Concatenar strings\012*Introdueix un alt"
	.ascii	"re string*\000"
	.align	2
.LC4:
	.ascii	"\012arg=1: Invertir String\000"
	.align	2
.LC5:
	.ascii	"\012arg=2: toUpperCase\000"
	.align	2
.LC6:
	.ascii	"\012arg=3: toLowerCase\000"
	.align	2
.LC7:
	.ascii	"\012STRING RESULTAT:\012\000"
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
	str	lr, [sp, #-4]!
	sub	sp, sp, #140
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
	mov	r3, #0
	str	r3, [sp, #132]
	b	.L4
.L5:
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, #32
	strb	r2, [r3]
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L4:
	ldr	r3, [sp, #132]
	cmp	r3, #56
	ble	.L5
	ldr	r0, .L27
	bl	GARLIC_printf
	add	r3, sp, #96
	mov	r1, #28
	mov	r0, r3
	bl	GARLIC_getstring
	str	r0, [sp, #128]
	ldr	r1, [sp, #128]
	ldr	r0, .L27+4
	bl	GARLIC_printf
	add	r3, sp, #96
	mov	r1, r3
	ldr	r0, .L27+8
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	cmp	r3, #3
	ldrls	pc, [pc, r3, asl #2]
	b	.L6
.L8:
	.word	.L7
	.word	.L9
	.word	.L10
	.word	.L11
.L7:
	ldr	r0, .L27+12
	bl	GARLIC_printf
	add	r3, sp, #68
	mov	r1, #28
	mov	r0, r3
	bl	GARLIC_getstring
	str	r0, [sp, #124]
	ldr	r1, [sp, #124]
	ldr	r0, .L27+4
	bl	GARLIC_printf
	add	r3, sp, #68
	mov	r1, r3
	ldr	r0, .L27+8
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #132]
	b	.L12
.L13:
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L12:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #128]
	cmp	r2, r3
	blt	.L13
	mov	r3, #0
	str	r3, [sp, #132]
	b	.L14
.L15:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #128]
	add	r3, r2, r3
	add	r1, sp, #68
	ldr	r2, [sp, #132]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r1, sp, #136
	add	r3, r1, r3
	strb	r2, [r3, #-128]
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L14:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #124]
	cmp	r2, r3
	blt	.L15
	b	.L6
.L9:
	ldr	r0, .L27+16
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #132]
	b	.L16
.L17:
	ldr	r2, [sp, #128]
	ldr	r3, [sp, #132]
	sub	r3, r2, r3
	sub	r3, r3, #1
	add	r2, sp, #136
	add	r3, r2, r3
	ldrb	r1, [r3, #-40]	@ zero_extendqisi2
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L16:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #128]
	cmp	r2, r3
	blt	.L17
	b	.L6
.L10:
	ldr	r0, .L27+20
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #132]
	b	.L18
.L21:
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #96
	bls	.L19
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #122
	bhi	.L19
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	sub	r3, r3, #32
	and	r1, r3, #255
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	b	.L20
.L19:
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
.L20:
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L18:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #128]
	cmp	r2, r3
	blt	.L21
	b	.L6
.L11:
	ldr	r0, .L27+24
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #132]
	b	.L22
.L25:
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #64
	bls	.L23
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #90
	bhi	.L23
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, #32
	and	r1, r3, #255
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	b	.L24
.L23:
	add	r2, sp, #96
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	r2, sp, #8
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
.L24:
	ldr	r3, [sp, #132]
	add	r3, r3, #1
	str	r3, [sp, #132]
.L22:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #128]
	cmp	r2, r3
	blt	.L25
	nop
.L6:
	ldr	r0, .L27+28
	bl	GARLIC_printf
	add	r3, sp, #8
	mov	r0, r3
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #140
	@ sp needed
	ldr	pc, [sp], #4
.L28:
	.align	2
.L27:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 47) 7.1.0"
