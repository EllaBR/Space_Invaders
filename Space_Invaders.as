;------------------------------------------------------------------------------
; ZONA I: Definicao de constantes
;         Pseudo-instrucao : EQU
;------------------------------------------------------------------------------
CR              EQU     0Ah
FIM_TEXTO       EQU     '@'
IO_READ         EQU     FFFFh
IO_WRITE        EQU     FFFEh
IO_STATUS       EQU     FFFDh
INITIAL_SP      EQU     FDFFh
CURSOR		    EQU     FFFCh
CURSOR_INIT		EQU		FFFFh
ROW_POSITION	EQU		0d
COL_POSITION	EQU		0d
ROW_SHIFT		EQU		8d
COLUMN_SHIFT	EQU		8d
LINE_LENGTH     EQU     81d
SPACESHIP_ROW   EQU     22d
CARACTER_ESPACO EQU     ' '
CARACTER_NAVE   EQU     'n'
BORDA_ESQ       EQU     1d
BORDA_DIR      EQU     78d
TIMER_UNITS    EQU     FFF6h
ACTIVATE_TIMER EQU     FFF7h
ON             EQU     1d
TIRO           EQU     'o'
BORDA_TIRO     EQU     4d
LINHA_INICIAL_BALA EQU 21d
LINHA_FINAL_BALA EQU 4d
ZERO_ASCII EQU 48d
COLUNA_PONTUACAO EQU 75d
LINHA_PONTUACAO EQU 2d
INIMIGO_1 EQU '&'
COLUNA_DIREITA EQU 79d
PAREDE EQU '|'
POS_VIDA_1 EQU 9d
POS_VIDA_2 EQU 12d
POS_VIDA_3 EQU 15d


SIM EQU 1
NAO EQU 0


;------------------------------------------------------------------------------
; ZONA II: definicao de variaveis
;          Pseudo-instrucoes : WORD - palavra (16 bits)
;                              STR  - sequencia de caracteres (cada ocupa 1 palavra: 16 bits).
;          Cada caracter ocupa 1 palavra
;------------------------------------------------------------------------------

                ORIG    8000h
Row0			STR     '********************************************************************************', FIM_TEXTO
Row1			STR     '|                                                                              |', FIM_TEXTO
Row2			STR     '| LIFES:<3 <3 <3        | ~ S P A C E    I N V A D E R S ~ |        SCORE:000  |', FIM_TEXTO
Row3            STR     '|------------------------------------------------------------------------------|', FIM_TEXTO
Row4            STR     '|                                                                              |', FIM_TEXTO
Row5            STR     '|                                                                              |', FIM_TEXTO
Row6            STR     '|                                                                              |', FIM_TEXTO
Row7            STR     '|          & & & & & & & & & & & & & & & & & & & & & & & & & & & & & &         |', FIM_TEXTO
Row8            STR     '|          & & & & & & & & & & & & & & & & & & & & & & & & & & & & & &         |', FIM_TEXTO
Row9            STR     '|                                                                              |', FIM_TEXTO
Row10           STR     '|                                                                              |', FIM_TEXTO
Row11           STR     '|                                                                              |', FIM_TEXTO
Row12           STR     '|                                                                              |', FIM_TEXTO
Row13           STR     '|                                                                              |', FIM_TEXTO
Row14           STR     '|                                                                              |', FIM_TEXTO
Row15           STR     '|                                                                              |', FIM_TEXTO
Row16           STR     '|                                                                              |', FIM_TEXTO
Row17           STR     '|                                                                              |', FIM_TEXTO
Row18           STR     '|                                                                              |', FIM_TEXTO
Row19           STR     '|                                                                              |', FIM_TEXTO
Row20           STR     '|                                                                              |', FIM_TEXTO
Row21           STR     '|                                                                              |', FIM_TEXTO
Row22			STR     '|                                     nnnnnnn                                  |', FIM_TEXTO
Row23           STR     '********************************************************************************', FIM_TEXTO
Perdeu          STR     'VOCE PERDEU', FIM_TEXTO
Ganhou          STR     'VOCE GANHOU', FIM_TEXTO

