/*------------------------------------------------------------------------------

	"garlic_graf.c" : fase 1 / programador G

	Funciones de gesti�n de las ventanas de texto (gr�ficas), para GARLIC 1.0

------------------------------------------------------------------------------*/
#include <nds.h>

#include <garlic_system.h>	// definici�n de funciones y variables de sistema
#include <garlic_font.h>	// definici�n gr�fica de caracteres

/*definiciones*/
#define NVENT	 4					// n�mero de ventanas totales
#define PPART	 2					// n�mero de ventanas horizontales o verticales (particiones de pantalla)

#define L2_PPART 1				// log base 2 de PPART

#define VCOLS	 32				// columnas y filas de cualquier ventana
#define VFILS	 24
#define PCOLS	 VCOLS * PPART		// n�mero de columnas totales (en pantalla)
#define PFILS	 VFILS * PPART		// n�mero de filas totales (en pantalla)

int bg2, bg3, bg2map;


/* _gg_generarMarco: dibuja el marco de la ventana que se indica por par�metro*/
void _gg_generarMarco(int v)
{
	//mapPtr=mapbase_bg3+desplazamiento de filas
	u16 * mapPtr=bgGetMapPtr(bg3)+(((v)/PPART)*VFILS*PCOLS);
	//si es impar mapPtr=mapPtr+numColumnas de 1 ventana
	if(v%PPART!=0){
		mapPtr=(u16*)mapPtr+VCOLS*(v%PPART);
	}
	//recorremos filas (i=y)
	for (int i=0;i<VFILS;i++){
		//recorremos columnas (j=x)
		for(int j=0;j<VCOLS;j++){
			if(i==0){
				if(j==0)
					mapPtr[j+i*PCOLS]=103;
				else 
				{
				if(j==VCOLS-1)
					mapPtr[j+i*PCOLS]=102;
				else{
					mapPtr[j+i*PCOLS]=99;
					}
				}
			}
			else if(i==VFILS-1){
				if(j==0)
					mapPtr[j+i*PCOLS]=100;
				else 
				{
				if(j==VCOLS-1)
					mapPtr[j+i*PCOLS]=101;
				else
					mapPtr[j+i*PCOLS]=97;
					}
				}
			else{
				if(j==0)
					mapPtr[j+i*64]=96;
				else if(j==VCOLS-1)
					mapPtr[j+i*64]=98;
				}
		}
	}
}


/* _gg_iniGraf: inicializa el procesador gr�fico A para GARLIC 1.0 */
void _gg_iniGrafA()
{
	videoSetMode(MODE_5_2D);
	vramSetBankA(VRAM_A_MAIN_BG_0x06000000);
	lcdMainOnTop();
	//inicialitzaci� del fons gr�fics 2 i 3: S'ha de tenir en compte el tamany que ocupar� cada mapa
	//tamany mapa=n� posicions*n�bytes/posici�=64*64posicions * 2bytes/posici� =8192bytes= 8K (separaci� de 4 mapbase)
	bg2=bgInit(2, BgType_ExRotation,BgSize_ER_512x512,0,3);
	bg3=bgInit(3, BgType_ExRotation,BgSize_ER_512x512,4,3);
	bg2map=(int)bgGetMapPtr(bg2);
	//Prioritat fons 3>fons 2
	bgSetPriority(bg3,0);
	bgSetPriority(bg2,1);
	//void decompress(const void * data, void * dst, DecompressType type)
	decompress(garlic_fontTiles, bgGetGfxPtr(bg3), LZ77Vram);
	
	dmaCopy(garlic_fontPal, BG_PALETTE, sizeof(garlic_fontPal));
	
	//generar los marcos de las ventanas de texto en el fondo 3
	for (int i=0;i<NVENT;i++){
		_gg_generarMarco(i);
	}
	//escalar los fondos 2 y 3 para que se ajusten exactamente a las dimensiones de una pantalla de la nds
	//zoom al 50%
	bgSetScale(bg3,512, 512);
	bgSetScale(bg2, 512, 512);
	bgUpdate();
}



