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
	.ascii	"\012Ni X ni Y pulsados\000"
	.align	2
.LC1:
	.ascii	"\012X pulsada\000"
	.align	2
.LC2:
	.ascii	"\012Y pulsada\000"
	.align	2
.LC3:
	.ascii	"\012X e Y pulsados\000"
	.align	2
.LC4:
	.ascii	"\012*Introdueix un string*\012\000"
	.align	2
.LC5:
	.ascii	"\012Longitud de l'string: %d\000"
	.align	2
.LC6:
	.ascii	"\012Valor de l'string:\012%s\000"
	.align	2
.LC7:
	.ascii	"\012arg=0: Concatenar strings\012*Introdueix un alt"
	.ascii	"re string*\000"
	.align	2
.LC8:
	.ascii	"\012arg=1: Invertir String\000"
	.align	2
.LC9:
	.ascii	"\012arg=2: toUpperCase\000"
	.align	2
.LC10:
	.ascii	"\012arg=3: toLowerCase\000"
	.align	2
.LC11:
	.ascii	"\012STRING RESULTAT:\012\000"
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
	bl	GARLIC_getXYbuttons
	mov	r3, r0
	strb	r3, [sp, #139]
	ldrb	r3, [sp, #139]	@ zero_extendqisi2
	cmp	r3, #3
	bne	.L4
	ldr	r0, .L32
	bl	GARLIC_printf
	b	.L3
.L4:
	ldrb	r3, [sp, #139]	@ zero_extendqisi2
	cmp	r3, #2
	bne	.L6
	ldr	r0, .L32+4
	bl	GARLIC_printf
	b	.L3
.L6:
	ldrb	r3, [sp, #139]	@ zero_extendqisi2
	cmp	r3, #1
	bne	.L7
	ldr	r0, .L32+8
	bl	GARLIC_printf
	b	.L3
.L7:
	ldrb	r3, [sp, #139]	@ zero_extendqisi2
	cmp	r3, #0
	bne	.L3
	ldr	r0, .L32+12
	bl	GARLIC_printf
	nop
	mov	r3, #0
	str	r3, [sp, #140]
	b	.L9
.L10:
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, #32
	strb	r2, [r3]
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L9:
	ldr	r3, [sp, #140]
	cmp	r3, #56
	ble	.L10
	ldr	r0, .L32+16
	bl	GARLIC_printf
	add	r3, sp, #100
	mov	r1, #28
	mov	r0, r3
	bl	GARLIC_getstring
	str	r0, [sp, #132]
	ldr	r1, [sp, #132]
	ldr	r0, .L32+20
	bl	GARLIC_printf
	add	r3, sp, #100
	mov	r1, r3
	ldr	r0, .L32+24
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	cmp	r3, #3
	ldrls	pc, [pc, r3, asl #2]
	b	.L11
.L13:
	.word	.L12
	.word	.L14
	.word	.L15
	.word	.L16
.L12:
	ldr	r0, .L32+28
	bl	GARLIC_printf
	add	r3, sp, #72
	mov	r1, #28
	mov	r0, r3
	bl	GARLIC_getstring
	str	r0, [sp, #128]
	ldr	r1, [sp, #128]
	ldr	r0, .L32+20
	bl	GARLIC_printf
	add	r3, sp, #72
	mov	r1, r3
	ldr	r0, .L32+24
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #140]
	b	.L17
.L18:
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L17:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #132]
	cmp	r2, r3
	blt	.L18
	mov	r3, #0
	str	r3, [sp, #140]
	b	.L19
.L20:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #132]
	add	r3, r2, r3
	add	r1, sp, #72
	ldr	r2, [sp, #140]
	add	r2, r1, r2
	ldrb	r2, [r2]	@ zero_extendqisi2
	add	r1, sp, #144
	add	r3, r1, r3
	strb	r2, [r3, #-132]
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L19:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #128]
	cmp	r2, r3
	blt	.L20
	b	.L11
.L14:
	ldr	r0, .L32+32
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #140]
	b	.L21
.L22:
	ldr	r2, [sp, #132]
	ldr	r3, [sp, #140]
	sub	r3, r2, r3
	sub	r3, r3, #1
	add	r2, sp, #144
	add	r3, r2, r3
	ldrb	r1, [r3, #-44]	@ zero_extendqisi2
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L21:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #132]
	cmp	r2, r3
	blt	.L22
	b	.L11
.L15:
	ldr	r0, .L32+36
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #140]
	b	.L23
.L26:
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #96
	bls	.L24
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #122
	bhi	.L24
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	sub	r3, r3, #32
	and	r1, r3, #255
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	b	.L25
.L24:
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
.L25:
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L23:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #132]
	cmp	r2, r3
	blt	.L26
	b	.L11
.L16:
	ldr	r0, .L32+40
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #140]
	b	.L27
.L30:
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #64
	bls	.L28
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #90
	bhi	.L28
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	add	r3, r3, #32
	and	r1, r3, #255
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	b	.L29
.L28:
	add	r2, sp, #100
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	add	r2, sp, #12
	ldr	r3, [sp, #140]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
.L29:
	ldr	r3, [sp, #140]
	add	r3, r3, #1
	str	r3, [sp, #140]
.L27:
	ldr	r2, [sp, #140]
	ldr	r3, [sp, #132]
	cmp	r2, r3
	blt	.L30
	nop
.L11:
	ldr	r0, .L32+44
	bl	GARLIC_printf
	add	r3, sp, #12
	mov	r0, r3
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #148
	@ sp needed
	ldr	pc, [sp], #4
.L33:
	.align	2
.L32:
	.word	.LC0
	.word	.LC1
	.word	.LC2
	.word	.LC3
	.word	.LC4
	.word	.LC5
	.word	.LC6
	.word	.LC7
	.word	.LC8
	.word	.LC9
	.word	.LC10
	.word	.LC11
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
