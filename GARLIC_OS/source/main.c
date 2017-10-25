/*------------------------------------------------------------------------------

	"main.c" : fase 1 / programador M

	Programa de prueba de carga de un fichero ejecutable en formato ELF,
	pero sin multiplexación de procesos ni utilizar llamadas a _gg_escribir().
------------------------------------------------------------------------------*/
#include <nds.h>
#include <stdio.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema

extern int * punixTime;		// puntero a zona de memoria con el tiempo real


/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------
	
	consoleDemoInit();		// inicializar console, sólo para esta simulación
	
	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits

	if (!_gm_initFS()) {
		printf("ERROR: ¡no se puede inicializar el sistema de ficheros! Y PUTA MIERDA");
		exit(0);
	}
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	intFunc start;
	inicializarSistema();
	printf("********************************");
	printf("*                              *");
	printf("* Sistema Operativo GARLIC 1.0 *");
	printf("*                              *");
	printf("********************************");
	printf("*** Inicio fase 1_M\n");
	
	printf("*** Carga de programa HOLA.elf\n");
	start = _gm_cargarPrograma("HOLA");
	if (start)
	{	printf("*** Direccion de arranque :\n\t\t%p\n", start);
		printf("*** Pusle tecla \'START\' ::\n\n");
		while(1) {
			swiWaitForVBlank();
			scanKeys();
			if (keysDown() & KEY_START) break;
		}
		start(1);		// llamada al proceso HOLA con argumento 1
	} else
		printf("*** Programa \"HOLA\" NO cargado\n");
	
	printf("\n\n\n*** Carga de programa PRNT.elf\n");
	start = _gm_cargarPrograma("PRNT");
	if (start)
	{	printf("*** Direccion de arranque :\n\t\t%p\n", start);
		printf("*** Pusle tecla \'START\' ::\n\n");
		while(1) {
			swiWaitForVBlank();
			scanKeys();
			if (keysDown() & KEY_START) break;
		}
		start(0);		// llamada al proceso PRNT con argumento 0
	} else
		printf("*** Programa \"PRNT\" NO cargado\n");

	printf("*** Final fase 1_M\n");

	while (1) {
		swiWaitForVBlank();
	}							// parar el procesador en un bucle infinito
	return 0;
}

