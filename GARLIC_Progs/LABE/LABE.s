	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"LABE.c"
	.comm	chars,112,4
	.comm	lab,512,4
	.comm	nchars,4,4
	.comm	labx,4,4
	.comm	laby,4,4
	.comm	points,4,4
	.text
	.align	2
	.global	init_lab
	.syntax unified
	.arm
	.fpu softvfp
	.type	init_lab, %function
init_lab:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #36
	mov	r3, #0
	str	r3, [sp, #24]
	b	.L2
.L3:
	ldr	r2, .L16
	ldr	r3, [sp, #24]
	add	r3, r2, r3
	mov	r2, #98
	strb	r2, [r3]
	ldr	r3, .L16+4
	ldr	r3, [r3]
	sub	r3, r3, #1
	ldr	r2, .L16
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #24]
	add	r3, r2, r3
	mov	r2, #98
	strb	r2, [r3]
	ldr	r0, [sp, #24]
	mov	r3, #0
	mov	r2, #95
	mov	r1, #4
	bl	GARLIC_printchar
	ldr	r0, [sp, #24]
	ldr	r3, .L16+4
	ldr	r3, [r3]
	add	r3, r3, #3
	mov	r1, r3
	mov	r3, #0
	mov	r2, #95
	bl	GARLIC_printchar
	ldr	r3, [sp, #24]
	add	r3, r3, #1
	str	r3, [sp, #24]
.L2:
	ldr	r3, .L16+8
	ldr	r3, [r3]
	ldr	r2, [sp, #24]
	cmp	r2, r3
	bcc	.L3
	mov	r3, #1
	str	r3, [sp, #28]
	b	.L4
.L5:
	ldr	r2, .L16
	ldr	r3, [sp, #28]
	mov	r1, #98
	strb	r1, [r2, r3, lsl #5]
	ldr	r3, .L16+8
	ldr	r3, [r3]
	sub	r3, r3, #1
	ldr	r1, .L16
	ldr	r2, [sp, #28]
	lsl	r2, r2, #5
	add	r2, r1, r2
	add	r3, r2, r3
	mov	r2, #98
	strb	r2, [r3]
	ldr	r3, [sp, #28]
	add	r3, r3, #4
	mov	r1, r3
	mov	r3, #0
	mov	r2, #95
	mov	r0, #0
	bl	GARLIC_printchar
	ldr	r3, .L16+8
	ldr	r3, [r3]
	sub	r3, r3, #1
	mov	r0, r3
	ldr	r3, [sp, #28]
	add	r3, r3, #4
	mov	r1, r3
	mov	r3, #0
	mov	r2, #95
	bl	GARLIC_printchar
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L4:
	ldr	r3, .L16+4
	ldr	r3, [r3]
	sub	r2, r3, #1
	ldr	r3, [sp, #28]
	cmp	r2, r3
	bhi	.L5
	mov	r3, #1
	str	r3, [sp, #28]
	b	.L6
.L9:
	mov	r3, #1
	str	r3, [sp, #24]
	b	.L7
.L8:
	ldr	r2, .L16
	ldr	r3, [sp, #28]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #24]
	add	r3, r2, r3
	mov	r2, #102
	strb	r2, [r3]
	ldr	r3, [sp, #24]
	add	r3, r3, #1
	str	r3, [sp, #24]
.L7:
	ldr	r3, .L16+8
	ldr	r3, [r3]
	sub	r2, r3, #1
	ldr	r3, [sp, #24]
	cmp	r2, r3
	bhi	.L8
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L6:
	ldr	r3, .L16+4
	ldr	r3, [r3]
	sub	r2, r3, #1
	ldr	r3, [sp, #28]
	cmp	r2, r3
	bhi	.L9
	ldr	r3, .L16+8
	ldr	r2, [r3]
	mov	r3, r2
	lsl	r3, r3, #2
	add	r3, r3, r2
	lsl	r2, r3, #2
	add	r3, r3, r2
	sub	r3, r3, #50
	ldr	r2, .L16+4
	ldr	r2, [r2]
	sub	r2, r2, #2
	mul	r3, r2, r3
	ldr	r2, .L16+12
	umull	r1, r3, r2, r3
	lsr	r3, r3, #5
	str	r3, [sp, #20]
	ldr	r2, .L16+16
	ldr	r3, [sp, #20]
	str	r3, [r2]
	mov	r3, #0
	str	r3, [sp, #28]
	b	.L10
.L11:
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	ldr	r3, .L16+8
	ldr	r1, [r3]
	add	r3, sp, #4
	add	r2, sp, #8
	bl	GARLIC_divmod
	ldr	r3, [sp, #4]
	str	r3, [sp, #16]
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	ldr	r3, .L16+4
	ldr	r1, [r3]
	add	r3, sp, #4
	add	r2, sp, #8
	bl	GARLIC_divmod
	ldr	r3, [sp, #4]
	str	r3, [sp, #12]
	ldr	r2, .L16
	ldr	r3, [sp, #12]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #98
	beq	.L10
	ldr	r0, [sp, #16]
	ldr	r3, [sp, #12]
	add	r3, r3, #4
	mov	r1, r3
	mov	r3, #0
	mov	r2, #95
	bl	GARLIC_printchar
	ldr	r2, .L16
	ldr	r3, [sp, #12]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r3, r2, r3
	mov	r2, #98
	strb	r2, [r3]
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L10:
	ldr	r2, [sp, #28]
	ldr	r3, [sp, #20]
	cmp	r2, r3
	bcc	.L11
	mov	r3, #0
	str	r3, [sp, #28]
	b	.L12
.L13:
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	ldr	r3, .L16+8
	ldr	r1, [r3]
	add	r3, sp, #4
	add	r2, sp, #8
	bl	GARLIC_divmod
	ldr	r3, [sp, #4]
	str	r3, [sp, #16]
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	ldr	r3, .L16+4
	ldr	r1, [r3]
	add	r3, sp, #4
	add	r2, sp, #8
	bl	GARLIC_divmod
	ldr	r3, [sp, #4]
	str	r3, [sp, #12]
	ldr	r2, .L16
	ldr	r3, [sp, #12]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #102
	bne	.L12
	ldr	r0, [sp, #16]
	ldr	r3, [sp, #12]
	add	r3, r3, #4
	mov	r1, r3
	mov	r3, #0
	mov	r2, #14
	bl	GARLIC_printchar
	ldr	r2, .L16
	ldr	r3, [sp, #12]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r3, r2, r3
	mov	r2, #112
	strb	r2, [r3]
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L12:
	ldr	r2, [sp, #28]
	ldr	r3, [sp, #20]
	cmp	r2, r3
	bcc	.L13
	mov	r3, #0
	str	r3, [sp, #28]
	b	.L14
.L15:
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #1
	mov	ip, r3
	ldr	r1, .L16+20
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r1, .L16+20
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r0
	mov	r1, #22
	mov	r0, ip
	bl	GARLIC_printchar
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, #1
	mov	r0, r3
	ldr	r1, .L16+20
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, #26
	mov	r1, #22
	bl	GARLIC_printchar
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, #3
	mov	r0, r3
	ldr	r1, .L16+20
	ldr	r2, [sp, #28]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, #16
	mov	r1, #22
	bl	GARLIC_printchar
	ldr	r3, [sp, #28]
	add	r3, r3, #1
	str	r3, [sp, #28]
.L14:
	ldr	r3, .L16+24
	ldr	r3, [r3]
	ldr	r2, [sp, #28]
	cmp	r2, r3
	bcc	.L15
	nop
	add	sp, sp, #36
	@ sp needed
	ldr	pc, [sp], #4
.L17:
	.align	2
.L16:
	.word	lab
	.word	laby
	.word	labx
	.word	1374389535
	.word	points
	.word	chars
	.word	nchars
	.size	init_lab, .-init_lab
	.align	2
	.global	init_chars
	.syntax unified
	.arm
	.fpu softvfp
	.type	init_chars, %function
init_chars:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #28
	mov	r3, #0
	str	r3, [sp, #20]
	b	.L19
.L22:
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	ldr	r3, .L23
	ldr	r1, [r3]
	add	r3, sp, #4
	add	r2, sp, #8
	bl	GARLIC_divmod
	ldr	r3, [sp, #4]
	str	r3, [sp, #16]
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	ldr	r3, .L23+4
	ldr	r1, [r3]
	add	r3, sp, #4
	add	r2, sp, #8
	bl	GARLIC_divmod
	ldr	r3, [sp, #4]
	str	r3, [sp, #12]
	ldr	r2, .L23+8
	ldr	r3, [sp, #12]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #102
	bne	.L19
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	ldrb	r1, [r3]	@ zero_extendqisi2
	ldr	r2, .L23+8
	ldr	r3, [sp, #12]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #16]
	add	r3, r2, r3
	mov	r2, r1
	strb	r2, [r3]
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldr	r2, [sp, #16]
	str	r2, [r3]
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r2, [sp, #12]
	str	r2, [r3]
	ldr	r0, [sp, #16]
	ldr	r3, [sp, #12]
	add	r3, r3, #4
	mov	lr, r3
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	ldrb	ip, [r3]	@ zero_extendqisi2
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, ip
	mov	r1, lr
	bl	GARLIC_printchar
	ldr	r3, .L23
	ldr	r3, [r3]
	lsr	r2, r3, #1
	ldr	r3, [sp, #16]
	cmp	r2, r3
	bls	.L20
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #1
	str	r2, [r3]
	b	.L21
.L20:
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mvn	r2, #0
	str	r2, [r3]
.L21:
	ldr	r1, .L23+12
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, [sp, #20]
	add	r3, r3, #1
	str	r3, [sp, #20]
.L19:
	ldr	r3, .L23+16
	ldr	r3, [r3]
	ldr	r2, [sp, #20]
	cmp	r2, r3
	bcc	.L22
	nop
	add	sp, sp, #28
	@ sp needed
	ldr	pc, [sp], #4
.L24:
	.align	2
.L23:
	.word	labx
	.word	laby
	.word	lab
	.word	chars
	.word	nchars
	.size	init_chars, .-init_chars
	.align	2
	.global	init_puppets
	.syntax unified
	.arm
	.fpu softvfp
	.type	init_puppets, %function
init_puppets:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	sub	sp, sp, #8
	mov	r3, #0
	str	r3, [sp, #4]
	b	.L26
.L27:
	ldr	r3, [sp, #4]
	and	r3, r3, #255
	add	r3, r3, #33
	and	r0, r3, #255
	ldr	r1, .L28
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	mov	r2, r0
	strb	r2, [r3]
	ldr	r1, [sp, #4]
	ldr	r0, .L28
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #12
	str	r1, [r3]
	ldr	r1, .L28
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #16
	mov	r2, #0
	str	r2, [r3]
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	str	r3, [sp, #4]
.L26:
	ldr	r2, [sp, #4]
	ldr	r3, .L28+4
	ldr	r3, [r3]
	cmp	r2, r3
	bcc	.L27
	nop
	add	sp, sp, #8
	@ sp needed
	bx	lr
.L29:
	.align	2
.L28:
	.word	chars
	.word	nchars
	.size	init_puppets, .-init_puppets
	.align	2
	.global	update_score
	.syntax unified
	.arm
	.fpu softvfp
	.type	update_score, %function
update_score:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #28
	str	r0, [sp, #4]
	ldr	r1, .L34
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #16
	ldr	r3, [r3]
	str	r3, [sp, #20]
	ldr	r3, [sp, #20]
	cmp	r3, #9
	bls	.L31
	add	r3, sp, #12
	add	r2, sp, #16
	mov	r1, #10
	ldr	r0, [sp, #20]
	bl	GARLIC_divmod
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, #2
	mov	ip, r3
	ldr	r3, [sp, #16]
	and	r3, r3, #255
	add	r3, r3, #16
	and	r0, r3, #255
	ldr	r1, .L34
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r0
	mov	r1, #22
	mov	r0, ip
	bl	GARLIC_printchar
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, #3
	mov	ip, r3
	ldr	r3, [sp, #12]
	and	r3, r3, #255
	add	r3, r3, #16
	and	r0, r3, #255
	ldr	r1, .L34
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r0
	mov	r1, #22
	mov	r0, ip
	bl	GARLIC_printchar
	b	.L33
.L31:
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #1
	add	r3, r3, r2
	lsl	r3, r3, #1
	add	r3, r3, #3
	mov	ip, r3
	ldr	r3, [sp, #20]
	and	r3, r3, #255
	add	r3, r3, #16
	and	r0, r3, #255
	ldr	r1, .L34
	ldr	r2, [sp, #4]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r0
	mov	r1, #22
	mov	r0, ip
	bl	GARLIC_printchar
.L33:
	nop
	add	sp, sp, #28
	@ sp needed
	ldr	pc, [sp], #4
.L35:
	.align	2
.L34:
	.word	chars
	.size	update_score, .-update_score
	.align	2
	.global	mov_chars
	.syntax unified
	.arm
	.fpu softvfp
	.type	mov_chars, %function
mov_chars:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #28
	mov	r3, #0
	str	r3, [sp, #16]
	mov	r3, #0
	str	r3, [sp, #20]
	b	.L37
.L50:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldr	r1, [r3]
	ldr	r0, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	add	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r1, [r3]
	ldr	r0, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #24
	ldr	r3, [r3]
	add	r3, r1, r3
	str	r3, [sp, #8]
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	mov	r3, sp
	add	r2, sp, #4
	mov	r1, #4
	bl	GARLIC_divmod
	ldr	r3, [sp]
	cmp	r3, #3
	beq	.L38
	ldr	r2, .L51+4
	ldr	r3, [sp, #8]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #98
	bne	.L39
.L38:
	mov	r3, #0
	str	r3, [sp, #16]
	bl	GARLIC_random
	mov	r3, r0
	mov	r0, r3
	mov	r3, sp
	add	r2, sp, #4
	mov	r1, #4
	bl	GARLIC_divmod
.L46:
	ldr	r3, [sp]
	cmp	r3, #3
	ldrls	pc, [pc, r3, asl #2]
	b	.L40
.L42:
	.word	.L41
	.word	.L43
	.word	.L44
	.word	.L45
.L41:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #1
	str	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #0
	str	r2, [r3]
	b	.L40
.L43:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #0
	str	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #1
	str	r2, [r3]
	b	.L40
.L44:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mvn	r2, #0
	str	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mov	r2, #0
	str	r2, [r3]
	b	.L40
.L45:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #20
	mov	r2, #0
	str	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #24
	mvn	r2, #0
	str	r2, [r3]
	nop
.L40:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldr	r1, [r3]
	ldr	r0, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #20
	ldr	r3, [r3]
	add	r3, r1, r3
	str	r3, [sp, #12]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r1, [r3]
	ldr	r0, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #24
	ldr	r3, [r3]
	add	r3, r1, r3
	str	r3, [sp, #8]
	ldr	r3, [sp]
	add	r3, r3, #1
	and	r3, r3, #3
	str	r3, [sp]
	ldr	r3, [sp, #16]
	add	r3, r3, #1
	str	r3, [sp, #16]
	ldr	r3, [sp, #16]
	cmp	r3, #3
	bhi	.L39
	ldr	r2, .L51+4
	ldr	r3, [sp, #8]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #98
	beq	.L46
.L39:
	ldr	r2, .L51+4
	ldr	r3, [sp, #8]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #112
	beq	.L47
	ldr	r2, .L51+4
	ldr	r3, [sp, #8]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #102
	bne	.L48
.L47:
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldr	r3, [r3]
	mov	r0, r3
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r3, [r3]
	add	r3, r3, #4
	mov	r1, r3
	mov	r3, #0
	mov	r2, #0
	bl	GARLIC_printchar
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r1, [r3]
	ldr	r0, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #4
	ldr	r3, [r3]
	ldr	r0, .L51+4
	lsl	r2, r1, #5
	add	r2, r0, r2
	add	r3, r2, r3
	mov	r2, #102
	strb	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldr	r2, [sp, #12]
	str	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r2, [sp, #8]
	str	r2, [r3]
	ldr	r2, .L51+4
	ldr	r3, [sp, #8]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	ldrb	r3, [r3]	@ zero_extendqisi2
	cmp	r3, #112
	bne	.L49
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #16
	ldr	r3, [r3]
	add	r1, r3, #1
	ldr	r0, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r0, r3
	add	r3, r3, #16
	str	r1, [r3]
	ldr	r0, [sp, #20]
	bl	update_score
	ldr	r3, .L51+8
	ldr	r3, [r3]
	sub	r3, r3, #1
	ldr	r2, .L51+8
	str	r3, [r2]
.L49:
	ldr	r2, .L51+4
	ldr	r3, [sp, #8]
	lsl	r3, r3, #5
	add	r2, r2, r3
	ldr	r3, [sp, #12]
	add	r3, r2, r3
	mov	r2, #98
	strb	r2, [r3]
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #4
	ldr	r3, [r3]
	mov	ip, r3
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #8
	ldr	r3, [r3]
	add	r3, r3, #4
	mov	lr, r3
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	ldrb	r0, [r3]	@ zero_extendqisi2
	ldr	r1, .L51
	ldr	r2, [sp, #20]
	mov	r3, r2
	lsl	r3, r3, #3
	sub	r3, r3, r2
	lsl	r3, r3, #2
	add	r3, r1, r3
	add	r3, r3, #12
	ldr	r3, [r3]
	mov	r2, r0
	mov	r1, lr
	mov	r0, ip
	bl	GARLIC_printchar
.L48:
	ldr	r3, [sp, #20]
	add	r3, r3, #1
	str	r3, [sp, #20]
.L37:
	ldr	r3, .L51+12
	ldr	r3, [r3]
	ldr	r2, [sp, #20]
	cmp	r2, r3
	bcc	.L50
	nop
	add	sp, sp, #28
	@ sp needed
	ldr	pc, [sp], #4
.L52:
	.align	2
.L51:
	.word	chars
	.word	lab
	.word	points
	.word	nchars
	.size	mov_chars, .-mov_chars
	.section	.rodata
	.align	2
.LC0:
	.ascii	"-- Programa LABE  -  PID %2(%d) %0--\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #12
	str	r0, [sp, #4]
	ldr	r3, [sp, #4]
	cmp	r3, #0
	bge	.L54
	mov	r3, #0
	str	r3, [sp, #4]
.L54:
	ldr	r3, [sp, #4]
	cmp	r3, #3
	ble	.L55
	mov	r3, #3
	str	r3, [sp, #4]
.L55:
	bl	GARLIC_clear
	bl	GARLIC_pid
	mov	r3, r0
	mov	r1, r3
	ldr	r0, .L58
	bl	GARLIC_printf
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	mov	r2, r3
	ldr	r3, .L58+4
	str	r2, [r3]
	ldr	r3, .L58+4
	ldr	r3, [r3]
	lsl	r3, r3, #3
	ldr	r2, .L58+8
	str	r3, [r2]
	ldr	r3, .L58+12
	mov	r2, #16
	str	r2, [r3]
	bl	init_puppets
	bl	init_lab
	bl	init_chars
.L56:
	bl	mov_chars
	mov	r0, #0
	bl	GARLIC_delay
	ldr	r3, .L58+16
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L56
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #12
	@ sp needed
	ldr	pc, [sp], #4
.L59:
	.align	2
.L58:
	.word	.LC0
	.word	nchars
	.word	labx
	.word	laby
	.word	points
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
