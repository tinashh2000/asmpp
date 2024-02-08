
ExtendedPS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     BasPSInvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,0F2h
        STOSB
        MOV     BYTE [Temp1],_OWORD
        JMP     BasicPS2

BasicPD:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     BasPSInvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,66h
        STOSB
        MOV     BYTE [Temp1],_OWORD
        JMP     BasicPS2
BasPSInvalidOpF:
        JMP     InvalidOperand1
BasicPS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     BasPSInvalidOpF
        MOV     BYTE [Temp1],_OWORD
BasicPS1:
        LES     DI,DWORD [OBufferPtr]
BasicPS2:
        MOV     BH,BYTE [REXOverride]
		
;        CMP     DL,SSEReg
;        JZ      BasPSRegOK
;        CMP     DL,SSE2Reg
;        JNZ     BasPSInvalidOpF
		
        CMP     DL,SSEReg
        JNZ      BasPSInvalidOpF		
        CMP     DH,8
        JB     	BasPSRegOK		
        OR      BH,44h
        MOV     BYTE [REXDisp],1		
		AND DH, 07h	;Remove the top bits
BasPSRegOK:
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
		
        CMP     BL,Mem
        JZ      BasPSRegMem
		
        CMP     CL, SSEReg
        JNZ     BasPSInvalidOpF
		CMP		CH, 8
		JB		BasPSRegsOK
        OR      BH,41h
        MOV     BYTE [REXDisp],1		
		AND		CH, 07h
BasPSRegsOK:
        OR      DH,CH
        OR      DH,0C0h

        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     AL,0Fh
        STOSB
        MOVSB
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
BasPSRegMem:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      BasPSRegMemOpSizeOK
        CMP     AL,BYTE [Temp1]
        JNZ     BasPSInvalidOpSize
BasPSRegMemOpSizeOK:
        OR      BYTE [ModRM],DH
        CALL    WriteOverrides
        MOV     AL,0Fh
        STOSB
        MOVSB
        CALL    WriteEAData
        JMP     AssembleDone
BasPSInvalidOpSize:
        JMP     InvalidOperandSize

BasicSS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSEInvalidOpF
        MOV     BYTE [Temp1],_DWORD
        JMP     BasicPS1

ExtendedSS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSEInvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,0F3h
        STOSB
        MOV     BYTE [Temp1],_DWORD
        JMP     BasicPS2

BasicSD:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSEInvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,066h
        STOSB
        MOV     BYTE [Temp1],_QWORD
        JMP     BasicPS2
SSEInvalidOpF:
        JMP     InvalidOperand1


ExtendedSD:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSEInvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,0F2h
        STOSB
        MOV     BYTE [Temp1],_QWORD
        JMP     BasicPS2

MOVSDPInstr2:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],0F2h
        INC     DI
        MOV     BYTE [Temp1],_DWORD
        JMP     SSESS2
SSESS:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],0F3h
        INC     DI
        MOV     BYTE [Temp1],_DWORD
SSESS2:
        CMP     AL,Mem
        JZ      SSESSMem
        CMP     AL,Keyword
        JNZ     SSESSInvalidOpF
        MOV     BH,BYTE [REXOverride]
        CMP     DL,SSEReg
        JNZ     SSESSInvalidOpF
		CMP	DH, 8
		JB	SSESSRegOK
        OR      BH,44h
        MOV     BYTE [REXDisp],1
		AND		DH, 07h
SSESSRegOK:
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        CMP     BL,Mem
        JZ      SSESSRegMem
        CMP     CL,SSEReg
        JNZ     SSESSInvalidOpS
		CMP		CH, 8
        JB      SSESSReg2OK
        OR      BH,41h
        MOV     BYTE [REXDisp],1
		AND		CH, 07h
SSESSReg2OK:
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        OR      DH,CH
        OR      DH,0C0h
        MOV     AL,0Fh
        STOSB
        MOVSB
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
SSESSRegMem:
        DEC     SI
        OR      BYTE [ModRM],DH
        JMP     SSESSMemRegTestSize
SSESSInvalidOpF:
        JMP     InvalidOperand1
SSESSInvalidOpS:
        JMP     InvalidOperand2
SSESSInvalidOpSize:
        JMP     InvalidOperandSize
SSESSMem:
        CMP     BL,Keyword
        JNZ     SSESSInvalidOpS
        MOV     BH,BYTE [REXOverride]
        CMP     CL,SSEReg
        JNZ     SSESSInvalidOpS
		CMP		CH, 8
		JB		SSESSMemRegOK
        OR      BH,44h
		MOV     BYTE [REXDisp],1
		AND CH,07h
