PEStubFile  PROC
	CALL	GetNextStr
	CMP	AL,Alpha
	JZ	pesfLoad
	CMP	AL,Quote
	JNZ	pesfFail
pesfLoad:
	MOV	CX,[StrLen]
	MOV	CH,0
	MOV	DI,(externFileName)
	MOV	SI,[StrStart]
	REP	MOVSB
	MOV	AL,0
	STOSB

	MOV	DX,(externFileName)	;AL is already 0
	CALL	FOpen
	JC	pesfError2
	MOV	BX,AX
	XOR	DX,DX
	XOR	CX,CX
	MOV	AL,2
	CALL	FSeek
	JC	pesfError

	CALL	FClose
	MOV	BYTE [externStub],1

    ADD AX,0Fh      ;Align to 16-byte boundaries
    ADC DX,0
    AND AX,0FFF0h
	MOV	[pe32StubSize],AX
	MOV	[pe32StubSize][2],DX

	RET
pesfError:
	CALL	FClose	
pesfError2:
	JMP	FError

pesfFail:
	JMP	FileNameExpected

PEStubFile  ENDP

OpenPE32GetParam	PROC
	JMP ope32gpGetParams

ope32gpOS2:
	AND WORD [pe32SubSystem],NOT 1
	OR  WORD [pe32SubSystem],4
	JMP ope32gpGetParams

ope32gpGUI:
	AND WORD [pe32SubSystem],NOT 1
	JMP ope32gpGetParams

ope32gpDLL:
;        AND WORD [pe32Character],NOT 2
	OR  WORD [pe32Character],2000h
	MOV WORD [pe32DLLCharacter],0Fh
	JMP ope32gpGetParams

ope32gpDebug:
	JMP ope32gpGetParams

ope32gpPosix:
	MOV WORD [pe32SubSystem],7
	JMP ope32gpGetParams

ope32gpParams3:
	CMP AX,1F90h
	JZ  ope32gpOS2

	CMP AX,0A5CBh
	JZ  ope32gpGUI

	CMP AX,3AB7h
	JZ  ope32gpDLL

	JMP ope32gpGetParams

ope32gpStub:
    CMP DX,035E7h
    JNZ ope32gpGetParams
    CALL    PEStubFile
    JMP ope32gpGetParams

ope32gpParams4:
    CMP AX,4358h
    JZ  ope32gpStub
    JMP ope32gpGetParams

ope32gpParams5:

	CMP AX,544Fh
	JZ  ope32gpDebug

	CMP AX,0FC47h
	JZ  ope32gpPosix

ope32gpGetParams:
	CALL	GetNextStr

	MOV DI,SI

	MOV CX,[StrLen]
	TEST	CX,CX
	JZ  ope32gpDone

	MOV AX,[StrCRC]
	MOV DX,[StrCRC][2]

	CMP CL,3
	JZ  ope32gpParams3

    CMP CL,4
    JZ  ope32gpParams4

	CMP CL,5
	JZ  ope32gpParams5

	CMP CL,6
	JZ  ope32gpParams6

	CMP CL,7
	JZ  ope32gpParams7

	CMP CL,10
	JZ  ope32gpParams10
 ope32gpDone:
	RET

ope32gpParams6:
	CMP AX,0E4EFh
	JZ  ope32gpNative

	JMP ope32gpGetParams

ope32gpNative:
	MOV WORD [pe32SubSystem],1
	JMP ope32gpGetParams
    
ope32gpParams7:
	CMP AX,0C547h
	JZ  ope32gpWindows

	CMP AX,0C953h
	JZ  ope32gpConsole

	JMP ope32gpGetParams

ope32gpWindows:
	AND WORD [pe32SubSystem],NOT 1
	OR  WORD [pe32SubSystem],2
	JMP ope32gpGetParams

ope32gpConsole:
	OR  WORD [pe32SubSystem],1
	JMP ope32gpGetParams

ope32gpParams10:
	CMP AX,82E0h
	JZ  ope32gpExe
	JMP ope32gpGetParams

ope32gpExe:
	AND WORD [pe32Character],NOT 2000h
	OR  WORD [pe32Character],2
	JMP ope32gpGetParams	
OpenPE32GetParam	ENDP

COFFSectionClass    PROC
    PUSH    AX,BX,CX,DX,SI,DI
	MOV DI,[pe64Seg]
	CMP	BYTE [OutFormat],OutPE64
	JZ	cfSegOutFileOK
	MOV DI,[pe32Seg]	
    CMP BYTE [OutFormat],OutPE32
	JZ	cfSegOutFileOK
    MOV DI,[cf32Seg] 
    CMP BYTE [OutFormat],OutCOFF32
	JZ	cfSegOutFileOK
    MOV DI,[cf64Seg] 
cfSegOutFileOK:
    MOV CX,[SI]

    TEST    CX,CX
    JNZ cfSegNameOK

    PUSH    DI

    LEA DI,[SI][2]

    MOV AX,"SA"
    STOSW
    MOV AX,"PM"
    STOSW

    MOV AX,DI
    SUB AX,(MiscFmt)

    CALL    HexToStrWord
    
    POP DI

    MOV CX,8

 cfSegNameOK:

    CALL    COFFCheckClassName

    MOV  CX,8
	ADD	SI,2
	REP MOVSB

 cfClassDone:
    POP DI,SI,DX,CX,BX,AX
	RET
COFFSectionClass    ENDP

DoRVAOperation	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE64
        JZ      droFormatOK
        CMP     AL,OutPE32
        JZ      droFormatOK
        JMP     InvalidKeyword
droFormatOK:
        MOV     AX,[Settings]
        PUSH    AX
        OR      BYTE [Settings][1],0C0h
        OR      BYTE [Process],4
        CALL    GetOperand
        AND     BYTE [Process],NOT 4
        POP     CX
        MOV     BX,(Settings)
        AND     CL,3
        AND     BYTE [BX],NOT 3
        OR      BYTE [BX],CL
        MOV     BYTE [BX][1],CH

        CMP     AH,Number
        JNZ     DoRIPOperation
        PUSH    AX
        MOV     SI,(OWordNum)
        MOV     AX,[pe32ImageBase]
        SUB     [SI],AX
        MOV     AX,[pe32ImageBase][2]
        SBB     [SI][2],AX
        POP     AX
        RET
DoRIPOperation:
        JMP     InvalidKeyword
DoRVAOperation	ENDP


cpe32CheckIfValidSection:
    CMP WORD [DI][2].pesRawPTR,DX
    JNZ cpe32SectionOK
cpe32Ret:
    RET

