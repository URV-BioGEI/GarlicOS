@;==============================================================================
@;
@;	"garlic_itcm_mem.s":	código de rutinas de soporte a la carga de
@;							programas en memoria (version 2.0)
@;
@;==============================================================================

NUM_FRANJAS = 768
INI_MEM_PROC = 0x01002000


.section .dtcm,"wa",%progbits
	.align 2

	.global _gm_zocMem
_gm_zocMem:	.space NUM_FRANJAS			@; vector de ocupación de franjas mem.


.section .itcm,"ax",%progbits

	.arm
	.align 2


	.global _gm_reubicar
	@; Rutina de soporte a _gm_cargarPrograma(), que interpreta los 'relocs'
	@; de un fichero ELF, contenido en un buffer *fileBuf, y ajustar las
	@; direcciones de memoria correspondientes a las referencias de tipo
	@; R_ARM_ABS32, a partir de las direcciones de memoria destino de código
	@; (dest_code) y datos (dest_data), y según el valor de las direcciones de
	@; las referencias a reubicar y de las direcciones de inicio de los
	@; segmentos de código (pAddr_code) y datos (pAddr_data)
	@;Parámetros:
	@; R0: dirección inicial del buffer de fichero (char *fileBuf)
	@; R1: dirección de inicio de segmento de código (unsigned int pAddr_code)
	@; R2: dirección de destino en la memoria (unsigned int *dest_code)
	@; R3: dirección de inicio de segmento de datos (unsigned int pAddr_data)
	@; (pila): dirección de destino en la memoria (unsigned int *dest_data)
	@;Resultado:
	@; cambio de las direcciones de memoria que se tienen que ajustar
