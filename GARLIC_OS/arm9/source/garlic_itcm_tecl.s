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
	push {r1-r7, r12, lr}

	@; Ahora registraremos el proceso en la cola de espera del KB
	ldr r3, =_gd_nKeyboard			@; r3 = @_gd_Keyboardl
	ldrb r4, [r3]					@; r4 = _gd_Keyboardl
	ldr r5, =_gd_Keyboard			@; cargamos @base de la cola de espera del KB (vector de char)
	strb r2, [r5, r4]				@; guardamos el zócalo recibido por parámetro a la posicion
	add r4, #1						@; sumamos 1 al índice
	strb r4, [r3]					@; actualizamos el índice
	
	@; Mirem que la interficie estigui mostrada
	
	ldr r4, =_gt_kbvisible			@; r4 = @ _gt_visible
	ldrb r3, [r4]					@; r3 = _gt_visible
	cmp r3, #1						@; Si esta mostrada, vol dir que algu l'esta utilitzant
	beq .Lgtgetstr_pidzcode			@; Per tant passem aquest pas. Sino...
	mov r5, r0						@; r5 = @ string. Salvamos la dirección del string en r5
	mov r0, r2						@; Passada de parametres a _gt_showKB (espera el número de zócalo por r0)
	push {r0-r3}
	bl _gt_showKB 					@; mostramos la interficie para el proceso que llama a getstring
	pop {r0-r3}
	mov r0, r5						@; Recuperamos en r0 @ string
 
	@; Ara posarem a 1 el bit de mes pes de la variable _gd_pidz per indicar que es tracta dun proces que espera KB
.Lgtgetstr_pidzcode:
	ldr r3, = _gd_pidz				@; r3 = @_gd_pidz
	ldr r4, [r3]					@; r4 = _gd_pidz
	orr r4, r4, #0x80000000			@; fiquem a 1 el bit de més pes del pidz
	str r4, [r3]					@; Actualitzem la variable
	bl _gp_WaitForVBlank			@; Cridem a wait or virtual blank  per a forçar que es salvi el context del proces
	
	@; aqui continuara el proces que hagi sigut tret de la cua d'espera amb la rsi

	@; copiar el string leído sobre el vector que se ha pasado por parámetro, filtrando el número de caracteres leido 
	@;total de caracteres y añadiendo el centinela, y devolviendo
	@;el número total de caracteres leídos (excluido el centinela).
	ldr r3, =_gt_inputl				@; carreguem @ base de la variable de nombre de caracters
	ldrb r2, [r3]					@; r2 = nombre de caracters d'input
	add r2, #1						@; Sumem un a r2 per a tenir en compte el caracter centinella
	cmp r1, r2						@; Comparem el nombre de caracters d'input i la capacitat del string destí
	movlo r2, r1					@; r2 = nombre de caracters maxim (valor més limitant)
	
	cmp r2, #0						@; Si no hi ha res al buffer sortim. 
	beq .Lgtgetstr_copystrfi		@; 
	
	ldr r4, =_gt_input				@; r4 = @ base del vector de input
	mov r5, #0						@; r5 = comptador. Inicialitzem comptador
	
.Lgtgetstr_copystr:
	ldrsb r3, [r4, r5]				@; Carreguem signed (per a reconeixer caracter centinella) sobre r3. Conté el vector a tractar
	cmp r3, #-1						@; Si el caracter a llegir es -1 (final de linia)
	beq .Lgtgetstr_copystrfi		@; Afegim caracter de final de linia i sortim
	@;SI o estem al final
	strb r3, [r0, r5]				@; Guardem sobre l'string que rebem per parametre
	add r5, #1						@; Incrementem comptador
	cmp r5, r2						@; Si el comptador no es igual al valor maxim 
	bne .Lgtgetstr_copystr			@; tornem a iterar
