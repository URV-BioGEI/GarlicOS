@;==============================================================================
@;
@;	"garlic_itcm_sys.s":	código de las rutinas de soporte al sistema 2.0
@;						(ver "garlic_system.h" para descripción de rutinas)
@;
@;==============================================================================

.section .dtcm,"wa",%progbits

	.align 2

	.global _gs_colZoc		@; colores de las zonas de memoria de cada zócalo
_gs_colZoc: .byte 0, 224, 184, 128, 48, 208, 80, 112, 96, 160, 245, 144, 176, 64, 192, 32

	.global _gs_charTabla	@; códigos de los caracteres para dibujar la tabla de procesos
_gs_charTabla:
		.byte 42,32,83,105,115,116,101,109,97,32,79,112,101,114,97,116,105,118,111,32,71,65,82,76,73,67,32,50,46,48,32,42,0
		.byte 138,137,137,143,137,137,137,137,143,137,137,137,137,143,137,137,137,137,137,137,137,137,143,137,137,143,137,143,137,137,137,141,0
		.byte 136,32,90,136,32,80,73,68,136,80,114,111,103,136,80,67,97,99,116,117,97,108,136,80,105,136,69,136,85,115,111,136,0
		.byte 147,148,148,149,148,148,148,148,149,148,148,148,148,149,148,148,148,148,148,148,148,148,149,148,148,149,148,149,148,148,148,150,0
		.byte 136,32,32,136,32,32,32,32,136,32,32,32,32,136,32,32,32,32,32,32,32,32,136,32,32,136,32,136,32,32,32,136,0
		.byte 139,137,137,145,137,137,137,137,145,137,137,137,137,145,137,137,137,137,137,137,137,137,145,137,137,145,137,145,137,137,137,140,0



.section .itcm,"ax",%progbits

	.arm
	.align 2

	.global _gs_num2str_dec
	@; _gs_num2str_dec: permite convertir un número natural de 32 bits a su
	@;					representación en decimal, dentro de un string acabado
	@;					en cero ('\0');
	@;Parámetros
	@; R0: char * numstr,
	@; R1: unsigned int length,
	@; R2: unsigned int num
	@;Resultado
	@; R0: 0 si no hay problema, !=0 si el número no cabe en el string
_gs_num2str_dec:
	push {r1-r8, lr}
	cmp r1, #1
	bhi .Ln1s_cont1			@; verificar si hay espacio para centinela + 1 dígito
	mov r0, #-1
	b .Ln1s_fin				@; retornar con código de error en R0
.Ln1s_cont1:
	mov r6, r0				@; R6 = puntero a string de resultado
	mov r7, r1				@; R7 = índice carácter (inicialmente es la longitud del string)
	mov r8, r2				@; R8 = número a transcribir
	mov r3, #0
	sub r7, #1
	strb r3, [r6, r7]		@; guardar final de string (0) en última posición
.Ln1s_while:	
	cmp r7, #0				@; repetir mientras quede espacio en el string
	beq .Ln1s_cont2
	sub sp, #8				@; reservar espacio en la pila para resultados
	mov r0, r8				@; pasar numerador por valor
	mov r1, #10				@; pasar denominador por valor
	mov r2, sp				@; pasar dirección para albergar el cociente
	add r3, sp, #4			@; pasar dirección para albergar el resto
	bl _ga_divmod
	pop {r4-r5}				@; R4 = cociente, R5 = resto
	add r5, #48				@; añadir base de códigos ASCII para dígitos numéricos
	sub r7, #1
	strb r5, [r6, r7]		@; almacenar código ASCII en vector
	mov r8, r4				@; actualizar valor del número a convertir
	cmp r8, #0				@; repetir mientras el número sea diferente de 0
	bne .Ln1s_while
.Ln1s_pad:
	cmp r7, #0				@; bucle para llenar de espacios en blanco la
	beq .Ln1s_cont2			@; parte restante del inicio del string
	mov r3, #' '
	sub r7, #1
	strb r3, [r6, r7]		@; almacenar código ASCII ' ' en vector
	b .Ln1s_pad
.Ln1s_cont2:
	mov r0, r8				@; esto indicará si el numero se ha podido codificar
