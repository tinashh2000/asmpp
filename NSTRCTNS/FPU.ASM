
FstPInvalidOpF:
        JMP     InvalidOperand1
FstPInvalidOpS:
        JMP     InvalidOperand2
FstPInstr2:
        CMP     AL,Keyword
        JNZ     FstPInvalidOpF
        CMP     DL,FPUReg
        JNZ     FstPInvalidOpF
        LES     DI,[OBufferPtr]
        MOV     AH,[SI][6]
        ADD     AH,DH
        MOV     AL,0DDh
        STOSW
        PUSH    DI
        CALL    GetNext
        POP     DI
        CMP     AL,EndOfLine
        JNZ     FstPGetST0
        JMP     AssembleDone
FstPGetST0:
        CMP     AL,Keyword
        JNZ     FstPInvalidOpS
        CMP     DX,FPUReg
        JNZ     FstPInvalidOpS
        JMP     AssembleDone

FComPInstrx:        
        CALL    GetOperand
        MOV     SI,OFFSET FComInstr+2
        JMP     FldPInstr2
FCompPInstrx:        
        CALL    GetOperand
        MOV     SI,OFFSET FCompInstr+2
        JMP     FldPInstr2
FstPInstrx:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        CMP     AL,Mem
        JZ      FldPMem
        JMP     FstPInstr2
FldPInstr:
        CALL    GetOperand
        MOV     SI,OFFSET FldInstr+2
FldPInstr2:
        CMP     AL,Mem
        JZ      FldPMem
        CMP     AL,EndOfLine
        JZ      FldPEOL
        CMP     AL,Keyword
        JNZ     FldPInvalidOpF
FldPKeyword:
        CMP     DL,FPUReg
        JNZ     FldPInvalidOpF
        CMP     DH,0
        JZ      FldPST0
FldPRegOK:
        LES     DI,[OBufferPtr]
        MOV     AX,[SI][6]
        ADD     AH,DH
        STOSW
        JMP     AssembleDone
FldPEOL:
        MOV     DH,1
        JMP     FldPRegOK
FldPST0:        
        CMP     BYTE [NextChar],Comma
        JNZ     FldPRegOK
        PUSH    SI
        CALL    GetOperand
        POP     SI
        CMP     AL,Keyword
        JNZ     FldPInvalidOpS
        CMP     DL,FPUReg
        JNZ     FldPInvalidOpF
        JMP     FldPRegOK
FldPInvalidOpS:
        JMP     InvalidOperand2
FComx:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LEA     SI,[SI][-6]
        CMP     AL,Keyword
        JZ      FldPKeyword
        CMP     AL,EndOfLine
        JZ      FldPEOL
FldPInvalidOpF:
        JMP     InvalidOperand1
FldPMem:
        CALL    GetOperandSize
        LES     DI,[OBufferPtr]
        CMP     AH,_DWORD
        JZ      FldPMem32
        CMP     AH,_QWORD
        JZ      FldPMem64
        CMP     AH,_TWORD
        JZ      FldPMem80
FldPInvalidSize:
        JMP     InvalidOperandSize
FldPMem32:
        CALL    WriteOverrides
        MOV     AX,[SI]
        TEST    AL,AL
        JZ      FldPInvalidSize
        STOSB
        OR      BYTE [ModRM],AH
        CALL    WriteEAData
        JMP     AssembleDone
FldPMem64:
        CALL    WriteOverrides
        MOV     AX,[SI][2]
        TEST    AL,AL
        JZ      FldPInvalidSize
        STOSB
        OR      BYTE [ModRM],AH
        CALL    WriteEAData
        JMP     AssembleDone
FldPMem80:
        CALL    WriteOverrides
        MOV     AX,[SI][4]
        TEST    AL,AL
        JZ      FldPInvalidSize
        STOSB
        OR      BYTE [ModRM],AH
        CALL    WriteEAData
        JMP     AssembleDone

FFreePInstrx:
        CALL    GetOperand
        CMP     AL,Keyword
        JNZ     FstSwInvalidOp
        CMP     DL,FPUReg
        JNZ     FstSwInvalidOp
        MOV     AH,DH
        ADD     AH,0C0h
        LES     DI,[OBufferPtr]
        MOV     AL,0DDh
        STOSW
        JMP     AssembleDone

FstSwInvalidOp:
        JMP     InvalidOperand
FstSwPInstr:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,[OBufferPtr]
        CMP     AL,EndOfLine
        JZ      FstSwAX
        CMP     AL,Mem
        JZ      FstSwMem
        CMP     AL,Keyword
        JNZ     FstSwInvalidOp
        CMP     DX,0 SHL 8 OR Reg16
        JNZ     FstSwInvalidOp
FstSwAX:
        CMP     SI,OFFSET FnstSwInstr+2
        JZ      FstSwAX2
        MOV     AL,9Bh
        STOSB
