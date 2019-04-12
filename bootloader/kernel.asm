;set print-registers
MOV AH, 0x0E ;function nr
MOV BH, 0x00 ;page
MOV BL, 0x07 ;color

MOV SI, msg ;move msg to SI-pointer
CALL PrintString ;call function to print SI (msg)

;JMP $ ;hang

PrintString:
next_char:
MOV AL, [SI] ;current character
OR AL, AL
JZ print_done ;if current char is zero, go to end
INT 0x10 ;print character
INC SI ;increase pointer to msg (next character)
JMP next_char
exit_char:
  RET

print_done:
  RET
msg db 'Hello world from the kernel!', 13, 10, 0

TIMES 512 - ($ - $$) db 0 ;fill the rest
