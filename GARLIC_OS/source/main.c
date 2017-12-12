/*------------------------------------------------------------------------------

	"main.c" : fase 2 / progP

	Versión final de GARLIC 2.0
	(multiplexación, retardar procesos, matar procesos)

------------------------------------------------------------------------------*/
#include <nds.h>
#include <stdlib.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema

extern int * punixTime;		// puntero a zona de memoria con el tiempo real

const short divFreq0 = -33513982/1024;		// frecuencia de TIMER0 = 1 Hz


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


/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------
	int v;

	_gg_iniGrafA();			// inicializar procesadores gráficos
	_gs_iniGrafB();
	for (v = 0; v < 4; v++)	// para todas las ventanas
	{	_gg_generarMarco(v, 0);
		_gd_wbfs[v].pControl = 0;		// inicializar los buffers de ventana
	}
	_gs_dibujarTabla();

	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits
	
	_gd_pcbs[0].keyName = 0x4C524147;		// "GARL"
	
	if (!_gm_initFS()) {
		_gg_escribir("ERROR: ¡no se puede inicializar el sistema de ficheros!", 0, 0, 0);
		exit(0);
	}

	irqInitHandler(_gp_IntrMain);	// instalar rutina principal interrupciones
	irqSet(IRQ_VBLANK, _gp_rsiVBL);	// instalar RSI de vertical Blank
	irqEnable(IRQ_VBLANK);			// activar interrupciones de vertical Blank

	irqSet(IRQ_TIMER0, _gp_rsiTIMER0);
	irqEnable(IRQ_TIMER0);				// instalar la RSI para el TIMER0
	TIMER0_DATA = divFreq0; 
	TIMER0_CR = 0xC3;  	// Timer Start | IRQ Enabled | Prescaler 3 (F/1024)
	
	REG_IME = IME_ENABLE;			// activar las interrupciones en general
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	intFunc start;
	int mtics, v;

	inicializarSistema();
	
	_gg_escribir("********************************", 0, 0, 0);
	_gg_escribir("*                              *", 0, 0, 0);
	_gg_escribir("* Sistema Operativo GARLIC 2.0 *", 0, 0, 0);
	_gg_escribir("*                              *", 0, 0, 0);
	_gg_escribir("********************************", 0, 0, 0);
	_gg_escribir("*** Inicio fase 2_P\n", 0, 0, 0);
	
	_gg_escribir("*** Carga de programa HOLA.elf\n", 0, 0, 0);
	start = _gm_cargarPrograma("HOLA");
	if (start)
	{	
		_gp_crearProc(start, 1, "HOLA", 3);
		_gp_crearProc(start, 2, "HOLA", 3);
		_gp_crearProc(start, 3, "HOLA", 3);
		
		while (_gd_tickCount < 240)			// esperar 4 segundos
		{
			_gp_WaitForVBlank();
			porcentajeUso();
		}
		_gp_matarProc(1);					// matar proceso 1
		_gg_escribir("Proceso 1 eliminado\n", 0, 0, 0);
		_gs_dibujarTabla();
		
		while (_gd_tickCount < 480)			// esperar 4 segundos más
		{
			_gp_WaitForVBlank();
			porcentajeUso();
		}
		_gp_matarProc(3);					// matar proceso 3
		_gg_escribir("Proceso 3 eliminado\n", 0, 0, 0);
		_gs_dibujarTabla();
		
		while (_gp_numProc() > 1)			// esperar a que proceso 2 acabe
		{
			_gp_WaitForVBlank();
			porcentajeUso();
		}
		_gg_escribir("Proceso 2 terminado\n", 0, 0, 0);
	} else
		_gg_escribir("*** Programa NO cargado\n", 0, 0, 0);
	
	_gg_escribir("*** Carga de programa PONG.elf\n", 0, 0, 0);
	start = _gm_cargarPrograma("PONG");
	if (start)
	{
		for (v = 1; v < 4; v++)	// inicializar buffers de ventanas 1, 2 y 3
			_gd_wbfs[v].pControl = 0;
		
		_gp_crearProc(start, 1, "PONG", 1);
		_gp_crearProc(start, 2, "PONG", 2);
		_gp_crearProc(start, 3, "PONG", 3);
		
		mtics = _gd_tickCount + 960;
		while (_gd_tickCount < mtics)		// esperar 16 segundos más
		{
			_gp_WaitForVBlank();
			porcentajeUso();
		}
		
		_gp_matarProc(1);					// matar los 3 procesos a la vez
		_gp_matarProc(2);
		_gp_matarProc(3);
		_gg_escribir("Procesos 1, 2 y 3 eliminados\n", 0, 0, 0);
		
		while (_gp_numProc() > 1)	// esperar a que todos los procesos acaben
		{
			_gp_WaitForVBlank();
			porcentajeUso();
		}
		
	} else
		_gg_escribir("*** Programa NO cargado\n", 0, 0, 0);
	
	
	_gg_escribir("*** Carga de programa DETM.elf\n", 0, 0, 0);
	start = _gm_cargarPrograma("DETM");
	if (start)
	{
		for (v = 1; v < 4; v++)	// inicializar buffers de ventanas 1, 2 y 3
			_gd_wbfs[v].pControl = 0;
		
		_gp_crearProc(start, 1, "DETM", 1);
		_gp_crearProc(start, 2, "DETM", 2);
		_gp_crearProc(start, 3, "DETM", 3);
	} else
		_gg_escribir("*** Programa NO cargado\n", 0, 0, 0);
	
	v=_gp_numProc();
	while (_gp_numProc() > 1)			// esperar a que proceso 2 acabe
		{
			_gp_WaitForVBlank();
			porcentajeUso();
			if (_gp_numProc() < v){
				_gs_dibujarTabla();
				v--;
			}
		}
	_gg_escribir("Procesos 1, 2 i 3 terminados\n", 0, 0, 0);
	
	
	_gg_escribir("*** Final fase 2_P\n", 0, 0, 0);
	_gs_dibujarTabla();

	while(1) {
		_gp_WaitForVBlank();
	}							// parar el procesador en un bucle infinito
	return 0;
}
