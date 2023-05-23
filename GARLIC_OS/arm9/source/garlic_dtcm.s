@;==============================================================================
@;
@;	"garlic_dtcm.s":	zona de datos b�sicos del sistema GARLIC 1.0
@;						(ver "garlic_system.h" para descripci�n de variables)
@;
@;==============================================================================

.section .dtcm,"wa",%progbits

	.align 2

	.global _gd_pidz	 		@; Identificador de proceso + z�calo actual
_gd_pidz:	.word 0

	.global _gd_pidCount		@; Contador global de PIDs
_gd_pidCount:	.word 0

	.global _gd_tickCount		@; Contador global de tics
_gd_tickCount:	.word 0

	.global _gd_sincMain		@; Sincronismos con programa principal
_gd_sincMain:	.word 0

	.global _gd_seed			@; Semilla para generaci�n de n�meros aleatorios
_gd_seed:	.word 0xFFFFFFFF

	.global _gd_nReady			@; N�mero de procesos en la cola de READY
_gd_nReady:	.word 0

	.global _gd_qReady			@; Cola de READY (procesos preparados)
_gd_qReady:	.space 16

	.global _gd_nDelay			@; N�mero de procesos en la cola de DELAY
_gd_nDelay:	.word 0

	.global _gd_qDelay			@; Cola de DELAY (procesos retardados)
_gd_qDelay:	.space 16 * 4

	.global _gd_pcbs			@; Vector de PCBs de los procesos activos
_gd_pcbs:	.space 16 * 6 * 4

	.global _gd_wbfs			@; Vector de WBUFs de las ventanas disponibles
_gd_wbfs:	.space 16 * (4 + 64)

	.global _gd_stacks			@; Vector de pilas de los procesos activos
_gd_stacks:	.space 15 * 128 * 4

	.global _gd_res
_gd_res:	.word 0				@; resultat del residu

	.global _gd_percentatge
_gd_percentatge:	.space 4	@; string amb el percentatge d'�s de CPU


@; progM
	.global quo
quo:	.space 4

	.global _gm_first_mem_pos	@; posici�n de memoria inicial donde cargar los programas 
_gm_first_mem_pos: .word 0x01002000 

	.global res
res:    .space 4

@;VARIABLES GLOBALS AFEGIDES

@; progT
	.global _gt_bginfo			@; Fondo de prioridad 2, muestra info del teclado
_gt_bginfo: .space 4

	.global _gt_bgbox			@; Fondo de prioridad 1, cuadro de entrada de texto
_gt_bgbox: .space 4

	.global _gt_bgcursor		@; Fondo de prioridad 0, cursor
_gt_bgcursor: .space 4

	.global _gt_mapbaseinfo		@; Direcci�n del mapa de baldosas del bg0
_gt_mapbaseinfo: .space 4		

	.global _gt_mapbasebox		@; Direcci�n del mapa de baldosas del bg1
_gt_mapbasebox: .space 4

	.global _gt_mapbasecursor	@; Direcci�n del mapa de baldosas del bg2
_gt_mapbasecursor: .space 4		

	.global _gt_kbvisible		@; Indica la visibilitat del teclat
_gt_kbvisible: .space 1

	.global _gd_Keyboard			@; Cua de processos que esperen la entrada pel teclat
_gd_Keyboard: .space 16*1
	
	.global _gd_nKeyboard		@; �ndex de l'array de processos esperant per teclat
_gd_nKeyboard: .space 1

	.global _gd_kbsignal		@; La funci� _gt_getstring espera a que el bit corresponent al proces d'aquesta variable es posi a 1 
_gd_kbsignal: .space 2

	.global _gt_inputl			@; Contiene el n�mero de caracteres que ha introducido el usuario
_gt_inputl: .space 1

	.global _gt_input			@; Vector de 30 caracteres introducidos. Ha passat de 28 a 30 perque ara el text box es mes gran
_gt_input: .space 31*1

	.global _gt_cursor_pos	 	@; Posici� del cursor
_gt_cursor_pos: .space 1

	.global _gt_PIDZ_tmp		@; Buffer de caracters que s'utilitza com a variable temporal per a mostrar PID i socol per pantalla
_gt_PIDZ_tmp: .space 6
	
	.global _gt_XYbuttons		@; Variable que cont� l'estat dels botons X i Y (bit 0 = 1; X apretat, sino soltat, bit 1 = 1; Y apretat, sino soltat)
_gt_XYbuttons: .space 1

	.global _gt_CAPS_lock		@; Variable booleana que indica si el bloc maj�scules es troba activat (true) o n (false)
_gt_CAPS_lock: .space 1		


.end

