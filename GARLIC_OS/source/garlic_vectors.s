@;==============================================================================
@;
@;	"garlic_vector.s":	vector de direcciones de rutinas del API de GARLIC 1.0
@;
@;	ATENCIÓN: Ésta y las demás rutinas del API se declaran aquí para obtener 
@;	un vector de dirección de inicio de esas rutinas. Esto permite llamar a dichas 
@;	rutinas de forma independiente de su ubicación real en memoria, la cual cambia
@;	cada vez que se modifica el código de las rutinas. Este vector se alojará en 
@;	las primeras posiciones de la memoria ITCM.
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
