@;==============================================================================
@;
@;	"garlic_vector.s":	vector de direcciones de rutinas del API de GARLIC 1.0
@;
@;==============================================================================

.section .vectors,"a",%note 


APIVector:						@; Vector de direcciones de rutinas del API
	.word	_ga_pid				@; (código de rutinas en "garlic_itcm_api.s")
	.word	_ga_random
	.word	_ga_divmod
	.word	_ga_printf
	.word	_ga_getstring

.end
