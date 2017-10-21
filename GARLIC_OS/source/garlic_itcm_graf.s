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
	push {r3-r6, lr}
	@; Cálculo desplazamiento ventana V: calculo desplazamiento columnas + cálculo desplazamiento filas
	@; Cálculo desplazamiento de columnas: VCOLS*(v%PPART)
	
	and r3, r0, #L2_PPART	@; r3= v%PPART
	mov r5, #VCOLS
	mul r4, r5, r3			@; r4= VCOLS*(v%PPART)
	
	@; Cálculo desplazamiento de filas: (v/PPART)*VFILS*PCOLS
	mov r5, #VFILS
	lsr r6, r0, #L2_PPART	@; r6= v/PPART : shift a la derecha de V
	mul r3, r6, r5			@; r3= (v/PPART)*VFILS
	mov r6, #PCOLS
	mla r5, r3, r6, r4		@; Desplazamiento ventana v: r5= (v/PPART)*VFILS*PCOLS + VCOLS*(v%PPART)
	
	@; Cálculo desplazamiento de fila actual f en ventana v: desplazamiento ventana v + desplazamiento f
	@; Cálculo desplazamiento de f: f*PCOLS
	
	mla r4,	r1, r6, r5		@; r4= f*PCOLS + (v/PPART)*VFILS*PCOLS + VCOLS*(v%PPART)
	
	@; Sumar desplazamiento fila actual en ventana a la dirección del mapa de bg2
	ldr r3, =bg2map			@; Apuntamos a la variable que contiene la dirección del mapa de bg2
	ldr r3, [r3]			@; Cargamos la dirección del mapa de bg2
	lsl r4, #1				@; Adaptación del número de baldosas al número de bytes: cada indice de baldosa ocupa 2 bytes (halfword)
	add r3, r4				@; Dirección del mapa de bg + desplazamiento total
	
	ldr r4, =_gd_wbfs		@; Apuntamos a dirección del vector de WBFS
	mov r5, #WBUFS_LEN
	mul r6, r5, r0			@; Desplazamiento necesario para situarnos a la posición del vector correspondiente a nuestra ventana
	add r4, r6				@; Nos situamos en la posición inicial de pChars de nuestra ventana
	add r4, #4				@; Desplazamiento para situarnos a pChars (pControl ocupa 4 bytes)
	
	mov r5, #0				@; Contador de chars añadidos a 0
	@;Bucle para guardar una baldosa en la dirección del mapa indicada
.Lescribir:		
	ldrb r6, [r4, r5]		@; Cargamos codigo ASCII: r6=_gd_wbfs[v].pChars[r5]
	sub r6, #32				@; Pasamos de codigo ASCII a codigo de baldosa
	strh r6, [r3]			@; Guardar codigo de baldosa en la dirección del mapa calculada previamente
	add r5, #1				@; Aumentamos el contador
	add r3, #2				@; Siguiente posición del mapa
	cmp r5, r2				
	blo .Lescribir			@; Si contador<n efectuamos otra iteración
	
	pop {r3-r6, pc}


	.global _gg_desplazar
	@; Rutina para desplazar una posición hacia arriba todas las filas de la
	@; ventana (v), y borrar el contenido de la última fila
	@;Parámetros:
	@;	R0: ventana a desplazar (int v)
_gg_desplazar:
	push {lr}


	pop {pc}


.end