RowIndex		WORD	0d
ColumnIndex		WORD	0d
TextIndex		WORD	0d
Coluna_mais_direita WORD 44d
Coluna_mais_esquerda WORD 38d
Meio_da_nave WORD 41d
Coluna_tiro  WORD 0d 
Linha_Tiro  WORD 21d
Contador WORD 0d
BalaAtiva WORD 0d
Colisao WORD NAO
Dezena WORD 0d
Centena WORD 0d

Coluna_esquerda_inimigos WORD 11d
Coluna_direita_parede WORD 78d

Coluna_esquerda_parede WORD 1d

memoria_inimigos WORD 0d
Contador_tempo WORD 0d
linha_inimigos  WORD 7d

contador_linha_direita WORD 0d
contador_linha_esquerda WORD 0d
contador_linha_baixo WORD 0d
contador_linha_inimigos WORD 7d

Flag_direcao WORD 0d
Contador_vida WORD 3d
Flag_vence WORD 0d




;------------------------------------------------------------------------------
; ZONA II: definicao de tabela de interrupções
;------------------------------------------------------------------------------
                ORIG    FE00h
INT0            WORD    Move_Nave_Esq
INT1            WORD    Move_Nave_Dir
INT2            WORD    Disparo

				
				ORIG    FE0Fh
INT15           WORD    Timer

;------------------------------------------------------------------------------
; ZONA IV: codigo
;        conjunto de instrucoes Assembly, ordenadas de forma a realizar
;        as funcoes pretendidas
;------------------------------------------------------------------------------
                ORIG    0000h
                JMP     Main


;------------------------------------------------------------------------------
; Rotina Esqueleto
;------------------------------------------------------------------------------
Esqueleto: 	PUSH R1
			PUSH R2


			POP R2
			POP R1

			RET

;------------------------------------------------------------------------------
; Rotina Disparo
;------------------------------------------------------------------------------
Disparo: 	PUSH R1
			PUSH R2
			PUSH R3


			MOV R1, M[BalaAtiva]
			MOV R2, SIM
			CMP R1, R2 
			JMP.Z Final_Disparo


			MOV R3, TIRO

			MOV R1, SIM
			MOV M[ BalaAtiva ], R1

			MOV R1, LINHA_INICIAL_BALA
			MOV R2, M[ Meio_da_nave ]

			MOV M[ Linha_Tiro ], R1 
			MOV M[ Coluna_tiro ], R2


			SHL R1, 8d 
			OR R1, R2 
			MOV M[CURSOR], R1 
			MOV M[IO_WRITE], R3





Final_Disparo:POP R3
			POP R2
			POP R1

			RTI


;------------------------------------------------------------------------------
; Rotina PrintString
;------------------------------------------------------------------------------
PrintString:PUSH R1
			PUSH R2
			PUSH R3
			PUSH R4
			PUSH R5
			
			MOV R5, R3

CyclePrintString:MOV R2, M[ R1 ]
			CMP R2, FIM_TEXTO
			JMP.Z EndPrintString
			;CALL Printa_memoria
			MOV R3, R5
			SHL R3, 8d
			OR R3, R4
			MOV M[ CURSOR ], R3
			INC R4
			MOV M[ IO_WRITE ], R2

			INC R1
			JMP CyclePrintString
;linha r3 coluna r4 string r1

EndPrintString:POP R5 
			POP R4
			POP R3
			POP R2
			POP R1

			RET

;------------------------------------------------------------------------------
; Rotina PrintMap
;------------------------------------------------------------------------------			
PrintMap:PUSH R1
		 PUSH R2
		 PUSH R3
		 PUSH R4
		 PUSH R5

		 MOV R1, Row0
		 MOV R2, LINE_LENGTH
		
		MOV R3, 0d ; linha
		MOV R5, 24d

