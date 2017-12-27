@;==============================================================================
@;
@;	"garlic_dtcm.s":	zona de datos básicos del sistema GARLIC 1.0
@;						(ver "garlic_system.h" para descripción de variables)
@;
@;==============================================================================

.section .dtcm,"wa",%progbits

	.align 2

	.global _gd_pidz			@; Identificador de proceso + zócalo actual
_gd_pidz:	.word 0

	.global _gd_pidCount		@; Contador global de PIDs
_gd_pidCount:	.word 0

	.global _gd_tickCount		@; Contador global de tics
_gd_tickCount:	.word 0

	.global _gd_sincMain		@; Sincronismos con programa principal
_gd_sincMain:	.word 0

	.global _gd_seed			@; Semilla para generación de números aleatorios
_gd_seed:	.word 0xFFFFFFFF

	.global _gd_nReady			@; Número de procesos en la cola de READY
_gd_nReady:	.word 0

	.global _gd_qReady			@; Cola de READY (procesos preparados)
_gd_qReady:	.space 16

	.global _gd_nDelay			@; Número de procesos en la cola de DELAY
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
_gd_percentatge:	.space 4	@; string amb el percentatge d'ús de CPU


@; progM
	.global quo
quo:	.space 4

	.global _gm_first_mem_pos	@; posición de memoria inicial donde cargar los programas 
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

	.global _gt_mapbaseinfo		@; Dirección del mapa de baldosas del bg0
_gt_mapbaseinfo: .space 4		

	.global _gt_mapbasebox		@; Dirección del mapa de baldosas del bg1
_gt_mapbasebox: .space 4

	.global _gt_mapbasecursor	@; Dirección del mapa de baldosas del bg2
_gt_mapbasecursor: .space 4		

	.global _gt_kbvisible		@; Indica la visibilitat del teclat
_gt_kbvisible: .space 1

	.global _gd_Keyboard			@; Cua de processos que esperen la entrada pel teclat
_gd_Keyboard: .space 16*1
	
	.global _gd_nKeyboard		@; Índex de l'array de processos esperant per teclat
_gd_nKeyboard: .space 1

	.global _gd_kbsignal		@; La funció _gt_getstring espera a que el bit corresponent al proces d'aquesta variable es posi a 1 
_gd_kbsignal: .space 2

	.global _gt_inputl			@; Contiene el número de caracteres que ha introducido el usuario
_gt_inputl: .space 1

	.global _gt_input			@; Vector de 28 caracteres introducidos. Al final he decidir fer-ho amb chars
_gt_input: .space 28*1

	.global _gt_cursor_pos	 	@; Posició del cursor
_gt_cursor_pos: .space 1

	.global _gt_PIDZ_tmp		@; Buffer de caracters que s'utilitza com a variable temporal per a mostrar PID i socol per pantalla
_gt_PIDZ_tmp: .space 6

	.global _gt_button_tics		@; Variable per a normalitzar la velocitat de reacció dels botons per part de la rsi de teclat
_gt_button_tics: .space 1
	
	.global _gt_XYbuttons		@; Variable que conté l'estat dels botons X i Y (bit 0 = 1; X apretat, sino soltat, bit 1 = 1; Y apretat, sino soltat)
_gt_XYbuttons: .space 1

	.global _gt_CAPS_lock		@; Variable booleana que indica si el bloc majúscules es troba activat (true) o n (false)
_gt_CAPS_lock: .space 1		

	@;.global _gt_set				@; Variable que conte els jocs de caracters (4 arrays de caracters (1 byte) de 30 posicions en dos sets diferents de caracters)
@;_gt_set: .space 30*4*2*1
	.global _gt_charsetmin			@; Sets de caracters per a CAPS_lock = false
_gt_charsetmin: .space 30*4

	.global _gt_charsetmaj			@; Sets de caracters per a CAPS_lock = true
_gt_charsetmaj: .space 30*4

.end

