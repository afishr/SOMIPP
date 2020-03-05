org 0x100

; clearing registers
xor ax, ax
mov es, ax
mov dh, -1 

prompt:
	mov ah, 2
	inc dh
	mov dl, 0
	int 10h
	
	mov ah, 0eh 
	mov al, '$'
	int 10h
	
	mov al, ' '
	int 10h
	
	mov si, 0
	jmp main

main: 
	mov ah, 00h
	int 16h
	 
	cmp ah, 0Eh
	je backspace
	
	cmp ah, 1Ch
	je enter
	
	cmp si, 255 ; limit length of input to 256
	ja main
	
	mov ah, 0eh 
	int 10h
	
	mov msg[si], al
	inc si
	
	jne main

enter:
	cmp si, 0
	je prompt

	mov ah, 03h
	int 10h

	mov al, 1
	inc dh
	mov dl, 0
	mov bl, 0000_0111b
	mov cx, si
	push cs
	pop es
	mov bp, offset msg
	mov ah, 13h
	int 10h
	
	jmp prompt

backspace:
	cmp si, 0
	je main

	mov ah, 03h
	int 10h
	      
	mov ah, 2
	dec dl
	int 10h
  
  mov msg[si], 0x0
  dec si
  
	mov ah, 0ah 
	mov cx, 1
	mov al, ' '
	int 10h
	jmp main

end:
	ret 

msg: dw '', 0x0