OpenCoff64Format  PROC

	MOV WORD [OutFlags],0300h

	XOR AX,AX
    MOV [cf64RelocPTR],AX
    MOV [cf64SymbolTablePTR],AX
    MOV [cf64StringTablePTR],AX

    MOV WORD [cf64Seg],(cf64Sections)
    MOV [cf64SegAttr],AX
    MOV [cf64SegAttr][2],AX
	MOV BYTE [CurSeg],0FEh
	MOV BYTE [CurSeg][3],0FEh

    MOV WORD [cf64Machine],8664h
    MOV WORD [cf64SizeOptional],0

	MOV	WORD [cf64NumSymbols],0		;Will change
	
    MOV WORD [cf64Character], IMG_32BIT_MACHINE | IMG_BYTES_REVERSED_LO

	MOV WORD [ProgIP],AX
	MOV WORD [ProgIP][2],AX
	MOV WORD [ProgIP][4],AX 						
	MOV WORD [ProgIP][6],AX


;    MOV WORD [cf64StringTableSize],AX
;    MOV WORD [cf64StringTableSize][2],AX

	MOV WORD [SegAlignment],1

	MOV WORD [StrPTR],(FmtParams)
    CALL OpenCoff32GetParam

;OpenCoff64ParamsOK:
    MOV AX,[cf64NumSections]
    XOR DX,DX
    MOV BX,(SIZE PESection)
    MUL BX

    ADD AX,(cf64Sections-cf64Machine)
	ADC	DX,0

    ADD AX,3       ;Align to 4 bytes
	ADC	DX,0

    AND AX,NOT 3

	MOV [FileSize],AX
	MOV	[FileSize][2],DX
    MOV [cf64HeadersSize],AX

	MOV	CX,DX		;Reserve space for headers. We will write it last
	MOV DX,AX
	MOV AL,0

	MOV BX,[OutHandle]
	CALL	FSeek

	CALL	_USE64
	OR  BYTE [ExtMask],SYM_NEEDSRELOC
	
	CMP	BYTE [Pass],1
	JZ	ocf64Done;
	CALL	cf32CopySections
 ocf64Done:

	RET
OpenCoff64Format  ENDP

InitCoff64    PROC

    MOV DI,[cf64Seg]

	MOV AX,[OBufferPTR]
	XOR DX,DX
	ADD AX,[FileSize]
	ADC DX,[FileSize][2]

	PUSH	AX,DX

    MOV BX,4
	CALL	AlignAX
	MOV [DI].pesRawPTR,AX
	MOV [DI][2].pesRawPTR,DX

	POP SI,CX
	SUB AX,CX
	SBB DX,SI
	MOV CX,AX	;its less than 64k, we dont need the high word, its actually less than 3-bytes
	CALL	PaddBytes

	MOV	WORD [cf64ThisSection],0

	CMP BYTE [Pass],1
    JZ  InitCoff64Pass1

 icf64Done:
	RET
InitCoff64Pass1:
    MOV WORD [cf64NumSections],0
    MOV WORD [cf64RelocPTR],0
    OR      BYTE [RefFlags],16
    JMP icf64Done
InitCoff64    ENDP

CloseCoff64File   PROC

    TEST    BYTE [cf64Flags][1],3    ;Is there any reloc
    JNZ cCoff64Reloc
    JMP cCoff64RelocOK

cCoff64Reloc:
    XOR DX,DX
    MOV AL,F_FILEEND		;Get to end of file
    MOV BX,[OutHandle]
    CALL    FSeek

	MOV	CX,[cf64NumSections]	;Adjust the pointer the reloc on the sections.
	TEST	CX,CX
    JZ  cCoff64RelocSectionsOK
    MOV DI,(cf64Sections)
 cCoff64AdjustSectionsRelocPTR:
	CMP	WORD [DI].pesNumReloc,0
	JZ	cCoff64AdjustSectionsRelocPTRNull
	ADD	WORD [DI].pesRelocPTR,AX
	ADC	WORD [DI][2].pesRelocPTR,DX
 cCoff64AdjustSectionsRelocPTRNext:
    ADD DI,(SIZE PESection)
	DEC	CX
	JNZ	cCoff64AdjustSectionsRelocPTR	
    JMP cCoff64RelocSectionsOK
 cCoff64AdjustSectionsRelocPTRNull:

	MOV	WORD [DI].pesRelocPTR,0
	MOV	WORD [DI][2].pesRelocPTR,0
    JMP cCoff64AdjustSectionsRelocPTRNext

 cCoff64RelocSectionsOK:
	
	MOV	SI,[NewHandle]
	TEST	SI,SI
    JZ  cCoff64RelocNewOK
	PUSH	BX
	MOV	DI,[OutHandle]
	CALL	FCopy
	POP BX
