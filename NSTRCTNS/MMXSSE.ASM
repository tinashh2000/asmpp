BasicMMX:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     BasMMInvalidOpF
        LES     DI,DWORD [OBufferPtr]
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        CMP     DL,SSEReg
        JAE     BasMMSSE
        CMP     BL,Mem
        JZ      BasMMRegMem
        CMP     BL,Keyword
        JNZ     BasMMInvalidOpS
        CMP     CL,MMXReg
        JNZ     BasMMInvalidOpS
        MOV     AL,0Fh
        OR      DH,CH
        OR      DH,0C0h
        MOV     AH,BYTE [SI]
        STOSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
BasMMRegMem:    
        CALL    WriteOverrides
        MOV     BL,_QWORD
BasMMRegMem2:
        MOV     AL,0Fh
        MOV     AH,BYTE [SI]
        STOSW
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      BasMMRegMemOpSizeOK
        CMP     AL,BL
        JNZ     BasMMInvalidOpSize
BasMMRegMemOpSizeOK:
        OR      BYTE [ModRM],DH
        CALL    WriteEAData
        JMP     AssembleDone
BasMMInvalidOpSize:
        JMP     InvalidOperandSize
BasMMInvalidOpF:
        JMP     InvalidOperand1
BasMMInvalidOpS:
        JMP     InvalidOperand2
BasMMSSE:
        MOV     BH,BYTE [REXOverride]
        CMP     DL,SSEReg
        JZ      BasMMSSEOK
        OR      BH,44h
        MOV     BYTE [REXDisp],1
BasMMSSEOK:
        MOV     AL,66h
        STOSB
        CMP     BL,Mem
        JZ      BasMMSSEMem
        CMP     BL,Keyword
        JNZ     BasMMInvalidOpS
        CMP     CL,SSEReg
        JZ      BasMMSSERegsOK
        OR      BH,41h
BasMMSSERegsOK:
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     AL,0Fh
        STOSB
        MOV     AL,BYTE [SI]
        OR      DH,CH
        OR      DH,0C0h
        MOV     AH,DH
        STOSW
        JMP     AssembleDone
BasMMSSEMem:
        CALL    WriteOverrides
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     BL,_OWORD
        JMP     BasMMRegMem2
