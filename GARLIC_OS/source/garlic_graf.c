/*------------------------------------------------------------------------------

	"garlic_graf.c" : fase 1 / programador G

	Funciones de gestión de las ventanas de texto (gráficas), para GARLIC 1.0

------------------------------------------------------------------------------*/
#include <nds.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <garlic_font.h>	// definición gráfica de caracteres

/*definiciones*/
#define NVENT	 4					// número de ventanas totales
#define PPART	 2					// número de ventanas horizontales o verticales (particiones de pantalla)

#define L2_PPART 1				// log base 2 de PPART

#define VCOLS	 32				// columnas y filas de cualquier ventana
#define VFILS	 24
#define PCOLS	 VCOLS * PPART		// número de columnas totales (en pantalla)
#define PFILS	 VFILS * PPART		// número de filas totales (en pantalla)

int bg2, bg3, bg2map;


/* _gg_generarMarco: dibuja el marco de la ventana que se indica por parámetro*/
void _gg_generarMarco(int v, int color)
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


/* _gg_iniGraf: inicializa el procesador gráfico A para GARLIC 1.0 */
void _gg_iniGrafA()
{
	videoSetMode(MODE_5_2D);
	vramSetBankA(VRAM_A_MAIN_BG_0x06000000);
	lcdMainOnTop();
	//inicialització del fons gràfics 2 i 3: S'ha de tenir en compte el tamany que ocupará cada mapa
	//tamany mapa=nº posicions*nºbytes/posició=64*64posicions * 2bytes/posició =8192bytes= 8K (separació de 4 mapbase)
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
		_gg_generarMarco(i, 0); // afegit argument per a la compilacio del commit inicial fase 2
	}
	//escalar los fondos 2 y 3 para que se ajusten exactamente a las dimensiones de una pantalla de la nds
	//zoom al 50%
	bgSetScale(bg3,512, 512);
	bgSetScale(bg2, 512, 512);
	bgUpdate();
}



/* _gg_procesarFormato: copia los caracteres del string de formato sobre el
					  string resultante, pero identifica los códigos de formato
					  precedidos por '%' e inserta la representación ASCII de
					  los valores indicados por parámetro.
	Parámetros:
		formato	->	string con códigos de formato (ver descripción _gg_escribir);
		val1, val2	->	valores a transcribir, sean número de código ASCII (%c),
					un número natural (%d, %x) o un puntero a string (%s);
		resultado	->	mensaje resultante.
	Observación:
		Se supone que el string resultante tiene reservado espacio de memoria
		suficiente para albergar todo el mensaje, incluyendo los caracteres
		literales del formato y la transcripción a código ASCII de los valores.
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
	Parámetros:
		formato	->	cadena de formato, terminada con centinela '\0';
					admite '\n' (salto de línea), '\t' (tabulador, 4 espacios)
					y códigos entre 32 y 159 (los 32 últimos son caracteres
					gráficos), además de códigos de formato %c, %d, %x y %s
					(max. 2 códigos por cadena)
		val1	->	valor a sustituir en primer código de formato, si existe
		val2	->	valor a sustituir en segundo código de formato, si existe
					- los valores pueden ser un código ASCII (%c), un valor
					  natural de 32 bits (%d, %x) o un puntero a string (%s)
		ventana	->	número de ventana (de 0 a 3)
*/
void _gg_escribir(char *formato, unsigned int val1, unsigned int val2, int ventana)
{
	int numChars, filaActual, i=0,primer=0;
	char caracter;
	
	char resultado[3*VCOLS]="";
	
	_gg_procesarFormato(formato,val1,val2,resultado);
	
	//_gd_wbfs:vector con los buffers de las 4  ventanas
	//garlicWBUF: estructura buffer de una ventana: pControl: 16 bits altos->número de línea ; 16 bits bajos->chars pendientes de escritura
	
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
			numChars=0;				//numero de carácteres de la nueva linea=0
			filaActual++;			//Saltamos a la siguiente linea
		}
		//Se actualiza pControl: shift a l'esquerra de filaActual->El que afegim quedará als 16 bits baixos, on estará numChars restant de la fila
		_gd_wbfs[ventana].pControl=(filaActual<<16)+numChars;
		
		i++;
		caracter=resultado[i];
	}
}
