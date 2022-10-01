	.arch armv5te
	.eabi_attribute 23, 1
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"PRNT.c"
	.global	numeros
	.section	.rodata
	.align	2
	.type	numeros, %object
	.size	numeros, 160
numeros:
	.word	0
	.word	3
	.word	5
	.word	7
	.word	11
	.word	17
	.word	23
	.word	37
	.word	127
	.word	227
	.word	233
	.word	257
	.word	1019
	.word	2063
	.word	3001
	.word	4073
	.word	15099
	.word	26067
	.word	37109
	.word	68139
	.word	481021
	.word	573949
	.word	721905
	.word	951063
	.word	1048576
	.word	2131331
	.word	3910491
	.word	5110611
	.word	10631069
	.word	16777216
	.word	18710911
	.word	20931097
	.word	268435456
	.word	471103972
	.word	631297553
	.word	825266928
	.word	1153631781
	.word	-1415647083
	.word	-1167743450
	.word	-1
	.global	frases
	.align	2
.LC0:
	.ascii	"Por fin lleg\363. Salimos en seguida para Carmona.\012"
	.ascii	"\000"
	.align	2
.LC1:
	.ascii	"El chofer alzaba una ceja, pisaba el acelerador y d"
	.ascii	"ec\355a, \000"
	.align	2
.LC2:
	.ascii	"volviendose a medias hacia nosotras:\012\000"
	.align	2
.LC3:
	.ascii	"\011-Podridita que est\341 la carretera.\012\000"
	.align	2
.LC4:
	.ascii	"Me preguntaba Mrs. Adams y yo le traducia: \000"
	.align	2
.LC5:
	.ascii	"<<La carretera, que esta podrida.>> \000"
	.align	2
.LC6:
	.ascii	"Ella miraba por un lado y hacia los comentarios mas"
	.ascii	" raros. \000"
	.align	2
.LC7:
	.ascii	"\277Como puede pudrirse una carretera?\012\000"
	.align	2
.LC8:
	.ascii	"Es Carmona una ciudad toda murallas y tuneles, la m"
	.ascii	"as fuerte de Andalucia en los tiempos de Jul\000"
	.align	2
.LC9:
	.ascii	"io Cesar. Y fuimos directamente a la ne-\012cropoli"
	.ascii	"s. \000"
	.align	2
.LC10:
	.ascii	"Un chico de aire avispado fue a avisar al guardia, "
	.ascii	"que\000"
	.align	2
.LC11:
	.ascii	" era un hombre flaco, alto, sin una onza de grasa, "
	.ascii	"\000"
	.align	2
.LC12:
	.ascii	"con el perfil de una medalla romana. \000"
	.align	2
.LC13:
	.ascii	"Aparentaba cincuenta y cinco a\361os. \000"
	.align	2
.LC14:
	.ascii	"<<A la paz de Dios>>, \000"
	.align	2
.LC15:
	.ascii	"dijo cuando llego.\012\000"
	.align	2
	.type	frases, %object
	.size	frases, 64
frases:
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
	.word	.LC12
	.word	.LC13
	.word	.LC14
	.word	.LC15
	.align	2
.LC16:
	.ascii	"-- Programa PRNT  -  PID (%d) --\012\000"
	.align	2
.LC17:
	.ascii	"\012Prueba juego de caracteres:\012\000"
	.align	2
.LC18:
	.ascii	"%c\000"
	.align	2
.LC19:
	.ascii	"\012\012Prueba numeros:\012\000"
	.align	2
.LC20:
	.ascii	"%d (0x%x)\011\000"
	.align	2
.LC21:
	.ascii	"\012\000"
	.align	2
.LC22:
	.ascii	"\012\012Prueba frases:\012\000"
	.align	2
.LC23:
	.ascii	"%s\000"
	.align	2
.LC24:
	.ascii	"\012\012Pruebas mixtas::\012\000"
	.align	2
.LC25:
	.ascii	"string%%char\000"
	.align	2
.LC26:
	.ascii	"\012%%a%%\011prueba %s: %c%d\012%%\000"
	.align	2
.LC27:
	.ascii	"b%%\011aleatorio decimal: %d%%\012\011\011  hexadec"
	.ascii	"imal: 0x%x%%\012\000"
	.align	2
