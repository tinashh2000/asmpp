PrintStr:
        PUSH    ES,DI
        PUSH    DS
        POP     ES
        MOV     DI,WORD [PrintPtr]
PrintStrLoop:
        LODSB
        TEST    AL,AL
        JZ      PrintStrEnd
        CMP     AL,0Dh
        JZ      PrintStrFlush
        CMP     AL,0Ah
        JZ      PrintStrLoop
        STOSB
        CMP     DI,OFFSET PrintBuffer+256
        JBE     PrintStrLoop
        MOV     AX,".."
        STOSW
        STOSB
        JMP PrintStrFlush
PrintStrEnd:
        MOV [PrintPTR],DI
        POP DI,ES
        RET
PrintStrFlush:
        CALL    PrintFlush
        JMP     PrintStrLoop
PrintFlush:
        MOV     AL,0
        STOSB
        PUSH    CX,SI,ES
        CALL    SendMessage,[hOutput],LB_ADDSTRING,0,DS,OFFSET PrintBuffer
        MOV     DI,OFFSET PrintBuffer
        POP     ES,SI,CX
        RET
        
PrintStrFixed:
        PUSH    ES,DI
        PUSH    DS
        POP ES
        MOV DI,[PrintPTR]
        TEST    CX,CX
        JZ      PrintStrfixedEnd
PrintStrFixedLoop:
        LODSB
        TEST    AL,AL
        JZ      PrintStrFixedEnd
        CMP     AL,0Dh
        JZ      PrintStrFixedFlush
        CMP     AL,0Ah
        JZ      PrintStrFixedLoop
        STOSB
        CMP     DI,OFFSET PrintBuffer+256
        JAE     PrintStrFixedFlush1
        DEC     CX
        JNZ     PrintStrFixedLoop
PrintStrFixedEnd:
        MOV [PrintPTR],DI
        POP DI,ES
        RET
PrintStrFixedFlush1:
        MOV     AX,".."
        STOSW
        STOSB
PrintStrFixedFlush:
        CALL    PrintFlush
        JMP PrintStrFixedLoop

PrintLF:
        MOV     SI,OFFSET _lf
        CALL    PrintStr
        RET

PrintInt:        
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
        CMP     AX,10
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

PrintOct:
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
        MOV     BX,8
        STD
        JMP     PrintIntLoop

PrintHex:
        PUSH    AX
        MOV     AX,DX
        CALL    PrintHexWord
        POP     AX
        CALL    PrintHexWord
        RET

PrintHexWord:
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



PrintError:
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
