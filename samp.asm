;Christabelle
.MODEL SMALL
.STACK 100H
.DATA
input_len DW 0
input DB ?,'$' ; array to store input
msg DB "Enter number: $"     
msg1 DB "Prime Numbers: $"
newline DB 0dh,0ah,'$' ; newline character  
termi DW 0 

.CODE
MAIN PROC 
    
MOV BH,0
MOV BL,10D

MOV AX, @DATA   ;store data variable
MOV DS, AX

; display prompt message
MOV AH, 09H         ;for printing
MOV DX, OFFSET msg  ;store address location
INT 21H     ;christabelle


;Aaron
; read numbers from keyboard and store them in input array
MOV SI, 0   ;for array

INPUT_LOOP:
    MOV aH, 01H         ;scan character
    INT 21H
    MOV [input+SI], AL  ;input[si] ;move user input to input array 
    INC SI              ;si++ increment 
    CMP AL, 13          ;check if user hit enter
    JNE INPUT_LOOP      ;jump if not equal
    MOV [input_len], SI ;store the result of si(length of array) to input_len

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
INT 21H     ;Aaron
                   

;ako          
; iterate through the input array
MOV DI, [input_len] ;store value of input_len to DI
MOV SI, 0 ; SI = 0

CHECK_LOOP:
    ; check if the current element is equal to ' '
    MOV AL, [input+SI]  ;input[si]
    CMP AL, 13D         ;check if user hit enter
    JE CHECK
    CMP AL, ' '         ;check if user entered a space
    JNE NUMBER          ;jump if not equal
    
    JMP CHECK           ;jump to check

    ;clears bh memory, bl=10 
    ;for new number
    MOV BH,0
    MOV BL,10D

    BACK:
        ; increment si and loop check_loop
        INC SI             ;SI++
        DEC DI             ;DI--
        MOV [termi], DI    ;store new value of DI to termi
        JNZ CHECK_LOOP     ; jump if not equal to zero
        
        JMP EXIT


    ;convert to number
    NUMBER:
        SUB AL,30H  ;convert into a number
        MOV CL,AL   ;store converted value into CL
        MOV AL,BH   ;AL = BH ; for 
        MUL BL      ;Multiply BL (has value of 10 or A)
        ADD AL,CL   ;add cl to al
        MOV BH,AL   ;BH = AL ;
        
        JMP BACK  ;ako


;Robin
;check if it is prime
CHECK:   
    CMP BH,1        ;compare bh to 1
    JLE NOT_PRIME   ;jump if less than or equal

    MOV CX,2        ;store 2 to cx
    AND AX,0        ;clears value of ax and dx
    AND DX,0

    MOV AL,BH       ;store value of bh to al
    DIV CX          ; divide it to 2

    MOV CX,AX       ;store value of ax to to cx

ISPRIME:
    CMP CX,2        ;compare cx to 2
    JL PRIME
    AND AX,0        ;clears ax and dx
    AND DX,0
    MOV AL,BH       ;store value of bh to al       
    DIV CX          ;divide it to cx
    DEC CX          ;decrement

    CMP DX,0        
    JE NOT_PRIME

    JMP ISPRIME ;robin

;michael
;print if number is prime
PRIME:
    AND AX,0
    MOV AL,BH       ;AL = 23
    MOV CL,10D      ;CL=10
    
    MOV BX,0000H    ;clears BX


STORE:
    DIV CL              ;divides CL and AL ;AH = remainder AL=quotient 
    MOV [0000H+BX],AH   ;32
    ADD BX,2H
    MOV AH,0
    CMP AL,0 

    JNE STORE


    MOV AH,2
    MOV  DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H

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
    JMP BACK ;michael
    

EXIT:	   
    mov ah, 4ch
    int 21h   
        
MAIN ENDP
END MAIN