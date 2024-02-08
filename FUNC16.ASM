
ProcessQuoteInit:
        TEST    BYTE [Process],4
        JNZ     ProcessQuoteDone2
        CALL    GetNextCharI
ProcessQuote:        
        MOV     AL,BYTE [NextChar]
        CMP     AL,Alpha
        JZ      ProcessQuoteOpOK
        CMP     AL,AddOp
        JB      ProcessQuoteDone
        CMP     AL,BoolOrOp
        JA      ProcessQuoteDone
        INC     WORD [InBufferPtr]
        MOV     BYTE [CurOp],AL
ProcessQuoteOpOK:
        OR      BYTE [Process],4
        PUSH    DX
        MOV     DI,WORD [StrFree]
        MOV     CX,DX
        ADD     DX,DI
        CMP     DX,OFFSET StrBuffer+2048
        JA      ProcessQuoteTooLong
        PUSH    DI
        MOV     SI,OFFSET StrBuffer
        REP     MOVSB
        MOV     WORD [StrFree],DI
ProcessQuoteLoop:
        CALL    GetOperand
        CMP     AL,Quote
        JZ      ProcessQuote2
        CALL    CombineOperators
        JC      ProcessQuoteError
        JMP     ProcessQuoteLoop
ProcessQuoteDone:
        AND     BYTE [Process],NOT 4
ProcessQuoteDone2:
        MOV     AX,Quote
        RET
ProcessQuoteTooLong:
        MOV     SI,WORD [OBufferPtr]
        JMP     GetNextAlphaTooLong
ProcessQuoteJoin:
        MOV     BP,DX
        ADD     BP,CX
        CMP     BP,256
        JA      ProcessQuoteTooLong
ProcessQuoteSwap:
        MOV     SI,OFFSET StrBuffer-1
        MOV     DI,SI
        ADD     DI,CX
        ADD     DI,DX
        ADD     SI,DX
        STD
        XCHG    CX,DX
        REP     MOVSB
        MOV     CX,DX
        MOV     SI,WORD [StrFree]
        CLD
        MOV     DI,OFFSET StrBuffer
        REP     MOVSB
        MOV     DX,BP
        JMP     ProcessQuote
ProcessQuoteError:
        CMP     BYTE [CurOp],0
        JNZ     ProcessQuoteError2
        CMP     AL,Keyword
        JZ      ProcessQuoteKW
        CMP     AL,CPUInstruction
        JNZ     ProcessQuoteError2
        CALL    GetInstrOperator
        JC      ProcessQuoteError2
        MOV     BYTE [CurOp],AL
        JMP     ProcessQuoteLoop
ProcessQuoteError2:
        JMP     InvalidEAEntry
ProcessQuoteKW:
        CMP     DL,Operator
        JNZ     ProcessQuoteError2
        MOV     BYTE [CurOp],DH
        JMP     ProcessQuoteLoop
ProcessQuote2:
        CMP     DX,256
        JA      ProcessQuoteTooLong
        POP     SI,CX
        MOV     WORD [StrFree],SI
        MOV     DI,OFFSET StrBuffer
        MOV     AL,BYTE [CurOp]
        TEST    AL,AL
        JZ      ProcessQuoteJoin
        MOV     BYTE [CurOp],0
        CMP     AL,AddOp
        JZ      ProcessQuoteJoin
        CMP     AL,LTOp
        JZ      ProcessQuoteLT
        CMP     AL,GTOp
        JZ      ProcessQuoteGT
        CMP     AL,EQOp
        JZ      ProcessQuoteEQ
        CMP     AL,NotOp
        JZ      ProcessQuoteNE
        CMP     AL,NEOp
        JZ      ProcessQuoteNE
        CMP     AL,LEOp
        JZ      ProcessQuoteLE
        CMP     AL,GEOp
        JZ      ProcessQuoteGE
        CMP     AL,BoolEQOp
        JZ      ProcessQuoteEQ
        JMP     InvalidOperators
ProcessQuoteLoadZero:
        MOV     DI,OFFSET OWordNum
        XOR     AX,AX
        MOV     DX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     AX,Number SHL 8 OR Num8
        RET
ProcessQuoteLT:
        CMP     CX,DX
        JA      ProcessQuoteLoadZero
        JB      ProcessQuoteLoadOne
        REP     CMPSB
        JGE     ProcessQuoteLoadZero
        JMP     ProcessQuoteLoadOne
ProcessQuoteGT:
        CMP     CX,DX
        JA      ProcessQuoteLoadOne
        JB      ProcessQuoteLoadZero
        REP     CMPSB
        JLE     ProcessQuoteLoadZero
        JMP     ProcessQuoteLoadOne
ProcessQuoteEQ:
        CMP     CX,DX
        JNZ     ProcessQuoteLoadZero
        REPZ    CMPSB
        JNZ     ProcessQuoteLoadZero
        JMP     ProcessQuoteLoadOne
ProcessQuoteNE:
        CMP     CX,DX
        JNZ     ProcessQuoteLoadOne
        REPNZ   CMPSB
        JZ      ProcessQuoteLoadZero
        JMP     ProcessQuoteLoadOne
ProcessQuoteLE:
        CMP     CX,DX
        JA      ProcessQuoteLoadZero
        JB      ProcessQuoteLoadOne
        REP     CMPSB
        JG      ProcessQuoteLoadZero
        JMP     ProcessQuoteLoadOne
ProcessQuoteGE:
        CMP     CX,DX
        JA      ProcessQuoteLoadOne
        JB      ProcessQuoteLoadZero
        REP     CMPSB
        JL      ProcessQuoteLoadZero
        JMP     ProcessQuoteLoadOne
ProcessQuoteLoadOne:
        MOV     DI,OFFSET OWordNum
        MOV     AX,-1
        MOV     DX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     AX,Number SHL 8 OR Num8
        RET
AssembleChangeInFile:
        CMP     BYTE [FileLevel],0
        JZ      AssembleChangeInFileFail
        MOV     BX,WORD [CurHandle]
        CALL    FClose
        DEC     BYTE [FileLevel]
        MOV     BX,WORD [FileLevel]
        MOV     AX,72
        MUL     BX
        MOV     SI,AX
        ADD     SI,OFFSET Files
        MOV     DI,OFFSET CurFile
        MOV     CX,36
        REP     MOVSW
        MOV     BYTE [Msg],CL
        MOV     BX,WORD [CurHandle]
        CALL    FGetPos
        MOV     BYTE [Flushed],1
        MOV     WORD [BytesRead],AX
        MOV     WORD [BytesRead][2],DX
        MOV     SP,WORD [AsmStack]
        JMP     AssembleFileInit
AssembleChangeInFileFail:
        MOV     BYTE [Msg],0
        STC
        RET
