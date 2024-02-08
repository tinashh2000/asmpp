INCLUDE "COFFPARA.ASM"
INCLUDE "COFFPROC.ASM"

OpenCoff32Format  PROC

	MOV WORD [OutFlags],0300h

	XOR AX,AX
    MOV [cf32RelocPTR],AX
    MOV [cf32SymbolTablePTR],AX
    MOV [cf32StringTablePTR],AX

    MOV WORD [cf32Seg],(cf32Sections)
    MOV [cf32SegAttr],AX
    MOV [cf32SegAttr][2],AX
	MOV BYTE [CurSeg],0FEh
	MOV BYTE [CurSeg][3],0FEh

    MOV WORD [cf32Machine],14Ch
    MOV WORD [cf32SizeOptional],0

	MOV	WORD [cf32NumSymbols],0		;Will change
	
    MOV WORD [cf32Character],IMG_32BIT_MACHINE  | IMG_BYTES_REVERSED_LO

	MOV WORD [ProgIP],AX
	MOV WORD [ProgIP][2],AX
	MOV WORD [ProgIP][4],AX 						
	MOV WORD [ProgIP][6],AX


;    MOV WORD [cf32StringTableSize],AX
;    MOV WORD [cf32StringTableSize][2],AX

	MOV WORD [SegAlignment],1

	MOV WORD [StrPTR],(FmtParams)
    CALL OpenCoff32GetParam

;OpenCoff32ParamsOK:
    MOV AX,[cf32NumSections]
    XOR DX,DX
    MOV BX,(SIZE PESection)
    MUL BX

    ADD AX,(cf32Sections-cf32Machine)
	ADC	DX,0

    ADD AX,3       ;Align to 4 bytes
	ADC	DX,0

    AND AX,NOT 3

	MOV [FileSize],AX
	MOV	[FileSize][2],DX
    MOV [cf32HeadersSize],AX

	MOV	CX,DX		;Reserve space for headers. We will write it last
	MOV DX,AX
	MOV AL,0

	MOV BX,[OutHandle]
	CALL	FSeek

	CALL	_USE32
	OR  BYTE [ExtMask],SYM_NEEDSRELOC
	
	CMP	BYTE [Pass],1
	JZ	ocf32Done;
	CALL	cf32CopySections
 ocf32Done:

	RET
OpenCoff32Format  ENDP

InitCoff32    PROC

    MOV DI,[cf32Seg]

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

	MOV	WORD [cf32ThisSection],0

	CMP BYTE [Pass],1
    JZ  InitCoff32Pass1

 icf32Done:
	RET
InitCoff32Pass1:
    MOV WORD [cf32NumSections],0
    MOV WORD [cf32RelocPTR],0
    OR      BYTE [RefFlags],16
    JMP icf32Done
InitCoff32    ENDP

CloseCoff32File   PROC

    TEST    BYTE [cf32Flags][1],3    ;Is there any reloc
    JNZ cCoff32Reloc
    JMP cCoff32RelocOK

cCoff32Reloc:
    XOR DX,DX
    MOV AL,F_FILEEND		;Get to end of file
    MOV BX,[OutHandle]
    CALL    FSeek

	MOV	CX,[cf32NumSections]	;Adjust the pointer the reloc on the sections.
	TEST	CX,CX
    JZ  cCoff32RelocSectionsOK
    MOV DI,(cf32Sections)
 cCoff32AdjustSectionsRelocPTR:
	CMP	WORD [DI].pesNumReloc,0
	JZ	cCoff32AdjustSectionsRelocPTRNull
	ADD	WORD [DI].pesRelocPTR,AX
	ADC	WORD [DI][2].pesRelocPTR,DX
 cCoff32AdjustSectionsRelocPTRNext:
    ADD DI,(SIZE PESection)
	DEC	CX
	JNZ	cCoff32AdjustSectionsRelocPTR	
    JMP cCoff32RelocSectionsOK
 cCoff32AdjustSectionsRelocPTRNull:

	MOV	WORD [DI].pesRelocPTR,0
	MOV	WORD [DI][2].pesRelocPTR,0
    JMP cCoff32AdjustSectionsRelocPTRNext

 cCoff32RelocSectionsOK:
	
	MOV	SI,[NewHandle]
	TEST	SI,SI
    JZ  cCoff32RelocNewOK
	PUSH	BX
	MOV	DI,[OutHandle]
	CALL	FCopy
	POP BX
