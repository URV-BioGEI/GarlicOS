/*------------------------------------------------------------------------------

	"main.c" : fase 1 / programador G

	Programa de prueba de llamada de funciones gráficas de GARLIC 1.0,
	pero sin cargar procesos en memoria ni multiplexación.

------------------------------------------------------------------------------*/
#include <nds.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema

#include <GARLIC_API.h>		// inclusión del API para simular un proceso

int hola(int);				// función que simula la ejecución del proceso
extern int prnt(int);		// otra función (externa) de test correspondiente
							// a un proceso de usuario

extern int * punixTime;		// puntero a zona de memoria con el tiempo real


/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------
	int v;

	_gg_iniGrafA();			// inicializar procesador gráfico A
	for (v = 0; v < 4; v++)	// para todas las ventanas
		_gd_wbfs[v].pControl = 0;		// inicializar los buffers de ventana
	
	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	
	inicializarSistema();
	
	_gg_escribir("********************************", 0, 0, 0);
	_gg_escribir("*                              *", 0, 0, 0);
	_gg_escribir("* Sistema Operativo GARLIC 1.0 *", 0, 0, 0);
	_gg_escribir("*                              *", 0, 0, 0);
	_gg_escribir("********************************", 0, 0, 0);
	_gg_escribir("*** Inicio fase 1_G\n", 0, 0, 0);
	
	_gd_pidz = 6;	// simular zócalo 6
	hola(0);
	_gd_pidz = 7;	// simular zócalo 7
	hola(2);
	_gd_pidz = 5;	// simular zócalo 5
	prnt(1);

	_gg_escribir("*** Final fase 1_G\n", 0, 0, 0);

	while(1) {
		swiWaitForVBlank();
	}							// parar el procesador en un bucle infinito
	return 0;
}


/* Proceso de prueba */
//------------------------------------------------------------------------------
int hola(int arg) {
//------------------------------------------------------------------------------
	unsigned int i, j, iter;
	
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	
									// esccribir mensaje inicial
	GARLIC_printf("-- Programa HOLA  -  PID (%d) --\n", GARLIC_pid());
	
	j = 1;							// j = cálculo de 10 elevado a arg
	for (i = 0; i < arg; i++)
		j *= 10;
						// cálculo aleatorio del número de iteraciones 'iter'
	GARLIC_divmod(GARLIC_random(), j, &i, &iter);
	iter++;							// asegurar que hay al menos una iteración
	
	for (i = 0; i < iter; i++)		// escribir mensajes
		GARLIC_printf("(%d)\t%d: Hello world!\n", GARLIC_pid(), i);

	return 0;
}
