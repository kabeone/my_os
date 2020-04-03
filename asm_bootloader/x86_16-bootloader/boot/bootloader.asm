	bits 16

start:	jmp init_stack

init_stack:
	mov ax, 0x07C0
	mov ds, ax
	mov es, ax
	mov ax, 0x8000
	mov ss, ax
	mov sp, 0xf000

	
boot:
	cli
	cld
	;; mov si, msg
	;; call print

		
	mov ax, 0x50
		;instructions address 
	mov es, ax
	xor bx, bx
		;read from floppy disk
	mov al, 2
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0
	mov ah, 0x02
	int 0x13

	jmp 0x60:0x0
	
hlt:	
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
	

msg:    db "Welcome in my bootloader!", 0
	
times 510 - ($-$$) db 0
dw 0xAA55
