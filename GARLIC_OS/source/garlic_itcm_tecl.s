@;==============================================================================
@;
@;	"garlic_itcm_tecl.s":	código de las rutinas del teclado virtual
@;	Programador: Aleix Mariné
@;==============================================================================

.section .itcm,"ax",%progbits

	.arm
	.align 2

	.global _gt_getstring
	@;Parámetros:
	@; R0: string -> dirección base del vector de caracteres (bytes)
	@; R1: max_char -> número máximo de caracteres del vector
	@; R2: zocalo -> número de zócalo del proceso invocador
	@; Return
	@; R0: int -> Número de carácteres leídos
	@;	•	Si la interfaz de teclado está desactivada (oculta), mostrarla
	@;	(ver punto 8) y activar la RSI de teclado (ver punto 9).
	
	@;	•	Añadir el número de zócalo sobre un vector global
	@;	_gd_kbwait[], que se comportará como una cola en la cual
	@;	estarán registrados los procesos que esperan la entrada de
	@;	un string por teclado,
	
	@;	•	Esperar a que el bit de una variable global _gd_kbsignal,
	@;	correspondiente al número de zócalo indicado, se ponga a 1,
	
	@;	•	Poner el bit anterior a cero, copiar el string leído sobre el
	@;	vector que se ha pasado por parámetro, filtrando el número
	@;	total de caracteres y añadiendo el centinela, y devolviendo
	@;	el número total de caracteres leídos (excluido el centinela).
_gt_getstring:
	push {r1-r7, lr}

	@; Ahora registraremos el proceso en la cola de espera del KB
	
	ldr r3, =_gd_nKeyboard			@; Cargamos la @ el numero de procesos esperando 
	ldrsb r4, [r3]					@; r4 = num procesos
	cmp r4, #16						@; Si el nombre de processos es igual a la mda maxima de la cua
	moveq r0, #-1					@; Carreguem un -1 a r0
	beq .L_getstring_error			@; I sortim de la rutina
	ldr r5, =_gd_Keyboard			@; cargamos @base de la cola de espera del KB (vector de char)
	strb r2, [r5, r4]				@; guardamos el zócalo recibido por parámetro a la posicion
	add r4, #1						@; sumamos 1 al índice
	strb r4, [r3]					@; actualizamos el índice
	
	@; Ara posarem el segon bit de mes pes de la variable _gd_pidz per indicar que es tracta dun proces que espera KB
	ldr r3, = _gd_pidz				@; r3 = @_gd_pidz
	ldr r4, [r3]					@; r4 = _gd_pidz
	orr r4, r4, #0x40000000			@; fiquem a 1 el segon bit de més pes del pidz
	bl _gp_rsiVBL					@; Cridem a _gp_rsiVL per a forçar que es salvi el context del proces
	
	@; aqui continuara el proces que hagi sigut tret de la cua d'espera
	
	mov r5, r0						@; r5 = @ string. Salvamos la dirección del string en r5
	mov r0, r2						@; Passada de parametres a _gt_showKB (espera el número de zócalo por r0)
	push {r0-r5}
	bl _gt_showKB 					@; mostramos
	pop {r0-r5}
	mov r0, r5						@; Recuperamos en r0 @ string 

	@;Bucle de espera a _gd_kbsignal

	ldr r3, =_gd_kbsignal		@; Cargamos @ de la variable _gd_kbsignal (señal de rsi)
	mov r4, #1					@; Cargamos un 1 en r4
	lsl r4, r2					@; Lo desplazamos tantas posiciones como número de zócalo del proceso invocaador
.Lgtgetstr_waitforsignal:		@; bucle d'espera del bit a _gd_kbsignal
	bl _gp_WaitForVBlank		@; Esperamos un retroceso vertical para no sobrecargar CPU
	ldrh r5, [r3]				@; Volvemos a traer de memoria el contenido de la variable
	tst r5, r4					@; Comprovamos que el bit este a uno
	beq .Lgtgetstr_waitforsignal@; Si no hay coincidencia de bits volvemos al principio del bucle de espera
	mvn r4, r4					@; NOT de todos los bits 1 a 1, por tanto seran todos los bits a 1 excepto el del proceso que tratamos
	and r4, r5					@; Hacemos una and, por lo que el bit del proceso tratado se pondra a 0 i el valor de todos los demas procesos tendra el valor que ya tenia.
	strh r4, [r3]				@; Actualizamos la variable _gd_kbsignal con el bit del proceso actual a 0

	@; copiar el string leído sobre el vector que se ha pasado por parámetro, filtrando el número de caracteres leido 
	@;total de caracteres y añadiendo el centinela, y devolviendo
	@;el número total de caracteres leídos (excluido el centinela).
	ldr r3, =_gt_inputl			@; carreguem @ base de la variable de nombre de caracters
	ldrb r2, [r3]				@; r2 = nombre de caracters d'input
	cmp r1, r2					@; Comparem el nombre de caracters d'input i la capacitat del string destí
	movlo r2, r1				@; r2 = nombre de caracters maxim (valor més limitant)
	
	cmp r2, #0					@; Si no hi ha res al buffer sortim. 
	beq .Lgtgetstr_copystrfi	@; 
	
	ldr r4, =_gt_input			@; r4 = @ base del vector de input
	mov r5, #0					@; r5 = comptador. Inicialitzem comptador
	
