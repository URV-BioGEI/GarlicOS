/*------------------------------------------------------------------------------

	"garlic_tecl.c" : Contiene fuciones comunes para la gestión de teclado
	
	Inicializa toda la información necesaria para la gestión del teclado, como las
	variables globales, los gráficos, instalar la RSI de teclado, etc.

------------------------------------------------------------------------------*/

//#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */
#include <nds.h>
#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <garlic_font.h>	// definición gráfica de caracteres

char _gt_minset[4][30] = {{' ', '\\', ' ', '1', ' ', '2', ' ', '3', ' ', '4', ' ', '5', ' ', '6', ' ', '7', ' ', '8', ' ', '9', ' ', '0', ' ', '\'', ' ', '{', ' ', '~', ' ', ' '},
						   {'@', ' ' , '<', ' ', 'q', ' ', 'w', ' ', 'e', ' ', 'r', ' ', 't', ' ', 'y', ' ', 'u', ' ', 'i', ' ', 'o' , ' ', 'p', ' ', '[', ' ', ' ', 'D', 'E', 'L'},
						   {'C', 'A' , 'P', 'S', ' ', 'a', ' ', 's', ' ', 'd', ' ',  'f', ' ','g', ' ', 'h', ' ', 'j', ' ', 'k', ' ' , 'l', ' ', '-', ' ', 'I', 'N', 'T', 'R', 'O'},
						   {'S', 'P' , 'A', 'C', 'E', ' ', 'z', ' ', 'x', ' ', 'c', ' ', 'v', ' ', 'b', ' ', 'n', ' ', 'm', ' ', ',' , ' ', '.', ' ', ' ', '<', '=', ' ', '=', '>'}};

char _gt_majset[4][30] = {{' ', '+', ' ', '!', ' ', '"', ' ', '#', ' ', '$', ' ', '%', ' ', '&', ' ', '/', ' ', '(', ' ', ')', ' ', '=', ' ', '?', ' ', '}', ' ', '|', ' ', ' '},
						   {'*', ' ', '>', ' ', 'Q', ' ', 'W', ' ', 'E', ' ', 'R', ' ', 'T', ' ', 'Y', ' ', 'U', ' ', 'I', ' ', 'O', ' ', 'P', ' ', ']', ' ', ' ', 'D', 'E', 'L'},
						   {'C', 'A', 'P', 'S', ' ', 'A', ' ', 'S', ' ', 'D', ' ', 'F',' ' , 'G', ' ', 'H', ' ', 'J', ' ', 'K', ' ', 'L', ' ', '_', ' ', 'I', 'N', 'T', 'R', 'O'},
			    		   {'S', 'P', 'A', 'C', 'E', ' ', 'Z', ' ', 'X', ' ', 'C', ' ', 'V', ' ', 'B', ' ', 'N', ' ', 'M', ' ', ';', ' ', ':', ' ', ' ', '<', '=', ' ', '=', '>'}};
 

//_gt_set[0].set = _gt_minset;
	//_gt_set[1].set = _gt_minset;
