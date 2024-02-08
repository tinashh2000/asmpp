PrintStr	PROC
        LODSB
        TEST    AL,AL
        JZ      PrintStrEnd
		CALL	PrintChar
		JMP     PrintStr
PrintStrEnd:
        RET
PrintStr	ENDP

PrintStrFixed	PROC
        TEST    CX,CX
        JZ      PrintStrfixedend
PrintStrFixedLoop:
        LODSB
        TEST    AL,AL
        JZ      PrintStrFixedEnd

        CMP     AL,32
        JB      PrintStrFixedLoo

		CALL	PrintChar
 PrintStrFixedLoo:
        DEC     CX
        JNZ     PrintStrfixedLoop
PrintStrFixedEnd:
        RET
PrintStrFixed	ENDP


PrintStrLine PROC
pslLoop:
        LODSB
        TEST	AL,AL
        JZ	pslDone

		CMP		AL,0Dh
		JZ		pslDone
		CMP		AL,0Ah
		JZ		pslDone
		
;        CMP     AL,32
;        JB      pslLoop

		CALL	PrintChar
 		JMP		pslLoop
pslDone:
        RET
PrintStrLine	ENDP

PrintLF	PROC
		MOV	AL,0Dh
		CALL	PrintChar
		MOV	AL,0Ah
		CALL	PrintChar
        RET
PrintLF	ENDP

PrintInt	PROC
        MOV     DI,OFFSET NumBuffer+12
        XOR     CX,CX
        PUSH    ES
        MOV     BX,AsmData
        MOV     ES,BX
        MOV     BX,10
        STD
PrintIntLoop:
        PUSH    AX
        MOV     AX,DX
        XOR     DX,DX
        DIV     BX
        MOV     SI,AX
        POP     AX
        DIV     BX
        PUSH    AX
        MOV     AL,DL
        ADD     AL,48
        STOSB
        MOV     DX,SI
        POP     AX
        INC     CL
        TEST    DX,DX
        JNZ     PrintIntLoop
        CMP     AX,BX
        JAE     PrintIntLoop
        TEST    AL,AL
        JZ      PrintintPrintStr
        ADD     AL,48
        STOSB
        INC     CL
PrintIntPrintStr:
        CLD
        LEA     SI,[DI+1]
        CALL    PrintStrfixed
        POP     ES
        RET
PrintInt	ENDP

PrintOct	PROC
        MOV     DI,OFFSET NumBuffer+12
        XOR     CX,CX
        PUSH    ES
        MOV     BX,AsmData
        MOV     ES,BX
        MOV     BX,8
        STD
        JMP     PrintIntLoop
PrintBin:
        MOV     DI,OFFSET NumBuffer+32
        XOR     CX,CX
        PUSH    ES
        MOV     BX,AsmData
        MOV     ES,BX
        MOV     BX,2
        STD
        JMP     PrintIntLoop
PrintOct	ENDP

PrintHex	PROC
        PUSH    AX
        MOV     AX,DX
        CALL    PrintHexWord
        POP     AX
        CALL    PrintHexWord
        RET
PrintHex	ENDP

PrintHexByte:
        MOV     CX,204h
        MOV     BH,AL
        JMP     PrintHexWordLoop

PrintHexWord	PROC
        MOV     CX,404h
        MOV     BX,AX
PrintHexWordLoop:
        ROL     BX,CL
        MOV     AL,BL
        AND     AL,0Fh

        ADD     AL,48
        MOV     AH,7
        MOV     DH,0FFh ;Must be 0xFF IF > 58
        CMP     AL,58   ;is AL > 58
        ADC     DH,0    ;INC DH IF below
        AND     AH,DH   ;erase AH IF < 58
        ADD     AL,AH   ;AL+AH->AH

        CALL    PrintChar
        DEC     CH
        JNZ     PrintHexWordLoop
        RET
PrintHexWord	ENDP



PrintError	PROC
        PUSH    ES
        MOV     AX,AsmData
        MOV     DS,AX
        MOV     ES,AX
        CMP     BYTE [Error],130
        JZ      PrintErrorSuppWarnings
        PUSH    SI
        CMP     BYTE [Error],128
        JZ      PrintErrorWarning
        CMP     BYTE [Error],255
        JZ      PrintErrorFatal
        MOV     SI,OFFSET Errortxt
        INC     WORD [NumErrors]
        CMP     BYTE [Error],127
        JZ      PrintError1
        MOV     BYTE [Error],0
        JMP     PrintError1
PrintErrorSuppWarnings:
        INC     WORD [NumWarnings]
        MOV     BYTE [Error],0
        TEST    BYTE [AsmFlags2][1],1
        JZ      PrintErrorDone
        PUSH    SI
PrintErrorWarning:
        MOV     SI,OFFSET WarningTxt
        INC     WORD [NumWarnings]
        MOV     BYTE [Error],0
        JMP     PrintError1
PrintErrorFatal:
        MOV     SI,OFFSET FatalTxt
        INC     WORD [NumErrors]