ClosePE32Seg	PROC
    
	MOV	DI,[pe32Seg]
	MOV	AX,[OBufferPTR]
	XOR	DX,DX

	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]    ;Calc section PTR from file start (BYTE 0)

    SUB AX,[DI].pesRawPTR   ;SUB section start PTR to get section SIZE
    SBB DX,[DI][2].pesRawPTR

    XOR BX,BX       ;Make it zero for future use

    CMP WORD [DI].pesRawPTR,BX  ;if zero
    JZ  cpe32CheckIfValidSection
    TEST WORD [pe32Flags],0F0h
    JZ  cpe32Ret
 cpe32SectionOK:

	MOV	CX,AX		    ;copy INTO SI:CX
	MOV	SI,DX
	PUSH	BX
	XCHG	BX,[UninitData]
	ADD	CX,BX		    ;calculate virtual SIZE.
	POP	BX
	XCHG	BX,[UninitData][2]
	ADC	SI,BX		    ;without aligning

	MOV	BX,[pe32SectionAlign]
	CALL	AlignCX
	MOV	[DI].pesVirtualSize,CX
	MOV	[DI][2].pesVirtualSize,SI

	PUSH	AX

	MOV	AX,[pe32Flags]
	TEST	AL,10h
	JNZ	ClosePE32ImportSeg

	TEST	AL,20h
	JNZ	ClosePE32ExportSeg

	TEST	AL,40h
	JNZ	ClosePE32DataSeg

	TEST	AH,20h
	JNZ	ClosePE32ResourceSeg

    TEST    AL,80h
    JZ     ClosePE32DataSeg

	MOV	BX,(pe32CodeSize)

	TEST	AL,1
	JNZ	ClosePE32SegOK

    OR      AL,1
    MOV     BYTE [pe32Flags],AL

	MOV	AX,[DI].pesRVA
	MOV	[pe32CodeBase],AX

	MOV	AX,[DI][2].pesRVA
	MOV	[pe32CodeBase][2],AX

	JMP	ClosePE32SegOK

ClosePE32ImportSeg:
	MOV	BX,(pe32ImportSize)
	JMP	ClosePE32SegOK

ClosePE32ExportSeg:
	MOV	BX,(pe32ExportSize)
	JMP	ClosePE32SegOK

ClosePE32ResourceSeg:
	MOV	BX,(pe32ResourceSize)
	JMP	ClosePE32SegOK

ClosePE32DataSeg:
	MOV	BX,(pe32IDataSize)
	TEST	BYTE [pe32Flags],2
	JNZ	ClosePE32SegOK

        OR      AL,2
        MOV     BYTE [pe32Flags],AL

	MOV	AX,[DI].pesRVA
	MOV	[pe32DataBase],AX
	MOV	AX,[DI][2].pesRVA
	MOV	[pe32DataBase][2],AX

ClosePE32SegOK:

	ADD	WORD [BX],CX
	ADC	WORD [BX][2],SI
	POP AX

	PUSH	AX,DX		    ;Save, use it later to calc the padd bytes
	MOV	BX,[pe32FileAlign]    ;ALIGN section SIZE IN file
	CALL	AlignAX
	PUSH	AX,DX		    ;Save, use later to padd

	MOV	[DI].pesRawSize,AX  ;Write section SIZE, aligned.
	MOV	[DI][2].pesRawSize,DX

	ADD	CX,[DI].pesRVA
	ADC	SI,[DI][2].pesRVA

	MOV	BX,[pe32SectionAlign]
	CALL	AlignCX
	ADD	AX,[DI].pesRawPTR
	ADD	DX,[DI][2].pesRawPTR

	ADD	DI,(SIZE PESection)
	MOV	[pe32Seg],DI

	MOV	[DI].pesRVA,CX
	MOV	[DI][2].pesRVA,SI

	MOV	[DI].pesRawPTR,AX
	MOV	[DI][2].pesRawPTR,DX

	POP	DX,AX
	POP	SI,CX
	SUB	AX,CX
	SBB	DX,SI
	MOV	CX,AX
	CALL	PaddBytes
	AND	WORD [pe32Flags],0CF0Fh
	RET
ClosePE32Seg	ENDP

OpenPE32Format	PROC
	MOV AX,[pe32RelocSeg]
	TEST	AX,AX
	JNZ OpenPE32MemOK
	MOV BX,01000h
	CALL	AllocateMem
	JNC	OpenPE32MemOK
	MOV	BYTE [Error],QuitError
	MOV	SI,OFFSET _NotEnoughMem
	CALL	PrintError
	MOV	BYTE [Msg],EndOfFile
	MOV	SP,WORD [AsmStack]
	JMP	AssembleEndOfFile

OpenPE32MemOK:
	MOV [pe32RelocSeg],AX
	MOV WORD [OutFlags],0300h
	XOR AX,AX
	MOV [pe32RelocPTR],AX
	MOV WORD [pe32Seg],(pe32Sections)
	MOV [pe32SegAttr],AX
	MOV [pe32SegAttr][2],AX
	MOV BYTE [CurSeg],0FEh
	MOV BYTE [CurSeg][3],0FEh

	MOV WORD [pe32Signature],"EP"

	MOV WORD [pe32Machine],14Ch
	MOV WORD [pe32SizeOptional],0E0h
	MOV WORD [pe32Character],818Eh
	MOV WORD [pe32Magic],10Bh

	MOV	DX,thisVersion
	XCHG DL,DH
	MOV WORD [pe32Version],DX

	MOV WORD [pe32ImageBase],AX
	MOV WORD [pe32ImageBase][2],40h

	MOV WORD [ProgIP],AX
	MOV WORD [ProgIP][2],40h
	MOV WORD [ProgIP][4],AX 						
	MOV WORD [ProgIP][6],AX

	MOV WORD [pe32SectionAlign],1000h
	MOV WORD [pe32FileAlign],200h
	AND WORD [pe32Flags],200h

	MOV DI,(pe32ExportRVA)
	MOV CX,8*16
	REP STOSW

	MOV WORD [pe32CodeSize],AX
	MOV WORD [pe32CodeSize][2],AX
	MOV WORD [pe32IDataSize],AX
	MOV WORD [pe32IDataSize][2],AX

	MOV WORD [pe32UDataSize],AX
	MOV WORD [pe32UDataSize][2],AX

	MOV WORD [pe32OSVersion],1

	MOV WORD [pe32SubSysVersion],4
	MOV WORD [pe32SubSysVersion][2],0

	MOV WORD [pe32SubSystem],2

	MOV WORD [pe32NumRVAs],10h
	MOV WORD [pe32NumRVAs][2],AX

	TEST	BYTE [externStub],1
	JNZ	pe32StubSizeOK
	MOV WORD [pe32StubSize],80h
	MOV	WORD [pe32StubSize][2],AX
pe32StubSizeOK:
	MOV WORD [SegAlignment],1

	MOV WORD [StrPTR],(FmtParams)
	CALL OpenPE32GetParam