void _gt_initKB()
{
	//lcdMainOnTop();

	int i;
	
	/* Instalem la rsi del IRQ IPC SYNC de la NDS:
	Això indica al controlador general d'interrupcions que quan es produeixi la interrupció IRQ_IPC_SYNC
	ha d'executar la funció rsi que nosaltres li indiquem per a gestionar la interrupcio */
	irqSet(IRQ_IPC_SYNC, _gt_rsi_IPC_SYNC);
	
	/*Habilitem al registre de control REG_IPC_SYNC el bit 13 amb la máscara IPC_SYNC_IRQ_ENABLE
	que permet rebre interrupcions IPC_SYNC de l'altre processador. En aquest cas ARM7 podra interrompre
	al ARM9. Caldra habilitar el bit complementari (bit 14) del mateix registre pero DE L'ALTRE PROCESSADOR
	per a que es pugui generar la interrupcio. */
	REG_IPC_SYNC = 0;
	REG_IPC_SYNC = IPC_SYNC_IRQ_REQUEST | IPC_SYNC_IRQ_ENABLE;	

	/* Instalem la rsi del IRQ IPC FIFO de la NDS:
	Això indica al controlador general d'interrupcions que quan es produeixi la interrupció IRQ_IPC_FIFO
	ha d'executar la funció rsi que nosaltres li indiquem per a gestionar la interrupcio */
	irqSet(IRQ_FIFO_NOT_EMPTY, _gt_rsi_IPC_FIFO);
	
	/* Indiquem que es poden produir interrupcions procedint d'aqeusts dispositiu. També iniciem la cua */
	REG_IPC_FIFO_CR = IPC_FIFO_ENABLE | IPC_FIFO_RECV_IRQ | 1 << 15 | 1 << 10 | IPC_FIFO_SEND_CLEAR;

	/* Indiquem al registre IE (interrupt enable) que les interrupcions següents estan actives:
		- IRQ_IPC_SYNC: per a rebre l'estat dels botons X i Y
		- IRQ_FIFO_NOT_EMPTY: Per a rebre informacio sobre iteraccio tactil amb el teclat
		*/
	irqEnable(IRQ_IPC_SYNC | IRQ_FIFO_NOT_EMPTY);	
	
	/* Inicializamos procesador gráfico en el modo 0 (los 4 fondos en modo texto) */
	videoSetModeSub(MODE_0_2D);
	
	/* Asignamos el banco de memoria B como fondo principal*/
	vramSetBankC(VRAM_C_SUB_BG_0x06200000);
	
	/*	arg 0: Layer, capa de fondo. (0-3) siendo 0 más prioritario
			bg1	-> cursor
			bg1	-> linea de texto
			bg2 -> Ventana completa de instrucciones
		arg 1: Tipo de fondo (tipo texto con 4 bits por pixel)
		arg 2: Dimensiones de tipo texto 32x32
		arg 3: MapBase = n -> @fondo + n*2KB; @base -> 0x0600 0000
		arg 4: TileBase = n -> @fondo + n*16KB 
	*/
	_gt_bginfo = bgInitSub(BG_PRIORITY(2), BgType_Text8bpp, BgSize_T_256x256, 4, 1);
	_gt_bgbox = bgInitSub(BG_PRIORITY(1), BgType_Text8bpp, BgSize_T_256x256, 5, 1);
	_gt_bgcursor = bgInitSub(BG_PRIORITY(0), BgType_Text8bpp, BgSize_T_256x256, 6, 1);
	
	/* Inicializamos las variables globales de dirección del mapa de baldosas de los diferentes
	fondos */
	_gt_mapbaseinfo = bgGetMapPtr(_gt_bginfo);
	_gt_mapbasebox = bgGetMapPtr(_gt_bgbox);
	_gt_mapbasecursor = bgGetMapPtr(_gt_bgcursor);
	
	/* Descomprimimos las baldosas de GARLIC y los copiamos en la posición de mem 
	donde estan definidas la posicion de las baldosas en uno de los fondos, debido 
	a que se ha indicado que todos los mapas tienen su mapa de baldosas en el mismo 
	sitio solamente necesitamos hacer una copia */
	decompress(garlic_fontTiles, bgGetGfxPtr(_gt_bgbox), LZ77Vram);
	
	/* Copiamos la paleta de colores de GARLIC en la paleta de colores del procesador 
	secundario */
	dmaCopy(garlic_fontPal, BG_PALETTE_SUB, garlic_fontPalLen);
	
	/* Carreguem els missatges */
				/*   I  n  p  u  t     f  o   r    z  0 0      (  P  I  D    0000         )  :		*/
	int str1[26] = {41,78,80,85,84,0,70,79,82,0,90,16,16,0,8,48,41,36,0,16,16,16,16,16,9,26};
	for(i=0; i<26;i++)
		_gt_mapbasebox[i]= str1[i];
	
	// Inicialitzem el fons color carn per a 12 files
	for(i=0; i<(32*12); i++){
		_gt_mapbaseinfo[i]=(128*3)+95;
	}
	
	// Cursor
	//_gt_mapbasecursor[166]=128*3+113;

	// Quadre per l'esquerra
	_gt_mapbasebox[32*2]=32*3+2;
	
	// Quadre per la dreta
	_gt_mapbasebox[32*2+31]=32*3;
	
	// Quadre de text per dalt i per baix
	for(i=0; i<30; i++){
		_gt_mapbasebox[32+1+i]=32*3+1;
		_gt_mapbasebox[32*3+1+i]=32*3+3;
	}

	// Inicialitza blanc del quadre de text
	for(i=0; i<30; i++){
		_gt_mapbaseinfo[32*2+1+i]=95;
	}
	
	// Rajoles blaves per la primera linia
	for(i=0; i<30; i++)
	{
		if(i%2!=0)
		{
			_gt_mapbaseinfo[32*4+1+i]=128+32*2+31;
		}
	}
	
	// Rajoles blaves per la segona linia
	for(i=0; i<30; i++){
		if(i%2==0&&i<25) {
			_gt_mapbaseinfo[193+i]=128+95;
		}
	}
	
	// Rajoles blaves per la tercera linia
	for(i=0; i<30; i++){
		if(i%2==0&&i<19) {
			_gt_mapbaseinfo[262+i]=128+95;
		}
	}
	
	// Rajoles blaves per la quarta linia
	for(i=0; i<30; i++){
		if(i%2==0&&i<17) {
			_gt_mapbaseinfo[327+i]=128+95;
		}
	}
	
	// rajoles per intro i space
	for(i=0; i<5; i++)
	{
		_gt_mapbaseinfo[282+i]=128+95; // inicialitzem rajoletes blaves intro
		//CUARTA FILA
		_gt_mapbaseinfo[321+i]=128+95; // inicialitzem rajoletes blaves space
	}
	
	// Inicialitzem les rajoletes de les tecles del cursor
	for(i=0; i<2; i++){
		_gt_mapbaseinfo[346+i]=128+95;
		_gt_mapbaseinfo[349+i]=128+95;
	}
	
	// les rajoletes del DEL
	_gt_mapbaseinfo[220]=128+95;
	_gt_mapbaseinfo[221]=128+95;
	_gt_mapbaseinfo[222]=128+95;
	
	 //Inicialitzem input 
	for (i = 0; i < 31; i++) _gt_input[i] = -1;
	
		/* Inicialitzem comptador de processos */
	_gd_nKeyboard = 0; 
	
	/* Posem la visibilitat del teclat a fals */
	_gt_kbvisible = false;
	
	/* inicialitzem el cursor*/
	_gt_cursorini();
	
	/* Indiquem que el bloc majúscules està desactivat */
	_gt_CAPS_lock = 1;
	
	/* Inicialitzem la part grafica del teclat */
	_gt_graf();
	
	/* Inicialitzem l'estat dels botons com si no estiguessin sent apretats*/
	_gt_XYbuttons = 3;
	
	/* Amaguem el teclat */
	_gt_hideKB();
}

