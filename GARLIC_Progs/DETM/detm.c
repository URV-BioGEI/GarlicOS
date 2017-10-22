/*------------------------------------------------------------------------------

	"DETM.c" : primer programa del ProgP Cristòfol Daudén para el sistema operativo GARLIC 1.0;
	
	Calcula el determinant d'una matriu nxn on n serà 2+l'argument d'entrada al programa

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

int _start(int arg)				/* función de inicio : no se usa 'main' */
{
	
	int i,j,k,l,m,n ; 
	float a[5][5]; 
	float det;	
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	
	//ordre =2+arguments de entrada
	n=2+arg;
	m=n-1; 
	
	//CAS EN QUE EL PROG T COMPLETI LA TASCA
	/* Vamos a introducir la matriz por teclado*/ 
	/*GARLIC_printf("\t\tIntroducir los elementos por FILAS \n"); 
	GARLIC_printf("\t\t---------------------------------- \n"); 
	for(i=1;i<=n;i++){ 
		for(j=1;j<=n;j++){ 
			GARLIC_printf("A(%d,%d) =",i,j); 
			GARLIC_scanf("%f",&a[i][j]); 
		} 
	}*/
	for(i=1;i<=n;i++){ 
		for(j=1;j<=n;j++){ 
			a[i][j]=GARLIC_random()%10;
		}
	}
	
/* Llegim elements matriu */ 
	for(i=1;i<=n;i++){ 
		for(j=1;j<=n;j++) GARLIC_printf("\t\t\tA(%d,%d) =%8.4f\n",i,j,a[i][j] ); 
	} 

/*****Càlcul del DETERMINANT*****/ 
	det=a[1][1]; 
	for(k=1;k<=m;k++){ 
		l=k+1; 
		for(i=l;i<=n;i++){ 
			for(j=l;j<=n;j++) a[i][j] = ( a[k][k]*a[i][j]-a[k][j]*a[i][k] )/a[k][k]; 
		} 
		det=det*a[k+1][k+1]; 
	} 
	GARLIC_printf("\n\n"); 
	GARLIC_printf("\t\t\tDETERMINANT = %f\n", det); 
	GARLIC_printf("\t\t\t-------------------------\n");

	return 0;
}
