        EVEN 2
ProcessEA:        
        XOR     AX,AX
        MOV     [RemainBytes],AL
        MOV     DI,OFFSET EADisp
        MOV     CX,10
        REP     STOSW
ProcessEAInit2:
        OR      BYTE [Process],2
        MOV     BYTE [NextChar],AL
        JMP     ProcessEALoop

ProcessEASize16:
        TEST    BYTE [EARegType],6
        JNZ ProcessEASizeInvalid
        MOV BYTE [EADispSize],2
        OR  BYTE [EARegType],1
        JMP ProcessEALoop
ProcessEASize32:
        TEST    BYTE [EARegType],5
        JNZ ProcessEASizeInvalid
        MOV BYTE [EADispSize],4
        OR  BYTE [EARegType],2
        JMP ProcessEALoop
ProcessEASize64:
        TEST    BYTE [EARegType],3
        JNZ ProcessEASizeInvalid
        MOV BYTE [EADispSize],8
        JMP ProcessEALoop
ProcessEASizeSpec2:
        TEST    BYTE [EARegType],40h
        JNZ ProcessEASizeInvalid
        OR  BYTE [EARegType],40h
        CMP DH,_WORD
        JZ  ProcessEASize16
        CMP DH,_DWORD
        JZ  ProcessEASize32
        CMP DH,_QWORD
        JZ  ProcessEASize64
ProcessEASizeInvalid:
        JMP InvalidKeyword

ProcessEAOperator2:
        CMP     DH,20
        JBE     ProcessEASpecialOp
        MOV     [CurOp],DH
        JMP     ProcessEALoop
ProcessEASpecialOp:
        CMP     DH,10
        JAE     ProcessEASpecialOpError
        CALL    DoSpecialOperation
        JMP     ProcessEALoop2
ProcessEASpecialOpError:
        JMP     InvalidEAEntry

ProcessSegReg386:
        ADD     DH,64h
        JMP     ProcessSegReg2
ProcessSegReg:
        MOV     CL,3
        SHL     DH,CL
        ADD     DH,26h
ProcessSegReg2:
        MOV     AL,BYTE [NextChar]
        MOV     BYTE [SegOverride],DH        
		CMP     AL,Colon
		JNZ	ProcessSegReg2_1
        INC     WORD [InBufferPtr]
		MOV BYTE [NextChar], 0
ProcessSegReg2_1:
        JMP     ProcessEALoop
ProcessEAKeyword3:
        CMP     DL,LMReg32
        JZ      ProcessEALMReg32
        CMP     DL,LMReg64
        JZ      ProcessEALMReg64
        CMP     DL,SegReg
        JZ      ProcessSegReg
        CMP     DL,SegReg386
        JZ      ProcessSegReg386
        CMP     DL,DataType
        JZ      ProcessEASizeSpec
        JMP     InvalidEAEntry
ProcessEASizeSpec:
        JMP ProcessEASizeSpec2
ProcessEALMReg32:
        MOV     AL,41h
        CMP     BYTE [BaseReg],0
        JZ      ProcessEALMReg322
        MOV     AL,42h
ProcessEALMReg322:
        OR      BYTE [REXOverride],AL
        JMP     ProcessEAReg32
ProcessEALMReg64:
        MOV     AL,41h
        CMP     BYTE [BaseReg],0
        JZ      ProcessEALMReg642
        MOV     AL,42h
ProcessEALMReg642:
        OR      BYTE [REXOverride],AL
        JMP     ProcessEAReg64
ProcessEAMultiBase:
        MOV     SI,OFFSET _MultiR16Base
        JMP     PrtError
ProcessEAMultiIdx:
        MOV     SI,OFFSET _MultiR16Idx
        JMP     PrtError
InvalidEAEntry:
        MOV     SI,OFFSET _InvalidEAEntry
        JMP     PrtError
InvalidEAReg:
        MOV     SI,OFFSET _InvalidEAReg
        JMP     PrtError
ProcessEAReg16StoreBase:
        CMP     BYTE [BaseReg],0
        JNZ     ProcessEAMultiBase
        MOV     BYTE [BaseReg],DH
        JMP     ProcessEALoop
ProcessEAReg16StoreIdx:
        CMP     BYTE [IdxReg],0
        JNZ     ProcessEAMultiIdx
        MOV     BYTE [IdxReg],DH
        JMP     ProcessEALoop
