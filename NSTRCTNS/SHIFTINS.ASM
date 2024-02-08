        
ShiftMem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     ShiftMemx
ShiftMem32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     ShiftMemx
ShiftMem64:
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     ShiftMemx
ShiftMem8:
        MOV     AL,0FFh
ShiftMemx:
        MOV     AH,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        CMP     BL,Keyword
        JZ      ShiftMemCL
        CMP     BH,Number
        JNZ     ShiftInvalidOpS
        CMP     BL,Num8
        JNZ     ShiftNumTooBig
        CMP     CL,1
        JZ      ShiftMemOne
        ADD     AL,0C1h
        STOSB
        LODSB
        OR      BYTE [ModRM],AL
        MOV     BYTE [RemainBytes],1
        CALL    WriteEAData
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
ShiftMemCL:
        ADD     AL,0D3h
ShiftMemCL2:
        STOSB
        LODSB
        OR      BYTE [ModRM],AL
        CALL    WriteEAData
        JMP     AssembleDone
ShiftMemOne:
        ADD     AL,0D1h
        JMP     ShiftMemCL2
ShiftMem:
        CALL    WriteOverrides
        CALL    GetOperandSize
        XOR     AL,AL
        CMP     AH,_BYTE
        JZ      ShiftMem8
        CMP     AH,_WORD
        JZ      ShiftMem16
        CMP     AH,_DWORD
        JZ      ShiftMem32
        CMP     AH,_QWORD
        JZ      ShiftMem64
        JMP     InvalidOperandSize
ShiftImmCLExpected:
        JMP     ImmCLExpected
ShiftInstr:        
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Mem
        JZ      ShiftMem
        CMP     AL,Keyword
        JNZ     ShiftInvalidOpF
        CMP     BL,Keyword
        JZ      ShiftRegCL
        CMP     BH,Number
        JNZ     ShiftImmCLExpected
        CMP     BL,Num8
        JNZ     ShiftNumTooBig
        CMP     CL,1
        JZ      ShiftRegOne
        JMP     ShiftRegImm
ShiftRegOne:
        MOV     AL,0D1h
        JMP     ShiftRegCL2
ShiftInvalidOpS:
        JMP     InvalidOperand2
ShiftInvalidOpF:
        JMP     InvalidOperand1
ShiftNumTooBig:
        JMP     NumTooBig
ShiftRegCL:        
        CMP     CX,(1 SHL 8) OR Reg8
        JNZ     ShiftImmCLExpected
        MOV     AL,0D3h
ShiftRegCL2:
        CMP     DL,Reg8
        JZ      ShiftR8CL
        CMP     DL,Reg16
        JZ      ShiftR16CL
        CMP     DL,Reg32
        JZ      ShiftR32CL
        CMP     DL,Reg64
        JZ      ShiftR64CL
        MOV     AH,AL
        CALL    WriteRegOverride
        MOV     AL,AH
        JMP     ShiftRxCL
ShiftR32CL:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     ShiftRxCL
ShiftR16CL:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
ShiftRxCL:        
        STOSB
        LODSB
        OR      AL,DH
        OR      AL,0C0h
        STOSB
        JMP     AssembleDone
ShiftR8CL:
        DEC     AL
        STOSB
        LODSB
        OR      AL,DH
        OR      AL,0C0h
        STOSB
        JMP     AssembleDone
ShiftR64CL:
        MOV     BYTE ES:[DI],48h
        INC     DI
        JMP     ShiftRxCL
ShiftR64Imm:
        MOV     BYTE ES:[DI],48h
        INC     DI
        JMP     ShiftRxImm
ShiftRegImm:
        MOV     AH,BYTE [SI]
        MOV     AL,0C1h
        CMP     DL,Reg8
        JZ      ShiftR8Imm
        CMP     DL,Reg16
        JZ      ShiftR16Imm
        CMP     DL,Reg32
        JZ      ShiftR32Imm
        CMP     DL,Reg64
        JZ      ShiftR64Imm
        CALL    WriteRegOverride
        JMP     ShiftRxImm
ShiftR8Imm:
        DEC     AL
        STOSB
        LODSB
        OR      AL,DH
        OR      AL,0C0h
        MOV     AH,CL
        STOSW
        JMP     AssembleDone
ShiftR32Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     ShiftRxImm
ShiftR16Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     ShiftRxImm
ShiftRxImm:
        STOSB
        LODSB
        OR      AL,DH
        OR      AL,0C0h
        MOV     AH,CL
        STOSW
        JMP     AssembleDone