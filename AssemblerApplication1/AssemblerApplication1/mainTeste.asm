/*
 * mainTeste.asm
 *
 *  Created: 11/09/2020 13:24:13
 *   Author: T-Gamer
 */ 

 .equ LCDisplay = PORTD

 rjmp inicio

 .include "lib328Pv02.inc"
 
 inicio:
	ldi r16, 255
	out ddrd, r16
	rcall lcd_init
	rcall lcd_clear
	ldi r26, 0

loop:
	ldi lcd_caracter, 'a'
	rcall lcd_write_caracter
	mov lcd_number, r26
	rcall lcd_write_number
	rcall darDelay
	inc r26
	rjmp loop

darDelay:
	ldi delay_time, 1
	rcall delay_seconds
	rcall lcd_clear
	ret


