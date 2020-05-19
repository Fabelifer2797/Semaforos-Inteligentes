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
;La memoria RAM comienza en la dirección 0x20000000
;Notaciones: S = Semaforo, P = Peatonal, H = Horizontal, V (al inicio) = Vertical, A = Amarillo, R = Rojo, V (al final) = Verde
;Cada dirección de memoria apunta a un bloque de 4 bytes de tamaño

SHV			EQU		0x20000000	;se asigna la etiqueta semaforo horizontal verde al espacio de memoria
SHA			EQU		0x20000004	;se asigna la etiqueta semaforo horizontal amarillo al espacio de memoria
SHR			EQU		0x20000008	;se asigna la etiqueta semaforo horizontal al espacio de memoria
SPHV		EQU		0x2000000C	;se asigna la etiqueta semaforo peatonal horizontal verde al espacio de memoria
SPHR		EQU		0x20000010	;se asigna la etiqueta semaforo peatonal horizontal rojo al espacio de memoria
SVV			EQU		0x20000014	;se asigna la etiqueta semaforo vertical verde al espacio de memoria
SVA			EQU		0x20000018	;se asigna la etiqueta semaforo vertical amarillo al espacio de memoria
SVR			EQU		0x2000001C	;se asigna la etiqueta semaforo vertical rojo al espacio de memoria
SPVV		EQU		0x20000020	;se asigna la etiqueta semaforo peatonal vertical verde al espacio de memoria
SPVR		EQU		0x20000024	;se asigna la etiqueta semaforo peatonal vertical rojo al espacio de memoria
	
	
	
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

CI		MOV 	H,#FALSE				;Se le asigna el valor de 0 a la variable H
		MOV 	V,#FALSE				;Se le asigna el valor de 0 a la variable V
		MOV 	CONT1,#FALSE			;Se le asigna el valor de 0 a la variable CONT1
		MOV 	RELOJOUT,#FALSE			;Se le asigna el valor de 0 a la variable RELOJOUT
		MOV 	AMARILLO,#FALSE			;Se le asigna el valor de 0 a la variable AMARILLO
		MOV 	FLUJOHORIZONTAL,#FALSE	;Se le asigna el valor de 0 a la variable FLUJOHORIZONTAL
		
;Se establecen los valores iniciales de los outputs en memoria		
		MOV 	R6,#TRUE		;Se le asigna el valor de 1 al registro 6
		MOV		R7,#FALSE		;Se le asigna el valor de 0 al registro 7
		LDR 	R8,=SHV			;Carga la dirección de memoria de la variable SHV en el registro 8
		STR		R7,[R8]			;Asigna el valor del registro 7 a la variable asignada a la dirección del registro 8
		LDR		R8,=SHA			;Carga la dirección de memoria de la variable SHA en el registro 8
		STR		R7,[R8]
		LDR		R8,=SHR			;Carga la dirección de memoria de la variable SHR en el registro 8
		STR		R6,[R8]			;Asigna el valor del registro 6 a la variable asignada a la dirección del registro 8
		LDR		R8,=SPHV		;Carga la dirección de memoria de la variable SPHV en el registro 8
		STR		R6,[R8]
		LDR		R8,=SPHR		;Carga la dirección de memoria de la variable SPHR en el registro 8	
		STR		R7,[R8]
		LDR		R8,=SVV			;Carga la dirección de memoria de la variable SVV en el registro 8
		STR		R6,[R8]
		LDR		R8,=SVA			;Carga la dirección de memoria de la variable SVA en el registro 8
		STR		R7,[R8]
		LDR		R8,=SVR			;Carga la dirección de memoria de la variable SVR en el registro 8
		STR		R7,[R8]
		LDR		R8,=SPVV		;Carga la dirección de memoria de la variable SPVV en el registro 8
		STR		R7,[R8]
		LDR		R8,=SPVR		;Carga la dirección de memoria de la variable SPVR en el registro 8
		STR		R6,[R8]
		BX 		LR				;Se sale de la subrutina y regresa al flujo principal
		
;Subrutina que se encarga de cambiar el valor de la variable reloj out de acuerdo a la ecuación diseñada

CRO		ADD		CONT1,CONT1,#1 ;aumenta en 1 el valor de CONT1
		CMP     CONT1,#3 ; Debería compararse con 64000 de acuerdo al pseudo código, pero de momento dejarlo en 3 por las pruebas
		ITE    	EQ		; Se verifica la condición del IF
		MOVEQ   RELOJOUT,#1 ; Se ejecuta el THEN (Es decir cuando se cumple la condición del IF)
		;Comienzo del ELSE
		EORNE	R6,V,#1 ; NOT del LSB de V mediante un XOR
		ANDNE	R7,R6,FLUJOHORIZONTAL	;Se guarda en el registro 7 el resultado del AND entre el registro 6 y el FLUJOHORIZONTAL
		ANDNE	R8,H,R6					;Se guarda en el registro 8 el resultado del AND entre H y el registro 6
		ANDNE	R9,H,FLUJOHORIZONTAL	;Se guarda en el registro 9 el resultado del AND entre H y el FLUJOHORIZONTAL
		ORRNE	R10,R7,R8				;Se guarda en el registro 10 el resultado del OR entre el registro 7 y el registro 8
		ORRNE	R11,R10,R9 ;En R11 se almacena el resultado de la ecuación
		EORNE	RELOJOUT,FLUJOHORIZONTAL,R11  ; Se aplica un XOR entre FLUJOHORIZONTAL Y R11, y se almacena en RELOJOUT
		;Fin del ELSE
		BX		LR 	;Se sale de la subrutina y regresa al flujo principal
		
;Subrutina que se encarga de verificar la condición de reloj out

