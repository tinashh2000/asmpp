
PMDescMemRequired:
        JMP     MemOpExpected

PMDescInstr:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,[OBufferPtr]
        CMP     AL,Mem
        JNZ     PMDescMemRequired
        CALL    WriteOverrides
        LODSB
        OR      BYTE [ModRM],AL
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AX,010Fh
        STOSW
        CALL    WriteEAData
        CMP     BYTE [AddrMode],2
        JA      PMDescInstr64
        CALL    CheckOpSize48
        JMP     AssembleDone
PMDescInstr64:
        CALL    CheckOpSize80
        JMP     AssembleDone

PMInstr1:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,[OBufferPtr]
        CMP     AL,Mem
        JZ      PMInstr1Mem
        CMP     AL,Keyword
        JNZ     xLDTRM16Expected
        CMP     DL,Reg16
        JZ      PMInstr1Reg16
        CMP     DL,LMReg16
        JNZ     xLDTRM16Expected
        MOV     AL,41h
        STOSB
PMInstr1Reg16:
        MOVSW
        LODSB
        OR      AL,0C0h
        OR      AL,DH
        STOSB
        JMP     AssembleDone
PMInstr1Mem:
        CALL    CheckOpSize16
        CALL    WriteOverrides
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOVSW
        LODSB
        OR      BYTE [ModRM],AL
        CALL    WriteEAData
        JMP     AssembleDone
xLDTRM16Expected:
        JMP     InvalidOperand
PMInstr2:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,[OBufferPtr]
        CMP     AL,Mem
        JZ      PMInstr2Mem
        CMP     AL,Keyword
        JNZ     xLDTRM16Expected
        CMP     DL,Reg16
        JZ      PMInstr2R16
        CMP     DL,Reg32
        JZ      PMInstr2R32
        CMP     DL,Reg64
        JZ      PMInstr2R64
        CMP     DL,LMReg16
        JZ      PMInstr2LMR16
        CMP     DL,LMReg32
        JZ      PMInstr2LMR32
        CMP     DL,LMReg64
        JZ      PMInstr2LMR64
        JMP     xLDTRM16Expected
xLDTInvalidAddrMode:
        JMP     InvalidAddrMode
PMInstr2LMR16:
        MOV     AL,41h
        STOSB
PMInstr2R16:
        MOVSW
        LODSB
        OR      AL,0C0h        
        OR      AL,DH
        STOSB
        JMP     AssembleDone
PMInstr2LMR32:
        MOV     AX,4166h
        STOSW
        JMP     PMInstr2R16
PMInstr2R32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     PMInstr2R16
PMInstr2R64:
        MOV     AL,48h
        STOSB
        JMP     PMInstr2R16
PMInstr2LMR64:
        MOV     AL,49h
        JMP     PMInstr2R16
PMInstr2Mem:
        CALL    WriteOverrides
        MOV     AH,BYTE [OperandSize]
        TEST    AH,AH
        JZ      PMInstr2Mem16
        CMP     AH,_WORD
        JZ      PMInstr2Mem16
        CMP     AH,_DWORD
        JZ      PMInstr2Mem32
        CMP     AH,_QWORD
        JZ      PMInstr2Mem64
        JMP     InvalidOperandSize
PMInstr2Mem64:
        CMP     BYTE [AddrMode],4
        JNZ     xLDTInvalidAddrMode
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     PMInstr2MemWrite
PMInstr2Mem32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     PMInstr2MemWrite
PMInstr2Mem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
PMInstr2MemWrite:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        MOVSW
        LODSB
        OR      BYTE [ModRM],AL
        CALL    WriteEAData
        JMP     AssembleDone

PMInstr3RegExpected:
        JMP     InvalidOperand1
PMInstr3RegMem:
        JMP     TranslateRegMemExt
PMInstr3:        
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     PMInstr3RegExpected
        XOR     BP,BP
        CMP     BL,Mem
        JZ      PMInstr3RegMem
        CMP     BL,Keyword
        JNZ     PMInstr3InvalidOpS
        JMP     TranslateRegRegExt
PMInstr3InvalidOpS:
        JMP     InvalidOperand2
