/*------------------------------------------------------------------------------

	garlic_mainARM7  (Aleix Mariné, 24/12/2017)
	
------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------

	Simon1  (Santiago Romaní, novembre 2011)
	
	-> based on "Common" templates from DevkitPro; see the following original
	   legal notice:
	
---------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------
	
	default ARM7 core

		Copyright (C) 2005 - 2010
		Michael Noland (joat)
		Jason Rogers (dovoto)
		Dave Murphy (WinterMute)

	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any
	damages arising from the use of this software.

	Permission is granted to anyone to use this software for any
	purpose, including commercial applications, and to alter it and
	redistribute it freely, subject to the following restrictions:

	1.	The origin of this software must not be misrepresented; you
		must not claim that you wrote the original software. If you use
		this software in a product, an acknowledgment in the product
		documentation would be appreciated but is not required.

	2.	Altered source versions must be plainly marked as such, and
		must not be misrepresented as being the original software.

	3.	This notice may not be removed or altered from any source
		distribution.

---------------------------------------------------------------------------------*/
#include <nds.h>
touchPosition tempPos = {0};


/*comprobarPantallaTactil() verifica si se ha pulsado efectivamente la pantalla
   táctil con el lápiz, comprobando que está pulsada durante al menos dos llama-
   das consecutivas a la función y, además, las coordenadas raw sean diferentes
   de 0; en este caso, se fija el parámetro pasado por referencia, touchPos,
   con las coordenadas (x, y) en píxeles, y la función devuelve cierto.*/ 
bool comprobarPantallaTactil(void)
{
	if (!touchPenDown()) return false;	// no hay contacto del lápiz con la pantalla
	else		// hay contacto
	{
		touchReadXY(&tempPos);	// leer la posición de contacto
		if ((tempPos.rawx == 0) || (tempPos.rawy == 0)) return false;	 // si las posiciones son 0
		else return true; // sino devuelve cierto
	}
}



//------------------------------------------------------------------------------
int main() {
//------------------------------------------------------------------------------
  //unsigned char mensaje;
	short x, y;
	//int i;
	char buttons = 0, oldbuttons = 0;
	bool dinsderang;
	unsigned int posarrayx, posarrayy, codi, numcaselles; // per defecte el codi sera 0; // per defecte escriurem una sola casella
	
	readUserSettings();			// configurar parámetros lectura Touch Screen
	irqInit();
	REG_IPC_FIFO_CR = IPC_FIFO_ENABLE | IPC_FIFO_SEND_CLEAR; //  | IPC_FIFO_RECV_IRQ | 1 << 15 | 1 << 10
	irqEnable(IRQ_IPC_SYNC | IRQ_VBLANK | IRQ_FIFO_NOT_EMPTY);	
		
	REG_IPC_SYNC = 0; // inicialitzem el registre de control
	REG_IPC_SYNC = IPC_SYNC_IRQ_ENABLE | IPC_SYNC_IRQ_REQUEST;
	/* Activación de todas las IRQ (interrupt master enable)  */

  do
  {
	oldbuttons = buttons; // canviem els botons
	buttons = REG_KEYXY & 0X3; // carreguem el nous botons (ens interessen els dos primers bits)
		/* Permetem interrupcions i passem els 2 primers bits del REG_KEYXY (estat dels botons X i Y) */
	if (oldbuttons != buttons) 	REG_IPC_SYNC = IPC_SYNC_IRQ_REQUEST | IPC_SYNC_IRQ_ENABLE | buttons << 8 ; // li passem els dos botons 
	
	dinsderang = true;
	codi = 0;
	numcaselles = 1;
	posarrayy = 0;
	posarrayx = 0;

	// COmprovem si s'ha apretat la pantalla tactil
	
	if (comprobarPantallaTactil())
	{
		x = tempPos.px;					// leer posición (x, y)
		y = tempPos.py;
		
		x=x >> 3;	// Obtenim coordenades en nombre de rajoles
		y=y >> 3;
		
		//REG_IPC_FIFO_TX = x;
		switch (y)
		{
		case 5: // fila 5
			if (x % 2 != 0 || x < 2 || x > 30) dinsderang = false;
			else 
			{
				if (x == 30) codi = 7; // codi per boto especial
				posarrayy = 0; // corregim per a que sigui una posicio de l'array 
			}
		break;
		case 7:
			if ( (x % 2 != 0 && x > 0 && x < 26) || (x > 27 && x < 31) ) 
			{
				if (x > 28)
				{
					x = 28; // si hem apretat a DEL que apunti a DEL desde el principi
					numcaselles = 3;
					codi = 3; // codi per a la tecla DEL
				}
				posarrayy = 1;
			}
			else dinsderang = false;
		break;
		case 9:
			if ( (x > 0 && x < 5) || (x % 2 == 0 && x > 5 && x < 25) || (x > 25 && x < 31) ) 
			{
				if (x > 0 && x < 5)
				{
					x = 1; // si hem apretat a CAPS que x apunti a CAPS desde el principi
					numcaselles = 4;
					codi = 2; // codi per a la tecla CAPS
				}
				else if (x > 25 && x < 31)
				{
					x = 26;
					numcaselles = 5;
					codi = 4; // codi per a INTRO
				}
				posarrayy = 2;

			}
			else dinsderang = false;
		break;
		case 11:		
			if ( (x > 0 && x < 6) || (x % 2 == 0 && x > 6 && x < 24) || (x == 26 || x == 27) || (x == 29 || x == 30)) 
			{
				if (x > 0 && x < 6)
				{
					x = 1;
					numcaselles = 5;
					codi = 1; // codi per a la tecla SPACE
				}
				else if (x == 26 || x == 27)
				{
					x = 26;
					numcaselles = 2;
					codi = 5; // codi per a la tecla <=
				}
				else if (x == 29 || x == 30)
				{
					x = 29;
					numcaselles = 2;
					codi = 6; // codi per a la tecla <=
				}
				posarrayy = 3;
			}
			else dinsderang = false;
		break;
		default:
			dinsderang = false;
		break;
		}
		posarrayx = x-1; // corregim per a que la pos de x coincideixi amb la del array
		if (dinsderang) REG_IPC_FIFO_TX	= (numcaselles & 0x3) << 19 | ((y * 32 + x) & 0x1FF) << 10 | ((posarrayy * 30 + posarrayx) & 0x7F) << 3 | (codi & 0x3);
	}
	else swiWaitForVBlank(); // Esperem per no sobrecarregar cpu 
  }while (1);
return 0;
}
