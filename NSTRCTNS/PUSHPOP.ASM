PopMem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     PopMemWrite
PopMem32:
        CMP     BYTE [AddrMode],2
        JA      PopInvalidAddrMode
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
PopMemWrite:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,08Fh
        STOSB
        MOV     BP,SI
        CALL    WriteEAData
        MOV     SI,BP
        JMP     PopCheckNext
PopMem64:
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     PopMemWrite
PopMem:
        CALL    WriteOverrides
        CALL    GetOperandSize
        CMP     AH,_WORD
        JZ      PopMem16
        CMP     AH,_DWORD
        JZ      PopMem32
        CMP     AH,_QWORD
        JZ      PopMem64
        JMP     InvalidOperandSize
PopPInstr:
        CALL    GetOperand
        LES     DI,[OBufferPtr]
PopInstr2:
        CMP     AL,Mem
        JZ      PopMem
        CMP     AL,Keyword
        JNZ     PopInvalidOp
        CMP     DL,Reg16
        JZ      PopR16
        CMP     DL,Reg32
        JZ      PopR32
        CMP     DL,Reg64
        JZ      PopR64
        CMP     DL,SegReg386
        JZ      PopSReg386
        CMP     DL,SegReg
        JZ      PopSReg
        CMP     DL,LMReg16
        JZ      PopLMR16
        CMP     DL,LMReg64
        JZ      PopLMR64
PopInvalidOp:
        JMP     InvalidOperand
PopInvalidAddrMode:
        JMP     InvalidAddrMode
PopR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,58h
        ADD     AL,DH
        STOSB
PopCheckNext:
        CMP     DI,(0FFF0h)
        JA      PopWriteOutFile
PopCheckNext2:
        XOR     AL,AL
        MOV     BYTE [CommaFlag],AL
        MOV     BYTE [OperandSize],AL
        PUSH    DI
        CALL    GetOperand
        POP     DI
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,EndOfLine
        JNZ     PopInstr2
        JMP     AssembleDone
PopR32:
        CMP     BYTE [AddrMode],2
        JA      PopInvalidAddrMode
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,58h
        ADD     AL,DH
        STOSB
        JMP     PopCheckNext
PopR64:
        MOV     AL,58h
        ADD     AL,DH
        STOSB
        JMP     PopCheckNext
PopLMR16:
        MOV     AX,4166h
        STOSW
        JMP     PopR64
PopLMR64:
        MOV     AL,49h
        STOSB
        JMP     PopR64
PopSReg386:
        MOV     AL,0Fh
        MOV     AH,DH
        SHL     AH,1
        SHL     AH,1
        SHL     AH,1
        ADD     AH,0A1h
        STOSW
        JMP     PopCheckNext
PopSReg:
        CMP     DH,1
        JZ      PopCS
        MOV     AL,DH
        SHL     AL,1
        SHL     AL,1
        SHL     AL,1
        ADD     AL,7
        STOSB
        JMP     PopCheckNext
PopWriteOutFile:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     PopCheckNext2
PopCS:
        JMP     CSDest
PushNum8:
        CMP     DX,127
        JG      PushNumByAddr
        CMP     DX,-128
        JL      PushNumByAddr
        MOV     AL,6Ah
        MOV     AH,DL
        STOSW
        JMP     PushCheckNext
PushNum16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,68h
        STOSB
        CALL    Write16Imm2
        JMP     PushCheckNext
PushNumInvalidAddrMode:
        JMP     InvalidAddrMode
PushNum32:
        CMP     BL,2
        JA      PushNumInvalidAddrMode
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
PushNumWrite:
        MOV     AL,68h
        STOSB
        CALL    Write32Imm
        JMP     PushCheckNext
PushNumByOpSize:
        CMP     AH,_BYTE
        JZ      PushNum8
        CMP     AH,_WORD
        JZ      PushNum16
        CMP     AH,_DWORD
        JZ      PushNum32
        CMP     AH,_QWORD
        JZ      PushNumWrite
        JMP     InvalidOperandSize
