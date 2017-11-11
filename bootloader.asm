[BITS 32]
[ORG 0x7c00]

MOV SI, BOOTLOADERSTR
CALL PrintString
JMP $

PrintCharacter:
MOV AH, 0x0E
MOV BH, 0x00
MOV BL, 0x07

INT 0x10
RET

PrintString:
next_character:
MOV AL, [SI]
INC SI
OR AL, AL
JZ exit_function
CALL PrintCharacter
exit_function:
RET

BOOTLOADERSTR db 'gherkinBoot for gherkinOS', 0

TIMES 510 - ($ - $$) DB 0
DW 0xAA55