;OpenPE32ParamsOK:
	MOV AX,[pe32NumSections]
	MOV DX,(SIZE PESection)
	MUL DX

	ADD AX,(pe32Sections-pe32Signature)
	ADC	DX,0

	ADD AX,[pe32StubSize]
	ADC	DX,[pe32StubSize][2]

	MOV BX,[pe32FileAlign]
	DEC BX

	ADD AX,BX
	ADC	DX,0

	NOT BX
	AND AX,BX

	MOV [FileSize],AX
	MOV	[FileSize][2],DX
	MOV [pe32HeadersSize],AX
	MOV	[pe32HeadersSize][2],DX

	MOV	CX,DX
	MOV DX,AX
	MOV AL,0
	MOV BX,[OutHandle]
	CALL	FSeek

	CALL	_USE32
	OR  BYTE [ExtMask],SYM_NEEDSRELOC
	RET
OpenPE32Format	ENDP

ClosePE32File	PROC
	TEST	BYTE [pe32Flags][1],3    ;Is there any reloc
	JNZ cpe32Reloc
	JMP cpe32RelocOK

cpe32Reloc:

	MOV	DI,[pe32Seg]
	MOV	CX,[pe32RelocRVA]
	MOV	SI,[pe32RelocRVA][2]
	CALL	PE32RelocChangeBase

	MOV	AX,[DI].pesRVA	   ;Current RVA = reloc. We're about to write
	MOV [pe32BaseRelocRVA],AX
	MOV	AX,[DI][2].pesRVA
	MOV [pe32BaseRelocRVA][2],AX
	
	MOV	AX,[pe32RelocPTR]
	MOV	BX,AX
	SUB	AX,[pe32RelocStart]   ;RelocPTR-RelocStart
	CMP	AX,8		    ;Is it > 8
	JA	cpe32RelocSizeOK
	MOV	BX,[pe32RelocStart]   ;IF <=8, point to start

cpe32RelocSizeOK:

	ADD	BX,3		    ;ALIGN to 32-bits
	AND	BL,NOT 3
	MOV	AX,[NewFileSize]
	MOV	DX,[NewFileSize][2]
	ADD	AX,BX
	ADC	DX,0
	MOV	[pe32BaseRelocSize],AX
	MOV	[pe32BaseRelocSize][2],DX
	MOV	DI,[pe32Seg]
	PUSH	BX

	MOV	CX,AX
	MOV	SI,DX

	MOV	BX,[pe32FileAlign]
	CALL	AlignCX
	MOV	[DI].pesRawSize,CX
	MOV	[DI][2].pesRawSize,SI

	MOV	BX,[pe32SectionAlign]
	CALL	AlignAX
	MOV	[DI].pesVirtualSize,AX
	MOV	[DI][2].pesVirtualSize,DX

	MOV	BYTE [DI].pesCharacter,40h
	MOV	BYTE [DI][3].pesCharacter,42h

	ADD	AX,[DI].pesRVA
	ADC	DX,[DI][2].pesRVA

	MOV	SI,(RelocName)
	MOV	CX,4
	REP	MOVSW
	ADD	DI,(SIZE PESection)-8
	MOV	[DI].pesRVA,AX
	MOV	[DI][2].pesRVA,DX

	MOV	[pe32Seg],DI

	XOR	DX,DX
	MOV	CX,DX
	MOV	AL,2
	MOV	BX,[OutHandle]
	CALL	FSeek

	POP BX

	MOV	SI,[NewHandle]
	TEST	SI,SI
	JZ  cpe32RelocNewOK
	PUSH	BX
	MOV	DI,[OutHandle]
	CALL	FCopy
	POP BX
cpe32RelocNewOK:
	TEST	BX,BX
	JZ  cpe32RelocOK
	PUSH	DS
	XOR	DX,DX
	MOV	DI,BX
	LEA	CX,[BX][4]
	MOV	BX,[OutHandle]
	MOV	DS,[pe32RelocSeg]
	MOV	WORD [DI],DX
	MOV	WORD [DI][2],DX
	CALL	FWrite
	POP DS

cpe32RelocOK:
	MOV	DI,[pe32Seg]
	MOV	AX,[DI].pesRVA
	MOV	[pe32ImageSize],AX
	MOV	AX,[DI][2].pesRVA
	MOV	[pe32ImageSize][2],AX

	XOR	DX,DX
	MOV	CX,DX
	MOV	AL,0
	CALL	FSeek
	
	TEST	BYTE [externStub],1
    JNZ cpe32CopyStubFile
    JMP cpe32CopyStub

 cpe32CopyStubFile:
	MOV	AL,0
	MOV	DX,(externFileName)
	CALL	FOpen
	JC	cpe32StubFileError
	MOV	BX,AX
	XOR	DI,DI
	XOR	SI,SI
    JMP cpe32CopyStubLoop

 cpe32StubSizeError:
	MOV	SI,(_StubSizeError)
	JMP	PrtError
	
 cpe32StubFileError:
	JMP	FError

 cpe32CopyStubLoop:	
	PUSH	DS
	MOV	CX,32700
	MOV	DS,[DiskOutSeg]
	XOR	DX,DX
	CALL	FRead
	POP	DS
	JC	cpe32StubFileError
	TEST	AX,AX
	JZ	cpe32CopyStubDone

    TEST    SI,SI
    JNZ cpe32StubEXEHeaderOK
    TEST    DI,DI
    JNZ cpe32StubEXEHeaderOK

    PUSH    ES
    MOV ES,[DiskOutSeg]
    MOV CX,ES:[0000]
    POP ES
    CMP CX,"ZM"
    JZ  cpe32StubEXESigOK

    CMP CX,"MZ"
    JNZ  cpe32StubSizeError

 cpe32StubEXESigOK:
    PUSH    ES
    MOV ES,[DiskOutSeg]

    MOV WORD ES:[0],"ZM"

    MOV DX,[pe32StubSize]
    MOV WORD ES:[3Ch],DX

    MOV DX,[pe32StubSize][2]
    MOV WORD ES:[3Ch][2],DX

    POP ES
 cpe32StubEXEHeaderOK:
	ADD	SI,AX
	ADC	DI,0

	CMP	DI,[pe32StubSize][2]
	JBE	cpe32StubSizeOK

	CMP	SI,[pe32StubSize]
	JA	cpe32StubSizeError
	
 cpe32StubSizeOK:
 
	PUSH	BX	;Save stub file handle
	MOV	BX,[OutHandle]
	MOV	CX,AX
	PUSH	DS
	MOV	DS,[DiskOutSeg]
	XOR	DX,DX
	CALL	FWrite
	POP	DS
	POP	BX
	JC	cpe32StubFileError
	
	JMP	cpe32CopyStubLoop
	
 cpe32CopyStubDone:

;	ADD	[BytesWritten],SI
;	ADC [BytesWritten][2],DI
	MOV	AL,0
	MOV	BX,[OutHandle]
	MOV	DX,[pe32StubSize]
	MOV	CX,[pe32StubSize][2]
	CALL	FSeek

	MOV ES,[DiskOutSeg]
	XOR	DI,DI
	JMP	cpe32StubOK
  
 cpe32CopyStub:
	MOV SI,(DosStub)
	MOV ES,[DiskOutSeg]
	MOV CX,[pe32StubSize]
	XOR DI,DI
	MOV DX,DI
	REP MOVSB

 cpe32StubOK:
	
	MOV SI,(MiscFmt)
	MOV CX,[pe32HeadersSize]
	
	SUB CX,[pe32StubSize]
	
	REP MOVSB

	MOV [OBufferPTR],DI

	MOV CX,DI
	MOV BX,[OutHandle]
	PUSH	DS
	PUSH	ES
	POP DS
	CALL	FWrite
	POP DS

	XOR CX,CX
	MOV DX,CX
	MOV AL,2
	MOV BX,[OutHandle]
	CALL	FSeek
	PUSH	AX,DX
	MOV BX,[pe32FileAlign]
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

	XOR	BX,BX
	XCHG BX,[OutHandle]
	CALL	FClose
	CALL	PrintOutFile
	RET
ClosePE32File	ENDP

InitPE32	PROC
	MOV DI,[pe32Seg]

	MOV AX,[OBufferPTR]
	XOR DX,DX
	ADD AX,[FileSize]
	ADC DX,[FileSize][2]

	PUSH	AX,DX
	MOV CX,AX
	MOV SI,DX

	MOV BX,[pe32FileAlign]
	CALL	AlignAX
	MOV [DI].pesRawPTR,AX
	MOV [DI][2].pesRawPTR,DX

	MOV BX,[pe32SectionAlign]
	CALL	AlignCX
	MOV [DI].pesRVA,CX
	MOV [DI][2].pesRVA,SI

	POP SI,CX
	SUB AX,CX
	SBB DX,SI
	MOV CX,AX
	CALL	PaddBytes

	CMP BYTE [Pass],1
	JZ  InitPE32Pass1
	RET
InitPE32Pass1:
	MOV WORD [pe32NumSections],0
	MOV WORD [pe32RelocPTR],0
    OR      BYTE [RefFlags],16
	RET
InitPE32	ENDP

PE32InitSeg	PROC
	TEST	BYTE [Temp4],1
	JNZ PE32InitSegClassOK
	CALL	COFFSectionClass
 PE32InitSegClassOK:
	MOV	DI,[pe32Seg]

	TEST	BYTE [Temp4],2	;AT was specified
	JNZ	PE32InitSegAddrOK
	MOV	AX,[DI].pesRVA
	MOV	DX,[DI][2].pesRVA
	ADD	AX,[pe32ImageBase]
	ADC	DX,[pe32ImageBase][2]
	MOV	[ProgIP],AX
	MOV	[ProgIP][2],DX
	XOR	AX,AX
	MOV	[ProgIP][4],AX
	MOV	[ProgIP][6],AX
 PE32InitSegAddrOK:
	XOR	AX,AX
	XOR	DX,DX
	TEST	[pe32Flags],0F0h
	JNZ	PE32InitSegOK
 PE32DefaultCode:
	MOV	WORD [DI].pesCharacter,20h
	MOV	WORD [DI][2].pesCharacter,60h
    OR  BYTE [pe32Flags],40h  ;This is data
 PE32InitSegOK:
	CMP	BYTE [Pass],1
	JNZ	PE32InitDone
	INC	WORD [pe32NumSections]
 PE32InitDone:
	RET
PE32InitSeg	ENDP

PE32Reloc	PROC
	PUSH	ES,SI,DI
	MOV	AX,DI
	MOV	DI,[pe32Seg]
	SUB	AX,[DiskOutStart]
	XOR	DX,DX
	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]
	SUB	AX,[DI].pesRawPTR
	SBB	DX,[DI][2].pesRawPTR
	ADD	AX,[DI].pesRVA
	ADD	DX,[DI][2].pesRVA
PE32RelocCalcRVA:
	MOV	CX,AX
	MOV	SI,DX
	TEST	BYTE [pe32Flags][1],1
	JZ	PE32RelocNextRVA
	SUB	AX,[pe32RelocRVA]
	SBB	DX,[pe32RelocRVA][2]
	JNZ	PE32RelocNextRVA
	CMP	AX,0FFFh
	JA	PE32RelocNextRVA
	JMP	PE32RelocRVAOK
PE32RelocNextRVA:
	MOV	AX,CX
	MOV	DX,SI
	MOV	BX,NOT 0FFFh	    ;Find next RVA which gives smallest disp
	AND	CX,BX
	XCHG	[pe32RelocRVA],CX
	XCHG	[pe32RelocRVA][2],SI
	CALL	PE32RelocChangeBase
	JMP	PE32RelocCalcRVA
PE32RelocRVAOK:
	MOV	BYTE [RelocFlags],0
	PUSH	ES
	OR	AH,30h
	LES	DI,[pe32RelocPTR]
	STOSW
	MOV [pe32RelocPTR],DI
	POP ES
	CMP	DI,0FFF0h
	JA	PE32RelocFlush
pe32rDone:
	POP	DI,SI,ES
	RET
PE32RelocFlush:
	CALL	PE32RelocChangeBase
	CMP WORD [NewHandle],0
	JNZ pe32rfCreateNew
 pe32rfWrite:
	PUSH	DS
	MOV BX,[NewHandle]
	MOV DS,[pe32RelocSeg]
	XOR DX,DX
	MOV CX,8
	XCHG	CX,[pe32RelocPTR]
	CALL	FWrite
	ADD WORD [NewFileSize],AX
	ADC WORD [NewFileSize][2],0
	POP DS
	MOV [pe32RelocStart],DX
	JMP	pe32rDone
 pe32rfCreateNew:
	CALL	CreateNewFile
	JMP pe32rfWrite
PE32Reloc	ENDP

PE32RelocChangeBase	PROC
	PUSH	ES,DI		;ALIGN to next 32-bits
	LES	DI,[pe32RelocPTR]
	MOV	WORD ES:[DI],0	;Clear next WORD. Alignment could pass it
	ADD	DI,3
	AND	DI,NOT 3
	MOV	BX,DI	    ;Use RelocPTR to calc the len of previous base
	ADD	DI,8		;Give space FOR the length AND base
	XCHG	BX,[pe32RelocStart]
	MOV	[pe32RelocPTR],DI ;New aligned PTR
	TEST	BYTE [pe32Flags][1],1
	JZ	pe32rcFirstReloc
	SUB	DI,8
	SUB	DI,BX	    ;Length=RelocPTR-RelocStart
	CMP	DI,8
	JBE	pe32rcReUse
	MOV	ES:[BX],CX  ;BaseRVA
	MOV	ES:[BX][2],SI
	MOV	ES:[BX][4],DI	    ;Length
	MOV	WORD ES:[BX][6],0
	JMP	pe32rcDone
