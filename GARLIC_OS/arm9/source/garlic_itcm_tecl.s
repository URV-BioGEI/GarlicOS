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
	@;
	@; 		1 => Encolar proceso en la cola de teclado
	@;		2 => Si la interficie de teclado esta oculta, mostrarla para este proceso
	@;		3 => Poner bit 30 de la variable _gd_pidz a 1(proceso que espera teclado)
	@;		4 => Llamamos a _gp_rsiVBL, que forzara salvar el contexto del proceso
	@;		5 => Dentro de la funcion _gp_rsiVBL se salva el contexto del proceso
	@;		6 => WAIT UNTIL INTRO. El proceso que espera a teclado esta en la cola de teclado con su contexto
	@;		salvado sin gastar quantums. La rsi del sistema IPC_FIFO es quien se encarga de 
	@;		capturar los caracteres e ir manejando la esscritura hasta que se pulsa INTRO para 
	@;		confirmar string.
	@;		7 => Cuando se pulsa INTRO, la rsi actua, desencolando el proceso en _gt_Keyboard[0]
	@;		i colocandolo en _gd_Ready[nReady], disminuyendo y aumentando los correspondientes
	@;		indices i compactando el vector _gt_Keyboard.
	@;		8 => En los quantums siguientes la rutina _gt_getstring continuara su ejecucion i 
	@;		realizara las siguientes tareas de finalizacion: 
	@;			- copiar el string leído sobre el vector que se ha pasado por parámetro
	@;			- Filtrar el número de caracteres leidos i devolverlo por r0
	@;			- Añadir el centinela
	@;		9 => Debido a la posible concurrencia con las llamadas a _gt_getstring la llamada 
	@;		a showKB del paso 2 puede no realizarse debido a que ya se este atendiendo a una 
	@;		peticion i la interficie ya este mostrada. Debido a que todos los procesos estan 
	@;		bloqueados, la solucion que se ha dado a este problema es que el proceso que ya haya
	@;		finalizado la lectura de su string, sea el que invoque a showKB para el siguiente proceso
	@;		que espera teclado; teniendo que obtener su zocalo para que se muestre correctamente.
	@;		
	@;		EJEMPLO: 
	@;		void P0 {_gt_getsring(...)} //getstring desde P0. P0 hara el 2o paso i sera atendido
	@;		void P1 {_gt_getsring(...)}	//getstring desde P1. P1 no hara el 2o paso debido a que la 
	@;		interficie ya esta siendo usada.
	@;		_gt_Keyboard = {P0, P1}
	@;		Cuando a P0 se le confirme el string, sera el encargado de mostrar la interficie para P1.
	@;		
	@; 		Por tanto, en el paso 9 podemos añadir que:
	@;			- Se oculta la interficie
	@;			- Se resetea la interficie para el siguiente uso
	@;			- Se muestra la interficie para el siguiente proceso (si lo hay). Sino se mantiene oculta
	@;		
	
_gt_getstring:
	push {r1-r7, lr}

	@; Ahora registraremos el proceso en la cola de espera del KB
	
	ldr r3, =_gd_nKeyboard			@; Cargamos la @ de la varible que tiene el numero de procesos esperando 
	ldrsb r4, [r3]					@; r4 = num procesos
	cmp r4, #16						@; Si el nombre de processos es igual a la mida maxima de la cua
	moveq r0, #-1					@; Carreguem un -1 a r0
	beq .L_getstring_error			@; I sortim de la rutina
	ldr r5, =_gd_Keyboard			@; cargamos @base de la cola de espera del KB (vector de char)
	strb r2, [r5, r4]				@; guardamos el zócalo recibido por parámetro a la posicion
	add r4, #1						@; sumamos 1 al índice
	strb r4, [r3]					@; actualizamos el índice
	
	@; Mirem que la interficie estigui mostrada
	
	ldr r4, =_gt_kbvisible			@; Cargamos @ de _gt_visible
	ldrb r3, [r4]					@; r3 = _gt_visible
	cmp r3, #1						@; Si esta mostrada, vol dir que algu l'esta utilitzant
	beq .Lgtgetstr_pidzcode			@; Per tant passem aquest pas. Sino...
	mov r5, r0						@; r5 = @ string. Salvamos la dirección del string en r5
	mov r0, r2						@; Passada de parametres a _gt_showKB (espera el número de zócalo por r0)
	push {r0-r5}
	bl _gt_showKB 					@; mostramos la interficie para el proceso que llama a getstring
	pop {r0-r5}
	mov r0, r5						@; Recuperamos en r0 @ string
 
	@; Ara posarem a 1 el segon bit de mes pes de la variable _gd_pidz per indicar que es tracta dun proces que espera KB