.Lgtgetstr_copystrfi:
	mov r6, #0						@; Afegim el caracter de final de string (el \0 de tota la, vida)
	strb r6, [r0, r5]				@; Guardem el caracter de final de linia
	
	push {r0-r3}
	bl _gt_resetKB					@; resetegem per al següent us
	bl _gt_hideKB					@; Amaguem interficie de teclat
	pop {r0-r3}
		
	@; Ara mostrarem la interficie per al següent proces que utilitzara el teclat. Per a fer-ho cal que primer eliminem 
	@; el primer proces que espera teclat (aixo ho fara la rsi) per a que al carregar _gd_Keybard[0] obtinguem el socol 
	@; del seguent proces
	ldr r3, =_gd_nKeyboard			@; Cargamos la @ de la varible que tiene el numero de procesos esperando 
	ldrb r4, [r3]					@; r4 = num procesos
	cmp r4, #0						@; Si el nombre de processos es 0, sortim sense mostrar interficie
	beq .L_getstring_error			@; Sortim
	ldr r0, =_gd_Keyboard			@; Carreguem @ cua de teclat	
	ldrb r0, [r0]					@; Carreguem el primer byte (socol del següent proces)
	push {r0-r3}
	bl _gt_showKB 					@; mostramos la interficie para el proceso en la posicion 0 de la cola
	pop {r0-r3}
	
	mov r0, r2						@; Retorn de parametres
.L_getstring_error:
	pop {r1-r7, r12, pc}			
		
	
	.global _gt_cursorini
	@; Inicialitza el cursor en la primera posicio
_gt_cursorini:
	push {r0-r1, lr}
	ldr r0, =_gt_mapbasecursor	@; r0 = @@ del mapa de rajoletes del cursor
	ldr r0, [r0] 				@; r0 = @ el mapa del rajoletes
	add r0, #(32*2+1)*2			@; Anem a la capsa de text en el mapa del cursor 			
	ldr r1, =128*2+97				@; carreguem a r1 la rajoleta de cursor (ratlla per la part de sota)
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
	add r2, #(32*2+1)*2			@; desplacem fins a la linia del cursor
	mov r3, #0					@; r3 = 0 (casella transparent)
	strb r3, [r0] 				@; cursor a la posicio 0
	strh r3, [r2, r1] 			@; borra el cursor de la posicio on estigui
	bl _gt_cursorini			@; posa cursor a la primera posicio grafica

	mov r0, #0					@; r0 = 0 (comptador)
	mov r1, #-1					@; r1 = -1
	ldr r2, =_gt_input			@; r2 = @_gt_input 
	ldr r3, =_gt_inputl			@; r3 = @_gt_inputl
	ldrb r4, [r3]				@; r4 = _gt_inputl
.Lgtr_clean_input:
	strb r1, [r2, r0]			@; actualitza la posicio i amb un -1 ( centinella)
	bl _gt_updatechar			@; actualitza el caracter
	add r0, #1					@; afegeix a l'index
	cmp r0, r4					@; mentre no haguem arribat al final del string					
	blo .Lgtr_clean_input		@; seguim netejant l'string d'entrada

	mov r1, #0					@; r1 = 0
	strb r1, [r3]				@; reiniciem la quantitat de input
	
	pop {r0-r4, pc}
	
	
		.global _gt_updatechar
	@; Consulta un determinat caracter al vector _gt_input i actualitza el mapa de rajoletes amb la rajoleta corresponent
	@;Parámetros:
	@; R0: pos -> index del caracter a actualitzar
