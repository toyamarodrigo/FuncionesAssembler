;ESTE ES EL INSTLADOR DE LA INTERRUPCION

;-----------------------------------------------------------------------------
;	tasm tsr2.asm
;	tlink /t tsr2.obj  generar un archivo.com
;-----------------------------------------------------------------------
.8086
.model tiny	                        ; Definicion para generar un archivo .COM
.code
   org 100h	                        ; Definicion para generar un archivo .COM

start:
   jmp main	                        ; Comienza con un salto para dejar la parte residente primero

Funcion PROC FAR
    cmp dl,0
	je shifty
	cmp dl,1
	je andy
	
	shifty:
		push cx
		mov cx,bx
		call shiftleft
		pop cx
		jmp fin
		
	andy:
		push ax
		push bx
		call andear
		add sp,4
		;pop bx
		;pop ax

	fin:
		iret
endp
;---------------------------------------------------------------------
;AX es el nro a shiftear
;CX es el nro de veces
shiftleft proc
	push cx
	
	ciclo: 
		shl ax,1
		loop ciclo
	
	pop cx
	ret
endp
;---------------------------------------------------------------------
andear proc
	push bp
	
	mov bp,sp
	mov ax,[bp+4]
	and ax,[bp+6]
	
	pop bp
	ret
endp
;---------------------------------------------------------------------

; Datos usados dentro de la ISR ya que no hay DS dentro de una ISR
ViejaInt80      LABEL   DWORD
DespIntXX    dw   0
SegIntXX     dw   0

FinResidente LABEL BYTE		; Marca el fin de la porción a dejar residente


Cartel    DB "Programa Instalado exitosamente!!!",0dh, 0ah, '$'
main:
    mov ax,CS
    mov DS,ax
    mov ES,ax

Recupero:
    mov AX,3580h        ; Obtiene la ISR que esta instalada en la interrupcion
    int 21h    
         
    mov DespIntXX,BX    
    mov SegIntXX,ES	
	
InstalarInt:
    mov AX,2580h	; Coloca la nueva ISR en el vector de interrupciones
    mov DX,Offset Funcion 
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
