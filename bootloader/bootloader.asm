 [BITS 16]
 [ORG 0X7C00]
 
 xor ax, ax  ;make it zero
 mov ds, ax
 cld ;clear direction
 mov ss,ax
 mov sp, 0x7C00
 sti

 mov si, msg
 push si
 call print_hex_word
 pop si
 push ds
 call print_hex_word
 pop ds

 call print

 call reset_disk

 call ReadFloppy

 ;push DX
 ;call print_hex_word
 ;pop DX
 ;push BX
 ;call print_hex_word
 ;pop BX
 ;pushf
 ;call print_hex_word
 ;popf
 
 ;call disk_read_error
 
 hang:
    ;cli
    ;call load_sector
    ;jmp hang
     
 .data:
     msg db 'Hello world !!!!',13,10,0
     msg2 db "ERROR IN DISK READING",13,10,0
     ;startaddr   EQU  0x7E00
     ;endaddr EQU 0x7E00
 print:
    lodsb
    or al, al  ;zero=end of str
    jz done    ;get out
    mov ah, 0x0E
    mov bh, 0
    int 0x10
    jmp print
 
 done:
    ret
  
;dd if=boot.bin of=floopy.img seek=0 count=1 conv=notrunc

 print_hex_word:
    pusha           ; Save all registers, 16 bytes total
    mov bp, sp      ; BP=SP, on 8086 can't use sp in memory operand
    mov cx, 0x0404  ; CH = number of nibbles to process = 4 (4*4=16 bits)
                    ; CL = Number of bits to rotate each iteration = 4 (a nibble)
    mov dx, [bp+18] ; DX = word parameter on stack at [bp+18] to print
    mov bx, [bp+20] ; BX = page / foreground attr is at [bp+20]

.loop:
    rol dx, cl      ; Roll 4 bits left. Lower nibble is value to print
    mov ax, 0x0e0f  ; AH=0E (BIOS tty print),AL=mask to get lower nibble
    and al, dl      ; AL=copy of lower nibble
    add al, 0x90    ; Work as if we are packed BCD
    daa             ; Decimal adjust after add.
                    ;    If nibble in AL was between 0 and 9, then CF=0 and
                    ;    AL=0x90 to 0x99
                    ;    If nibble in AL was between A and F, then CF=1 and
                    ;    AL=0x00 to 0x05
    adc al, 0x40    ; AL=0xD0 to 0xD9
                    ; or AL=0x41 to 0x46
    daa             ; AL=0x30 to 0x39 (ASCII '0' to '9')
                    ; or AL=0x41 to 0x46 (ASCII 'A' to 'F')
    int 0x10        ; Print ASCII character in AL
    dec ch
    jnz .loop       ; Go back if more nibbles to process
    popa            ; Restore all the registers
    ret

 reset_disk:
    MOV AH, 00h
    MOV DL, 00h
    RET

 ReadFloppy:
	
    ;MOV AX, 0X007E
	MOV BX, 0X7E0
    MOV ES, BX
    MOV BX, 0X00 
    MOV AH, 02h
	MOV AL, 01h
	
	MOV CX, 0x0002
	MOV DH, 00h
	MOV DL, 00h
    
	
	;MOV SI,DiskAddressPacket
	INT 0x13
    push es
    push bx
    retf
	;JC ReadFloppy ;if it went wrong, try again
	;call print
	;pointers to RAM position (0x1000)
	;MOV AX, 0x1000
	;MOV DS, AX
	;MOV ES, AX
	;MOV FS, AX
	;MOV GS, AX
	;MOV SS, AX

	;JMP 0x1000:0x0
	;call print
    	;jnc disk_read_error
    	;call 0x00200
    	;hlt
	;ret
; DiskAddressPacket:          db 16,0 
;.SectorsToRead:             dw 1                              ; Number of sectors to read (read size of OS) 
;.Offset:                    dw 0                              ; Offset :0000 
;.Segment:                   dw 0200h                          ; Segment 0200
;.End:                       dq 16                             ; Sector 16 or 10h on CD-ROM 



 
 times 510-($-$$) db 0
 db 0x55
 db 0xAA
