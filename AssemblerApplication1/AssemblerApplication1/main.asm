;====================================================================
; Created:   20 de agosto de 2020
; Processor: ATmega328P
; Compiler:  AVRASM (Proteus)
; Autor: Yuri Martins
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================
.equ LedStart = pb0	; Saída  (LED)
.equ Motor = pb1	; Saída (Atuador)	
.equ Cilindro = pb2	; Saída (Atuador)			
.equ Resfriar = pb3	; Saída (Atuador)
.equ StartBu = pc0 ; Entrada (Botão Start)	
.equ S1 = pc1	; Entrada  (Botão)	
.equ S2 = pc2	; Entrada  (Botão)	
.equ S3 = pc3	; Entrada  (Botão)	
.equ LCDisplay = PORTD
;====================================================================
; VARIABLES
;====================================================================

;====================================================================
; RESET and INTERRUPT VECTORS
;====================================================================

      ; Reset Vector
      rjmp  Start ; Pula direto o Label Start, impedimento o carregamento completo da biblioteca.

;====================================================================
; CODE SEGMENT
;====================================================================
.include "lib328Pv02.inc" ; ínclui o header(biblioteca) para facilitar no manejo de atraso.

Start:
	  ldi r16, 0b00001111
	  out ddrb, r16
;------------------------Entradas - pull-up--------------------------;
      ldi r16, 0b11110000
	  out ddrc, r16
	  ldi r16, 0b11111111
	  out portc, r16
;------------------------display - portd--------------------------;
	  out DDRD, r16
	  rcall lcd_init
	  rcall lcd_clear
	  rcall piscaInic
	  rcall CaixaContText
	  
ButtonStart:
	  sbic pinc, StartBu ; Testa se PC0 está sendo apertado(0 no Portc), caso esteja, pula de linha e executa a linha 59, caso faz um loop infinito, até que ocorra o contrário
	  rjmp ButtonStart ;  Pula ao lable ButtonStart
	  rjmp Loop ; Pula ao lable Loop

Loop: ; Lable principal do programa
	  call ligarSistema ; Faz uma chamada(pula) relativa ao ligarSistema
	  call fase1
	  cbi portb, Cilindro
	  call fase2
	  sbi portb, Motor	
	  call fase3
	  rjmp ButtonStart

ligarSistema:
	  ldi r16, 0b00000111
	  out portb, r16
	  call mostra
	  ret
;====================================================================; 
fase1:	  
	  sbic pinc, S1
	  rjmp fase1
      ret

fase2:
	  sbic pinc, S2
	  rjmp fase2
	  rcall Resfriador
	  ret

fase3:
	  sbic pinc, S3
	  rjmp fase3
	  rcall contagem	  
;====================================================================;
contagem:
	  inc r13 ; r17 = r17 + 1
	  mov r27, r13
	  rcall mostra
	  cpi r27, 3 ; R17 - R16 = 0 -> Zero Flag(1); 
	  brne loop ; Desvia se diferente, ou seja, se o bit Zero Flag estiver desativado(0)
	  rjmp desliga

desliga:
	  cbi portb, Motor
	  cbi portb, LedStart
	  clr r13
	  rcall mostra
	  rjmp ButtonStart 

mostra:
	  rcall contCaixa
	  ret

;====================================================================;	
Resfriador:
      cbi portb, Motor	
	  sbi portb, Resfriar
	  ldi delay_time, 2 	; Carrega delay_time com 5 (5 segundos)
      rcall delay_seconds	; Chama rotina de atraso
	  cbi portb, Resfriar	
	  ret
;====================================================================;

lcd_inicio:
	ldi lcd_col, 2
    rcall lcd_lin0_col
	ldi lcd_caracter, 'P'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'G'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'R'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter

	ldi lcd_col, 2
    rcall lcd_lin1_col
	ldi lcd_caracter, 'C'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'M'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'E'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'C'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'N'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'D'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'O'
	rcall lcd_write_caracter
	ret

piscaInic:
	rcall lcd_inicio
	ldi delay_time, 1
	rcall delay_seconds
	rcall lcd_clear
	ldi delay_time, 1
	rcall delay_seconds
	rcall lcd_inicio
	ldi delay_time, 1
	rcall delay_seconds
	rcall lcd_clear
	ldi delay_time, 1
	rcall delay_seconds
	ret

CaixaContText:
	ldi lcd_col, 0
    rcall lcd_lin1_col
	ldi lcd_caracter, 'C'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'I'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'X'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'A'
	rcall lcd_write_caracter
	ldi lcd_caracter, 'S'
	rcall lcd_write_caracter
	ldi lcd_caracter, ':'
	rcall lcd_write_caracter
	ldi lcd_caracter, ' '
	rcall lcd_write_caracter
	ret

contCaixa:
	ldi lcd_col, 9
    rcall lcd_lin1_col
	mov lcd_number, r13
	rcall lcd_write_number
	ret