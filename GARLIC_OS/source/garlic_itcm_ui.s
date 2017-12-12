@;==============================================================================
@;
@;	"garlic_itcm_ui.s":	código de variables y rutinas de soporte a la interficie
@;						de usuario para GARLIC 2.0
@;						(ver "garlic_system.h" para descripción)
@;
@;==============================================================================


.section .dtcm,"wa",%progbits

	.align 2

	.global _gi_za				@; zócalo seleccionado actualmente
_gi_za:			.word 0

_gi_nFrames:	.word 0			@; número de frames de la animación
_gi_orgX:		.word 0			@; origen X de los fondos de las ventanas
_gi_orgY:		.word 0			@; origen Y de los fondos de las ventanas
_gi_orgX_ant:	.word 0			@; origen X anterior de las ventanas
_gi_orgY_ant:	.word 0			@; origen Y anterior de las ventanas
_gi_zoom:		.word 0x200		@; zoom de los fondos de las ventanas
_gi_zoom_ant:	.word 0x200		@; zoom anterior de las ventanas



.section .itcm,"ax",%progbits

	.arm
	.align 2

	.global _gi_movimientoVentanas
_gi_movimientoVentanas:
	push {r0-r3,r8-r9, lr}
	
	ldr r0, =_gi_nFrames;
	ldr r1, [r0]				@; R1 = numero actual de frames
	cmp r1, #0
	beq .Lmv_fin				@; si nFrames = 0, final RSI
	sub r1, #1
	str r1, [r0]				@; _gi_nFrames--;
	
	@; actualizar posición X de las ventanas
	ldr r0, =_gi_orgX
	ldr r2, [r0]				@; R2 = origen X de fondos de ventanas
	ldr r3, =_gi_orgX_ant
	ldr r8, [r3]				@; R8 = _gi_orgX_ant
	cmp r8, r2
	beq .Lmv_fin_orgX			@; si orgX = orgX_ant, final ajuste orgX
	sub r9, r2, r8
	mul r0, r9, r1 
	sub r2, r0, asr #5			@; R2 = ((orgX - orgX_ant) * numFrames) >> 5;
	mov r9, r2, lsl #8			@; convertir a coma fija 24.8
	mov r0, #0x04000000
	add r0, #0x28				@; R0 es dirección de BG2X
	str r9, [r0]
	str r9, [r0, #0x10]			@; actualizar fondos 2 y 3
	cmp r1, #0
	bne .Lmv_fin_orgX			@; si nFrames != 0, final ajuste orgX
	str r2, [r3]				@; sino, _gi_orgX_ant = _gi_orgX;
.Lmv_fin_orgX:

	@; actualizar posición Y de las ventanas
	ldr r0, =_gi_orgY
	ldr r2, [r0]				@; R2 = origen Y de fondos de ventanas
	ldr r3, =_gi_orgY_ant
	ldr r8, [r3]				@; R8 = _gi_orgY_ant
	cmp r8, r2
	beq .Lmv_fin_orgY			@; si orgY = orgY_ant, final ajuste orgY
	sub r9, r2, r8
	mul r0, r9, r1 
	sub r2, r0, asr #5			@; R2 = ((orgY - orgY_ant) * numFrames) >> 5;
	mov r9, r2, lsl #8			@; convertir a coma fija 24.8
	mov r0, #0x04000000
	add r0, #0x2C				@; R0 es dirección de BG2Y
	str r9, [r0]
	str r9, [r0, #0x10]			@; actualizar fondos 2 y 3
	cmp r1, #0
	bne .Lmv_fin_orgY			@; si nFrames != 0, final ajuste orgY
	str r2, [r3]				@; sino, _gi_orgY_ant = _gi_orgY;
.Lmv_fin_orgY:

	@; actualizar zoom de las ventanas
	ldr r0, =_gi_zoom
	ldr r2, [r0]				@; R2 = zoom actual de ventanas
	ldr r3, =_gi_zoom_ant
	ldr r8, [r3]				@; R8 = _gi_zoom_ant
	cmp r8, r2
	beq .Lmv_fin				@; si zoom = zoom_ant, final RSI
	sub r9, r2, r8
	mul r0, r9, r1
	sub r2, r0, lsr #5			@; R2 = ((zoom - zoom_ant) * numFrames) >> 5;
	mov r0, #0x04000000
	add r0, #0x20				@; R0 es dirección de BG2PA
	strh r2, [r0]				@; actualizar PA y PD del fondo 2
	strh r2, [r0, #0x06]
	add r0, #0x10				@; R0 es dirección de BG3PA
	strh r2, [r0]				@; actualizar PA y PD del fondo 3
	strh r2, [r0, #0x06]
	cmp r1, #0
	bne .Lmv_fin				@; si nFrames != 0, final RSI
	str r2, [r3]				@; sino, _gi_zoom_ant = _gi_zoom;

.Lmv_fin:
	pop {r0-r3,r8-r9, pc}



	.global _gi_redibujarZocalo
	@; R0 = seleccionar
_gi_redibujarZocalo:
	push {r0-r5, lr}

	ldr r5, =_gi_za
	ldr r1, [r5]				@; R1 = _gi_za
	@;color = (seleccionar == 0 ? ((_gi_za == 0) || (_gd_pcbs[_gi_za].PID != 0) ? 0 : 3) : 2);
	mov r4, #2					@; R4 es variable color (por defecto = 2)
	cmp r0, #0
	bne .LrZ_cont				@; si seleccionar = 1, continuar con color = 2
	mov r4, #3					@; si zócalo vacío, color = 3
	cmp r1, #0
	beq .LrZ_col0				@; si _gi_za = 0, salta a fijar color a 0
	ldr r0, =_gd_pcbs
	mov r2, #24
	mul r3, r2, r1				@; R3 = offset _gd_pcbs[_gi_za]
	ldr r2, [r0, r3]			@; R2 = _gd_pcbs[_gi_za].PID
	cmp r2, #0
	beq .LrZ_cont				@; si PID = 0, continua con color = 3
.LrZ_col0:
	mov r4, #0					@; color = 0 (proceso activo)
.LrZ_cont:
	mov r5, r1
	@;_gg_escribirLineaTabla(_gi_za, color);
	mov r0, r1
	mov r1, r4
	bl _gg_escribirLineaTabla
	@;_gg_generarMarco(_gi_za, color);
	mov r0, r5
	mov r1, r4
	bl _gg_generarMarco
	
	pop {r0-r5, pc}



	@; _gi_ajustarScroll: función auxiliar para ajustar el scroll para la
	@;			ventana del zócalo actual (_gi_za), teniendo en cuenta su
	@;			posición y el zoom actual; también reajusta un posible zoom
	@;			activo
_gi_ajustarScroll:
	push {r0-r11, lr}

	ldr r0, =_gi_za
	ldr r1, [r0]				@; R1 = _gi_za
	and r2, r1, #0x03			@; R2 es zmod4 = _gi_za & 3;
	mov r3, r1, lsr #2			@; R3 es zdiv4 = _gi_za >> 2;
	ldr r0, =_gi_zoom
	ldr r4, [r0]				@; R4 = _gi_zoom
	@;if (_gi_zoom == 1024)
	@;	{ d_orgX = 0; d_orgY = 0; }	// zoom máximo -> no hay scroll
	cmp r4, #1024
	bne .LaS_else1_1
	mov r6, #0					@; R6 es d_orgX (= 0 para scroll máximo)
	mov r7, #0					@; R7 es d_orgY (= 0 para scroll máximo)
	b .LaS_finif1
	@;else if (_gi_zoom == 512)
	@;	{ d_orgX = (zmod4 / 2) * 512;	// zoom intermedio -> scroll en
	@;	  d_orgY = (zdiv4 / 2) * 384;	// 4 quadrantes
	@;	}
.LaS_else1_1:
	cmp r4, #512
	bne .LaS_else1_2
	mov r6, r2, lsr #1			@; elimina bit de menos peso de zmod4
	mov r6, r6, lsl #9			@; multiplicar por 512
	mov r8, r3, lsr #1			@; elimina bit de menos peso de zdiv4
	mov r9, #384
	mul r7, r8, r9
	b .LaS_finif1
	@;else {	d_orgX = zmod4 * 256;		// zoom mínimo -> scroll de centrado
	@;		d_orgY = zdiv4 * 192;	}	// de cada ventana
.LaS_else1_2:
	mov r6, r2, lsl #8
	mov r9, #192
	mul r7, r3, r9
.LaS_finif1:
	ldr r10, =_gi_orgX
	ldr r8, [r10]				@; R8 es _gi_orgX
	ldr r11, =_gi_orgY
	ldr r9, [r11]				@; R9 es _gi_orgY
	@;if ((d_orgX != _gi_orgX) || (d_orgY != _gi_orgY))
	@;{
	cmp r6, r8
	bne .LaS_if2
	cmp r7, r9
	beq .LaS_finif2
.LaS_if2:
	@;		// iniciar un nuevo scroll
	ldr r5, =_gi_orgX_ant
	str r8, [r5]					@;	_gi_orgX_ant = _gi_orgX;
	ldr r5, =_gi_orgY_ant
	str r9, [r5]					@;	_gi_orgY_ant = _gi_orgY;
	str r6, [r10]					@;	_gi_orgX = d_orgX;
	str r7, [r11]					@;	_gi_orgY = d_orgY;
	ldr r5, =_gi_zoom_ant
	ldr r8, [r5]					@; R8 es _gi_zoom_ant
	ldr r0, =_gi_nFrames
	@;	if (_gi_zoom_ant != _gi_zoom)	// ajustar el posible zoom activo
	cmp r8, r4
	beq .LaS_finif2_1
	@;		_gi_zoom_ant = _gi_zoom - (((_gi_zoom - _gi_zoom_ant) * _gi_nFrames) >> 5);
	ldr r9, [r0]					@; R9 es _gi_nFrames
	sub r2, r4, r8
	mul r3, r2, r9
	sub r8, r4, r3, lsr #5
	str r8, [r5]
.LaS_finif2_1:
	mov r9, #32
	str r9, [r0]					@;	_gi_nFrames = 32;
	@;}
.LaS_finif2:
	pop {r0-r11, pc}



	@; _gi_iniciarZoom: función auxiliar para iniciar un zoom, recalculando un
	@;			posible cambio de scroll
_gi_iniciarZoom:
	push {r0-r5, lr}
	
	ldr r4, =_gi_nFrames
	ldr r5, [r4]					@; R5 es _gi_nFrames
	ldr r0, =_gi_orgX
	ldr r1, [r0]					@; R1 es _gi_orgX
	ldr r2, =_gi_orgX_ant
	ldr r3, [r2]					@; R3 es _gi_orgX_ant
	@;if (_gi_orgX_ant != _gi_orgX)
	cmp r1, r3
	beq .LiZ_finif1
	@;	_gi_orgX_ant = _gi_orgX - (((_gi_orgX - _gi_orgX_ant) * _gi_nFrames) >> 5);
	sub r0, r1, r3
	mul r3, r0, r5
	sub r3, r1, r3, lsr #5
	str r3, [r2]
.LiZ_finif1:
	ldr r0, =_gi_orgY
	ldr r1, [r0]					@; R1 es _gi_orgY
	ldr r2, =_gi_orgY_ant
	ldr r3, [r2]					@; R3 es _gi_orgY_ant
	@;if (_gi_orgY_ant != _gi_orgY)
	cmp r1, r3
	beq .LiZ_finif2
	@;	_gi_orgY_ant = _gi_orgY - (((_gi_orgY - _gi_orgY_ant) * _gi_nFrames) >> 5);
	sub r0, r1, r3
	mul r3, r0, r5
	sub r3, r1, r3, lsr #5
	str r3, [r2]
.LiZ_finif2:
	mov r5, #32
	str r5, [r4]					@;_gi_nFrames = 32;
	bl _gi_ajustarScroll

	pop {r0-r5, pc}



	.global _gi_controlInterfaz
	@; R0 = key
_gi_controlInterfaz:
	push {r0-r4, lr}
	
	mov r4, r0						@; R4 guardará el parámetro key
	ldr r1, =_gi_za
	ldr r2, [r1]					@; R2 = _gi_za
	@;switch (key)
	@;{
	@;case KEY_UP:
	tst r4, #0x0040
	beq .LcI_cont1
	@;	if (_gi_za >= 4)
	cmp r2, #4
	blo .LcI_finswitch
	@;	{
	mov r0, #0
	bl _gi_redibujarZocalo
	sub r2, #4						@; subir la selección de zócalo
	str r2, [r1]					@; _gi_za -= 4;
	mov r0, #1
	bl _gi_redibujarZocalo
	bl _gi_ajustarScroll
	@;	}
	@;	break;
	b .LcI_finswitch
.LcI_cont1:
	@;case KEY_DOWN:
	tst r4, #0x0080
	beq .LcI_cont2
	@;	if (_gi_za < 12)
	cmp r2, #12
	bhs .LcI_finswitch
	@;	{
	mov r0, #0
	bl _gi_redibujarZocalo
	add r2, #4						@; bajar la selección de zócalo
	str r2, [r1]					@; _gi_za += 4;
	mov r0, #1
	bl _gi_redibujarZocalo
	bl _gi_ajustarScroll
	@;	}
	@;	break;
	b .LcI_finswitch
.LcI_cont2:
	@;case KEY_LEFT:
	tst r4, #0x0020
	beq .LcI_cont3
	@;	if ((_gi_za % 4) >= 1)
	and r3, r2, #0x03				@; R3 = _gi_za % 4
	cmp r3, #1
	blo .LcI_finswitch
	@;	{
	mov r0, #0
	bl _gi_redibujarZocalo
	sub r2, #1						@; selección de zócalo izquierdo
	str r2, [r1]					@; _gi_za -= 1;
	mov r0, #1
	bl _gi_redibujarZocalo
	bl _gi_ajustarScroll
	@;	}
	@;	break;
	b .LcI_finswitch
.LcI_cont3:
	@;case KEY_RIGHT:
	tst r4, #0x0010
	beq .LcI_cont4
	@;	if ((_gi_za % 4) < 3)
	and r3, r2, #0x03				@; R3 = _gi_za % 4
	cmp r3, #3
	bhs .LcI_finswitch
	@;	{
	mov r0, #0
	bl _gi_redibujarZocalo
	add r2, #1						@; selección de zócalo derecho
	str r2, [r1]					@; _gi_za += 1;
	mov r0, #1
	bl _gi_redibujarZocalo
	bl _gi_ajustarScroll
	@;	}
	@;	break;
	b .LcI_finswitch
.LcI_cont4:
	ldr r1, =_gi_zoom
	ldr r2, [r1]					@; R2 = _gi_zoom
	ldr r0, =_gi_zoom_ant
	@;case KEY_START:
	tst r4, #0x0008
	beq .LcI_cont5
	str r2, [r0]					@; _gi_zoom_ant = _gi_zoom;
	mov r2, #256
	str r2, [r1]					@; _gi_zoom = 1 << 8;
	bl _gi_iniciarZoom
	@;	break;
	b .LcI_finswitch
.LcI_cont5:
	@;case KEY_L:
	tst r4, #0x0200
	beq .LcI_cont6
	@;	if (_gi_zoom > 256)
	cmp r2, #256
	bls .LcI_finswitch
	@;	{
	str r2, [r0]					@; _gi_zoom_ant = _gi_zoom;
	mov r2, r2, lsr #1				@; dividir por 2 el factor de zoom actual
	str r2, [r1]					@; _gi_zoom >>= 1;
	bl _gi_iniciarZoom
	@;	break;
	b .LcI_finswitch
.LcI_cont6:
	@;case KEY_R:
	tst r4, #0x0100
	beq .LcI_finswitch
	@;	if (_gi_zoom < 1024)
	cmp r2, #1024
	bhs .LcI_finswitch
	@;	{
	str r2, [r0]					@; _gi_zoom_ant = _gi_zoom;
	mov r2, r2, lsl #1				@; multiplicar por 2 el factor d zoom actual
	str r2, [r1]					@; _gi_zoom <<= 1;
	bl _gi_iniciarZoom
	@;	break;
	@;}
.LcI_finswitch:

	pop {r0-r4, pc}

.end
