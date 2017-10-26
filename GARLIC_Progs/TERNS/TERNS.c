/*------------------------------------------------------------------------------

	"TERNS.c"
	
	Imprime las ternas pitagóricas por una ventana de GARLIC que
	cumplan c<(arg+1)*2000

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

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

int _start(int arg)				
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
}


