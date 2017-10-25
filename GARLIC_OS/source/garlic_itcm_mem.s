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
		beq .LFin
		sub r5, #1			@; añade uno al contador
		ldr r0, [r8, r11]	@; carga el tipo de la sección
		cmp r0, #9
		
		addne r11, #40
		bne .LBuclesecciones
		add r11, #12		@; sh_offset offset del segmento
		ldr r7, [r8, r11]	@; valor del offset cargado en r7
		add r11, #4			
		ldr r0, [r8, r11]	@; en r0 tenemos el size de la sección (serán todo reubicadores)
		add r11, #16
		ldr r1, [r8, r11]	@; en r1 tenemos el tamaño de cada reubicador
		ldr r2, =quo
		bl _ga_divmod		@; en r2 tenemos el numero de reubicadores
		ldr r2, [r2]
		
	.LBucleReubicadores:
		cmp r2, #0
		beq .LBuclesecciones
		sub r2, #1
		ldr r1, [r8, r7]	@; guardo en r1 el valor del primer reubicador, el offset
		add r7, #4
		ldrb r0, [r8, r7]	@; guardo en r0 el tipo de reubicador
		and r0, #0xFF
		cmp r0, #2
		
		addne r7, #4
		b .LBucleReubicadores			@; si no es del tipo correcto, siguiente reubicador

		
		add r1, r10
		sub r1, r9			@; en r1 tengo la direccion de reubicación
		ldr r12, [r1]		@; obtengo el contenido de la dirección	
		add r12, r10
		sub r12, r9
		str r12, [r1]
		add r7, #4
		b .LBucleReubicadores
		

	.LFin:
	
	pop {r0-r12,pc}
	
.end

