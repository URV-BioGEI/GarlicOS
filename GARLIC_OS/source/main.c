/*------------------------------------------------------------------------------
	"main.c" : fase 1 / programador P-G
------------------------------------------------------------------------------*/

#include <nds.h>
#include <stdio.h>
#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <GARLIC_API.h>		// inclusión del API para simular un proceso

int hola(int);				// función que simula la ejecución del proceso
extern int prnt(int);		// otra función (externa) de test correspondiente
							// a un proceso de usuario
int detm(int);
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
}


//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	
	inicializarSistema();
	int i=4;
	
	_gg_escribir("********************************", 0, 0, 0);
	_gg_escribir("*                              *", 0, 0, 0);
	_gg_escribir("* Sistema Operativo GARLIC 1.0 *", 0, 0, 0);
	_gg_escribir("*                              *", 0, 0, 0);
	_gg_escribir("********************************", 0, 0, 0);
	_gg_escribir("*** Inicio fase 1_G-P\n", 0, 0, 0);
	
	_gp_crearProc(hola, 7, "HOLA", 1);
	_gp_crearProc(hola, 14, "HOLA", 1);
	_gp_crearProc(detm, 9, "DETM", 2);
	
	//mentre hi hagi processos en execució diferents del S.O
	while(_gp_numProc()>1){
		if(_gp_numProc()<i){
			_gg_escribir("\t*** HA ACABAT UN PROCES\n", 0, 0, 0);
			i--;
		}
	}

	_gg_escribir("*** Final fase 1_G-P\n", 0, 0, 0);

	while(1) {
		swiWaitForVBlank();
	}							// parar el procesador en un bucle infinito
	
return 0;
}

/* Proceso de prueba */
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
int det3(int a[][3]){
	return (a[0][0]*a[1][1]*a[2][2]+a[0][1]*a[1][2]*a[2][0]+a[1][0]*a[2][1]*a[0][2]-a[0][2]*a[1][1]*a[2][0]-a[0][1]*a[1][0]*a[2][2]-a[1][2]*a[2][1]*a[0][0]);
}

int det4(int a[][4]){
	int factor=1;
	int n=4;
	int det=0;
	int a2[n-1][n-1];
	int i,j,k;
	for(i=0; i<n; i++){
		for(j=0; j<n; j++){
			for(k=0; k<n; k++){
				if(k<i) a2[j][k]=a[j+1][k];
				else a2[j][k]=a[j+1][k+1];
			}
		}
		det+=factor*a[0][i]*det3(a2);
		factor=factor*-1;
	}
	return det;
}

int det5(int a[][5]){
	int factor=1;
	int n=5;
	int det=0;
	int a2[n-1][n-1];
	int i,j,k;
	for(i=0; i<n; i++){
		for(j=0; j<n; j++){
			for(k=0; k<n; k++){
				if(k<i) a2[j][k]=a[j+1][k];
				else a2[j][k]=a[j+1][k+1];
			}
		}
		det+=factor*a[0][i]*det4(a2);
		factor=factor*-1;
	}
	return det;
}

int detm(int arg)				
{	  
	int det, n, i,j;
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	//ordre =2+arguments de entrada
	n=2+arg;
	int a[n][n];
	
	GARLIC_printf("-- Programa DETM  -  PID (%d) --\n", GARLIC_pid());

	for(i=0;i<n;i++){ 
		for(j=0;j<n;j++){
			a[i][j]=GARLIC_random()%10;
		}
	}
	
	/*
	//2x2
	a[0][0]=7;
	a[0][1]=6;
	a[1][0]=4;
	a[1][1]=9;
	//3x3
	a[0][2]=2;
	a[1][2]=9;
	a[2][0]=4;
	a[2][1]=2;
	a[2][2]=1;
	//4x4
	a[0][3]=3;
	a[1][3]=6;
	a[2][3]=1;
	a[3][0]=4;
	a[3][1]=2;
	a[3][2]=1;
	a[3][3]=5;
	//5x5
	a[0][4]=4;
	a[1][4]=7;
	a[2][4]=8;
	a[3][4]=9;
	a[4][0]=1;
	a[4][1]=1;
	a[4][2]=1;
	a[4][3]=1;
	a[4][4]=1;*/
	
/* Llegim elements matriu */ 
	for(i=0;i<n;i++){ 
		for(j=0;j<n;j++){
			GARLIC_printf("(%d)\tElement: %d\n",GARLIC_pid(),a[i][j]);
		}
	}
	
	det=-10;
/*****Càlcul del DETERMINANT*****/
	if(n==2) det=a[0][0]*a[1][1]-a[0][1]*a[1][0];
	else{
		if(n==3) det=det3(a);
		else{
			if(n==4) det=det4(a);
			else{
				//det=det5(a);
				det=-1;
			}
		}
	}
	
	if(n==5) GARLIC_printf("(%d)\tERROR MEMORIA EN MATRIU 5X5\n",GARLIC_pid());
	else GARLIC_printf("(%d)\tDETERMINANT = %d\n",GARLIC_pid(),det);
	return 0;
}
