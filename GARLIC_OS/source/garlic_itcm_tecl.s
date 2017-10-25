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
	@; si la interfaz de teclado está desactivada (oculta), mostrarla
	@;	(ver punto 8) y activar la RSI de teclado (ver punto 9).
	@;• añadir el número de zócalo sobre un vector global
	@;_gd_kbwait[], que se comportará como una cola en la cual
	@;estarán registrados los procesos que esperan la entrada de
	@;un string por teclado,
	@;• esperar a que el bit de una variable global _gd_kbsignal,
	@;correspondiente al número de zócalo indicado, se ponga a 1,
	@;• poner el bit anterior a cero, copiar el string leído sobre el
	@;vector que se ha pasado por parámetro, filtrando el número
	@;total de caracteres y añadiendo el centinela, y devolviendo
	@;el número total de caracteres leídos (excluido el centinela).
_gt_getstring:
	push {r1-r7, lr}
	
	@; si KB IF oculta -> KB IF visible i activamos interrupciones de teclado
	
	ldr r4, =_gt_kbvisible		@; Cargamos @ de _gt_visible
	ldrb r3, [r4]				@; r3 = _gt_visible
	cmp r3, #1					@; Comprovamos si la interfaz de teclado está activada...
	beq .Lgtgetstr_showed		@; Si es así nos saltamos este paso
	
	mov r5, r0					@; r5 = @ string. Salvamos la dirección del string en r5
	mov r0, r2					@; Passada de parametres a _gt_showKB (espera el número de zócalo por r0)
	bl _gt_showKB 				@; si o esta mostrada mostramos la interfaz
	mov r0, r5					@; Recuperamos en r0 @ string
	mov r3, #1					@; cargamos un 1 en r3,
	strb r3, [r4]				@; indicamos que se esta mostrando,
	@;ldr r3, =0x04000132			@; cargamos dirección del registro REG_KEYCNT,
	@;ldrh r4, [r3]				@; cargamos el contenido de este registro,
	@;orr r4, #0x2000				@; activamos el bit de RSIs general de teclado y
	@;strh r4, [r3]				@; salvamos en el registro
	
	@; Ahora registraremos el proceso en la cola de espera del KB
	
	.Lgtgetstr_showed:			
	ldr r3, =_gd_kbwait_num		@; Cargamos la @ el numero de procesos esperando 
	ldrsb r4, [r3]				@; r4 = num procesos
	ldr r5, =_gd_kbwait			@; cargamos @base de la cola de espera del KB (vector de char)
	strb r2, [r5, r4]			@; guardamos el zócalo recibido por parámetro a la posicion
	strb r4, [r3]				@; actualizamos el índice

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
	ldrsb r2, [r3]				@; r2 = nombre de caracters d'input
	cmp r1, r2					@; Comparem el nombre de caracters d'input i la capacitat del string destí
	movlo r2, r1				@; r2 = nombre de caracters maxim (valor més limitant)
	ldr r4, =_gt_input			@; r4 = @ base del vector de input
	mov r5, #0					@; r5 = comptador. Inicialitzem comptador

.Lgtgetstr_copystr:
	@;mov r6, r5, lsl #1			@; Multipliquem per 2 (deplaçament en un vector de halfwords)
	ldrsb r3, [r4, r5]			@; Carreguem signed (per a reconeixer caracter centinella) sobre r3. Conté el vector a tractar
	cmp r3, #-1					@; Mirem que no sigui caracter de final de linea
	beq .Lgtgetstr_copystrfi	@; Si es sortim
	add r3, #32					@; Factor de correcció per a transformar al codi ASCII
	strb r3, [r0, r5]			@; Guardem sobre l'string que rebem per parametre
	add r5, #1					@; Incrementem comptador
	cmp r5, r2					@; Si el comptador no es igual al valor maxim 
	bne .Lgtgetstr_copystr		@; tornem a iterar
.Lgtgetstr_copystrfi:
	mov r6, #0					@; Afegim el caracter de final de string (el \0 de tota la vida)
	strb r6, [r0, r5]			@; Guardem el caracter de final de linia
	
	mov r0, r2					@; Retorn de parametres
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
	ldr r1, [r0]				@; r1 = _gt_cursor_pos
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
	
	
	
	
	
	@; Controla el uso del teclado a través de interrupciones causadas por las teclas

	.global _gt_rsiKB