.Lgtgetstr_pidzcode:
	ldr r3, = _gd_pidz				@; r3 = @_gd_pidz
	ldr r4, [r3]					@; r4 = _gd_pidz
	orr r4, r4, #0x40000000			@; fiquem a 1 el segon bit de més pes del pidz
	bl _gp_rsiVBL					@; Cridem a _gp_rsiVL per a forçar que es salvi el context del proces
	
	@; aqui continuara el proces que hagi sigut tret de la cua d'espera

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
	
	@; Ara mostrarem la interficie per al següent proces que utilitzara el teclat. Per a fer-ho cal que primer eliminem 
	@; el primer proces que espera teclat (aixo ho fara la rsi) per a que al carregar _gd_Keybard[0] obtinguem el socol 
	@; del seguent proces
	ldr r3, =_gd_nKeyboard			@; Cargamos la @ de la varible que tiene el numero de procesos esperando 
	ldrb r4, [r3]					@; r4 = num procesos
	cmp r4, #0						@; Si el nombre de processos es 0, sortim sense mostrar interficie
	beq .L_getstring_error			@; Sortim
	ldr r0, =_gd_Keyboard			@; Carreguem cua de teclat	
	ldrb r0, [r0]					@; Carreguem el primer byte (següent proces)
	push {r0-r5}
	bl _gt_showKB 					@; mostramos la interficie para el proceso en la posicion 0 de la cola
	pop {r0-r5}
	mov r0, r2						@; Retorn de parametres

.L_getstring_error:
	pop {r1-r7, pc}			
	
	
	
	
		.global _gt_cursorini
	@; Inicialitza el cursor en la primera posicio
_gt_cursorini:
	push {r0-r1, lr}
	ldr r0, =_gt_mapbasecursor	@; r0 = @@ del mapa de rajoletes del cursor
	ldr r0, [r0] 				@; r0 = @ el mapa del rajoletes
	add r0, #(32*2+2)*2			@; Anem a la capsa de text en el mapa del cursor 			
	mov r1, #97					@; carreguem a r1 la rajoleta de cursor (ratlla per la part de dalt)
	strh r1, [r0] 				@; carrega el cursor a la posicio inicial
	pop {r0-r1, pc}


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
	add r2, #(32*2+2)*2			@; desplacem fins a la linia del cursor
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
	add r1, #132 				@; direccio d'inici del quadre de text
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
	
	
	@; Recibe el nuevo estado de los botones X e Y del arm7 a traves del sistema IPCSYNC.
	@; Guarda esa informacion en los dos primeros bits de menos peso de la variable _gt_XYButtons
	@; Se consultara el estado de los botones desde el arm9 usando esa variable, ya que continuamente
	@; su valor esta siendo refrescado por esta rsi

	.global _gt_rsi_IPC_SYNC
