@;==============================================================================
@;
@;	"garlic_vector.s":	vector de direcciones de rutinas del API de GARLIC 2.0
@;
@;==============================================================================

.section .vectors,"a",%note


APIVector:						@; Vector de direcciones de rutinas del API
	.word	_ga_pid				@; (código de rutinas en "garlic_itcm_api.s")
	.word	_ga_random
	.word	_ga_divmod
	.word	_ga_printf
	.word	_ga_printchar
	.word	_ga_printmat
	.word	_ga_delay
	.word	_ga_clear
	@;.word	_gt_getstring		@;funció per al teclat d'aleix

.end
