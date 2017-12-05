/*------------------------------------------------------------------------------

	"CRON.c" : programa de prueba para el sistema operativo GARLIC 2.0;
	
	Muestra un laberinto aleatorio con un cierto número de puntos, y unos
	objectos que se mueven de forma aleatoria, comiendo esos puntos; las dimen-
	siones del laberinto y el número de objectos depende del argumento:
		0:	1 objeto / 8 columnas
		1:	2 objetos / 16 columnas
		2:	3 objetos / 24 columnas
		3:	4 objetos / 32 columnas

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

#define BLOCK 0x5F
#define POINT 0x0E
#define SPACE 0x00

#define MAX_FILS 16
#define MAX_COLS 32

#define F 'f'
#define P 'p'
#define B 'b'


struct character {
	char c;
	unsigned int x;
	unsigned int y;
	unsigned int color;
	unsigned int score;
	unsigned int xdir;
	unsigned int ydir;
};

struct character chars[4];
char lab[MAX_FILS][MAX_COLS];
unsigned int nchars, labx, laby, points;


/* Funcion para inicializar el laberinto, dibujando en pantalla el marco, los
	bloques aleatorios y los puntos; accede a las variables globales que
	definen la matriz (lab), la anchura del laberinto (labx) y la altura (laby)
*/
void init_lab()
{
	unsigned int i,j;
	unsigned int num_items, randx, randy;
	unsigned int div, mod;
	
	// Init horizontal borders
	for (j = 0; j < labx; j++)
	{
		lab[0][j] = B;
		lab[laby-1][j] = B;
		GARLIC_printchar(j, 4, BLOCK, 0);
		GARLIC_printchar(j, laby+3, BLOCK, 0);
	}
	
	// Init vertical borders
	for (i = 1; i < laby-1; i++)
	{
		lab[i][0] = B;
		lab[i][labx-1] = B;
		GARLIC_printchar(0, i+4, BLOCK, 0);
		GARLIC_printchar(labx-1, i+4, BLOCK, 0);
	}
	
	// Init empty positions
	for (i = 1; i < laby-1; i++)
	{
		for (j = 1; j < labx-1; j++)
			lab[i][j] = F;
	}
	
	// Calculate number of random blocks and points
	num_items = (25 * (labx-2) * (laby-2)) / 100;
	points = num_items;

	// Init random blocks
	i=0;
	while (i < num_items)
	{
		GARLIC_divmod(GARLIC_random(), labx, &div, &mod);
		randx = mod;
		GARLIC_divmod(GARLIC_random(), laby, &div, &mod);
		randy = mod;
		
		if (lab[randy][randx] != B)
		{
			GARLIC_printchar(randx, randy+4, BLOCK, 0);
			lab[randy][randx] = B;
			i++;
		}
	}

	// Init random points
	i=0;
	while (i < num_items)
	{
		// Obtener posiciones aleatorias
		GARLIC_divmod(GARLIC_random(), labx, &div, &mod);
		randx = mod;
		GARLIC_divmod(GARLIC_random(), laby, &div, &mod);
		randy = mod;
		
		// Comprobar que es una posición accesible
		if (lab[randy][randx] == F)
		{
			GARLIC_printchar(randx, randy+4, POINT, 0);
			lab[randy][randx] = P;
			i++;
		}
	}
	
	// Print Scores
	for (i = 0; i < nchars; i++)
	{
		GARLIC_printchar(i*6, 22, chars[i].c, chars[i].color);
		GARLIC_printchar((i*6)+1, 22, 0x1A, chars[i].color);
		GARLIC_printchar((i*6)+3, 22 , 0x10, chars[i].color);
	}
}

/* Funcion para obtener la posicion inicial de las letras y dibujarlas en
	pantalla */
