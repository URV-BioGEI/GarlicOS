/*------------------------------------------------------------------------------

	"main.c" : fase 2 / progP i progG

	Versión final de GARLIC 2.0
	(multiplexación, retardar procesos, matar procesos, escribir mensajes en color, escribir caracteres y matrices de caracteres)

------------------------------------------------------------------------------*/
#include <nds.h>
#include <stdlib.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema

extern int * punixTime;		// puntero a zona de memoria con el tiempo real

const short divFreq0 = -33513982/1024;		// frecuencia de TIMER0 = 1 Hz

const short divFreq2 = -33513982/(1024*4);	// frecuencia de TIMER2 = 4 Hz

const char espaisBlanc[] ="   ";

const char *argumentosDisponibles[4] = { "0", "1", "2", "3"};
		// se supone que estos programas están disponibles en el directorio
		// "Programas" de las estructura de ficheros de Nitrofiles
const char *progs[10] = {"BORR","CRON","DESC","HOLA","LABE","PONG","PRNT","STRN","TERN","DETM"};
const int num_progs = 10;

/* función para escribir los porcentajes de uso de la CPU de los procesos de los
		cuatro primeros zócalos, en el caso que la RSI del TIMER0 haya realizado
		el cálculo */
void porcentajeUso()
{
	if (_gd_sincMain & 1)			// verificar sincronismo de timer0
	{
		_gd_sincMain &= 0xFFFE;			// poner bit de sincronismo a cero
		_gg_escribir("***\t%d%%  %d%%", _gd_pcbs[0].workTicks >> 24,
										_gd_pcbs[1].workTicks >> 24, 0);
		_gg_escribir("  %d%%  %d%%\n", _gd_pcbs[2].workTicks >> 24,
										_gd_pcbs[3].workTicks >> 24, 0);
	}
}


/* Función para presentar una lista de opciones y escoger una: devuelve el índice de la opción
		(0: primera opción, 1: segunda opción, etc.)
		ATENCIóN: para que pueda funcionar correctamente, se supone que no habrá desplazamiento
				  de las líneas de la ventana. */
int escogerOpcion(char *opciones[], int num_opciones)
{
	int fil_ini, j, sel, k;
	
	fil_ini = _gd_wbfs[_gi_za].pControl >> 16;		// fil_ini es índice fila inicial
	for (j = 0; j < num_opciones; j++)			// mostrar opciones
		_gg_escribir("%1( ) %s\n", (unsigned int) opciones[j], 0, _gi_za);

	sel = -1;									// marca de no selección
	j = 0;										// j es preselección
	_gg_escribirCar(1, fil_ini, 10, 2, _gi_za);	// marcar preselección
	do
	{
		_gp_WaitForVBlank();
		scanKeys();
		k = keysDown();				// leer botones
		if (k != 0)
			switch (k)
			{
				case KEY_UP:
						if (j > 0)
						{	_gg_escribirCar(1, fil_ini+j, 0, 2, _gi_za);
							j--;
							_gg_escribirCar(1, fil_ini+j, 10, 2, _gi_za);
						}
						break;
				case KEY_DOWN:
						if (j < num_opciones-1)
						{	_gg_escribirCar(1, fil_ini+j, 0, 2, _gi_za);
							j++;
							_gg_escribirCar(1, fil_ini+j, 10, 2, _gi_za);
						}
						break;
				case KEY_START:
						sel = j;			// escoger preselección
						break;
			}
	} while (sel == -1);
	return sel;
}


/* Función para permitir seleccionar un programa entre los ficheros ELF
		disponibles, así como un argumento para el programa (0, 1, 2 o 3) */