.Ln1s_fin:					@; completamente en el string (si R0 = 0)
	pop {r1-r8, pc}



	.global _gs_num2str_hex
	@; _gs_num2str_hex: permite convertir un número natural de 32 bits a su
	@;					representación en hexadecimal, dentro de un string
	@;					acabado en cero ('\0');
	@;Parámetros
	@; R0: char * numstr,
	@; R1: unsigned int length,
	@; R2: unsigned int num
	@;Resultado
	@; R0: 0 si no hay problema, !=0 si el número no cabe en el string
_gs_num2str_hex:
	push {r1-r4, lr}
	cmp r1, #1
	bhi .Ln2s_cont1			@; verificar si hay espacio para centinela + 1 dígito
	mov r0, #-1
	b .Ln2s_fin				@; retornar con código de error en R0
.Ln2s_cont1:
	mov r3, #0
	sub r1, #1
	strb r3, [r0, r1]		@; guardar final de string (0) en última posición
.Ln2s_while:	
	cmp r1, #0				@; repetir mientras quede espacio en el string
	beq .Ln2s_cont2
	and r4, r2, #0x0F		@; obtener el dígito hexa de menos peso
	cmp r4, #10				@; si dígito hexa menor que 10, saltar a tratamiento
	blo .Ln2s_dec			@; de dígitos decimales
	add r4, #7				@; ajuste para letras 'A'-'F' (65 - 10 - 48)
.Ln2s_dec:
	add r4, #48				@; añadir base de códigos ASCII para números
	sub r1, #1
	strb r4, [r0, r1]		@; almacenar código ASCII en vector
	mov r2, r2, lsr #4		@; actualizar valor del número a convertir
	cmp r2, #0				@; repetir mientras el número sea diferente de 0
	bne .Ln2s_while
.Ln2s_pad:
	cmp r1, #0				@; bucle para llenar de ceros la
	beq .Ln2s_cont2			@; parte restante del inicio del string
	mov r3, #'0'
	sub r1, #1
	strb r3, [r0, r1]		@; almacenar código ASCII '0' en vector
	b .Ln2s_pad
.Ln2s_cont2:
	mov r0, r2				@; esto indicará si el numero se ha podido codificar
.Ln2s_fin:					@; completamente en el string (si R0 = 0)
	pop {r1-r4, pc}



	.global _gs_copiaMem
	@; Rutina para copiar un bloque de memoria desde una dirección fuente a 
	@; otra dirección destino, el número de bytes indicado:
	@;Parámetros:
	@; R0: dirección fuente (debe ser múltiplo de 4)
	@; R1: dirección destino (debe ser múltiplo de 4)
	@; R2: número de bytes a copiar
_gs_copiaMem:
	push {r0-r12, lr}
	and r11, r2, #3				@; R11 = contador de bytes residuales
	mov r2, r2, lsr #2			@; convierte num. bytes en num. words
    and  r12, r2, #7     		@; R12 = contador de words residuales
    movs r2, r2, lsr #3  		@; R2 = contador de bloques de 8 words
    beq  .LcopMem_reswords
.LcopMem_bloques:				@; copiar bloques de 8 words
    ldmia r0!, {r3-r10}   
    stmia r1!, {r3-r10}
    subs  r2, #1
    bne   .LcopMem_bloques
.LcopMem_reswords:				@; copiar los words residuales (entre 0 y 7)
    subs  r12, #1
    ldrcs r3, [r0], #4
    strcs r3, [r1], #4
    bcs   .LcopMem_reswords
.LcopMem_resbytes:				@; copiar los bytes residuales (entre 0 y 3)
    cmp r11, #0
	beq .LcopMem_fin
    ldrb r3, [r0], #1
    strb r3, [r1], #1
	sub  r11, #1
    b .LcopMem_resbytes
.LcopMem_fin:
    pop {r0-r12, pc}



	.global _gs_borrarVentana
	@; Rutina para borrar todo el contenido de una ventana, vaciar el buffer de
	@;	caracteres y poner el puntero de línea actual al principio (fila 0)
	@;Parámetros:
	@;	R0: índice de ventana (0..15)
	@;	R1: número de ventanas (0 -> 4 ventanas, 1 -> 16 ventanas)
	@;¡ATENCIÓN! Para que esta rutina funcione correctamente, es necesario
	@; haber inicializado el procesador gráfico principal correctamente
	@; (baldosas, paleta, mapa de baldosas de fondo 2 con las dimensiones
	@;  adecuadas, etc.).