EVEN 2
ProcessEAReg166:
        CMP     BYTE [BX],2
        JA      ProcessEARegNumTooBig
        MOV     BYTE [BX],2
        TEST    BYTE [EARegType],6
        JNZ     ProcessEARegMismatch
        MOV     BYTE [EARegType],1
        INC     DH
        CMP     DH,3+1
        JZ      ProcessEAReg16StoreBase
        CMP     DH,5+1
        JZ      ProcessEAReg16StoreBase
        CMP     DH,6+1
        JZ      ProcessEAReg16StoreIdx
        CMP     DH,7+1
        JZ      ProcessEAReg16StoreIdx
        JMP     InvalidEAReg
ProcessEARegMismatch:
        MOV     SI,OFFSET _EARegMismatch
        JMP     PrtError
ProcessEARegNumTooBig:
        JMP     NumTooBig
EVEN 2
ProcessEAReg32:
        CMP     BYTE [BX],4
        JA      ProcessEARegNumTooBig
        MOV     BYTE [BX],4
        TEST    BYTE [EARegType],5
        JNZ     ProcessEARegMismatch
        MOV     BYTE [EARegType],2
ProcessEAReg32Store:
        INC     DH
        CMP     BYTE [BaseReg],0
        JZ      ProcessEAReg32BaseReg
        CMP     BYTE [IdxReg],0
        JNZ     ProcessEARegOptimize
        MOV     BYTE [IdxReg],DH
        JMP     ProcessEALoop
ProcessEAReg32BaseReg:
        MOV     BYTE [BaseReg],DH
        JMP     ProcessEALoop
ProcessEAReg64:
        TEST    BYTE [EARegType],3
        JNZ     ProcessEARegMismatch
        MOV     BYTE [EARegType],4
        JMP     ProcessEAReg32Store
EVEN 2
ProcessEAKeyword:        
        CMP     DL,Operator
        JZ      ProcessEAOperator
        MOV     SI,OFFSET CurOp
        CMP     BYTE [SI],AddOp
        JZ      ProcessEAKeyword2
        CMP     BYTE [SI],0
        JNZ     ProcessEAInvalidOperator
ProcessEAKeyword2:
        MOV     BYTE [SI],0
        MOV     BX,OFFSET EADispSize
        CMP     DL,Reg16
        JZ      ProcessEAReg16
        CMP     DL,Reg32
        JZ      ProcessEAReg32
        CMP     DL,Reg64
        JZ      ProcessEAReg64
        JMP     ProcessEAKeyword3
ProcessEAReg16:
        JMP     ProcessEAReg166
ProcessEAInvalidOperator:
        MOV     SI,OFFSET _InvalidOperators
        JMP     PrtError
ProcessEARegOptimize:
        MOV     SI,OFFSET _TooManyRegs
        JMP     PrtError
ProcessEAOperator:
        JMP     ProcessEAOperator2

EVEN 2
ProcessEALoop:
        MOV     AL,[NextChar]        
        CMP     AL,Comma
        JZ      ProcessEAComma
        CMP     AL,Colon
        JZ      ProcessEAComma
        CMP     AL,OpenBracket
        JZ      ProcessEAComma
        CMP     AL,CloseBracket
        JZ      ProcessEAComma
        CALL    GetNext
ProcessEALoop2:
        CMP     AL,Keyword
        JZ      ProcessEAKeyword        
        CMP     AH,Number
        JNZ     ProcessEA2
ProcessEANumber:
        MOV     SI,OFFSET OWordNum
        MOV     DI,OFFSET EADisp
        CMP     BYTE [CurOp],MulOp
        JZ      ProcessEAScale
ProcessEACalc:
        MOV     BL,BYTE [EADispSize]
        CMP     BL,0
        JNZ     ProcessEACalcBySize
        CMP     BYTE [AddrMode],2
        JZ      ProcessEA32
        JA      ProcessEA64
ProcessEACalcBySize:
        CMP     AL,Num32
        JAE     ProcessEA32
        CMP     BL,2
        JA      ProcessEA32SizeOK
        CALL    Calc32
        MOV     BYTE [EADispSize],2
        JMP     ProcessEALoop
ProcessEA32:
        CMP     AL,Num32
        JA      ProcessEANumTooBig
        CMP     BL,4
        JA      ProcessEANumTooBig
ProcessEA32SizeOK:
        MOV     BYTE [EADispSize],4
        CALL    Calc32
        JMP     ProcessEALoop
ProcessEA64:
        CMP     AL,Num64
        JA      ProcessEANumTooBig        
        MOV AH,8
        JZ  ProcessEA64NumOK
        CMP BYTE [EADispSize],8
        JZ  ProcessEA64NumOK
        MOV AH,4
ProcessEA64NumOK:
        MOV     BYTE [EADispSize],AH
        CALL    Calc64
        JMP     ProcessEALoop
