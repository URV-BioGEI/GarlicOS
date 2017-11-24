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
	
	//_gt_showKB(1);
}

//------------------------------------------------------------------------------
int main(int argc, char **argv) {
//------------------------------------------------------------------------------
	intFunc start, start1;	
	inicializarSistema();
	int i=4;
	
	GARLIC_printf("********************************");
	GARLIC_printf("*                              *");
	GARLIC_printf("* Sistema Operativo GARLIC 1.0 *");
	GARLIC_printf("*                              *");
	GARLIC_printf("********************************");
	GARLIC_printf("*** Inicio fase 1_G-P\n");

	start = _gm_cargarPrograma("HOLA");
	GARLIC_printf("*** Direccion de arranque :\n\t\t%p\n", start);
	if (start)
	{	
		_gp_crearProc(start, 2, "HOLA", 1);
		//GARLIC_printf("*** Direccion de arranque :\n\t\t%p\n", start);
	} else printf("*** Programa \"HOLA\" NO cargado\n");

	


	start1 = _gm_cargarPrograma("PRNT");
	GARLIC_printf("*** Direccion de arranque :\n\t\t%p\n", start1);
	if (start1)
	{	
		_gp_crearProc(start1, 1, "PRNT", 2);
		//GARLIC_printf("*** Direccion de arranque :\n\t\t%p\n", start1);
	} 
	else printf("*** Programa \"PRNT\" NO cargado\n");
	
	
	start = _gm_cargarPrograma("CUAD");
	if (start)
	{	
		//GARLIC_printf("*** Direccion de arranque :\n\t\t%p\n", start);
		_gp_crearProc(start, 3, "CUAD", 2);
	} else printf("*** Programa \"CUAD\" NO cargado\n");
	
	//printf("*** Final fase 1_M\n");
	
	//mentre hi hagi processos en execució diferents del S.O
	while(_gp_numProc()>=1){
		if(_gp_numProc()<i){
			_gg_escribir("\t*** HA ACABAT UN PROCES\n", 0, 0, 0);
			i--;
		}
	}
	
	// parar el procesador en un bucle infinito
	while (1) {
		_gp_WaitForVBlank();
	}							
	
return 0;
}

/* Proceso de prueba, con llamadas a las funciones del API del sistema Garlic 

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

 Proceso de prueba ProgP, con llamadas a las funciones del API del sistema Garlic 
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
	
/* Llegim elements matriu 
	for(i=0;i<n;i++){ 
		for(j=0;j<n;j++){
			GARLIC_printf("(%d)\tElement: %d\n",GARLIC_pid(),a[i][j]);
		}
	}
	
	det=-10;
*****Càlcul del DETERMINANT*****
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
 Proceso de prueba ProgP, con llamadas a las funciones del API del sistema Garlic 
//------------------------------------------------------------------------------
unsigned int mcd(unsigned int a,unsigned int b){
	unsigned int aux, quociente, modulo;
	
	while(b!=0){
		aux=b;
		GARLIC_divmod(a,b,&quociente,&modulo);
		b=modulo;
		a=aux;
	}
	return a;
}

int tern(int arg)				
{
	unsigned int maxim=(arg+1)*2000;
	unsigned int a, b,c =0, comptador=0;
	GARLIC_printf("-- Programa TERNS --\n");
	
	int n, m=2;
	
	while (c<maxim){
		for(n=1;n<m;n++){
			a=m*m-n*n;
			b=2*m*n;
			c=m*m+n*n;
			
			if(c>maxim)
				break;
			//Si es una terna primitiva
			if(mcd(mcd(a,b),c)){
				comptador++;
				GARLIC_printf("TERNA %d : ( %d,",comptador,a);
				GARLIC_printf(" %d, %d )\n",b,c);
			}
		}
		m++;
	}
	return 0;
}*/


