BasicMemImmOpt:
        CALL    GetOperandSize
        CMP     AH,_BYTE
        JBE     BasicMemImmOK
        MOV     AL,BYTE [SI]
        OR      BYTE [ModRM],AL
        MOV     AL,83h
        CMP     AH,_WORD
        JZ      BasicMem16Imm
        CMP     AH,_QWORD
        JZ      BasicMem64Imm
        CMP     AH,_DWORD
        JNZ     BasicMemInvalidSize
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
BasicMemImmWrite:
        MOV     AH,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AH
        ADD     DI,WORD [REXDisp]
        STOSB
        MOV     BYTE [RemainBytes],1
        CALL    WriteEAData
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
BasicMem16Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     BasicMemImmWrite
BasicMem64Imm:
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     BasicMemImmWrite
BasicMemImmOptTest:
        MOV     AL,BYTE [EAMask]
        AND     AL,[Settings]
        TEST    AL,1
        JNZ     BasicMemImmOK
        CMP     CX,-128
        JL      BasicMemImmOK
        CMP     CX,127
        JG      BasicMemImmOK
        JMP     BasicMemImmOpt
BasicMemImm:
        CALL    WriteOverrides
        CMP     BL,Num8
        JZ      BasicMemImmOptTest
BasicMemImmOK:
        MOV     AH,BYTE [SI]
        MOV     AL,81h
        JMP     TranslateMemImm
BasicMemInvalidSize:
        JMP     InvalidOperandSize
BasicInstr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Mem
        JZ      BasicInstrMem
        CMP     AL,Keyword
        JNZ     BasicInvalidOpF
        CMP     BL,Keyword
        JNZ     BasicInstrRegxx
        MOV     AH,BYTE [SI]
        ADD     AH,3
        JMP     TranslateReg
BasicInvalidOpS:
        JMP     InvalidOperand2
BasicInvalidOpF:
        JMP     InvalidOperand1
BasicInstrMem:
        CMP     BH,Number
        JZ      BasicMemImm
        CMP     BL,Keyword
        JNZ     BasicInvalidOpS
BasicMemReg:
        MOV     AL,BYTE [SI]
        INC     AL
        JMP     TranslateMemReg
BasicInstrRegxx:
        CMP     BL,Mem
        JZ      BasicInstrRegMem
        CMP     BH,Number
        JNZ     BasicInvalidOpS
BasicRegImm:
        MOV     AH,BYTE [SI]
        CMP     BL,Num8
        JZ      BasicRegImmOpt
BasicRegNoRegOpt:
        TEST    DH,DH
        JZ      BasicRegImmAccumOpt
BasicRegNoOpt:
        MOV     AL,81h
        JMP     TranslateRegImm
BasicInstrRegMem:
        MOV     AL,BYTE [SI]
        ADD     AL,3
        JMP     TranslateRegMem
BasicRegImmOpt:
        MOV     AL,BYTE [EAMask]
        AND     AL,[Settings]
        TEST    AL,1
        JNZ     BasicRegNoRegOpt
        CMP     CX,-128
        JL      BasicRegNoRegOpt
        CMP     CX,127
        JG      BasicRegNoRegOpt
        CMP     DL,Reg16
        JZ      BasicR16Imm8
        JB      BasicRegNoRegOpt
        CMP     DL,Reg64
        JB      BasicR32Imm8
        JZ      BasicR64Imm8
        CMP     DL,LMReg16
        JZ      BasicLMR16Imm8
        JB      BasicRegNoOpt
        CMP     DL,LMReg64
        JB      BasicLMR32Imm8
        JZ      BasicLMR64Imm8
        JMP     BasicRegNoOpt
BasicR16Imm8:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     BasicRegImm8
BasicR32Imm8:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     BasicRegImm8
BasicR64Imm8:
        MOV     BYTE ES:[DI],48h
        INC     DI
        JMP     BasicRegImm8
BasicLMR16Imm8:
        MOV     WORD ES:[DI],4466h
        ADD     DI,2
        JMP     BasicRegImm8
BasicLMR32Imm8:
        MOV     BYTE ES:[DI],44h
        INC     DI
        JMP     BasicRegImm8
BasicRegImmAccumOpt:
        CMP     DL,Reg64
        JA      BasicRegNoOpt
        CMP     DL,Reg8
        JB      BasicRegNoOpt
        MOV     AL,AH
        ADD     AL,5
        CMP     DL,Reg64
        JZ      BasicReg64Imm
        CMP     DL,Reg32
        JZ      BasicReg32Imm
        CMP     DL,Reg16
        JZ      BasicReg16Imm
BasicReg8Imm:
        CMP     BL,Num8
        JA      BasicRegNumTooBig
        DEC     AL
        STOSB
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
BasicLMR64Imm8:
        MOV     BYTE ES:[DI],49h
        INC     DI
        JMP     BasicRegImm8
BasicReg64Imm:
        CMP     BL,Num32
        JA      BasicRegNumTooBig
        MOV     BYTE ES:[DI],48h
        INC     DI
        STOSB
        CALL    Write32Imm
        JMP     AssembleDone
BasicReg32Imm:
        CMP     BL,Num32
        JA      BasicRegNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        STOSB
        CALL    Write32Imm
        JMP     AssembleDone
BasicReg16Imm:
        CMP     BL,Num16
        JA      BasicRegNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSB
        CALL    Write16Imm
        JMP     AssembleDone
BasicRegNumTooBig:
        JMP     NumTooBig
BasicRegImm8:
        MOV     AL,83h
        OR      AH,DH
        OR      AH,0C0h
        STOSW
        MOV     AL,CL
        STOSB
        JMP     AssembleDone