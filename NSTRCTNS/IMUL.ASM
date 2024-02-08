
IMulPOneOP:
        MOV     BYTE [Temp2],40
        LES     DI,[OBufferPtr]
        JMP     SingleOpGetOperand
IMulPInstr:
        CALL    GetOperand
        CMP     AL,Mem
        JZ      IMulPOneOp
        CMP     BYTE [NextChar],Comma
        JNZ     IMulPOneOP
        PUSH    AX,DX
        CALL    GetOperand
        MOV     BX,AX
        MOV     CX,DX
        POP     DX,AX
        CMP     BL,EndOfLine
        JZ      IMulPOneOP
        CMP     AL,Keyword
        JNZ     IMulPOneOp
        CMP     BYTE [NextChar],Comma
        JZ      IMul3Ops
        LES     DI,[OBufferPtr]
        XOR     BP,BP
        MOV     SI,OFFSET IMulInstr+2
        CMP     BL,Mem
        JZ      IMulRegMem
        CMP     BH,Number
        JZ      IMulRegImm
        CMP     BL,Keyword
        JNZ     IMulInvalidOpS
        JMP     TranslateRegRegExt
IMulRegMem:
        JMP     TranslateRegMemExt
IMulRegImm:
        MOV     BX,DX
        XCHG    DX,CX
        JMP     IMul3OpsNumOK
IMulNumExpected:
        JMP     NumExpected

IMul3RegMem:
        PUSH    DX
        CALL    GetOperand
        POP     BX
        CMP     AH,Number
        JNZ     IMulNumExpected
        JMP     IMul3RegMem2

IMulInvalidOpS:
        JMP     InvalidOperand2
IMul3Ops:
        CMP     BL,Mem
        JZ      IMul3RegMem
        CMP     BL,Keyword
        JNZ     IMulInvalidOpS
        PUSH    CX,DX
        CALL    GetOperand
        POP     BX,CX
        CMP     AH,Number
        JNZ     IMulNumExpected
        LES     DI,[OBufferPtr]
IMul3OpsNumOK:
        ADD     BH,BH
        ADD     BH,BH
        ADD     BH,BH
        OR      BH,CH
        OR      BH,0C0h
        MOV     AH,[REXOverride]
        LES     DI,[OBufferPtr]
        CMP     BL,Reg16
        JZ      IMul3R16
        CMP     BL,Reg32
        JZ      IMul3R32
        CMP     BL,Reg64
        JZ      IMul3R64
        OR      AH,44h
        CMP     BL,LMReg16
        JZ      IMul3R16
        CMP     BL,LMReg32
        JZ      IMul3R32
        CMP     BL,LMReg64
        JZ      IMul3R64
        JMP     InvalidOperand1
IMul3R64:
        OR      AH,48h
        CMP     CL,Reg64
        JZ      IMul3Write32
        OR      AH,41h
        CMP     CL,LMReg64
        JZ      IMul3Write32
        JMP     InvalidOperand2
IMulNumTooBig:
        JMP     NumTooBig
IMul3R16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr16Disp]
        CMP     CL,Reg16
        JZ      IMul3Write16
        OR      AH,41h
        CMP     CL,LMReg16
        JZ      IMul3Write16
IMul3InvalidOpS:
        JMP     InvalidOperand2
IMul3Write16:
        CMP     AL,Num16
        JA      IMulNumTooBig
        CMP     AL,Num8
        JA      IMul3Write162
        CMP     DX,127
        JG      IMul3Write162
        CMP     DX,-128
        JGE     IMul3Write8
IMul3Write162:
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        MOV     AL,069h
        MOV     AH,BH
        STOSW
        CALL    Write16Imm2
        JMP     AssembleDone
        
IMul3R32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr32Disp]
        CMP     CL,Reg32
        JZ      IMul3Write32
        OR      AH,41h
        CMP     CL,LMReg32
        JNZ     IMul3InvalidOpS
IMul3Write32:
        CMP     AL,Num32
        JA      IMulNumTooBig
        CMP     AL,Num8
        JA      IMul3Write322
        CMP     DX,127
        JG      IMul3Write322
        CMP     DX,-128
        JGE     IMul3Write8
IMul3Write322:
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        MOV     AL,069h
        MOV     AH,BH
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone
IMul3Write8:
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        MOV     AL,06Bh
        STOSB
        MOV     AL,BH
        MOV     AH,DL
        STOSW
        JMP     AssembleDone        

IMul3RegMem2:
        ADD     BH,BH
        ADD     BH,BH
        ADD     BH,BH
        OR      BYTE [ModRM],BH
        LES     DI,[OBufferPtr]
        MOV     CL,AL
        CALL    WriteOverrides
        MOV     AL,CL
        MOV     CL,[OperandSize]
        MOV     AH,[REXOverride]
        CMP     BL,Reg16
        JZ      IMulR16Mem
        CMP     BL,Reg32
        JZ      IMulR32Mem
        CMP     BL,Reg64
        JZ      IMulR64Mem
        OR      AH,44h
        CMP     BL,LMReg16
        JZ      IMulR16Mem
        CMP     BL,LMReg32
        JZ      IMulR32MEm
        CMP     BL,LMReg64
        JZ      IMulR64Mem
        JMP     InvalidOperand1

IMulR64Mem:
        OR      AH,48h
        MOV     BYTE [REXDisp],1
        JMP     IMulR32MemW

IMulR16Mem:
        TEST    CL,CL
        JZ      IMulR16MemSizeOK
        CMP     CL,_WORD
        JNZ     IMulMemInvalidOpSize
IMulR16MemSizeOK:
        CMP     AL,Num8
        JNZ     IMulR16MemW
        CMP     DX,127
        JG      IMulR16MemW
        CMP     DX,-128
        JGE     IMulMemWrite8
IMulR16MemW:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr16Disp]
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        MOV     AL,69h
        STOSB
        MOV     BYTE [RemainBytes],2
        MOV     CX,DX
        CALL    WriteEAData
        CALL    Write16Imm2
        JMP     AssembleDone
IMulMemInvalidOpSize:
        JMP     InvalidOperandSize
IMulR32Mem:
        TEST    CL,CL
        JZ      IMulR32MemSizeOK
        CMP     CL,_DWORD
        JNZ     IMulMemInvalidOpSize
IMulR32MemSizeOK:
        CMP     AL,Num8
        JNZ     IMulR32MemW
        CMP     DX,127
        JG      IMulR32MemW
        CMP     DX,-128
        JGE     IMulMemWrite8
IMulR32MemW:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr32Disp]
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        MOV     AL,69h
        STOSB
        MOV     BYTE [RemainBytes],4
        MOV     CX,DX
        CALL    WriteEAData
        CALL    Write32Imm
        JMP     AssembleDone

IMulMemWrite8:
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        MOV     AL,06Bh
        STOSB
        MOV     CL,DL
        MOV     BYTE [RemainBytes],1
        CALL    WriteEAData
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
