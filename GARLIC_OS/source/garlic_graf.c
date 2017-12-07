/*------------------------------------------------------------------------------

	"garlic_graf.c" : fase 1 / programador G

	Funciones de gestión de las ventanas de texto (gráficas), para GARLIC 1.0

------------------------------------------------------------------------------*/
#include <nds.h>

#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <garlic_font.h>	// definición gráfica de caracteres

/*definiciones*/
#define NVENT	 16					// número de ventanas totales
#define PPART	 4					// número de ventanas horizontales o verticales (particiones de pantalla)

#define L2_PPART 2				// log base 2 de PPART

#define VCOLS	 32				// columnas y filas de cualquier ventana
#define VFILS	 24
#define PCOLS	 VCOLS * PPART		// número de columnas totales (en pantalla)
#define PFILS	 VFILS * PPART		// número de filas totales (en pantalla)

int bg2, bg3, bg2map;

const unsigned int char_colors[] = {240, 96, 64};	// amarillo, verde, rojo

/* _gg_generarMarco: dibuja el marco de la ventana que se indica por parámetro*/
void _gg_generarMarco(int v, int color)
{
	//mapPtr=mapbase_bg3+desplazamiento de filas
	u16 * mapPtr = bgGetMapPtr(bg3)+ ( ((v)/ PPART)* VFILS* PCOLS);
	//si es impar mapPtr=mapPtr+numColumnas de 1 ventana
	if(v%PPART != 0)
	{
		mapPtr=(u16*) mapPtr+VCOLS * (v % PPART);
	}
	
	int indexColor = color * 128;
	
	//recorremos filas (i=y)
	for (int i=0 ; i<VFILS ; i++)
	{
		//recorremos columnas (j=x)
		for(int j=0 ; j<VCOLS ; j++)
		{
			if(i==0)
			{
				if(j == 0)
					mapPtr[j + i * PCOLS]= 103 + indexColor;
				else 
				{
				if(j == VCOLS-1)
					mapPtr[j + i * PCOLS]= 102 + indexColor;
				else{
					mapPtr[j + i * PCOLS]= 99 + indexColor;
					}
				}
			}
			else if(i == VFILS-1){
				if(j==0)
					mapPtr[j + i * PCOLS]= 100 + indexColor;
				else 
				{
				if(j==VCOLS-1)
					mapPtr[j + i * PCOLS]=101 + indexColor;
				else
					mapPtr[j + i * PCOLS]=97 + indexColor;
					}
				}
			else{
				if(j==0)
					mapPtr[j + i * PCOLS]=96 + indexColor;
				else if(j==VCOLS-1)
					mapPtr[j + i * PCOLS]=98 + indexColor;
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
	//tamany mapa=nº posicions*nºbytes/posició=128*128posicions * 2bytes/posició =327682bytes= 32K (separació de 4 mapbase)
	bg2 = bgInit(2, BgType_ExRotation,BgSize_ER_1024x1024,0,4);
	bg3 = bgInit(3, BgType_ExRotation,BgSize_ER_1024x1024,16,4);
	bg2map = (int) bgGetMapPtr(bg2);
	
	//Prioritat fons 3>fons 2
	bgSetPriority(bg3,0);
	bgSetPriority(bg2,1);
	
	//void decompress(const void * data, void * dst, DecompressType type)
	decompress(garlic_fontTiles, bgGetGfxPtr(bg3), LZ77Vram);
	
	dmaCopy(garlic_fontPal, BG_PALETTE, sizeof(garlic_fontPal));
	
	//tamaño tiles: 8*8 píxeles 8bpp ->64bytes/tile
	//tamaño tiles: 64 bytes/tile * 128 tiles = 8192
	//cada acceso a memoria vram carga un halfword ->16 bits / 2 bytes
	//Índice recorrido -> 8192/2 posiciones vram
	
	int index = 4096;
	
	int numColors= sizeof(char_colors)/sizeof(unsigned int);
	
	u16* base = bgGetGfxPtr(bg3);
	
	for(int colors= 0; colors < numColors; colors++)
	{
		for(int i= 0; i< index; i++)
		{
			if(base[i]==0x00FF)
				base[index * (colors + 1) + i] = (u16)char_colors[colors];
				
			else if(base[i]==0xFF00)
				base[index * (colors + 1) + i] = (u16)char_colors[colors] << 8;
				
			else if(base[i]==0xFFFF)
				base[index * (colors + 1) + i] = (u16)char_colors[colors] + ((u16)char_colors[colors] << 8) ;
		}
	}
	
	
	//generar los marcos de las ventanas de texto en el fondo 3
	for (int i=0 ; i< NVENT ; i++)
	{
		_gg_generarMarco(i, 2); // afegit argument per a la compilacio del commit inicial fase 2
	}
	
	//escalar los fondos 2 y 3 para que se ajusten exactamente a las dimensiones de una pantalla de la nds
	//zoom al 50%
	bgSetScale(bg3, 1024, 1024);
	bgSetScale(bg2, 1024, 1024);
	
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
	
	while(caract!='\0')
	{
		if (caract=='%')
		{
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
				while(valor[comptador]!='\0')
				{
					resultado[i]=valor[comptador];
					comptador++;i++;
				}	
				j++;
			}
			if(caract=='c' && var>0)
			{
				if(var==2)
					resultado[i]=(char)val1;
				else if(var==1)
					resultado[i]=(char)val2;
				var--;
				i++;
				j++;
			}
			else if(caract=='d' && var>0)
			{
				//Guardaremos a val los codigos ascii del valor decimal a transcribir
				if(var==2)
					_gs_num2str_dec(val,sizeof(val),val1);
				else if(var==1)
					_gs_num2str_dec(val,sizeof(val),val2);
				var--;
				comptador=0;
				while(val[comptador]!='\0')
				{
					if(val[comptador]!=' ')
					{
						resultado[i]= val[comptador];
						i++;
					}
					comptador++;
				}
				j++;
			}
			else if(caract=='x' && var>0)
			{
				if(var==2)
					_gs_num2str_hex(val, sizeof(val), val1);
				else if(var==1)
					_gs_num2str_hex(val, sizeof(val), val2);
				var--;
				comptador=0;
				while(val[comptador] != '\0')
				{
					if(val[comptador] != '0')
					{
						resultado[i]=val[comptador];
						i++;
					}	
					comptador++;
				}
				j++;
			}
			//Si se tiene que escribir % o no hay mas variables a transcribir
			else if(caract=='%'|| var==0 || (caract>= 48 && caract<=51 ))
			{
				if(caract=='%')
				{
					resultado[i]= caract;
				}
				else if(var==0 || (caract >= 48 && caract <= 51 ))
				{
					resultado[i]= '%';
					i++;
					resultado[i]= caract;
				}
				
				i++;
				j++;
			}
		}
		else
		{
			resultado[i]=formato[j];
			i++;
			j++;
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
	int numChars, filaActual, i=0,primer=0;int color;
	char caracter;
	
	char resultado[3*VCOLS+1]="";
	
	_gg_procesarFormato(formato, val1, val2, resultado);
	
	//_gd_wbfs:vector con los buffers de las 4  ventanas
	//garlicWBUF: estructura buffer de una ventana: pControl: 16 bits altos->número de línea ; 16 bits bajos->chars pendientes de escritura
	
	numChars = _gd_wbfs[ventana].pControl & 0xFFFF;  				//Seleccionamos los bits bajos de pControl con bitwise AND de 16 bits a 1
	filaActual = (_gd_wbfs[ventana].pControl & 0x0FFF0000) >> 16;		//Seleccionamos los bits medios de pControl mediante un shift de 12 bits i and de 12 bits a 1
	color = _gd_wbfs[ventana].pControl >> 28; 			//Seleccionamos los 4 bits altos correspondientes al color
	
	caracter = resultado[i];
	
	//mientras no se llegue al final de la cadena de formato
	while(caracter!='\0')
	{
		if(caracter== '%' && (resultado[i+1] >= 48 && resultado[i+1] <= 51 ))
		{
			i++;
			switch(resultado[i]){
				case '0':
					color = 0;
					break;
				case '1':
					color = 1;
					break;
				case '2':
					color = 2;
					break;
				case '3':
					color = 3;
					break;
			}
			
			_gd_wbfs[ventana].pControl = (( _gd_wbfs[ventana].pControl & 0x0FFFFFFF) + (color << 28));
			i++;
			caracter = resultado[i];
		}
		
		if(caracter=='\t')
		{
			if (numChars % 4 == 0)
				primer=1;
			//mientras no se acaben de poner los 4 espacios o no se tenga que pasar a la siguiente linea
			while(( (numChars<VCOLS) && (numChars % 4 !=0 ) ) || (primer==1))
			{
				primer = 0;
				_gd_wbfs[ventana].pChars[numChars] = ' ';
				numChars++;
			}
		}
		else if(caracter != '\n' && numChars < VCOLS)
		{
			_gd_wbfs[ventana].pChars[numChars] = caracter +  (128 * color);
			numChars++;
		}
		
		if(caracter == '\n' || numChars == VCOLS)
		{
			_gp_WaitForVBlank();		//Esperamos al siguiente periodo de retroceso vertical
			//Cuando filaActual=VFILS tendremos que desplazar la ventana
			
			if(filaActual == VFILS)
			{
				_gg_desplazar(ventana);
				filaActual--;
			}
			
			_gg_escribirLinea(ventana, filaActual, numChars);
			numChars=0;				//numero de carácteres de la nueva linea=0
			filaActual++;			//Saltamos a la siguiente linea
		}
		//Se actualiza pControl: shift a l'esquerra de filaActual->El que afegim quedará als 16 bits baixos, on estará numChars restant de la fila
		_gd_wbfs[ventana].pControl = ((color & 0xF) << 28) + ((filaActual & 0x0FFF) << 16) + numChars;
		i++;
		caracter = resultado[i];
	}
}
