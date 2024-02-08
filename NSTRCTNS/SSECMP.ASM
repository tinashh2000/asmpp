SSEComparePSInvalidOpF:
        JMP     InvalidOperand1
SSEComparePSInvalidOpS:
        JMP     InvalidOperand2
SSEComparePS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
SSEComparePS1:
        MOV     BYTE [Temp1],_OWORD
        MOV     BP,0C20Fh
SSEComparePS2:
        CMP     AL,Keyword
        JNZ     SSEComparePSInvalidOpF
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        MOV     BH,BYTE [REXOverride]
        CMP     DL,SSEReg
        JNZ     SSEComparePSInvalidOpF
		CMP	DH,8
		JB SSEComparePSRegOK
        OR      BH,44h
        MOV     BYTE [REXDisp],1
		AND	DH, 07h
SSEComparePSRegOK:
        CMP     BL,Mem
        JZ      SSEComparePSRegMem
        CMP     BL,Keyword
        JNZ     SSEComparePSInvalidOpS
        CMP     CL,SSEReg
        JNZ     SSEComparePSInvalidOpS
		CMP	CH, 8
		JB SSEComparePSReg2OK
        OR      BH,41h
		MOV BYTE [REXDisp], 1
		AND CH,07h
SSEComparePSReg2OK:
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        OR      CH,0C0h
        MOV     AX,BP
        STOSW
        OR      DH,CH
        MOV     AL,DH
        MOV     AH,BYTE [SI]
        STOSW
        JMP     AssembleDone
SSEComparePSInvalidOpSize:
        JMP     InvalidOperandSize
SSEComparePSRegMem:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      SSEComparePSMemSizeOK
        CMP     AL,BYTE [Temp1]
        JNZ     SSEComparePSInvalidOpSize
SSEComparePSMemSizeOK:
        CALL    WriteOverrides
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     AX,BP
        STOSW
        OR      BYTE [ModRM],DH
        MOV     BX,SI
        MOV     BYTE [RemainBytes],1
        CALL    WriteEAData
        MOV     AL,BYTE [BX]
        STOSB
        JMP     AssembleDone
SSECompareSS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],0F3h
        INC     DI
        JMP     SSEComparePS1
SSECompareSD:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],0F2h
        INC     DI
        JMP     SSEComparePS1
SSEComparePD:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],066h
        INC     DI
        JMP     SSEComparePS1

CMPSSPInstr:
        MOV     AL,BYTE [BX][3]
        MOV     BYTE [Temp1],AL
        PUSH    BX
        CALL    GetTwoOperands
        MOV     AH,BL
        PUSH    AX,CX,DX
        CALL    GetOperand
        CMP     AH,Number
        JNZ     CMPSSInvalidOpF
        CMP     AL,Num8
        JNZ     CMPSSNumTooBig
        POP     DX,CX,AX,SI
        MOV     BL,AH
        LES     DI,DWORD [OBufferPtr]
        MOV     BP,WORD [SI]
        MOV     AH,BYTE [SI][2]
        MOV     BYTE ES:[DI],AH
        INC     DI
        MOV     SI,OFFSET OWordNum
        JMP     SSEComparePS2


CMPSSInvalidOpF:
        JMP     InvalidOperand1
CMPSSNumTooBig:
        JMP     NumTooBig
CMPPSPInstr:
        MOV     AL,BYTE [BX][2]
        MOV     BYTE [Temp1],AL
        PUSH    BX
        CALL    GetTwoOperands
        MOV     AH,BL
        PUSH    AX,CX,DX
        CALL    GetOperand
        CMP     AH,Number
        JNZ     CMPSSInvalidOpF
        CMP     AL,Num8
        JNZ     CMPSSNumTooBig
        POP     DX,CX,AX,SI
        MOV     BL,AH
        LES     DI,DWORD [OBufferPtr]
        MOV     BP,WORD [SI]
        MOV     SI,OFFSET OWordNum
        JMP     SSEComparePS2

CmpSDPInstr:
        MOV     AL,BYTE [NextChar]
        CMP     AL,Char0A
        JNZ     CmpSDInstr2
CmpSDInstrOK:
        LES     DI,[OBufferPtr]
        XOR     AL,AL
        XCHG    AL,BYTE [SegOverride]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,BYTE [BX]
        STOSB
        JMP     AssembleDone
CmpSDInstr2:
        CMP     AL,SemiColon
        JZ      CmpSDInstrOK
        INC     BX
        CMP     BX,OFFSET CMPSDInstr+3
        JZ      CmpSSInvk
        JMP     MOVSDPInstr2
CmpSSInvk:
        JMP     CMPSSPInstr
 