pe32rcReUse:
	MOV	[pe32RelocStart],BX
	ADD	BX,8
	MOV	[pe32RelocPTR],BX
	JMP	pe32rcDone
pe32rcFirstReloc:
	TEST	BYTE [pe32Flags][1],2
	JNZ	pe32rcDone
	INC	WORD [pe32NumSections]
pe32rcDone:
	OR	BYTE [pe32Flags][1],3
	POP	DI,ES
	RET
PE32RelocChangeBase	ENDP

ImportPE32	PROC
	TEST	BYTE [OutFlags][1],1
	JZ	ipe32InvalidKW
	TEST	BYTE [pe32Flags],10h
	JZ	ipe32InvalidKW
	AND	BYTE [OutFlags][1],NOT 1

	PUSH	ES
	LES	DI,[OBufferPTR]
	MOV	[_peBufferPTR],0
	MOV	[_peBufferSeg],ES
	POP	ES
	MOV	AX,[FileSize]
	MOV	DX,[FileSize][2]
	ADD	AX,DI
	ADC	DX,0

	MOV	DI,[pe32Seg]
	CMP	AX,[DI].pesRawPTR
	JNZ	ipe32InvalidKW
	CMP	DX,[DI][2].pesRawPTR
	JNZ	ipe32InvalidKW
	CALL	WriteOutFile
	OR	BYTE [Settings][1],3
	MOV	WORD [_peDescSize],(5*4)  ;Init Descriptor Length
	MOV	WORD [_peDirSize],(5*4)  ;Init total size of directory
	JMP	ipe32GetLib

 ipe32InvalidKW:
	MOV	SI,(_InvalidKeyword)
	JMP	PrtErrorQuit

 ipe32LibExpected:
	MOV	SI,(_InvalidOperand)
	JMP	PrtErrorQuit

; ipe32DupDef:
;        MOV     SI,(_DupDef)
;        JMP     PrtErrorQuit

 ipe32GetLib:
	CALL	GetNext
	CMP	AX,Quote
	JNZ ipe32LibExpected
	CMP	DH,0
	JA  ipe32InvalidOp2
	CMP	DL,0
	JZ  ipe32InvalidOp2
	MOV	CX,DX
	INC	DX		;Allow for null terminator
	ADD	[Temp4],DX	;LibraryNames Len
	ADD	WORD [_peSectionSize],4	;RVAs Length
	ADD	WORD [_peDescSize],(5*4)  ;Descriptor Length
	ADD	DX,(5*4)+8	;8 since there are 2 RVA tables
	ADD	[_peDirSize],DX	;Entire directory Len
	LES	DI,[Temp2]
	MOV	AL,CL
	STOSB
	MOV	SI,(StrBuffer)
	REP	MOVSB
	MOV	[_peBufferPTR],DI
	JMP ipe32GetModules

 ipe32InvalidOp2:
	MOV SI,(_InvalidOperand)
	JMP	PrtErrorQuit

 ipe32Instr:
	CMP DX,(EndDirective)
	JZ  ipe32Finalize
	CMP DX,(ImportDirective)
	JNZ ipe32InvalidOp
	JMP ipe32GetLib
 ipe32Finalize:
	JMP	ipe32Finalize2

 ipe32NewLine:
	ADD WORD [LineNumber],1
	ADC WORD [LineNumber][2],0
	CMP BYTE [Msg],EndOfFile
	JZ  ipe32Finalize
	MOV BYTE [EOLFlag],0
 ipe32GetModules:
	CALL	GetNext
	CMP	AL,EndOfLine
	JZ  ipe32NewLine
	CMP	AX,CPUInstruction
	JZ  ipe32Instr
	CMP	AH,Identifier
	JNZ ipe32IDExpected
	MOV	CX,DI
	LES	DI,[_peBufferPTR]
	CMP	AL,UnknownID
	JNZ ipe32Exists
	MOV AL,0
	STOSB
	MOV	AX,CX
	STOSW
	MOV	AX,BP
	STOSW
	MOV	AL,[StrLen]
	STOSB
	JMP	ipe32ModuleOK

 ipe32IDExpected:
 ipe32InvalidOp:
	MOV SI,(_InvalidOperand)
	JMP	PrtErrorQuit

 ipe32DupDef:
	MOV SI,(_DupDef)
	JMP PrtErrorQuit

 ipe32Exists:
	TEST	BYTE [RefFlags],8

	PUSH	DS
	LDS	SI,[SymPos]

	JNZ ipe32ExistsOK

	TEST	BYTE [SI].seIDFlags,SYM_UNDEF
	JZ  ipe32DupDef
 ipe32ExistsOK:

	MOV AL,0
	STOSB
	MOV	AX,SI
	STOSW
	MOV	AX,DS
	STOSW
	MOV	AL,0
	STOSB
	CMP	BYTE [SI].seIDType,DWordID
	JZ  ipe32TypeOK
	MOV BYTE [SI].seIDType,DWordID
	OR  BYTE [RefFlags],10h
 ipe32TypeOK:
	POP DS
 ipe32ModuleOK:
	MOV	[Temp2],DI
	CALL	GetNext
	LES	DI,[_peBufferPTR]
	CMP	AH,Number
	JZ  ipe32ModuleOrdinal
	CMP	AX,Quote
	JNZ ipe32InvalidOp
	CMP DH,0
	JNZ ipe32InvalidOp
	CMP	DL,0
	JZ  ipe32InvalidOp
	MOV	AL,DL
	STOSB
	MOV	SI,(StrBuffer)
	MOV	CX,DX
	REP	MOVSB
	ADD	DX,3
	ADD	[_peModuleNamesLen],DX  ;Module Names Length
	ADD	[_peDirSize],DX
	ADD	WORD [_peSectionSize],4
	MOV	[_peBufferPTR],DI
	JMP ipe32GetModules
 ipe32ModuleOrdinal:
	MOV	AL,0
	STOSB
	MOV	AX,DX
	STOSW
	MOV	[_peBufferPTR],DI
	JMP ipe32GetModules

