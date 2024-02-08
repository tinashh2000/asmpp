SSE_R_RM_Instr_Dbl:	;Double puts a 66h override
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSE_R_RM_Instr_InvalidOpF
        LES     DI,DWORD [OBufferPtr]
        MOV     AL,66h
        STOSB
        MOV     BYTE [Temp1],_OWORD
        JMP     SSE_R_RM_Instruction2
SSE_R_RM_Instr_InvalidOpF:
        JMP     InvalidOperand1

SSE_R_RM_Instr_Sngl:	;Single doesnt add a 66h override
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     SSE_R_RM_Instr_InvalidOpF
        MOV     BYTE [Temp1],_OWORD
SSE_R_RM_Instr_Sngl_1:
        LES     DI,DWORD [OBufferPtr]
SSE_R_RM_Instruction2:
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        MOV     BH,BYTE [REXOverride]
        CMP     DL,SSEReg
        JZ      SSE_R_RM_Instruction_RegOK
        CMP     DL,SSE2Reg
        JNZ     SSE_R_RM_Instruction_InvalidOpF
        OR      BH,44h
        MOV     BYTE [REXDisp],1
SSE_R_RM_Instruction_RegOK:
        CMP     BL,Mem
        JZ      SSE_R_RM_Instruction_PSRegMem
        OR      DH,CH
        OR      DH,0C0h
        CMP     DL,SSEReg
        JZ      SSE_R_RM_Instruction_RegsOK
        OR      BH,41h
SSE_R_RM_Instruction_RegsOK:
        MOV     BYTE ES:[DI],BH
        ADD     DI,WORD [REXDisp]
        MOV     AL,0Fh
        STOSB
		
		PUSH CX	;Save
		LODSB		;Number of bytes to copy
        MOV	CL, AL	;Put in counter
		MOV CH, 0
		REPNZ MOVSB	;Copy them CX times
		POP CX
		
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
SSE_R_RM_Instruction_RegMem:
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      SSE_R_RM_Instruction_RegMemOpSizeOK
        CMP     AL,BYTE [Temp1]
        JNZ     SSE_R_RM_Instruction_InvalidOpSize
SSE_R_RM_Instruction_RegMemOpSizeOK:
        OR      BYTE [ModRM],DH
        CALL    WriteOverrides
        MOV     AL,0Fh
        STOSB
		
		PUSH CX	;Save
		LODSB		;Number of bytes to copy
        MOV	CL, AL	;Put in counter
		MOV CH, 0
		REPNZ MOVSB	;Copy them CX times
		POP CX		

        CALL    WriteEAData
        JMP     AssembleDone
SSE_R_RM_Instruction_InvalidOpSize:
        JMP     InvalidOperandSize

