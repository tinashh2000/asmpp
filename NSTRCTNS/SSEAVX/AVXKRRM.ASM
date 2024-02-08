;****************************************************************************************
;* The African Assembler Copyright (C) 2006 - 2024 Tinashe Mutandagayi                  *
;*                                                                                      *
;* This file is part of the African Assembler source code. The author(s) of this file 	*
;* is/are not liable for any damages, loss or loss of information, deaths, sicknesses   *
;* or other bad things resulting from use of this file or software, either direct or    *
;* indirect.                                                                            *
;* Terms and conditions for use and distribution can be found in the license file named *
;* LICENSE.TXT. If you distribute this file or continue using it,                       *
;* it means you understand and agree with the terms and conditions in the license file. *
;* binding this file.                                                                   *
;*                                                                                      *
;* Happy Coding :)                                                                      *
;****************************************************************************************

echo (7 * 6 + 8)

SIZE_OF_AVX_PARAM_ENTRY equ 6
AVX_PARAM_NUM_ENTRIES   EQU 7
AVX_ERROR_HANDLING_SAE	EQU	80h

AVX_ERROR_HANDLING_SAE_RNE	EQU	1
AVX_ERROR_HANDLING_SAE_RD	EQU	2
AVX_ERROR_HANDLING_SAE_RU	EQU	3
AVX_ERROR_HANDLING_SAE_RZ	EQU	4


SIMD_Custom_Instr:

	MOV AX, (ParamsData)
	CALL AVX_GetParams, AX

	CALL PrintLF
	CALL PrintLF

	MOV AL, [ParamsData].avxNumParams
    MOV AH, 0
	CALL PrintHexWord

	MOV AL, 32
	CALL PrintChar

	MOV AX, [ParamsData].avxPType_1
	MOV DX, [ParamsData].avxPValue_1

    LEA BX, [ParamsData].avxPType_1
    MOV CL, [ParamsData].avxNumParams
    CMP CL, 0
    JZ SIMD_Custom_Instr_Got_Done

PUSHAD
CALL _PrintChar, WORD (':')
MOVZX AX, BYTE [ParamsData].avxCommas
MOV DX, 0
CALL PrintBin
CALL _PrintLF
POPAD

SIMD_Custom_Instr_Got_Loop:

    CALL _PrintHex, WORD [BX]
    CALL _PrintChar, WORD (' ')
    CALL _PrintHex, WORD [BX][2]
    CALL _PrintChar, WORD (',')
    CALL _PrintChar, WORD (' ')
	ADD BX, 6

    DEC CL
    JNZ SIMD_Custom_Instr_Got_Loop

SIMD_Custom_Instr_Got_Done:
    
SIMD_Custom_Instr_Finish:	
    LES     DI,[OBufferPtr]
    int 3
	JMP AssembleDone





AVX_R_R_RM_Imm8_AVX5_km_R_RxMxM64_Imm8_Instr_Double:
    int 3
	
	MOV AX, (ParamsData)
	CALL AVX_GetParams, AX

	CALL PrintLF
	CALL PrintLF

	MOV AL, [ParamsData].avxNumParams
    MOV AH, 0
	CALL PrintHexWord

	MOV AL, 32
	CALL PrintChar

	MOV AX, [ParamsData].avxPType_1
	MOV DX, [ParamsData].avxPValue_1

    LEA BX, [ParamsData].avxPType_1
    MOV CL, [ParamsData].avxNumParams
    CMP CL, 0
    JZ AVX_Got_Done

PUSHAD
CALL _PrintChar, WORD (':')
MOVZX AX, BYTE [ParamsData].avxCommas
MOV DX, 0
CALL PrintBin
CALL _PrintLF
POPAD

AVX_Got_Loop:

    CALL _PrintHex, WORD [BX]
    CALL _PrintChar, WORD (' ')
    CALL _PrintHex, WORD [BX][2]
    CALL _PrintChar, WORD (',')
    CALL _PrintChar, WORD (' ')
	ADD BX, 6

    DEC CL
    JNZ AVX_Got_Loop

AVX_Got_Done:
    
AVX_R_R_RM_Imm8_AVX5_km_R_RxMxM64_Imm8_Instr_Double_Finish:	
    LES     DI,[OBufferPtr]
    int 3
	JMP AssembleDone

