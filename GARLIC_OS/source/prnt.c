/*------------------------------------------------------------------------------

	"PRNT.c" : programa de test de la función de API GARLIC_printf();
				(versión 1.0)
	
	Imprime diversos mensajes por ventana, comprobando el funcionamiento de
	la inserción de valores con distintos formatos, con o sin traspaso del
	límite de la última columna de la ventana.

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

/* definicion de variables globales */
const unsigned int numeros[] = { 0, 3, 5, 7,
								11, 17, 23, 37,
								127, 227, 233, 257,
								1019, 2063, 3001, 4073,
								15099, 26067, 37109, 68139,
								481021, 573949, 721905, 951063, 
								1048576, 2131331, 3910491, 5110611,
								10631069, 16777216, 18710911, 20931097,
								268435456, 471103972, 631297553, 825266928,
								1153631781, 2879320213, 3127223846, 4294967295};
				
char * const frases[] = {"Por fin llegó. Salimos en seguida para Carmona.\n",
					"El chofer alzaba una ceja, pisaba el acelerador y decía, ",
					"volviendose a medias hacia nosotras:\n",
					"\t-Podridita que está la carretera.\n",
					"Me preguntaba Mrs. Adams y yo le traducia: ",
					"<<La carretera, que esta podrida.>> ",
					"Ella miraba por un lado y hacia los comentarios mas raros. ",
					"¿Como puede pudrirse una carretera?\n",
					"Es Carmona una ciudad toda murallas y tuneles, la mas fuerte de Andalucia en los tiempos de Jul",
					"io Cesar. Y fuimos directamente a la ne-\ncropolis. ",
					"Un chico de aire avispado fue a avisar al guardia, que",
					" era un hombre flaco, alto, sin una onza de grasa, ",
					"con el perfil de una medalla romana. ",
					"Aparentaba cincuenta y cinco años. ",
					"<<A la paz de Dios>>, ",
					"dijo cuando llego.\n"};

int prnt(int arg)				/* Proceso de prueba */
{
	unsigned int i, j;
	
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	
									// esccribir mensaje inicial
	GARLIC_printf("-- Programa PRNT  -  PID (%d) --\n", GARLIC_pid());
	
	GARLIC_printf("\nPrueba juego de caracteres:\n");
	for (i = 32; i < 128; i++)		// imprimir todo el repertorio de códigos
		GARLIC_printf("%c", i);		// ASCII visibles (>31) y estándar (<128)

	GARLIC_printf("\n\nPrueba numeros:\n");
	for (i = 0; i < 10; i++)
	{
		for (j = 0; j < arg+1; j++)
			GARLIC_printf("%d (0x%x)\t", numeros[i*4+j], numeros[i*4+j]);
		GARLIC_printf("\n");
	}

	GARLIC_printf("\n\nPrueba frases:\n");
	for (i = 0; i < (arg+1)*4; i++)
		GARLIC_printf("%s", frases[i]);
	
	GARLIC_printf("\n\nPruebas mixtas::\n");
	GARLIC_printf("\n%%a%%\tprueba %s: %c%d\n%%", "string%%char", 64, 0);
	i = GARLIC_random();
	GARLIC_printf("b%%\taleatorio decimal: %d%%\n\t\t  hexadecimal: 0x%x%%\n", i, i);
	GARLIC_printf("%%c%%\tcodigos de formato reconocidos: %%c %%d %%x %%s\n", i, 0);
	GARLIC_printf("%%d%%\tcodigos de formato no reconocidos: %%i %%f %%e %%g %%p\n\n");

	return 0;
}
