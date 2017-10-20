@;==============================================================================
@;
@;	"GARLIC_API.s":	implementación de funciones del API del sistema operativo
@;					GARLIC 1.0 (descripción de funciones en "GARLIC_API.h")
@;	
@;	Las funciones que hay en este archivo solamente se encargan de llamar de
@;	forma indirecta a las rutinas del API utilizando su vector de direcciones. 
@;	
@;
@;==============================================================================

.text
	.arm
	.align 2

	.global GARLIC_pid
GARLIC_pid:
	push {r4, lr}
	mov r4, #0				@; vector base de rutinas API de GARLIC
	mov lr, pc				@; guardar dirección de retorno
	ldr pc, [r4]			@; llamada indirecta a rutina 0x00
	pop {r4, pc}

	.global GARLIC_random
GARLIC_random:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #4]		@; llamada indirecta a rutina 0x01
	pop {r4, pc}

	.global GARLIC_divmod
GARLIC_divmod:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #8]		@; llamada indirecta a rutina 0x02
	pop {r4, pc}

	.global GARLIC_printf
GARLIC_printf:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #12]		@; llamada indirecta a rutina 0x03
	pop {r4, pc}
	
	.global GARLIC_getstring
	push {r4, lr}
	mov r4, #0				@; Inicializamos r4
	mov lr, pc				@; Guardamos dirección de retorno de la función del API
	ldr pc, [r4, #16]		@; llamada indirecta a rutina 0x04 del vector de direcciones
	pop {r4, pc}			

.end