ipe32Finalize2:
	MOV SI,(OWordNum)
	MOV AX,[ProgIP][-2]
	MOV [SI][1],AX
	MOV AL,[ProgIP][-3]
	MOV [SI],AL

	MOV AX,[Temp6]	;Descriptor length = library name pointer
	ADD AX,[Temp4]	;Library names len+DescLen = module name pointer
	MOV [Temp4],AX	;Store it

	ADD AX,[Temp7]	;Module Names Len+Module Names Pointer=FirstThunk
	MOV [_peModuleNamesLen],AX	;Store it
	MOV [_peLibTable],AX ;Fixed Pointer to First Thunk

	MOV BX,[pe32Seg]
	MOV AX,[BX].pesRVA
	MOV DX,[BX][2].pesRVA
	ADD AX,[pe32ImageBase]
	ADC DX,[pe32ImageBase][2]
	ADD AX,[_peModuleNamesLen]
	ADC DX,0
;	ADD AX,[_peSectionSize]
;	ADC DX,0
	MOV [SI][4],AX	;address of first symbol
	MOV [SI][6],DX


	LES CX,[_peBufferPTR]	;Destination pointer
	MOV DI,65534	;Allow two bytes to indicate the end
	SUB DI,CX	;Make sure DI goes to the highest address possible
	PUSH	DI	;Save it, to know where the unprocessed start. also len
	XOR SI,SI	;Copy
	REP MOVS    BYTE ES:[DI],ES:[SI]
	MOV AX,0FFh	;Indicate end
	STOSW
	POP CX		;Restore len
	MOV SI,CX	;which is also the unprocessed pointer
	XOR DI,DI	;Zero from address 0 to unprocessed start
	MOV AL,0
	REP STOSB
	ADD WORD [_peBufferPTR],2  ;Add length by the end bytes 00FFh
;	MOV [Temp1],AX	;init Source Pointer
	MOV [_peDirTable],AX	;init Directory Pointer
	MOV ES,[_peBufferSeg]	;Destination pointer
	JMP ipe32flGetLib

 ipe32Done:
	MOV SI,[_peLibTable]     ;First thunk start
	MOV DI,SI
	MOV CX,[_peSectionSize]	    ;Total size of import directory
	ADD DI,CX
;	REP MOVS    BYTE ES:[DI],ES:[SI]
	JMP AssembleDone

 ipe32flGetLib:
	MOV	CX,ES:[SI]  ;GetLen
	CMP CX,0FFh	    ;CX=00FFh - terminator
	JZ  ipe32Done

	MOV DI,[pe32Seg]
	MOV AX,[DI].pesRVA
	MOV DX,[DI][2].pesRVA
	PUSH	AX,DX
	ADD AX,[_peModuleNamesLen]
	ADC DX,0
	MOV DI,[_peDirTable]
;	MOV WORD ES:[DI],AX ;Original thunk
;	MOV WORD ES:[DI][2],DX
;	ADD AX,[_peSectionSize]	    ;Add by size of original thunk
;	ADC DX,0
	MOV ES:[DI][16],AX  ;First thunk
	MOV ES:[DI][18],DX
	POP DX,AX
	ADD AX,[_peDescSize]	    ;Add RVA+Library name start
	ADC DX,0
	MOV ES:[DI][12],AX
	MOV ES:[DI][14],DX

	ADD WORD [_peDirTable],(5*4)	;Move to next entry

	INC SI
	MOV CH,0
	MOV DI,[_peDescSize]
	INC CX
	ADD [_peDescSize],CX
	DEC CX
	
	REP MOVS    BYTE ES:[DI],ES:[SI]
	MOV AL,0
	STOSB
 ipe32flGetModules:
	CMP BYTE ES:[SI],0
	JNZ ipe32flModulesDone
	INC SI
	MOV AL,ES:[SI][4]
	CMP AL,0
	JZ  ipe32flExists
	MOV CL,AL
	MOV CH,DWordID
	MOV DI,ES:[SI]
	MOV BP,ES:[SI][2]
	PUSH	ES,SI
	MOV SI,(OWordNum)
	MOV BYTE [SI],0
	CALL	WriteSymbol
	POP SI,ES
	MOV BX,[_peBufferPTR]
	JMP ipe32flWriteModule

 ipe32flModulesDone:
	ADD WORD [_peModuleNamesLen],4
	ADD WORD [OWordNum][4],4    ;Null
	ADC WORD [OWordNum][6],0
	JMP ipe32flGetLib

 ipe32flExists:
	PUSH	ES
	PUSH	BX
	LES BP,ES:[SI]
	MOV AX,[OWordNum][4]
	MOV DX,[OWordNum][6]

	MOV CX,AX
	MOV BX,DX

	XCHG	ES:[BP].seIDData,AX
	XCHG	ES:[BP][2].seIDData,DX
	AND	BYTE ES:[BP].seIDFlags,NOT SYM_UNDEF

	CMP BX,DX
	POP BX
	POP ES
	JZ  ipe32flWriteModule
	OR  BYTE [RefFlags],10h
 ipe32flWriteModule:
	ADD SI,5    ;Move from the Crc or SymPos

	LODS	BYTE ES:[SI]	;Get module name length
	CMP AL,0
	JZ  ipe32flOrdinal

	MOV CL,AL		;Prepare string length
	MOV CH,0

	MOV DI,[pe32Seg]
	MOV AX,[DI].pesRVA
	MOV DX,[DI][2].pesRVA
	ADD AX,[_peLibNamesLen]	    ;Pointer to module names
	ADC DX,0

	MOV DI,[_peModuleNamesLen]	    ;Pointer to first thunk        
	STOSW
	MOV AX,DX
	STOSW

	MOV DI,[_peLibNamesLen]	      
	MOV AX,CX	    ;AX=CX+3, Allow for the hint+the null terminator
	ADD AX,3
	ADD [_peLibNamesLen],AX
	XOR AX,AX
	STOSW	    ;Hint
	REP MOVS BYTE ES:[DI],ES:[SI]	;String
	STOSB	    ;Null

	ADD WORD [_peModuleNamesLen],4
	ADD WORD [OWordNum][4],4
	ADC WORD [OWordNum][6],0
	JMP ipe32flGetModules
 ipe32flOrdinal:
	MOV DI,[_peModuleNamesLen]
	LODS	WORD ES:[SI]
	STOSW
	MOV AX,8000h
	STOSW
	ADD WORD [_peModuleNamesLen],4
	ADD WORD [OWordNum][4],4
	ADC WORD [OWordNum][6],0
	JMP ipe32flGetModules
ImportPE32	ENDP