_gt_rsiKB:
	push {r0-r4, lr}
	ldr r0, =0x04000130 @; r0 = @REG_KEYINPUT
	ldrh r0, [r0]		@; r0 = REG_KEYINPUT
	
	@; testear bits a 0 para las diferentes teclas 
	
	@; KEY_A
	tst r0, #0x0001
	beq .Lgtrsi_A
		
	@; KEY_B
	tst r0, #0x0002
	beq .Lgtrsi_B
		
	@; KEY_SELECT
	tst r0, #0x0004
	beq .Lgtrsi_SELECT
	
	@; KEY_START
	tst r0, #0x0008
	beq .Lgtrsi_START
	
	@; KEY_LEFT
	tst r0, #0x0020 
	beq .Lgtrsi_LEFT
		
	@; KEY_RIGHT
	tst r0, #0x0010
	beq .Lgtrsi_RIGHT
		
	b .Lgtrsi_end				@; Si no coincideix amb res
	
	@; KEY_A 
.Lgtrsi_A:
	ldr r2, =_gt_cursor_pos		@; r2 = @index cursor
	ldrsb r2, [r2] 				@; r2 = index cursor
	mov r0, r2					@; Passada de parámetres
	bl _gt_getchar 				@; obtenim caracter a la posicio indicada
	cmp r0, #127 				@; Si es l´últim carácter codificable
	beq .Lgtrsi_end				@; Sortim (el botó A no farà cap acció)

	cmp r0, #-1					@; Si no estamos en la última posición escribible
	bne .Lgtrsi_A_end 			@; vamos directamente a incrementar caracter
	ldr r3, =_gt_inputl			@; Si estamos en la última posicion, r3 = @_gt_inputl
	ldrsb r4, [r3]				@; r4 = _gt_inputl
	add r4, #1					@; _gt_inputl++
	strb r4, [r3]				@; Actualiza valor de _gt_inputl
	
.Lgtrsi_A_end:
	add r0, #1 					@; Incrementem carácter
	mov r1, r0					@; r1 = carácter a posar
	mov r0, r2					@; posicio del cursor
	bl _gt_putchar				@; Coloquem el carácter
	
	bl _gt_updatechar			@; actualitzem el caracter per pantalla
	b .Lgtrsi_end 
	
	@; KEY_B 
.Lgtrsi_B:
	ldr r2, =_gt_cursor_pos		@; r2 = @index cursor
	ldrsb r2, [r2] 				@; r2 = index cursor
	mov r0, r2					@; r0 = r2, passada de parametres
	bl _gt_getchar				@; Obtenim caracter a la posicio del cursor

	cmp r0, #0 					@; Si estem en el caracter minim
	ble .Lgtrsi_end				@; El botó B no farà res

	sub r0, #1 					@; Decrementem el caracter 

	mov r1, r0					@; r1 = caracter a colocar
	mov r0, r2					@; r0 = index del cursor
	bl _gt_putchar 				@; Posem el nou caracter modificat 

	bl _gt_updatechar 			@; actualitzem per pantalla
	b .Lgtrsi_end 
	
	@; KEY_SELECT 
.Lgtrsi_SELECT:
	ldr r2, =_gt_cursor_pos		@; r2 = @ index cursor
	ldrsb r4, [r2] 				@; r4 = index cursor
	ldr r3, =_gt_inputl			@; r3 = @ _gt_inputl
	ldrsb r5, [r3]				@; r5 = _gt_inputl
	
	cmp r5, #0					@; Si _gt_inputl és 0
	beq .Lgtrsi_end				@; Sortim perque el select no farà res
	
	mov r0, r4					@; Guardem index cursor a r0 per a passar parametres
	bl _gt_getchar				@; Obtenim el caracter
	cmp r0, #-1 				@; Si el caracter que es vol borrar es -1
	beq .Lgtrsi_end				@; surt (select no fara res)
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
	
	b .Lgtrsi_end 				@; sortim de la rsi
	
	
	@; KEY_START 