_gt_rsi_IPC_SYNC:
	push {r0-r1, lr}
	ldr r0, =0x04000180 		@; Carreguem direccio del registre de control/dades IPC_SYNC
	ldr r0, [r0]				@; Carreguem el sseu contingut
	and r0, r0, #0x3			@; Fem un clean dels dos primers bit, ja que son els unics que ens interessen
	ldr r1, =_gt_XYbuttons		@; r1 = @_gt_XYbuttons
	strb r0, [r1]				@; Guardem els dos bits de menys pes del registre IPC_SYNC del ARM9 a la variable _gt_XYbuttons
	pop {r0-r1, pc}
	
	@; Trata la informacion recibida a traves del sistema IPC_FIFO, utilizada por arm7 para enviar
	@; informacion la ultima pulsacion sobre la interficie dde teclado.
	@; Debido a que además de tener unos caracteres que añadir al buffer, hay que "pintar" unos
	@; determinados cuadros de la interficie de teclado segun la tecla a pulsar, arm7 se encarga 
	@; de hacer las comprobaciones logicas pertinentes para quitarle codigo a la rsi y facilitar 
	@; su trabajo. Concretamente, se ha implementado un tipo de mensaje que la rsi debe interpretar
	@; para procesar la interrupcion. La estructura del mensaje es el siguiente:
	@;		bits 19-21: Numero de casillas (ncas) a pintar desde la posicion inicial de tecla en el mapa
	@;		de baldosas.
	@;		bits 10-18: Desplazamiento hasta la posicion inicial de la tecla pulsada en el mapa de 
	@;		baldosas. Esto nos indica a partir de que baldosa hay que actualizar el dibujo ( resaltar)
	@;		bits 3-9: Desplazamiento para llegar a la posicion del array de caracteres correspondiente
	@; 		_gt_minset o _gt_majset. Esto nos dara el caracter a añadir al buffer
	@;		bits 0-2: Se usa para distinguir la pulsacion de una tecla especial. Codigos:
	@;			000 -> Tecla normal: Se pinta una sola casilla y hay que escribir la letra del array
	@;			001 -> SPACE: Se pintan ncas a partir del indice de baldosas y se añade un espacio
	@;			010 -> CAPS: se cambia el booleano en extern bool _gt_CAPS_lock i se llama a _gt_graf
	@;			par actualizar las vistas. No hay que hacer nada mas.
	@;			011 -> DEL: Se pintan ncas a partir del indice de baldosas y se llama a la funcion borrar (select)
	@;			100 -> INTRO: Se pintan ncas a partir del indice de baldosas y se confirma el string (start)
	@;			101 -> <=: Se pintan ncas a partir del indice de baldosas y se llama a la funcion (KEY_LEFT)
	@;			110 -> =>: Se pintan ncas a partir del indice de baldosas y se llama a la funcion (KEY_RIGHT)
	@;			111 -> Boton extra de la primera fila. Esconde la interficie de teclado

	.global _gt_rsi_IPC_FIFO
_gt_rsi_IPC_FIFO: 
	push {r0-r12, lr}
	mov r2, #0x04100000 		@; r2 = @IPC_FIFO_RECV
	ldr r2, [r2] 				@; r2 = IPC_FIFO_RECV
	
	ldr r0, =_gt_kbvisible
	ldrb r0, [r0]
	cmp r0, #1
	bne .L_IPC_FIFO_end

	and r3, r2, #0x3			@; r3 = IPC_FIFO_RECV & 0x3. Obtenemos tres primeros bits
	cmp r3, #0					@; Si es tracta de un 0 ( tecla normal)
	beq .L_IPC_FIFO_putkey
	cmp r3, #1					@; Si es tracta de un 1 ( tecla SPACE)
	beq .L_IPC_FIFO_SPACE
	cmp r3, #2					@; Si es tracta de un 2 ( tecla CAPS)
	beq .L_IPC_FIFO_CAPS
	cmp r3, #3					@; Si es tracta de un 3 ( tecla DEL)
	beq .L_IPC_FIFO_DEL			
	cmp r3, #4					@; Si es tracta de un 4 ( tecla INTRO)
	beq .L_IPC_FIFO_INTRO
	cmp r3, #5					@; Si es tracta de un 5 ( tecla <=)
	beq .L_IPC_FIFO_KEY_LEFT
	cmp r3, #6					@; Si es tracta de un 6 ( tecla =>)
	beq .L_IPC_FIFO_KEY_RIGHT
								@; Si es tracta de un 7 ( tecla especial)
	