void seleccionarPrograma()
{
	intFunc start;
	int ind_prog, argumento;

	_gp_matarProc(_gi_za);
	_gd_wbfs[_gi_za].pControl = 0;	// resetear el contador de filas y caracteres
	_gg_escribir("%3* %d: proceso destruido\n", _gi_za, 0, 0);
	_gg_escribirLineaTabla(_gi_za, 3);
	
	_gs_borrarVentana(_gi_za, 1);
	_gg_escribir("%1*** Seleccionar programa :\n", 0, 0, _gi_za);
	ind_prog = escogerOpcion((char **) progs, num_progs);
	_gg_escribir("%1*** Seleccionar argumento :\n", 0, 0, _gi_za);
	argumento = escogerOpcion((char **) argumentosDisponibles, 4);
	
	start = _gm_cargarPrograma((char *) progs[ind_prog]);
	if (start)
	{	_gp_crearProc(start, _gi_za, (char *) progs[ind_prog], argumento);
		_gg_escribir("%2* %d:%s.elf", _gi_za, (unsigned int) progs[ind_prog], 0);
		_gg_escribir(" (%d)\n", argumento, 0, 0);
		_gg_escribirLineaTabla(_gi_za, 2);
	}
}




/* Función para gestionar los sincronismos generados por diversas rutinas
		para el programa principal */
void gestionSincronismos()
{
	int i, mask;
	
	if (_gd_sincMain & 0xFFFE)		// si hay algun sincronismo pendiente
	{
		mask = 2;
		for (i = 1; i <= 15; i++)
		{
			if (_gd_sincMain & mask)
			{	// actualizar visualización de tabla de zócalos
				_gg_escribirLineaTabla(i, (i == _gi_za ? 2 : 3));
				_gg_escribir("%0* %d: proceso terminado\n", i, 0, 0);
				_gd_sincMain &= ~mask;		// poner bit a cero
			}
			mask <<= 1;
		}
	}
}





/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------

	_gg_iniGrafA();			// inicializar procesadores gráficos
	_gs_iniGrafB();
	
	_gs_dibujarTabla();
	
	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits

	_gd_pcbs[0].keyName = 0x4C524147;		// "GARL"
	
	_gi_redibujarZocalo(1);			// marca tabla de zócalos con el proceso
									// del S.O. seleccionado (en verde)
	
	if (!_gm_initFS())
	{	_gg_escribir("%3ERROR: ¡no se puede utilizar sistema de ficheros!", 0, 0, 0);
		exit(0);
	}

	irqInitHandler(_gp_IntrMain);	// instalar rutina principal interrupciones
	irqSet(IRQ_VBLANK, _gp_rsiVBL);	// instalar RSI de vertical Blank
	irqEnable(IRQ_VBLANK);			// activar interrupciones de vertical Blank

	irqSet(IRQ_TIMER0, _gp_rsiTIMER0);
	irqEnable(IRQ_TIMER0);				// instalar la RSI para el TIMER0
	TIMER0_DATA = divFreq0; 
	TIMER0_CR = 0xC3;  	// Timer Start | IRQ Enabled | Prescaler 3 (F/1024)

	irqSet(IRQ_TIMER2, _gg_rsiTIMER2);
	irqEnable(IRQ_TIMER2);			// instalar la RSI para el TIMER2
	TIMER2_DATA = divFreq2; 
	TIMER2_CR = 0xC3;  		// Timer Start | IRQ Enabled | Prescaler 3 (F/1024)

	irqSet(IRQ_VCOUNT, _gi_movimientoVentanas);
	REG_DISPSTAT |= 0xE620;			// fijar linea VCOUNT a 230 y activar int.
	irqEnable(IRQ_VCOUNT);			// de VCOUNT
	
	REG_IME = IME_ENABLE;			// activar las interrupciones en general
	
	_gt_initKB(); 					// progT: Activem interficie de teclat
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------

	int key;
	inicializarSistema();

	_gg_escribir("%3********************************", 0, 0, 0);
	_gg_escribir("%1*                              *", 0, 0, 0);
	_gg_escribir("%2* Sistema%1 Operativo%3 GARLIC 2.0 *", 0, 0, 0);
	_gg_escribir("%1*                              *", 0, 0, 0);
	_gg_escribir("%0********************************", 0, 0, 0);
	_gg_escribir("%1*** Inicio fase 2_G\n", 0, 0, 0);
	

	while (1)						// bucle infinito
	{
		scanKeys();
		key = keysDown();			// leer botones y controlar la interfaz
		if (key != 0)				// de usuario
		{	_gi_controlInterfaz(key);
			if ((key == KEY_START) && (_gi_za != 0))
				seleccionarPrograma();
		}
		gestionSincronismos();
		_gp_WaitForVBlank();		// retardo del proceso de sistema
	}
	return 0;
	
}