.Lgtrsi_START:
	ldr r2, =_gd_kbwait			@; r2 @ _gd_kbwait	
	ldrb r4, [r2]				@; r4 socol del proces a _gd_kbwait[0] 
	mov r0, #1					@; carreguem un 1 a r2
	lsl r0, r4 					@; Desplacem tants bits com nombre de socol
	ldr r1, =_gd_kbsignal		@; r1 = @ _gd_kbsignal
	ldrh r3, [r1]				@; r3 = _gd_kbsignal
	orr r3, r0					@; Sumem els bits actius a _gd_kbsignal amb el bit de procés que estem tractant actualment
	strh r3, [r1]				@; actualitzem valor de _gd_kbsignal i donem senyal a _gt_getstring per a que continui
	
	ldr r0, =_gd_kbwait_num		@; r0 = @_gd_kbwait_num
	ldrb r1, [r0]				@; r1 = _gd_kbwait_num
	sub r1, #1					@; disminuim en un el nombre de processos
	strb r1, [r0]				@; actualitzem el nombre de processos
	
	mov r3, #0					@; inicialitzem comptador
.Lgtrsi_START_move:
	add r3, #1					@; afegim un al comptador
	ldrb r4, [r2, r3]			@; carreguem a r4 el socol del proces a _gd_kbwait[i+1]
	sub r3, #1					@; restem 1 per a anar a la posicio anterior
	strb r4, [r2, r3]			@; guardem a la posicio _gd_kbwait[i] movent un proces
	add r3, #1					@; Afegim 1 per a compensar el que hem restat abans
	cmp r1, r3					@; mirem si hem arribat al final de la cua de processos
	bne .Lgtrsi_START_move		@; si no hem arribat saltem
	

	b .Lgtrsi_end				@; i sortim
	
	
	@; KEY_LEFT 
.Lgtrsi_LEFT:
	ldr r0, =_gt_cursor_pos		@; Carreguem @ de la posicio del cursor
	ldrsb r1, [r0]				@; r1 = posicio del cursor
	cmp r1, #0 					@; Comprovem si estem posicio 0
	beq .Lgtrsi_end				@; Si es així final de bucle perque aquest botó no farà res
 
	sub r1, #1 					@; sino restem 1 posicio i 
	strb r1, [r0]				@; actualitzem variable

	ldr r0, =_gt_mapbasecursor	@; r0 = @@ del mapa de rajoletes del cursor
	ldr r0, [r0] 				@; r0 = @ el mapa del rajoletes
	add r0, #260				@; Anem a la següent linia de la capsa de text en el mapa del cursor 
	mov r1, r1, lsl #1 			@; calculem desplacament (halfwords)
			
	mov r2, #99					@; carreguem a r2 la rajoleta de cursor (ratlla per la part de dalt)
	strh r2, [r0, r1] 			@; carrega el cursor a la posicio anterior
			
	add r1, #2					@; i a la següent posicio
			
	mov r2, #0					@; carreguem un 0
	strh r2, [r0, r1] 			@; I posem una rajoleta de 0 (negre) per borrar el cursor de la posicio original
	b .Lgtrsi_end 
		
	@; KEY_RIGHT 
.Lgtrsi_RIGHT:
	ldr r0, =_gt_cursor_pos		@; Carreguem @ de la posicio del cursor
	ldrsb r1, [r0]				@; r1 = posicio del cursor
	ldr r2, =_gt_inputl			@; r2 = @_gt_inputl
	ldrsb r2, [r2]				@; r2 = _gt_inputl
	cmp r1, r2 					@; Comprovem si estem al final
	beq .Lgtrsi_end				@; si estem la fletxeta no fara re i sortim
	cmp r1, #27 				@; Comprovem si estem al final del buffer
	beq .Lgtrsi_end				@; si ho estem sortim perque la fletxeta no fara re
 
	@; Sino
 
	add r1, #1 					@; sumem 1 posicio al cursor
	strb r1, [r0]				@; actualitzem el cursor

	ldr r0, =_gt_mapbasecursor	@; r0 = @@_gt_mapbasecursor
	ldr r0, [r0] 				@; r0 = @_gt_mapbasecursor
	add r0, #260				@; Anem a la següent linea de la caixa de text
		
	lsl r1, #1 					@; calculem desplacament en un vector de halfowrd
			
	mov r2, #99					@; Carreguem rajoleta de cursor
	strh r2, [r0, r1] 			@; escriu cursor a la posicio següent
			
	sub r1, #2					@; resta dos per a l'índex
			
	mov r2, #0					@; carreguem un 0 a r2
	strh r2, [r0, r1]			@; I borrem el cursor
	b .Lgtrsi_end 
	
	
.Lgtrsi_end:
	pop {r0-r4, pc}
.end