cCoff32RelocNewOK:
    MOV BX,[cf32RelocPTR]
    TEST    BX,BX
    JZ  cCoff32RelocOK

	MOV	CX,BX
	PUSH	DS
    XOR DX,DX           ;Write reloc info
	MOV	BX,[OutHandle]
    MOV DS,[cf32RelocSeg]
	CALL	FWrite
	POP DS
 
 cCoff32RelocOK:

	MOV	BX,[OutHandle]		;File size
	CALL	FGetSize

	MOV	CX,[cf32SymbolTablePTR]
	TEST	CX,CX
	JZ	cCoff32SymbolsOK

	MOV	[cf32PTRSymbols],AX			;if there are no symbols, then dont update ptrsymbols
	MOV	[cf32PTRSymbols][2],DX

 cCoff32SymbolCheckStringTableOK:

	MOV	BX,[OutHandle]
    CALL    cf32GetStringTableSize

	PUSH	DS
	MOV	DS,[cf32SymbolTableSeg]

    XCHG    BX,CX   ;BX=symtablsize, we want to write the size of stringtbl there
    MOV WORD [BX],AX
    MOV WORD [BX][2],DX

    XCHG    BX,CX   ;BX=handle,CX=len as before

	ADD	CX,4
	XOR	DX,DX
	CALL	FWrite
	POP	DS
	MOV	CX,[cf32StringTablePTR]
	TEST	CX,CX
	JZ	cCoff32SymbolsOK
	MOV	BX,[OutHandle]
	PUSH	DS
    MOV DS,[cf32StringTableSeg]
	XOR	DX,DX
	CALL	FWrite
	POP	DS

 cCoff32SymbolsOK:
 
	XOR CX,CX
	MOV DX,CX
	MOV AL,2
	MOV BX,[OutHandle]
	CALL	FSeek

	PUSH	AX,DX
    MOV BX,4 		;[cf32FileAlign]
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
    MOV CX,[cf32HeadersSize]

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

CloseCoff32File   ENDP

;;;;;;;;;Called when a segment is opened

Coff32InitSeg PROC

	TEST	BYTE [Temp4],1
    JNZ Coff32InitSegClassOK

    CALL    COFFSectionClass

 Coff32InitSegClassOK:

    MOV DI,[cf32Seg]

	TEST	BYTE [Temp4],2	;AT was specified
    JNZ Coff32InitSegAddrOK
	
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

 Coff32InitSegAddrOK:
	XOR	AX,AX
	XOR	DX,DX

	MOV	WORD [DI].pesNumReloc,0

    MOV	AX,[cf32ThisSection]
    MOV	[ProgIP][-2],AX
	
	INC	WORD [cf32ThisSection]
	CALL	cf32CopySectionToSymbolTable

    MOV AX,[OBufferPTR]
    XOR DX,DX

    ADD AX,[FileSize]
    ADC DX,[FileSize][2]

    MOV [DI].pesRawPTR,AX
    MOV [DI][2].pesRawPTR,DX

    TEST    [cf32Flags],0F0h
    JNZ Coff32InitSegOK
 Coff32DefaultCode:
	MOV	WORD [DI].pesCharacter,20h
	MOV	WORD [DI][2].pesCharacter,60h
    OR  BYTE [cf32Flags],40h  ;This is code
 Coff32InitSegOK:
	
	CMP	BYTE [Pass],1
    JNZ Coff32InitDone
    INC WORD [cf32NumSections]

 Coff32InitDone:
	RET
Coff32InitSeg ENDP

;;;;;;;Called when a segment is closed

CloseCoff32Seg    PROC
	MOV     DI,WORD [OBufferPtr]
    CALL    WriteUninitData
    MOV DI,[cf32Seg]

	MOV	AX,[OBufferPTR]
	XOR	DX,DX

	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]    ;Calc section PTR from file start (BYTE 0)

    SUB AX,[DI].pesRawPTR   ;SUB section start PTR to get section SIZE
    SBB DX,[DI][2].pesRawPTR

    XOR BX,BX       ;Make it zero for future use

    CMP WORD [DI].pesRawPTR,BX  ;if zero
    JZ  cCoff32CheckIfValidSection

    TEST WORD [cf32Flags],0F0h
    JZ  cCoff32Ret

 cCoff32SectionOK:

    MOV [DI].pesVirtualSize,BX
    MOV [DI][2].pesVirtualSize,BX

 CloseCoff32SegOK:

    MOV CX,AX
    MOV SI,DX

    MOV BX,4
    CALL    AlignCX

    MOV [DI].pesRawSize,CX  ;Write section SIZE, aligned.
    MOV [DI][2].pesRawSize,SI
    TEST    SI,SI
    JNZ CloseCoff32SegSizeOK
    TEST    CX,CX
    JNZ CloseCoff32SegSizeOK
    MOV [DI].pesRawPTR,CX
    MOV [DI][2].pesRawPTR,CX

 CloseCoff32SegSizeOK:

    PUSH    CX,SI
    SUB CX,AX
    SBB SI,DX
    CALL    PaddBytes   ;CX=Num
    POP DX,AX
	
	ADD	DI,(SIZE PESection)
    MOV [cf32Seg],DI

	MOV	AX,[OBufferPTR]
	XOR	DX,DX

	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]    ;Calc section PTR from file start (BYTE 0)

	MOV	[DI].pesRawPTR,AX
	MOV	[DI][2].pesRawPTR,DX

    AND WORD [cf32Flags],0CF0Fh

	JMP	cCoff32Ret

 cCoff32CheckIfValidSection:

    CMP WORD [DI][2].pesRawPTR,DX
    JNZ cCoff32SectionOK

 cCoff32Ret:
    RET

