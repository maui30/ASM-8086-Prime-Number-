.MODEL SMALL
.STACK 100H

.DATA
input_len DW 0
input DB ?,'$' ; array to store input
msg DB "Enter number: $"     
msg1 DB "Prime Numbers: $"
newline DB 0dh,0ah,'$' ; newline character  
termi DW 0
numStr DW 0
disEnd DB "END $"

.CODE
MAIN PROC 
    
MOV BH,0
MOV BL,10D

MOV AX, @DATA
MOV DS, AX

; display prompt message
MOV AH, 09H
MOV DX, OFFSET msg
INT 21H

; read numbers from keyboard and store them in input array
MOV SI, 0

INPUT_LOOP:
    MOV aH, 01H
    INT 21H
    MOV [input+SI], AL
    ; increment si and loop input_loop
    INC SI
    CMP AL, 13
    JNE INPUT_LOOP
    MOV [input_len], SI

; display newline
MOV AH, 09H
MOV DX, OFFSET newline
INT 21H
           
; display newline
MOV AH, 09H
MOV DX, OFFSET newline
INT 21H
        
; display prompt message
MOV AH, 09H 
MOV dx, OFFSET msg1
INT 21H  

; display newline
MOV AH, 09H
MOV DX, OFFSET newline
INT 21H
                   
             
; iterate through the input array
MOV DI, [input_len]
MOV SI, 0

CHECK_LOOP:
    ; check if the current element is equal to ' '
    MOV [numStr], SI
    MOV AL, [input+SI]  
    CMP AL, 30H
    JE ZERO 
    CMP AL, 13D
    JE CHECK
    CMP AL, ' '
    JNE NUMBER
    
    JMP CHECK

    ;clears bh memory, bl=10 
    ;for new number
    MOV BH,0
    MOV BL,10D

    BACK:
        ; increment si and loop check_loop
        INC SI
        DEC DI
        MOV [termi], DI
        JNZ CHECK_LOOP
        
        JMP EXIT


    ;convert to number
    NUMBER:
        SUB AL,30H
        MOV CL,AL
        MOV AL,BH
        MUL BL
        ADD AL,CL
        MOV BH,AL
        
        JMP BACK 

ZERO:
    DEC SI
    MOV AH, [input+SI]  
    CMP AH, ' '
    JE  ZEROF
    
    MOV SI, [numStr]
    JMP NUMBER
    
ZEROF:
    MOV SI, [numStr]   
    INC SI
    MOV AH, [input+SI]
    CMP AH, 13D
    JE NOT_PRIME
    CMP AH, ' '
    JE BACK
    
    MOV SI, [numStr]
    JMP NUMBER


;check if it is prime
CHECK:   
    CMP BH,1
    JE NOT_PRIME

    MOV CX,2
    AND AX,0
    AND DX,0

    MOV AL,BH
    DIV CX

    MOV CX,AX              

ISPRIME:
    CMP CX,2
    JL PRIME
    AND AX,0
    AND DX,0
    MOV AL,BH               
    DIV CX 
    DEC CX
    CMP DX,0

    JE NOT_PRIME

    JMP ISPRIME


;print if number is prime
PRIME:
    AND AX,0
    MOV AL,BH
    MOV CL,10D
    
    MOV BX,0000H    

;stores the result in memory at [0000H + BX]
STORE:
    DIV CL
    MOV [0000H+BX],AH
    ADD BX,2H
    MOV AH,0
    CMP AL,0

    JNE STORE


MOV AH,2
MOV  DL,0DH
INT 21H
MOV DL,0AH
INT 21H

;Prints the digit of the quotient 
PRINT: 
    SUB BX,2H
    MOV DL,[0000H+BX]
    ADD DL,30H
    INT 21H
    CMP BX,0
    JNE PRINT

NOT_PRIME:
    MOV BH,0
    MOV BL,10D
    CMP [termi], 0
    JE EXIT
    JMP BACK
    

EXIT:
    MOV AH, 09H 
    MOV dx, OFFSET newline
    INT 21H 

    MOV AH, 09H 
    MOV dx, OFFSET newline
    INT 21H 

    MOV AH, 09H 
    MOV dx, OFFSET disEnd
    INT 21H  

    mov ah, 4ch
    int 21h   
        
MAIN ENDP
END MAIN