/*------------------------------------------------------------------------------

	"STRN.c" : programa de test del progT
				(versión 1.0)
	
	Duu a terme diferents funcions per a treballar amb strings,aprofitant
	l'entrada del teclat.

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

/* definicion de variables globales 
Concatenació (0): Llegeix dos strings per teclat i els concatena.
Inversió (1): Llegeix un sol string i l'inverteix, posant la última posició en la primera i així successivament.
toUpperCase (2): Llegeix un sol string i transforma tots els caràcters en minúscula a majúscula.
toLowerCase (3): Llegeix un sol string i transforma tots els caràcters en majúscula a minúscula.

La funció retornarà l'string resultant per paràmetre, però també l'imprimirà per una de les quatre pantalles,
 escollida segons el valor de l'argument. En tot moment es conservarà el caràcter de final de vector \0.
*/

	char v1[28], v2[28], vr[56];

char* _start(unsigned char arg)
{
	unsigned char lengthv2, lengthv1 = GARLIC_getstring(v1, 28);
	int i, temp;
	switch (arg)
	{
		case 0:
			lengthv2 = GARLIC_getstring(v2, 28);
			for (i = lengthv1; i< lengthv1+lengthv2; i++)
			{
				vr[i] = v2[i-lengthv1];
			}
			vr[i] = '\0';
			GARLIC_printf(vr, 0, 0, 0);
			
			v1 = vr;
		break;
		
		case 1:
			for (i = 0; i < lengthv1; i++)
			{
				temp = v1[lengthv1-i-1];
				v1[lengthv1-i-1] = v1[i];
				v1[i] = temp;
			}
		break;
		
		case 2:
			for (i = 0; i < lengthv1; i++)
			{
				if (v1[i] > 96 && v1[i] < 123)
				{
					v1[i] = v1[i] - 32;
				}
			}
		break;
		
		case 3:
			for (i = 0; i < lengthv1; i++)
			{
				if (v1[i] > 64 && v1[i] < 91)
				{
					v1[i] = v1[i] - 32;
				}
			}
		break;
	}
	GARLIC_printf(v1, 0, 0, 0);
	return v1;
	
}
