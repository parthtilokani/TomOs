[bits 16]
[org 0x7E00]

start:
 xor ax, ax  ;make it zero
 mov ds, ax
 mov cx, ax
 cld ;clear direction
 mov ss,ax
 mov si, ax
 mov sp, 0x7E00
 sti


mov si, kernel_msg
;call print_hex_word
call print

.data:
	kernel_msg db 'from kernel',13,10,0

hang:
	jmp hang


print:
    lodsb
    or al, al  ;zero=end of str
    jz done    ;get out
    ;mov al, 'h'
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp print
 
done:
    ret