.Lgtgetstr_copystr:
	ldrsb r3, [r4, r5]			@; Carreguem signed (per a reconeixer caracter centinella) sobre r3. Conté el vector a tractar
	add r3, #32					@; Factor de correcció per a transformar al codi ASCII
	strb r3, [r0, r5]			@; Guardem sobre l'string que rebem per parametre
	add r5, #1					@; Incrementem comptador
	cmp r5, r2					@; Si el comptador no es igual al valor maxim 
	bne .Lgtgetstr_copystr		@; tornem a iterar
.Lgtgetstr_copystrfi:
	mov r6, #0					@; Afegim el caracter de final de string (el \0 de tota la, vida)
	strb r6, [r0, r5]			@; Guardem el caracter de final de linia
	
	push {r0-r5}
	bl _gt_resetKB				@; resetegem per al següent us
	bl _gt_hideKB				@; Amaguem interficie de teclat
	pop {r0-r5}

	mov r0, r2					@; Retorn de parametres
.L_getstring_error:
	pop {r1-r7, pc}			
	
	
	
	
		.global _gt_cursorini
	@; Inicialitza el cursor en la primera posicio
_gt_cursorini:
	push {r0-r1, lr}
	ldr r0, =_gt_mapbasecursor	@; r0 = @@ del mapa de rajoletes del cursor
	ldr r0, [r0] 				@; r0 = @ el mapa del rajoletes
	add r0, #260				@; Anem a la següent linia de la capsa de text en el mapa del cursor 			
	mov r1, #99					@; carreguem a r1 la rajoleta de cursor (ratlla per la part de dalt)
	strh r1, [r0] 				@; carrega el cursor a la posicio inicial
	pop {r0-r1, pc}






		.global _gt_writePIDZ
	@; Recibe un char con el número de zócalo y muestra el PID del proceso correspondiente en la interfície de teclado 
	@; usando el fondo info
	@; Parámetros
	@; R0: char zocalo
_gt_writePIDZ:
	push {r1-r6,lr}
	
	@; ZÓCALO
	
	mov r5, r0					@; r5 = socol (copia de seguretat)
	mov r2, r0					@; r2 = socol		
	ldr r0, =_gt_PIDZ_tmp		@; r0 = @ _gd_PIDZ_tmp
	mov r1, #3					@; r1 = 3 (nombre de caracters)
	bl _gs_num2str_dec			@; converteix el zocalo passat per parametre a string R0: char * numstr, R1: int length, R2: int num. return r0 = 0 si toot va be
	ldr r0, =_gt_PIDZ_tmp		@; r0 = @ _gd_PIDZ_tmp
	ldr r2, =_gt_mapbaseinfo	@; r2 = @@ _gt_mapbaseinfo
	ldr r2, [r2]				@; r2 = @ _gt_mapbaseinfo
	mov r6, r2					@; Salvem aquesta direccio de memoria
	add r2, #88					@; Anem a on comença el text aquell de z00
	
	mov r1, #0					@; Inicialitzem comptador
.Lgtesc_V1:
	ldrb r4, [r0, r1]			@; carreguem el digit del nombre de socol
	cmp r4, #32					@; comparem amb 32
	subne r4, #32				@; Si es tracta d'un número normal (0-9) restem 32 per a passar a rajoletes
	subeq r4, #16				@; Si es tracta d'un espai (32) restem 16 per a obtenir un 0 en coddificacio de rajoletes
	mov r3, r1, lsl #1			@; Ens desplacem en el mapa de rajoletes (halfwords)
	strh r4, [r2, r3]			@; guardem a la posicio de zocalo
	add r1, #1					@; incrementem el comptador
	cmp r1, #3					@; si hem fet ja 3 repeticions sortim ja
	bne .Lgtesc_V1 				@; iteracio

	@; PID

	mov r4, #24					@; carrega 24 a r4 (la mida de cada PCB)
	mul r3, r5, r4				@; multipliquem aquest 24 amb el zocalo per a saber el desplaçament 
	ldr r2, =_gd_pcbs			@; carreguem direcció base del vector de PCBs
	ldr r2, [r2, r3] 			@; r2 = PIDZ del proces
	
	ldr r0, =_gt_PIDZ_tmp		@; r0 = @_gd_PIDZ_tmp
	mov r1, #6					@; r1 = 6 (caracters maxims)
	bl _gs_num2str_dec			@; converteix el PIDZ a string
	ldr r0, =_gt_PIDZ_tmp		@; r0 = @_gd_PIDZ_tmp

	mov r2, r6					@; restaurem r2 = @ _gt_mapbaseinfo
	add r2, #104				@; accedim a on comença el PID:00000
	
	mov r1, #0					@; Inicialitzem comptador