CyclePrintMap: MOV R4, 0d
		CMP R3, R5
		JMP.Z EndPrintMap
		CALL PrintString

		INC R3
		ADD R1, R2
		JMP CyclePrintMap


EndPrintMap:POP R5
		 POP R4
		 POP R3 
		 POP R2 
		 POP R1 

		 RET
;------------------------------------------------------------------------------
; Rotina Move_Nave_Esq
;------------------------------------------------------------------------------
Move_Nave_Esq:PUSH R1
    PUSH R2;
    PUSH R3
    PUSH R4

    MOV R1, BORDA_ESQ
    CMP M[Coluna_mais_esquerda], R1
    JMP.Z End_Move_Nave_Esq

    MOV R1, M[Coluna_mais_direita] ; R1 = 45d
    MOV R2, SPACESHIP_ROW ; R2 = 22d
    SHL R2, 8d 
    OR R2, R1 
    MOV M[ CURSOR ], R2 
    MOV R3, CARACTER_ESPACO
    MOV M[ IO_WRITE ], R3
    DEC M[Coluna_mais_direita]

  	DEC M[ Coluna_mais_esquerda ] ; R1 inicial = 38d, R1 depois 37
  	MOV R1, M[ Coluna_mais_esquerda ] ; R1 = 37d
    MOV R2, SPACESHIP_ROW ; R2 = 22d
    SHL R2, 8d 
    OR R2, R1 
    MOV M[ CURSOR ], R2 
    MOV R3, CARACTER_NAVE
    MOV M[ IO_WRITE ], R3

    DEC M[Meio_da_nave]

 End_Move_Nave_Esq:POP R4
    POP R3 
    POP R2
    POP R1
    RTI

 ;------------------------------------------------------------------------------
; Rotina Move_Nave_Dir
;------------------------------------------------------------------------------
Move_Nave_Dir:PUSH R1
    PUSH R2;
    PUSH R3
    PUSH R4

    MOV R1, BORDA_DIR
    CMP M[Coluna_mais_direita], R1
    JMP.Z End_Move_Nave_DIR


    MOV R1, M[Coluna_mais_esquerda] 
    MOV R2, SPACESHIP_ROW 
    SHL R2, 8d 
    OR R2, R1 
    MOV M[ CURSOR ], R2 
    MOV R3, CARACTER_ESPACO
    MOV M[ IO_WRITE ], R3
    INC M[Coluna_mais_esquerda]

  	INC M[ Coluna_mais_direita ] 
  	MOV R1, M[ Coluna_mais_direita ] 
    MOV R2, SPACESHIP_ROW 
    SHL R2, 8d 
    OR R2, R1 
    MOV M[ CURSOR ], R2 
    MOV R3, CARACTER_NAVE
    MOV M[ IO_WRITE ], R3

    INC M[Meio_da_nave]

End_Move_Nave_DIR:POP R4
    POP R3 
    POP R2
    POP R1
    RTI
;------------------------------------------------------------------------------
; Rotina de Interrupção Timer
;------------------------------------------------------------------------------
Timer: PUSH R1
	   PUSH R2
	   PUSH R3



	   INC M[Contador_tempo]
	   MOV R1, M[Contador_tempo]
	   MOV R2, 1d 
	   CMP R1, R2 
	   CALL.Z Movimenta_inimigos
	


	   MOV R1, M[ BalaAtiva ]
	   MOV R2, SIM

	   CMP R1, R2 
	   JMP.NZ TerminaTimer


	   CALL MovimentaBala


	      


TerminaTimer:CMP M[Flag_vence], R0
		JMP.NZ Para_timer  

		CALL Config_Timer

Para_timer:POP R3
	      POP R2 
	      POP R1 

	      RTI


	  

