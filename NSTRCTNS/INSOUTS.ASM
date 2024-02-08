
OutSPInstr:
        MOV     BYTE [Temp1],6Fh
        CALL    GetTwoOperands
        XCHG    CX,DX
        XCHG    AX,BX
        MOV     BP,6+1
        JMP     InsPInstr2
InSMemExp:
        JMP     MemOpExpected
InSDXExpected:
        JMP     DXImmExpected
InSESOverride:
        JMP     CantESOverride
InSInvalidAddress:
        JMP     InvalidEAEntry
InSInvalidOpSize:
        JMP     InvalidOperandSize
InSOpSizeReq:
        JMP     OperandSizeRequired
InSInvalidOp:
        JMP     InvalidOperand
InSPInstr:
        CALL    GetTwoOperands
        MOV     BYTE [Temp1],6Dh
        MOV     BP,7+1
        MOV     AH,0
        XCHG    AH,BYTE [SegOverride]
        TEST    AH,AH
        JZ      InSPInstr2
        CMP     AH,26h
        JNZ     InSESOverride
InsPInstr2:
        CMP     AL,Mem
        JNZ     InSMemExp
        CMP     BL,Keyword
        JNZ     InSInvalidOp
        MOV     AX,WORD [BaseReg]
        CMP     AX,BP
        JZ      InSBaseRegOK
        XCHG    AL,AH
        CMP     AX,BP
        JNZ     InsInvalidAddress
InSBaseRegOK:
        CMP     BYTE [EADispSize],0
        JNZ     InSInvalidAddress
        CMP     CX,(2 SHL 8) OR Reg16
        JNZ     InSDXExpected
        LES     DI,DWORD [OBufferPtr]
        XOR     AX,AX
        XCHG    AX,WORD [AddrOverride]
        STOSB   ;ES:[DI]=AL
        CMP     AL,1    ;AL ,1
        SBB     DI,0    ;DI=DI-CF. Subtracts IF below
        MOV     AL,AH
        STOSB
        CMP     AL,1
        SBB     DI,0
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      InSOpSizeReq
        MOV     AL,BYTE [REXOverride]
        CMP     AH,_WORD
        JZ      InSWord
        CMP     AH,_DWORD
        JZ      InSDWord
        CMP     AH,_QWORD
        JZ      InSQWord
        CMP     AH,_BYTE
        JNZ     InSInvalidOpSize
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BYTE [Temp1]
        DEC     AL
        STOSB
        JMP     AssembleDone
InSWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BYTE [Temp1]
        STOSB
        JMP     AssembleDone
InSDWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BYTE [Temp1]
        STOSB
        JMP     AssembleDone
InSQWord:
        OR      AL,48h
        MOV     AH,BYTE [Temp1]
        MOV     WORD ES:[DI],AX
        ADD     DI,2
        JMP     AssembleDone