@;==============================================================================
@;
@;	"garlic_itcm_mem.s":	código de rutinas de soporte a la carga de
@;							programas en memoria (version 1.0)
@;
@;==============================================================================

.section .itcm,"ax",%progbits

	.arm
	.align 2


	.global _gm_reubicar
	@; rutina para interpretar los 'relocs' de un fichero ELF y ajustar las
	@; direcciones de memoria correspondientes a las referencias de tipo
	@; R_ARM_ABS32, restando la dirección de inicio de segmento y sumando
	@; la dirección de destino en la memoria;
	@;Parámetros:
	@; R0: dirección inicial del buffer de fichero (char *fileBuf)
	@; R1: dirección de inicio de segmento (unsigned int pAddr)
	@; R2: dirección de destino en la memoria (unsigned int *dest)
	@;Resultado:
	@; cambio de las direcciones de memoria que se tienen que ajustar
_gm_reubicar:
	push {r0-r12,lr}
		ldr r11, [r0, #32]	@; e_shoff offset de la tabla de secciones
		ldrh r5, [r0, #48]	@; e_shnum numero de entradas 
		mov r8, r0			@; muevo el buffer a r8
		mov r9, r1			@; muevo el inicio de segmento a r9
		mov r10, r2			@; muevo el destino en la memoria a r10
		add r11, #4	
		
	.LBuclesecciones:
		cmp r5, #0			@; compara numero de entradas con contador 
		beq .LFinReubicar
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

	.LFinReubicar:
	
	pop {r0-r12,pc}
	
	
		.global _gm_pintaEstado
	@; Rutina de servicio a la RSI para pintar el estado del proceso en pantalla.
	@; R0 = numero de zocalo (fila de texto a modificar)
	@; R1 = estado (0:Run, 1: Blocked, 2: Ready)
_gm_pintaEstado:
	push {r0-r4, lr}
		
		mov r4, #0x06200000  	@; r4 = posición donde empieza la memoria del mapa de baldosas
		add r2, r4, #52			@; r2 = primera posición de la columna de estado
		add r0, #4		 		@; r0 = indice de fila en la que pintar
		
		mov r3, r0, lsl #6	 	@; r3 = indice de para el array en r2
		add r2, r3			 	@; r2 = puntero que apunta a la baldosa de texto del proceso a modificar
		
		@; 0x06200000+0x1B2 -> R azul  (/2 = 217)
		@; 0x06200000+0x139 -> Y blanca (/2 = 156)
		@; 0x06200000+0x122 -> B blanca (/2 = 145)
		
		cmp r1, #0
		beq .LPintaRun
		
		cmp r1, #1
		beq .LPintaBlocked
		
		cmp r1, #2
		beq .LPintaReady
		
	.LPintaRun:
		ldr r3, =178
		strh r3,[r2]
		b .LFinPintarEstado
		
	.LPintaBlocked:
		ldr r3, =34
		strh r3,[r2]
		b .LFinPintarEstado
	
	.LPintaReady:
		ldr r3, =57
		strh r3,[r2]
		
	.LFinPintarEstado:
	
	pop {r0-r4, pc}
	
	.global _gm_borrarPila
	@; Rutina de Servicio para la RSI. Se encarga de borrar la pila una vez no esté asignado el PCB.
	@; r0 = zócalo
_gm_borrarPila:
	push {r0-r5, lr}
	
		mov r4, #0x06200000  	@; r4 = posición donde empieza la memoria del mapa de baldosas
		add r2, r4, #47	 		@; r2 = primera posición de la columna de pila
		add r0, #4		     	@; r0 = indice de fila en la que pintar
		
		mov r3, r0, lsl #6	 	@; r3 = indice de para el array en r2
		add r2, r3			 	@; r2 = puntero que apunta a la baldosa de texto del proceso a modificar
		
		mov r5, #384			@; Baldosa inicial
		strh r5, [r2]
		strh r5, [r2,#2]		@; Pintamos las dos baldosas contiguas
		
	pop {r0-r5, pc}
	
	.global _gm_pintarPila
	@; Rutina de Servicio para la RSI. Se encarga de pintar la parte de la pila ocupada
	@; r0 = zócalo
	@; r1 = nivel de ocupación de la pila
_gm_pintarPila:
	push {r0-r6,lr}
		mov r4, #0x06200000  	@; r4 = posición donde empieza la memoria del mapa de baldosas
		add r2, r4, #47		 	@; r2 = primera posición de la columna de pila
		add r0, #4		     	@; r0 = indice de fila en la que pintar
		
		mov r3, r0, lsl #6	 	@; r3 = indice de para el array en r2
		add r2, r3			 	@; r2 = puntero que apunta a la baldosa de texto del proceso a modificar
		
		
		cmp r1,#9				@; Comparamos con 9 porque la pila se representa en 9 estados
		bge .LElsePila
		
		@; Implicitamente r3 < 9, r2 es un puntero a la baldosa de la izquierda, r1 = nivel de ocupación (1era mitad de la pila)
		add r5, r2, #2			@; r5 = puntero a la baldosa de la derecha (pila zonas altas)
		mov r6, #119
		strh r6, [r5]			@; Ponemos baldosa vacía
		b .LFinPintarPila	
				
	.LElsePila:
		mov r6, #127			@; Baldosa llena
		strh r6, [r2]		
		add r2, #2				@; Ahora r2 es un puntero a la baldosa de la derecha
		sub r1, #8				@; r1 = nivel de ocupación (2da mitad de la pila) 

	.LFinPintarPila:
		add r1, #119			@; r1 = baldosa de ocupación a pintar
		strh r1, [r2]
	
	pop {r0-r6,pc}
			

	.global _gm_rsiTIMER1
	@; Rutina de Servicio de Interrupción (RSI) para actualizar la representa-
	@; ción de la pila y el estado de los procesos activos.
_gm_rsiTIMER1:
	push {r0-r10,lr}
		
		ldr r0, =_gd_pidz
		
		@;Proceso en run
		ldr r0, [r0]		@;r0 = valor de _gd_pidz
		and r0, #0xF		@; r0 = 4 bits bajos de _gd_pidz (numero de zocalo)
		
		mov r1, #0
		bl _gm_pintaEstado
		
	@; Procesos en Ready
		ldr r3, =_gd_qReady
		ldr r2, =_gd_nReady
		ldr r2, [r2]		@; r2 = numero de procesos en cola de ready
		
		mov r1, #2			
	.LRecorreReady:
		sub r2, #1
		cmp r2, #-1
		beq .LFinReady
		
		ldrb r0, [r3,r2]	@; r0 = pid + zocalo
		and r0, #0xF		@; r0 = 4 bits bajos de _gd_pidz (numero de zocalo)
		
		bl _gm_pintaEstado
		b .LRecorreReady
		
	.LFinReady:
		mov r1, #1
		ldr r3, =_gd_qDelay
		ldr r2, =_gd_nDelay
		ldr r2, [r2]
		
	.LRecorrerBlocked:
		sub r2, #1
		cmp r2, #-1
		beq .LFinBlocked
		
		mov r4, r2, lsl #2	@; r4 =  indice * 2^2
		ldr r0, [r3,r4]		@; r0 = pid + zocalo
		and r0, #0xF		@; r0 = 4 bits bajos de _gd_pidz (numero de zocalo)
		
		bl _gm_pintaEstado
		b .LRecorrerBlocked
		
	.LFinBlocked:
	@; Gestión de pintado del uso de pila
		ldr r10, =_gd_pcbs
		ldr r6, =_gd_stacks
		
		mov r3, #16				@; r3 = numero maximo de procesos
		mov r0, #0				@; r0 = indice para recorrer _gd_pcbs
		
		mov r8, #512 			@; r8 = tamaño del stack de un proceso
		mov r5, #24
	.LRecorrerPCBs:
		mla r4, r0, r5, r10		@; r4 = (indice * tamaño de cada PCB (24 bytes))+puntero hasta array_pcb
		cmp r0, #0				@; Proceso SO
		beq .LProcesoSO
		
		ldr r7, [r4]			@; r7 = PID del proceso		
		cmp r7, #0
		beq .LBorrarPila
		
	.LProcesoSO:
		add r4, #8				@; r4 = r4 + 8 para apuntar a Stack Pointer
		ldr r1, [r4]			@; r1 = Stack Pointer
		
		cmp r0, #0				@; Si es SO
		ldreq r9, =0x0b003d00	@; @ System Stack
		beq .LProcesoSOStack
		
		mul r7, r0, r8			@; r7 = num zocalo * tamaño de la pila
		add r9, r6, r7			@; r9 = puntero al principio de la pila del proceso i 
	
	.LProcesoSOStack:
		sub r9, #4				@; Restamos 4 para ajustar el funcionamiento de la pila
		
		sub r1, r9, r1			@; r1 = numero de bytes ocupados en la pila
		mov r1, r1, lsr #2		@; r1 = Numero de words que ocupa la pila (dividimos entre 4 bytes)
		
		mov r1, r1, lsr #3		@; r1 =  words / 128 * 16 = words / 8
		
		bl _gm_pintarPila
		b .LSiguientePCB
		
	.LBorrarPila:
		bl _gm_borrarPila
		
	.LSiguientePCB:	
		add r0, #1
		cmp r0, r3
		bne .LRecorrerPCBs	
		
	pop {r0-r10, pc}
	
	
.end

