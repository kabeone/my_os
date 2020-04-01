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
	mov si, msg
	call print
	hlt


end:	
        popa
        mov sp, bp
        pop bp
        ret

	
MovCursor:
		;dh -> row / dl -> col
	push bp
	mov bp, sp
	pusha

	mov ah, 0x2
	mov bh, 0x00
    	int 0x10
	jmp end
	

PutChar:
		;al -> char to print / bh -> color (only in graphic mode) / cx -> number of times the char will be printed
        push bp
    	mov bp, sp
    	pusha

    .loop:
        cmp cx, 0
        je end
        sub cx, 1
	mov bh, 0x00
	mov ah, 0x0E
        int 0x10
        jmp .loop

	
print:
		;si -> string ptr
	push bp
	mov bp, sp
	pusha

	mov ah, 0x0E

    .loop:
	cmp BYTE [si], 0
	je end
	mov al, [si]
	add si, 1
	int 0x10
	jmp .loop
	
	
msg:    db "My_string!!", 0

times 510 - ($-$$) db 0
dw 0xAA55