ProcessEAComma:
        JMP     ProcessEAComma2
EVEN 2
ProcessEA2:
        CMP     AL,CloseSqBracket
        JZ      ProcessEACloseSq
        CALL    CombineOperators
        JC      ProcessEA3
        JMP     ProcessEALoop
EVEN 2
ProcessEAScale:
        CMP     WORD [BaseReg],0
        JZ      ProcessEACalc
        CMP     AL,Num8
        JNZ     ProcessEANumTooBig
        CMP     DL,9
        JA      ProcessEAInvalidScale
        CMP     BYTE [Scale],1
        JA      ProcessEACalc
        MOV     BYTE [CurOp],0
        XOR     AL,AL
        CMP     BYTE [IdxReg],1
        ADC     AL,AL
        MOV     BYTE [ScalePos],AL
        MOV     BYTE [Scale],DL
        JMP     ProcessEALoop
ProcessEAInvalidScale:
        JMP     ProcessEA32InvalidScale
ProcessEANumTooBig:
        JMP     NumTooBig
EVEN 2
ProcessEA3:        
        CMP     AL,EndOfLine
        JZ      ProcessEAEOL
        CMP     AL,OpenBracket
        JZ      ProcessEAExpr
        CMP     AL,OpenSqBracket
        JZ      ProcessEANewShell
        JMP     InvalidEAEntry
ProcessEAExpr:        
        MOV     AL,BYTE [CurOp]
        PUSH    AX
        CALL    ProcessExpression
        AND     BYTE [Process],NOT 1
        POP     AX
        MOV     BYTE [CurOp],AL
        JMP     ProcessEANumber
ProcessEANewShell:
        CMP     BYTE [NeedSq],1
        JZ      ProcessEAMissingCloseSq
        MOV     BYTE [NeedSq],1
        JMP     ProcessEALoop
EVEN 2
ProcessEAOpenNewShell:
        INC     WORD [InBufferPtr]
        JMP     ProcessEALoop
ProcessEAMissingOpenSq:
        MOV     SI,OFFSET _MissingOpenSq
        JMP     PrtError

EVEN 2
ProcessEACloseSq:
        CMP     BYTE [NeedSq],0
        JZ      ProcessEAMissingOpenSq
        CALL    GetNextCharI
        CMP     AL,OpenSqBracket
        JZ      ProcessEAOpenNewShell
        CMP     AL,SemiColon
        JZ      ProcessEAFinalize
        CMP     AL,Comma
        JZ      ProcessEAFinalize
        CMP     AL,EndOfLine
        JZ      ProcessEAFinalize
        MOV     BYTE [NeedSq],0
        JMP     ProcessEALoop
EVEN 2
ProcessEAEOL:
        CMP     BYTE [NeedSq],0
        JZ      ProcessEAFinalize
ProcessEAMissingCloseSq:
        JMP     MissingCloseSq
EVEN 2
ProcessEAComma2:
        CMP     BYTE [NeedSq],0
        JZ      ProcessEAFinalize
MissingCloseSq:
        MOV     SI,OFFSET _MissingCloseSq
        CALL    PrtError
        JMP     PrtError3
EVEN 2
ProcessEADispOnly:
        MOV     AX,Mem
        CMP     BYTE [SI],4
        JZ      ProcessEADisp32
        JA      ProcessEADisp64
        MOV     BYTE [ModRM],06h
        RET
EVEN 2
ProcessEADisp32:
        MOV     BYTE [ModRM],05h
        CMP     CL,2
        JB      ProcessEAPutOverride
        JA      ProcessEADisp64
        RET
EVEN 2
ProcessEAPutOverride:
        MOV     BYTE [AddrOverride],67h
        RET
ProcessEADisp64:
        TEST    BYTE [EARegType],2
        JNZ ProcessEADisp64DW
        OR      BYTE [EARegType],80h
        MOV     BYTE [ModRM],05h
        RET
ProcessEADisp64DW:
        MOV     BYTE [ModRM],4
        MOV     BYTE [SIB],25h
        MOV     BYTE [SIBDisp],1
        RET
ProcessEAFinalizeReg64:
        JMP     ProcessEAFinalizeReg642