TranslateQuote:        
        TEST    BYTE [Settings][1],1
        JNZ     TranslateQuoteDone
        CMP     DX,16
        JA      TranslateQuoteNumTooBig
        TEST    DX,DX
        JZ      TranslateQuoteEmpty        
        MOV     DI,OFFSET OWordNum
        MOV     CX,4
        XOR     AX,AX
        REP     STOSW
        MOV     DI,OFFSET OWordNum
        ADD     DI,DX
        MOV     AH,BYTE [DI][NumSizeTable][-OWordNum][-1]
        MOV     SI,OFFSET StrBuffer
TranslateQuoteLoop:
        LODSB
        DEC     DI
        MOV     BYTE [DI],AL
        DEC     DL
        JNZ     TranslateQuoteLoop
        MOV     DX,WORD [DI]
        MOV     AL,AH
        MOV     AH,Number
TranslateQuoteDone:
        RET
TranslateQuoteEmpty:
        MOV     AH,Number
        MOV     AL,Num8
        RET
TranslateQuoteNumTooBig:
        JMP     NumTooBig
EVEN 2
WriteOverrides:
        XOR     AX,AX
        XCHG    AX,WORD [AddrOverride]
        STOSB   ;ES:[DI]=AL
        CMP     AL,1    ;AL ,1
        SBB     DI,0    ;DI=DI-CF. Subtracts IF below
        MOV     AL,AH
        STOSB
        CMP     AL,1
        SBB     DI,0
WriteOverridesDone:
        RET
EVEN 2
UpdateProgIP:
        MOV     BX,DI
        SUB     BX,WORD [OBufferPtr]
        MOV     WORD [OBufferPtr],DI
        ADD     WORD [ProgIP],BX
        JC      UpdateEIP
        RET
UpdateProgIPOverflow:
        STC
        RET
UpdateEIP:
        CMP     BYTE [AddrMode],2
        JB      UpdateProgIPOverflow
        ADD     WORD [ProgIP][2],1
        JC      UpdateRIP
        RET
UpdateRIP:
        CMP     BYTE [AddrMode],4
        JB      UpdateProgIPOverflow
        ADD     WORD [ProgIP][4],1
        ADC     WORD [ProgIP][6],0
        RET
EVEN 2
CheckOpSize64:
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      CheckOpSizeOK
        CMP     AH,_QWORD
        JNZ     CheckOpSizeFail
CheckOpSizeOK:
        CLC
        RET
CheckOpSizeFail:
        JMP     InvalidOperandSize
EVEN 2
CheckOpSize32:
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      CheckOpSizeOK
        CMP     AH,_DWORD
        JNZ     CheckOpSizeFail
        RET

EVEN 2
CheckOpSize48:
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      CheckOpSizeOK
        CMP     AH,_FWORD
        JNZ     CheckOpSizeFail
        RET

EVEN 2
CheckOpSize80:
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      CheckOpSizeOK
        CMP     AH,_TWORD
        JNZ     CheckOpSizeFail
        RET

EVEN 2
CheckOpSize16:
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      CheckOpSizeOK
        CMP     AH,_WORD
        JNZ     CheckOpSizeFail
        RET

EVEN 2
CheckOpSize8:
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      CheckOpSizeOK
        CMP     AH,_BYTE
        JNZ     CheckOpSizeFail
        RET
EVEN 2
GetJump16Size:
        TEST    BL,1
        JZ      GetJumpDone
        CMP     BYTE [JmpSize],0    ;IF SIZE is specified dont worry
        JNZ     GetJumpDone
        CMP     BL,3
;        JZ      GetJumpNearJmp
        CMP     DX,WORD [ProgIP]    ;IF symbol IF NOT forward referenced
        JBE     GetJumpDone
GetJumpNearJmp:
        MOV     BYTE [JmpSize],NearJmp
GetJumpDone:
        RET

EVEN 2
GetJump32Size:
        TEST    BL,1
        JZ      GetJumpDone
        CMP     BYTE [JmpSize],0
        JNZ     GetJumpDone
        CMP     BL,3
;        JZ      GetJumpNearJmp
        MOV     AX,WORD [OWordNum][2]
        CMP     AX,WORD [ProgIP][2]
        JB      GetJumpDone
        CMP     DX,WORD [ProgIP]
        JBE     GetJumpDone        
        MOV     BYTE [JmpSize],NearJmp
        RET
EVEN 2
GetJump64Size:
        TEST    BL,1
        JZ      GetJumpDone
        CMP     BYTE [JmpSize],0    
        JNZ     GetJumpDone
        CMP     BL,3
;        JZ      GetJumpNearJmp
        PUSH    SI,DI
        STD
        MOV     SI,OFFSET OWordNum+6
        MOV     DI,OFFSET ProgIP+6
        PUSH    ES
        MOV BX,DS
        MOV ES,BX
        MOV     BL,0
        CMPSW
        ADC     BL,BL
        CMPSW
        ADC     BL,BL
        CMPSW
        ADC     BL,BL
        CMPSW
        ADC     BL,BL
        POP ES
        CLD
        JNZ     GetJump64Done
        MOV     BYTE [JmpSize],NearJmp
GetJump64Done:
        POP     DI,SI
        RET

TranslateR8InvalidComb:
        JMP     CombinationNotAllowed
TranslateR8LM:
        TEST    DH,32
        JNZ     TranslateR8InvalidComb
TranslateLMStore:
        STOSB
TranslateRegStore:
        MOV     AL,AH
        MOV     AH,DH
        STOSW
        JMP     AssembleDone
TranslateR8:
        DEC     AH
        CMP     CL,Reg8
        JZ      TranslateRegStore
        MOV     AL,41h
        CMP     CL,LMReg8
        JZ      TranslateR8LM
        MOV     AL,40h
        CMP     CL,LMLowReg
        JZ      TranslateR8LM
        JMP     InvalidOperand2
EVEN 2
TranslateReg:
        ADD     DH,DH
        ADD     DH,DH
        ADD     DH,DH
TranslateReg2:
        OR      DH,CH
        OR      DH,0C0h
        CMP     DL,Reg8
        JZ      TranslateR8
        CMP     DL,Reg16
        JZ      TranslateR16
        CMP     DL,Reg32
        JZ      TranslateR32
        CMP     DL,Reg64
        JZ      TranslateR64
        JMP     TranslateReg22
TranslateR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        CMP     CL,Reg16
        JZ      TranslateRegStore2
        MOV     AL,41h
        CMP     CL,LMReg16
        JZ      TranslateLMStore2
        JMP     InvalidOperand2
TranslateR32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        CMP     CL,Reg32
        JZ      TranslateRegStore2
        MOV     AL,41h
        CMP     CL,LMReg32
        JZ      TranslateLMStore2
        JMP     InvalidOperand2