cCoff64RelocNewOK:
    MOV BX,[cf64RelocPTR]
    TEST    BX,BX
    JZ  cCoff64RelocOK

	MOV	CX,BX
	PUSH	DS
    XOR DX,DX           ;Write reloc info
	MOV	BX,[OutHandle]
    MOV DS,[cf64RelocSeg]
	CALL	FWrite
	POP DS
 
 cCoff64RelocOK:

	MOV	BX,[OutHandle]		;File size
	CALL	FGetSize

	MOV	CX,[cf64SymbolTablePTR]
	TEST	CX,CX
	JZ	cCoff64SymbolsOK

	MOV	[cf64PTRSymbols],AX			;if there are no symbols, then dont update ptrsymbols
	MOV	[cf64PTRSymbols][2],DX

 cCoff64SymbolCheckStringTableOK:

	MOV	BX,[OutHandle]
    CALL    cf32GetStringTableSize

	PUSH	DS
	MOV	DS,[cf64SymbolTableSeg]

    XCHG    BX,CX   ;BX=symtablsize, we want to write the size of stringtbl there
    MOV WORD [BX],AX
    MOV WORD [BX][2],DX

    XCHG    BX,CX   ;BX=handle,CX=len as before

	ADD	CX,4
	XOR	DX,DX
	CALL	FWrite
	POP	DS
	MOV	CX,[cf64StringTablePTR]
	TEST	CX,CX
	JZ	cCoff64SymbolsOK
	MOV	BX,[OutHandle]
	PUSH	DS
    MOV DS,[cf64StringTableSeg]
	XOR	DX,DX
	CALL	FWrite
	POP	DS

 cCoff64SymbolsOK:
 
	XOR CX,CX
	MOV DX,CX
	MOV AL,2
	MOV BX,[OutHandle]
	CALL	FSeek

	PUSH	AX,DX
    MOV BX,4 		;[cf64FileAlign]
	MOV CX,AX
	MOV SI,DX
	CALL	AlignCX
	SUB CX,AX
	SBB SI,DX
	MOV ES,[DiskOutSeg]
	XOR DI,DI
	MOV AX,DI
	MOV DX,CX
	SHR CX,1
	REP STOSW

	MOV BX,[OutHandle]

	XCHG	CX,DX
	PUSH	DS
	PUSH	ES
	POP DS
	CALL	FWrite
	POP DS
	POP SI,CX
	ADD CX,AX
	ADC SI,0
	ADD [BytesWritten],CX
	ADC [BytesWritten][2],SI
	
;Print headers

	XOR	DX,DX
	MOV	CX,DX
	MOV	AL,0
	CALL	FSeek
	
	MOV SI,(MiscFmt)
    XOR DI,DI
    MOV ES,[DiskOutSeg]
    MOV CX,[cf64HeadersSize]

	REP MOVSB

	MOV [OBufferPTR],DI
	MOV CX,DI
	MOV BX,[OutHandle]
	PUSH	DS
	PUSH	ES
	POP DS
	CALL	FWrite
	POP DS

	MOV	BX,[OutHandle]
	CALL	FGetSize

;Close file

	XOR	BX,BX
	XCHG BX,[OutHandle]

	CALL	FClose
	CALL	PrintOutFile

	RET

CloseCoff64File   ENDP

;;;;;;;;;Called when a segment is opened

