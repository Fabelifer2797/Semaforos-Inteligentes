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
;Cada dirección de memoria apunta a un bloque de un byte de tamaño

SHV			EQU		0x20000000
SHA			EQU		0x20000001
SHR			EQU		0x20000002
SPHV		EQU		0x20000003
SPHR		EQU		0x20000004
SVV			EQU		0x20000005
SVA			EQU		0x20000006
SVR			EQU		0x20000007
SPVV		EQU		0x20000008
SPVR		EQU		0x20000009
	
	
;Código del programa principal


		AREA Main, CODE, READONLY
		ENTRY
		EXPORT	__main
		
__main

INF		BL		CI    ; Branch de la subrutina CI = Condiciones iniciales
		B 		INF  ; Branch que genera un loop infinito

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
		
		
		END
			