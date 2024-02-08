        
MovxxInvkMoveMem:
        JMP     MoveRegMem2
MovxxR16Mem:
        CMP     AH,_WORD
        JZ      MovxxInvkMoveMem
        JA      MovxxInvalidOpSize
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
MovxxRegMemWrite:
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOVSW
        CMP     AH,_WORD
        CMC
        ADC     BYTE ES:[DI][-1],0
        ADD     DH,DH
        SHL     DH,1
        SHL     DH,1
        OR      BYTE [ModRM],DH
        CALL    WriteEAData
        JMP     AssembleDone
MovxxR32Mem:
        CMP     AH,_DWORD
        JZ      MovxxInvkMoveMem
        JA      MovxxInvalidOpSize
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     MovxxRegMemWrite
MovxxR64Mem:
        OR      AL,8
        CMP     AH,_DWORD
        JZ      MovxxR64Mem32
        JA      MovxxR64Memxx
        JMP     MovxxRegMemWrite
MovxxR64Memxx:
        CMP     AH,_QWORD
        JNZ     MovxxInvalidOpSize
        JMP     MovxxinvkMoveMem
MovxxR64Mem32:
        JMP     MovSXDR64Mem32
MovxxMem:
        CALL    WriteOverrides
        MOV     AH,BYTE [OperandSize]
MovxxMemSizeOK:
        MOV     AL,BYTE [REXOverride]
        XOR     BL,BL
        CMP     DL,Reg16
        JZ      MovxxR16Mem
        CMP     DL,Reg32
        JZ      MovxxR32Mem
        CMP     DL,Reg64
        JZ      MovxxR64Mem
        OR      AL,4
        CMP     DL,LMReg16
        JZ      MovxxR16Mem
        CMP     DL,LMReg32
        JZ      MovxxR32Mem
        CMP     DL,LMReg64
        JZ      MovxxR64Mem
MovxxInvalidOpSize:
        JMP     InvalidOperandSize

MovxxInstr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     MovxxInvalidOpF
        CMP     BL,Mem
        JZ      MovxxMem
        CMP     BL,Keyword
        JNZ     MovxxInvalidOpS
        CMP     DL,CL
        JZ      MovxxInvMove        
        ADD     DH,DH
        SHL     DH,1
        SHL     DH,1
        OR      DH,CH
        OR      DH,0C0h
        MOV     AL,40h  ;Prepare REX
        CMP     DL,Reg16
        JZ      MovxxR16
        CMP     DL,Reg32
        JZ      MovxxR32
        CMP     DL,Reg64
        JZ      MovxxR64
        OR      AL,4
        CMP     DL,LMReg16
        JZ      MovxxLMR16
        CMP     DL,LMReg32
        JZ      MovxxLMR32
        CMP     DL,LMReg64
        JZ      MovxxR64
MovxxInvalidOpF:
        JMP     InvalidOperand1
MovxxInvalidOpS:
        JMP     InvalidOperand2
MovxxInvMove:
        MOV     AH,8Bh
        JMP     TranslateReg
MovxxR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
MovxxR162:
        CMP     CL,Reg8
        JZ      MovxxR16R8
        CMP     CL,LMLowReg
        JZ      MovxxR16R8LM
        CMP     CL,LMReg8
        JNZ     MovxxInvalidOpS
        OR      AL,1
MovxxR16R8LM:
        STOSB
MovxxR16R8:
        MOVSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
MovxxR32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
MovxxR322:
        CMP     CL,Reg16
        JZ      MovxxR32R16
        CMP     CL,LMReg16
        JZ      MovxxR32R16LM
        JMP     MovxxR162
MovxxR32R16LM:
        OR  AL,1
        STOSB
MovxxR32R16:
        MOVSW
        INC     BYTE ES:[DI][-1]
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
MovxxR64:
        OR      AL,8
        CMP     DL,Reg32
        JZ      MovxxR64R32
        CMP     DL,LMReg32
        JZ      MovxxR64LMR32
        JMP     MovxxLMR32
MovxxLMR16:
        MOV     AL,66h
        STOSB
MovxxLMR162:
        CMP     CL,Reg8
        JZ      MovxxLMR16R8Chk
        CMP     CL,LMLowReg
        JZ      MovxxLMR16R8
        OR      AL,1
        CMP     CL,LMReg8
        JZ      MovxxLMR16R8
        JMP     InvalidOperand2
MovxxInvalidComb:
        JMP     CombinationNotAllowed
MovxxLMR32:
        CMP     CL,Reg16
        JZ      MovxxLMR32R16
        OR      AL,1
        CMP     CL,LMReg16
        JZ      MovxxLMR32R16
        AND     AL,NOT 1
        JMP     MovxxLMR162
MovxxR64LMR32:
        OR      AL,1
MovxxR64R32:
        JMP     MovSXDR64R32

MovxxLMR16R8Chk:
        CMP     CH,3
        JA      MovxxInvalidComb
MovxxLMR16R8:
        STOSB
        MOVSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone

MovxxLMR32R16:
        STOSB
        MOVSW
        INC     BYTE ES:[DI][-1]
        MOV     AL,DH
        STOSB
        JMP     AssembleDone

MovSXDRegMem:
        CALL    WriteOverrides
        MOV     AL,BYTE [REXOverride]
        MOV     AH,BYTE [OperandSize]
        OR      BYTE [ModRM],DH
        CMP     AH,_DWORD
        JZ      MovSXDRegMem32
        TEST    AH,AH
        JZ      MovSXDRegMem32
        JMP     InvalidOperandSize
MovSXDRegMem32:
        OR      AL,8
        CMP     DL,Reg64
        JZ      MovSXDR64Mem32
        OR      AL,4
        CMP     DL,LMReg64
        JNZ     MovSXDInvalidOpF
MovSXDR64Mem32:
        STOSB
        MOV     AL,63h
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
MovSXDPInstr:
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     MovSXDInvalidOpF
        ADD     DH,DH
        SHL     DH,1
        SHL     DH,1
        CMP     BL,Mem
        JZ      MovSXDRegMem
        CMP     BL,Keyword
        JNZ     MovSXDInvalidOpS
        OR      DH,CH
        OR      DH,0C0h
        MOV     AL,48h
        CMP     DL,Reg64
        JZ      MovSXDR64Reg
        OR      AL,4
        CMP     DL,LMReg64
        JNZ     MovSXDInvalidOpF
MovSXDR64Reg:
        CMP     CL,Reg32
        JZ      MovSXDR64R32
        OR      AL,1
        CMP     CL,LMReg32
        JNZ     MovSXDInvalidOpS
MovSXDR64R32:
        STOSB
        MOV     AL,63h
        MOV     AH,DH
        STOSW
        JMP     AssembleDone
MovSXDInvalidOpF:
        JMP     InvalidOperand1
MovSXDInvalidOpS:
        JMP     InvalidOperand2