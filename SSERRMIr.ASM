SSE_R_RM_Imm8_Instr_Double:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSE_R_RM_Imm8_Instr_InvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,66h
        STOSB
        MOV     BYTE [Temp1],_OWORD
        JMP     SSE_R_RM_Imm8_Instr_Common
SSE_R_RM_Imm8_Instr_InvalidOpF:
        JMP     InvalidOperand1
SSE_R_RM_Imm8_Instr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSE_R_RM_Imm8_Instr_InvalidOpF
        MOV     BYTE [Temp1],_OWORD
SSE_R_RM_Imm8_Instr_Single2:
        LES     DI,DWORD [OBufferPtr]
SSE_R_RM_Imm8_Instr_Common:
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        MOV     BH,BYTE [REXOverride]
        CMP     DL,SSEReg
        JNZ     SSE_R_RM_Imm8_Instr_InvalidOpF
		CMP	DH, 8
		JB SSE_R_RM_Imm8_Instr_RegOK
        OR      BH,44h
        MOV     BYTE [REXDisp],1
		AND DH, 07h
SSE_R_RM_Imm8_Instr_RegOK:
        CMP     BL,Mem
        JZ      SSE_R_RM_Imm8_Instr_RegMem
		
        CMP     CL,SSEReg
        JNZ     SSE_R_RM_Imm8_Instr_InvalidOpF
		CMP		CH, 8
		JB		SSE_R_RM_Imm8_Instr_RegsOK
		
        OR      BH,41h
        MOV     BYTE [REXDisp],1

SSE_R_RM_Imm8_Instr_RegsOK:
        OR      DH,CH
        OR      DH,0C0h

        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
	
		PUSH CX	;Save
		LODSB		;Number of bytes to copy
        MOV	CL, AL	;Put in counter
		MOV CH, 0
		REPNZ MOVSB	;Copy them CX times
		POP CX		
        MOV     AL,DH
        STOSB

SSE_R_RM_Imm8_Instr_FixNumber:
		
		MOV	[OBufferPtr], DI
        CALL    GetOperand
			
        CMP     AH,Number
        JNZ     SSE_R_RM_Imm8_Instr_InvalidOpF
        CMP     AL,Num8
        JA      SSE_R_RM_Imm8_Instr_NumTooBig	
		
		LES DI,[OBufferPtr]
		
		MOV	AL,DL
		STOSB
        JMP     AssembleDone
SSE_R_RM_Imm8_Instr_NumTooBig:
		JMP		NumTooBig
		
SSE_R_RM_Imm8_Instr_InvalidOpSize:
        JMP		InvalidOperandSize

SSE_R_RM_Imm8_Instr_RegMem:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      SSE_R_RM_Imm8_Instr_RegMemOpSizeOK
        CMP     AL,BYTE [Temp1]
        JNZ     SSE_R_RM_Imm8_Instr_InvalidOpSize
SSE_R_RM_Imm8_Instr_RegMemOpSizeOK:
        OR      BYTE [ModRM],DH
        CALL    WriteOverrides
		
		PUSH CX	;Save
		LODSB		;Number of bytes to copy
        MOV	CL, AL	;Put in counter
		MOV CH, 0
		REPNZ MOVSB	;Copy them CX times
		POP CX
        CALL    WriteEAData
        JMP     AssembleDone