/* _gg_procesarFormato: copia los caracteres del string de formato sobre el
					  string resultante, pero identifica los c�digos de formato
					  precedidos por '%' e inserta la representaci�n ASCII de
					  los valores indicados por par�metro.
	Par�metros:
		formato	->	string con c�digos de formato (ver descripci�n _gg_escribir);
		val1, val2	->	valores a transcribir, sean n�mero de c�digo ASCII (%c),
					un n�mero natural (%d, %x) o un puntero a string (%s);
		resultado	->	mensaje resultante.
	Observaci�n:
		Se supone que el string resultante tiene reservado espacio de memoria
		suficiente para albergar todo el mensaje, incluyendo los caracteres
		literales del formato y la transcripci�n a c�digo ASCII de los valores.
*/
void _gg_procesarFormato(char *formato, unsigned int val1, unsigned int val2,
																char *resultado)
{
	char caract;
	int j=0,i=0,comptador;
	caract=formato[j];
	int var=2;char val[11];
	
	while(caract!='\0'){
		if (caract=='%'){
			j++;
			caract=formato[j];
			//Si se trata de un string
			if(caract=='s' && var>0){
				char * valor=(char *) 0;		//Creamos un puntero a un string
				//Copiamos la direccion del puntero con el valor a transcribir a nuestro puntero
				if(var==2)
					valor=(char *)val1;	
				else if(var==1)
					valor=(char *)val2;
				comptador=0;
				var--;
				//Recorremos el string y lo copiamos a resultado
				while(valor[comptador]!='\0'){
					resultado[i]=valor[comptador];
					comptador++;i++;
				}	
				j++;
			}
			if(caract=='c' && var>0){
				if(var==2)
					resultado[i]=(char)val1;
				else if(var==1)
					resultado[i]=(char)val2;
				var--;
				i++;
				j++;
			}
			else if(caract=='d' && var>0){
				//Guardaremos a val los codigos ascii del valor decimal a transcribir
				if(var==2)
					_gs_num2str_dec(val,sizeof(val),val1);
				else if(var==1)
					_gs_num2str_dec(val,sizeof(val),val2);
				var--;
				comptador=0;
				while(val[comptador]!='\0'){
					if(val[comptador]!=' '){
						resultado[i]=val[comptador];
						i++;}
					comptador++;
				}
				j++;
			}
			else if(caract=='x' && var>0){
				if(var==2)
					_gs_num2str_hex(val,sizeof(val),val1);
				else if(var==1)
					_gs_num2str_hex(val,sizeof(val),val2);
				var--;
				comptador=0;
				while(val[comptador]!='\0'){
					if(val[comptador]!='0'){
						resultado[i]=val[comptador];i++;
					}	
					comptador++;
				}
				j++;
			}
			//Si se tiene que escribir % o no hay mas variables a transcribir
			else if(caract=='%'||var==0){
				if(caract=='%')
					resultado[i]='%';
				else if(var==0){
					resultado[i]='%';i++;
					resultado[i]=caract;
					}
				i++;j++;
			}
		}
		else{
			resultado[i]=formato[j];
			i++;j++;
		}
		caract=formato[j];
	}
}


/* _gg_escribir: escribe una cadena de caracteres en la ventana indicada;
	Par�metros:
		formato	->	cadena de formato, terminada con centinela '\0';
					admite '\n' (salto de l�nea), '\t' (tabulador, 4 espacios)
					y c�digos entre 32 y 159 (los 32 �ltimos son caracteres
					gr�ficos), adem�s de c�digos de formato %c, %d, %x y %s
					(max. 2 c�digos por cadena)
		val1	->	valor a sustituir en primer c�digo de formato, si existe
		val2	->	valor a sustituir en segundo c�digo de formato, si existe
					- los valores pueden ser un c�digo ASCII (%c), un valor
					  natural de 32 bits (%d, %x) o un puntero a string (%s)
		ventana	->	n�mero de ventana (de 0 a 3)
*/
void _gg_escribir(char *formato, unsigned int val1, unsigned int val2, int ventana)
{
	int numChars, filaActual, i=0,primer=0;
	char caracter;
	
	char resultado[3*VCOLS]="";
	
	_gg_procesarFormato(formato,val1,val2,resultado);
	
	//_gd_wbfs:vector con los buffers de las 4  ventanas
	//garlicWBUF: estructura buffer de una ventana: pControl: 16 bits altos->n�mero de l�nea ; 16 bits bajos->chars pendientes de escritura
	
	numChars= _gd_wbfs[ventana].pControl & 0xFFFF;  	//Seleccionamos los bits bajos de pControl con bitwise AND de 16 bits a 1
	filaActual= _gd_wbfs[ventana].pControl >> 16;		//Seleccionamos los bits altos de pControl mediante un shift de 16 bits
	
	caracter=resultado[i];
	//mientras no se llegue al final de la cadena de formato
	while(caracter!='\0'){
		if(caracter=='\t'){
			if (numChars%4==0)
				primer=1;
			//mientras no se acaben de poner los 4 espacios o no se tenga que pasar a la siguiente linea
			while(((numChars<VCOLS) && (numChars%4 !=0 ))|| (primer==1)){
				primer=0;
				_gd_wbfs[ventana].pChars[numChars]=' ';
				numChars++;
			}
		}
		else if(caracter!='\n'|| numChars<VCOLS){
			_gd_wbfs[ventana].pChars[numChars]=caracter;
			numChars++;
		}
		if(caracter=='\n'|| numChars==VCOLS){
			_gp_WaitForVBlank();		//Esperamos al siguiente periodo de retroceso vertical
			//Cuando filaActual=VFILS tendremos que desplazar la ventana
			if(filaActual==VFILS){
				_gg_desplazar(ventana);
				filaActual--;
			}
			_gg_escribirLinea(ventana,filaActual,numChars);
			numChars=0;				//numero de car�cteres de la nueva linea=0
			filaActual++;			//Saltamos a la siguiente linea
		}
		//Se actualiza pControl: shift a l'esquerra de filaActual->El que afegim quedar� als 16 bits baixos, on estar� numChars restant de la fila
		_gd_wbfs[ventana].pControl=(filaActual<<16)+numChars;
		
		i++;
		caracter=resultado[i];
	}
}
