/*------------------------------------------------------------------------------

	"main.c" : fase 1 / programador P

	Programa de prueba de creación y multiplexación de procesos en GARLIC 1.0,
	pero sin cargar procesos en memoria ni utilizar llamadas a _gg_escribir().

------------------------------------------------------------------------------*/
#include <nds.h>
#include <stdio.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema

#include <GARLIC_API.h>		// inclusión del API para simular un proceso
int hola(int);				// función que simula la ejecución del proceso
int detm(int);

extern int * punixTime;		// puntero a zona de memoria con el tiempo real


/* Inicializaciones generales del sistema Garlic */
//------------------------------------------------------------------------------
void inicializarSistema() {
//------------------------------------------------------------------------------

	consoleDemoInit();		// inicializar consola, sólo para esta simulación
	
	_gd_seed = *punixTime;	// inicializar semilla para números aleatorios con
	_gd_seed <<= 16;		// el valor de tiempo real UNIX, desplazado 16 bits
	
	irqInitHandler(_gp_IntrMain);	// instalar rutina principal interrupciones
	irqSet(IRQ_VBLANK, _gp_rsiVBL);	// instalar RSI de vertical Blank
	irqEnable(IRQ_VBLANK);			// activar interrupciones de vertical Blank
	REG_IME = IME_ENABLE;			// activar las interrupciones en general
	
	_gd_pcbs[0].keyName = 0x4C524147;	// "GARL"
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	
	inicializarSistema();
	
	printf("********************************");
	printf("*                              *");
	printf("* Sistema Operativo GARLIC 1.0 *");
	printf("*                              *");
	printf("********************************");
	printf("*** Inicio fase 1_P\n");
	
	_gp_crearProc(hola, 7, "HOLA", 1);
	_gp_crearProc(hola, 14, "HOLA", 2);
	_gp_crearProc(detm, 8, "DETM", 1);
	
	
	while (_gp_numProc() > 1) {
		_gp_WaitForVBlank();
		printf("*** Test %d:%d\n", _gd_tickCount, _gp_numProc());
	}						// esperar a que terminen los procesos de usuario

	printf("*** Final fase 1_P\n");

	while (1) {
		_gp_WaitForVBlank();
	}							// parar el procesador en un bucle infinito
	return 0;
}


/* Proceso de prueba, con llamadas a las funciones del API del sistema Garlic */
//------------------------------------------------------------------------------
int hola(int arg) {
//------------------------------------------------------------------------------
	unsigned int i, j, iter;
	
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	
									// esccribir mensaje inicial
	GARLIC_printf("-- Programa HOLA  -  PID (%d) --\n", GARLIC_pid());
	
	j = 1;							// j = cálculo de 10 elevado a arg
	for (i = 0; i < arg; i++)
		j *= 10;
						// cálculo aleatorio del número de iteraciones 'iter'
	GARLIC_divmod(GARLIC_random(), j, &i, &iter);
	iter++;							// asegurar que hay al menos una iteración
	
	for (i = 0; i < iter; i++)		// escribir mensajes
		GARLIC_printf("(%d)\t%d: Hello world!\n", GARLIC_pid(), i);

	return 0;
}


/* Proceso de prueba ProgP, con llamadas a las funciones del API del sistema Garlic */
//------------------------------------------------------------------------------
int detm(int arg)				
{	
	int i,j,k,l,m,n ; 
	unsigned int a[6][6]; 
	int det;
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	
	//ordre =2+arguments de entrada
	n=2+arg;
	m=n-1;
	
	GARLIC_printf("-- Programa DETM  -  PID (%d) --\n", GARLIC_pid());

	for(i=1;i<=n;i++){ 
		for(j=1;j<=n;j++){
			a[i][j]=GARLIC_random()%10;
		}
	}
	
/* Llegim elements matriu */ 
	for(i=1;i<=n;i++){ 
		for(j=1;j<=n;j++){
			GARLIC_printf("(%d)\tElement: %d\n",GARLIC_pid(),a[i][j]);
		}
	} 

/*****Càlcul del DETERMINANT*****/
	unsigned int quo, res;
	//unsigned int num, den;
	det=a[1][1];
	for(k=1;k<=m;k++){
		l=k+1; 
		for(i=l;i<=n;i++){	
			for(j=l;j<=n;j++){
				//num=a[k][k]*a[i][j]-a[k][j]*a[i][k];
				//den=a[k][k];
				//GARLIC_printf("\t\t\tA(%d,%d)\n",num,den);
				GARLIC_divmod((a[k][k]*a[i][j]-a[k][j]*a[i][k]), a[k][k], &quo, &res);
				//GARLIC_printf("\t\t\tA(%d,%d)\n",quo,res);				
				a[i][j] = quo;
			}
		} 
		det=det*a[k+1][k+1]; 
	} 
	//GARLIC_printf("\n\n"); 
	GARLIC_printf("(%d)\tDETERMINANT = %d\n",GARLIC_pid(),det); 
	//GARLIC_printf("\t\t\t-------------------------\n");

	return 0;
}
