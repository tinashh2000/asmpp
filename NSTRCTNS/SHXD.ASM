ShxdMemSizeOK:
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        LEA     AX,[DI+1]
        XCHG    AX,WORD [Temp1]
        STOSW
        MOV     [Temp2],DI
        CALL    GetOperand
        MOV     DI,[Temp2]
        MOV     ES,[DiskOutSeg]
        CMP     AL,Keyword
        JZ      ShxdMemCL
        CMP     AH,Number
        JNZ     ShxdInvalidOpT2
        CMP     AL,Num8
        JA      ShxdNumTooBig2
        MOV     BYTE [RemainBytes],1
        MOV     CL,DL
        MOV     BX,WORD [Temp1]
        DEC     BYTE ES:[BX]
        CALL    WriteEAData
        MOV     AL,CL
        STOSB
        JMP     AssembleDone
ShxdMemCL:
        CMP     DX,1 SHL 8 OR Reg8
        JNZ     ShxdInvalidOpT2
        CALL    WriteEAData
        JMP     AssembleDone
ShxdNumTooBig2:
        JMP     NumTooBig
ShxdInvalidOpT2:
        JMP     InvalidOperand3
ShxdMemSize2:
        TEST    AL,AL
        JZ      ShxdMemSizeOK
        JMP     OperandSizeMismatch
ShxdMem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr16Disp]
        CMP     AL,WordID+1
        JNZ     ShxdMemSize2
        JMP     ShxdMemSizeOK
ShxdMem32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr32Disp]
        CMP     AL,DWordID+1
        JNZ     ShxdMemSize2
        JMP     ShxdMemSizeOK
ShxdMem64:
        OR      AH,48h
        CMP     AL,QWordID+1
        JNZ     ShxdMemSize2
        JMP     ShxdMemSizeOK
ShxdMem:
        ADD     CH,CH
        ADD     CH,CH
        ADD     CH,CH
        OR      BYTE [ModRM],CH
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AH,[REXOverride]
        MOV     AL,[OperandSize]
        CMP     BL,Keyword
        JNZ     ShxdInvalidOPS
        CMP     CL,Reg16
        JZ      ShxdMem16
        CMP     CL,Reg32
        JZ      ShxdMem32
        CMP     CL,Reg64
        JZ      ShxdMem64
        OR      AH,44h
        CMP     CL,LMReg16
        JZ      ShxdMem16
        CMP     CL,LMReg32
        JZ      ShxdMem32
        CMP     CL,LMReg64
        JZ      ShxdMem64
        JMP     InvalidOperand2
ShxdInstr:
        MOV     AX,[BX]
        MOV     WORD [Temp1],AX
        MOV     BYTE [REXDisp],0
        CALL    GetTwoOperands
        CMP     AL,Mem
        JZ      ShxdMem
        CMP     AL,Keyword
        JNZ     ShxdInvalidOpF
        CMP     AL,BL
        JNZ     ShxdInvalidOpS
        ADD     CH,CH
        ADD     CH,CH
        ADD     CH,CH
        OR      DH,CH
        OR      DH,0C0h
        MOV     AH,[REXOverride]
        LES     DI,[OBufferPtr]
        CMP     DL,Reg16
        JZ      ShxdReg16
        CMP     DL,Reg32
        JZ      ShxdReg32
        CMP     DL,Reg64
        JZ      ShxdReg64
        OR      AH,41h
        CMP     DL,LMReg16
        JZ      ShxdReg16
        CMP     DL,LMReg32
        JZ      ShxdReg32
        CMP     DL,LMReg64
        JZ      ShxdReg64
ShxdInvalidOpF:
        JMP     InvalidOperand1
ShxdInvalidOpS:
        JMP     InvalidOperand2
ShxdReg16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr16Disp]
        CMP     CL,Reg16
        JZ      ShxdGetLast
        CMP     CL,LMReg16
        JNZ     ShxdInvalidOpS
        OR      AH,44h        
        JMP     ShxdGetLast
ShxdReg64:
        OR      AH,48h
        MOV     BYTE [REXDisp],1
        CMP     CL,Reg64
        JZ      ShxdGetLast
        CMP     CL,LMReg64
        JZ      ShxdGetLast
        JMP     InvalidOperand2
ShxdReg32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,[Addr32Disp]
        CMP     CL,Reg32
        JZ      ShxdGetLast
        CMP     CL,LMReg32
        JNZ     ShxdInvalidOpS
        OR      AH,44h
        MOV     BYTE [REXDisp],1
ShxdGetLast:
        MOV     BYTE ES:[DI],AH
        ADD     DI,[REXDisp]
        LEA     AX,[DI+1]
        XCHG    AX,WORD [Temp1]
        STOSW
        MOV     AL,DH
        STOSB
ShxdGetLast2:
        MOV     [Temp2],DI
        CALL    GetOperand
        MOV     DI,[Temp2]
        CMP     AL,Keyword
        JZ      ShxdRegCL
        CMP     AH,Number
        JNZ     ShxdInvalidOpT
        CMP     AL,Num8
        JA      ShxdNumTooBig
;ShxdRegNum:
        MOV     ES,[DiskOutSeg]
        MOV     BX,WORD [Temp1]
        DEC     BYTE ES:[BX]
        MOV     AL,DL
        STOSB
        JMP     AssembleDone
ShxdRegCL:
        CMP     DX,1 SHL 8 OR Reg8
        JNZ     ShxdInvalidOpT
        JMP     AssembleDone
ShxdInvalidOpT:
        JMP     InvalidOperand3
ShxdNumTooBig:
        JMP     NumTooBig