ExportPE32	PROC
	JMP	epe32Start

	epe32InvalidKW:
	JMP	InvalidKeyword
 
 epe32Start:
	TEST	BYTE [OutFlags][1],2
	JZ	epe32InvalidKW
	TEST	BYTE [pe32Flags],20h
	JZ	epe32InvalidKW
	AND	BYTE [OutFlags][1],NOT 2
	PUSH	ES
	LES	DI,[OBufferPTR]
	MOV	[Temp2],0FFFEh
	MOV	[Temp3],ES
	POP	ES
	MOV	AX,[FileSize]
	MOV	DX,[FileSize][2]
	ADD	AX,DI
	ADC	DX,0

	MOV	DI,[pe32Seg]
	CMP	AX,[DI].pesRawPTR
	JNZ	epe32InvalidKW
	CMP	DX,[DI][2].pesRawPTR
	JNZ	epe32InvalidKW
	CALL	WriteOutFile
	OR	BYTE [Settings][1],3
	CALL	GetNext
	CMP	AX,Quote
	JNZ epe32LibExpected
	CMP	DH,0
	JNZ	epe32InvalidOp
	MOV	ES,[Temp3]
	XOR	DI,DI
	MOV	AX,DI
	MOV	CX,(4*5)
	REP	STOSW
	MOV	CX,DX
	MOV SI,(StrBuffer)
	REP	MOVSB
	MOV	AL,0
	STOSB
	MOV	[Temp5],DI
	JMP epe32GetModule
 epe32LibExpected:
	JMP	InvalidOperand
 epe32Instr:
	CMP DX,(EndDirective)
	JZ  epe32Done
	JMP InvalidOperand
 epe32Done:
	JMP epe32Done2
 epe32gmEOL:
	CMP	BYTE [Msg],EndOfFile
	JZ  epe32Done
	ADD WORD [LineNumber],1
	ADC WORD [LineNumber][2],0
	MOV BYTE [EOLFlag],0
 epe32GetModule:
	CALL	GetNext
	CMP	AL,EndOfLine
	JZ  epe32gmEOL
	CMP	AX,CPUInstruction
	JZ  epe32Instr
	CMP	AH,Identifier
	JNZ epe32InvalidOp
	CMP	AL,UnknownID
	JNZ epe32Exists
	PUSH	DS
	POP ES
	MOV	BX,(ProgIP-4)
	MOV	SI,(Zeros)
	MOV	BYTE [SI],SYM_UNDEF
	MOV	CH,[StrLen]
	MOV	CL,DWordID
	CALL	WriteSymbol
	XOR	AX,AX
	MOV	DX,AX
	JMP	epe32IDOK

 epe32IDNotFound:
	MOV SI,(_IDNotFound)
	JMP	PrtErrorQuit

 epe32InvalidOp:
	JMP	InvalidOperand

 epe32Exists:
	LES	DI,[SymPos]
	MOV	DX,ES:[DI].seIDData	;They are stored in reverse
	MOV	AX,ES:[DI][2].seIDData
	CMP	BYTE ES:[DI].seIDType,DWordID
	JZ	epe32IDTypeOK
	MOV	BYTE ES:[DI].seIDType,DWordID
	OR	BYTE [RefFlags],10h
 epe32IDTypeOK:
	TEST	BYTE ES:[DI].seIDFlags,SYM_UNDEF
	JZ  epe32IDOK
	TEST	BYTE [RefFlags],8
	JNZ epe32IDNotFound
 epe32IDOK:
	LES	DI,[Temp2]
	SUB DX,[pe32ImageBase]
	SBB AX,[pe32ImageBase][2]
	STD
	STOSW
	MOV AX,DX
	STOSW
	CLD
	MOV	[Temp2],DI
	CALL	GetNext
	CMP AX,Quote
	JNZ epe32InvalidOp
	CMP DH,0
	JNZ epe32InvalidOp

	LES DI,[Temp2]
	MOV BX,[pe32Seg]
	MOV CX,DX
	MOV DX,[Temp5]
	XOR AX,AX
	MOV SI,DX
	ADD DX,[BX].pesRVA
	ADC AX,[BX][2].pesRVA
	STD
	STOSW
	MOV AX,DX
	STOSW
	CLD
	MOV [Temp2],DI
	MOV DI,SI
	MOV SI,(StrBuffer)
	REP MOVSB
	MOV AL,0
	STOSB
	MOV [Temp5],DI
	MOV [Temp6],DI
	JMP epe32GetModule

 epe32Done2:
	LES CX,[Temp2]
	MOV DI,[Temp5]	;Where module names end
	ADD DI,3	;Align
	AND DI,NOT 3
	ADD CX,2
	XOR DX,DX
	SUB DX,CX
	MOV AX,DX
	SHR DX,1    ;Divide by 2 to get half the size
	ADD DX,DI   ;Pointer to name table

	MOV BX,AX
	ADD BX,DI   ;Go just after the RVA tables

	SHR AX,3    ;Divide by 8
	MOV WORD ES:[16],1
	MOV WORD ES:[20],AX
	MOV WORD ES:[24],AX

	MOV SI,[pe32Seg]
	MOV AX,[SI].pesRVA
	MOV SI,[SI][2].pesRVA

	PUSH	BX
	XOR BP,BP
	ADD BX,AX
	ADC BP,SI
	MOV ES:[36],BX	;Ordinal Table
	MOV ES:[38],BP

	MOV BX,DX
	XOR BP,BP
	ADD BX,AX
	ADC BP,SI
	MOV ES:[32],BX	;Name pointers
	MOV ES:[34],BP

	MOV BX,DI
	XOR BP,BP
	ADD BX,AX
	ADC BP,SI
	MOV ES:[28],BX
	MOV ES:[30],BP

	MOV BX,(4*10)
	XOR BP,BP
	ADD BX,AX
	ADC BP,SI
	MOV ES:[12],BX
	MOV ES:[14],BP
	POP BX

	MOV SI,0FFFCh
	XOR AX,AX

	TEST	CX,CX
	JZ  epe32CopyDone
 epe32CopyLoop:
	CMP SI,CX
	JBE epe32CopyDone
	MOVS	WORD ES:[DI],ES:[SI]
	MOVS	WORD ES:[DI],ES:[SI]
	SUB SI,8
	XCHG	DI,DX
	MOVS	WORD ES:[DI],ES:[SI]
	MOVS	WORD ES:[DI],ES:[SI]
	SUB SI,8
	XCHG	DI,DX
	MOV ES:[BX],AX
	INC AX
	ADD BX,2
	JMP epe32CopyLoop
 epe32CopyDone:
	MOV	DI,BX
	JMP	AssembleDone
ExportPE32	ENDP


EndPE32	PROC
        MOV AX,[SI]
        MOV	DX,[SI][2]
        SUB AX,[pe32ImageBase]
        SBB DX,[pe32ImageBase][2]
        MOV [pe32EPoint],AX
        MOV [pe32EPoint][2],DX
        RET
EndPE32	ENDP

;GetSegAddrPE32	PROC
;        XOR     AX,AX
;        MOV     DX,AX
;        STC
;        RET
;GetSegAddrPE32	ENDP


