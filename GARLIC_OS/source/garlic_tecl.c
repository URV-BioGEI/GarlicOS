/*------------------------------------------------------------------------------

	"garlic_tecl.c" : Contiene fuciones comunes para la gestión de teclado
	
	Inicializa toda la información necesaria para la gestión del teclado, como las
	variables globales, los gráficos, instalar la RSI de teclado, etc.

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */
#include <nds.h>
#include <stdio.h>

/* definicion de variables globales */

void _gt_initKB()
{
	/* Inicializamos procesador gráfico en el modo 0 (los 4 fondos en modo texto) */
	videoSetModeSub(MODE_0_2D);
	/* Asignamos el banco de memoria B como fondo principal*/
	vramSetBankB(VRAM_B_MAIN_BG_0x06000000);
	/*	arg 0: Layer, capa de fondo. (0-3) siendo 0 más prioritario
		arg 1: Tipo de fondo (tipo texto con 4 bits por pixel)
		arg 2: Dimensiones de tipo texto 32x32
		arg 3: MapBase = 0 -> @fondo + 0*2KB = 0x0600 0000
		arg 4: TileBase = 1 -> @fondo + 1*16KB = 0x0600 0400
	*/
	bgInitSub(BG_PRIORITY(0), BgType_Text4bpp, BgSize_T_256x256, 0, 1)
}

void _gt_showKB()
{

}

void _gt_hideKB()
{

}