AVX_GetParams	PROC	destination:WORD

		PUSH BX, SI, DI
		PUSH DS
		POP ES
        MOV DI, [destination]        
		MOV	CX, (SIZE AVX_PARAMS) /2        
        XOR AX,AX
		REP STOSW

        OR      BYTE [Settings][1],5	;We dont want to define unknown symbols
        MOV     BYTE [InstrPresent],0

		MOV BX, (ParamsData)
		LEA DI, [BX].avxPType_1
		MOV [ParamsDest], DI

AVX_GetParams_Loop:

        MOV     BYTE [CommaFlag],0
        MOV     WORD [StrLen],0

CALL _PrintLF
CALL _PrintChar, WORD ('$')
CALL _PrintInt, WORD [LineNumber]

PUSHAD
PUSH DS
CALL _PrintChar, WORD ('(')
LDS SI, [InBufferPTR]
MOV CX, 8
CALL PrintStrFixed
CALL _PrintChar, WORD (')')
POP DS
POPAD

PUSHAD
CALL _PrintChar, WORD ('~')
MOVZX AX, BYTE [NextChar]
CALL _PrintHex, AX
CALL _PrintChar, WORD ('~')
POPAD

		CMP BYTE [NextChar], Comma
		JZ	AVX_GetParams_Comma

CALL _PrintChar, WORD ('?')
        CMP BYTE [NextChar], Char0A
        ;JZ AVX_GetParams_Done_1

CALL _PrintChar, WORD ('|')

        PUSH BP
        CALL    GetOperand
        POP BP

PUSHAD
CALL _PrintLF
CALL _PrintChar, WORD ('/')
CALL _PrintHex32, AX, DX
CALL _PrintChar, WORD ('/')
CALL _PrintLF
POPAD

		CMP AL, OpenCBracket
		JZ	AVX_GetParams_CurlyBracket
		CMP	AL, Keyword
		JZ AVX_GetParams_Keyword
        CMP AL, Mem
        JZ AVX_GetParams_Mem
        CMP AH, Number
        JZ AVX_GetParams_Number
        CMP	WORD [StrLen],0
        JZ	AVX_GetParams_1
		JMP  AVX_GetParams_Alpha
AVX_GetParams_1:
CALL _PrintChar, WORD ('_')
    CMP AL,EndOfLine
    JZ  AVX_GetParams_Done_1
CALL _PrintChar, WORD ('=')
        JMP AVX_GetParams_Done_1
AVX_GetParams_Keyword:
		JMP AVX_GetParams_Write_1

AVX_GetParams_Mem:
    MOV DL, [OperandSize]
    JMP AVX_GetParams_Write_1

AVX_GetParams_Too_Many_Ops:
    JMP manyoperands

AVX_GetParams_Number:    

AVX_GetParams_Write_1:
	MOV BX, [destination]
    CMP BYTE [BX].avxNumParams, AVX_PARAM_NUM_ENTRIES
    JAE AVX_GetParams_Too_Many_Ops

	MOV DI, [ParamsDest]
	MOV [DI], AX	
	MOV [DI][2], DX
	XOR AX,AX
	MOV [DI][4], AX
	ADD DI, SIZE_OF_AVX_PARAM_ENTRY
	INC BYTE [BX].avxNumParams

PUSHAD
CALL _PrintChar, WORD('!')
CALL _PrintHex, WORD [BX].avxNumParams
CALL PrintLF
POPAD

 	MOV [ParamsDest], DI
	JMP	AVX_GetParams_Loop

AVX_GetParams_Comma:
CALL _PrintChar, WORD ('(')
CALL _PrintChar, WORD (',')
CALL _PrintChar, WORD (')')
		INC BYTE [InBufferPTR]	;Move past the comma
	MOV BX, [destination]

        XOR CX,CX 
        XOR AX,AX
        MOV AL, 1
        MOV CL, BYTE [BX].avxNumParams
        SHL AL, CL
        CALL _PrintHex32, AX, CX
        TEST BYTE [BX].avxCommas, AL
        JNZ AVX_GetParams_Comma_Error
        OR BYTE [BX].avxCommas, AL
;		MOV AX, Comma
		XOR DX, DX
        MOV BYTE [NextChar], DL

        PUSH DS, ES, BP
        CALL GetNextCharI
        POP BP, ES, DS

    	JMP	AVX_GetParams_Loop

		JMP AVX_GetParams_Write_1
