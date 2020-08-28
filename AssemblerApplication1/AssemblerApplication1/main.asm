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
.equ DISPLAY = PORTD
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
      ; Write your code here
	  ldi r16, 0b00001111
	  out ddrb, r16
;------------------------Entradas - pull-up--------------------------;
      ldi r16, 0b11110000
	  out ddrc, r16
	  ldi r16, 0b11111111
	  out portc, r16
;------------------------display - portd--------------------------;
	  out ddrd, r16
	  ldi r17, 0
	  
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
	  inc r17
	  rcall mostra
	  ldi r16, 6
	  cp r17, r16
	  brne loop
	  rjmp desliga

desliga:
	  cbi portb, Motor
	  cbi portb, LedStart
	  CLR R17
	  rcall mostra
	  rjmp ButtonStart 

mostra:
	  mov AUX, r17
	  rcall Decodifica
	  ret

;====================================================================;	
Resfriador:
      cbi portb, Motor	
	  sbi portb, Resfriar
	  ldi delay_time, 5  	; Carrega delay_time com 5 (5 segundos)
      rcall delay_seconds	; Chama rotina de atraso
	  cbi portb, Resfriar	
	  ret
;====================================================================;