void _gt_graf()
{
	short int i,j;
	char tmpset[4][30];
	// Escollir entre majuscules o minuscules
	if(_gt_CAPS_lock){
		for (i = 0; i < 4; i++)
		{
			for (j = 0; j < 30; j++)
			{
				tmpset[i][j] = _gt_majset[i][j];
			}
		}
	} 
	else 
	{
		for (i = 0; i < 4; i++)
		{
			for (j = 0; j < 30; j++)
			{
				tmpset[i][j] = _gt_minset[i][j];
			}
		}
	}

	// PRIMERA FILA
	for(i=0; i<30; i++)
	{
		_gt_mapbasebox[32*4+1+i] = tmpset[0][i]-32;
	}
	
	// SEGONA FILA
	for(i=0; i<30; i++)
	{
		_gt_mapbasebox[193+i] = tmpset[1][i]-32;
	}

	// TERCERA FILA
	for(i=0; i<30; i++)
	{
		_gt_mapbasebox[257+i] = tmpset[2][i]-32;
	}
	
	// rajoles del caps, que estaran a lila o no segons l'estat de les majuscules
	for(i=0; i<4; i++){
		if (_gt_CAPS_lock==0){
			_gt_mapbaseinfo[257+i]=128+95;
		} else {
			_gt_mapbaseinfo[257+i]=256+95;
		}
	}
	
	// CUARTA FILA
	for(i=0; i<30; i++)
	{
		_gt_mapbasebox[321+i]=tmpset[3][i]-32;
	}
}

void _gt_writePIDZ(char zoc)
{
	int i;
	_gs_num2str_dec(_gt_PIDZ_tmp, 2, zoc);
	
	for (i = 0; i < 2; i++)
	{
		if (_gt_PIDZ_tmp[i] == 32) _gt_mapbasebox[11+i] = _gt_PIDZ_tmp[i]-16;
		else _gt_mapbasebox[11+i] = _gt_PIDZ_tmp[i]-32;
	}
	
	_gs_num2str_dec(_gt_PIDZ_tmp, 6, _gd_pcbs[(int)zoc].PID);

	for (i = 0; i < 5; i++)
	{
		if (_gt_PIDZ_tmp[i] == 32) _gt_mapbasebox[19+i] = _gt_PIDZ_tmp[i]-16;
		else _gt_mapbasebox[19+i] = _gt_PIDZ_tmp[i]-32;
	}
}
	
void _gt_showKB(char zoc)
{	
	_gt_kbvisible = 1;	// indiquem que teclat mostrat

	bgShow(_gt_bginfo);		// activem els fons del teclat
	bgShow(_gt_bgbox);
	bgShow(_gt_bgcursor);
	
	_gt_writePIDZ(zoc);	// escribim el pidz del procés rebut per parametre en la finestreta
}

void _gt_hideKB()
{
	bgHide(_gt_bginfo);		// amaguem tots els background
	bgHide(_gt_bgbox);
	bgHide(_gt_bgcursor);
	
	_gt_kbvisible = false;	// indiquem que teclat amagat	
}