/*------------------------------------------------------------------------------

	"TERN.c"
	
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
	int trobat =0;
	GARLIC_printf("%0-- %1Programa TERNS%0 --\n");
	
	int n, m=2;
	
	while (c<maxim && !trobat){
		for(n=1;n<m;n++){
			a=m*m-n*n;
			b=2*m*n;
			c=m*m+n*n;
			
			if(c>maxim)
				trobat=1;
			//Si es una terna primitiva
			if(mcd(mcd(a,b),c)==1){
				comptador++;
				GARLIC_printf("%0TERNA %d: (%1 %d%0,",comptador,a);
				GARLIC_printf("%2 %d%0,%3 %d %0)\n",b,c);
			}
		}
		m++;
	}
	return 0;
}


