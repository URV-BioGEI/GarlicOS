/*------------------------------------------------------------------------------

	"DETM.c" : primer programa del ProgP Cristòfol Daudén para el sistema operativo GARLIC 1.0;
	
	Calcula el determinant d'una matriu nxn on n serà 2+l'argument d'entrada al programa
	
	Quan s'intenta calcular el detrminat d'una mariu 5x5 salta un error perque s'excedeix
	la madia màxima de memòria assignada per al programa.

------------------------------------------------------------------------------*/

#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */

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

int _start(int arg)				
{	  
	int det, n, i,j;
	if (arg < 0) arg = 0;			// limitar valor máximo y 
	else if (arg > 3) arg = 3;		// valor mínimo del argumento
	//ordre =2+arguments de entrada
	n=2+arg;
	int a[n][n];
	
	GARLIC_printf("-- Programa DETM  -  PID (%d) --\n", GARLIC_pid());
	//GARLIC_printf("%1-- Programa DETM  -  PID %2(%d) %1--\n", GARLIC_pid());
	
	for(i=0;i<n;i++){ 
		for(j=0;j<n;j++){
			a[i][j]=GARLIC_random()%10;
		}
	}
	
/* Llegim elements matriu */ 
	for(i=0;i<n;i++){ 
		for(j=0;j<n;j++){
			if (arg == 1) GARLIC_delay(1000000);
			GARLIC_printf("(%d)\tElement: %d\n",GARLIC_pid(),a[i][j]);
			//GARLIC_printf("%1(%d)\t%2Element: %3%d\n",GARLIC_pid(),a[i][j]);
			
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
	
	//Visualtzació per quan fusioni amb el progG
	/**if(n==5) GARLIC_printf("%1(%d)\t%2ERROR MEMORIA EN MATRIU 5X5\n",GARLIC_pid());
	else if(det>=0) GARLIC_printf("%1(%d)\t%2DETERMINANT = %3%d\n",GARLIC_pid(),det);
	else GARLIC_printf("%1(%d)\t%2DETERMINANT = %3-%d\n",GARLIC_pid(),det*-1);**/
	
	if(n==5) GARLIC_printf("(%d)\tERROR MEMORIA EN MATRIU 5X5\n",GARLIC_pid());
	else if(det>=0) GARLIC_printf("(%d)\tDETERMINANT = %d\n",GARLIC_pid(),det);
	else GARLIC_printf("(%d)\tDETERMINANT = -%d\n",GARLIC_pid(),det*-1);
	
	return 0;
}