TranslateR64:
        MOV     AL,48h
        CMP     CL,Reg64
        JZ      TranslateLMStore2
        MOV     AL,49h
        CMP     CL,LMReg64
        JZ      TranslateLMStore2
        JMP     InvalidOperand2

TranslateLMR8InvalidComb:
        JMP     CombinationNotAllowed
TranslateLM8R8:
        CMP     CH,4 
        JAE     TranslateLMR8InvalidComb
TranslateLMStore2:
        STOSB
TranslateRegStore2:
        MOV     AL,AH
        MOV     AH,DH
        STOSW
        JMP     AssembleDone
TranslateLMR8:
        DEC     AH
        MOV     AL,44h
        CMP     CL,Reg8
        JZ      TranslateLM8R8
        MOV     AL,45h
        CMP     CL,LMReg8
        JZ      TranslateLMStore2
        MOV     AL,44h
        CMP     CL,LMLowReg
        JZ      TranslateLMStore2
        JMP     InvalidOperand2
TranslateLowReg:
        DEC     AH
        MOV     AL,40h
        CMP     CL,Reg8
        JZ      TranslateLM8R8
        MOV     AL,41h
        CMP     CL,LMReg8
        JZ      TranslateLMStore2
        MOV     AL,40h
        CMP     CL,LMLowReg
        JZ      TranslateLMStore2
        JMP     InvalidOperand2
EVEN 2
TranslateReg22:
        CMP     DL,LMReg8
        JZ      TranslateLMR8
        CMP     DL,LMReg16
        JZ      TranslateLMR16
        CMP     DL,LMReg32
        JZ      TranslateLMR32
        CMP     DL,LMReg64
        JZ      TranslateLMR64
        CMP     DL,LMLowReg
        JZ      TranslateLowReg
        JMP     InvalidOperand1
TranslateLMR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,44h
        CMP     CL,Reg16
        JZ      TranslateLMStore3
        MOV     AL,45h
        CMP     CL,LMReg16
        JZ      TranslateLMStore3
        JMP     InvalidOperand2
TranslateLMR32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,44h
        CMP     CL,Reg32
        JZ      TranslateLMStore3
        MOV     AL,45h
        CMP     CL,LMReg32
        JZ      TranslateLMStore3
        JMP     InvalidOperand2
TranslateLMR64:
        MOV     AL,4Ch
        CMP     CL,Reg64
        JZ      TranslateLMStore3
        MOV     AL,4Dh
        CMP     CL,LMReg64
        JZ      TranslateLMStore3
        JMP     InvalidOperand2
TranslateLMStore3:
        STOSB
TranslateRegStore3:
        MOV     AL,AH
        MOV     AH,DH
        STOSW
        JMP     AssembleDone
TranslateMem16Imm:
        CMP     BL,Num16
        JA      TranslateMemImmNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AH,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        STOSB
        MOV     BYTE [RemainBytes],2
        CALL    WriteEAData
        CALL    Write16Imm
        JMP     AssembleDone
TranslateMem32Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
TranslateMem32ImmCheckSize:
        CMP     BL,Num32
        JA      TranslateMemImmNumTooBig
TranslateMemImmWrite:
        MOV     AH,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        STOSB
        MOV     BYTE [RemainBytes],4
        CALL    WriteEAData
        CALL    Write32Imm
        JMP     AssembleDone
TranslateMemImmNumTooBig:
        JMP     NumTooBig
TranslateMem64Imm:
        CMP     BYTE [AddrMode],4
        JB      TranslateMemImmInvalidAddrMode
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     TranslateMem32ImmCheckSize
TranslateMemImmInvalidAddrMode:
        JMP     InvalidAddrMode
EVEN 2
TranslateMemImm:
        OR      BYTE [ModRM],AH
        PUSH    AX
        CALL    WriteOverrides
        POP     AX
        CALL    GetOperandSize
        CMP     AH,_BYTE
        JZ      TranslateMem8Imm
        CMP     AH,_WORD
        JZ      TranslateMem16Imm
        CMP     AH,_DWORD
        JZ      TranslateMem32Imm
        CMP     AH,_QWORD
        JZ      TranslateMem64Imm
        JMP     InvalidOperandSize
TranslateMem8Imm:
        CMP     BL,Num8
        JA      TranslateMemImmNumTooBig
        MOV     AH,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        DEC     AL
        STOSB
        MOV     BYTE [RemainBytes],1
        CALL    WriteEAData
        MOV     AL,CL
        STOSB
        JMP     AssembleDone

TranslateR8Mem:
        CALL    CheckOpSize8
        DEC     AL
        JMP     TranslateRegMemWrite
TranslateR16Mem:
        CALL    CheckOpSize16
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     TranslateRegMemWrite
TranslateR32Mem:
        CALL    CheckOpSize32
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
TranslateRegMemWrite:
        MOV     AH,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
TranslateR64Mem:
        CALL    CheckOpSize64
        OR      BYTE [REXOverride],48h
        JMP     TranslateRegMemWrite
EVEN 2
TranslateMemReg:
        MOV     DX,CX
TranslateRegMem:
        PUSH    AX
        CALL    WriteOverrides
        POP     AX
        ADD     DH,DH
        ADD     DH,DH
        ADD     DH,DH
        OR      BYTE [ModRM],DH
        CMP     DL,Reg8
        JZ      TranslateR8Mem
        CMP     DL,Reg16
        JZ      TranslateR16Mem
        CMP     DL,Reg32
        JZ      TranslateR32Mem
        MOV     BYTE [REXDisp],1
        CMP     DL,Reg64
        JZ      TranslateR64Mem
        OR      BYTE [REXOverride],40h
        CMP     DL,LMLowReg
        JZ      TranslateLowRegMem
        OR      BYTE [REXOverride],44h
        CMP     DL,LMReg8
        JZ      TranslateLMR8Mem
        CMP     DL,LMReg16
        JZ      TranslateLMR16Mem
        CMP     DL,LMReg32
        JZ      TranslateLMR32Mem
        CMP     DL,LMReg64
        JZ      TranslateR64Mem
        CMP     CX,DX
        JZ      TranslateMemRegInvalidOp
        JMP     InvalidOperand1
TranslateMemRegInvalidOp:
        JMP     InvalidOperand2
TranslateLowRegMem:
        CALL    CheckOpSize8
        DEC     AL
        JMP     TranslateRegMemWrite
TranslateLMR8Mem:
        CALL    CheckOpSize8
        DEC     AL
        JMP     TranslateRegMemWrite
TranslateLMR16Mem:
        CALL    CheckOpSize16
        JMP     TranslateRegMemWrite
TranslateLMR32Mem:
        CALL    CheckOpSize32        
        JMP     TranslateRegMemWrite