.Lgtesc_V:
	ldrb r4, [r0, r1]			@; procedim igual que abans
	cmp r4, #32
	subne r4, #32
	subeq r4, #16
	mov r3, r1, lsl #1
	strh r4, [r2, r3]
	add r1, #1
	cmp r1, #5					@; pero amb limit 5
	blo .Lgtesc_V 				@; segueix iterant

	pop {r1-r6, pc}
	
	
	
	
	
	
	.global _gt_resetKB
	@; reinicia totes les variables i estructures per a la següent E/S per KB
_gt_resetKB:
	push {r0-r4, lr}
	@; reiniciar cursor
		
	ldr r0, =_gt_cursor_pos		@; r0 = @_gt_cursor_pos	
	ldrb r1, [r0]				@; r1 = _gt_cursor_pos
	mov r1, r1, lsl #1			@; r1 = r1*2
	ldr r2, =_gt_mapbasecursor	@; r2 = @@_gt_mapbasecursor
	ldr r2, [r2]				@; r2 = @_gt_mapbasecursor
	add r2, #260				@; desplacem fins a la linia del cursor
	mov r3, #0					@; r3 = 0
	strb r3, [r0] 				@; cursor a la posicio 0
	strh r3, [r2, r1] 			@; borra el cursor de la posicio on estigui

	bl _gt_cursorini			@; posa cursor a la primera posicio

	mov r0, #0					@; r0 = 0
	mov r1, #-1					@; r1 = -1
	ldr r2, =_gt_input			@; r2 = @_gt_input 
	ldr r3, =_gt_inputl			@; r3 = @_gt_inputl
	ldrb r4, [r3]				@; r4 = _gt_inputl
.Lgtr_clean_input:
	strb r1, [r2, r0]			@; actualitza la posicio i
	bl _gt_updatechar			@; actualitza el caracter
	add r0, #1					@; afegeix a l'index
	cmp r0, r4					@; mentre no haguem arribat al final del string					
	blo .Lgtr_clean_input		@; seguim netejant l'string d'entrada

	mov r1, #0					@; r1 = 0
	strb r1, [r3]				@; reiniciem la quantitat de input
	
	pop {r0-r4, pc}
	
	
	
	
		.global _gt_updatechar
	@; Consulta un determinat caracter i actualitza el mapa de rajoletes
	@;Parámetros:
	@; R0: pos -> index del caracter a actualitzar
_gt_updatechar:
	push {r0-r2, lr}

	ldr r1, =_gt_mapbasebox		@; r1 = @@_gt_mapbasebox
	ldr r1, [r1] 				@; r1 = @_gt_mapbasebox
	add r1, #196 				@; direccio d'inici del quadre de text
	ldr r2 , =_gt_input			@; r2 = @_gt_input	
	ldrsb r2, [r2, r0]			@; carrega a r2 el caracter a on apunta l'index passat per parametre
	cmp r2, #-1					@; Si el caracter que ens estan dient que actualitzem es el de final de linea
	moveq r2, #0				@; Posem el caracter negre com de buit 
	lsl r0, #1					@; Multipliquem per dos el desplaçament (anem amb halfwords)
	strh r2, [r1, r0]			@; I guardem sobre el mapa de rajoletes a la posicio que toca. 
	pop {r0-r2, pc}
	
	
	
	
	
		.global _gt_getchar
	@; Obtiene el caracter de la posicion indicada del vector de caracteres
	@;Parámetros:
	@; R0: pos -> Índice del carácter
	@;Retorna:
	@; R0: char -> caracter en la posicion recibida por parámetro
_gt_getchar:
	push {r1, lr}
	@;lsl r0, #1				@; Multipliquem per 2
	ldr r1 , =_gt_input		@; r1 = @_gt_input
	ldrsb r0, [r1, r0]		@; r0 = _gt_input[r0] -> Caracter desitjat
	pop {r1, pc}
	
	
	
	
	
		.global _gt_putchar
	@;Parámetros:
	@; R0: pos -> Índice del caracter a actualizar
	@; R1: char -> caracter a introducir
_gt_putchar:
	push {r0-r2, lr}
	@;lsl r0, #1				@; Multipliquem per 2
	ldr r2 , =_gt_input		@; r2 = @_gt_input
	strb r1, [r2, r0]		@; _gt_input[r0] = r1; 
	pop {r0-r2, pc}
	
	
	
	
	@; Recibe el nuevo estado de los botones X e Y del arm7 a traves del sistema IPCSYNC

	.global _gt_rsi_IPC_SYNC
_gt_rsi_IPC_SYNC:
	push {r0-r1, lr}
	ldr r0, =0x04000180 		@; Carreguem direccio del registre de control/dades IPC_SYNC
	ldr r0, [r0]				@; Carreguem el sseu contingut
	and r0, r0, #0x3			@; Fem un clean dels dos primers bit, ja que son els unics que ens interessen
	ldr r1, =_gt_XYbuttons		@; r1 = @_gt_XYbuttons
	strb r0, [r1]				@; Guardem els dos bits de menys pes del registre IPC_SYNC del ARM9 a la variable _gt_XYbuttons
	pop {r0-r1, pc}
.end