.L_IPC_FIFO_KEY_RIGHT:
	@; Per a aquesta tecla especial s'ha reutilitzat el codi per al boto KEY RIGHT de la fase 1

	ldr r0, =_gt_cursor_pos		@; Carreguem @ de la posicio del cursor
	ldrsb r1, [r0]				@; r1 = posicio del cursor
	ldr r3, =_gt_inputl			@; r3 = @_gt_inputl
	ldrsb r3, [r3]				@; r3 = _gt_inputl
	cmp r1, r3 					@; Comprovem si estem al final
	beq .L_IPC_FIFO_end			@; si estem la fletxeta no fara re i sortim
	@;cmp r1, #27 				@; Comprovem si estem al final del buffer
	@;beq .Lgtrsi_end				@; si ho estem sortim perque la fletxeta no fara re
 
	@; Sino
 
	add r1, #1 					@; sumem 1 posicio al cursor
	strb r1, [r0]				@; actualitzem el cursor
	ldr r0, =_gt_mapbasecursor	@; r0 = @@_gt_mapbasecursor
	ldr r0, [r0] 				@; r0 = @_gt_mapbasecursor
	add r0, #130				@; Anem a la linea de la caixa de text
	lsl r1, #1 					@; calculem desplacament en un vector de halfowrd
	mov r3, #97					@; Carreguem rajoleta de cursor
	strh r3, [r0, r1] 			@; escriu cursor a la posicio següent
			
	sub r1, #2					@; resta dos per a l'índex
			
	mov r3, #0					@; carreguem un 0 a r3
	strh r3, [r0, r1]			@; I borrem el cursor
	b .L_IPC_FIFO_paintkeys		@; Anem a pintar rajoletes
	
.L_IPC_FIFO_KEY_LEFT:
	@; Per a aquesta tecla especial s'ha reutilitzat el codi per al boto KEY LEFT de la fase 1

	ldr r0, =_gt_cursor_pos		@; Carreguem @ de la posicio del cursor
	ldrsb r1, [r0]				@; r1 = posicio del cursor
	cmp r1, #0 					@; Comprovem si estem posicio 0
	beq .L_IPC_FIFO_end			@; Si es així final de bucle perque aquest botó no farà res
	sub r1, #1 					@; sino restem 1 posicio i 
	strb r1, [r0]				@; actualitzem variable cursor

	ldr r0, =_gt_mapbasecursor	@; r0 = @@ del mapa de rajoletes del cursor
	ldr r0, [r0] 				@; r0 = @ el mapa del rajoletes
	add r0, #130				@; Anem a la capsa de text en el mapa del cursor 
	mov r1, r1, lsl #1 			@; calculem desplacament (halfwords)
			
	mov r3, #97					@; carreguem a r3 la rajoleta de cursor (ratlla per la part de baix)
	strh r3, [r0, r1] 			@; carrega el cursor a la posicio anterior
			
	add r1, #2					@; i a la següent posicio
			
	mov r3, #0					@; carreguem un 0
	strh r3, [r0, r1] 			@; I posem una rajoleta de 0 (negre) per borrar el cursor de la posicio original
	b .L_IPC_FIFO_paintkeys		@; Anem a pintar caselles 

.L_IPC_FIFO_INTRO:
	ldr r0, =_gd_nKeyboard		@; r0 = @_gd_nKeyboard
	ldrb r1, [r0]				@; r1 = _gd_nKeyboard
	sub r1, #1					@; disminuim en un el nombre de processos
	strb r1, [r0]				@; actualitzem el nombre de processos
	cmp r1, #0					@; Si no hi ha cap procés sortim (situacio impossible)
	beq .L_IPC_FIFO_end 		@; Sortim
	mov r3, #0					@; inicialitzem comptador
	ldr r5, =_gd_Keyboard		@; Carreguem direccio r5 = @ _gd_Keyboard
.Lgtrsi_START_move:
	add r3, #1					@; afegim un al comptador
	ldrb r4, [r5, r3]			@; carreguem a r4 el socol del proces a _gd_Keyboard[i+1]
	sub r3, #1					@; restem 1 per a anar a la posicio anterior
	strb r4, [r5, r3]			@; guardem a la posicio _gd_Keyboard[i] movent un proces
	add r3, #1					@; Afegim 1 per a compensar el que hem restat abans
	cmp r1, r3					@; mirem si hem arribat al final de la cua de processos
	bne .Lgtrsi_START_move		@; si no hem arribat saltem
	b .L_IPC_FIFO_paintkeys		@; Si hem aribat anem a pintar les caselles, tot i que en aqeust cas potser no es veuen