TranslateR8Imm:
        CMP     BL,Num8
        JA      TranslateRegImmNumTooBig
        DEC     AL
        STOSW
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
TranslateR16Imm:
        CMP     BL,Num16
        JA      TranslateRegImmNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSW
        CALL    Write16Imm
        JMP     AssembleDone
TranslateR32Imm:
        CMP     BL,Num32
        JA      TranslateRegImmNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone
TranslateR64Imm:
        CMP     BL,Num32
        JA      TranslateRegImmNumTooBig
        MOV     BYTE ES:[DI],48h
        INC     DI
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone
TranslateRegImmNumTooBig:
        JMP     NumTooBig
EVEN 2
TranslateRegImm:
        OR      AH,0C0h
        OR      AH,DH
        CMP     DL,Reg8
        JZ      TranslateR8Imm
        CMP     DL,Reg16
        JZ      TranslateR16Imm
        CMP     DL,Reg32
        JZ      TranslateR32Imm
        CMP     DL,Reg64
        JZ      TranslateR64Imm
        CMP     DL,LMLowReg
        JZ      TranslateLowRegImm
        CMP     DL,LMReg8
        JZ      TranslateLMR8Imm
        CMP     DL,LMReg16
        JZ      TranslateLMR16Imm
        CMP     DL,LMReg32
        JZ      TranslateLMR32Imm
        CMP     DL,LMReg64
        JZ      TranslateLMR64Imm
        JMP     InvalidOperand1
TranslateRegImmNumTooBig2:
        JMP     NumTooBig
TranslateLowRegImm:
        CMP     BL,Num8
        JA      TranslateRegImmNumTooBig2
        MOV     BYTE ES:[DI],40h
        INC     DI
        DEC AL
        STOSW
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
TranslateLMR8Imm:
        CMP     BL,Num8
        JA      TranslateRegImmNumTooBig2
        MOV     BYTE ES:[DI],41h
        INC     DI
        DEC AL
        STOSW
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
TranslateLMR16Imm:
        CMP     BL,Num16
        JA      TranslateRegImmNumTooBig2
        MOV     WORD ES:[DI],6641h
        INC     DI
        STOSW
        CALL    Write16Imm
        JMP     AssembleDone
TranslateLMR32Imm:
        CMP     BL,Num32
        JA      TranslateRegImmNumTooBig2
        MOV     BYTE ES:[DI],41h
        INC     DI
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone
TranslateLMR64Imm:
        CMP     BL,Num32
        JA      TranslateRegImmNumTooBig2
        MOV     BYTE ES:[DI],49h
        INC     DI
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone

EVEN 2
GetOperandSize:        
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      GetOperandSize2
        RET
GetOperandSize2:
        MOV     AH,BYTE [SymOpSize]
        TEST    AH,AH
        JNZ     GetOperandSizeDone
GetOperandSize3:
        MOV     AH,_WORD
        CMP     BYTE [AddrMode],2
        JB      GetOperandSizeDone
        MOV     AH,_QWORD
        JA      GetOperandSizeDone
        MOV     AH,_DWORD
GetOperandSizeDone:
        RET

NumToEA:
        MOV     AL,BYTE [AddrMode]
        MOV     SI,OFFSET OWordNum
        MOV     DI,OFFSET EADisp
        MOV     AH,0
        MOVSW
        MOVSW
        MOVSW
        MOVSW        
        MOV     BL,4 ;32&64 bit addr mode disp SIZE       
        SHR     AL,1 ;Only addr 16=1 so IF addr16 then CF=1
        ADC     AH,AH ;AH=CF
        SUB     BL,AH ;BL=BL-CF  ;IF mode=16 then 2 is subtracted
        SUB     BL,AH ;BL=BL-CF
        ADD     AH,5
        MOV     BYTE [ModRM],AH
        MOV     BYTE [EADispSize],BL
        XOR     AX,AX
        MOV     WORD [SIBDisp],AX
        MOV     BYTE [RemainBytes],AL
        DEC     AX
        CMP     BYTE [AddrMode],4
        ADC     AL,0
        AND     AL,80h
        OR      [EARegType],AL
        RET

BBadReloc2:
        MOV BYTE [Error],128
        JMP BBadRelo
BBadReloc:
        MOV BYTE [Error],130
BBadRelo:
        PUSH    ES,SI,DI
        MOV SI,OFFSET _BadReloc
        CALL    PrintError
        POP DI,SI,ES
        RET

Write64Reloc:
        OR  BYTE [RelocFlags],8
        MOV     BL,[OutFormat]
        CMP     BL,OutMZ
        JZ      Write64MZReloc
        CMP     BL,OutOMF16
        JZ      Write64OMF16Reloc
        CMP     BL,OutOMF32
        JZ      Write64OMF32Reloc
        CMP     BL,OutNE16
        JZ      Write64NE16Reloc

        CMP     BL,OutPE32
        JZ      Write64PE32Reloc
        CMP     BL,OutPE64
        JZ      Write64PE64Reloc

        CMP     BL,OutCOFF32
        JZ      Write64COFF32Reloc
        CMP     BL,OutCOFF64
        JZ      Write64COFF64Reloc

        RET

Write64MZReloc:
        JMP     MZReloc

Write64PE32Reloc:
        JMP     PE32Reloc

Write64PE64Reloc:
        JMP     PE64Reloc

Write64COFF32Reloc:
        JMP     COFF32Reloc

Write64COFF64Reloc:
        JMP     COFF64Reloc

Write64NE16Reloc:
        JMP     NE16Reloc

Write64OMF16Reloc:
        JMP     OMFReloc

Write64OMF32Reloc:
        JMP     OMFReloc

Write32Reloc:
        OR  BYTE [RelocFlags],8
        MOV     BL,[OutFormat]
        CMP     BL,OutMZ
        JZ      Write32MZReloc
        CMP     BL,OutOMF16
        JZ      Write32OMF16Reloc
        CMP     BL,OutOMF32
        JZ      Write32OMF32Reloc
        CMP     BL,OutNE16
        JZ      Write32NE16Reloc

        CMP     BL,OutPE32
        JZ      Write32PE32Reloc
        CMP     BL,OutPE64
        JZ      Write32PE64Reloc

        CMP     BL,OutCOFF32
        JZ      Write32COFF32Reloc

        CMP     BL,OutCOFF64
        JZ      Write32COFF64Reloc
        RET

Write32PE32Reloc:
        JMP     PE32Reloc

Write32PE64Reloc:
        JMP     PE64Reloc

Write32COFF32Reloc:
        JMP     COFF32Reloc

Write32COFF64Reloc:
        JMP     COFF64Reloc

Write32NE16Reloc:
        JMP     NE16Reloc