_gt_updatechar:
	push {r0-r3, lr}

	ldr r1, =_gt_mapbasebox		@; r1 = @@_gt_mapbasebox
	ldr r1, [r1] 				@; r1 = @_gt_mapbasebox
	add r1, #(32*2+1)*2			@; direccio d'inici del quadre de text
	ldr r2 , =_gt_input			@; r2 = @_gt_input	
	ldrsb r2, [r2, r0]			@; carrega a r2 el caracter a on apunta l'index passat per parametre (signed per a centinella)
	cmp r2, #-1					@; Si el caracter que ens estan dient que actualitzem es el de final de linea

	moveq r2, #0				@; Posem el caracter negre com de buit
	moveq r3, #95				@; rajola blanca
	@;Sino
	subne r2, #32				@; Restem per a corregir (transformem ASCII en codificació rajola)
	movne r3, #128+95			@; rajola blava
	
	lsl r0, #1					@; Multipliquem per dos el desplaçament (anem amb halfwords)
	strh r2, [r1, r0]			@; I guardem sobre el mapa de rajoletes a la posicio que toca. 

	ldr r1, =_gt_mapbaseinfo	
	ldr r1, [r1]				@; Obtenim punter
	add r1, r0					@; Calculem desplaçament (@ mapbase + desplaçament fins rajoles quadre de text + posicio ultim caracter) 
	add r1, #(32*2+1)*2
	strh r3, [r1]				@; Guardem la rajola seleccionada (de text o de buit) a la posicio que toca

.L_gt_updatechar_exit:
	pop {r0-r3, pc}
	
.global _gt_movecursor
	@; Mueve el cursor una posicion a la derecha si r0==0 i sinolo mueve a la izquierda
	@; R0: direccion  (o derecha 1 izquierda)
_gt_movecursor:
	push {r0-r6, lr}

	cmp r0, #0
	movne r0, #-1				@; Si tirem a l'esquerra posem un -1
	
	ldr r3, =_gt_inputl
	ldrb r3, [r3]				@; r3 = Inputlength
	ldr r2, =_gt_cursor_pos
	ldrb r1, [r2]				@; r1 = posicio del cursor
	
	cmp r0, #0					@; Si anem a la dreta
	cmpeq r1, r3				@; SI la posicio del cursor i la quantitat de tecles es igual
	beq .L_gt_movecursor_end	@; Sortim perque no farem res
	cmp r1, #29					@; aquest es implicitament un cmpne. @;si la pos del cursor es maxima
	beq .L_gt_movecursor_end	@;Sortim
	cmp r0, #0					@; Si la direccio es esquerra
	cmpne r1, #1				@; i estem a la posicio 0
	blt .L_gt_movecursor_end	@; sortim
	
	@; Aqui arriben les crides "productives" de moure el cursor
	ldr r3, =_gt_mapbasecursor	@; r0 = @@_gt_mapbasecursor
	ldr r3, [r3] 				@; r0 = @_gt_mapbasecursor
	add r3, #(32*2+1)*2			@; Anem a la linea de la caixa de text
	lsl r5, r1, #1 				@; calculem desplacament en un vector de halfowrd
	
	mov r4, #0					@; Carreguem rajoleta de buit
	strh r4, [r3, r5] 			@; escriu buida a la posicio actual
	
	cmp r0, #0
	moveq r0, #1				@; Si tirem a la dreta posem un 1
	
	add r1, r0 					@; sumem o restem una posicio al cursor
	strb r1, [r2]				@; actualitzem el cursor
	
	add r5, r0 					
	add r5, r0 					@; Sumem la pos que falta (posicio del costat en un vector de halfwords)	

	ldr r4, =128*2+97				@; carreguem un cursor a r4
	strh r4, [r3, r5]			@; I posem el cursor a la nova posicio
.L_gt_movecursor_end:
	pop {r0-r6, pc}
	
	
		.global _gt_getchar
	@; Obtiene el caracter de la posicion indicada del vector de caracteres
	@;Parámetros:
	@; R0: pos -> Índice del carácter
	@;Retorna:
	@; R0: char -> caracter en la posicion recibida por parámetro
