.8086
.model tiny		; Definicion para generar un archivo .COM
.code
   org 100h		; Definicion para generar un archivo .COM
start:
   jmp main		; Comienza con un salto para dejar la parte residente primero
;--------------------------------------------------------------------------------		
rcambio proc far					; en Di el offset a modicar, en ax la letra a buscar, en cx el reemplazo
	push bx
	
	mov bx,0					;indice para recorrer el texto en cero
	
ciclorcambio:
	
	cmp byte ptr[bx+di],'$'					
	je finrcambio
	
	cmp byte ptr[bx+di],al				;comparo el caracter en curso con el que me dieron
	je cambiorcambio
	inc bx						;incremento y evaluo el siguiente
	jmp ciclorcambio
cambiorcambio:
	mov [bx+di],cl				;Reemplazo con el caracter dato que esta en cx, en realidad en cl 
	inc bx						;incremento y evaluo el siguiente
	jmp ciclorcambio
finrcambio:
		
	
		pop bx
		
		iret
        endp
;--------------------------------------------------------------------------------------------
; Datos usados dentro de la ISR ya que no hay DS dentro de una ISR
ViejaInt66      LABEL   DWORD	;label va a estar compuesto por los dos de abajo Offset y Segmento de codigo
DespInt66    dw   0
SegInt66     dw   0

FinResidente LABEL BYTE		; Marca el fin de la porción a dejar residente
;------------------------------------------------------------------------
; Datos a ser usados por el Instalador
;------------------------------------------------------------------------
Cartel    DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$'

main:
; Se apunta todos los registros de segmentos al mismo lugar CS.
    mov ax,CS
    mov DS,ax
    mov ES,ax

InstalarInt:
;----------------------------------------------------------------------------------
	mov AX,3566h        ; Obtiene la ISR que esta instalada en la interrupcion 66h
    int 21h    
         
    mov DespInt66,BX    
    mov SegInt66,ES

    mov AX,2566h	; Coloca la nueva ISR en el vector de interrupciones 66h
    mov DX,Offset rcambio	;nombre de mi funcion
    int 21h

MostrarCartel:
    mov dx, offset Cartel
    mov ah,9
    int 21h

DejarResidente:		
    Mov     AX,(15+offset FinResidente) 
    Shr     AX,1            
    Shr     AX,1        ;Se obtiene la cantidad de paragraphs
    Shr     AX,1
    Shr     AX,1	;ocupado por el codigo
    Mov     DX,AX           
    Mov     AX,3100h    ;y termina sin error 0, dejando el
    Int     21h         ;programa residente
end start
