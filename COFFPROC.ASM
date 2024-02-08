cf32GetStringTableSize  PROC
    MOV AX,[cf32StringTablePTR]
    XOR DX,DX

    ADD AX,4
    ADC DX,0

	ADD	AX,[cf32StringTableStart]		;start ptr
    ADC DX,[cf32StringTableStart][2]
    RET
cf32GetStringTableSize  ENDP

cf32CopySections	PROC
    PUSH    AX,BX,CX,DX,SI,DI

    MOV DX,[cf32NumSections]
    TEST    DX,DX
    JZ  cf32CopyDone

    CALL    cf32CheckSymbolTableMemory
    MOV SI,(cfSections)
    LES DI,[cf32SymbolTablePTR]

    XOR	BX,BX
 icf32CopySections:
    PUSH    SI
    MOV CX,4
    REP MOVSW

    MOV AX,CX
    STOSW
    STOSW       ;Value=0

    INC BX
    MOV AX,BX   ;Section num
    STOSW

    MOV AX,CX   ;Type
    STOSW

    MOV AX,IMAGE_SYM_CLASS_STATIC
    STOSB

    MOV AL,0    ;Num AUX Symbols
    STOSB

    POP SI
    ADD SI,(SIZE PESection)

    DEC DX
    JNZ icf32CopySections
    MOV [cf32SymbolTablePTR],DI
	MOV	[cf32NumSymbols],BX
;	MOV	ES:[0],DI	;Size of string table
	PUSH	DS
	POP	ES
 cf32CopyDone:
    POP DI,SI,DX,CX,BX,AX
	RET
cf32CopySections	ENDP

cf32CopySectionToSymbolTable	PROC
	CMP	BYTE [Pass],1
	JNZ	cf32CopySectionToSymbolTableDone
	
    PUSH    AX,BX,CX,DX,SI,DI
    CALL    cf32CheckSymbolTableMemory
    MOV SI,[cf32Seg]
    LES DI,[cf32SymbolTablePTR]

    XOR	BX,BX

    MOV CX,4
    REP MOVSW

    MOV AX,CX
    STOSW
    STOSW       ;Value=0


    MOV AX,[cf32ThisSection]   ;Section num
    STOSW

    MOV AX,CX   ;Type
    STOSW

    MOV AX,IMAGE_SYM_CLASS_EXTERNAL
    STOSB

    MOV AL,0    ;Num AUX Symbols
    STOSB

    MOV [cf32SymbolTablePTR],DI

	MOV	AX,[cf32NumSymbols]	
	MOV	[cf32ThisSectionSymbolPos],AX

	INC	WORD [cf32NumSymbols]
;	MOV	ES:[0],DI	;Size of string table
	PUSH	DS
	POP	ES

    POP DI,SI,DX,CX,BX,AX
 cf32CopySectionToSymbolTableDone:
	RET

cf32CopySectionToSymbolTable	ENDP

cf32CheckSymbolTableMemory	PROC
	CMP	WORD [cf32SymbolTableSeg],0
	JNZ	cf32CheckSymbolTableMemoryOK
    CMP WORD [cf32StringTablePTR],0
    CMP WORD [cf32StringTableSeg],0
	CALL	cf32AllocateSymbolTableMemory
 cf32CheckSymbolTableMemoryOK:
	CMP	WORD [cf32SymbolTablePTR],32768-100
	JBE	cf32CheckSymbolTableMemoryDone

	MOV	SI,(_SymbolTableOverflow)
	JMP PrtFatalError

 cf32CheckSymbolTableMemoryDone:
	RET
cf32CheckSymbolTableMemory	ENDP

cf32AllocateSymbolTableMemory	PROC
    PUSH    AX,BX
	MOV BX,0800h
	CALL	AllocateMem
	MOV	WORD [cf32SymbolTablePTR],0
	MOV	WORD [cf32SymbolTableSeg],AX	
    JNC cf32AllocateSymbolTableMemoryDone
	JMP	notenoughmemory
cf32AllocateSymbolTableMemoryDone:
    POP BX,AX
	RET
cf32AllocateSymbolTableMemory	ENDP

cf32CheckStringTableMemory	PROC
	CMP	WORD [cf32StringTableSeg],0
	JNZ	cf32CheckStringTableMemoryOK
	CALL	cf32AllocateStringTableMemory
 cf32CheckStringTableMemoryOK:
	CMP	WORD [cf32StringTablePTR],32768-100
	JBE	cf32CheckStringTableMemoryDone

	MOV	SI,(_StringTableOverflow)
	JMP PrtFatalError

 cf32CheckStringTableMemoryDone:
	RET
cf32CheckStringTableMemory	ENDP

cf32AllocateStringTableMemory	PROC
    PUSH    AX,BX
	MOV BX,0800h
	CALL	AllocateMem
	MOV	WORD [cf32StringTablePTR],0
	MOV	WORD [cf32StringTableSeg],AX
    JNC cf32AllocateStringTableMemoryDone
	JMP	notenoughmemory	
cf32AllocateStringTableMemoryDone:
    POP BX,AX
	RET
cf32AllocateStringTableMemory	ENDP

cf32CheckRelocMemory	PROC
	CMP	WORD [cf32RelocSeg],0
	JNZ	cf32CheckRelocMemoryOK
	CALL	cf32AllocateRelocMemory
 cf32CheckRelocMemoryOK:
	CMP	WORD [cf32RelocPTR],65535-100
	JBE	cf32CheckRelocMemoryDone

   MOV SI,(_RelocOverflow)
   JMP PrtFatalError

 cf32CheckRelocMemoryDone:
	OR	BYTE [pe32Flags][1],3		;Reloc information is present
	RET
cf32CheckRelocMemory	ENDP

cf32AllocateRelocMemory	PROC
    PUSH    AX,BX
	MOV BX,01000h
	CALL	AllocateMem
	MOV	WORD [cf32RelocSeg],AX
	MOV	WORD [cf32RelocPTR],0
    JNC cf32AllocateRelocMemoryDone
	JMP	notenoughmemory
cf32AllocateRelocMemoryDone:
    POP BX,AX
	RET
cf32AllocateRelocMemory	ENDP

cf32GetAbsRelocPTR  PROC
	MOV	AX,[cf32RelocPTR]
	XOR	DX,DX
	RET
cf32GetAbsRelocPTR	ENDP