_gs_borrarVentana:
	push {r0-r5, lr}
								@; (para procesador gráfico principal)
	mov r4, #0x06000000			@; R4 = base 0 del mapa de baldosas (fondo 2)
	and r0, #0x0F
	and r1, #1
	mov r2, #24
	mov r2, r2, lsl #7
	mov r2, r2, lsl r1			@; R2 = 24 * 2 * (64 o 128)
	mov r3, r0, lsr #1
	mov r3, r3, lsr r1			@; R3 = iv / (2 o 4)
	mul r5, r3, r2
	add r4, r5					@; R4 = base primera fila de ventana
								@;		4 ventanas : +(24 * 2 * 64 * iv / 2)
								@;		16 ventanas: +(24 * 2 * 128 * iv / 4)
	mov r2, #1
	mov r2, r2, lsl r1			@; R2 = 1 para 4 ventanas
	add r2, r1					@; R2 = 3 para 16 ventanas
	and r2, r0					@; R2 = (iv % 2) o (iv % 4)
	mov r2, r2, lsl #6
	add r4, r2					@; R4 = base primera casilla de ventana
								@;		4 ventanas : (iv % 2 * 32*2)
								@;		16 ventanas: (iv % 4 * 32*2)
	mov r2, #128
	mov r1, r2, lsl r1			@; R1 = 64 o 128 caracteres por fila
	mov r5, #0
	mov r2, #0
.LborrarV_for1:					@; bucle para borrar filas
	mov r3, #0
.LborrarV_for2:					@; bucle para recorrer las casillas de la fila
	strh r5, [r4, r3]			@; borrar casilla
	add r3, #2					@; pasar a siguiente casilla
	cmp r3, #64					@; 32 columnas
	blo .LborrarV_for2
	add r4, r1					@; pasar a siguiente fila
	add r2, #1
	cmp r2, #24					@; 24 filas
	blo .LborrarV_for1
	
	ldr r4, =_gd_wbfs
	mov r1, #68
	mul r2, r0, r1
	add r4, r2					@; R4 = base _gd_wbfs[ventana]
	str r5, [r4]				@; _gd_wbfs[ventana].pControl = 0
	
	pop {r0-r5, pc}



	.global _gs_iniGrafB
	@; Inicializa el procesador gráfico B (sub) para GARLIC 2.0:
	@; memoria de vídeo en el banco de vídeo-RAM C (0x06200000);
	@; fondo 0 de texto (32x32) caracteres, mapa en la base 0;
	@; 128 baldosas (8 bits por píxel) en la base 1, y dibujos de
	@; baldosas repetidos 3 veces, una por cada color (512 baldosas);
	@; 96 baldosas correspondientes a los gráficos de ocupación de memoria,
	@; copiadas en sus respectivas posiciones de pantalla.	