;------------------------------------------------------------------------------
; Rotina de Interrupção MovimentaBala
;------------------------------------------------------------------------------
MovimentaBala: PUSH R1
	   PUSH R2
	   PUSH R3

	   CALL Colisao_inimigo

	   MOV R1, SIM
	   MOV R2, M[Colisao]
	   CMP R1, R2 
	   JMP.Z Para_bala


	   MOV R1, CARACTER_ESPACO
	   MOV R2, M[Linha_Tiro]
	   MOV R3, M[Coluna_tiro]
	   SHL R2, 8d 
	   OR R2, R3 
	   MOV M[CURSOR], R2 
	   MOV M[IO_WRITE], R1

	   MOV R1, TIRO

	   DEC M[ Linha_Tiro ]
	   MOV R2, M[Linha_Tiro]
	   MOV R3, M[Coluna_tiro]

	   SHL R2, 8d 
	   OR R2, R3 


	   MOV M[CURSOR], R2 
	   MOV M[IO_WRITE], R1 

	   MOV R1, LINHA_FINAL_BALA
       MOV R2, M[Linha_Tiro]
       CMP R2, R1
       JMP.NZ Continua_bala



	   
Para_bala:MOV R1, CARACTER_ESPACO
	  MOV R2, M[Linha_Tiro]
	  MOV R3, M[Coluna_tiro]
	  SHL R2, 8d 
	  OR R2, R3 
	  MOV M[CURSOR], R2 
	  MOV M[IO_WRITE], R1
	  MOV R1, NAO
	  MOV M[BalaAtiva], R1
	  MOV M[Colisao], R1

Continua_bala:POP R3
	  POP R2 
	  POP R1 

	  RET    

;------------------------------------------------------------------------------
; Rotina de Interrupção CONFIG_TIMER
;------------------------------------------------------------------------------
Config_Timer: PUSH R1
	   PUSH R2
	   PUSH R3

	MOV R1, 1d
	MOV M[TIMER_UNITS], R1
	MOV R1, ON
	MOV M[ACTIVATE_TIMER], R1

			


     POP R3
	 POP R2 
	 POP R1 

	 RET
;------------------------------------------------------------------------------
; Rotina COLISÃO_INIMIGO
;------------------------------------------------------------------------------
Colisao_inimigo: PUSH R1
	   PUSH R2
	   PUSH R3
	   PUSH R4
	   PUSH R5

	MOV R1, M[Linha_Tiro]
	MOV R2, M[Coluna_tiro]
	MOV R3, Row0
	MOV R4, 81d
	ADD R3, R2 
	DEC R1
	MUL R1, R4
	ADD R3, R4
	MOV R5, M[R3]
	CMP R5, CARACTER_ESPACO
	JMP.Z Nao_Colide 
	MOV R1, SIM
	MOV M[Colisao], R1 
	MOV R2, CARACTER_ESPACO
	MOV M[R3], R2
	MOV R1, M[Linha_Tiro]
	MOV R2, M[Coluna_tiro]
	DEC R1 
	SHL R1, 8d 
	OR R1, R2 
	MOV M[CURSOR], R1
	MOV R3, CARACTER_ESPACO 
	MOV M[IO_WRITE], R3
	CALL Pontuacao




Nao_Colide:POP R5
	 POP R4
     POP R3
	 POP R2 
	 POP R1 

	 RET

;------------------------------------------------------------------------------
; Rotina PONTUACAO
;------------------------------------------------------------------------------
Pontuacao:PUSH R1
	   PUSH R2
	   PUSH R3


	INC M[Dezena]
	MOV R1, 10d
	MOV R2, M[Dezena]
	CMP R1, R2 
	JMP.NZ Continua_Pontuacao
	MOV R3, 0d
	MOV M[Dezena], R3
	INC M[Centena]
	MOV R1, LINHA_PONTUACAO
	MOV R2, COLUNA_PONTUACAO
	DEC R2
	SHL R1, 8d 
	OR R1, R2 
	MOV M[CURSOR], R1
	MOV R1, M[Centena]
	ADD R1, ZERO_ASCII
	MOV M[IO_WRITE], R1