Write32MZReloc:
        JMP     MZReloc

Write32OMF16Reloc:
        JMP     OMFReloc

Write32OMF32Reloc:
        JMP     OMFReloc

Write16NE16Reloc:
        JMP     NE16Reloc
Write16MZReloc:
        JMP     MZReloc
Write16OMF16Reloc:
        JMP     OMFReloc

Write16Reloc:
        MOV     BL,[OutFormat]
        CMP     BL,OutMZ
        JZ      Write16MZReloc
        CMP     BL,OutOMF16
        JZ      Write16OMF16Reloc
        CMP     BL,OutOMF32
        JZ      Write16OMF32Reloc
        CMP     BL,OutNE16
        JZ      Write16NE16Reloc

        CMP     BL,OutPE32
        JZ      Write16PE32Reloc

        CMP     BL,OutPE64
        JZ      Write16PE64Reloc

        CMP     BL,OutCOFF32
        JZ      Write16COFF32Reloc

        CMP     BL,OutCOFF64
        JZ      Write16COFF64Reloc
        RET

Write16PE32Reloc:
        CALL    BBadReloc2
        JMP     PE32Reloc

Write16PE64Reloc:
        CALL    BBadReloc2
        JMP     PE64Reloc

Write16COFF32Reloc:
        CALL    BBadReloc2
        JMP     COFF32Reloc

Write16COFF64Reloc:
        CALL    BBadReloc2
        JMP     COFF64Reloc

Write16OMF32Reloc:
        CALL    BBadReloc2
        JMP     OMFReloc

Write16Relo22:
        JMP     Write16Relo2

WriteEADataReloc16	PROC
        MOV     SI,OFFSET EADisp
        CALL    Write16Reloc
        MOVSW
        POP     CX
        TEST    BYTE [RelocFlags2],1
        JNZ     Write16Relo22
        RET
WriteEADataReloc16	ENDP

WriteEADataReloc32	PROC
        MOV     SI,(EADisp)
        CALL    Write32Reloc
        MOVSW
        MOVSW
        POP     CX
        TEST    BYTE [RelocFlags2],1
        JNZ     Write16Relo22
        RET
WriteEADispTooLarge:
        JMP NumTooBig
WriteEADataReloc32	ENDP

EVEN 2
WriteEAData	PROC
        MOV     AL,BYTE [ModRM]
        STOSB
        MOV     AL,BYTE [SIB]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [SIBDisp]
WriteEAData2:
        MOV     AL,[EADispSize]
        CMP     AL,0
        JZ      WriteEADone
        CMP     AL,8
        JZ      WriteEADispTooLarge
WriteEADataDispOK:
        PUSH    CX
        TEST    BYTE [EARegType],80h
        JNZ     WriteEADataDisp64
        MOV     CL,BYTE [EADispSize]
WriteEADataDispOK2:
        MOV     AL,[RelocFlags]
        AND     AL,3
        CMP     AL,3
        JZ      WriteEADataReloc
        MOV     CH,0
        MOV     SI,OFFSET EADisp
        REP     MOVSB
        POP     CX
WriteEADone:
        RET
WriteEADataDisp64:
        JMP     WriteEADataDisp642
WriteEADataReloc:
        CMP     CL,1
        JZ      WriteEADataRelocDone
        CMP     CL,2
        JZ      WriteEADataReloc16
        CMP     CL,4
        JZ      WriteEADataReloc32
WriteEADataRelocDone:
        MOV     CH,0
        MOV     CL,BYTE [EADispSize]
        MOV     SI,OFFSET EADisp
        REP     MOVSB
        POP     CX
        RET
WriteEAData		ENDP

EVEN 2
Write16Imm:
        TEST    BYTE [RelocFlags],1
        JNZ     Write16Relo
        MOV     AX,CX
        STOSW
        RET

Write16Relo:
        MOV SI,OFFSET OWordNum
        CALL    Write16Reloc
        MOVSW
        TEST    BYTE [RelocFlags2],1
        JNZ     Write16Relo2
        RET

Write16Relo2:
        PUSH    DI,ES
        PUSH    DS
        POP     ES
        MOV     SI,OFFSET RelocFlags2
        MOV     DI,OFFSET RelocFlags
        MOVSW
        MOVSW
        MOVSW
        MOV     WORD [RelocFlags2],0
        POP     ES,DI
        RET

EVEN 2
Write16Imm2:
        TEST    BYTE [RelocFlags],1
        JNZ     Write16Relo
        MOV     AX,DX
        STOSW
        RET
EVEN 2
Write32Relo:
        MOV     SI,OFFSET OWordNum
        CALL    Write32Reloc
        MOVSW
        MOVSW
        TEST    BYTE [RelocFlags2],1
        JNZ     Write16Relo2
        RET
EVEN 2
Write32Imm:
        TEST    BYTE [RelocFlags],1
        JNZ     Write32Relo
        MOV     SI,OFFSET OWordNum
        MOVSW
        MOVSW
        RET

Write64Relo:
        MOV     SI,OFFSET OWordNum
        CALL    Write64Reloc
        MOVSW
        MOVSW
        MOVSW
        MOVSW
        TEST    BYTE [RelocFlags2],1
        JNZ     Write16Relo2
        RET
EVEN 2
Write64Imm:
        TEST    BYTE [RelocFlags],1
        JNZ     Write64Relo
        MOV     SI,OFFSET OWordNum
        MOVSW
        MOVSW
        MOVSW
        MOVSW
        RET

WriteEADataDisp642:

        PUSH    AX,BX,DX,SI
        LEA     SI,[DI][4]
        SUB     SI,[OBufferPtr]
        ADD     SI,[RemainBytes]
		
        MOV     AX,[ProgIP]
        MOV     BX,[ProgIP][2]
        MOV     CX,[ProgIP][4]
        MOV     DX,[ProgIP][6]

        ADD     AX,SI
        ADC     BX,0
        ADC     CX,0
        ADC     DX,0

        MOV     SI,OFFSET EADisp
        SUB     [SI],AX
        SBB     [SI][2],BX
        SBB     [SI][4],CX
        SBB     [SI][6],DX
        AND     BYTE [RelocFlags],NOT 1
        XOR     BX,BX
        CMP     [SI][4],BX
        JZ      WriteEADataDisp64Test
        DEC     BX
        CMP     [SI][4],BX
        JNZ     WriteEADataDispTooBig
;        TEST    BYTE [SI][6],80h
;        JZ      WriteEADataDispTooBig
WriteEADataDisp64Test:
        CMP     [SI][6],BX
        JNZ     WriteEADataDispTooBig
        POP     SI,DX,BX,AX
        MOV     CL,4
        JMP     WriteEADataDispOK2
