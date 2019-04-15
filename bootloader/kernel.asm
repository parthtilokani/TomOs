[bits 16]
[ORG 0x0000]

start:
 mov ax, cs 
 mov ds, ax
 
 cld ;clear direction
 ;mov ss,ax
 ;mov si, ax
; mov sp, 0x7E00
 ;sti
 ;cli


mov si, kernel_msg
call print
;mov ax, [kernel_msg]
hang:
    cli
    jmp hang

;call print_hex_word
;call print_char

;
.data:
    kernel_msg  db 'from kernel',13,10,0



print_char:
    mov al, 'a'
    mov ah, 0x0E
    mov bh, 0
    int 10h
    ret

print:
    lodsb
    or al, al  ;zero=end of str
    jz done    ;get out
    ;mov al, 'h'
    mov ah, 0x0E
    mov bh, 0
    int 10h
    jmp print
 
done:
    ret