Coff64InitSeg PROC

	TEST	BYTE [Temp4],1
    JNZ Coff64InitSegClassOK

    CALL    COFFSectionClass

 Coff64InitSegClassOK:

    MOV DI,[cf64Seg]

	TEST	BYTE [Temp4],2	;AT was specified
    JNZ Coff64InitSegAddrOK
	
	CALL	cf32GetAbsRelocPTR
	MOV	[DI].pesRelocPTR,AX
	MOV	WORD [DI][2].pesRelocPTR,DX

	MOV	AX,[DI].pesRVA
	MOV	DX,[DI][2].pesRVA
	MOV	[ProgIP],AX
	MOV	[ProgIP][2],DX
	XOR	AX,AX
	MOV	[ProgIP][4],AX
	MOV	[ProgIP][6],AX

 Coff64InitSegAddrOK:
	XOR	AX,AX
	XOR	DX,DX

	MOV	WORD [DI].pesNumReloc,0

    MOV	AX,[cf64ThisSection]
    MOV	[ProgIP][-2],AX
	
	INC	WORD [cf64ThisSection]
	CALL	cf32CopySectionToSymbolTable

    MOV AX,[OBufferPTR]
    XOR DX,DX

    ADD AX,[FileSize]
    ADC DX,[FileSize][2]

    MOV [DI].pesRawPTR,AX
    MOV [DI][2].pesRawPTR,DX

    TEST    [cf64Flags],0F0h
    JNZ Coff64InitSegOK
 Coff64DefaultCode:
	MOV	WORD [DI].pesCharacter,20h
	MOV	WORD [DI][2].pesCharacter,60h
    OR  BYTE [cf64Flags],40h  ;This is code
 Coff64InitSegOK:
	
	CMP	BYTE [Pass],1
    JNZ Coff64InitDone
    INC WORD [cf64NumSections]

 Coff64InitDone:
	RET
Coff64InitSeg ENDP

;;;;;;;Called when a segment is closed

CloseCoff64Seg    PROC
	MOV     DI,WORD [OBufferPtr]
    CALL    WriteUninitData
    MOV DI,[cf64Seg]

	MOV	AX,[OBufferPTR]
	XOR	DX,DX

	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]    ;Calc section PTR from file start (BYTE 0)

    SUB AX,[DI].pesRawPTR   ;SUB section start PTR to get section SIZE
    SBB DX,[DI][2].pesRawPTR

    XOR BX,BX       ;Make it zero for future use

    CMP WORD [DI].pesRawPTR,BX  ;if zero
    JZ  cCoff64CheckIfValidSection

    TEST WORD [cf64Flags],0F0h
    JZ  cCoff64Ret

 cCoff64SectionOK:

    MOV [DI].pesVirtualSize,BX
    MOV [DI][2].pesVirtualSize,BX

 CloseCoff64SegOK:

    MOV CX,AX
    MOV SI,DX

    MOV BX,4
    CALL    AlignCX

    MOV [DI].pesRawSize,CX  ;Write section SIZE, aligned.
    MOV [DI][2].pesRawSize,SI
    TEST    SI,SI
    JNZ CloseCoff64SegSizeOK
    TEST    CX,CX
    JNZ CloseCoff64SegSizeOK
    MOV [DI].pesRawPTR,CX
    MOV [DI][2].pesRawPTR,CX

 CloseCoff64SegSizeOK:

    PUSH    CX,SI
    SUB CX,AX
    SBB SI,DX
    CALL    PaddBytes   ;CX=Num
    POP DX,AX
	
	ADD	DI,(SIZE PESection)
    MOV [cf64Seg],DI

	MOV	AX,[OBufferPTR]
	XOR	DX,DX

	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]    ;Calc section PTR from file start (BYTE 0)

	MOV	[DI].pesRawPTR,AX
	MOV	[DI][2].pesRawPTR,DX

    AND WORD [cf64Flags],0CF0Fh

	JMP	cCoff64Ret

 cCoff64CheckIfValidSection:

    CMP WORD [DI][2].pesRawPTR,DX
    JNZ cCoff64SectionOK

 cCoff64Ret:
    RET

CloseCoff64Seg    ENDP

;;;;;Record Reloc information