Continua_Pontuacao:MOV R1, LINHA_PONTUACAO
	MOV R2, COLUNA_PONTUACAO
	SHL R1, 8d 
	OR R1, R2 
	MOV M[CURSOR], R1
	MOV R1, M[Dezena]
	ADD R1, ZERO_ASCII



	MOV M[IO_WRITE], R1
	MOV R1, 6d
	CMP M[Centena], R1
	CALL.Z Ganha_jogo

 	 POP R3
	 POP R2 
	 POP R1 

	 RET

;------------------------------------------------------------------------------
; Rotina MOVIMENTA_INIMIGOS_DIREITA
;------------------------------------------------------------------------------
Movimenta_inimigo_dir:PUSH R1 
					  PUSH R2 
					  PUSH R3


MOV R1, M[contador_linha_inimigos]
MOV M[linha_inimigos], R1
MOV M[contador_linha_direita], R0

MOV R1, 0d
MOV M[Contador_tempo], R1

MOV R1, LINE_LENGTH
MOV R2, M[linha_inimigos]
MOV R3, M[Coluna_direita_parede]

MUL R1, R2
ADD R2, R3 
MOV R1, Row0
ADD R1, R2 ; poição antes da parede
MOV R3, INIMIGO_1
CMP M[R1], R3 
JMP.Z Move_para_baixo

MOV R1, 1d
MOV M[Coluna_esquerda_inimigos], R1



Continua_movimento_dir:MOV R1, LINE_LENGTH
		MOV R2, M[linha_inimigos]
		MOV R3, M[Coluna_esquerda_inimigos]

		MUL R1, R2
		ADD R2, R3 

		MOV R1, Row0
		ADD R1, R2 ;posição memoria que começa inimigos
		

		MOV R2, INIMIGO_1
		CMP M[R1], R2 
		JMP.Z Escreve_espaco
		
		MOV R2, PAREDE
		CMP M[R1], R2
		JMP.Z Checa_linhas


		INC M[Coluna_esquerda_inimigos]

		JMP Continua_movimento_dir

Escreve_espaco:MOV R2, CARACTER_ESPACO
		MOV M[ R1 ], R2

		MOV R2, M[linha_inimigos] 
		MOV R3, M[Coluna_esquerda_inimigos]
		SHL R2, 8d 
		OR R2, R3
		MOV M[CURSOR], R2  
		MOV R2, CARACTER_ESPACO  
		MOV M[IO_WRITE], R2
		INC M[Coluna_esquerda_inimigos]

		MOV R2, M[linha_inimigos] 
		MOV R3, M[Coluna_esquerda_inimigos]
		SHL R2, 8d 
		OR R2, R3
		MOV M[CURSOR], R2
		MOV R2, INIMIGO_1 
		MOV M[IO_WRITE], R2


		INC R1
		MOV R2, INIMIGO_1
		MOV M[R1], R2 


		INC M[Coluna_esquerda_inimigos]
		

		JMP Continua_movimento_dir


Checa_linhas:MOV R1, 2d
INC M[contador_linha_direita]
CMP M[contador_linha_direita], R1
JMP.Z End_movimenta_dir
INC M[linha_inimigos]
MOV R1, 1d
MOV M[Coluna_esquerda_inimigos], R1

JMP Continua_movimento_dir

 Move_para_baixo:CALL Movimenta_inimigo_baixo
 End_movimenta_dir:MOV M[contador_linha_direita], R0
 		DEC M[linha_inimigos]
 		POP R3 
 		POP R2 
 		POP R1 


 		RET

;------------------------------------------------------------------------------
; Rotina MOVIMENTA_INIMIGOS_BAIXO
;------------------------------------------------------------------------------
Movimenta_inimigo_baixo:PUSH R1 
					  PUSH R2 
					  PUSH R3 

MOV R1, M[contador_linha_inimigos]
MOV M[linha_inimigos], R1
MOV R1, 1d
MOV M[Coluna_esquerda_inimigos], R1
INC M[linha_inimigos]

MOV R3, 21d
CMP M[linha_inimigos], R3
CALL.Z Perde_vida
CMP M[linha_inimigos], R3
JMP.Z End_movimenta_baixo



