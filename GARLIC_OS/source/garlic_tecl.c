/*------------------------------------------------------------------------------

	"garlic_tecl.c" : Contiene fuciones comunes para la gestión de teclado
	
	Inicializa toda la información necesaria para la gestión del teclado, como las
	variables globales, los gráficos, instalar la RSI de teclado, etc.

------------------------------------------------------------------------------*/

//#include <GARLIC_API.h>			/* definición de las funciones API de GARLIC */
#include <nds.h>
#include <garlic_system.h>	// definición de funciones y variables de sistema
#include <garlic_font.h>	// definición gráfica de caracteres

void _gt_initKB()
{
	//lcdMainOnTop();

	int i;
	
	/* Instalem la IRQ del sistema FIFO*/
	
	//INT_instalarRSIPrincipal((u32 *)0x0B003FFC, rsi_principal, IRQ_VBLANK | IRQ_TIMER0 | IRQ_FIFO_NOT_EMPTY);
	//REG_IPC_FIFO_CR = IPC_FIFO_ENABLE | IPC_FIFO_RECV_IRQ;
	
	/* Instalem la IRQ FIFO de la NDS:
	Això indica al controlador general d'interrupcions que quan es produeixi la interrupció IRQ_FIFO_NOT_EMPTY
	ha d'executar la funció rsi que nosaltres li indiquem per a gestionar la interrupcio */
	irqSet(IRQ_KEYS, _gt_rsiKB);
	
	/* Activamos RSIs de las teclas A, B, SELECT, START, los cursores derecho e izquierdo 
	y activamos el interruptor general de IRQ por teclado */
	REG_KEYCNT = KEY_A | KEY_B | KEY_SELECT | KEY_START | KEY_RIGHT | KEY_LEFT | (1<<14);
	
	/* Activación IRQ en el registro principal del controlador de interrupciones */
	REG_IME=IME_ENABLE;
	/* Inicializamos procesador gráfico en el modo 0 (los 4 fondos en modo texto) */
	videoSetModeSub(MODE_0_2D);
	/* Asignamos el banco de memoria B como fondo principal*/
	vramSetBankC(VRAM_C_SUB_BG_0x06200000);
	
	/*	arg 0: Layer, capa de fondo. (0-3) siendo 0 más prioritario
			bg0	-> cursor
			bg1	-> linea de texto
			bg2 -> Ventana completa de instrucciones
		arg 1: Tipo de fondo (tipo texto con 4 bits por pixel)
		arg 2: Dimensiones de tipo texto 32x32
		arg 3: MapBase = n -> @fondo + n*2KB; @base -> 0x0600 0000
		arg 4: TileBase = n -> @fondo + n*16KB 
	*/
	_gt_bginfo = bgInitSub(BG_PRIORITY(0), BgType_Text8bpp, BgSize_T_256x256, 4, 0);
	_gt_bgbox = bgInitSub(BG_PRIORITY(1), BgType_Text8bpp, BgSize_T_256x256, 5, 0);
	_gt_bgcursor = bgInitSub(BG_PRIORITY(2), BgType_Text8bpp, BgSize_T_256x256, 6, 0);
	
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
	
	/* Inicialitzem comptador de processos */
	_gd_kbwait_num = 0; 
	
	/* Posem la visibilitat del teclat a fals */
	_gt_kbvisible = false;
	
	/* Carreguem els missatges */
				/*   I  n  p  u  t     f  o   r    z  0  0   (  P  I  D    0  0  0  0  0  )  :		*/
	int str1[26] = {41,78,80,85,84,0,70,79,82,0,90,16,16,0,8,48,41,36,0,16,16,16,16,16,9,26};
	for(i=0; i<26;i++)
		_gt_mapbaseinfo[33+i]= str1[i];
	
	/* final de quadre per l'esquerre */
	_gt_mapbaseinfo[65]=106;
	_gt_mapbaseinfo[97]=104;
	_gt_mapbaseinfo[129]=107;
	
	/* final de quadre per la dreta */
	_gt_mapbaseinfo[94]=109;
	_gt_mapbaseinfo[126]=104;
	_gt_mapbaseinfo[158]=108; 
	
	
	/* Cuadre de text per dalt i per baix*/
	for(i=0; i<28; i++){
		_gt_mapbaseinfo[66+i]=105;
		_gt_mapbaseinfo[130+i]=105;
	}

	
	/*	            '  A  /  B  ' :   c  a	r  a  c  t  e   r   '  <  /  >  ' :   p  o  s  i  c  i  o  n */
	int str2[29] = {7,33,15,34,7,26,67,65,82,65,67,84,69,82,0,7,28,15,30,7,26,80,79,83,73,67,73,79,78};
    for(i=0; i<29;i++)
		_gt_mapbaseinfo[193+i]= str2[i];
	/*              '  S  E  L  E  C  T  '  :  b  o  r  r  a    '  S  T  A  R  T  '  :  r  e  t  u  r  n */
	int str3[29] = {7,51,37,44,37,35,52,7,26,66,79,82,82,65,0,7,51,52,33,50,52,7,26,82,69,84,85,82,78};
  for(i=0; i<29;i++)
		_gt_mapbaseinfo[257+i]= str3[i];
		
	/* Inicialitzem input */
	for (i = 0; i < 28; i++) _gt_input[i] = -1;
	/* inicialitzem el cursor*/
	_gt_cursorini();
	/* Amaguem el teclat */
	//_gt_hideKB();
	_gt_hideKB();
}

void _gt_showKB(char zoc)
{
	
	irqEnable(IRQ_KEYS);	// activem interrupcions per teclat
	
	_gt_kbvisible = true;	// indiquem que teclat mostrat

	bgShow(_gt_bginfo);		// activem els fons del teclat
	bgShow(_gt_bgbox);
	bgShow(_gt_bgcursor);
	
	_gt_writePIDZ(zoc);	// escribim el pidz del procés rebut per parametre en la finestreta
}

void _gt_hideKB(){
	irqDisable(IRQ_KEYS);	// desactivem interrupcions per teclat
	
	
	bgHide(_gt_bginfo);		// amaguem tots els background
	bgHide(_gt_bgbox);
	bgHide(_gt_bgcursor);
	
	_gt_kbvisible = false;	// indiquem que teclat amagat

	//_gt_resetKB();
	
}