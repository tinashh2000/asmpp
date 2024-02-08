
MMX_SSE_R_RxM64__RxM64_R_Instr_DiffSet:	;Use different set if SSE registers are used instead of loading 66h override
	MOV BYTE [Temp2], 0x99	;Don't add 0x66 prefix, instead choose a different set of instruction bytes
MMX_SSE_R_RxM64__RxM64_R_Instr:
	MOV	BYTE [Temp1], _QWORD
	JMP MMX_SSE_R_RM__RM_R_Instr_1
	
MMX_SSE_R_RM__RM_R_Instr:
	MOV	BYTE [Temp1], 0	;Used to determine size. Reset it	
MMX_SSE_R_RM__RM_R_Instr_1:

	MOV BYTE [Temp4], 0	;Assume we are going to get the first set of instruction bytes
	
	PUSH    BX
	CALL    GetTwoOperands
	POP     SI
	LES     DI,DWORD [OBufferPtr]

	MOV BYTE [Temp3], 0
	
	CMP	AL, Mem
	JNZ	MMX_SSE_R_RM__RM_R_Instr_2

	INC BYTE [Temp4]	;We are now getting the alternate set of instructions if first operand is memory
	
	XCHG	AX, BX
	XCHG	CX, DX
	
	MOV	BYTE [Temp3], 1
MMX_SSE_R_RM__RM_R_Instr_2:
	MOV BYTE [REXDisp], 0

	CMP	AL, Keyword
	JNZ	MMX_SSE_R_RM__RM_R_Instr_InvalidOp1
	
	CMP	DL, MMXReg
	JZ	MMX_SSE_R_RM__RM_R_Instr_MemMMX
	
	CMP	DL, SSEReg
	JNZ	MMX_SSE_R_RM__RM_R_Instr_InvalidOp2
	
	CMP	BYTE [Temp1], 0
	JNZ	MMX_SSE_R_RM__RM_R_Instr_Reg1_SizeOK
	
	MOV BYTE [Temp1], _OWORD	
	
 MMX_SSE_R_RM__RM_R_Instr_Reg1_SizeOK:
 
 	CMP BYTE [Temp2], 0x99	
	JNZ	MMX_SSE_R_RM__RM_R_Instr_Use_Override
	
	ADD BYTE [Temp4], 2	;Advance by 2 so that we use a different set of instructions than what we use for mmx.
	JMP MMX_SSE_R_RM__RM_R_Instr_OverrideOK
MMX_SSE_R_RM__RM_R_Instr_Use_Override:	
	MOV	BYTE [Addr32Disp], 1
MMX_SSE_R_RM__RM_R_Instr_OverrideOK:	
	CMP	DH, 8
	JB	MMX_SSE_R_RM__RM_R_Instr_MR_RegOK
	
	MOV BYTE [REXDisp], 1
	OR BYTE [RexOverride], 0x44
	AND DH, 07h
	JMP MMX_SSE_R_RM__RM_R_Instr_MR_RegOK
MMX_SSE_R_RM__RM_R_Instr_MemMMX:
	CMP	BYTE [Temp1], 0
	JNZ	MMX_SSE_R_RM__RM_R_Instr_MR_RegOK
	MOV BYTE [Temp1], _QWORD
MMX_SSE_R_RM__RM_R_Instr_MR_RegOK:
	JMP	MMX_SSE_R_RM__RM_R_Instr_3
	
MMX_SSE_R_RM__RM_R_Instr_InvalidOpSize:
	JMP	InvalidOperandSize
	
MMX_SSE_R_RM__RM_R_Instr_InvalidOp2:
	CMP	BYTE [Temp3], 1
	JE	MMX_SSE_R_RM__RM_R_Instr_InvalidOp1
	JMP	InvalidOperand2
	
MMX_SSE_R_RM__RM_R_Instr_InvalidOp1:
	CMP	BYTE [Temp3], 1
	JE	MMX_SSE_R_RM__RM_R_Instr_InvalidOp2
	JMP	InvalidOperand1
	
