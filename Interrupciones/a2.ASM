.8086
.model small
.stack 100h
.data
        cartel1 db 'Ingrese el texto:$',0dh,0ah,'$'
		texto db 250 dup ('$'),'$'
        salto1 db 0dh,0ah,'$'
.code

main proc
        mov ax,@data
        mov ds,ax     

		mov ax, offset cartel1		;paso el parametro para imprimir en ax
		call rimpret				;imprime el cartel
		
		mov di,offset texto
		mov cx,250					;paso los paramtros para ingresar texto
		call rtxtin					;ingresa texto almacenado en texto
		
		mov ax, offset salto1
		call rimpret
		
		mov di, offset texto		;parametros para cambiar un caracter
		
		mov ax,'a'
		mov cx,'@'
		int 66h
		
		mov ax,'e'
		int 66h
		
		mov ax,'i'
		int 66h
		
		mov ax,'o'
		int 66h
		
		mov ax,'u'
		int 66h
									;tengo el texto cambiado
		mov ax, offset texto
		call rimpret
		
		mov ax,4c00h
		int 21h
		
		endp
;--------------------------------------------------------------------------------		
rcambio proc					; en Di el offset a modicar, en ax la letra a buscar, en cx el reemplazo
	push bx
	

	mov bx,0					;indice para recorrer el texto en cero
	
ciclorcambio:
	
	cmp byte ptr[bx+di],'$'					
	je finrcambio
	
	cmp [bx+di],al					;comparo el caracter en curso con el que me dieron
	je cambiorcambio
	inc bx						;incremento y evaluo el siguiente
	jmp ciclorcambio
cambiorcambio:
	mov [bx+di],cl				;Reemplazo con el caracter dato que esta en cx, en realidad en cl 
	inc bx						;incremento y evaluo el siguiente
	jmp ciclorcambio
finrcambio:
		
	
		pop bx
		
		ret
        endp
;--------------------------------------------------------------------------------------------
rtxtin proc						;ingreso de un texto de [cx] caracteres almacenado en [di]
								;Parametros [cx/di]
		push ax
		push bx
		
		xor bx,bx
ciclortxtin:
		mov ah,1
		int 21h
		cmp al,'$'
		je otrortxtin
		
		
		mov [bx+di],al
		inc bx
		cmp bx,cx
		je otrortxtin
		jmp ciclortxtin
otrortxtin:
		pop bx
		pop ax

		ret
		endp					;termina funcion de ingreso de texto

;---------------------------------------------------------------------------------------------------
rimpret proc		;imprime una cadena de caracter Parametros [AX]
		push ax		
		push dx
		
		mov dx,ax	;en AX tiene que estar el offset
		mov ah,9
		int 21h
			
		pop dx		;los recupero en orden inverso
		pop ax
		
		ret			;termina la funcion imprimir texto
		endp

;--------------------------------------------------------------------------------------------
        end main
                 