AVX_GetParams_Comma_Error:
    JMP CommaError

AVX_GetParams_InvalidArgument:
		XOR AX, AX
AVX_GetParams_Done_1:
		POP DI, SI, BX
		RET

AVX_GetParams_CurlyBracket:	;We are expecting something in the syntax {k0} or {sae-rz}
	JMP AVX_GetParams_CurlyBracket_0




AVX_GetParams_Alpha:
	MOV     SI,OFFSET StrBuffer
	CMP WORD [StrLen], 2
	JZ AVX_GetParams_Alpha_Len_2
	CMP WORD [StrLen], 4
	JZ AVX_GetParams_Alpha_Len_4
AVX_GetParams_Alpha_Anon:
	JMP     AVX_GetParams_1
AVX_GetParams_Alpha_Len_2:
	CMP BYTE [StrBuffer], 'k'
	JNZ AVX_GetParams_Alpha_Anon
	MOV AH, [StrBuffer][1]
	SUB AH, '0'
	CMP AH, 7
	JA AVX_GetParams_Alpha_Anon
	MOV AL, AVX_Kx_REG
	XOR DX,DX
	JMP	AVX_GetParams_Write_1

AVX_GetParams_Alpha_Len_4:
	CMP WORD [StrBuffer], 'nb'
	JNZ AVX_GetParams_Alpha_Anon
	CMP BYTE [StrBuffer][2], 'd'
	JNZ AVX_GetParams_Alpha_Anon
    MOV AH, [StrBuffer][3]  ;bnd0 -bnd3
	SUB AH, '0'
	CMP AH, 3
	JA AVX_GetParams_Alpha_Anon
	MOV AL, AVX_BOUND_REG
	XOR DX,DX
	JMP	AVX_GetParams_Write_1

;****************************************************************************************
;* AVX_GetParams_CurlyBracket															*
;* Handles Curly brackets to extract expressions like:									*
;* {sae}, {er}, {k0}{k6} {rn-sae} or {sae-rn}											*
;* It is also permissible to express rounding and error handling as 					*
;*      {rn, sae} or {sae, rn}															*
;****************************************************************************************

AVX_GetParams_CurlyBracket_0:
		CMP WORD [InBufferPTR], 't1'	;1toXX where XX is 2, 4,8 or 16
		JNZ AVX_GetParams_CurlyBracket_1
		JMP AVX_GetParams_CurlyBracket_1toXX
AVX_GetParams_CurlyBracket_1:

        PUSH BP
       	CALL    GetOperand
        POP BP

		CMP	AL,	Alpha
		JNZ	AVX_GetParams_Curly_InvalidArgument

		MOV BX, destination

		MOV SI, (StrBuffer)
		MOV CX, [StrLen]
		CMP CX, 2
		JZ AVX_GetParams_Curly_Len2
		CMP CX, 3
		JZ AVX_GetParams_Curly_Len3
;        CMP CX, 4
;		JZ AVX_GetParams_Curly_Len4
		CMP CX, 1
		JZ AVX_GetParams_Curly_Len1

AVX_GetParams_Curly_InvalidArgument:
		JMP	AVX_GetParams_InvalidArgument

AVX_GetParams_CurlyBracket_Continue:	;On second thoughts -- a hyphen or comma must have already been handled

;	CMP BYTE [NextChar], SubOp
;	JZ	AVX_GetParams_CurlyBracket_Hyphen

;	CMP BYTE [NextChar], Comma
;	JZ	AVX_GetParams_CurlyBracket_Hyphen

AVX_GetParams_CurlyBracket_Continue2:
AVX_GetParams_CurlyBracket_FindClosing: ;We expect a closing brace  
		CMP BYTE [NextChar], CloseCBracket
		JNZ	AVX_GetParams_CurlyBracket_Invalid_Argument
		INC WORD [InBufferPTR]
        MOV BYTE [NextChar], 0
AVX_GetParams_CurlyBracket_Done:
        CALL _PrintChar, WORD ('+')
		JMP AVX_GetParams_Loop

AVX_GetParams_CurlyBracket_Hyphen:
		JMP AVX_GetParams_CurlyBracket_Continue2

AVX_GetParams_Curly_Len3:	;Expect sae
		CMP WORD [StrBuffer], 'as'
		JNZ AVX_GetParams_Curly_Len3_2 
		JMP AVX_GetParams_CurlyBracket_SAE