IRO		CMP		RELOJOUT,#1
		IT		EQ   ; Se verifica el IF Reloj out == 1
		BEQ		CDO	 ; Se hace un Salto en caso de que la condición se cumpla al branch CDO = Cambio De Outputs
		BX		LR   ; Si la condición no se cumple se regresa al ciclo infinito
		
;Subrutina que se encarga de cambiar los valores de algunos outputs dependiendo del valor de Flujo Horizontal
;Para esta subrutina R6 representa a la variable interna cont2

CDO     MOV		R6,#5 ; Aquí se debería almacenar 12000 pero dejarlo así de momento para las pruebas
		MOV		AMARILLO,#1	;Se le asigna el valor de 1 a la variable AMARILLO
		MOV		RELOJOUT,#0	;Se le asigna el valor de 0 a la variable RELOJOUT
		MOV 	H,#0
		MOV		V,#0
		MOV		R7,#TRUE	;Se le asigna el valor de 1 al registro 7
		MOV		R8,#FALSE	;Se le asigna el valor de 0 al registro 8
		LDR		R9,=SHV		;Carga la dirección de memoria de la variable SHV en el registro 9
		LDR		R10,=SHA	;Carga la dirección de memoria de la variable SHA en el registro 10
		LDR		R11,=SVV	;Carga la dirección de memoria de la variable SVV en el registro 11
		LDR		R12,=SVA	;Carga la dirección de memoria de la variable SVA en el registro 12
		CMP		FLUJOHORIZONTAL,#1 ;Compara si el FLUJOHORIZONTAL es igual a 1
		ITTE	EQ
		STREQ	R8,[R9]
		STREQ	R7,[R10]
		STRNE	R8,[R11]
		STRNE	R7,[R12]
		BL		L2      ;Branch L2 = Loop 2
		
;Subrutina que ejecuta el segundo ciclo
 
L2		CBZ		R6,L20 ; Branch L20 = Loop 2 Out, básicamente lo saca del loop cuando cont2 sea cero
		SUB     R6,R6,#1
		B		L2
		
		
;Subrutina después del segundo ciclo, que verifica el nuevo valor de Flujo Horizontal

L20		MOV		CONT1,#0	;Se le asigna el valor de 0 a la variable CONT1
		MOV		AMARILLO,#0	;Se le asigna el valor de 0 a la variable AMARILLO
		EOR		FLUJOHORIZONTAL,FLUJOHORIZONTAL,#1 ;Se hace el NOT mediante un XOR entre 1 y el LSB de FLUJOHORIZONTAL
		CBZ		FLUJOHORIZONTAL,CFO ;Branch CFO = Cambio final de Outputs
		;Comienzo del IF
		LDR		R9,=SHV		;Carga la dirección de memoria de la variable SHV en el registro 9
		STR		R7,[R9]		;Asigna el valor del registro 7 a la variable asignada a la dirección del registro 9
		LDR		R9,=SHA		;Carga la dirección de memoria de la variable SHA en el registro 9
		STR		R8,[R9]
		LDR		R9,=SHR		;Carga la dirección de memoria de la variable SHR en el registro 9
		STR		R8,[R9]		;Asigna el valor del registro 8 a la variable asignada a la dirección del registro 9
		LDR		R9,=SPHV	;Carga la dirección de memoria de la variable SPHV en el registro 9
		STR		R8,[R9]
		LDR		R9,=SPHR	;Carga la dirección de memoria de la variable SPHR en el registro 9
		STR		R7,[R9]
		LDR		R9,=SVV		;Carga la dirección de memoria de la variable SVV en el registro 9
		STR		R8,[R9]
		LDR		R9,=SVA		;Carga la dirección de memoria de la variable SVA en el registro 9
		STR		R8,[R9]
		LDR		R9,=SVR		;Carga la dirección de memoria de la variable SVR en el registro 9
		STR		R7,[R9]
		LDR		R9,=SPVV	;Carga la dirección de memoria de la variable SPVV en el registro 9
		STR		R7,[R9]
		LDR		R9,=SPVR	;Carga la dirección de memoria de la variable SPVR en el registro 9
		STR		R8,[R9]
		BL		INF
	
		
;Subrutina que cambia los outputs cuando Flujo Horizontal == 0, Entra al ELSE

		;Comienzo del Else
CFO		LDR		R9,=SHV		;Carga la dirección de memoria de la variable SHV en el registro 9
		STR		R8,[R9]		;Asigna el valor del registro 8 a la variable asignada a la dirección del registro 9
		LDR		R9,=SHA		;Carga la dirección de memoria de la variable SHA en el registro 9
		STR		R8,[R9]
		LDR		R9,=SHR		;Carga la dirección de memoria de la variable SHR en el registro 9
		STR		R7,[R9]		;Asigna el valor del registro 7 a la variable asignada a la dirección del registro 9
		LDR		R9,=SPHV	;Carga la dirección de memoria de la variable SPHV en el registro 9
		STR		R7,[R9]
		LDR		R9,=SPHR	;Carga la dirección de memoria de la variable SPHR en el registro 9
		STR		R8,[R9]
		LDR		R9,=SVV		;Carga la dirección de memoria de la variable SVV en el registro 9
		STR		R7,[R9]
		LDR		R9,=SVA		;Carga la dirección de memoria de la variable SVA en el registro 9
		STR		R8,[R9]
		LDR		R9,=SVR		;Carga la dirección de memoria de la variable SVR en el registro 9
		STR		R8,[R9]
		LDR		R9,=SPVV	;Carga la dirección de memoria de la variable SPVV en el registro 9
		STR		R8,[R9]
		LDR		R9,=SPVR	;Carga la dirección de memoria de la variable SPVR en el registro 9
		STR		R7,[R9]
		BL		INF
		
		END