WriteEADataDispTooBig:
        JMP     NumTooBig

CreateNewFile	PROC
        MOV     SI,OFFSET Files
        MOV     AX,DS
        MOV     ES,AX
        MOV     CX,WORD [FileLen]
        MOV     BX,CX
        MOV     DI,SI
        MOV     AL,"."
        REPNZ   SCASB
        JNZ     CreateNewFileExtOK
        INC     CX
CreateNewFileExtOK:
        MOV     DI,OFFSET NewFile
        MOV     DX,DI
        SUB     BX,CX
        MOV     CX,BX
        REP     MOVSB
        MOV     AX,"t."
        STOSW
        MOV     AX,"pm"
        STOSW
        CALL    FCreate
        JC      CreateNewFileError
        MOV     WORD [NewHandle],AX
        MOV     BX,AX
        RET
CreateNewFileError:
        MOV     SI,OFFSET _TempFileError
        JMP     PrtError2
CreateNewFile	ENDP

CreateAnotherFile	PROC
        MOV     SI,OFFSET Files
        MOV     AX,DS
        MOV     ES,AX
        MOV     CX,WORD [FileLen]
        MOV     BX,CX
        MOV     DI,SI
        MOV     AL,"."
        REPNZ   SCASB
        JNZ     CreateAnotherFileExtOK
        INC     CX
CreateAnotherFileExtOK:
        MOV     DI,OFFSET AnotherFile
        MOV     DX,DI
        SUB     BX,CX
        MOV     CX,BX
        REP     MOVSB
        MOV     AX,"t."
        STOSW
        MOV     AX,"~m"
        STOSW
        CALL    FCreate
        JC      CreateAnotherFileError
        MOV     BX,AX
        RET
CreateAnotherFileError:
        MOV     SI,OFFSET _TempFileError
        JMP     PrtError2
CreateAnotherFile	ENDP



EnterReference:
        RET
ResolveReferences:        
        RET
EVEN 2
WriteRegOverride:
        CMP     DL,LMReg8
        JZ      WriteRegLMR8
        CMP     DL,LMReg16
        JZ      WriteRegLMR16
        CMP     DL,LMReg32
        JZ      WriteRegLMR32
        CMP     DL,LMReg64
        JZ      WriteRegLMR64
        CMP     DL,LMLowReg
        JNZ     WriteRegInvalidOperand
        MOV     AL,40h
        STOSB
        DEC     AH
        RET
WriteRegLMR8:
        MOV     AL,41h
        STOSB
        DEC     AH
        RET
WriteRegLMR16:
        MOV     AL,66h
        STOSB
        MOV     AL,41h
        STOSB
        RET
WriteRegLMR32:
        MOV     AL,41h
        STOSB
        RET
WriteRegLMR64:
        MOV     AL,49h
        STOSB
        RET
WriteRegInvalidOperand:
        JMP     InvalidOperand
EVEN 2
ResetAsmData:        
        MOV     AX,AsmData
        MOV     DS,AX
        XOR     AX,AX
        MOV     BYTE [CurOp],AL
        MOV     BYTE [Process],AL
        MOV     BYTE [SegOverride],AL
        MOV     WORD [RelocFlags],0
        MOV     WORD [ExprStack],OFFSET ExprBuffer
        MOV     WORD [StrFree],StrBuffer+64
        RET

EVEN 2
TranslateMemRegExt:
        MOV     DX,CX
TranslateRegMemExt:
        CALL    WriteOverrides
        MOV     AL,BYTE [REXOverride]
        ADD     DH,DH
        ADD     DH,DH
        ADD     DH,DH
        OR      BYTE [ModRM],DH
        CMP     DL,Reg8
        JZ      TranslateRegMem8Ext
        CMP     DL,Reg16
        JZ      TranslateRegMem16Ext
        CMP     DL,Reg32
        JZ      TranslateRegMem32Ext
        MOV     BYTE [REXDisp],1
        CMP     DL,Reg64
        JZ      TranslateRegMem64Ext
        OR      AL,40h
        CMP     DL,LMLowReg
        JZ      TranslateRegMem8Ext
        OR      AL,4
        CMP     DL,LMReg8
        JZ      TranslateRegMem8Ext
        CMP     DL,LMReg16
        JZ      TranslateRegMem16Ext2
        CMP     DL,LMReg32
        JZ      TranslateRegMem32Ext2
        CMP     DL,LMReg64
        JZ      TranslateRegMem64Ext
TranslateMemInvalidOp:
        CMP     CX,DX
        JZ      TranslateMemInvalidOp2
        JMP     InvalidOperand1
TranslateMemInvalidOp2:
        JMP     InvalidOperand2
TranslateRegMem8Ext:
        TEST    BP,BP
        JZ      TranslateMemInvalidOp
        ADD     SI,2
        CALL    CheckOpSize8
        JMP     TranslateRegMem32ExtWrite
TranslateRegMem16Ext:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
TranslateRegMem16Ext2:
        CALL    CheckOpSize16
        JMP     TranslateRegMem32ExtWrite
TranslateRegMem32Ext:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
TranslateRegMem32Ext2:
        CALL    CheckOpSize32
TranslateRegMem32ExtWrite:
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOVSW
        CALL    WriteEAData
        JMP     AssembleDone
TranslateRegMem64Ext:
        CALL    CheckOpSize64
        OR      AL,48h
        JMP     TranslateRegMem32ExtWrite
TranslateMemInvalidAddr:
        JMP     InvalidAddrMode

TranslateR8InvalidComb2:
        JMP     CombinationNotAllowed
TranslateR8LMRExt:
        TEST    DH,32
        JNZ     TranslateR8InvalidComb2
TranslateRLMRExt:
        STOSB
TranslateRegStoreExt:
        MOVSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
TranslateR8Ext:
        TEST    BP,BP
        JZ      TranslateR8InvalidComb2
        ADD     SI,2
        CMP     CL,Reg8
        JZ      TranslateRegStoreExt
        MOV     AL,41h
        CMP     CL,LMReg8
        JZ      TranslateRLMRExt
        MOV     AL,40h
        CMP     CL,LMLowReg
        JZ      TranslateRLMRExt
        JMP     InvalidOperand2
TranslateR64Ext:
        MOV     AL,48h
        CMP     CL,Reg64
        JZ      TranslateRLMRExt
        MOV     AL,49h
        CMP     CL,LMReg64
        JZ      TranslateRLMRExt
        JMP     InvalidOperand2
EVEN 2
TranslateRegRegExt:
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      DH,CH
        OR      DH,0C0h
        CMP     DL,Reg8
        JZ      TranslateR8Ext
        CMP     DL,Reg16
        JZ      TranslateR16Ext
        CMP     DL,Reg32
        JZ      TranslateR32Ext
        CMP     DL,Reg64
        JZ      TranslateR64Ext
        JMP     TranslateRegRegExt2
