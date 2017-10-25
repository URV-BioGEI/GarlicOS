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

	.global _gd_seed			@; Semilla para generación de números aleatorios
_gd_seed:	.word 0xFFFFFFFF

	.global _gd_nReady			@; Número de procesos en la cola de READY
_gd_nReady:	.word 0

	.global _gd_qReady			@; Cola de READY (procesos preparados)
_gd_qReady:	.space 16

	.global _gd_pcbs			@; Vector de PCBs de los procesos activos
_gd_pcbs:	.space 16 * 6 * 4

	.global _gd_wbfs			@; Vector de WBUFs de las ventanas disponibles
_gd_wbfs:	.space 4 * (4 + 32)

	.global _gd_stacks			@; Vector de pilas de los procesos activos
_gd_stacks:	.space 15 * 128 * 4

<<<<<<< HEAD
@;VARIABLES GLOBALS AFEGIDES
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

	.global _gd_kbwait			@; Cua de processos que esperen la entrada pel teclat
_gd_kbwait: .space 16*1
	
	.global _gd_kbwait_num		@; Índex de l'array de processos esperant per teclat
_gd_kbwait_num: .space 1

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

.end
=======
	.global _gm_first_mem_pos	@; posición de memoria inicial donde cargar los programas 
_gm_first_mem_pos: .word 0x01002000 
>>>>>>> origin/progM

	.global quo
quo:    .space 4
.end