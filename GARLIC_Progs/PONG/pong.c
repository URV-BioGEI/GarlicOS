/*------------------------------------------------------------------------------

	"PONG.c" : programa de prueba para el sistema operativo GARLIC 2.0;
	
	Rebota un caracter por la ventana del proceso, donde la velocidad de
	movimiento del caracter depende del argumento del programa, que corresponde
	al número de segundos que tiene que esperar entre movimiento y movimiento;
	si el argumento es 0, el retardo es un retrazado vertical (más el tiempo
	necesario para restaurar el proceso).

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */


int _start(int arg)				/* función de inicio : no se usa 'main' */
{
	int x, y, dirx, diry;
	
	if (arg < 0) arg = 0;			// limitar valor mínimo del argumento 
	if (arg > 3) arg = 3;			// limitar retardo máximo 3 segundos

	GARLIC_clear();
									// esccribir mensaje inicial
	GARLIC_printf("-- Programa PONG  -  PID %2(%d) %0--\n", GARLIC_pid());

	x = 0; y = 0;					// posición inicial
	dirx = 1; diry = 1;				// dirección inicial
	GARLIC_printchar( x, y, 95, arg);	// escribir caracter por primera vez
	do
	{
		GARLIC_delay(arg);
		GARLIC_printchar( x, y, 0, arg);	// borrar caracter anterior
		x += dirx;
		y += diry;						// avance del caracter
		if ((x == 31) || (x == 0))
			dirx = -dirx;				// rebote izquierda o derecha
		if ((y == 23) || (y == 0))
			diry = -diry;				// rebote arriba o abajo
		if ((x == 0) && (y == 0))
			y = 1;						// forzar posiciones (x+y) impares
		else if ((x == 0) && (y == 1))
		{	y = 0;						// forzar posiciones (x+y) pares
			diry = 1;						// forzar dirección derecha
		}
		GARLIC_printchar( x, y, 95, arg);	// reescribir caracter		
	} while (1); 				// no acaba nunca
	return 0;
}
