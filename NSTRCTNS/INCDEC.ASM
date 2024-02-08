IncDecByte:
        MOV     AL,0FEh
        JMP     IncDecMemWrite
IncDecWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     IncDecMemWrite
IncDecDWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
IncDecMemWrite:
        MOV     AH,BYTE [REXOverride]
IncDecMemWrite2:
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        STOSB
        CALL    WriteEAData
        JMP     IncDecCheckNext
IncDecQWord:
        CMP     BYTE [AddrMode],4
        JB      IncDecInvalidAddr
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     IncDecMemWrite
IncDecInvalidAddr:
        JMP     InvalidAddrMode
IncDecMem:
        CALL    WriteOverrides
        CALL    GetOperandSize
        MOV     AL,BYTE [Temp2]
        OR      BYTE [ModRM],AL
        CMP     AH,_BYTE
        JZ      IncDecByte
        MOV     AL,0FFh
        CMP     AH,_WORD
        JZ      IncDecWord
        CMP     AH,_DWORD
        JZ      IncDecDWord
        CMP     AH,_QWORD
        JZ      IncDecQWord
        JMP     InvalidOperandSize
IncDecReg16LM:
        MOV     AL,66h
        STOSW
        MOV     AL,0FFh
        JMP     IncDecEncode16
IncDecReg16LM2:
        MOV     AL,AH
        STOSB
        MOV     AL,0FFh
        JMP     IncDecEncode16
IncDecInstr:
        MOV     AL,BYTE [BX]
        MOV     BYTE [Temp2],AL
        CALL    GetOperand
        LES     DI,[OBufferPtr]
IncDecInstr2:
        CMP     AL,Mem
        JZ      IncDecMem
        CMP     AL,Keyword
        JNZ     IncDecInvalidOp
        CMP     DL,Reg8
        JZ      IncDecReg8
        JB      IncDecInvalidOp
        CMP     DL,Reg32
        JZ      IncDecReg32
        JB      IncDecReg16
        MOV     AH,40h
        CMP     DL,LMLowReg
        JB      IncDecReg64
        JZ      IncDecReg8LM
        OR      AH,1
        CMP     DL,LMReg16
        JZ      IncDecReg16LM
        JB      IncDecReg8LM
        CMP     DL,LMReg64
        JB      IncDecReg16LM2
        JZ      IncDecReg64
IncDecInvalidOp:
        JMP     InvalidOperand
IncDecReg16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,0FFh
        CMP     BYTE [AddrMode],2
        JA      IncDecEncode16
        MOV     AL,BYTE [Temp2]
        ADD     AL,40h
        ADD     AL,DH
        STOSB
IncDecCheckNext:
        CMP     DI,(0FFF0h)
        JA      IncDecWriteOutFile
IncDecCheckNext2:
        XOR     AL,AL
        MOV     BYTE [OperandSize],AL
        MOV     BYTE [CommaFlag],AL
        PUSH    DI
        CALL    GetOperand
        POP     DI
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,EndOfLine
        JNZ     IncDecInstr2
        JMP     AssembleDone
IncDecReg8LM:
        MOV     AL,AH
        STOSB
IncDecReg8:
        MOV     AL,0FEh
IncDecEncode16:
        MOV     AH,BYTE [Temp2]
        OR      AH,0C0h
        OR      AH,DH
        STOSW
        JMP     IncDecCheckNext
IncDecReg32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,0FFh
        CMP     BYTE [AddrMode],2
        JA      IncDecEncode16
        MOV     AL,BYTE [Temp2]
        ADD     AL,40h
        ADD     AL,DH
        STOSB
        JMP     IncDecCheckNext
IncDecReg64:
        OR      AH,48h
        MOV     AL,AH
        STOSB
        MOV     AL,0FFh
        JMP     IncDecEncode16
IncDecWriteOutFile:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     IncDecCheckNext2