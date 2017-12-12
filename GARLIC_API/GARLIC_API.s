@;==============================================================================
@;
@;	"GARLIC_API.s":	implementación de funciones del API del sistema operativo
@;					GARLIC 2.0 (descripción de funciones en "GARLIC_API.h")
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


	.global GARLIC_printchar
GARLIC_printchar:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #16]		@; llamada indirecta a rutina 0x04
	pop {r4, pc}

	.global GARLIC_printmat
GARLIC_printmat:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #20]		@; llamada indirecta a rutina 0x05
	pop {r4, pc}

	.global GARLIC_delay
GARLIC_delay:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #24]		@; llamada indirecta a rutina 0x06
	pop {r4, pc}

	.global GARLIC_clear
GARLIC_clear:
	push {r4, lr}
	mov r4, #0
	mov lr, pc
	ldr pc, [r4, #28]		@; llamada indirecta a rutina 0x07
	pop {r4, pc}


.end