_gm_reubicar:
	push {r0-r12,lr}
		ldr r4, [SP, #15]
		ldr r11, [r0, #32]	@; e_shoff offset de la tabla de secciones
		ldrh r5, [r0, #48]	@; e_shnum numero de entradas 
		mov r8, r0			@; muevo el buffer a r8
		mov r9, r1			@; muevo el inicio de segmento a r9
		mov r10, r2			@; muevo el destino en la memoria a r10
		mov r6, r3
		add r11, #4
		cmp r6, #0xFFFFFFFF
		beq .LBuclesecciones
		b .LDosSegmentos
		
	@;1 segmento
	.LBuclesecciones:
		cmp r5, #0			@; compara numero de entradas con contador 
		beq .LFin
		sub r5, #1			@; añade uno al contador
		ldr r0, [r8, r11]	@; carga el tipo de la sección
		cmp r0, #9
		beq .LTipoSeleccion
		beq .LTipoSeleccion
		add r11, #40
		b .LBuclesecciones
	.LTipoSeleccion:
		add r11, #12		@; sh_offset offset del segmento
		ldr r7, [r8, r11]	@; valor del offset cargado en r7
		add r11, #4			
		ldr r0, [r8, r11]	@; en r0 tenemos el size de la sección (serán todo reubicadores)
		add r11, #16
		ldr r1, [r8, r11]	@; en r1 tenemos el tamaño de cada reubicador
		ldr r2, =quo
		ldr r3, =res
		bl _ga_divmod		@; en r2 tenemos el numero de reubicadores
		ldr r2, [r2]
		ldr r3, [r3]
	.LBucleReubicadores:
		cmp r2, #0
		beq .Laddr11
		sub r2, #1
		ldr r1, [r8, r7]	@; guardo en r1 el valor del primer reubicador, el offset
		add r7, #4
		ldr r0, [r8, r7]	@; guardo en r0 el tipo de reubicador
		and r0, #0xFF
		cmp r0, #2
		beq .Lreubicar
		beq .Lreubicar
		b .Ladd
		
	.Lreubicar:
		add r1, r10
		sub r1, r9			@; en r1 tengo la direccion de reubicación
		ldr r12, [r1]		@; obtengo el contenido de la dirección	
		add r12, r10
		sub r12, r9
		str r12, [r1]
		b .Ladd
		
	.Ladd:
		add r7,#4
		b .LBucleReubicadores
	.Laddr11:
		add r11,#8
		b .LBuclesecciones
	
	@; si hay dos segmentos (igual salvo la reubicacion)
	.LDosSegmentos:
		cmp r5, #0			@; compara numero de entradas con contador 
		beq .LFin
		sub r5, #1			@; añade uno al contador
		ldr r0, [r8, r11]	@; carga el tipo de la sección
		cmp r0, #9
		beq .LTipoSeleccionD
		beq .LTipoSeleccionD
		add r11, #40
		b .LDosSegmentos
	.LTipoSeleccionD:
		add r11, #12		@; sh_offset offset del segmento
		ldr r7, [r8, r11]	@; valor del offset cargado en r7
		add r11, #4			
		ldr r0, [r8, r11]	@; en r0 tenemos el size de la sección (serán todo reubicadores)
		add r11, #16
		ldr r1, [r8, r11]	@; en r1 tenemos el tamaño de cada reubicador
		ldr r2, =quo
		ldr r3, =res
		bl _ga_divmod		@; en r2 tenemos el numero de reubicadores
		ldr r2, [r2]
		ldr r3, [r3]
	.LBucleReubicadoresD:
		cmp r2, #0
		beq .Laddr11D
		sub r2, #1
		ldr r1, [r8, r7]	@; guardo en r1 el valor del primer reubicador, el offset
		add r7, #4
		ldr r0, [r8, r7]	@; guardo en r0 el tipo de reubicador
		and r0, #0xFF
		cmp r0, #2
		beq .LreubicarD
		beq .LreubicarD
		b .LaddD
		
	.LreubicarD:
		add r1, r10
		sub r1, r9			@; en r1 tengo la direccion de reubicación
		ldr r12, [r1]		@; obtengo el contenido de la dirección	
		cmp r12, r6
		bge .LSegundoSegmento
		add r12, r10
		sub r12, r9
		str r12, [r1]
		b .LaddD
		
	.LSegundoSegmento:
		add r12, r4
		sub r12, r6
		str r12, [r1]
		b .LaddD
		
	.LaddD:
		add r7,#4
		b .LBucleReubicadoresD
	.Laddr11D:
		add r11,#8
		b .LDosSegmentos
	.LFin:
	
	pop {r0-r12,pc}


	.global _gm_reservarMem
	@; Rutina para reservar un conjunto de franjas de memoria libres
	@; consecutivas que proporcionen un espacio suficiente para albergar
	@; el tamaño de un segmento de código o datos del proceso (según indique
	@; tipo_seg), asignado al número de zócalo que se pasa por parámetro;
	@; también se encargará de invocar a la rutina _gm_pintarFranjas(), para
	@; representar gráficamente la ocupación de la memoria de procesos;
	@; la rutina devuelve la primera dirección del espacio reservado; 
	@; en el caso de que no quede un espacio de memoria consecutivo del
	@; tamaño requerido, devuelve cero.
	@;Parámetros:
	@;	R0: el número de zócalo que reserva la memoria
	@;	R1: el tamaño en bytes que se quiere reservar
	@;	R2: el tipo de segmento reservado (0 -> código, 1 -> datos)
	@;Resultado:
	@;	R0: dirección inicial de memoria reservada (0 si no es posible)
_gm_reservarMem:
	push {r1-r12,lr}
		ldr r8, =_gm_zocMem @; accede al vector
		mov r9, r0			@;recoloco los parametros
		mov r10, r1
		mov r11, r2
		mov r0, r1		 	@;preparo para hacer división de cuantas franjas necesito 
		mov r1, #32
		ldr r2, =quo
		ldr r3, =res
		bl _ga_divmod
		ldr r0, [r2]
		ldr r1, [r3]
		mov r4, #0			@;contador de franjas a 0
		mov r5, #0			@; contador de franjas seguidas correctas a 0
		cmp r1, #0
		beq .Lnohayresto
		
		add r0, #1
	.Lnohayresto:
		cmp r5, r0			@; compara si ya tengo suficientes libres seguidos
		beq .Lsuficientes
		ldr r12, =NUM_FRANJAS
		cmp r4, r12
		beq .Lnoespacio
		ldrb r2, [r8, r4]
		cmp r2, #0
		beq .Llibre
		bne .Lnolibre
		
	.Llibre:
		add r5, #1
		add r4, #1
		b .Lnohayresto
	.Lnolibre:
		mov r5, #0
		add r4, #1
		b .Lnohayresto
		
	.Lsuficientes:
		sub r4, r5
		mov r10, r4
		mov r6, #0
		mov r1, #32
		ldr r7, =INI_MEM_PROC
		mla r0, r4, r1, r7
	.Lsuficientes2:
		cmp	r6, r5
		beq .Lreservado
		strb r9, [r8, r4]
		add r4, #1
		add r6, #1
		b .Lsuficientes2
		
	.Lnoespacio:
		mov r0, #0
		b .Lfin
	.Lreservado:
		push {r0-r3}
		mov r0, r9
		mov r3, r11
		mov r1, r10
		mov r2, r5
		bl _gm_pintarFranjas
		pop {r0-r3}
	pop {r1-r12, pc}


	.global _gm_liberarMem
	@; Rutina para liberar todas las franjas de memoria asignadas al proceso
	@; del zócalo indicado por parámetro; también se encargará de invocar a la
	@; rutina _gm_pintarFranjas(), para actualizar la representación gráfica
	@; de la ocupación de la memoria de procesos.
	@;Parámetros:
	@;	R0: el número de zócalo que libera la memoria
_gm_liberarMem:
	
	push {r0-r12, lr}
		ldr r1, =_gm_zocMem
		mov r2, #0 
		mov r10, #0

	.Lbucle:
		ldr r5, =NUM_FRANJAS
		cmp r2, r5
		beq .Lfin
		ldrb r3, [r1, r2]
		cmp r3, r0
		beq .Leliminar1
		add r2, #1
		b .Lbucle
		
		
	.Leliminar1:
		mov r9, r2		@; indice inicial de las franjas
	.Leliminar:
		add r10, #1
		mov r4, #0
		strb r4, [r1, r2]
		add r2, #1
		ldrb r3, [r1, r2]
		cmp r3, r0
		beq .Leliminar
		add r2, #1
		bne .Lquitarfranjas
	.Lquitarfranjas:
		push {r0-r3}
		mov r0, r4
		mov r1, r9
		mov r2, r10
		bl _gm_pintarFranjas
		pop {r0-r3}
		b .Lbucle
	.Lfin:
	pop {r0-r12, pc}


	.global _gm_pintarFranjas
	@; Rutina para para pintar las franjas verticales correspondientes a un
	@; conjunto de franjas consecutivas de memoria asignadas a un segmento
	@; (de código o datos) del zócalo indicado por parámetro.
	@;Parámetros:
	@;	R0: el número de zócalo que reserva la memoria (0 para borrar)
	@;	R1: el índice inicial de las franjas
	@;	R2: el número de franjas a pintar
	@;	R3: el tipo de segmento reservado (0 -> código, 1 -> datos)
_gm_pintarFranjas:
	push {r0-r12,lr}
	
		mov r4, #0x06200000
		add r5, r4, #0x00004000
		add r6, r5, #0x8000			@;base de baldosas para gestion de memoria	 
		ldr r4, =_gs_colZoc
		add r9, r4, r0				@;seleccion del color
		ldrb r10, [r9]
		mov r11, #0	
		push {r0-r3}
		mov r0, r1
		mov r1, #8
		ldr r2, =quo
		ldr r3, =res
		bl _ga_divmod
		ldr r8, [r2]
		ldr r5, [r3]
		pop {r0-r3}
		add r11, r5
		mov r7, #64
		mul r8, r7
		add r8, r5
		mov r5, #0
	.Lbuclesico:
		cmp r11, #8
		beq .Lnuevabaldosa
		mov r7, r8
		add r7, #16
		mov r12, #0
	.Lbuclesico2:
		cmp r12, #4
		beq .Lfuerabuclesico2
		cmp r3, #0
		bne .Ldatos
		ldrh r0, [r6, r7]
		mov r0, r0, lsl #8
		add r0, r10
		strh r0, [r6, r7]
		add r7, #8
		add r12, #1
		b .Lbuclesico2
	.Ldatos: 
		cmp r5, #0
		bne .Luno
		ldrh r0, [r6, r7]
		mov r0, r0, lsl #8
		add r0, r10
		strh r0, [r6, r7]
		add r7, #8
		add r12, #1
		mov r5, #1
		b .Lbuclesico2
	.Luno:
		ldrh r0, [r6, r7]
		mov r0, r0, lsl #8
		add r0, #0x00
		strh r0, [r6, r7]
		add r7, #8
		add r12, #1
		mov r5, #0
		b .Lbuclesico2
	.Lfuerabuclesico2:
		add r8, #1
		add r11, #1
		sub r2, #1
		cmp r5, #0
		beq .Lponauno
		mov r5, #0
		cmp r2, #0
		bne .Lbuclesico
		beq .Lfinpintar
	.Lponauno:
		mov r5, #1
		cmp r2, #0
		bne .Lbuclesico
		beq .Lfinpintar
		
	.Lnuevabaldosa: 
		add r8, #56
		mov r11, #0
		b .Lbuclesico
	.Lfinpintar:
	pop {r0-r12,pc}



	.global _gm_rsiTIMER1
	@; Rutina de Servicio de Interrupción (RSI) para actualizar la representa-
	@; ción de la pila y el estado de los procesos activos.
_gm_rsiTIMER1:
	push {r0-r12,lr}
		ldr r0, =_gd_pcbs
		mov r2, #512
		mov r3, #1
		mov r4, #24
		ldr r1, =_gd_stacks
		
	.Lbuclersi1:
		cmp r3, #16
		beq .Lfinrsi1
		mul r7, r3, r2
		sub r7, #4
		add r11, r1, r7
		mla r6, r4, r3, r0
		ldr r12, [r6]
		cmp r12, #0
		beq .Lnext
		add r6, #8
		ldr r12, [r6]
		mov r5, #0
	.Lbuclersi2:
		cmp r11, r12
		beq .Lsal
		add r12, #4
		add r5, #4
		b .Lbuclersi2
	
	.Lsal:
		mov r7, #0x06200000
		mov r6, #2
		add r6, r3
		add r7, r6, lsl #6
		mov r9, #27
		add r7, r9, lsl #2
		mov r10, #119
	.Lbuclersi3:
		cmp r5, #0
		ble .Lsal2
		add r10, #1
		sub r5, #32
		cmp r10, #127
		beq .Lsal2
		b .Lbuclersi3
	.Lsal2:	
		add r7, #3
		strh r10, [r7]
		mov r10, #119
	.Lbuclersi4:
		cmp r5, #0
		ble .Lsal3
		add r10, #1
		sub r5, #32
		cmp r10, #127
		beq .Lsal3
		b .Lbuclersi4
	.Lsal3:
		add r7, #1
		strh r10, [r7]
		add r3, #1
		b .Lbuclersi1
		
	.Lnext:
		add r3, #1
		b .Lbuclersi1
	.Lfinrsi1:
	
	@; parte de las letras
		ldr r0, =_gd_pidz
		ldr r0, [r0]
		and r0, #0xF
		cmp r0, #0
		beq .LrunningSO
		mov r7, #0x06200000
		mov r6, #2
		add r6, r0
		add r7, r6, lsl #6
		mov r9, #29
		add r7, r9, lsl #2
		mov r0, #50
		strh r0, [r7]
	.LrunningSO:
	pop {r0-r12, pc}


.end