Continua_movimento_baixo:MOV R1, LINE_LENGTH
		MOV R2, M[linha_inimigos]
		MOV R3, M[Coluna_esquerda_inimigos]
		MUL R1, R2
		ADD R2, R3 
		MOV R1, Row0
		ADD R1, R2 ;posição memoria que começa inimigos
		MOV R2, INIMIGO_1
		CMP M[R1], R2 
		JMP.Z Escreve_espaco_baixo	
		MOV R2, PAREDE
		CMP M[R1], R2
		JMP.Z Checa_linhas_baixo
		INC M[Coluna_esquerda_inimigos]
		JMP Continua_movimento_baixo

Escreve_espaco_baixo:MOV R2, CARACTER_ESPACO


		MOV M[ R1 ], R2

		MOV R2, M[linha_inimigos] 
		MOV R3, M[Coluna_esquerda_inimigos]
		SHL R2, 8d 
		OR R2, R3
		MOV M[CURSOR], R2  
		MOV R2, CARACTER_ESPACO  
		MOV M[IO_WRITE], R2
		
		INC M[linha_inimigos]


		MOV R2, M[linha_inimigos] 
		MOV R3, M[Coluna_esquerda_inimigos]
		SHL R2, 8d 
		OR R2, R3
		MOV M[CURSOR], R2
		MOV R2, INIMIGO_1 
		MOV M[IO_WRITE], R2


		ADD R1, LINE_LENGTH
		MOV R2, INIMIGO_1
		MOV M[R1], R2 

		
		DEC M[linha_inimigos]
		

		INC M[Coluna_esquerda_inimigos]
		

		JMP Continua_movimento_baixo

Checa_linhas_baixo:MOV R1, 2d
INC M[contador_linha_baixo]
CMP M[contador_linha_baixo], R1
JMP.Z End_movimenta_baixo
DEC M[linha_inimigos]
MOV R1, 1d
MOV M[Coluna_esquerda_inimigos], R1

JMP Continua_movimento_baixo		

 End_movimenta_baixo:MOV M[contador_linha_baixo], R0
 		INC M[contador_linha_inimigos]
 		CALL Troca_direcao
 		POP R3 
 		POP R2 
 		POP R1 


 		RET

;------------------------------------------------------------------------------
; Rotina MOVIMENTA_INIMIGOS_ESQUERDA
;------------------------------------------------------------------------------
Movimenta_inimigo_esq:PUSH R1 
					  PUSH R2 
					  PUSH R3 

MOV R1, M[contador_linha_inimigos]
MOV M[linha_inimigos], R1
MOV M[contador_linha_esquerda], R0

MOV R1, 0d
MOV M[Contador_tempo], R1

MOV R1, LINE_LENGTH
MOV R2, M[linha_inimigos]
MOV R3, M[Coluna_esquerda_parede]

MUL R1, R2
ADD R2, R3 
MOV R1, Row0
ADD R1, R2 ; posição antes da parede
MOV R3, INIMIGO_1
CMP M[R1], R3 
JMP.Z Move_para_baixo_esq

MOV R1, 1d
MOV M[Coluna_esquerda_inimigos], R1



Continua_movimento_esq:MOV R1, LINE_LENGTH
		MOV R2, M[linha_inimigos]
		MOV R3, M[Coluna_esquerda_inimigos]

		MUL R1, R2
		ADD R2, R3 

		MOV R1, Row0
		ADD R1, R2 ;posição memoria que começa inimigos
		

		MOV R2, INIMIGO_1
		CMP M[R1], R2 
		JMP.Z Escreve_espaco_esq
		
		MOV R2, PAREDE
		CMP M[R1], R2
		JMP.Z Checa_linhas_esq


		INC M[Coluna_esquerda_inimigos]

		JMP Continua_movimento_esq

