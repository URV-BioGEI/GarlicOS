/*------------------------------------------------------------------------------

	"CUAD.c" Programa que realiza la media cuadrática de un array de talla (arg+1)^5. El array esta llenado con numeros randoms entre 0 y 100.

------------------------------------------------------------------------------*/


#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

int _start(int arg)				/* función de inicio : no se usa 'main' */
{
	
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	
	GARLIC_printf("-- Programa CUAD  -  PID (%d) --\n", GARLIC_pid());
	//obtengo el numero de numeros y creo un array con el tamaño
	int sinpotencia = arg+1;
	int size = sinpotencia;
	size = sinpotencia*sinpotencia*sinpotencia*sinpotencia*sinpotencia;
	
	//lleno el array de numeros random
	int contador;
	int valor;
	int cuadrado;
	int total=0;
	unsigned int cociente, mod;
	for (contador=0; contador<size; contador++){
		GARLIC_divmod(GARLIC_random(), 100, &cociente, &mod);
		GARLIC_printf("%d ", mod);
		cuadrado = mod*mod;
		//GARLIC_printf("%d ", cuadrado);
		total= total + cuadrado;
	}
	
	//realizo división
	unsigned int cocientea, moda;
	GARLIC_divmod(total,size, &cocientea, &moda);
	total=cocientea;
	GARLIC_printf("\n %d <-Suma de numeros a cuadrado entre n. ", total);
	
	
	//realizo la raiz cuadrada
	unsigned int cocienteb, modb;
	unsigned int cocientec, modc;
	int x=total;
	int y=0;
	int a, b;
	int z=0;
	do{
		//x=(((x*x) + total) / (2*x));
		a = (x*x) + total;
		b = 2*x;
		GARLIC_divmod(a, b, &cocienteb, &modb);
		x = cocienteb;
		y = mod*100000;
		GARLIC_divmod(y, 100000, &cocientec, &modc);
		y= cocientec;
		z=z+1;
		
	}while(z<25);
	
	int j=0;
	
	GARLIC_printf("La size es: %d \n", size);
	GARLIC_printf("La media cuadrática es: %d \n con %d \n", x, y);
	
	return 0;
}