ImportSegPE32	PROC
        TEST    BYTE [pe32Flags],0F4h ;IF this is IMPORT/EXPORT/code/data OR IMPORT exists
        JNZ     ispe32Error
        OR      BYTE [pe32Flags],10h  ;This is IMPORT
        MOV     DI,[pe32Seg]
        MOV     AX,[DI].pesRVA
        MOV     [pe32ImportRVA],AX
        MOV     AX,[DI][2].pesRVA
        MOV     [pe32ImportRVA][2],AX
        OR      BYTE [DI].pesCharacter,40h      ;data
        OR      BYTE [DI][3].pesCharacter,0C0h   ;readable,writeable
        CLC
        RET
ispe32Error:
		STC
		RET
ImportSegPE32	ENDP

		
ExportSegPE32	PROC
        TEST    BYTE [pe32Flags],0F8h  ;IF this is IMPORT/EXPORT/code/data OR EXPORT exists
        JNZ     espe32Error
        OR      BYTE [pe32Flags],20h  ;This is EXPORT
        MOV     DI,[pe32Seg]
        MOV     AX,[DI].pesRVA
        MOV     [pe32ExportRVA],AX
        MOV     AX,[DI][2].pesRVA
        MOV     [pe32ExportRVA][2],AX
        OR      BYTE [DI].pesCharacter,40h      ;data
        OR      BYTE [DI][3].pesCharacter,40h   ;readable
        CLC
        RET
espe32Error:
		STC
		RET
ExportSegPE32	ENDP

CodeSegPE32	PROC
        
        MOV     AL,[pe32Flags]
        TEST    AL,0F0h     ;IF this is code,IMPORT,EXPORT OR data
        JNZ cspe32Error
        OR      BYTE [pe32Flags],80h          ;this is code
        MOV     DI,[pe32Seg]
        OR      BYTE [DI].pesCharacter,20h      ;code
        OR      BYTE [DI][3].pesCharacter,60h   ;readable, executable
        CLC
        RET
cspe32Error:
		STC
		RET
CodeSegPE32	ENDP

NotPagedSegPE32	PROC
		MOV     DI,[pe32Seg]
        OR      BYTE [DI][3].pesCharacter,4      ;Notpageable
        CLC
        RET
NotPagedSegPE32	ENDP

DiscardableSegPE32	PROC
        MOV     DI,[pe32Seg]
        OR      BYTE [DI][3].pesCharacter,2      ;Discardable
        CLC
        RET
DiscardableSegPE32	ENDP

ExecutableSegPE32	PROC
        MOV     AL,[pe32Flags]
        TEST    AL,80h
        JZ  xspe32Error
        CLC
        RET
xspe32Error:
		STC
		RET

ExecutableSegPE32	ENDP


ResSegPE32	PROC
        TEST    BYTE [pe32Flags][1],10h
        JNZ rspe32Error
        MOV     DI,[pe32Seg]
        MOV     AX,[DI].pesRVA
        MOV     [pe32ResourceRVA],AX
        MOV     AX,[DI][2].pesRVA
        MOV     [pe32ResourceRVA][2],AX
        OR      BYTE [pe32Flags][1],30h
        CLC
        RET
rspe32Error:
        STC
        RET
ResSegPE32	ENDP


ShareableSegPE32	PROC
        MOV     DI,[pe32Seg]
        OR      BYTE [DI][3].pesCharacter,10h      ;Shaareable
        CLC
        RET
ShareableSegPE32	ENDP


WritableSegPE32	PROC		
        MOV     AL,[pe32Flags]
        TEST    AL,80h      ;Is this code
        JNZ wspe32Error
        MOV     DI,[pe32Seg]
        OR      BYTE [DI][3].pesCharacter,80h      ;Writable
        CLC
        RET
wspe32Error:
		STC
		RET
WritableSegPE32	ENDP

		
DataSegPE32	PROC
        MOV     AL,[pe32Flags]
        TEST    AL,0F0h     ;IF this is code,IMPORT,EXPORT OR data
        JNZ dspe32Error
        OR      BYTE [pe32Flags],40h		;Dataseg
        MOV     DI,[pe32Seg]
        OR      BYTE [DI].pesCharacter,40h      ;data
        OR      BYTE [DI][3].pesCharacter,40h   ;readable
        CLC
        RET
dspe32Error:
		STC
		RET
DataSegPE32	ENDP

ReadableSegPE32	PROC
        MOV     DI,[pe32Seg]
        OR      BYTE [DI][3].pesCharacter,40h      ;readable
        CLC
        RET
ReadableSegPE32	ENDP

PE32Stack	PROC
        CMP     AL,Num32
        JA  PE32StackNumTooBig
        MOV     [pe32StackReserve],DX
        MOV     AX,[OWordNum][2]
        MOV     [pe32StackReserve][2],AX
        CALL    GetNext
        CMP AH,Number
        JZ  _pe32StackCommit
        MOV BX,(pe32StackReserve)
        MOV AH,Num32
        JMP _pe32StackOK

PE32StackNumTooBig:
		JMP	NumTooBig

_pe32StackCommit:
        MOV BX,(OWordNum)
_pe32StackOK:
        CMP AL,Num32
        JA  PE32StackNumTooBig
        MOV AX,[BX]
        MOV [pe32StackCommit],AX
        MOV AX,[BX][2]
        MOV [pe32StackCommit][2],AX
        JMP AssembleDone2
PE32Stack	ENDP


PE32Heap	PROC
        CMP     AL,Num32
        JA  pe32HpTooBig
        MOV     [pe32HeapReserve],DX
        MOV     AX,[OWordNum][2]
        MOV     [pe32HeapReserve][2],AX
        CALL    GetNext
        CMP AH,Number
        JZ  PE32HpCommit
        MOV BX,(pe32HeapReserve)
        MOV AH,Num32
        JMP PE32HeapOK
PE32HpCommit:
        MOV BX,(OWordNum)
PE32HeapOK:
        CMP AL,Num32
        JA  pe32HpTooBig
        MOV AX,[BX]
        MOV [pe32HeapCommit],AX
        MOV AX,[BX][2]
        MOV [pe32HeapCommit][2],AX
        JMP AssembleDone2
        
pe32HpTooBig:
		JMP	NumTooBig
PE32Heap	ENDP


COFFCheckClassName  PROC
    PUSH    AX,CX,SI,DI
	LODSW
    MOV CX,AX
    CMP CX,8
    JBE COFFCheckClassNameOK
    MOV CX,8
    MOV [SI][-2],CX
 COFFCheckClassNameOK:
    MOV DI,SI
    ADD DI,CX   ;Point to end of class name
    MOV DX,8
    SUB DX,CX
    MOV CX,DX
    MOV AL,0
    REP STOSB
    POP DI,SI,CX,AX
    RET
COFFCheckClassName  ENDP