TranslateR16Ext:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        CMP     CL,Reg16
        JZ      TranslateRegStoreExt2
        MOV     AL,41h
        CMP     CL,LMReg16
        JZ      TranslateRLMRExt2
        JMP     InvalidOperand2
TranslateR32Ext:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        CMP     CL,Reg32
        JZ      TranslateRegStoreExt2
        MOV     AL,41h
        CMP     CL,LMReg32
        JZ      TranslateRLMRExt2
        JMP     InvalidOperand2
TranslateRLMRExt2:
        STOSB
TranslateRegStoreExt2:
        MOVSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone

TranslateLMR8InvalidComb3:
        JMP     CombinationNotAllowed
TranslateLMR8Ext:
        CMP     CH,4
        JAE     TranslateLMR8InvalidComb3
TranslateLMStoreExt3:
        STOSB
        MOVSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
TranslateLMReg8Ext:
        TEST    BP,BP
        JZ      TranslateLMR8InvalidComb3
        ADD     SI,2
        MOV     AL,44h
        CMP     CL,Reg8
        JZ      TranslateLMR8Ext
        MOV     AL,45h
        CMP     CL,LMReg8
        JZ      TranslateLMStoreExt3
        MOV     AL,44h
        CMP     CL,LMLowReg
        JZ      TranslateLMStoreExt3
        JMP     InvalidOperand2
TranslateLowRegExt:
        TEST    BP,BP
        JZ      TranslateLMR8InvalidComb3
        ADD     SI,2
        MOV     AL,40h
        CMP     CL,Reg8
        JZ      TranslateLMR8Ext
        MOV     AL,41h
        CMP     CL,LMReg8
        JZ      TranslateLMStoreExt3
        MOV     AL,40h
        CMP     CL,LMLowReg
        JZ      TranslateLMStoreExt3
        JMP     InvalidOperand2
EVEN 2
TranslateRegRegExt2:
        CMP     DL,LMReg8
        JZ      TranslateLMR8Ext
        CMP     DL,LMReg16
        JZ      TranslateLMR16Ext
        CMP     DL,LMReg32
        JZ      TranslateLMR32Ext
        CMP     DL,LMReg64
        JZ      TranslateLMR64Ext
        CMP     DL,LMLowReg
        JZ      TranslateLowRegExt
        JMP     InvalidOperand1
TranslateLMR16Ext:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,44h
        CMP     CL,Reg16
        JZ      TranslateLMStoreExt4
        MOV     AL,45h
        CMP     CL,LMReg16
        JZ      TranslateLMStoreExt4
        JMP     InvalidOperand2
TranslateLMR32Ext:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,44h
        CMP     CL,Reg32
        JZ      TranslateLMStoreExt4
        MOV     AL,45h
        CMP     CL,LMReg32
        JZ      TranslateLMStoreExt4
        JMP     InvalidOperand2
TranslateLMR64Ext:
        MOV     AL,4Ch
        CMP     CL,Reg64
        JZ      TranslateLMStoreExt4
        MOV     AL,4Dh
        CMP     CL,LMReg64
        JZ      TranslateLMStoreExt4
        JMP     InvalidOperand2
TranslateLMStoreExt4:
        STOSB
        MOVSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone

ResetAllData:
        PUSH    DS
        POP     ES
        MOV     SI,OFFSET SymbolSeg+2
ResetAllDataFreeMem:
        XOR     AX,AX
        XCHG    AX,WORD [SI]
        TEST    AX,AX
        JZ      ResetAllDataFreeMemOK
        ADD     SI,2
        MOV     ES,AX
        CALL    FreeMem
        JMP     ResetAllDataFreeMem
ResetAllDataFreeMemOK:
        PUSH    DS
        POP ES
        MOV     DI,OFFSET NumSymbol
        MOV     CX,9
        REP     STOSW
        MOV     DI,OFFSET ProgIP
        MOV     CL,4
        REP     STOSW
        MOV     DI,OFFSET MiscFmt
        MOV     CX,5120/2
        REP     STOSW

		MOV	BYTE [externStub],AL
		MOV	BYTE [externFileName],AL
        MOV     [FileSize],AX
        MOV     [FileSize][2],AX
        MOV     [LastProgSize],AX
        MOV     [LastProgSize][2],AX
        MOV     [Settings],AX
        MOV     [NumSegs],AX
        MOV     [SymNextSpace],AX
        MOV     [OutFlags],AX
        AND     WORD [ProcFlags],300h
        OR      AL,24
        AND     [RefFlags],AX
        MOV     AX,[SymbolSeg]
        MOV     [FreeSymSeg],AX
        MOV     AX,[FirstMaxSymbols]
        MOV     [SymMaxSymbols],AX
        RET

SegmentAlign:
        MOV     AX,[OBufferPTR]
        SUB     AX,[DiskOutStart]
        XOR     DX,DX

        ADD     AX,[FileSize]
        ADC     DX,[FileSize][2]

        ADD     AX,[UninitData]
        ADC     DX,[UninitData][2]

        MOV     BX,[SegAlignment]
        CALL    Div32
        TEST    SI,SI
        JZ      SegmentAlignDone
        SUB     BX,SI
        MOV     CX,BX
        CALL    ReserveData16

;        MOV     DL,0
;        LES     DI,DWORD [OBufferPtr]
;        CALL    WriteMultiBytes
;        MOV     WORD [OBufferPtr],DI
;        CALL    UpdateProgIP
SegmentAlignDone:
        RET

PaddBytes   PROC
    TEST    CX,CX
    JZ      PaddBytesDone
    PUSH    BX,DX,DI
    PUSH    ES
    MOV     DL,0
    MOV     DI,[OBufferPtr]
    XOR BX,BX
    CALL    WriteMultiBytes
    MOV     WORD [OBufferPtr],DI
    CALL    UpdateProgIP
    POP ES
    POP DI,DX,BX
 PaddBytesDone:
    RET
PaddBytes   ENDP

WriteUninitLowWordZero:
        MOV CX,-1
        CMP     WORD [SI][2],0
        JNZ     WriteUninitData3
        RET
WriteUninitError:
        JMP     UninitSeg

WriteUninitData:

		PUSH	AX,BX,CX,DX,SI
        MOV     SI,OFFSET UninitData
        MOV     CX,WORD [SI]
        MOV     BX,WORD [SI][2]

        AND     BYTE [RefFlags],NOT 80h

        TEST    BX,BX
        JNZ WriteUninitData1

        TEST    CX,CX
        JZ  WriteUninitDataDone