FstSwAX2:
        MOV     AX,0E0DFh
        STOSW
        JMP     AssembleDone
FstSwMem:
        MOV     AL,[OperandSize]
        CMP     AL,_WORD
        JZ      FstSwSizeOK
        TEST    AL,AL
        JNZ     FstSwInvalidSize
FstSwSizeOK:
        CMP     SI,OFFSET FnstSwInstr+2
        JZ      FstSwSizeOK2
        MOV     AL,9Bh
        STOSB
FstSwSizeOK2:
        CALL    WriteOverrides
        MOV     AL,0DDh
        STOSB
        OR      BYTE [ModRM],56
        CALL    WriteEAData
        JMP     AssembleDone
FstSwInvalidSize:
        JMP     InvalidOperandSize

IntFPUMemExpected:
        JMP     MemOpExpected
IntegerFPU:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        CMP     AL,Mem
        JNZ     IntFPUMemExpected
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        CALL    GetOperandSize
        CMP     AH,_WORD
        JZ      IntFPU16
        CMP     AH,_DWORD
        JZ      IntFPU32
        CMP     AH,_QWORD
        JZ      IntFPU64
IntFPUInvalidSize:
        JMP     InvalidOperandSize
IntFPU16:
        MOV     AX,[SI]
        TEST    AL,AL
        JZ      IntFPUInvalidSize
        OR      BYTE [ModRM],AH
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
IntFPU32:
        MOV     AX,[SI][2]
        TEST    AL,AL
        JZ      IntFPUInvalidSize
        OR      BYTE [ModRM],AH
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
IntFPU64:
        MOV     AX,[SI][4]
        TEST    AL,AL
        JZ      IntFPUInvalidSize
        OR      BYTE [ModRM],AH
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
BasicFPUMem:
        POP     SI
        JMP     FldPMem
BasicFPU:
        PUSH    BX
        CALL    GetOperand
        CMP     AL,Mem
        JZ      BasicFPUMem
        CMP     AL,EndOfLine
        JZ      BasicFPUEOL
        CMP     AL,Keyword
        JNZ     BasicFPUInvalidOpF
        CMP     DL,FPUReg
        JNZ     BasicFPUInvalidOpF
        PUSH    DX
        CALL    GetOperand
        POP     BX
        CMP     AL,EndOfLine
        JZ      BasicFPUEOL2
        CMP     AL,Keyword
        JNZ     BasicFPUInvalidOpS
        CMP     DL,FPUReg
        JNZ     BasicFPUInvalidOpS
BasicFPURegOK:
        POP     SI
        LES     DI,[OBufferPtr]
        TEST    BH,BH
        JZ      BasicFPUST0x
        TEST    DH,DH
        JNZ     BasicFPUInvalidOpS
        MOV     AX,[SI][8]
        ADD     AH,BH
        STOSW
        JMP     AssembleDone
BasicFPUEOL:
        MOV     BH,0
        MOV     DH,1
        JMP     BasicFPURegOK
BasicFPUEOL2:
;        MOV     DH,1
;        TEST    BH,BH
;        JZ      BasicFPURegOK
        MOV     DH,0
        JMP     BasicFPURegOK
BasicFPUST0x:
        MOV     AX,[SI][6]
        ADD     AH,DH
        STOSW
        JMP     AssembleDone
BasicFPUInvalidOpF:
        JMP     InvalidOperand1
BasicFPUInvalidOpS:
        JMP     InvalidOperand2

BasicFPU2:
        PUSH    BX
        CALL    GetOperand
        CMP     AL,EndOfLine
        JZ      BasicFPU2EOL
        CMP     AL,Keyword
        JNZ     BasicFPU2EOL
        CMP     DL,FPUReg
        JNZ     BasicFPU2InvalidOpF
        PUSH    DX
        CALL    GetOperand
        POP     BX
        CMP     AL,EndOfLine
        JZ      BasicFPU2EOL2
        CMP     AL,Keyword
        JNZ     BasicFPU2InvalidOpS
        CMP     DX,FPUReg
        JNZ     BasicFPU2InvalidOpS
BasicFPU2RegOK:
        POP     SI
        TEST    DH,DH
        JNZ     BasicFPU2InvalidOpS
        LES     DI,[OBufferPtr]
        MOV     AX,[SI]
        ADD     AH,BH
        STOSW
        JMP     AssembleDone
BasicFPU2EOL:
        MOV     BH,1
        MOV     DH,0
        JMP     BasicFPU2RegOK
        JMP     AssembleDone
BasicFPU2EOL2:
        MOV     DH,0
        JMP     BasicFPU2RegOK
BasicFPU2InvalidOpF:
        JMP     InvalidOperand1
BasicFPU2InvalidOpS:
        JMP     InvalidOperand2