.L_IPC_FIFO_DEL:

	@; Per a aquesta tecla especial s'ha reutilitzat el codi per al boto select de la fase 1
	ldr r6, =_gt_cursor_pos		@; r2 = @ index cursor
	ldrsb r4, [r6] 				@; r4 = index cursor
	ldr r3, =_gt_inputl			@; r3 = @ _gt_inputl
	ldrsb r5, [r3]				@; r5 = _gt_inputl
	
	cmp r5, #0					@; Si _gt_inputl és 0
	beq .L_IPC_FIFO_end				@; Sortim perque el select no farà res
	
	mov r0, r4					@; Guardem index cursor a r0 per a passar parametres
	bl _gt_getchar				@; Obtenim el caracter
	cmp r0, #-1 				@; Si el caracter que es vol borrar es -1
	beq .L_IPC_FIFO_end				@; surt (select no fara res)
	@; Si arribem aquí el cursor no està sobre -1 i hi ha un caracter o més sobre el vector i per tant borrarem un caracter segur
	sub r5, #1					@; Per tant hi haura un caracter menys
	strb r5, [r3]				@; Actualitzem variable
	
	mov r0, r4					@; Restaurem l'índex a r0
	add r5, #1					@; Cal tenir en compte que encara estem tractant l'string original
.Lgtrsi_SELECT_bucle:
	add r0, #1					@; Index apunta al següent caracter
	mov r4, r0					@; Salvem la posicio que tractem a r4
	cmp r0, r5					@; comparem amb el nombre maxim de caracters
	beq .Lgtrsi_SELECT_end		@; Si estem al nombre maxim de caracters sortim. I sinó
	bl _gt_getchar				@; Obtenim caracter de la següent posicio 
	mov r1, r0					@; Posem el caracter a colocar a r1
	mov r0, r4					@; Restaurem la posicio a tractar
	sub r0, #1					@; Restem 1 per a que es posi el caracter en la posicio anterior
	bl _gt_putchar				@; coloquem el caracter i+1 en la posicio i
	bl _gt_updatechar			@; Actualitzem rajoleta de la posicio i
	add r0, #1					@; Compensem el que hem restat abans
	b .Lgtrsi_SELECT_bucle		@; tornem a començar el bucle
.Lgtrsi_SELECT_end:
	sub r0, #1					@; compensem l'últim caracter
	mov r1, #-1					@; carreguem caracter de final de linia
	bl _gt_putchar				@; Coloquem el caracter
	bl _gt_updatechar			@; L'actualitzem
	
	b .L_IPC_FIFO_paintkeys		@; sortim de la rsi
	
	
.L_IPC_FIFO_CAPS:
	ldr r3, =_gt_CAPS_lock		@; r3 = @_gt_CAPS_lock
	ldrb r4, [r3]				@; r4 = _gt_CAPS_lock
	mvn r4, r4					@; r4 = !r4 (NOT del bits a la variable)
	and r4, r4, #1				@; Conservem un sol bit (boolean) r4 = !_gt_CAPS_lock
	strb r4, [r3]				@; Actualitzem el valor de la variable
	push {r0-r5}				@; Salvem registres
	bl _gt_graf					@; Cridem a la funcio _gt_graf, que ens fa tot el que necesitem
	pop {r0-r5}					@; Recuperem
	b .L_IPC_FIFO_paintkeys		@; Anem a pintar rajoletes

	
.L_IPC_FIFO_SPACE:
	ldr r3, =_gt_cursor_pos		@; r3 = @ posicio del cursor
	ldrsb r4, [r3]				@; r4 = posicio del cursor
	ldr r5, =_gt_inputl			@; r5 = @ numero de caracters
	ldrb r6, [r5]				@; r6 = numero de caracters
	cmp r4, #28					@; Si la posicio del cursor esta al final
	beq .L_IPC_FIFO_end			@; Sortim
	cmp r4, r6					@; Si el cursor esta al final del string
	beq .L_IPC_FIFO_addspaceend	@; Afegim un espai al final, incrementem cursor i inputlength, i actualitzem rajoles
	@; I si estem pel mig
.L_IPC_FIFO_SPACE_insert:		
	mov r0, r4					@; r0 = pos_cursor
	mov r1, #0					@; Carreguem un 0 (rajoleta d'espai)
	bl _gt_putchar				@; Posem una rajola buida a la pos del cursor
	bl _gt_updatechar			@; Actualitzem caracters
	b .L_IPC_FIFO_paintkeys		@; i anem a pintar

