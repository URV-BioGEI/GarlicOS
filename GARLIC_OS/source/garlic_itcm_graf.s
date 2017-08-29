@;==============================================================================
@;
@;	"garlic_itcm_graf.s":	código de rutinas de soporte a la gestión de
@;							ventanas gráficas (versión 1.0)
@;
@;==============================================================================

NVENT	= 4					@; número de ventanas totales
PPART	= 2					@; número de ventanas horizontales o verticales
							@; (particiones de pantalla)
L2_PPART = 1				@; log base 2 de PPART

VCOLS	= 32				@; columnas y filas de cualquier ventana
VFILS	= 24
PCOLS	= VCOLS * PPART		@; número de columnas totales (en pantalla)
PFILS	= VFILS * PPART		@; número de filas totales (en pantalla)

WBUFS_LEN = 36				@; longitud de cada buffer de ventana (32+4)

.section .itcm,"ax",%progbits

	.arm
	.align 2


	.global _gg_escribirLinea
	@; Rutina para escribir toda una linea de caracteres almacenada en el
	@; buffer de la ventana especificada;
	@;Parámetros:
	@;	R0: ventana a actualizar (int v)
	@;	R1: fila actual (int f)
	@;	R2: número de caracteres a escribir (int n)
_gg_escribirLinea:
	push {lr}


	pop {pc}


	.global _gg_desplazar
	@; Rutina para desplazar una posición hacia arriba todas las filas de la
	@; ventana (v), y borrar el contenido de la última fila
	@;Parámetros:
	@;	R0: ventana a desplazar (int v)
_gg_desplazar:
	push {lr}


	pop {pc}


.end

