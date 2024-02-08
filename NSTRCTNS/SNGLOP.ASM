
SingleOpWriteOutFile:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     SingleOpCheckNext2
SingleOpInvalidOp:
        JMP     InvalidOperand
SingleOpCheckNext:
        CMP     DI,(0FFF0h)
        JA      SingleOpWriteOutFile
SingleOpCheckNext2:
        XOR     AL,AL
        MOV     BYTE [OperandSize],AL
        MOV     BYTE [CommaFlag],AL
;        AND     BYTE [Settings],NOT 0E0h
        PUSH    DI
        CALL    GetOperand
        POP     DI
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,EndOfLine
        JNZ     SingleOpGetOperand
        JMP     AssembleDone
SingleOp:
        MOV     AL,BYTE [BX]
        MOV     BYTE [Temp2],AL
        CALL    GetOperand
        LES     DI,[OBufferPtr]
SingleOpGetOperand:
        CMP     AL,Keyword
        JZ      SingleOpKeyword
        CMP     AL,Mem
        JNZ     SingleOpInvalidOp
        JMP     SingleOpMem
SingleOpKeyword:
        MOV     AH,BYTE [Temp2]
        OR      AH,0C0h
        OR      AH,DH
        CMP     DL,Reg8
        JZ      SingleOpReg8
        MOV     AL,0F7h
        CMP     DL,Reg16
        JZ      SingleOpReg16
        CMP     DL,Reg32
        JZ      SingleOpReg32
        CMP     DL,Reg64
        JZ      SingleOpReg64
        MOV     CX,AX
        MOV     AH,0
        CALL    WriteRegOverride
        CMP     AH,0FFh
        MOV     AX,CX
        JZ      SingleOpReg8
        JMP     SingleOpReg32Write2
SingleOpReg8:
        MOV     AL,0F6h
        STOSW
        JMP     SingleOpCheckNext
SingleOpReg16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSW
        JMP     SingleOpCheckNext
SingleOpReg32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
SingleOpReg32Write2:
        STOSW
        JMP     SingleOpCheckNext
SingleOpReg64:
        MOV     AL,48h
        STOSB
        MOV     AL,0F7h
        STOSW                        
        JMP     SingleOpCheckNext
SingleOpInvalidAddrMode:
        JMP     InvalidAddrMode
SingleOpMem:
        CALL    WriteOverrides
        MOV     AH,BYTE [Temp2]
        OR      BYTE [ModRM],AH
        CALL    GetOperandSize
        CMP     AH,_WORD
        JB      SingleOpByte
        MOV     BL,0F7h
        JZ      SingleOpWord
        CMP     AH,_DWORD
        JZ      SingleOpDWord
        CMP     AH,_QWORD
        JZ      SingleOpQWord
        JMP     InvalidOperandSize
SingleOpByte:
        MOV     BL,0F6h
        JMP     SingleOpMemWrite
SingleOpWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     SingleOpMemWrite
SingleOpQWord:
        CMP     BYTE [AddrMode],4
        JB      SingleOpInvalidAddrMode
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     SingleOpMemWrite
SingleOpDWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
SingleOpMemWrite:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        STOSB
        MOV     BP,SI
        CALL    WriteEAData
        MOV     SI,BP
        JMP     SingleOpCheckNext