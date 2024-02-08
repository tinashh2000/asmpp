SSE_R_RM_Instr_Double:		
		MOV		BYTE [Addr32Disp], 1
        MOV     BYTE [Temp1],_OWORD
        JMP     SSE_R_RM_Instr_Common
SSE_R_RM_Instr_InvalidOpF:
        JMP     InvalidOperand1
SSE_R_RM_Instr_Single:
		MOV		BYTE [Addr32Disp], 0		
        MOV     BYTE [Temp1],_OWORD
SSE_R_RM_Instr_Common:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSE_R_RM_Instr_InvalidOpF
        LES     DI,DWORD [OBufferPtr]

        MOV     BH,BYTE [REXOverride]
		
        CMP     DL,SSEReg
        JNZ     SSE_R_RM_Instr_InvalidOpF
		CMP		DH, 8
		JB		SSE_R_RM_Instr_RegOK
        OR      BH,44h
        MOV     BYTE [REXDisp],1
		AND		DH,07h
SSE_R_RM_Instr_RegOK:

        SHL     DH,1
		SHL     DH,1
        SHL     DH,1
		
        CMP     BL,Mem
        JZ      SSE_R_RM_Instr_RegMem

        CMP     CL,SSEReg
        JNZ     SSE_R_RM_Instr_InvalidOpF
		CMP		CH, 8
		JB		SSE_R_RM_Instr_RegsOK
		
        OR      BH,41h
        MOV     BYTE [REXDisp],1
		AND CH, 07h
SSE_R_RM_Instr_RegsOK:

        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]

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
SSE_R_RM_Instr_RegMem:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      SSE_R_RM_Instr_RegMemOpSizeOK
        CMP     AL,BYTE [Temp1]
        JNZ     SSE_R_RM_Instr_InvalidOpSize
SSE_R_RM_Instr_RegMemOpSizeOK:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]

        OR      BYTE [ModRM],DH
        CALL    WriteOverrides

        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]

		PUSH CX	;Save
		LODSB		;Number of bytes to copy
        MOV	CL, AL	;Put in counter
		MOV CH, 0
		REPNZ MOVSB	;Copy them CX times
		POP CX		

        CALL    WriteEAData
        JMP     AssembleDone

SSE_R_RM_Instr_InvalidOpSize:
        JMP     InvalidOperandSize
