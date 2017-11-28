/*------------------------------------------------------------------------------
	"main.c" : fase 1 / programador P-G-T-M
------------------------------------------------------------------------------*/

#include <nds.h>
#include <stdio.h>
#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <GARLIC_API.h>		// inclusión del API para simular un proceso

extern int * punixTime;		// puntero a zona de memoria con el tiempo real

/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------
	int v;

	_gg_iniGrafA();			// inicializar procesador gráfico A 
	for (v = 0; v < 4; v++)	// para todas las ventanas
		_gd_wbfs[v].pControl = 0;		// inicializar los buffers de ventana

	//consoleDemoInit();		// inicializar consola, sólo para esta simulación  
	 
	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits
	
	irqInitHandler(_gp_IntrMain);	// instalar rutina principal interrupciones
	irqSet(IRQ_VBLANK, _gp_rsiVBL);	// instalar RSI de vertical Blank
	irqEnable(IRQ_VBLANK);			// activar interrupciones de vertical Blank
	REG_IME = IME_ENABLE;			// activar las interrupciones en general 
	
	_gd_pcbs[0].keyName = 0x4C524147;	// "GARL"

	// Inicializar EDs i interrupciones de botones para el teclado
	_gt_initKB();	

	if (!_gm_initFS()) {
		//GARLIC_printf("ERROR: ¡no se puede inicializar el sistema de ficheros!");
		exit(0);
	} 
	
}

//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	intFunc start;	
	inicializarSistema();
	
	GARLIC_printf("********************************"); // 32 caracters per fila
	GARLIC_printf("*                              *");
	GARLIC_printf("* Sistema Operativo GARLIC 1.0 *");
	GARLIC_printf("*                              *");
	GARLIC_printf("********************************");
	GARLIC_printf("* Inicio fase 1_G-P-M-T        *");
	
	int i; 
	for (i=0; i<4; i++)
	{
		start = _gm_cargarPrograma("STRN");
		if (start != 0)  
		{
			if (_gp_crearProc(start, i+1, "STRN", i%4) != 0) GARLIC_printf("*\nEl proces STRN no s'ha creat\n*");
		}
		else GARLIC_printf("* \nPrograma STRN NO cargado\n");
	}
	/*
	start = _gm_cargarPrograma("STRN");
	if (start) _gp_crearProc(start, 1, "STRN", 2);
	else GARLIC_printf("* \nPrograma STRN NO cargado\n");
		
	start = _gm_cargarPrograma("CUAD");
	if (start)	_gp_crearProc(start, 5, "CUAD", 2);
	else GARLIC_printf("*** Programa \"CUAD\" NO cargado\n");
	
	start = _gm_cargarPrograma("TERNS");
	if (start)	_gp_crearProc(start, 6, "TERNS", 2);
	else GARLIC_printf("*** Programa \"TERNS\" NO cargado\n");
	
	start = _gm_cargarPrograma("DETM");
	if (start)	_gp_crearProc(start, 3, "DETM", 2);
	else GARLIC_printf("*** Programa \"DETM\" NO cargado\n");
	
	start = _gm_cargarPrograma("HOLA");
	if (start) _gp_crearProc(start, 2, "HOLA", 1);
	else GARLIC_printf("*** Programa \"HOLA\" NO cargado\n");

	start1 = _gm_cargarPrograma("PRNT");
	if (start1) _gp_crearProc(start1, 3, "PRNT", 2);
	else GARLIC_printf("*** Programa \"PRNT\" NO cargado\n");*/
	
	i=5;
	//mentre hi hagi processos en execució diferents del S.O
	while(_gp_numProc()>1){
		if(_gp_numProc()<i){
			GARLIC_printf("\n*** HA ACABAT UN PROCES ***\n");
			i--;
		}
	}
		GARLIC_printf("*** Final fase 1 M,T,G,P\n"); 

	// parar el procesador en un bucle infinito
	while (1) {
		_gp_WaitForVBlank();
	}						
	
return 0;
}