_gt_getchar:
	push {r1, lr}
	ldr r1 , =_gt_input		@; r1 = @_gt_input
	ldrsb r0, [r1, r0]		@; r0 = _gt_input[r0] -> Caracter desitjat
	pop {r1, pc}
	

		.global _gt_putchar
	@; Coloca el caracter recibido por paràmetro sobre el vector de caracteres
	@;Parámetros:
	@; R0: pos -> Índice del caracter a actualizar
	@; R1: char -> caracter a introducir
_gt_putchar:
	push {r0-r2, lr}
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
	@;mvn r0, r0					@; Neguem per a canviar els bits i fer que apretar sigui 1
	and r0, r0, #0x3			@; Fem un clean dels dos primers bit, ja que son els unics que ens interessen
	
	ldr r1, =_gt_XYbuttons		@; r1 = @_gt_XYbuttons
	strb r0, [r1]				@; Guardem els dos bits de menys pes del registre IPC_SYNC del ARM9 a la variable _gt_XYbuttons
	pop {r0-r1, pc}
	
	@; Trata la informacion recibida a traves del sistema IPC_FIFO, utilizada por arm7 para enviar
	@; informacion la ultima pulsacion sobre la interficie de teclado.
	@; Debido a que además de tener unos caracteres que añadir al buffer, hay que "pintar" unos
	@; determinados cuadros de la interficie de teclado segun la tecla a pulsar, arm7 se encarga 
	@; de hacer las comprobaciones logicas pertinentes para quitarle codigo a la rsi y facilitar 
	@; su trabajo. Concretamente, se ha implementado un tipo de mensaje que la rsi debe interpretar
	@; para procesar la interrupcion. La estructura del mensaje es el siguiente:
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
	@;		bits 3-9: Desplazamiento absoluto para llegar a la posicion del array de caracteres correspondiente
	@; 		_gt_minset o _gt_majset. Esto nos dara el caracter a añadir al buffer
	@;		bits 10-18: Desplazamiento hasta la posicion inicial de la tecla pulsada en el mapa de 
	@;		baldosas. Esto nos indica a partir de qué baldosa hay que actualizar el dibujo ( resaltar)
	@;		bits 19-21: Numero de casillas (ncas) a pintar desde la posicion inicial de tecla en el mapa
	@;		de baldosas.
	@;		bit 22: Si está a 1 indica que la tecla se acaba de dejar de pulsar y por tanto debe volver al estado original
	@;		(baldosas normales). Para estos casos el mensaje és exactamente igual al de la IRQ anterior





	.global _gt_rsi_IPC_FIFO
_gt_rsi_IPC_FIFO: 
	push {r0-r8, lr}
	mov r2, #0x04100000 		@; r2 = @IPC_FIFO_RECV
	ldr r2, [r2]				@; r3 = IPC_FIFO_RECV
	
	ldr r0, =_gt_kbvisible		@; Comprovem la visibilitat del teclat
	ldrb r0, [r0]
	tst r0, #1
	beq .L_IPC_FIFO_end			@; Si no essta mostrat sortim, sino analitzem el missatge

	tst r2, #0x400000			@; Testegem bit 22 a 1 de soltar tecla
	movne r8, #128*1+95			@; r8 codi de casella! Si esta a 1 indiquem el codi de casella a posar (la blava, i sino la lila ) aixi es pot reaprofitar el paintkeys
	bne .L_IPC_FIFO_paintkeys	@; Pintem rajoletes, ja que no hem de interpretar cap tecla
	ldreq r8, =128*2+95			@; r8 conte el codi de casella 
	
	and r3, r2, #0x7			@; r3 = IPC_FIFO_RECV & 0x7. Obtenemos tres primeros bits del mensaje recibido
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
	@; Amaguem el teclat
	push {r0-r5}
	bl _gt_hideKB
	pop {r0-r5}
	b .L_IPC_FIFO_end
	
.L_IPC_FIFO_KEY_RIGHT:
	
	mov r0, #0
	bl _gt_movecursor
	
	b .L_IPC_FIFO_paintkeys		@; Anem a pintar rajoletes
	