PrintError1:
        CALL    PrintStr
        MOV     SI,OFFSET curfile
        CALL    PrintStr
        MOV     AL,32
        CALL    PrintChar
        CMP     WORD [LineNumber],0
        JNZ     PrintError2
        CMP     WORD [LineNumber][2],0
        JZ      PrintError3
PrintError2:
        MOV     AL,"("
        CALL    PrintChar
        MOV     AX,[LineNumber]
        MOV     DX,[LineNumber][2]
        CALL    Printint
        MOV     AL,")"
        CALL    PrintChar
        MOV     AL,32
        CALL    PrintChar
PrintError3:
        CMP     BYTE [Error],127
        JNZ     PrintError4
        MOV     BYTE [Error],0
        MOV     SI,OFFSET _ArgStr
        CALL    PrintStr
        MOV     AX,[Temp4]
        XOR     DX,DX
        CALL    PrintInt
        MOV     AL,20h
        CALL    PrintChar
PrintError4:
        POP     SI
        CALL    PrintStr
PrintErrordone:
        POP     ES
        RET
PrintError	ENDP


intToStr    PROC
        PUSH    BX,DX,SI,DI,ES
		PUSHF
        MOV     DI,OFFSET NumBuffer+12
        XOR     CX,CX
        MOV     BX,AsmData
        MOV     ES,BX
        MOV     BX,10
        STD
intToStrLoop:
        PUSH    AX
        MOV     AX,DX
        XOR     DX,DX
        DIV     BX
        MOV     SI,AX
        POP     AX
        DIV     BX
        PUSH    AX
        MOV     AL,DL
        ADD     AL,48
        STOSB
        MOV     DX,SI
        POP     AX
        INC     CL
        TEST    DX,DX
        JNZ     intToStrLoop
        CMP     AX,10
        JAE     intToStrLoop
        TEST    AL,AL
        JZ      intToStrDone
        ADD     AL,48
        STOSB
        INC     CL
intToStrDone:
        CLD
        MOV SI,DI
        MOV DI,(NumBuffer)
        PUSH    CX
        INC SI
		REP	MOVSB
        POP CX
		POPF
        POP ES,DI,SI,DX,BX
        RET
intToStr	ENDP


DumpStuff   PROC
        PUSHAD
        MOV SI,(CurFile)
        CALL    PrintStr

        MOV     AX,[LineNumber]
        INC     AX
        XOR     DX,DX
        CALL    PrintInt

        MOV     AL,9
        CALL    PrintChar
        MOV     AX,[InBufferPTR]
        XOR     DX,DX
        CALL    PrintInt
        MOV     AL,9
        CALL    PrintChar

        MOV     AX,[OBufferPTR]
        XOR     DX,DX
        CALL    PrintInt

        MOV     AL,9
        CALL    PrintChar

        PUSH    DS
        LDS     SI,[InBufferPTR]
        MOV CX,15
        CALL    PrintStrFixed
        POP     DS
        CALL    PrintLF
        POPAD
        RET
DumpStuff   ENDP

HexToStrWord    PROC
        PUSH    BX, CX, DX
        MOV     CX,404h
        MOV     BX,AX
    htsLoop:
        ROL     BX,CL
        MOV     AL,BL
        AND     AL,0Fh

        ADD     AL,48
        MOV     AH,7
        MOV     DH,0FFh ;Must be 0xFF IF > 58
        CMP     AL,58   ;is AL > 58
        ADC     DH,0    ;INC DH IF below
        AND     AH,DH   ;erase AH IF < 58
        ADD     AL,AH   ;AL+AH->AH
        STOSB
        DEC     CH
        JNZ     htsLoop
        POP DX,CX,BX
        RET
HexToStrWord    ENDP

HexToStrDWord   PROC
    PUSH    AX
    MOV AX,DX
    CALL    HexToStrWord
    POP AX
    CALL    HexToStrWord
    RET
HexToStrDWord   ENDP


_PrintChar PROC   char:WORD
PUSHAD
    MOV AL, [char]
    CALL PrintChar
POPAD
    RET
_PrintChar ENDP

_PrintStr PROC strn:WORD
    PUSHAD
    MOV SI, [strn]
    CALL PrintStr
    POPAD
    RET
_PrintStr ENDP

_PrintHex PROC n1:WORD
    PUSHAD
    MOV AX, [n1]
    CALL PrintHexWord
    POPAD
    RET
_PrintHex ENDP


_PrintHex32 PROC n1:DWORD
    PUSHAD
    MOV AX, [n1]
    MOV DX, [n1][2]
    CALL PrintHex
    POPAD
    RET
_PrintHex32 ENDP


_PrintInt PROC n1:WORD
    PUSHAD
    MOV AX, [n1]
    MOV DX, 0
    CALL PrintInt
    POPAD
    RET
_PrintInt ENDP


_PrintInt32 PROC n1:DWORD
    PUSHAD
    MOV AX, [n1]
    MOV DX, [n1][2]
    CALL PrintInt
    POPAD
    RET
_PrintInt32 ENDP

_PrintLF PROC 
    PUSHAD
    CALL PrintLF
    POPAD
    RET
_PrintLF ENDP