AVX_GetParams_Curly_Len3_2:		
		JMP	AVX_GetParams_CurlyBracket_Continue


AVX_GetParams_Curly_Len2:	;Its faster to test k0 - k7 directly rather than comparing Crc32
	MOV AX, [SI]
	CMP AX,'re'
	JZ	AVX_GetParams_Curly_TryOther_Len2_er
	CMP AL, 'k'
	JNZ	AVX_GetParams_Curly_TryOther_Len2
	SUB AH, '0'
	CMP AH, 7
	JA AVX_GetParams_Curly_InvalidArgument
	MOV AL, AVX_Kx_MASKREG
AVX_GetParams_CurlyBracket_Write_1:		
	MOV DI, [ParamsDest]
	MOV [DI],AX
;AVX_GetParams_CurlyBracket_Write_2:	

PUSHAD
MOV AL, '@'
CALL PrintChar
CALL PrintLF
POPAD

	MOV BX, [destination]
    CMP BYTE [BX].avxNumParams, AVX_PARAM_NUM_ENTRIES
    JAE AVX_GetParams_CurlyBracket_Too_Many_Ops

	XOR AX,AX
	MOV [DI][2], AX
	MOV [DI][4], AX
	ADD DI, SIZE_OF_AVX_PARAM_ENTRY
;	MOV BX, destination
	INC BYTE [BX].avxNumParams
 	MOV [ParamsDest], DI
	JMP	AVX_GetParams_CurlyBracket_Continue
AVX_GetParams_Curly_TryOther_Len2_er:
	MOV AX, AVX_ERROR_HANDLING_ER
	JMP AVX_GetParams_CurlyBracket_Store_n_FindClosing

AVX_GetParams_CurlyBracket_Too_Many_Ops:
    JMP manyoperands

AVX_GetParams_CurlyBracket_Invalid_Argument:
	JMP AVX_GetParams_InvalidArgument


AVX_Error_Handling_Already_Specified:
	MOV SI, _ErrorHandlingAlreadySpecified
	JMP PrtError

AVX_GetParams_Rounding_Already_Specified:
	MOV SI, _RoundingAlreadySpecified
	JMP PrtError

AVX_GetParams_Curly_Len1:
	CMP BYTE [StrBuffer], 'z'
	JZ	AVX_GetParams_Curly_ZeroMask
	JMP	AVX_GetParams_CurlyBracket_Invalid_Argument
AVX_GetParams_Curly_ZeroMask:
	MOV AL, AVX_Kx_MASKREG
	MOV AH, AVX_ZERO_MASKREG
	CMP BYTE [NextChar], CloseCBracket
	JZ	AVX_GetParams_CurlyBracket_Write_1
	JMP AVX_GetParams_CurlyBracket_Invalid_Argument

AVX_GetParams_Curly_TryOther_Len2:
	MOV AX, [StrBuffer]
	MOV CX, 0
	CMP 	AX,'zr'	;rz
	JZ	AVX_GetParams_Curly_RZ
	CMP 	AX,'nr'	;rn
	JZ	AVX_GetParams_Curly_RN
	CMP 	AX,'ur'	;ru
	JZ	AVX_GetParams_Curly_RU
	CMP 	AX,'dr'	;rd
	JZ	AVX_GetParams_Curly_RD
	JMP AVX_GetParams_CurlyBracket_Invalid_Argument
AVX_GetParams_CurlyBracket_Store_n_FindClosing:

PUSHAD
MOV AL, '!'
CALL PrintChar
CALL PrintLF
POPAD

	MOV BX, [destination]
    CMP BYTE [BX].avxNumParams, AVX_PARAM_NUM_ENTRIES
    JAE AVX_GetParams_CurlyBracket_Too_Many_Ops

	MOV DI, [ParamsDest]
	MOV [DI], AX
	XOR CX,CX
	MOV [DI][2], CX
	MOV [DI][4], CX
	ADD DI, SIZE_OF_AVX_PARAM_ENTRY
	;MOV BX, destination
	INC BYTE [BX].avxNumParams
 	MOV [ParamsDest], DI
	JMP AVX_GetParams_CurlyBracket_FindClosing
AVX_GetParams_Curly_RZ:
	INC CX
AVX_GetParams_Curly_RU:
	INC CX