_gs_iniGrafB:
	push {r0-r9, lr}
 @; videoSetModeSub(MODE_5_2D);
	mov r0, #0x04000000
	orr r0, #0x00001000			@; R0 = dir. DISPCNT_B (0x04001000)
	mov r1, #0x00010000			@; R1 = modo gráfico 0, pantalla activada
	orr r1, #0x00000100			@;		fondo 0 activado (texto)
	str r1, [r0]				@; fijar modo de vídeo procesador gráfico B

 @;	vramSetBankC(VRAM_C_SUB_BG_0x06200000);
	ldr r0, =0x04000242			@; R0 = dir. registro control banco vídeo-RAM C
	mov r1, #0x84				@; R1 = memoria fondo para procesador gráfico B
	strb r1, [r0]				@; fijar modo de banco VRAM_C_SUB_BG_0x06200000

 @; bg0B = bgInitSub(0, BgType_Text8bpp, BgSize_T_256x256, map_base, tile_base);
	ldr r0, =0x04001008			@; R0 = dir. registro control REG_BG0CNT_SUB
	mov r1, #0x84				@; R1 -> priority = 0 (bits 1..0 = 00)
								@; 		 tile_base = 1 (bits 5..2 = 0001)
								@;		 BgType_Text8bpp (bit 7 = 1)
								@;		 map_base = 0 (bits 12..8 = 00000)
								@;		 BgSize_T_256x256 (bits 15..14 = 00)
	strh r1, [r0]				@; fijar modo del fondo 0
	
 @; decompress(garlic_fontTiles, bgGetGfxPtr(bg0B), LZ77Vram);
	ldr r0, =garlic_fontTiles
	mov r1, #0x06200000			@; R1 = base de la memoria de vídeo
	add r1, #0x00004000			@; R1 = GfxPtr (base memoria + 16 KBytes)
	mov r2, #0x1				@; R2 = LZ77Vram
	bl decompress
	
 @; dmaCopy(garlic_fontPal, BG_PALETTE_SUB, sizeof(garlic_fontPal));
	ldr r0, =garlic_fontPal
	mov r1, #0x05000000			@; R1 = base de las paletas
	add r1, #0x00000400			@; R1 = paleta de fondo para procesador graf. B
	mov r2, #0x200				@; R2 = 512 bytes (256 colores * 2 bytes/color)
	bl _gs_copiaMem

 @;	tile119_base = (unsigned int *) (0x06204000 + 119 * 64);
	mov r4, #0x06200000	 		@; R4 = base del mapa de caracteres
	add r3, r4, #0x00004000		@; R3 = base del contenido de baldosas
	add r0, r3, #0x1DC0			@; R0 = base de la baldosa 119 (119 * 64)
 @;	newtile_base = (unsigned int *) (0x06204000 + 512 * 64);
	add r1, r3, #0x8000			@; R1 = base de baldosas para gestión de memoria
 @;	mapMem_base = BG_MAP_RAM_SUB(0) + 32*21;
	add r3, r4, #0x540			@; R3 = posición fila 21 del mapa de caracteres
	mov r2, #64					@; R2 = longitud del contenido de una baldosa
	mov r4, #0					@; R4 es índice i
	mov r5, #512				@; R5 es R4 + 512
 @;	for (i = 0; i < 96; i++)
.LiniGrafB_for1:
 @;	{	dmaCopy(tile119_base, newtile_base, 64);
	bl _gs_copiaMem				@; copiar píxeles de la nueva baldosa
 @;		newtile_base += 16;					// sumar 64 bytes (16 words)
	add r1, #64					@; actualizar puntero a otra nueva baldosa
 @;		mapMem_base[i] = 512+i;
	strh r5, [r3]				@; guardar código baldosa en mapa de caracteres
	add r4, #1					@; i++;
	add r5, #1					@; actualizar (i+512)
	add r3, #2					@; avanzar puntero a siguiente casilla pantalla
 @;	}
	cmp r4, #96
	blo .LiniGrafB_for1

 @; Generar baldosas de colores
	mov r0, #0x06200000
	add r0, #0x00004000			@; R0 = base del contenido de baldosas
	mov r2, #0x2000				@; R2 = 128 * 64 (num. bytes baldosas)
	add r1, r0, r2				@; R1 = destino de las nuevas baldosas
	mov r8, #0xB0
	mov r4, #0					@; R4 es índice i
 @; for (i = 0; i < 3; i++)
.LiniGrafB_for2:
 @;	{
	bl _gs_copiaMem				@; copiar píxeles de todas las baldosas

	add r9, r8, r4, lsl #4		@; R9 = color de paleta
	mov r5, #0					@; R5 es índice j
 @; for (j = 0; j < 128; j++)
.LiniGrafB_for3:
 @; {
	ldr r3, [r1, r5]			@; R3 = *(tile_ptr + j)
	mov r7, #0					@; R7 es newColors
	mov r6, #0					@; R6 es índice k
 @; for (k = 0; k < 4; k++)
.LiniGrafB_for4:
 @; {
	tst r3, #0xFF				@; verificar 8 bits bajos
	beq .LiniGrafB_noColor
	orr r7, r9, lsl #24			@; guardar el nuevo color en los 8 bits altos
.LiniGrafB_noColor:
	add r6, #1
	cmp r6, #4
	beq .LiniGrafB_fifor4
	mov r7, r7, lsr #8			@; desplazar patrón del nuevo color
	mov r3, r3, lsr #8			@; y desplazar el patrón del color actual
	b .LiniGrafB_for4
.LiniGrafB_fifor4:
 @; }
	str r7, [r1, r5]			@; actualizar el nuevo patrón de color
	add r5, #4
	cmp r5, r2
	blo .LiniGrafB_for3
 @; }	
	add r1, r2					@; avanzar puntero siguiente bloque de baldosas	
	add r4, #1					@; i++;
 	cmp r4, #3
	blo .LiniGrafB_for2
 @;	}
	pop {r0-r9, pc}



	.global _gs_escribirStringSub
	@; Rutina para escribir un string (terminado con centinela cero) a partir
	@; de la posición indicada por parámetros (fil, col), con el color especifi-
	@; cado, en la pantalla secundaria;
	@;Parámetros
	@;	R0: dirección inicial del string
	@;	R1: fila inicial
	@;	R2: columna inicial
	@;	R3: color del texto
