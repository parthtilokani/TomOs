[org 0x7E000]
;data: 
 ;msg db 'Hello world from kernel!!!!',13,10,0

print:
    ;lodsb
    ;or al, al  ;zero=end of str
    
    ;jz done    ;get out
    mov al, 'd'
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    ;jmp print
 
 done:
    jmp $

