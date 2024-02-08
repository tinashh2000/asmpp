AVX_R128_R128M64_Instr_Double:
	MOV	BYTE [SSERegDisp], 1
	MOV BYTE [ExpectedMemSize], 64
	JMP	AVX_R128_R128M32_Instr_1
	
AVX_R128_R128M32_Instr:
	MOV	BYTE [SSERegDisp], 1
	MOV BYTE [ExpectedMemSize], 32	
AVX_R128_R128M32_Instr_1:
	CALL	GetOperand
	JMP	NotCoded
	JMP	AssembleDone
	

SSE_R_RM_AVX5_R_R_RM_Instr_Double:
	MOV	BYTE [SSERegDisp], 1
	JMP SSE_R_RM_AVX5_R_R_RM_Instr_1
SSE_R_RM_AVX5_R_R_RM_Instr:
	MOV	BYTE [SSERegDisp], 0
SSE_R_RM_AVX5_R_R_RM_Instr_1:
	PUSH    BX
	CALL    GetTwoOperands
	POP     SI
	CMP     AL,Keyword
	JNZ     SSE_R_RM_AVX5_R_R_RM_InvalidOpF
	LES     DI,DWORD [OBufferPtr]
	MOV	BYTE ES:[DI], 66h
	ADD DI, [SSERegDisp]
	MOV     BYTE [Temp1],_OWORD		
	JMP	NotCoded
	
	
SSE_M64_R_Instr:
	MOV	BYTE [SSERegDisp], 1
	JMP SSE_M64_R_Instr_1
SSE_M64_R_Instr:
	MOV	BYTE [SSERegDisp], 1
SSE_M64_R_Instr_1:
	PUSH    BX
	CALL    GetTwoOperands
	POP     SI
	CMP     AL,Mem
	JNZ     SSE_M64_R_Instr_InvalidOpF

	LES     DI,DWORD [OBufferPtr]
	MOV	BYTE ES:[DI], 66h
	ADD DI, [SSERegDisp]
	MOV     BYTE [Temp1],_OWORD		
	JMP	NotCoded

SSE_R_R_Instr_Double:
	MOV	BYTE [SSERegDisp], 1
	JMP SSE_R_R_Instr_1
SSE_R_R_Instr_Single:
	MOV	BYTE [SSERegDisp], 0
SSE_R_R_Instr_1:	
	PUSH    BX
	CALL    GetTwoOperands
	POP     SI
	CMP     AL,Keyword
	JNZ     SSE_R_R_Instr_InvalidOpF
	CMP		BL, Keyword
	JNZ     SSE_R_R_Instr_InvalidOpF

	SHL     DH,1
	SHL     DH,1
	SHL     DH,1
	MOV     BH,BYTE [REXOverride]

	CMP     DL,SSEReg
	JNZ     SSE_R_RM_Instr_InvalidOpF

	CMP	DH, 8
	JB	SSE_R_R_Instr_Reg1OK
	OR  BH,44h
	MOV BYTE [REXDisp],1
	AND DH, 07h
SSE_R_R_Instr_Reg1OK:

	CMP     CL,SSEReg
	JNZ     SSE_R_RM_Instr_InvalidOpF

	CMP	CH, 8
	JB	SSE_R_R_Instr_Reg2OK
	OR  BH,41h
	MOV BYTE [REXDisp],1
	AND CH, 07h
SSE_R_R_Instr_Reg2OK:

	MOV	BYTE ES:[DI], 66h
	ADD DI, [SSERegDisp]
	
	MOV     BYTE ES:[DI],BH
	ADD     DI,WORD [REXDisp]
	
	OR      DH,CH
	OR      DH,0C0h

	PUSH CX	;Save
	LODSB		;Number of bytes to copy
	MOV	CL, AL	;Put in counter
	MOV CH, 0
	REPNZ MOVSB	;Copy them CX times
	POP CX		

	MOV     AL,DH
	STOSB
	JMP     AssembleDone