Coff64Reloc   PROC
	CALL	cf32CheckRelocMemory
	PUSH	ES,SI,DI
	MOV	AX,DI
	MOV	DI,[cf64Seg]
	SUB	AX,[DiskOutStart]
	XOR	DX,DX
	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]
	SUB	AX,[DI].pesRawPTR
	SBB	DX,[DI][2].pesRawPTR

	INC	[DI].pesNumReloc
	
	OR	BYTE [cf64Flags][1],3
	
	LES	DI,[cf64RelocPTR]
	STOSW		;RVA
	MOV	AX,DX
	STOSW
	
	MOV	AX,[RelocData]
	STOSW
	XOR	AX,AX
	STOSW

	TEST	BYTE [RelocFlags],RELOC_RELATIVE
	SETNZ	AL
	MOV	DX,AX	;AX =1 if relative
	XOR	DX,1	;DX =1 if not relative
	DEC	AX		;If relative, AX = 0, if not relative AX = 0FFFF
	DEC	DX		;if not relative DX = 0, if relative DX = FFFF
	AND	AX,IMAGE_REL_I386_DIR32		;between AX and DX, one of them is 0 the other is FFFF
	AND	DX,IMAGE_REL_I386_REL32		;We and to make the FFFF one either IMAGE_REL_I386_DIR32 or IMAGE_REL_I386_REL32

	OR	AX,DX
	STOSW
	MOV	BYTE [RelocFlags],0
	MOV	[cf64RelocPTR],DI
 cf64RelocDone:
	POP	DI,SI,ES
	RET
Coff64Reloc   ENDP

EndCoff64 PROC
        RET
EndCoff64 ENDP

;;;;;;;;;Record a public variable
PublicCoff64	PROC
	CALL	cf32CheckSymbolTableMemory
	LES	DI,[cf64SymbolTablePTR]
	MOV	BX,[cf64Seg]

    LODSW
    MOV CX,AX
	MOV	DX,8
    CMP CX,DX   ;CX<8
	JBE	PublicCoff64CopyName

	CALL	cf32CheckStringTableMemory
    CALL    cf32GetStringTableSize

    PUSH    AX,DX
    PUSH    SI,DI,ES
    LES DI,[cf64StringTablePTR] ;Copy the name to symbol string table
	AND	CX,3Fh
	REP	MOVSB
	MOV	AL,0
	STOSB
	XCHG	[cf64StringTablePTR],DI
    POP ES,DI,SI

	XOR	AX,AX
	STOSW
	STOSW

    POP DX,AX
	STOSW
    MOV AX,DX
	STOSW
	JMP	PublicCoff64NameOK
 PublicCoff64CopyName:
	SUB	DX,CX
	REP	MOVSB
	MOV	AL,0
	MOV	CX,DX
	REP	STOSB

 PublicCoff64NameOK:

	MOV	AX,[ProgIP]
	MOV	DX,[ProgIP][2]

	STOSW
	MOV	AX,DX
	STOSW
	
	MOV	AX,[cf64ThisSection]	;Current section
	STOSW
	XOR	AX,AX
	STOSW
	
	MOV	AX,IMAGE_SYM_CLASS_EXTERNAL
	STOSB
	
	MOV	AL,0
	STOSB
	MOV	[cf64SymbolTablePTR],DI
	
	INC [cf64NumSymbols]
    RET
PublicCoff64	ENDP

;;;;;;;;;;;;;Record an external variable
ExternCOFF64    PROC
	CALL	cf32CheckSymbolTableMemory
	LES	DI,[cf64SymbolTablePTR]
	MOV	BX,[cf64Seg]

;    LODSW
    MOV CL,AL
    MOV CH,0

	MOV	DX,8
    CMP CX,DX   ;CX<8
    JBE ExternCoff64CopyName

    CALL    cf32GetStringTableSize
    PUSH    AX,DX
    PUSH    SI,DI,ES
	CALL	cf32CheckStringTableMemory
	LES	DI,[cf64StringTablePTR]
	AND	CX,3Fh
	REP	MOVSB
	MOV	AL,0
	STOSB
	XCHG	[cf64StringTablePTR],DI
    POP ES,DI,SI
	XOR	AX,AX
	STOSW
	STOSW
    POP DX,AX
	STOSW
    MOV AX,DX
	STOSW
    JMP ExternCoff64NameOK

ExternCoff64CopyName:

	SUB	DX,CX
	REP	MOVSB
	MOV	AL,0
	MOV	CX,DX
	REP	STOSB

ExternCoff64NameOK:

    XOR AX,AX
    STOSW       ;Value
    STOSW       ;Value High

    STOSW       ;Section number
	
    XOR AX,AX   ;Type
	STOSW
	
	MOV	AX,IMAGE_SYM_CLASS_EXTERNAL
	STOSB
	
	MOV	AL,0
	STOSB
	MOV	[cf64SymbolTablePTR],DI

	MOV	AX,[cf64NumSymbols]
	XOR	DX,DX
	INC [cf64NumSymbols]	
    RET
ExternCOFF64    ENDP
