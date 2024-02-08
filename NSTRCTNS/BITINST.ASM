
BitR16Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
BitRegImm2:
        MOV     AX,0BA0Fh
        STOSW
        MOV     AL,BYTE [SI][2]
        OR      AL,DH
        OR      AL,0C0h
        MOV     AH,CL
        STOSW
        JMP     AssembleDone
BitR32Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     BitRegImm2
BitR64Imm:
        MOV     AL,48h
        STOSB
        JMP     BitRegImm2
BitRegImm:
        CMP     BH,Number
        JNZ     BitRegExpected
        CMP     BL,Num8
        JNZ     BitNumTooBig
        CMP     DL,Reg16
        JZ      BitR16Imm
        CMP     DL,Reg32
        JZ      BitR32Imm
        CMP     DL,Reg64
        JZ      BitR64Imm
        MOV     AH,0
        CALL    WriteRegOverride
        CMP     AH,0FFh
        JZ      BitInstrInvalidOp
        JMP     BitRegImm2
BitNumTooBig:
        JMP     NumTooBig
BitRegExpected:
        JMP     InvalidOperand2
BitInstr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        XOR     BP,BP
        CMP     AL,Keyword
        JNZ     BitInstrMem
        CMP     BL,Keyword
        JNZ     BitRegImm
        XCHG    CX,DX
        JMP     TranslateRegRegExt
BitInstrInvalidOp:
        JMP     InvalidOperand1
BitInstrMem:
        CMP     BH,Number
        JZ      BitInstrMemImm
        CMP     BL,Keyword
        JNZ     BitInstrInvalidOp
        JMP     TranslateMemRegExt
BitInstrMemImm:
        CMP     BL,Num8
        JNZ     BitNumTooBig
        CALL    WriteOverrides
        CALL    GetOperandSize
        CMP     AH,_WORD
        JZ      BitMem16Imm
        CMP     AH,_DWORD
        JZ      BitMem32Imm
        CMP     AH,_QWORD
        JZ      BitMem64Imm
        JMP     InvalidOperandSize
BitMem16Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     BitMemImmWrite
BitMem32Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
BitMemImmWrite:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AX,0BA0Fh
        STOSW
        MOV     AL,BYTE [SI][2]
        OR      BYTE [ModRM],AL
        MOV     BYTE [RemainBytes],1
        CALL    WriteEAData
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
BitMem64Imm:
        CMP     BYTE [AddrMode],4
        JB      BitMem64InvalidAddr
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     BitMemImmWrite
BitMem64InvalidAddr:
        JMP     InvalidAddrMode