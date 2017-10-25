@;==============================================================================
@;
@;	"garlic_itcm_proc.s":	código de las funciones de control de procesos (1.0)
@;						(ver "garlic_system.h" para descripción de funciones)
@;
@;==============================================================================

.section .itcm,"ax",%progbits

	.arm
	.align 2
	
	.global _gp_WaitForVBlank
	@; rutina para pausar el procesador mientras no se produzca una interrupción
	@; de retrazado vertical (VBL); es un sustituto de la "swi #5", que evita
	@; la necesidad de cambiar a modo supervisor en los procesos GARLIC
_gp_WaitForVBlank:
	push {r0-r1, lr}
	ldr r0, =__irq_flags
.Lwait_espera:
	mcr p15, 0, lr, c7, c0, 4	@; HALT (suspender hasta nueva interrupción)
	ldr r1, [r0]			@; R1 = [__irq_flags]
	tst r1, #1				@; comprobar flag IRQ_VBL
	beq .Lwait_espera		@; repetir bucle mientras no exista IRQ_VBL
	bic r1, #1
	str r1, [r0]			@; poner a cero el flag IRQ_VBL
	pop {r0-r1, pc}


	.global _gp_IntrMain
	@; Manejador principal de interrupciones del sistema Garlic
_gp_IntrMain:
	mov	r12, #0x4000000
	add	r12, r12, #0x208	@; R12 = base registros de control de interrupciones	
	ldr	r2, [r12, #0x08]	@; R2 = REG_IE (máscara de bits con int. permitidas)
	ldr	r1, [r12, #0x0C]	@; R1 = REG_IF (máscara de bits con int. activas)
	and r1, r1, r2			@; filtrar int. activas con int. permitidas
	ldr	r2, =irqTable
.Lintr_find:				@; buscar manejadores de interrupciones específicos
	ldr r0, [r2, #4]		@; R0 = máscara de int. del manejador indexado
	cmp	r0, #0				@; si máscara = cero, fin de vector de manejadores
	beq	.Lintr_setflags		@; (abandonar bucle de búsqueda de manejador)
	ands r0, r0, r1			@; determinar si el manejador indexado atiende a una
	beq	.Lintr_cont1		@; de las interrupciones activas
	ldr	r3, [r2]			@; R3 = dirección de salto del manejador indexado
	cmp	r3, #0
	beq	.Lintr_ret			@; abandonar si dirección = 0
	mov r2, lr				@; guardar dirección de retorno
	blx	r3					@; invocar el manejador indexado
	mov lr, r2				@; recuperar dirección de retorno
	b .Lintr_ret			@; salir del bucle de búsqueda
.Lintr_cont1:	
	add	r2, r2, #8			@; pasar al siguiente índice del vector de
	b	.Lintr_find			@; manejadores de interrupciones específicas
.Lintr_ret:
	mov r1, r0				@; indica qué interrupción se ha servido
.Lintr_setflags:
	str	r1, [r12, #0x0C]	@; REG_IF = R1 (comunica interrupción servida)
	ldr	r0, =__irq_flags	@; R0 = dirección flags IRQ para gestión IntrWait
	ldr	r3, [r0]
	orr	r3, r3, r1			@; activar el flag correspondiente a la interrupción
	str	r3, [r0]			@; servida (todas si no se ha encontrado el maneja-
							@; dor correspondiente)
	mov	pc,lr				@; retornar al gestor de la excepción IRQ de la BIOS


	.global _gp_rsiVBL
	@; Manejador de interrupciones VBL (Vertical BLank) de Garlic:
	@; se encarga de actualizar los tics, intercambiar procesos, etc.
_gp_rsiVBL:
	push {r4-r7, lr}
	ldr r4, =_gd_tickCount	@; obtenim pa posició de la variable _tickCount
	ldr r5,[r4]				@; obtenim el nombre de tics en r5
	add r5, r5, #1			@; incrementem el nombre de tics en 1
	str r5, [r4]			@; actualitzem la variable _tickCount
	ldr r4, =_gd_nReady		@; obtenim la posició de la variable _gd_nReady
	ldr r5, [r4]			@; r1= processos en la cola de ready
	cmp r5, #0				@; mirem si hi ha processos en la cua
	beq .Lfi_rsiVBL			@; sortim de la RSI sense dur a terme un canvi de context
	ldr r4, =_gd_pidz		@; obtim la variable _gd_pidz on hi ha (Identificador de proceso + zócalo actual)
	ldr r5, [r4]			@; obtenim l'identificador del procés
	cmp r5, #0				@; mirem si el procés en execució és el SO
	beq .Lrsi_salvar_context	@; si ho és passem directament a salvar el seu context
	lsr r5, r4, #4			@; mirem el cas que no sigui un procés que ha acabat, pid=0, per fer-ho desplacem els 4 bits de menys pes (zòcalo)
	cmp r5, #0				@; comprobem que el pid no sigui 0
	beq .Lrsi_restauraProc	@; si ho és no salvem el context
.Lrsi_salvar_context:
	ldr r4, =_gd_nReady		@; r4= direcció de _gd_nready
	ldr r5, [r4]			@; r5= núm de processos en Ready
	ldr r6, =_gd_pidz		@; r6= direcció de _gd_pidz
	bl _gp_salvarProc		@; cridem la funció salvar context amb els paràmetres en els registres que toca
	str r5, [r4]			@; Actualitzem el num de processos en la cua de Ready, valor que ens retorna la funció 
.Lrsi_restauraProc:
	ldr r4, =_gd_nReady		@; r4= direcció de _gd_nready
	ldr r5, [r4]			@; r5= núm de processos en Ready
	ldr r6, =_gd_pidz		@; r6= direcció de _gd_pidz
	bl _gp_restaurarProc	@;cridem la funció salvar context amb els paràmetres en els registres que toca
.Lfi_rsiVBL:
	pop {r4-r7, pc}


	@; Rutina para salvar el estado del proceso interrumpido en la entrada
	@; correspondiente del vector _gd_pcbs
	@;Parámetros
	@; R4: dirección _gd_nReady
	@; R5: número de procesos en READY
	@; R6: dirección _gd_pidz
	@;Resultado
	@; R5: nuevo número de procesos en READY (+1)
_gp_salvarProc:
	push {r8-r11, lr}
	ldr r8, [r6]  			@; obteim el PID més zócalo
	and r8, r8, #15			@; r8= num de zócalo, ens quedem amb els 4 bits de menys pes del pidz
	ldr r9, =_gd_qReady		@; carreguem en r9 la direccio de la cua de Ready
	strb r8, [r9, r5]		@; guardem el nombre de zocalo del procés en l'última posició de la cua de Ready
	add r5, #1				@; incrementem el nombre de processos en la cua de Ready
	ldr r9, =_gd_pcbs		@; direcció del array de PCBs
	@;mul r10, r8, #24		@; desplaçament per arrivar al PCB del zócalo actual: num de zócalo * 24, on 24 es la mida de cada PCB (6 ints, 6 * 4 bytes per int)
	@;add r9, r10				@; R9 = direcció del PCB del procés actual
	mov r10, #24
	mla r9, r10, r8, r9		@; mateix que en les dos opp comentades anteriorment
	@; guardem PC
	mov r10, sp				@; r10 = SP_irq (punter al top de la pila IRQ)
	ldr r8, [r10, #60]		@; r8 = PC del procés a desbancar (+60 per l'estruct. de la pila IRQ veure a imatge)
	str r8, [r9, #4]		@; guardem el PC(r15) en la seva posició del PCB
	@; guardem el CSPR
	mrs r11, SPSR			@; movem el contingut del SPSR (CSPR del procés) al registre r11
	str r11, [r9, #12]		@; guardem el CSPR en el camp Status del PCB
	@; canviem el mode d'execució
	mrs r8, CPSR			@; r8 = CPSR
	orr r8, #0x1F			@; Mode System, 5 últims bits a 1
	msr CPSR, r8			@; Canvem el mode
	@; apilem els registres r0-r12 i r14
	push {r14}				@; Apilem R14
	ldr r8, [r10, #56]		@; r8 = R12 (emmagatzemat en la posició 14 de SP_IRQ)
	push {r8}				@; Apilem R12
	ldr r8, [r10, #12]		@; r8 = R11 (emmagatzemat en la posició 3 de SP_IRQ)
	push {r8}				@; Apilem R11
	ldr r8, [r10, #8]		@; r8 = R10 (emmagatzemat en la posició 2 de SP_IRQ)
	push {r8}				@; Apilem R10
	ldr r8, [r10, #4]		@; r8 = R9 (emmagatzemat en la posició 1 de SP_IRQ)
	push {r8}				@; Apilem R9	
	ldr r8, [r10]			@; r8 = R8 (emmagatzemat en la posició 0 de SP_IRQ)
	push {r8}				@; Apilem R8
	ldr r8, [r10, #32]		@; r8 = R7 (emmagatzemat en la posició 8 de SP_IRQ)
	push {r8}				@; Apilem R7	
	ldr r8, [r10, #28]		@; r8 = R6 (emmagatzemat en la posició 7 de SP_IRQ)
	push {r8}				@; Apilem R6
	ldr r8, [r10, #24]		@; r8 = R5 (emmagatzemat en la posició 6 de SP_IRQ)
	push {r8}				@; Apilem R5	
	ldr r8, [r10, #20]		@; r8 = R4 (emmagatzemat en la posició 5 de SP_IRQ)
	push {r8}				@; Apilem R4
	ldr r8, [r10, #52]		@; r8 = R3 (emmagatzemat en la posició 13 de SP_IRQ)
	push {r8}				@; Apilem R3	
	ldr r8, [r10, #48]		@; r8 = R2 (emmagatzemat en la posició 12 de SP_IRQ)
	push {r8}				@; Apilem R2
	ldr r8, [r10, #44]		@; r8 = R1 (emmagatzemat en la posició 11 de SP_IRQ)
	push {r8}				@; Apilem R1
	ldr r8, [r10, #40]		@; r8 = R0 (emmagatzemat en la posició 10 de SP_IRQ)
	push {r8}				@; Apilem R0	
	@; guardem el SP(r13) del proces en el PCB
	str r13, [r9, #8]		@; guardem el r13 en la pos. SP del PCB
	@; canviem el mode d'execució
	mrs r8, CPSR			@; r8 = CPSR
	and r8, #0xFFFFFFE0		@; Mode User
	orr r8, #0x12			@; Mode IRQ
	msr CPSR, r8			@; Canvem el mode
	pop {r8-r11, pc}


	@; Rutina para restaurar el estado del siguiente proceso en la cola de READY
	@;Parámetros
	@; R4: dirección _gd_nReady
	@; R5: número de procesos en READY
	@; R6: dirección _gd_pidz
_gp_restaurarProc:
	push {r8-r11, lr}
	

	pop {r8-r11, pc}


	.global _gp_numProc
	@;Resultado
	@; R0: número de procesos total
_gp_numProc:
	push {r1-r2, lr}
	mov r0, #1				@; contar siempre 1 proceso en RUN
	ldr r1, =_gd_nReady
	ldr r2, [r1]			@; R2 = número de procesos en cola de READY
	add r0, r2				@; añadir procesos en READY
	pop {r1-r2, pc}



	.global _gp_crearProc
	@; prepara un proceso para ser ejecutado, creando su entorno de ejecución y
	@; colocándolo en la cola de READY
	@;Parámetros
	@; R0: intFunc funcion,
	@; R1: int zocalo,
	@; R2: char *nombre
	@; R3: int arg
	@;Resultado
	@; R0: 0 si no hay problema, >0 si no se puede crear el proceso
_gp_crearProc:
	push {lr}


	pop {pc}


	@; Rutina para terminar un proceso de usuario:
	@; pone a 0 el campo PID del PCB del zócalo actual, para indicar que esa
	@; entrada del vector _gd_pcbs está libre; también pone a 0 el PID de la
	@; variable _gd_pidz (sin modificar el número de zócalo), para que el código
	@; de multiplexación de procesos no salve el estado del proceso terminado.
_gp_terminarProc:
	ldr r0, =_gd_pidz
	ldr r1, [r0]			@; R1 = valor actual de PID + zócalo
	and r1, r1, #0xf		@; R1 = zócalo del proceso desbancado
	str r1, [r0]			@; guardar zócalo con PID = 0, para no salvar estado			
	ldr r2, =_gd_pcbs
	mov r10, #24
	mul r11, r1, r10
	add r2, r11				@; R2 = dirección base _gd_pcbs[zocalo]
	mov r3, #0
	str r3, [r2]			@; pone a 0 el campo PID del PCB del proceso
.LterminarProc_inf:
	bl _gp_WaitForVBlank	@; pausar procesador
	b .LterminarProc_inf	@; hasta asegurar el cambio de contexto
	
.end