EVEN 2
ProcessEAFinalize:        
        MOV     BYTE [NeedSq],0
        AND     BYTE [Process],NOT 2
        OR      BYTE [Settings],20h ;Memory operand is now there
        MOV     BP,WORD [Settings]
        MOV     DI,BP
        AND     BP,WORD [EAMask]
        AND     BYTE [Settings],0FEh
        MOV     CL,BYTE [AddrMode]    
        MOV     DX,WORD [BaseReg]
        MOV     BX,OFFSET EADisp
        MOV     AX,WORD [BX]
        MOV     SI,OFFSET EADispSize
        TEST    DX,DX
        JZ      ProcessEADispOnly
        TEST    DI,1
        JNZ     ProcessEADispOptOK
        TEST    AX,AX
        JNZ     ProcessEADispOptOK
        CMP     BYTE [SI],2
        JBE     ProcessEADispOpt
        CMP     WORD [BX][2],0
        JNZ     ProcessEADispOptOK
        CMP     BYTE [SI],4
        JBE     ProcessEADispOpt
        CMP     WORD [BX][4],0
        JNZ     ProcessEADispOptOK
        CMP     WORD [BX][6],0
        JNZ     ProcessEADispOptOK
ProcessEADispOpt:
        MOV     BYTE [SI],0
ProcessEADispOptOK:
        CMP     BYTE [EARegType],2
        JZ      ProcessEAFinalizeReg32
        JA      ProcessEAFinalizeReg64        
        CMP     CL,2
        JA      ProcessEAInvalidAddrMode
        MOV     CH,67h
        JZ      ProcessEAReg16AddrOK
        MOV     CH,0
ProcessEAReg16AddrOK:        
        MOV     BYTE [AddrOverride],CH
        CMP     BYTE [SI],2
        JA      ProcessEANumTooBig2
        CMP     BYTE [SI],0
        JZ      ProcessEA16Regs
        MOV     BL,80h
        TEST    BP,3
        JNZ     ProcessEA16RegsDispOK
        CMP     AX,-128
        JL      ProcessEA16RegsDispOK
        CMP     AX,127
        JG      ProcessEA16RegsDispOK
ProcessEA16RegsDisp8:
        MOV     BL,40h
        MOV     BYTE [SI],1
ProcessEA16RegsDispOK:
        OR      BYTE [ModRM],BL
ProcessEA16Regs:
        MOV     AX,Mem
        TEST    DL,DL
        JZ      ProcessEA16IdxOnly
        TEST    DH,DH
        JZ      ProcessEA16BaseOnly
        SUB     DL,3+1
        SUB     DH,6+1
        ADD     DL,DH
        OR      BYTE [ModRM],DL
        RET

ProcessEAInvalidAddrMode:
        JMP     InvalidAddrMode
ProcessEANumTooBig2:
        JMP     NumTooBig

ProcessEA16IdxOnly:
        SUB     DH,6-3
        OR      BYTE [ModRM],DH
        RET
ProcessEAFinalizeReg32:
        CMP     CL,2
        JZ      ProcessEA32AddrOK
        MOV     BYTE [AddrOverride],67h
ProcessEA32AddrOK:
        MOV     CL,0    ;Clear CL
        CMP     BYTE [REXOverride],1    ;Is REXOverride=0
        CMC         ;CF=NOT CF. IF it is zero CF=1 so reverse it
        ADC     CL,CL   ;AL=AL+CF+AL
        MOV     BYTE [REXDisp],CL
        DEC     DL
        TEST    DH,DH
        JZ      ProcessEA32OneReg
        JMP     ProcessEA32TwoRegs

ProcessEA16BaseOnly:
        MOV     BL,7
        CMP     DL,5+1
        JNZ     ProcessEA16BaseOnly2
        MOV     BL,6
        CMP     BYTE [SI],0
        JNZ     ProcessEA16BaseOnly2
        MOV     BYTE [SI],1
        MOV     BL,46h
ProcessEA16BaseOnly2:
        OR      BYTE [ModRM],BL
        RET

ProcessEA32RegOpt2:
        DEC     BYTE [Scale]
        MOV     DH,DL
        INC     DH
        JMP     ProcessEA32TwoRegs
ProcessEA32RegOpt1:
        MOV     BYTE [Scale],2
        MOV     DH,DL
        INC     DH
        JMP     ProcessEA32TwoRegs
ProcessEA32ESPOpt:
        MOV     BYTE [SIBDisp],1
        MOV     BYTE [SIB],24h
        MOV     BYTE [ModRM],04h
        XOR     DL,DL
        JMP     ProcessEA32OneRegESPOK
ProcessEA32OneReg:
        CMP     DL,4
        JZ      ProcessEA32ESPOpt
