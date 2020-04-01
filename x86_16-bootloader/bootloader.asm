	bits 16
start:	jmp init_stack

init_stack:
    mov ax, 0x07C0
    mov ds, ax
    mov ax, 0x07E0
    mov ss, ax
    mov sp, 0x2000
    jmp boot

boot:
	cli
	cld

	mov dx, 0x202
	call MovCursor

	mov cx, 5
	mov al, 0x41
	call PutChar
	hlt

MovCursor:
	push bp
	mov bp, sp
	pusha

    ; dh -> row / dl -> col
    mov ah, 0x2
    mov bh, 0x00
    int 0x10

	popa
	mov sp, bp
	pop bp
	ret


PutChar:
    push bp
    mov bp, sp
    pusha

    .loop:
        cmp cx, 0
        je .end
        sub cx, 1
	    mov bh, 0x00
	    mov ah, 0x0E
        int 0x10
        jmp .loop

    .end:
	    popa
	    mov sp, bp
	    pop bp
	    ret



times 510 - ($-$$) db 0
dw 0xAA55
