LCaseStr:
    TEST    CX,CX
    JZ      LCaseStrDone
    PUSH    BX
    MOV     BX,OFFSET LCasetable
LCaseStrLoop:
    LODSB
    ES:
    XLAT
    STOSB
    DEC     CX
    JNZ     LCaseStrLoop
    POP     BX
LCaseStrDone:
    RET


UCaseStr:
    TEST    CX,CX
    JZ      LCaseStrDone
UCaseStrLoop:
    LODSB
    CMP     AL,"a"
    JB      UCaseCharOK
    CMP     AL,"z"
    JA      UCaseCharOK
    SUB     AL,32
UCaseCharOK:
    STOSB
    DEC     CX
    JNZ     UCaseStrLoop
    RET

SearchStr:
    PUSH    CX,SI,DI
    MOV DI,SI
    CALL    LCaseStr
    POP DI,SI,CX
    XOR     DX,DX
SearchCompareLoop:
    PUSH    CX
    PUSH    SI
    PUSH    DI
    REP     CMPSB
    POP     DI
    POP     SI
    POP     CX
    JZ      SearchFound
    ADD     DI,CX
    CMP     BYTE [DI],0
    JZ      SearchNotFound
    INC     DL
    JMP     SearchCompareLoop
SearchFound:
    MOV     AX,DX
    INC     AL
    RET
SearchNotFound:
    XOR     AX,AX
    RET

ConvStrNum:
        TEST    DX,DX
        JZ      ConvStrNumLoadZero
        CMP     DX,50
        JA      ConvStrNumDone
        ADD     DI,DX
        DEC     DI
        PUSH    DI
ConvStrLoop:
        LODSB
        MOV     BYTE [DI],AL
        DEC     DI
        DEC     DX
        JNZ     ConvStrLoop
        POP     SI
        SUB     SI,DI
        MOV     AL,BYTE [SI][NumSizeTable][-1]
        MOV     AH,Number
        MOV     DX,WORD [DI][1]
ConvStrNumDone:
        RET
ConvStrNumLoadZero:
        MOV     AX,(Number SHL 8) OR Num8
        XOR     DL,DL
        RET
