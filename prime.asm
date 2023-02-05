.MODEL SMALL
.STACK 100H
.DATA
  digit_array DB ?, '$'
  input_len DW 0
  input DB ?,'$' ; array to store input
  msg DB "Enter number: $"     
  msg1 DB "Prime Numbers: $"
  newline DB 0dh,0ah,'$' ; newline character  
  termi DW 0
.CODE
MAIN PROC 
    
MOV AX, @DATA
MOV DS, AX

; display prompt message
MOV AH, 09H
MOV DX, OFFSET msg
INT 21H

; read numbers from keyboard and store them in input array
MOV SI, 0

INPUT_LOOP:
    MOV AH, 01H
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

MOV BX, 0H

CHECK_LOOP:
    ; check if the current element is equal to ' '
    MOV CL, [input + SI]
    CMP CL, 13D
    JE CHECK_IF_PRIME
    CMP CL, ' '
    JNE NUMBER
    
    JMP CHECK_IF_PRIME


BACK:
    ; increment si and loop check_loop
    INC SI
    DEC DI
    MOV [termi], DI
    JNZ CHECK_LOOP
    
    JMP EXIT


; Convert to Number
; AX = Temporary Variable
; BX = Number Accumlator
; CL = Digit Character in ASCII format
; DX = 10D
NUMBER:
    MOV AX, BX      ; AX <- BX

    AND CH, 0H      ; Set CH to 0000

    MOV DX, 10D     ; 
    MUL DX          ; Multiply AX with DX (10D), to add trailing zero, 42 => 420

    SUB CL, '0'     ; Convert Digit Character ASCII to Integer
    ADD AX, CX      ; Add Digit to Number: Digit = 9, Number = 420 => 429
    MOV BX, AX      ; Move AX to BX
    
    JMP BACK 


; Checks if BX (Signed 16bit Integer) is prime or not
; Value Range of BX: -32,768 to +32,767
; Up to (2^15)-1 = 32767
CHECK_IF_PRIME:
  MOV CX, 2D      ; Set up the Divisor to 2
  CWD
  JMP IS_PRIME    ; goto IS_PRIME to start checking


; AX = Temporary Variable
; BX = Number to be Checked
; CX = Current Divisor
; DX = Remainder
IS_PRIME:
  MOV AX, BX      ; AX <- BX

  CMP AX, 0D      ; if Number == 0:
  JE NOT_PRIME    ;   goto NOT_PRIME

  CMP AX, 1D      ; if Number == 1:
  JE NOT_PRIME    ;   goto NOT_PRIME

  CMP CX, 255D    ; if Divisor > 255:
  JG PRIME        ;   goto PRIME
                  ;
                  ; Decimal 255 since the highest divisor of N is sqrt(N),
                  ; and the highest possible value is signed 16bit number, (2^15)-1 = 32767
                  ; sqrt(32767) <= 255

  CMP CX, BX      ; if Divisir > Number:
  JGE PRIME       ;   goto PRIME

  IDIV CX         ; AX = floor(AX / CX)   [Quotient]
                  ; DX = AX % CX          [Remainder]

  CMP DX, 0D      ; if Remainder == 0:  (Means that AX is divisible by CX)
  JE NOT_PRIME    ;   goto NOT_PRIME

  INC CX          ; Increment Divisor

  AND DX, 0H      ; Reset DX (Divisor Register)

  JMP IS_PRIME    ; Retry the process for the incremented Divisor


;print if number is prime
PRIME:
    MOV AX, BX
    MOV BX, 0000H

STORE:
    MOV CX, 10D
    IDIV CX

    MOV [0000H + BX], DX
    ADD BX, 2H
    AND DX, 0H

    CMP AX, 0H

    JNE STORE


MOV AH, 2H
MOV DL, 0DH
INT 21H
MOV DL, 0AH
INT 21H


PRINT: 
    SUB BX, 2H
    MOV DL,[0000H + BX]
    ADD DL, 30H
    INT 21H
    CMP BX, 0H
    JNE PRINT


NOT_PRIME:
    MOV BX, 0H
    CMP [termi], 0H
    JE EXIT
    JMP BACK
    

EXIT:	   
    mov AH, 4CH
    int 21H
        
MAIN ENDP
END MAIN