_gs_escribirStringSub:
	push {r0-r4, lr}
								@; (para procesador gráfico secundario)
	mov r4, #0x06200000			@; R4 = base 0 del mapa de baldosas 
	and r1, #0x1F
	cmp r1, #24					@; R1 = fila inicial (filtrar 5 bits bajos)
	blo .LescStrSub_0
	sub r1, #24					@; evita valores > 24
.LescStrSub_0:
	and r2, #0x1F				@; R2 = columna inicial (evita valores > 31)
	and r3, #0x03				@; R3 = color (sólo admite valores 0..3)
	mov r3, r3, lsl #7			@; R3 = desplazamiento baldosas de color (* 128)
	add r4, r1, lsl #6
	add r4, r2, lsl #1			@; R4 = base mapa + (fila * 32 + columna) * 2 
.LescStrSub_while:
	ldrb r1, [r0]				@; R1 = string[i]
	cmp r1, #32					@; salir de bucle si detecta centinela (R1 = 0),
	blo .LescStrSub_fiwhile	 	@; o código ASCII no imprimible (R1 < 32)
	sub r1, #32					@; restar base códigos ASCII imprimibles
	add r1, r3					@; sumar base de baldosas de color
	strh r1, [r4]				@; fijar baldosa
	add r4, #2					@; R4 apunta a la siguiente posicion del mapa
	add r0, #1					@; avanzar puntero de string
	add r2, #1					@; avanzar índice de columna
	cmp r2, #32
	blo .LescStrSub_while		@; seguir mientras no llegue a última columna
.LescStrSub_fiwhile:
	pop {r0-r4, pc}



	.global _gs_dibujarTabla
	@; Rutina para dibujar la tabla de procesos
_gs_dibujarTabla:
	push {r0-r4, lr}

	@; _gs_escribirStringSub((char *) tabla[0], 0, 0, 1);	// escribir mensaje
	ldr r0, =_gs_charTabla
	mov r1, #0
	mov r2, #0
	mov r3, #1
	bl _gs_escribirStringSub
	mov r3, #0
	mov r4, #0					@; R4 es índice del bucle
.LdibTab_for1:
	@; for (i = 0; i < 3; i++)				// escribir cabecera de la tabla
	@; { _gs_escribirStringSub((char *) tabla[i+1], 1+i, 0, 0);
	add r0, #33
	add r1, r4, #1
	bl _gs_escribirStringSub
	add r4, #1
	cmp r4, #3
	blo .LdibTab_for1			@; repetir para toda la cabecera
	@; }

	mov r3, #3
	mov r4, #0					@; R4 es índice del bucle
	add r0, #33
.LdibTab_for2:
	@; for (i = 0; i < 16; i++)				// escribir filas de la tabla
	@; { _gs_escribirStringSub((char *) tabla[4], 4+i, 0, 3);	// (en rojo)
	add r1, r4, #4
	bl _gs_escribirStringSub
	push {r0-r2}
	sub sp, #4					@; crea espacio en la pila para el string
	mov r0, sp					@; a generar con _ga_num2str()
	mov r1, #3
	mov r2, r4
	bl _gs_num2str_dec			@; _gs_num2str_dec(_gs_numZoc, 3, i);
	@;ldr r0, =_gs_numZoc
	mov r0, sp
	add r1, r4, #4
	mov r2, #1
	bl _gs_escribirStringSub	@; _gs_escribirStringSub(_gs_numZoc, i, 1, 3);
	add sp, #4
	pop {r0-r2}
	add r4, #1
	cmp r4, #16
	blo .LdibTab_for2			@; repetir para todas las filas de procesos
	@;}
	
	@;_gg_escribirStringSub((char *) tabla[5], 20, 0, 0);	// última linea
	add r0, #33
	mov r1, #20
	mov r3, #0
	bl _gs_escribirStringSub

	pop {r0-r4, pc}


.end