SSESSMemRegOK:
        SHL     CH,1
        SHL     CH,1
        SHL     CH,1
        OR      BYTE [ModRM],CH
SSESSMemRegTestSize:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      SSESSMemSizeOK
        CMP     AL,BYTE [Temp1]
        JNZ     SSESSInvalidOpSize
SSESSMemSizeOK:
        CALL    WriteOverrides
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     AL,0Fh
        MOV     AH,BYTE [SI][1]
        STOSW        
        CALL    WriteEAData
        JMP     AssembleDone

SSEDouble:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],066h
        INC     DI
        MOV     BYTE [Temp1],_OWORD
        JMP     SSESS2

SSESingle:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        MOV     BYTE [Temp1],_OWORD
        LES     DI,DWORD [OBufferPtr]
        JMP     SSESS2

SSEUnaligned:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        MOV     BYTE ES:[DI],0F3h
        INC     DI
        MOV     BYTE [Temp1],_OWORD
        JMP     SSESS2
SSEShiftNumTooBig:
        JMP     NumTooBig
SSEShiftImm:
        CMP     BL,Num8
        JNZ     SSEShiftNumTooBig        
        OR      DH,0C0h
        LODSB
        AND     AL,7Fh
        OR      AL,70h
        MOV     BH,AL
        OR      DH,BYTE [SI]
        CMP     DL,MMXReg
        JZ     	SSEShiftSSEImm3
        CMP     DL,SSEReg
        JNZ     SSEShiftInvalidOpF
SSEShiftSSEImm:        
        CMP	DH, 8
		JB	SSEShiftSSEImm2
		MOV	BYTE [REXDisp], 1
		MOV	AH, 44h
SSEShiftSSEImm2:
		MOV	AL, 66h
		STOSB
		
		MOV  ES:[DI], AH	;If we have 
		ADD	DI,[REXDisp]
SSEShiftSSEImm3:	
		MOV     AL,0Fh
        MOV     AH,BH
        STOSW
        MOV     AL,DH
        MOV     AH,CL
        STOSW
        JMP     AssembleDone
SSEShift:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        CMP     BH,Number
        JZ      SSEShiftImm
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        CMP     DL,SSEReg
        JZ      SSEShiftXMM
        CMP     DL,MMXReg
        JNZ     SSEShiftInvalidOpF
        CMP     BL,Mem
        JZ      SSEShiftMMMem
        CMP     CL,MMXReg
        JNZ     SSEShiftInvalidOpS
        OR      DH,CH
        OR      DH,0C0h        
        MOV     AL,0Fh
        MOV     AH,BYTE [SI]
        STOSW
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
SSEShiftMMMem:
        OR      BYTE [ModRM],DH
        CALL    WriteOverrides
        MOV     AL,0Fh
        MOV     AH,BYTE [SI]
        STOSW
        CALL    WriteEAData
        JMP     AssembleDone
SSEShiftInvalidOpF:
        JMP     InvalidOperand1
SSEShiftInvalidOpS:
        JMP     InvalidOperand2
SSEShiftInvalidOpSize:
        JMP     InvalidOperandSize
SSEShiftXMM:
	CMP DH, 8
	JB	SSEShiftXMM2
        MOV     BYTE [REXDisp],1
        OR      BYTE [REXOverride],44h
		AND DH, 07h
SSEShiftXMM2:
        MOV     AL,66h
        STOSB
        MOV     BH,BYTE [REXOverride]
        CMP     BL,Mem
        JZ      SSEShiftXMMMem
        CMP     BL,Keyword
        JNZ     SSEShiftInvalidOpS
        CMP     CL,SSEReg
        JNZ     SSEShiftInvalidOpS
		CMP CH, 8
		JB SSEShiftXMMReg2OK
        OR      BH,41h
		MOV	BYTE [REXDisp], 1
SSEShiftXMMReg2OK:
        OR      CH,0C0h
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     AL,0Fh
        MOV     AH,BYTE [SI]
        STOSW
        OR      DH,CH
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
SSEShiftXMMMem:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      SSEShiftXMMMemSizeOK
        CMP     AL,_OWORD
        JNZ     SSEShiftInvalidOpSize
SSEShiftXMMMemSizeOK:
        CALL    WriteOverrides
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        OR      BYTE [ModRM],DH
        MOV     AL,0Fh
        MOV     AH,BYTE [SI]
        STOSW
        CALL    WriteEAData
        JMP     AssembleDone


MOVxPS:
        JMP     AssembleDone
MOVxPD:
        JMP     AssembleDone