Escreve_espaco_esq:MOV R2, CARACTER_ESPACO
		MOV M[ R1 ], R2

		MOV R2, M[linha_inimigos] 
		MOV R3, M[Coluna_esquerda_inimigos]
		SHL R2, 8d 
		OR R2, R3
		MOV M[CURSOR], R2  
		MOV R2, CARACTER_ESPACO  
		MOV M[IO_WRITE], R2
		DEC M[Coluna_esquerda_inimigos]

		MOV R2, M[linha_inimigos] 
		MOV R3, M[Coluna_esquerda_inimigos]
		SHL R2, 8d 
		OR R2, R3
		MOV M[CURSOR], R2
		MOV R2, INIMIGO_1 
		MOV M[IO_WRITE], R2


		DEC R1
		MOV R2, INIMIGO_1
		MOV M[R1], R2 


		INC M[Coluna_esquerda_inimigos]
		INC R1
		

		JMP Continua_movimento_esq


Checa_linhas_esq:MOV R1, 2d
INC M[contador_linha_esquerda]
CMP M[contador_linha_esquerda], R1
JMP.Z End_movimenta_esq
INC M[linha_inimigos]
MOV R1, 1d
MOV M[Coluna_esquerda_inimigos], R1

JMP Continua_movimento_esq

 Move_para_baixo_esq:CALL Movimenta_inimigo_baixo
 End_movimenta_esq:MOV M[contador_linha_esquerda], R0
 		DEC M[linha_inimigos]
 		POP R3 
 		POP R2 
 		POP R1 


 		RET

;------------------------------------------------------------------------------
; Rotina MOVIMENTA_INIMIGOS
;------------------------------------------------------------------------------
Movimenta_inimigos:PUSH R1 
	

		MOV R1, 0d
		CMP M[Flag_direcao], R1
		CALL.Z Movimenta_inimigo_dir
		CMP M[Flag_direcao], R1
		CALL.NZ Movimenta_inimigo_esq 
  
 		POP R1 


 		RET

;------------------------------------------------------------------------------
; Rotina TROCA_DIREÇÃO
;------------------------------------------------------------------------------
Troca_direcao:PUSH R1 
	

		MOV R1, 0d
		CMP M[Flag_direcao], R1
		JMP.Z troca_para_esq
		JMP troca_para_dir

troca_para_esq:MOV R1, 1d
			   MOV M[Flag_direcao], R1
			   JMP End_troca_direcao


troca_para_dir:MOV M[Flag_direcao], R0 
  
End_troca_direcao:POP R1 
 		RET


;------------------------------------------------------------------------------
; Rotina PERDE_VIDA
;------------------------------------------------------------------------------
Perde_vida:PUSH R1 
		   PUSH R2 
		   PUSH R3
	
		MOV R1, 3d
		CMP M[Contador_vida], R1
		JMP.Z Perde_vida_3

		DEC R1
		CMP M[Contador_vida], R1
		JMP.Z Perde_vida_2

		DEC R1
		CMP M[Contador_vida], R1
		JMP.Z Perde_vida_1
		JMP End_perde_vida

Perde_vida_3:DEC M[Contador_vida]
			 MOV R1, LINHA_PONTUACAO
			 MOV R2, POS_VIDA_3
			 SHL R1, 8d 
			 OR R1,R2 
			 MOV M[CURSOR], R1 
			 MOV R3, CARACTER_ESPACO 
			 MOV M[IO_WRITE], R3
			 DEC R2
			 MOV R1, LINHA_PONTUACAO
			 SHL R1, 8d 
			 OR R1,R2
			 MOV M[CURSOR], R1 
			 MOV R3, CARACTER_ESPACO 
			 MOV M[IO_WRITE], R3 
			 JMP End_perde_vida

Perde_vida_2:DEC M[Contador_vida]
			 MOV R1, LINHA_PONTUACAO
			 MOV R2, POS_VIDA_2
			 SHL R1, 8d 
			 OR R1,R2 
			 MOV M[CURSOR], R1
			 MOV R3, CARACTER_ESPACO 
			 MOV M[IO_WRITE], R3
			 DEC R2
			 MOV R1, LINHA_PONTUACAO
			 SHL R1, 8d 
			 OR R1,R2
			 MOV M[CURSOR], R1 
			 MOV R3, CARACTER_ESPACO 
			 MOV M[IO_WRITE], R3 
			 JMP End_perde_vida