MMX_SSE_R_RM__RM_R_Instr_3:
	SHL	DH, 1
	SHL	DH, 1
	SHL	DH, 1
	
	PUSH CX
	MOV AH,0
	MOV CL, [Temp4]
MMX_SSE_R_RM__RM_R_Instr_FindSet:
	CMP CL, 0
	JZ	MMX_SSE_R_RM__RM_R_Instr_FindSet_Done
	MOV	AL, [SI]
	INC AX
	ADD	SI, AX
	DEC CL
	JMP MMX_SSE_R_RM__RM_R_Instr_FindSet
MMX_SSE_R_RM__RM_R_Instr_FindSet_Done:
	POP CX
MMX_SSE_R_RM__RM_R_Instr_4:

	CMP BYTE [SI][1], 0x66
	JNZ MMX_SSE_R_RM__RM_R_Instr_5
;	MOV BYTE [Addr32Disp], 1
MMX_SSE_R_RM__RM_R_Instr_5:
	
	CMP	BL, Mem
	JZ	MMX_SSE_R_RM__RM_R_Instr_Mem
	
	CMP	BL, Keyword
	JNZ MMX_SSE_R_RM__RM_R_Instr_InvalidOp2
	CMP	CL, DL
	JNZ	MMX_SSE_R_RM__RM_R_Instr_InvalidOp2

	CMP	CL, MMXReg
	JZ	MMX_SSE_R_RM__RM_R_Instr_WriteReg
	
	CMP	CL, SSEReg
	JNZ	MMX_SSE_R_RM__RM_R_Instr_InvalidOp2
	
	CMP	CH, 8
	JB MMX_SSE_R_RM__RM_R_Instr_WriteReg
	
	AND CH, 07h
	
	MOV BYTE [REXDisp], 1
	OR BYTE [RexOverride], 0x41
MMX_SSE_R_RM__RM_R_Instr_WriteReg:

	OR      DH,CH
	OR      DH,0C0h

	CALL Write_InstrTable_Bytes	

	MOV     AL,DH
	STOSB

	JMP	AssembleDone
	
MMX_SSE_R_RM__RM_R_Instr_Mem:
	MOV     AL,BYTE [OperandSize]
	TEST    AL,AL
	JZ      MMX_SSE_R_RM__RM_R_Instr_WriteMem
	CMP     AL,BYTE [Temp1]
	JNZ     MMX_SSE_R_RM__RM_R_Instr_InvalidOpSize
MMX_SSE_R_RM__RM_R_Instr_WriteMem:
	MOV     BYTE ES:[DI],66h
	ADD     DI,WORD [Addr32Disp]

	OR      BYTE [ModRM],DH
	CALL    WriteOverrides

	CALL Write_InstrTable_Bytes

	CALL    WriteEAData
	JMP     AssembleDone


Write_InstrTable_Bytes:

	PUSH CX	;Save
	LODSB		;Number of bytes to copy
	MOV	CL, AL	;Put in counter
	MOV CH, 0
	CMP	CL, 2
	JB Write_InstrTable_Bytes_4	;We should have at least 2 bytes to test if there are overrides in the instruction
	CMP BYTE [SI], 066h
	JNZ Write_InstrTable_Bytes_2
	MOVSB
	DEC CX
	JMP Write_InstrTable_Bytes_3

Write_InstrTable_Bytes_2:
	MOV     BYTE ES:[DI],66h
	ADD     DI,WORD [Addr32Disp]
Write_InstrTable_Bytes_3:

	CMP BYTE [SI], 0F3h
	JNZ Write_InstrTable_Bytes_4
	MOVSB
	DEC CX
	
Write_InstrTable_Bytes_4:

	MOV BH, [RexOverride]
	MOV     BYTE ES:[DI],BH		
	ADD     DI,WORD [REXDisp]

	REPNZ MOVSB	;Copy them CX times
	POP CX	
	RET