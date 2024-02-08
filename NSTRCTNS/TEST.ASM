
TestCheckMem:        
        CMP     AL,Mem
        JNZ     TestInvalidOpF
        CMP     BL,Keyword
        JNZ     TestCheckMemImm
        MOV     AL,85h
        MOV     DX,CX
        JMP     TranslateRegMem
TestCheckMemImm:        
        MOV     AL,0F7h
        JMP     TranslateMemImm
TestPInstr:        
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     TestCheckMem
        CMP     BL,Keyword
        JNZ     TestCheckRegImm
        MOV     AH,85h
        XCHG    CH,DH
        JMP     TranslateReg
TestInvalidOpF:
        JMP     InvalidOperand1
TestInvalidOpS:
        JMP     InvalidOperand2
TestCheckRegImm:
        CMP     BH,Number
        JNZ     TestRegCheckMem
        TEST    DH,DH
        JZ      TestCheckRegAccum
TestCheckRegImmTrans:
        MOV     AL,0F7h
        JMP     TranslateRegImm
TestRegCheckMem:        
        CMP     BL,Mem
        JNZ     TestInvalidOpS
        MOV     AL,085h
        JMP     TranslateRegMem
TestCheckRegAccum:
        CMP     DL,Reg8
        JB      TestCheckRegImmTrans
        JZ      TestALImm
        CMP     DL,Reg32
        JB      TestAXImm
        JZ      TestEAXImm
        CMP     DL,Reg64
        JZ      TestRAXImm
        JMP     TestCheckRegImmTrans
TestALImm:
        CMP     BL,Num8
        JA      TestAccumNumTooBig
        MOV     AL,0A8h
        MOV     AH,CL
        STOSW
        JMP     AssembleDone
TestAXImm:
        CMP     BL,Num16
        JA      TestAccumNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,0A9h
        STOSB
        CALL    Write16Imm
        JMP     AssembleDone
TestAccumNumTooBig:
        JMP     NumTooBig
TestEAXImm:
        CMP     BL,Num32
        JA      TestAccumNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,0A9h
        STOSB
        CALL    Write32Imm
        JMP     AssembleDone
TestRAXImm:
        CMP     BL,Num32
        JA      TestAccumNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AX,0A948h
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone