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

.global _gg_escribirCar
_gg_escribirCar:
	push {lr}
	pop {pc}
	
.global _gg_escribirMat
_gg_escribirMat:
	push {lr} 
	pop {pc}
	
@;.global _gs_borrarVentana
@;_gs_borrarVentana:
	@;push {lr}
	@;pop {pc}
	
	.global _gg_desplazar
	@; Rutina para desplazar una posición hacia arriba todas las filas de la
	@; ventana (v), y borrar el contenido de la última fila
	@;Parámetros:
	@;	R0: ventana a desplazar (int v)
_gg_desplazar:
	push {r1-r7,lr}
	@; Cálculo desplazamiento ventana V: calculo desplazamiento columnas + cálculo desplazamiento filas
	@; Cálculo desplazamiento de columnas: VCOLS*(v%PPART)
	
	and r1, r0, #L2_PPART	@; r3= v%PPART
	mov r3, #VCOLS
	mul r2, r3, r1			@; r4= VCOLS*(v%PPART)
	
	@; Cálculo desplazamiento de filas: (v/PPART)*VFILS*PCOLS
	mov r3, #VFILS
	lsr r4, r0, #L2_PPART	@; r6= v/PPART : shift a la derecha de V
	mul r1, r4, r3			@; r3= (v/PPART)*VFILS
	mov r4, #PCOLS
	mla r3, r1, r4, r2		@; Desplazamiento ventana v: r5= (v/PPART)*VFILS*PCOLS + VCOLS*(v%PPART)
	
	@; Sumar desplazamiento a la dirección del mapa de bg2
	ldr r1, =bg2map			@; Apuntamos a la variable que contiene la dirección del mapa de bg2
	ldr r1, [r1]			@; Cargamos la dirección del mapa de bg2
	lsl r3, #1				@; Adaptación del número de baldosas al número de bytes: cada indice de baldosa ocupa 2 bytes (halfword)
	add r1, r3				@; Dirección del mapa de bg + desplazamiento total
	mov r2, r1				@; r1: fila actual ; r2: fila siguiente
	lsl r4, r4, #1			@; Desplazamiento para aumentar una fila
	add r2, r4				@; r2=fila actual+ desp 1 fila
	mov r3, #VFILS			
	
.Ldesp_principio:			@; Bucle inicio recorrido fila
	mov r5, #0			
	mov r6, #VCOLS				
.Ldesp_avanzar:				@; while (0<VCOLS)
	ldrh r7, [r2, r5]		@; r7=sig.fila[r5]
	strh r7, [r1, r5]		@; fila[r5]=r7
	sub r6, #1				@; VCOLS--
	add r5, #2				@; r5++ (se guardan halfwords)
	cmp r6, #0				
	bhi .Ldesp_avanzar	
	
	add r1, r4				@; avanzamos filas
	add r2, r4
	sub r3, #1				@; VFILS--
	cmp r3, #0				
	bhi .Ldesp_principio	@; Si (VFILS>0) Volvemos a cambiar filas 
	sub r1, r4				@; Restablecemos las filas (hemos llegado a la fila final)
	sub r2, r4				
	mov r3, #0				@; r3=' '(Espacio en blanco)
	mov r5, #0				
	mov r6, #VCOLS
.Ldesp_final:				@; Mientras no se llegue al final de la fila se ponen espacios en blanco
	strh r3, [r1, r5]  
	sub r6, #1
	add r5, #2
	cmp r6, #0
	bhi .Ldesp_final
	
	pop {r1-r7,pc}


.end