AVX_GetParams_Curly_RD:
	INC CX
AVX_GetParams_Curly_RN:
	INC CX

	XOR AX, AX ;If AX is FECD then we have SAE expressed as well
AVX_GetParams_Curly_Store_Rounding_Info:
	MOV BX, destination
	TEST BYTE [BX].avxRoundingCtl, 0Fh
	JNZ	AVX_GetParams_Rounding_Already_Specified

	OR BYTE [BX].avxRoundingCtl, CL

	DEC CL

	CMP BYTE [NextChar], SubOp
	JZ	AVX_GetParams_CurlyBracket_RxGetSAE

	CMP AX, 0FECDh
	MOV AH, CL
	MOV AL, AVX_ROUNDING_CTL
	JNZ	AVX_GetParams_CurlyBracket_Store_n_FindClosing
	MOV AL, AVX_SAE_ROUNDING_CTL
	JMP AVX_GetParams_CurlyBracket_Store_n_FindClosing


;****************************************************************************************
;* AVX_GetParams_CurlyBracket_RxGetSAE													*
;* Handles {rx-} type of expressions. Expects something like {rx-sae}, 					*
;****************************************************************************************

AVX_GetParams_CurlyBracket_RxGetSAE:
	INC BYTE [InBufferPTR]
	PUSH CX	;Save the rounding method
    PUSH BP
	CALL GetOperand
    POP BP
	POP CX
	CMP	AL,	Alpha
	JZ AVX_GetParams_CurlyBracket_RxGetSAE_Alpha
	JMP	AVX_GetParams_Curly_InvalidArgument

AVX_GetParams_CurlyBracket_RxGetSAE_Alpha:
	CMP WORD [StrLen], 3
	JZ AVX_GetParams_CurlyBracket_RxGetSAE_2
	JMP AVX_GetParams_Curly_InvalidArgument

AVX_GetParams_CurlyBracket_RxGetSAE_2:
	CMP WORD [StrBuffer], 'as'
	JZ	AVX_GetParams_CurlyBracket_RxGetSAE_3
	JMP	AVX_GetParams_Curly_InvalidArgument

AVX_GetParams_CurlyBracket_RxGetSAE_3:
	CMP BYTE [StrBuffer], 'e'
	JZ AVX_GetParams_CurlyBracket_RxGetSAE_4
	JMP AVX_GetParams_Curly_InvalidArgument

AVX_GetParams_CurlyBracket_RxGetSAE_4:
	MOV BX, destination
	TEST BYTE [BX].avxErrorHandling, AVX_ERROR_HANDLING_SAE
	JZ	AVX_GetParams_CurlyBracket_RxGetSAE_5
	JMP AVX_Error_Handling_Already_Specified
AVX_GetParams_CurlyBracket_RxGetSAE_5:
	OR BYTE [BX].avxErrorHandling, AVX_ERROR_HANDLING_SAE
	MOV AL, AVX_SAE_ROUNDING_CTL
	MOV AH ,CL
	JMP	AVX_GetParams_CurlyBracket_Store_n_FindClosing


;****************************************************************************************
;* AVX_GetParams_CurlyBracket_SAE														*
;* Handles {sae} or {sae-rn} type of expressions										*
;****************************************************************************************

AVX_GetParams_CurlyBracket_SAE:
	CMP BYTE [StrBuffer][2], 'e'
	JZ AVX_GetParams_CurlyBracket_SAE_1
	JMP AVX_GetParams_Curly_Len3_2
AVX_GetParams_CurlyBracket_SAE_1:
	TEST BYTE [BX].avxErrorHandling, AVX_ERROR_HANDLING_SAE
	JZ	AVX_GetParams_CurlyBracket_SAE_2
	JMP AVX_Error_Handling_Already_Specified

AVX_GetParams_CurlyBracket_SAE_2:	
	OR BYTE [BX].avxErrorHandling, AVX_ERROR_HANDLING_SAE
	MOV AX, AVX_SAE_ROUNDING_CTL

	CMP BYTE [NextChar], SubOp
	JZ	AVX_GetParams_CurlyBracket_SAE_GetExtra

	JMP	AVX_GetParams_CurlyBracket_Store_n_FindClosing
