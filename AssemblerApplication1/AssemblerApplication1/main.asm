;====================================================================
; Created:   20 de agosto de 2020
; Processor: ATmega328P
; Compiler:  AVRASM (Proteus)
; Autor: Yuri Martins
;====================================================================

;====================================================================
; DEFINITIONS
;====================================================================
.equ LedStart = pb0	; Sa�da  (LED)
.equ Motor = pb1	; Sa�da (Atuador)	
.equ Cilindro = pb2	; Sa�da (Atuador)			
.equ Resfriar = pb3	; Sa�da (Atuador)
.equ StartBu = pc0 ; Entrada (Bot�o Start)	
.equ S1 = pc1	; Entrada  (Bot�o)	
.equ S2 = pc2	; Entrada  (Bot�o)	
.equ S3 = pc3	; Entrada  (Bot�o)	
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
.include "lib328Pv01.inc" ; �nclui o header(biblioteca) para facilitar no manejo de atraso.

Start:
      ; Write your code here
      sbi ddrb, 0	; Configura a porta pb0 como sa�da
      sbi ddrb, 1	; Configura a porta pb1 como sa�da
	  sbi ddrb, 2	; Configura a porta pb2 como sa�da
	  sbi ddrb, 3   ; Configura a porta pb1 como sa�da
;--------------------------------------------------------------------;
;------------------------PC0 ->  habilitado--------------------------;
      cbi ddrc, 0	; Configura a porta pc0 como entrada
      sbi portc, 0	; SET 1Habilita resistor de pull-up na porta pc0
;------------------------PC1 ->  habilitado--------------------------;
	  cbi ddrc, 1	; Configura a porta pc0 como entrada
      sbi portc, 1	; SET 1Habilita resistor de pull-up na porta pc0
;------------------------PC2 ->  habilitado--------------------------;
	  cbi ddrc, 2	; Configura a porta pc0 como entrada
      sbi portc, 2	; SET 1Habilita resistor de pull-up na porta pc0
;------------------------PC3 ->  habilitado--------------------------;
	  cbi ddrc, 3	; Configura a porta pc0 como entrada
      sbi portc, 3	; SET 1Habilita resistor de pull-up na porta pc0

	  
ButtonStart:
	  sbic pinc, StartBu ; Testa se PC0 est� sendo apertado(0 no Portc), caso esteja, pula de linha e executa a linha 59, caso faz um loop infinito, at� que ocorra o contr�rio
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
	  sbi portb, LedStart
	  sbi portb, Motor
	  sbi portb, Cilindro
	  ret
  
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
	  cbi portb, Motor
	  cbi portb, LedStart
	  ret

Resfriador:
      cbi portb, Motor	
	  sbi portb, Resfriar
	  ldi delay_time, 5  	; Carrega delay_time com 5 (5 segundos)
      rcall delay_seconds	; Chama rotina de atraso
	  cbi portb, Resfriar	
	  ret

;====================================================================;