PushNumber:
        MOV     BL,BYTE [AddrMode]
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JNZ     PushNumByOpSize
        MOV     AH,BYTE [EAMask]
        AND     AH,[Settings]
        TEST    AH,1
        JNZ     PushNumberSymbol
        CMP     AL,Num8
        JZ      PushNum8
PushNumByAddr:
        CMP BL,2
        JZ  PushNum32
        JB  PushNum16
        JMP PushNumWrite
PushNumberSymbol:
        CMP     BL,2
        JZ      PushNum32
        JA      PushNumWrite
        JMP     PushNum16
PushMem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     PushMemWrite
PushMem32:
        CMP     BL,2
        JA      PushInvalidAddrMode
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
PushMemWrite:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,0FFh
        STOSB
        MOV     BP,SI
        CALL    WriteEAData
        MOV     SI,BP
        JMP     PushCheckNext
PushMem64:
        CMP     BL,4
        JB      PushInvalidAddrMode
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     PushMemWrite

PushMem:
        AND     BYTE [Settings],NOT 0E0h
        CALL    WriteOverrides
        CALL    GetOperandSize
        OR      BYTE [ModRM],48
        CMP     AH,_WORD
        JZ      PushMem16
        CMP     AH,_DWORD
        JZ      PushMem32
        CMP     AH,_QWORD
        JZ      PushMem64
        JMP     InvalidOperandSize
PushNumber1:
        JMP     PushNumber
PushInvalidAddrMode:
        JMP     InvalidAddrMode
PushPInstr:
        CALL    GetOperand
        LES     DI,[OBufferPtr]
PushInstr2:
        MOV     BL,BYTE [AddrMode]
        CMP     AL,Mem
        JZ      PushMem
        CMP     AH,Number
        JZ      PushNumber1
        CMP     AL,Keyword
        JNZ     PushInvalidOp
        CMP     DL,Reg16
        JZ      PushR16
        CMP     DL,Reg32
        JZ      PushR32
        CMP     DL,Reg64
        JZ      PushR64
        CMP     DL,SegReg386
        JZ      PushSReg386
        CMP     DL,SegReg
        JZ      PushSReg
        CMP     DL,LMReg16
        JZ      PushLMR16
        CMP     DL,LMReg64
        JZ      PushLMR64
PushInvalidOp:
        JMP     InvalidOperand
PushR32:
        CMP     BL,4
        JAE     PushInvalidAddrMode
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,50h
        ADD     AL,DH
        STOSB
PushCheckNext:
        CMP     DI,(0FFF0h)
        JA      PushWriteOutFile
PushCheckNext2:
        XOR     AL,AL
        MOV     BYTE [CommaFlag],AL
        MOV     BYTE [OperandSize],AL
        PUSH    DI
        CALL    GetOperand
        POP     DI
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,EndOfLine
        JNZ     PushInstr2
        JMP     AssembleDone
PushR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,50h
        ADD     AL,DH
        STOSB
        JMP     PushCheckNext
PushR64:
        MOV     AL,50h
        ADD     AL,DH
        STOSB
        JMP     PushCheckNext
PushLMR16:
        MOV     AX,4166h
        STOSW
        JMP     PushR64
PushLMR64:
        MOV     AL,49h
        STOSB
        JMP     PushR64
PushSReg386:
        MOV     AL,0Fh
        MOV     AH,DH
        SHL     AH,1
        SHL     AH,1
        SHL     AH,1
        ADD     AH,0A0h
        STOSW
        JMP     PushCheckNext
PushSReg:
        MOV     AL,DH
        SHL     AL,1
        SHL     AL,1
        SHL     AL,1
        ADD     AL,6
        STOSB
        JMP     PushCheckNext
PushWriteOutFile:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     PushCheckNext2