.LC28:
	.ascii	"%%c%%\011codigos de formato reconocidos: %%c %%d %%"
	.ascii	"x %%s\012\000"
	.align	2
.LC29:
	.ascii	"%%d%%\011codigos de formato no reconocidos: %%i %%f"
	.ascii	" %%e %%g %%p\012\012\000"
	.text
	.align	2
	.global	_start
	.syntax unified
	.arm
	.fpu softvfp
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	sub	sp, sp, #20
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
	ldr	r0, .L13
	bl	GARLIC_printf
	ldr	r0, .L13+4
	bl	GARLIC_printf
	mov	r3, #32
	str	r3, [sp, #12]
	b	.L4
.L5:
	ldr	r1, [sp, #12]
	ldr	r0, .L13+8
	bl	GARLIC_printf
	ldr	r3, [sp, #12]
	add	r3, r3, #1
	str	r3, [sp, #12]
.L4:
	ldr	r3, [sp, #12]
	cmp	r3, #127
	bls	.L5
	ldr	r0, .L13+12
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #12]
	b	.L6
.L9:
	mov	r3, #0
	str	r3, [sp, #8]
	b	.L7
.L8:
	ldr	r3, [sp, #12]
	lsl	r2, r3, #2
	ldr	r3, [sp, #8]
	add	r3, r2, r3
	ldr	r2, .L13+16
	ldr	r1, [r2, r3, lsl #2]
	ldr	r3, [sp, #12]
	lsl	r2, r3, #2
	ldr	r3, [sp, #8]
	add	r3, r2, r3
	ldr	r2, .L13+16
	ldr	r3, [r2, r3, lsl #2]
	mov	r2, r3
	ldr	r0, .L13+20
	bl	GARLIC_printf
	ldr	r3, [sp, #8]
	add	r3, r3, #1
	str	r3, [sp, #8]
.L7:
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	mov	r2, r3
	ldr	r3, [sp, #8]
	cmp	r2, r3
	bhi	.L8
	ldr	r0, .L13+24
	bl	GARLIC_printf
	ldr	r3, [sp, #12]
	add	r3, r3, #1
	str	r3, [sp, #12]
.L6:
	ldr	r3, [sp, #12]
	cmp	r3, #9
	bls	.L9
	ldr	r0, .L13+28
	bl	GARLIC_printf
	mov	r3, #0
	str	r3, [sp, #12]
	b	.L10
.L11:
	ldr	r2, .L13+32
	ldr	r3, [sp, #12]
	ldr	r3, [r2, r3, lsl #2]
	mov	r1, r3
	ldr	r0, .L13+36
	bl	GARLIC_printf
	ldr	r3, [sp, #12]
	add	r3, r3, #1
	str	r3, [sp, #12]
.L10:
	ldr	r3, [sp, #4]
	add	r3, r3, #1
	lsl	r3, r3, #2
	mov	r2, r3
	ldr	r3, [sp, #12]
	cmp	r2, r3
	bhi	.L11
	ldr	r0, .L13+40
	bl	GARLIC_printf
	mov	r3, #0
	mov	r2, #64
	ldr	r1, .L13+44
	ldr	r0, .L13+48
	bl	GARLIC_printf
	bl	GARLIC_random
	mov	r3, r0
	str	r3, [sp, #12]
	ldr	r2, [sp, #12]
	ldr	r1, [sp, #12]
	ldr	r0, .L13+52
	bl	GARLIC_printf
	mov	r2, #0
	ldr	r1, [sp, #12]
	ldr	r0, .L13+56
	bl	GARLIC_printf
	ldr	r0, .L13+60
	bl	GARLIC_printf
	mov	r3, #0
	mov	r0, r3
	add	sp, sp, #20
	@ sp needed
	ldr	pc, [sp], #4
.L14:
	.align	2
.L13:
	.word	.LC16
	.word	.LC17
	.word	.LC18
	.word	.LC19
	.word	numeros
	.word	.LC20
	.word	.LC21
	.word	.LC22
	.word	frases
	.word	.LC23
	.word	.LC24
	.word	.LC25
	.word	.LC26
	.word	.LC27
	.word	.LC28
	.word	.LC29
	.size	_start, .-_start
	.ident	"GCC: (devkitARM release 46) 6.3.0"