Perde_vida_1:DEC M[Contador_vida]
			 MOV R1, LINHA_PONTUACAO
			 MOV R2, POS_VIDA_1
			 SHL R1, 8d 
			 OR R1,R2 
			 MOV M[CURSOR], R1 
			 MOV R3, CARACTER_ESPACO 
			 MOV M[IO_WRITE], R3
			 DEC R2
			 MOV R1, LINHA_PONTUACAO
			 SHL R1, 8d 
			 OR R1,R2
			 MOV M[CURSOR], R1 
			 MOV R3, CARACTER_ESPACO 
			 MOV M[IO_WRITE], R3
			 CALL Perde_Jogo
			 JMP Termina_vida
		

End_perde_vida:CALL Reseta_tela
Termina_vida:POP R3 
		POP R2
		POP R1 
 		RET

;------------------------------------------------------------------------------
; Rotina RESETA_TELA
;------------------------------------------------------------------------------
Reseta_tela:PUSH R1 
			PUSH R2
			PUSH R3
			PUSH R4 

			MOV R4, 0d
			MOV R3, 7d
			MOV R1, Row20
			CALL PrintString
			INC R3
			MOV R1, Row21
			CALL PrintString
			MOV R1, Row4
			MOV R3, 20d
			CALL PrintString
			INC R3 
			CALL PrintString
			MOV R1, Row20
			MOV R2, Row7
			


Cycle_reseta_tela:CMP R4, 162d 
				  JMP.Z Continua_ciclo
				  MOV R3, M[R1]
				  MOV M[R2], R3 
				  INC R4 
				  INC R1 
				  INC R2
				  JMP Cycle_reseta_tela

Continua_ciclo:MOV R4, R0
			   MOV R1, Row4
			   MOV R2, Row20
				   

Cycle_reseta_tela2:CMP R4, 162d
				  JMP.Z End_Reseta_tela
				  MOV R3, M[R1]
				  MOV M[R2], R3 
				  INC R4
				  INC R1  
				  INC R2 
				  JMP Cycle_reseta_tela2

	

		
  
End_Reseta_tela:MOV R3, 6d
		MOV M[contador_linha_inimigos], R3
		POP R4
		POP R3 
		POP R2
		POP R1 
 		RET

;------------------------------------------------------------------------------
; Rotina PERDE_JOGO
;------------------------------------------------------------------------------
Perde_Jogo:PUSH R1 
			PUSH R2
			PUSH R3
			PUSH R4 

			MOV R1, 1d
			MOV M[Flag_vence], R1
			MOV R3, 5d  
			MOV R4, 35d
			MOV R1, Perdeu
			CALL PrintString


  
End_Perde_Jogo:POP R4
		POP R3 
		POP R2
		POP R1 
 		RET

;------------------------------------------------------------------------------
; Rotina GANHA_JOGO
;------------------------------------------------------------------------------
Ganha_jogo:PUSH R1 
			PUSH R2
			PUSH R3
			PUSH R4 

			MOV R1, 1d
			MOV M[Flag_vence], R1
			MOV R3, 5d  
			MOV R4, 35d
			MOV R1, Ganhou
			CALL PrintString


  
End_Ganha_Jogo:POP R4
		POP R3 
		POP R2
		POP R1 
 		RET




;------------------------------------------------------------------------------
; Função Main
;------------------------------------------------------------------------------
Main:			ENI

				MOV		R1, INITIAL_SP
				MOV		SP, R1		 		; We need to initialize the stack
				MOV		R1, CURSOR_INIT		; We need to initialize the cursor 
				MOV		M[ CURSOR ], R1		; with value CURSOR_INIT
			    MOV		M[TextIndex], R1

			    CALL Config_Timer
				CALL PrintMap



			



			




    			



Cycle: 			BR		Cycle	
Halt:           BR		Halt