.L_IPC_FIFO_KEY_LEFT:

	mov r0, #1
	bl _gt_movecursor

	b .L_IPC_FIFO_paintkeys		@; Anem a pintar caselles 

.L_IPC_FIFO_INTRO:
	ldr r0, =_gd_nKeyboard		@; r0 = @_gd_nKeyboard
	ldrb r1, [r0]				@; r1 = _gd_nKeyboard
	sub r1, #1					@; disminuim en un el nombre de processos
	strb r1, [r0]				@; actualitzem el nombre de processos
	cmp r1, #0					@; Si no hi ha cap procés sortim (situacio impossible, activada per debug //)
	beq .L_IPC_FIFO_end 		@; Sortim
	mov r3, #0					@; inicialitzem comptador
	ldr r5, =_gd_Keyboard		@; Carreguem direccio r5 = @ _gd_Keyboard
	ldrb r0, [r5]				@; Salvem socol del proces per a colocarlo despres a la cua de ready
.Lgtrsi_START_move:
	add r3, #1					@; afegim un al comptador
	ldrb r4, [r5, r3]			@; carreguem a r4 el socol del proces a _gd_Keyboard[i+1]
	sub r3, #1					@; restem 1 per a anar a la posicio anterior
	strb r4, [r5, r3]			@; guardem a la posicio _gd_Keyboard[i] movent un proces
	add r3, #1					@; Afegim 1 per a compensar el que hem restat abans
	cmp r1, r3					@; mirem si hem arribat al final de la cua de processos
	bne .Lgtrsi_START_move		@; si no hem arribat saltem
	ldr r1, =_gd_nReady			@; Carreguem direccio de nReady
	ldr r3, [r1]				@; obtenim el nombre de processos esperant (es un word)
	ldr r4, =_gd_qReady			@; Obtenim direccio de la cua de ready
	strb r0, [r4, r3]			@; Posem el nou proces a la ultima posicio de la cua de ready
	add r3, #1					@; Afegim un proces esperant
	str r3, [r1]				@; Actualitzem variable
	b .L_IPC_FIFO_paintkeys		@; Si hem aribat anem a pintar les caselles, tot i que en aqeust cas potser no es veuen

.L_IPC_FIFO_DEL:
	ldr r3, =_gt_inputl			@; r3 = @ _gt_inputl
	ldrb r5, [r3]				@; r5 = _gt_inputl
	cmp r5, #0					@; Si _gt_inputl és 0
	beq .L_IPC_FIFO_end			@; Sortim perque el select no farà res
	
	sub r5, #1					@; Per tant hi haura un caracter menys
	strb r5, [r3]				@; Actualitzem variable
	
	ldr r6, =_gt_cursor_pos		@; r6 = @ index cursor
	ldrb r4, [r6] 				@; r4 = index cursor
	mov r0, r4					@; Guardem index cursor a r0 per a passar parametres
	bl _gt_getchar				@; Obtenim el caracter
	
	cmp r0, #-1 				@; Si el caracter que es vol borrar es -1, estem al final de vector
	bne .L_IPC_FIFO_DEL_MIDDLE	@; Per tant borrarem caracter del mig (comportament suprimir). I sino... borrarem caracter de final de linia i mourem el cursor
	bl _gt_movecursor			@; movem el cursor una posicio a la esquerra
	mov r1, #-1					@; Carreguem un caracter de final de linia
	sub r0, r4, #1				@; carreguem la posicio actual del cursor 
	bl _gt_putchar				@; posem el nou caracter buit al array
	bl _gt_updatechar			@; Actualitzem rajoles
	b .L_IPC_FIFO_paintkeys
	
.L_IPC_FIFO_DEL_MIDDLE:
	
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
	push {r0-r3, r12}			@; Salvem registres
	bl _gt_graf					@; Cridem a la funcio _gt_graf, que ens fa tot el que necesitem
	pop {r0-r3,r12}				@; Recuperem
	b .L_IPC_FIFO_end			@; Sortim