.L_IPC_FIFO_addspaceend:	

	@; Aquest 
	add r6, #1					@; r6 = _gt_inputl++
	strb r6, [r5]				@; Actualitzem valor de input
	add r4, #1					@; r4 = _gt_cursorpos++
	strb r4, [r3]				@; Actualitzem posicio del cursor
	ldr r7, =_gt_mapbasecursor	@; r7 = @@_gt_mapbasecursor
	ldr r7, [r7] 				@; r7 = @_gt_mapbasecursor
	add r7, #132				@; Anem a la següent linea de la caixa de text
	lsl r4, #1 					@; r4 = calculem desplacament en un vector de halfowrd
	mov r2, #97					@; Carreguem rajoleta de cursor
	strh r2, [r7, r4] 			@; escriu cursor a la nova posicio
	sub r1, #2					@; resta dos per a l'índex per anar enrere (halfwords)
	mov r2, #0					@; carreguem un 0 a r2 (rajoleta invisible)
	strh r2, [r0, r1]			@; I borrem el cursor
	b .L_IPC_FIFO_paintkeys		@; Anem a pintar
	
.L_IPC_FIFO_putkey: 
@; Totes les tecles normals aniran a parar aqui. Aquesta subfuncio sencarrega d'accedir a la
@; posicio de l'array de text (majset o minset segons _gt_CAPS_lock) indicada pel word rebut 
@; per missatge i posarla a la posicio del cursor.
	lsr r3, r2, #3				@; Desplacem 3 bits
	and r3, r3, #0x7F			@; Fem clean de la resta de bits (ens interessen els 7 primers)
	ldr r4, =_gt_CAPS_lock		@; carreguem variable caps
	ldrb r4, [r4]				@; r4 = _gt_CAPS_lock
	cmp r4, #0
	ldrgt r5, =_gt_majset		@; Segons l'estat carreguem una direccio de memoria
	ldreq r5, =_gt_minset
	ldrb r1, [r5, r3]			@; r1 = caracter Carreguem el caracter de la posicio de l'array que toca
	ldr r0, =_gt_cursor_pos		
	ldrb r0, [r0]				@; r0 = pos cursor. Obtenim la posicio del cursor
	ldr r4, =_gt_inputl			@; r4 = @ _gt_inputl
	ldrb r5, [r4]				@; r5 = _gt_inputls
	cmp r0, r5					@; Si
	bne .L_IPC_FIFO_putkey_notend @; Si no estem pel final actualitzem directament
	ldr r3, =_gt_inputl			@; Sino afegim 1 a la variable inputl
	ldrb r4, [r3]
	add r4, #1
	strb r4, [r3]
.L_IPC_FIFO_putkey_notend:
	bl _gt_putchar				@; Posem el caracter
	bl _gt_updatechar			@; Actualitzem el caracter
	@; Passem a pintar les tecles directament
.L_IPC_FIFO_paintkeys:
	lsr r3, r2, #10				@; Obtenim el codi de bits que ens indica el desplaçament al mapa de rajoles 
	lsr r4, r3, #9				@; Obtenim el nombre de rajoles a pintar
	ldr r7, =0x1FF
	and r3, r3, r7				@; Clean de la resta de bits
	and r4, r4, #0x7			@; Clean de la resta de bits
	sub r4, #1					@; Corregim un desplaçament
	lsl r3, #1					@; Multipliquem per 2 (halfwords)
	ldr r2, =_gt_mapbaseinfo	@; r2 = @@_gt_mapbaseinfo
	ldr r2, [r2]				@; r2 = @_gt_mapbaseinfo
	add r2, r3					@; Afegim la direccio base al desplaçament fins la primera posicio
	ldr r5, =351				@; Rajoleta de color lila
.L_IPC_FIFO_paintkeys_bucle:	@; Aquest bucle pinta tantes rajoles com s'indica en el registre
	lsl r6, r4, #1				@; Desplacem multiplicant per 2.
	strh r5, [r2, r6]			@; Anem a on indiqui l'index ja multiplicat per 2
	cmp r4, #0					@; Si l'index es 0 ja hem acabat
	beq .L_IPC_FIFO_end			@; Sortim
	sub r4, #1					@; Sino restem 1 i seguim iterant
	b .L_IPC_FIFO_paintkeys_bucle
.L_IPC_FIFO_end:
	pop {r0-r12, pc}

.end

