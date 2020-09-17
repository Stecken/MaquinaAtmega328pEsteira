/*
 * IF.asm
 *
 *  Created: 11/09/2020 20:36:13
 *   Author: Stecken
*/

 .equ LCDisplay = PORTD

	rjmp inicio
.include "lib328Pv02.inc"

//.db "TESTE", 0

inicio:
	ldi r26, 255
	out ddrd, r26
	rcall lcd_init
	rcall lcd_clear

separador:
	ldi YL,low(foda<<1)
	mov r13, r28
	mov lcd_caracter, r13
	cpi lcd_caracter, 10
	brlo loop
	rcall lcd_write_caracter
	rjmp separador


loop:
	rjmp loop

.exit