.L_IPC_FIFO_SPACE:
	ldr r3, =_gt_cursor_pos		@; r3 = @ posicio del cursor
	ldrb r4, [r3]				@; r4 = posicio del cursor
	ldr r5, =_gt_inputl			@; r5 = @ numero de caracters
	ldrb r6, [r5]				@; r6 = numero de caracters
	
	mov r0, r4					@; r0 = pos_cursor
	mov r1, #0					@; Carreguem un 0 (rajoleta d'espai)
	bl _gt_putchar				@; Posem una rajola buida a la pos del cursor
	bl _gt_updatechar			@; Actualitzem rajoles
	
	cmp r4, r6					@; Si el cursor no esta al final del string
	bne .L_IPC_FIFO_paintkeys	@; anem a pintar
	@; i sino afegim un a inputl
	add r6, #1					@; r6 = _gt_inputl++
	strb r6, [r5]				@; Actualitzem valor de input
	ldr r3, =_gt_input			@; direccio al array de input
	
	mov r0, #0
	bl _gt_movecursor
	
	b .L_IPC_FIFO_paintkeys		@; i anem a pintar
	
	
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
	
.L_IPC_FIFO_putkey_notend:
	bl _gt_putchar				@; Posem el caracter
	bl _gt_updatechar			@; Actualitzem el caracter
	
	ldr r4, =_gt_inputl			@; r4 = @ _gt_inputl
	ldrb r5, [r4]				@; r5 = _gt_inputls
	cmp r0, r5					@; Si
	bne .L_IPC_FIFO_paintkeys	@; Si pos cursor != _gt_inputl, no estem pel final per tant actualitzem directament
	add r5, #1
	strb r5, [r4]
	
	mov r0, #0
	bl _gt_movecursor			@; Movem un a la dreta per a facilitar l'escriptura
	
	@; Passem a pintar les tecles directament
.L_IPC_FIFO_paintkeys:
	
	and r3, r2, #0x7			@; Obbtenim codi de casella
	cmp r3, #2					@; Comparem amb 2
	beq .L_IPC_FIFO_end			@; Si es la tecla caps sortim perque tot ho fa _gt_graf

	lsr r3, r2, #10				@; r3 = Obtenim el codi de bits que ens indica el desplaçament al mapa de rajoles 
	lsr r4, r3, #9				@; r4 = Obtenim el nombre de rajoles a pintar
	ldr r7, =0x1FF				@; r7 = la mascara de 9 bits
	and r3, r3, r7				@; Clean de la resta de bits
	and r4, r4, #0x7			@; Clean de la resta de bits
	sub r4, #1					@; Corregim un desplaçament
	lsl r3, #1					@; Multipliquem per 2 (halfwords)
	ldr r2, =_gt_mapbaseinfo	@; r2 = @@_gt_mapbaseinfo
	ldr r2, [r2]				@; r2 = @_gt_mapbaseinfo
	add r2, r3					@; Afegim la direccio base al desplaçament fins la primera posicio
.L_IPC_FIFO_paintkeys_bucle:	@; Aquest bucle pinta tantes rajoles com s'indica en el registre
	lsl r6, r4, #1				@; Desplacem multiplicant per 2.
	strh r8, [r2, r6]			@; Rajoleta del color que toqui (s'escolleix al principi de la rsi). Anem a on indiqui l'index ja multiplicat per 2
	cmp r4, #0					@; Si l'index es 0 ja hem acabat
	beq .L_IPC_FIFO_end			@; Sortim
	sub r4, #1					@; Sino restem 1 i seguim iterant
	b .L_IPC_FIFO_paintkeys_bucle
	
.L_IPC_FIFO_end:
	pop {r0-r8, pc}

.end

