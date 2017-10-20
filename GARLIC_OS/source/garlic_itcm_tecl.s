@;==============================================================================
@;
@;	"garlic_itcm_tecl.s":	código de las rutinas del teclado virtual
@;	Programador: Aleix Mariné
@;==============================================================================

.section .itcm,"ax",%progbits

	.arm
	.align 2

	.global _gt_getstring
	@; R0: string -> dirección base del vector de caracteres (bytes)
	@; R1: max_char -> número máximo de caracteres del vector
	@; R2: zocalo -> número de zócalo del proceso invocador
	@; Return
	@; R0: int -> Número de carácteres leídos
	@;• si la interfaz de teclado está desactivada (oculta), mostrarla
	@;	(ver punto 8) y activar la RSI de teclado (ver punto 9).
	@;• añadir el número de zócalo sobre un vector global
	@;_gd_kbwait[], que se comportará como una cola en la cual
	@;estarán registrados los procesos que esperan la entrada de
	@;un string por teclado,
	@;• esperar a que el bit de una variable global _gd_kbsignal,
	@;correspondiente al número de zócalo indicado, se ponga a 1,
	@;• poner el bit anterior a cero, copiar el string leído sobre el
	@;vector que se ha pasado por parámetro, filtrando el número
	@;total de caracteres y añadiendo el centinela, y devolviendo
	@;el número total de caracteres leídos (excluido el centinela).
_gt_getstring:
	push {r1-r8, lr}
	
	pop {r1-r8, pc}

.end

