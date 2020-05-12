;Se renombran los registros que se  van a utilizar para los inputs

H		RN		R0
V		RN		R1

;Se renombran los registros que se van a utilizar como variables

CONT1				RN		R2
RELOJOUT			RN		R3
AMARILLO			RN		R4
FLUJOHORIZONTAL		RN		R5

;Se asignan etiquetas para las constantes de 0 y 1 que se usaran para mostrar el valor de los outputs

TRUE		EQU		1
FALSE		EQU		0
	
;Se asignan etiquetas para los espacios de memoria RAM donde se almacenaran los ouputs
;Notaciones: S = Semaforo, P = Peatonal, H = Horizontal, V (al inicio) = Vertical, A = Amarillo, R = Rojo, V (al final) = Verde
;Cada dirección de memoria apunta a un bloque de 4 bytes de tamaño

SHV			EQU		0x20000000
SHA			EQU		0x20000004
SHR			EQU		0x20000008
SPHV		EQU		0x2000000C
SPHR		EQU		0x20000010
SVV			EQU		0x20000014
SVA			EQU		0x20000018
SVR			EQU		0x2000001C
SPVV		EQU		0x20000020
SPVR		EQU		0x20000024
	
	
;Código del programa principal


		AREA Main, CODE, READONLY
		ENTRY
		EXPORT	__main
		
__main

		BL		CI    ; Branch de la subrutina CI = Condiciones iniciales
INF		BL		CRO   ; Branch de la subrutina CRO = Cambio del Reloj Out
		BL		IRO   ; Branch de la subrutina IRO = IF Reloj Out
		B 		INF   ; Branch que genera un loop infinito

;Subrutina que se encarga de establecer los valores iniciales antes del ciclo principal

CI		MOV 	H,#FALSE
		MOV 	V,#FALSE
		MOV 	CONT1,#FALSE
		MOV 	RELOJOUT,#FALSE
		MOV 	AMARILLO,#FALSE
		MOV 	FLUJOHORIZONTAL,#FALSE
		
;Se establecen los valores iniciales de los outputs en memoria		
		MOV 	R6,#TRUE
		MOV		R7,#FALSE
		LDR 	R8,=SHV
		STR		R7,[R8]
		LDR		R8,=SHA
		STR		R7,[R8]
		LDR		R8,=SHR
		STR		R6,[R8]
		LDR		R8,=SPHV
		STR		R6,[R8]
		LDR		R8,=SPHR
		STR		R7,[R8]
		LDR		R8,=SVV
		STR		R6,[R8]
		LDR		R8,=SVA
		STR		R7,[R8]
		LDR		R8,=SVR
		STR		R7,[R8]
		LDR		R8,=SPVV
		STR		R7,[R8]
		LDR		R8,=SPVR
		STR		R6,[R8]
		BX 		LR	    ;Se sale de la subrutina y regresa al flujo principal
		
;Subrutina que se encarga de cambiar el valor de la variable reloj out de acuerdo a la ecuación diseñada

CRO		ADD		CONT1,CONT1,#1
		CMP     CONT1,#3 ; Debería compararse con 64000 de acuerdo al pseudo código, pero de momento dejarlo en 3 por las pruebas
		ITE    	EQ		; Se verifica la condición del IF
		MOVEQ   RELOJOUT,#1 ; Se ejecuta el THEN
		;Comienzo del ELSE
		EORNE	R6,V,#1 ; NOT del LSB de V mediante un XOR
		ANDNE	R7,R6,FLUJOHORIZONTAL
		ANDNE	R8,H,R6
		ANDNE	R9,H,FLUJOHORIZONTAL
		ORRNE	R10,R7,R8
		ORRNE	R11,R10,R9
		EORNE	RELOJOUT,FLUJOHORIZONTAL,R11
		;Fin del ELSE
		BX		LR
		
;Subrutina que se encarga de verificar la condición de reloj out

IRO		CMP		RELOJOUT,#1
		IT		EQ   ; Se verifica el IF Reloj out == 1
		BEQ		CDO	 ; Se hace un Salto en caso de que la condición se cumpla al branch CDO = Cambio De Outputs
		BX		LR   ; Si la condición no se cumple se regresa al ciclo infinito
		
;Subrutina que se encarga de cambiar los valores de algunos outputs dependiendo del valor de Flujo Horizontal

CDO     MOV		R6,#0 ; Para esta subrutina R6 representa a la variable interna cont2
		MOV		AMARILLO,#1
		MOV		RELOJOUT,#0
		MOV		R7,#TRUE
		MOV		R8,#FALSE
		LDR		R9,=SHV
		LDR		R10,=SHA
		LDR		R11,=SVV
		LDR		R12,=SVA
		CMP		FLUJOHORIZONTAL,#1
		ITTE	EQ
		STREQ	R8,[R9]
		STREQ	R7,[R10]
		STRNE	R8,[R11]
		STRNE	R7,[R12]
		BL		L2      ;Branch L2 = Loop 2
		
;Subrutina que ejecuta el segundo ciclo

L2		BL		INF


		
		END