AVX_GetParams_CurlyBracket_SAE_GetExtra:
	INC WORD [InBufferPTR]
    PUSH BP
	CALL GetOperand
    POP BP

	CMP AL, Alpha
	JZ  AVX_GetParams_CurlyBracket_SAE_GetExtra_Alpha
	JMP AVX_GetParams_CurlyBracket_Invalid_Argument
AVX_GetParams_CurlyBracket_SAE_GetExtra_Alpha:
	MOV CX, [StrLen]
	CMP CX, 2
	JZ	AVX_GetParams_CurlyBracket_SAE_XX
	JMP AVX_GetParams_CurlyBracket_Invalid_Argument
AVX_GetParams_CurlyBracket_SAE_XX:
	MOV AX, [StrBuffer]
	XOR CX, CX
	CMP AX, 'zr'
	JZ	AVX_GetParams_CurlyBracket_SAE_RZ
	CMP AX, 'ur'
	JZ	AVX_GetParams_CurlyBracket_SAE_RZ
	CMP AX, 'dr'
	JZ	AVX_GetParams_CurlyBracket_SAE_RZ
	CMP AX, 'nr'
	JZ	AVX_GetParams_CurlyBracket_SAE_RZ
AVX_GetParams_CurlyBracket_SAE_RZ:
	INC CX
AVX_GetParams_CurlyBracket_SAE_RU:
	INC CX
AVX_GetParams_CurlyBracket_SAE_RD:
	INC CX
AVX_GetParams_CurlyBracket_SAE_RN:
	INC CX
	CMP BYTE [NextChar], CloseCBracket
	JZ 	AVX_GetParams_CurlyBracket_SAE_Rx_Close
	JMP AVX_GetParams_CurlyBracket_Invalid_Argument
AVX_GetParams_CurlyBracket_SAE_Rx_Close:
	MOV AX, 0FECDh
	JMP AVX_GetParams_Curly_Store_Rounding_Info

;If first 2 chars are 1t
AVX_GetParams_CurlyBracket_1toXX:
	CMP BYTE [InBufferPTR][2], 'o'
	JZ	AVX_GetParams_CurlyBracket_1toXX_1
	JMP AVX_GetParams_CurlyBracket_1
AVX_GetParams_CurlyBracket_1toXX_1:
	ADD WORD [InBufferPTR], 3

    PUSH BP
	CALL GetOperand
    POP BP

	MOV BX,[destination]
	CMP AL, Number
	JZ 	AVX_GetParams_CurlyBracket_1toXX_Num
	JMP AVX_GetParams_Curly_InvalidArgument
AVX_GetParams_CurlyBracket_1toXX_Num:
	CMP AH, Num8
	JA	AVX_GetParams_Curly_InvalidBroadcast
	CMP	DX, 2
	JZ	AVX_GetParams_CurlyBracket_1to2
	CMP	DX, 4
	JZ	AVX_GetParams_CurlyBracket_1to4
	CMP	DX, 8
	JZ	AVX_GetParams_CurlyBracket_1to8
	CMP	DX, 16
	JZ	AVX_GetParams_CurlyBracket_1to16
	CMP	DX, 32
	JZ	AVX_GetParams_CurlyBracket_1to32
	JMP	AVX_GetParams_CurlyBracket_1

AVX_GetParams_CurlyBracket_1to32:
AVX_GetParams_CurlyBracket_1to16:
AVX_GetParams_CurlyBracket_1to8:
AVX_GetParams_CurlyBracket_1to4:
AVX_GetParams_CurlyBracket_1to2:
	TEST BYTE[BX].avxBroadcastSize, 3Fh
	JNZ AVX_GetParams_CurlyBracket_BroadcastSize_Already_Specified
	MOV BYTE[BX].avxBroadcastSize, DL
	MOV AL, AvxBroadcastSize
	MOV AH, DL
	CMP BYTE [NextChar], CloseCBracket
	JZ AVX_GetParams_CurlyBracket_Invalid_Argument_1
	JMP AVX_GetParams_CurlyBracket_1

AVX_GetParams_CurlyBracket_Invalid_Argument_1:
	JMP AVX_GetParams_InvalidArgument

AVX_GetParams_Curly_InvalidBroadcast:
	MOV SI, _InvalidBroadcastSpecifier
	JMP PrtError

AVX_GetParams_CurlyBracket_BroadcastSize_Already_Specified:
	MOV SI, _BroadcastSizeAlreadySpecified
	JMP PrtError

AVX_GetParams ENDP