WriteUninitData1:

        CMP     BYTE [CurSeg],0FEh
        JZ      WriteUninitError

        MOV     AL,BYTE [CurSeg][3]
        MOV     BYTE [CurSeg],AL
        AND     WORD [UninitData][2],0FFh

WriteUninitData3:
        SUB     WORD [SI],CX
        SBB     WORD [SI][2],BX

        MOV     DX,90h
        CMP     BYTE [CurSeg], (SEGMENT_CODE + 1)
        SBB     DH,0    ;IF curseg is 1(code) DH=FF otherwise its zero
        AND     DL,DH

        PUSH    WORD [ProgIP]		;Prog IP has already been adjusted
        PUSH    WORD [ProgIP][2]
        PUSH    WORD [ProgIP][4]
        PUSH    WORD [ProgIP][6]
        CALL    WriteMultiBytes
        MOV     WORD [OBufferPtr],DI
        POP WORD [ProgIP][6]
        POP WORD [ProgIP][4]
        POP WORD [ProgIP][2]
        POP WORD [ProgIP]

 WriteUninitDataDone:


		POP	SI,DX,CX,BX,AX
        RET
ReserveWord:
        MOV     CX,2
        JMP     ReserveData16
ReserveDWord:
        MOV     CX,4
        JMP     ReserveData16
ReserveFWord:
        MOV     CX,6
        JMP     ReserveData16
ReserveQWord:
        MOV     CX,8
        JMP     ReserveData16
ReserveTWord:
        MOV     CX,10
        JMP     ReserveData16
ReserveOWord:
        MOV     CX,16
        JMP     ReserveData16
ReserveByte:
        MOV     CX,1

ReserveData16:
        XOR     BX,BX

ReserveData:
        PUSHAD
        CALL    ReserveDataX
        POPAD
        RET

ReserveDataX:
        MOV DX,BX
ReserveData2:
        TEST    BYTE [RefFlags],80h
        JZ      ReserveDataRegisterUnint
ReserveData3:
        ADD     WORD [UninitData],CX
        ADC     WORD [UninitData][2],DX
        JC      ReserveDataEIPOverflow
ReserveData4:
        ADD     WORD [ProgIP],CX
        ADC     WORD [ProgIP][2],DX
        JC      ReserveDataUpdateRIP
        JZ      ReserveData5

        CMP     BYTE [AddrMode],1
        JZ      ReserveDataEIPOverflow
 ReserveData5:
        RET
ReserveDataRegisterUnint:

        TEST    BYTE [InBlock],10   ;IF its XStruct OR STRUC just advance RIP
        JNZ     ReserveData4
        OR      BYTE [RefFlags],80h
        MOV     AL,0FFh
        XCHG    AL,BYTE [CurSeg]
        MOV     BYTE [CurSeg][3],AL
        JMP     ReserveData3
ReserveDataUpdateRIP:
        CMP     BYTE [AddrMode],2
        JZ      ReserveDataEIPOverflow
        ADD     WORD [ProgIP][4],1
        ADC     WORD [ProgIP][6],0
        JC      ReserveDataEIPOverflow
ReserveDataEIPOK:
        RET
ReserveDataEIPOverflow:
        MOV     AL,BYTE [AsmFlags]
        AND     AL,3
        CMP     AL,3
        JZ      ReserveDataEIPOK
        JMP     ProgIPOverflow

WriteStrUninit:
        PUSH    CX,SI
        CALL    WriteUninitData
        POP     SI,CX
        REP MOVSB
        RET

WriteStrChain:
        TEST    BYTE [RefFlags],80h
        JNZ     WriteStrUninit
WriteStrChain1:
        MOV     BX,0FFFAh
        SUB     BX,DI
        CMP     CX,BX
        JAE     WriteStrChain2
        MOV     BX,CX
WriteStrChain2:
        SUB     CX,BX
        PUSH    CX
        MOV     CX,BX
        REP     MOVSB
        POP     CX
        CMP     DI,0FFFAh-2
        JAE     WriteStrChainOut
        RET
WriteStrChainOut:
        PUSH    SI,CX,DS
        MOV     AX,AsmData
        MOV     DS,AX
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        POP     DS,CX,SI
        JMP     WriteStrChain1

WriteUnicodeStrUninit:
        PUSH    CX,SI
        CALL    WriteUninitData
        POP     SI,CX
WriteUnicodeStrChain:
        TEST    BYTE [RefFlags],80h
        JNZ     WriteUnicodeStrUninit
WriteUnicodeStrChain1:
        MOV     BX,0FFFAh
        SUB     BX,DI
        SHR BX,1    ;Divide by 2. Shrink available space, each unicode contains 2 bytes
        CMP     CX,BX
        JAE     WriteUnicodeStrChain2
        MOV     BX,CX
WriteUnicodeStrChain2:
        SUB     CX,BX
        PUSH    CX
        MOV     CX,BX
  WriteUnicodeStrChainLoop:
        MOVSB
        MOV AL,0
        STOSB
        DEC CX
        JNZ WriteUnicodeStrChainLoop

        POP     CX
        CMP     DI,0FFFAh-2
        JAE     WriteUnicodeStrChainOut
        RET
WriteUnicodeStrChainOut:
        PUSH    SI,CX,DS
        MOV     AX,AsmData
        MOV     DS,AX
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        POP     DS,CX,SI
        JMP     WriteUnicodeStrChain1

MarkInitPos:
        MOV     AX,WORD [BytesReadBak]
        MOV     DX,WORD [BytesReadBak][2]
        MOV     CX,WORD [InBufferPtr]
        ADD     AX,CX
        ADC     DX,0
        MOV     WORD [InitFilePos],AX
        MOV     WORD [InitFilePos][2],DX
        MOV     AX,WORD [LineNumber]
        MOV     WORD [InitLineNumber],AX
        MOV     AX,WORD [LineNumber][2]
        MOV     WORD [InitLineNumber][2],AX
        MOV     AX,WORD [IfBlockCnt]
        MOV     WORD [InitIfBlockCnt],AX
        MOV     AX,WORD [IfBlockCnt][2]
        MOV     WORD [InitIfBlockCnt][2],AX
        RET

PrtErrorRet:
        CALL    PrintError
        CALL    ResetAsmData
        CMP     BYTE [EOLFlag],EndOfLine
        JZ      PrtErrorRetDone
        LDS     SI,DWORD [InBufferPtr]
        CALL    GetNextFindNextLine
PrtErrorRetDone:
        ADD     WORD [LineNumber],1
        ADC     WORD [LineNumber][2],0
        RET

AlignAX:
        DEC     BX
        ADD     AX,BX
        ADC     DX,0
        NOT     BX
        AND     AX,BX
        RET

AlignCX:
        DEC     BX
        ADD     CX,BX
        ADC     SI,0
        NOT     BX
        AND     CX,BX
        RET