void init_chars()
{
	unsigned int i = 0;
	unsigned int randx, randy;
	unsigned int div, mod;
	
	while (i < nchars)
	{
		// Obtener posiciones aleatorias
		GARLIC_divmod(GARLIC_random(), labx, &div, &mod);
		randx = mod;
		GARLIC_divmod(GARLIC_random(), laby, &div, &mod);
		randy = mod;
		
		if (lab[randy][randx] == F)
		{
			// Escribir en mapa
			lab[randy][randx] = chars[i].c; 
			
			// Guadar valores en la estructura
			chars[i].x = randx;
			chars[i].y = randy;
			
			// Escribir en pantalla
			GARLIC_printchar(randx, randy+4, chars[i].c, chars[i].color);
			
			// Set movement direction
			if (randx < labx/2) chars[i].xdir = 1;
			else 				chars[i].xdir = -1;
			chars[i].ydir = 0;
			
			i++;
		}
	}
}


/* Inicialización de las estructuras */
void init_puppets()
{
	int i;
	for (i = 0; i < nchars; i++)
	{
		chars[i].c = 0x21 + i;
		chars[i].color = i;
		chars[i].score = 0;
	}
}


/* Actualización de puntos de una cierta letra segun el indice (i) de la tabla
	de estructuras chars */
void update_score(unsigned int i)
{
	unsigned int score, div, mod;
	
	score = chars[i].score;
	if (score > 9) {
		GARLIC_divmod(score, 10, &div, &mod);
		GARLIC_printchar((i*6)+2, 22, 0x10+div, chars[i].color);
		GARLIC_printchar((i*6)+3, 22, 0x10+mod, chars[i].color);
	} else {
		GARLIC_printchar((i*6)+3, 22, 0x10+score, chars[i].color);
	}
}

/* Funcion que implementa el algoritmo de movimiento de las letras, mueve una
	posicion a cada llamada */
void mov_chars()
{
	unsigned int i, j=0, div, mod;
	unsigned int newx, newy;
	
	for (i = 0; i < nchars; i++)
	{
		newx = chars[i].x + chars[i].xdir;
		newy = chars[i].y + chars[i].ydir;
		GARLIC_divmod(GARLIC_random(), 4, &div, &mod);
		if (mod == 3 || lab[newy][newx] == B)
		{	/* cambio de dirección si hay choque o con una probabilidad de 1/4 */
			j = 0;
			GARLIC_divmod(GARLIC_random(), 4, &div, &mod);
			do									// genera dirección aleatoria
			{
				switch (mod)
				{
					case 0:
						chars[i].xdir=1;
						chars[i].ydir=0;
						break;
					case 1:
						chars[i].xdir=0;
						chars[i].ydir=1;
						break;
					case 2:
						chars[i].xdir=-1;
						chars[i].ydir=0;
						break;
					case 3:
						chars[i].xdir=0;
						chars[i].ydir=-1;
						break;
				}
				newx = chars[i].x + chars[i].xdir;		// nueva posición según
				newy = chars[i].y + chars[i].ydir; 	// dirección aleatoria
				mod = (mod + 1) % 4;				// siguiente dirección
				j++;								// contador de intentos
			} while (j < 4 && lab[newy][newx] == B);	// hasta 4 intentos o via libre
		}
		if (lab[newy][newx] == P || lab[newy][newx] == F)
		{
			GARLIC_printchar(chars[i].x, chars[i].y+4, (char) SPACE, 0);
			lab[chars[i].y][chars[i].x] = F;
			
			chars[i].x = newx;
			chars[i].y = newy;
			
			if (lab[newy][newx] == P)
			{
				chars[i].score++;
				update_score(i);
				points--;
			}
			lab[newy][newx] = B;
			GARLIC_printchar(chars[i].x, chars[i].y+4, chars[i].c, chars[i].color);
		}
	}
}


/* Programa principal */
int _start(int arg)				/* función de inicio : no se usa 'main' */
{
	if (arg < 0) arg = 0;			// limitar valor mínimo del argumento 
	if (arg > 3) arg = 3;			// limitar valor máximo del argumento

	GARLIC_clear();
									// esccribir mensaje inicial
	GARLIC_printf("-- Programa LABE  -  PID %2(%d) %0--\n", GARLIC_pid());
	
	nchars = arg + 1;
	labx = nchars*8;
	laby = 16;
	
	init_puppets();
	init_lab();
	init_chars();
	do
	{
		mov_chars();
		GARLIC_delay(0);
	} while (points > 0); 	// repetir mientras queden puntos
	return 0;
}