ProcessEA32OneRegESPOK:
        MOV     CL,BYTE [Scale]
        CMP     CL,1
        JBE     ProcessEA32OneReg2
        CMP     BYTE [BaseReg],4+1
        JZ      ProcessEA32ESPError
        CMP     CL,2
        JZ      ProcessEA32RegOpt2
        CMP     CL,3
        JZ      ProcessEA32RegOpt2
        CMP     CL,5
        JZ      ProcessEA32RegOpt2
        CMP     CL,9
        JZ      ProcessEA32RegOpt2
        MOV     CH,85h
        CMP     CL,4
        JZ      ProcessEA32RegScaleOK
        CMP     CL,8
        JNZ     ProcessEA32InvalidScale
        OR      CH,40h
ProcessEA32RegScaleOK:
        MOV     BYTE [SI],4
        OR      BYTE [SIB],CH
        MOV     BYTE [SIBDisp],1
        MOV     BYTE [ModRM],04h
        ADD     DL,DL
        SHL     DL,1
        SHL     DL,1
        OR      BYTE [SIB],DL
        JMP     ProcessEA32Done
ProcessEA32NoDisp:
        CMP     DL,5
        JZ      ProcessEA32EBP
        MOV     AX,Mem
        RET
ProcessEA32EBP:
        MOV     BYTE [SI],1
        OR      BYTE [ModRM],40h
        MOV     AX,Mem
        RET

ProcessEA32InvalidScale:
        MOV     SI,OFFSET _InvalidScale
        JMP     PrtError

ProcessEA32ESPError:
        MOV     SI,OFFSET _EAESPError
        JMP     PrtError

ProcessEA32OneReg2:
        OR      BYTE [ModRM],DL
ProcessEA32CheckDisp2:
        CMP     BYTE [SI],0
        JZ      ProcessEA32NoDisp
ProcessEA32CheckDisp:
        MOV     BYTE [SI],4
        MOV     BL,80h
        MOV     CX,WORD [EADisp][2]
        TEST    CX,CX
        JZ      ProcessEA32DispSizeOK
        INC     CX
        JNZ     ProcessEA32DispOK   ;Must have been FFFF, it must become 0
        CMP     AH,0FFh
        JNZ     ProcessEA32DispOK
ProcessEA32DispSizeOK:
        TEST    BP,3
        JNZ     ProcessEA32DispOK
        CMP     AX,-128
        JL      ProcessEA32DispOK
        CMP     AX,127
        JG      ProcessEA32DispOK
ProcessEA32RegsDisp8:
        MOV     BYTE [SI],1
        MOV     BL,40h
ProcessEA32DispOK:
        OR      BYTE [ModRM],BL
        MOV     AX,Mem
        RET
ProcessEA32Done:
        MOV     AX,Mem
        RET
ProcessEA32XchgReg:
        CALL    SwapEARegs
        JMP ProcessEA32TwoRegs2
ProcessEA32TwoRegs:
        DEC     DH
        MOV     BYTE [ModRM],04h
        MOV     BYTE [SIBDisp],1
        MOV     CL,BYTE [Scale]
        CMP     CL,1
        JA      ProcessEA32TwoRegsScale
        CMP     DH,4
        JZ      ProcessEA32XchgReg
        CMP     DL,5
        JZ      ProcessEA32XchgReg
ProcessEA32TwoRegs2:
        CMP     DH,4
        JZ      ProcessEA32ESPError
        ADD     DH,DH
        SHL     DH,1
        SHL     DH,1
        OR      DH,DL
        MOV     BYTE [SIB],DH
        JMP     ProcessEA32CheckDisp2
ProcessEA32OptScale:
        CALL    SwapEARegs
        JMP     ProcessEA32TwoRegsScale2
ProcessEA32TwoRegsScale:
        CMP     BYTE [ScalePos],1
        JZ      ProcessEA32OptScale
ProcessEA32TwoRegsScale2:
        OR      DL,40h
        CMP     CL,2
        JZ      ProcessEA32TwoRegs2
        OR      DL,80h
        CMP     CL,8
        JZ      ProcessEA32TwoRegs2
        XOR     DL,40h
        CMP     CL,4
        JZ      ProcessEA32TwoRegs2
        JMP     ProcessEA32InvalidScale
ProcessEAFinalizeReg642:
        MOV     BYTE [REXDisp],1
        JMP     ProcessEA32AddrOK

SwapEARegs:
        XCHG    DL,DH
        PUSH    AX
        MOV AL,[RexOverride]
        TEST    AL,AL
        JZ  SwapEARegsDone
        MOV AH,AL
        SHR AH,1
        SHL AL,1
        OR  AL,AH
        AND AL,3
        OR  AL,40h
        MOV BYTE [RexOverride],AL
SwapEARegsDone:
        POP AX        
        RET
