SSE_AVX5_R_RxM32_WriteMask_Z:
	MOV	BYTE [Temp2], _DWORD
	JMP	SSE_AVX5_R_RxM32_WriteMask_Common

SSE_AVX5_R_RxM64_WriteMask_Z:
	MOV	BYTE [Temp2], _QWORD
	JMP	SSE_AVX5_R_RxM32_WriteMask_Common

SSE_AVX5_R_RxMxM32_WriteMask_Z:
	MOV	BYTE [Temp2], _DWORD
	JMP	SSE_AVX5_R_RxM32_WriteMask_Common

SSE_AVX5_R_RxM32_WriteMask_Common:
	MOV BYTE [ExpectMaskReg], 1
SSE_R_RM_AVX5_R_R_RM_Instr:
	PUSH	BX
	CALL	GetTwoOperands
	POP	DI
	
	CMP	AL, Keyword
	JNZ	SSE_R_RM_AVX5_R_R_RM_Instr_InvalidOpF
	
	CMP BL, Keyword
	JNZ	SSE_R_RM_AVX5_R_R_RM_Instr_InvalidOpS
	
	CMP	CL, BL
	JNZ SSE_R_RM_AVX5_R_R_RM_Instr_InvalidOpS

	CMP	DL, SSEReg
	JZ	SSE_R_RM_AVX5_R_R_RM_Instr_VEX128
	
	CMP	DL, AVXReg
	JZ	SSE_R_RM_AVX5_R_R_RM_Instr_VEX256
	
	CMP	DL, AVX512Reg
	JNZ	SSE_R_RM_AVX5_R_R_RM_Instr_InvalidOpF
	
SSE_R_RM_AVX5_R_R_RM_Instr_EVEX512:
	
	CMP	CL, DL
	JNZ	SSE_R_RM_AVX5_R_R_RM_Instr_InvalidOpS
	