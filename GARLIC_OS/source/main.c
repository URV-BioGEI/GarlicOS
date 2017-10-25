/*------------------------------------------------------------------------------

	"main.c" : fase 1 / programador P-G-M_T

------------------------------------------------------------------------------*/
#include <nds.h>
#include <stdio.h>
#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <GARLIC_API.h>		// inclusión del API para simular un proceso

extern int * punixTime;		// puntero a zona de memoria con el tiempo real
extern bool _gt_KBvisible;

/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------
	int v;
	_gg_iniGrafA();				// inicializar procesador gráfico A
	for (v = 0; v < 4; v++)	// para todas las ventanas
		_gd_wbfs[v].pControl = 0;		// inicializar los buffers de ventana

	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits
	
	irqInitHandler(_gp_IntrMain);	// instalar rutina principal interrupciones
	irqSet(IRQ_VBLANK, _gp_rsiVBL);	// instalar RSI de vertical Blank
	irqEnable(IRQ_VBLANK);			// activar interrupciones de vertical Blank
	REG_IME = IME_ENABLE;			// activar las interrupciones en general
	
	_gd_pcbs[0].keyName = 0x4C524147;	// "GARL"

	if (!_gm_initFS()) {
		_gg_escribir("ERROR: ¡no se puede inicializar el sistema de ficheros!",0,0,0);
		exit(0);
	} 
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	inicializarSistema();
	intFunc start, start2;
	
	_gg_escribir("INICI DEL SISTEMA\n",0,0,0);
	
	//PROGRAMA HOLA
	start = _gm_cargarPrograma("HOLA");
	if (start){
		_gp_crearProc(start, 5, "HOLA", 0);
	} 
	else{
		_gg_escribir("*** Programa \"HOLA\" NO cargat\n",0,0,0);
	}
	
	_gg_escribir("PRIMER PROGRAMA CARREGAT I CREAT NUM_PROC: %d\n",_gp_numProc(),0,0);
	
	//PROGRAMA DEL PROGP: DETM
	start2 = _gm_cargarPrograma("DETM");
	if (start2){
		_gp_crearProc(start2, 14, "DETM", 1);
	} 
	else{
		_gg_escribir("*** Programa \"DETM\" NO cargat\n",0,0,0);
	}
	
	_gg_escribir("SEGON PROGRAMA CARREGAT I CREAT NUM_PROC: %d\n",_gp_numProc(),0,0);
	
	//BUCLE INFINIT
	while (1) {
		_gg_escribir("BUCLE INFINIT: %d\n",_gp_numProc(),0,0);
		swiWaitForVBlank();
	}							// parar el procesador en un bucle infinito
	return 0;
	
}