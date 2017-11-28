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

La funció escriura l'string resultat per pantalla .
*/



int _start(int arg)
{
	if (arg < 0) arg = 0;			// limitar valor máximo y
	else if (arg > 3) arg = 3;		// valor mínimo del argumento

	int lengthv2, lengthv1, i;
	char v1[28], v2[28], vr[57];

	for (i=0; i<57; i++) vr[i] = ' ';
	GARLIC_printf("*Introdueix un string*\n");

	lengthv1 = GARLIC_getstring(v1, 28);

	GARLIC_printf("\nLongitud de l'string: %d", lengthv1);
	GARLIC_printf("\nValor de l'string:\n%s", v1);

	switch (arg)
	{
		case 0:
			GARLIC_printf("\narg=0: Concatenar strings\n*Introdueix un altre string*");
			lengthv2 = GARLIC_getstring(v2, 28);
			GARLIC_printf("\nLongitud de l'string: %d", lengthv2);
			GARLIC_printf("\nValor de l'string:\n%s", v2);
			for (i = 0; i< lengthv1; i++)
			{
				vr[i] = v1[i];
			}
			for (i = 0; i < lengthv2; i++)
			{
				vr[i + lengthv1] = v2[i];
			}
		break;

		case 1:
			GARLIC_printf("\narg=1: Invertir String");

			for (i = 0; i < lengthv1; i++)
			{
				vr[i] = v1[lengthv1-i-1];
			}
		break;

		case 2:
			GARLIC_printf("\narg=2: toUpperCase");

			for (i = 0; i < lengthv1; i++)
			{
				if (v1[i] > 96 && v1[i] < 123)
				{
					vr[i] = v1[i] - 32;
				}
				else vr[i] = v1[i];
			}
		break;

		case 3:
			GARLIC_printf("\narg=3: toLowerCase");

			for (i = 0; i < lengthv1; i++)
			{
				if (v1[i] > 64 && v1[i] < 91)
				{
					vr[i] = v1[i] + 32;
				}
				else vr[i] = v1[i];
			}
		break;
	}
	GARLIC_printf("\nSTRING RESULTAT:\n");
	
	GARLIC_printf(vr);

	return 0;

}