CloseCoff32Seg    ENDP

;;;;;Record Reloc information

Coff32Reloc   PROC
	CALL	cf32CheckRelocMemory
	PUSH	ES,SI,DI
	MOV	AX,DI
	MOV	DI,[cf32Seg]
	SUB	AX,[DiskOutStart]
	XOR	DX,DX
	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]
	SUB	AX,[DI].pesRawPTR
	SBB	DX,[DI][2].pesRawPTR

	INC	[DI].pesNumReloc
	
	OR	BYTE [cf32Flags][1],3
	
	LES	DI,[cf32RelocPTR]
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
	MOV	[cf32RelocPTR],DI
 cf32RelocDone:
	POP	DI,SI,ES
	RET
Coff32Reloc   ENDP

EndCoff32 PROC
        RET
EndCoff32 ENDP

;;;;;;;;;Record a public variable
PublicCoff32	PROC
	CALL	cf32CheckSymbolTableMemory
	LES	DI,[cf32SymbolTablePTR]
	MOV	BX,[cf32Seg]

    LODSW
    MOV CX,AX
	MOV	DX,8
    CMP CX,DX   ;CX<8
	JBE	PublicCoff32CopyName

	CALL	cf32CheckStringTableMemory
    CALL    cf32GetStringTableSize

    PUSH    AX,DX
    PUSH    SI,DI,ES
    LES DI,[cf32StringTablePTR] ;Copy the name to symbol string table
	AND	CX,3Fh
	REP	MOVSB
	MOV	AL,0
	STOSB
	XCHG	[cf32StringTablePTR],DI
    POP ES,DI,SI

	XOR	AX,AX
	STOSW
	STOSW

    POP DX,AX
	STOSW
    MOV AX,DX
	STOSW
	JMP	PublicCoff32NameOK
 PublicCoff32CopyName:
	SUB	DX,CX
	REP	MOVSB
	MOV	AL,0
	MOV	CX,DX
	REP	STOSB

 PublicCoff32NameOK:

	MOV	AX,[ProgIP]
	MOV	DX,[ProgIP][2]

	STOSW
	MOV	AX,DX
	STOSW
	
	MOV	AX,[cf32ThisSection]	;Current section
	STOSW
	XOR	AX,AX
	STOSW
	
	MOV	AX,IMAGE_SYM_CLASS_EXTERNAL
	STOSB
	
	MOV	AL,0
	STOSB
	MOV	[cf32SymbolTablePTR],DI
	
	INC [cf32NumSymbols]
    RET
PublicCoff32	ENDP

;;;;;;;;;;;;;Record an external variable
ExternCOFF32    PROC
	CALL	cf32CheckSymbolTableMemory
	LES	DI,[cf32SymbolTablePTR]
	MOV	BX,[cf32Seg]

;    LODSW
    MOV CL,AL
    MOV CH,0

	MOV	DX,8
    CMP CX,DX   ;CX<8
    JBE ExternCoff32CopyName

    CALL    cf32GetStringTableSize
    PUSH    AX,DX
    PUSH    SI,DI,ES
	CALL	cf32CheckStringTableMemory
	LES	DI,[cf32StringTablePTR]
	AND	CX,3Fh
	REP	MOVSB
	MOV	AL,0
	STOSB
	XCHG	[cf32StringTablePTR],DI
    POP ES,DI,SI
	XOR	AX,AX
	STOSW
	STOSW
    POP DX,AX
	STOSW
    MOV AX,DX
	STOSW
    JMP ExternCoff32NameOK

ExternCoff32CopyName:

	SUB	DX,CX
	REP	MOVSB
	MOV	AL,0
	MOV	CX,DX
	REP	STOSB

ExternCoff32NameOK:

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
	MOV	[cf32SymbolTablePTR],DI

	MOV	AX,[cf32NumSymbols]
	XOR	DX,DX
	INC [cf32NumSymbols]	
    RET
ExternCOFF32    ENDP
