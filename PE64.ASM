OpenPE64GetParam	PROC
	JMP ope64gpGetParams

ope64gpOS2:
	AND WORD [pe64SubSystem],NOT 1
	OR  WORD [pe64SubSystem],4
	JMP ope64gpGetParams

ope64gpGUI:
	AND WORD [pe64SubSystem],NOT 1
	JMP ope64gpGetParams

ope64gpDLL:
;        AND WORD [pe64Character],NOT 2
	OR  WORD [pe64Character],2000h
	MOV WORD [pe64DLLCharacter],0Fh
	JMP ope64gpGetParams

ope64gpDebug:
	JMP ope64gpGetParams

ope64gpPosix:
	MOV WORD [pe64SubSystem],7
	JMP ope64gpGetParams

ope64gpParams3:
	CMP AX,1F90h
	JZ  ope64gpOS2

	CMP AX,0A5CBh
	JZ  ope64gpGUI

	CMP AX,3AB7h
	JZ  ope64gpDLL

	JMP ope64gpGetParams

ope64gpParams5:

	CMP AX,544Fh
	JZ  ope64gpDebug

	CMP AX,0FC47h
	JZ  ope64gpPosix

ope64gpGetParams:
	CALL	GetNextStr

	MOV DI,SI

	MOV CX,[StrLen]
	TEST	CX,CX
	JZ  ope64gpDone

	MOV AX,[StrCRC]
	MOV DX,[StrCRC][2]

	CMP CL,3
	JZ  ope64gpParams3


	CMP CL,5
	JZ  ope64gpParams5

	CMP CL,6
	JZ  ope64gpParams6

	CMP CL,7
	JZ  ope64gpParams7

	CMP CL,10
	JZ  ope64gpParams10
 ope64gpDone:
	RET

ope64gpParams6:
	CMP AX,0E4EFh
	JZ  ope64gpNative

	JMP ope64gpGetParams

ope64gpNative:
	MOV WORD [pe64SubSystem],1
	JMP ope64gpGetParams
    
ope64gpParams7:
	CMP AX,0C547h
	JZ  ope64gpWindows

	CMP AX,0C953h
	JZ  ope64gpConsole

	JMP ope64gpGetParams

ope64gpWindows:
	AND WORD [pe64SubSystem],NOT 1
	OR  WORD [pe64SubSystem],2
	JMP ope64gpGetParams

ope64gpConsole:
	OR  WORD [pe64SubSystem],1
	JMP ope64gpGetParams

ope64gpParams10:
	CMP AX,82E0h
	JZ  ope64gpExe
	JMP ope64gpGetParams

ope64gpExe:
	AND WORD [pe64Character],NOT 2000h
	OR  WORD [pe64Character],2
	JMP ope64gpGetParams	
OpenPE64GetParam	ENDP


cpe64CheckIfValidSection:
    CMP WORD [DI][2].pesRawPTR,DX
    JNZ cpe64SectionOK
cpe64Ret:
    RET

ClosePE64Seg	PROC
	MOV	DI,[pe64Seg]

	MOV	AX,[OBufferPTR]
	XOR	DX,DX
	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]    ;Calc section PTR from file start (BYTE 0)

	SUB	AX,[DI].pesRawPTR   ;SUB section start PTR to get section SIZE
	SBB	DX,[DI][2].pesRawPTR

    XOR BX,BX       ;Make it zero for future use

    CMP WORD [DI].pesRawPTR,BX  ;if zero
    JZ  cpe64CheckIfValidSection
    TEST WORD [pe64Flags],0F0h
    JZ  cpe64Ret
 cpe64SectionOK:

	MOV	CX,AX		    ;copy INTO SI:CX
	MOV	SI,DX

	PUSH	BX
	XCHG	BX,[UninitData]
	ADD	CX,BX		    ;calculate virtual SIZE.
	POP	BX
	XCHG	BX,[UninitData][2]
	ADC	SI,BX		    ;without aligning

	MOV	BX,[pe64SectionAlign]
	CALL	AlignCX
	MOV	[DI].pesVirtualSize,CX
	MOV	[DI][2].pesVirtualSize,SI

	PUSH	AX

	MOV	AX,[pe64Flags]
	TEST	AL,10h	      
	JNZ	ClosePE64ImportSeg
	TEST	AL,20h	      
	JNZ	ClosePE64ExportSeg

	TEST	AH,20h
	JNZ	ClosePE64ResourceSeg

    TEST    AL,40h
	JNZ	ClosePE64DataSeg

    TEST    AL,80h
    JZ      ClosePE64DataSeg

	MOV	BX,(pe64CodeSize)

ClosePE64CodeSeg:
	TEST	AL,1
	JNZ	ClosePE64SegOK
        OR      AL,1
        MOV     BYTE [pe64Flags],AL
	MOV	AX,[DI].pesRVA
	MOV	[pe64CodeBase],AX
	MOV	AX,[DI][2].pesRVA
	MOV	[pe64CodeBase][2],AX
	JMP	ClosePE64SegOK

ClosePE64ImportSeg:
	MOV	BX,(pe64ImportSize)
	JMP	ClosePE64SegOK

ClosePE64ExportSeg:
	MOV	BX,(pe64ExportSize)
	JMP	ClosePE64SegOK

ClosePE64ResourceSeg:
	MOV	BX,(pe64ResourceSize)
	JMP	ClosePE64SegOK

ClosePE64DataSeg:
	MOV	BX,(pe64IDataSize)
	TEST	BYTE [pe64Flags],2
	JNZ	ClosePE64SegOK
        OR      BYTE [pe64Flags],2
;       MOV     AX,[DI].pesRVA
;       MOV     [pe64DataBase],AX
;       MOV     AX,[DI][2].pesRVA
;       MOV     [pe64DataBase][2],AX

ClosePE64SegOK:

        ADD WORD [BX],CX
	ADC	WORD [BX][2],SI
	POP AX

	PUSH	AX,DX		    ;Save, use it later to calc the padd bytes
	MOV	BX,[pe64FileAlign]    ;ALIGN section SIZE IN file
	CALL	AlignAX
	PUSH	AX,DX		    ;Save, use later to padd

	MOV	[DI].pesRawSize,AX  ;Write section SIZE, aligned.
	MOV	[DI][2].pesRawSize,DX

	ADD	CX,[DI].pesRVA
	ADC	SI,[DI][2].pesRVA

	MOV	BX,[pe64SectionAlign]
	CALL	AlignCX
	ADD	AX,[DI].pesRawPTR
	ADD	DX,[DI][2].pesRawPTR

	ADD	DI,(SIZE PESection)
	MOV	[pe64Seg],DI

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
	AND	WORD [pe64Flags],0CF0Fh
	RET
ClosePE64Seg	ENDP

OpenPE64Format	PROC
	MOV AX,[pe64RelocSeg]
	TEST	AX,AX
	JNZ OpenPE64MemOK
	MOV BX,01000h
	CALL	AllocateMem
	JNC	OpenPE64MemOK
	MOV	BYTE [Error],QuitError
	MOV	SI,OFFSET _NotEnoughMem
	CALL	PrintError
	MOV	BYTE [Msg],EndOfFile
	MOV	SP,WORD [AsmStack]
	JMP	AssembleEndOfFile

OpenPE64MemOK:
	MOV [pe64RelocSeg],AX
	MOV WORD [OutFlags],0300h
	XOR AX,AX
	MOV [pe64RelocPTR],AX
	MOV WORD [pe64Seg],(pe64Sections)
	MOV [pe64SegAttr],AX
	MOV [pe64SegAttr][2],AX
	MOV BYTE [CurSeg],0FEh
	MOV BYTE [CurSeg][3],0FEh

	MOV WORD [pe64Signature],"EP"

	MOV WORD [pe64Machine],8664h
	MOV WORD [pe64SizeOptional],0F0h
	MOV WORD [pe64Character],002fh
	MOV WORD [pe64Magic],20Bh
	
	MOV	DX,thisVersion
	XCHG DL,DH
	MOV WORD [pe64Version],DX

	MOV WORD [pe64ImageBase],AX
	MOV WORD [pe64ImageBase][2],40h

	MOV WORD [ProgIP],AX
	MOV WORD [ProgIP][2],40h
	MOV WORD [ProgIP][4],AX 						
	MOV WORD [ProgIP][6],AX

	MOV WORD [pe64SectionAlign],1000h
	MOV WORD [pe64FileAlign],200h
	AND WORD [pe64Flags],200h

	MOV DI,(pe64ExportRVA)
	MOV CX,8*16
	REP STOSW

	MOV WORD [pe64CodeSize],AX
	MOV WORD [pe64CodeSize][2],AX
	MOV WORD [pe64IDataSize],AX
	MOV WORD [pe64IDataSize][2],AX

	MOV WORD [pe64UDataSize],AX
	MOV WORD [pe64UDataSize][2],AX

	MOV WORD [pe64OSVersion],1

	MOV WORD [pe64SubSysVersion],4
	MOV WORD [pe64SubSysVersion][2],0

	MOV WORD [pe64SubSystem],2

	MOV WORD [pe64NumRVAs],10h
	MOV WORD [pe64NumRVAs][2],AX

	MOV WORD [pe64StubSize],80h
	MOV WORD [SegAlignment],1

	MOV WORD [StrPTR],(FmtParams)
	CALL OpenPE64GetParam
;OpenPE64ParamsOK:
	MOV AX,[pe64NumSections]
	MOV DX,(SIZE PESection)
	MUL DX
	ADD AX,(pe64Sections-pe64Signature)
	ADD AX,[pe64StubSize]
	MOV BX,[pe64FileAlign]

	DEC BX
	ADD AX,BX
	NOT BX
	AND AX,BX
	MOV AX,600h
	MOV [FileSize],AX
	MOV [pe64HeadersSize],AX
	MOV DX,AX
	XOR CX,CX
	MOV AL,0
	MOV BX,[OutHandle]
	CALL	FSeek
	CALL	_USE64
	OR	BYTE [ExtMask],SYM_NEEDSRELOC
	RET
OpenPE64Format	ENDP

ClosePE64File	PROC
	TEST	BYTE [pe64Flags][1],3    ;Is there any reloc
	JNZ cpe64Reloc
	JMP cpe64RelocOK

cpe64Reloc:

	MOV	DI,[pe64Seg]
	MOV	CX,[pe64RelocRVA]
	MOV	SI,[pe64RelocRVA][2]
	CALL	PE64RelocChangeBase

	MOV	AX,[DI].pesRVA	   ;Current RVA = reloc. We're about to write
	MOV [pe64BaseRelocRVA],AX
	MOV	AX,[DI][2].pesRVA
	MOV [pe64BaseRelocRVA][2],AX
	
	MOV	AX,[pe64RelocPTR]
	MOV	BX,AX
	SUB	AX,[pe64RelocStart]   ;RelocPTR-RelocStart
	CMP	AX,8		    ;Is it > 8
	JA	cpe64RelocSizeOK
	MOV	BX,[pe64RelocStart]   ;IF <=8, point to start

cpe64RelocSizeOK:

	ADD	BX,3		    ;ALIGN to 32-bits
	AND	BL,NOT 3
	MOV	AX,[NewFileSize]
	MOV	DX,[NewFileSize][2]
	ADD	AX,BX
	ADC	DX,0
	MOV	[pe64BaseRelocSize],AX
	MOV	[pe64BaseRelocSize][2],DX
	MOV	DI,[pe64Seg]
	PUSH	BX

	MOV	CX,AX
	MOV	SI,DX

	MOV	BX,[pe64FileAlign]
	CALL	AlignCX
	MOV	[DI].pesRawSize,CX
	MOV	[DI][2].pesRawSize,SI

	MOV	BX,[pe64SectionAlign]
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

	MOV	[pe64Seg],DI

	XOR	DX,DX
	MOV	CX,DX
	MOV	AL,2
	MOV	BX,[OutHandle]
	CALL	FSeek

	POP BX

	MOV	SI,[NewHandle]
	TEST	SI,SI
	JZ  cpe64RelocNewOK
	PUSH	BX
	MOV	DI,[OutHandle]
	CALL	FCopy
	POP BX
cpe64RelocNewOK:
	TEST	BX,BX
	JZ  cpe64RelocOK
	PUSH	DS
	XOR	DX,DX
	MOV	DI,BX
	LEA	CX,[BX][4]
	MOV	BX,[OutHandle]
	MOV	DS,[pe64RelocSeg]
	MOV	WORD [DI],DX
	MOV	WORD [DI][2],DX
	CALL	FWrite
	POP DS

cpe64RelocOK:
	MOV	DI,[pe64Seg]
	MOV	AX,[DI].pesRVA
	MOV	[pe64ImageSize],AX
	MOV	AX,[DI][2].pesRVA
	MOV	[pe64ImageSize][2],AX

	XOR	DX,DX
	MOV	CX,DX
	MOV	AL,0
	CALL	FSeek

	MOV SI,(DosStub)
	MOV ES,[OBufferPTR][2]
	MOV CX,[pe64StubSize]
	XOR DI,DI
	MOV DX,DI
	REP MOVSB
	MOV SI,(MiscFmt)
	MOV CX,[pe64HeadersSize]
	SUB CX,[pe64StubSize]
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
	MOV BX,[pe64FileAlign]
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
ClosePE64File	ENDP

InitPE64	PROC
	MOV DI,[pe64Seg]

	MOV AX,[OBufferPTR]
	XOR DX,DX
	ADD AX,[FileSize]
	ADC DX,[FileSize][2]

	PUSH	AX,DX
	MOV CX,AX
	MOV SI,DX

	MOV BX,[pe64FileAlign]
	CALL	AlignAX
	MOV [DI].pesRawPTR,AX
	MOV [DI][2].pesRawPTR,DX

	MOV BX,[pe64SectionAlign]
	CALL	AlignCX
	MOV [DI].pesRVA,CX
	MOV [DI][2].pesRVA,SI

	POP SI,CX
	SUB AX,CX
	SBB DX,SI
	MOV CX,AX
	CALL	PaddBytes

	CMP BYTE [Pass],1
	JZ  InitPE64Pass1
	RET
InitPE64Pass1:
	MOV WORD [pe64NumSections],0
	MOV WORD [pe64RelocPTR],0
    OR      BYTE [RefFlags],16
	RET
InitPE64	ENDP

PE64InitSeg	PROC
	TEST	BYTE [Temp4],1
	JNZ PE64InitSegClassOK
	CALL	COFFSectionClass
 PE64InitSegClassOK:
	MOV	DI,[pe64Seg]

	TEST	BYTE [Temp4],2
	JNZ	PE64InitSegAddrOK
	MOV	AX,[DI].pesRVA
	MOV	DX,[DI][2].pesRVA
	ADD	AX,[pe64ImageBase]
	ADC	DX,[pe64ImageBase][2]
	MOV	[ProgIP],AX
	MOV	[ProgIP][2],DX
	XOR	AX,AX
	MOV	[ProgIP][4],AX
	MOV	[ProgIP][6],AX
 PE64InitSegAddrOK:
	XOR	AX,AX
	XOR	DX,DX
	TEST	[pe64Flags],0F0h
	JNZ	PE64InitSegOK
 PE64DefaultCode:
	MOV	WORD [DI].pesCharacter,20h
	MOV	WORD [DI][2].pesCharacter,60h
    OR  BYTE [pe64Flags],40h  ;This is data
 PE64InitSegOK:
	CMP	BYTE [Pass],1
	JNZ	PE64InitDone
	INC	WORD [pe64NumSections]
 PE64InitDone:
	RET
PE64InitSeg	ENDP

PE64Reloc	PROC
	PUSH	ES,SI,DI
	MOV	AX,DI
	MOV	DI,[pe64Seg]
	SUB	AX,[DiskOutStart]
	XOR	DX,DX
	ADD	AX,[FileSize]
	ADC	DX,[FileSize][2]
	SUB	AX,[DI].pesRawPTR
	SBB	DX,[DI][2].pesRawPTR
	ADD	AX,[DI].pesRVA
	ADD	DX,[DI][2].pesRVA
PE64RelocCalcRVA:
	MOV	CX,AX
	MOV	SI,DX
	TEST	BYTE [pe64Flags][1],1
	JZ	PE64RelocNextRVA
	SUB	AX,[pe64RelocRVA]
	SBB	DX,[pe64RelocRVA][2]
	JNZ	PE64RelocNextRVA
	CMP	AX,0FFFh
	JA	PE64RelocNextRVA
	JMP	PE64RelocRVAOK
PE64RelocNextRVA:
	MOV	AX,CX
	MOV	DX,SI
	MOV	BX,NOT 0FFFh	    ;Find next RVA which gives smallest disp
	AND	CX,BX
	XCHG	[pe64RelocRVA],CX
	XCHG	[pe64RelocRVA][2],SI
	CALL	PE64RelocChangeBase
	JMP	PE64RelocCalcRVA
PE64RelocRVAOK:
	MOV	BYTE [RelocFlags],0
	PUSH	ES
	OR	AH,30h
	LES	DI,[pe64RelocPTR]
	STOSW
	MOV [pe64RelocPTR],DI
	POP ES
	CMP	DI,0FFF0h
	JA	PE64RelocFlush
pe64rDone:
	POP	DI,SI,ES
	RET
PE64RelocFlush:
	CALL	PE64RelocChangeBase
	CMP WORD [NewHandle],0
	JNZ pe64rfCreateNew
 pe64rfWrite:
	PUSH	DS
	MOV BX,[NewHandle]
	MOV DS,[pe64RelocSeg]
	XOR DX,DX
	MOV CX,8
	XCHG	CX,[pe64RelocPTR]
	CALL	FWrite
	ADD WORD [NewFileSize],AX
	ADC WORD [NewFileSize][2],0
	POP DS
	MOV [pe64RelocStart],DX
	JMP	pe64rDone
 pe64rfCreateNew:
	CALL	CreateNewFile
	JMP pe64rfWrite
PE64Reloc	ENDP

PE64RelocChangeBase	PROC
	PUSH	ES,DI		;ALIGN to next 32-bits
	LES	DI,[pe64RelocPTR]
	MOV	WORD ES:[DI],0	;Clear next WORD. Alignment could pass it
	ADD	DI,3
	AND	DI,NOT 3
	MOV	BX,DI	    ;Use RelocPTR to calc the len of previous base
	ADD	DI,8		;Give space FOR the length AND base
	XCHG	BX,[pe64RelocStart]
	MOV	[pe64RelocPTR],DI ;New aligned PTR
	TEST	BYTE [pe64Flags][1],1
	JZ	pe64rcFirstReloc
	SUB	DI,8
	SUB	DI,BX	    ;Length=RelocPTR-RelocStart
	CMP	DI,8
	JBE	pe64rcReUse
	MOV	ES:[BX],CX  ;BaseRVA
	MOV	ES:[BX][2],SI
	MOV	ES:[BX][4],DI	    ;Length
	MOV	WORD ES:[BX][6],0
	JMP	pe64rcDone
pe64rcReUse:
	MOV	[pe64RelocStart],BX
	ADD	BX,8
	MOV	[pe64RelocPTR],BX
	JMP	pe64rcDone
pe64rcFirstReloc:
	TEST	BYTE [pe64Flags][1],2
	JNZ	pe64rcDone
	INC	WORD [pe64NumSections]
pe64rcDone:
	OR	BYTE [pe64Flags][1],3
	POP	DI,ES
	RET
PE64RelocChangeBase	ENDP

ImportPE64	PROC
	MOV	AX,[Temp2]
	MOV	AX,[_peBufferPTR]
	MOV	AX,[Temp10]
	MOV	AX,[_peLibTable]
	TEST	BYTE [OutFlags][1],1
	JZ	ipe64InvalidKW
	TEST	BYTE [pe64Flags],10h
	JZ	ipe64InvalidKW
	AND	BYTE [OutFlags][1],NOT 1

	PUSH	ES
	LES	DI,[OBufferPTR]		;Output buffer PTR
	MOV	[_peBufferPTR],0
	MOV	[_peBufferSeg],ES			;Pre-point outbuffer to ES:0
	POP	ES
	MOV	AX,[FileSize]
	MOV	DX,[FileSize][2]
	ADD	AX,DI				;Get the Raw PTR to current section
	ADC	DX,0

	MOV	DI,[pe64Seg]		;Get current segment
	CMP	AX,[DI].pesRawPTR	;Is the Raw PTR equal to fileposition?
	JNZ	ipe64InvalidKW		;If not, we are at a wrong place
	CMP	DX,[DI][2].pesRawPTR
	JNZ	ipe64InvalidKW
	CALL	WriteOutFile	;Clear the buffer to create space for the import section
	OR	BYTE [Settings][1],3	;Pass quotes as they are,Dont force an address if an number is after an operand size spec

	MOV	WORD [_peDescSize],(5*4)  ;Init Descriptor Length with the empty directory entry
	MOV	WORD [_peDirSize],(5*4)  ;Init total size of directory

	JMP	ipe64GetLib

 ipe64InvalidKW:
	MOV	SI,(_InvalidKeyword)
	JMP	PrtErrorQuit

 ipe64LibExpected:
	MOV	SI,(_InvalidOperand)
	JMP	PrtErrorQuit

 ipe64InvalidOp2:
	MOV SI,(_InvalidOperand)
	JMP	PrtErrorQuit

 ipe64GetLib:
	CALL	GetNext
	CMP	AX,Quote
	JNZ ipe64LibExpected
	CMP	DH,0
	JA  ipe64InvalidOp2
	CMP	DL,0
	JZ  ipe64InvalidOp2
	MOV	CX,DX
	INC	DX			;Allow for null terminator
	ADD	[_peLibNamesLen],DX	;LibraryNames Len
	ADD	WORD [_peSectionSize],8	;After each library, we put modulename ptrs followed by a null qword
	ADD	WORD [_peDescSize],(5*4)  ;Descriptor Length
	ADD	DX,(5*4)+8	;8 since there are 2 RVA tables
	ADD	[_peDirSize],DX	;Entire directory Len
	LES	DI,[_peBufferPTR]	;ES:DI=OutBuffer
	MOV	AL,CL		;Numbytes of library name
	STOSB
	MOV	SI,(StrBuffer)	
	REP	MOVSB
	MOV	[_peBufferPTR],DI	;Save outbuffer position
	JMP ipe64GetModules

 ipe64Instr:
	CMP DX,(EndDirective)
	JZ  ipe64Finalize
	CMP DX,(ImportDirective)
	JNZ ipe64InvalidOp
	JMP ipe64GetLib

 ipe64Finalize:
	JMP	ipe64Finalize2

 ipe64NewLine:
	ADD WORD [LineNumber],1
	ADC WORD [LineNumber][2],0
	CMP BYTE [Msg],EndOfFile
	JZ  ipe64Finalize
	MOV BYTE [EOLFlag],0
 ipe64GetModules:
	CALL	GetNext
	CMP	AL,EndOfLine
	JZ  ipe64NewLine
	CMP	AX,CPUInstruction
	JZ  ipe64Instr
	CMP	AH,Identifier
	JNZ ipe64IDExpected
	MOV	CX,DI
	LES	DI,[_peBufferPTR]		;Fetch outbuffer ptr
	CMP	AL,UnknownID	;If the import ID given exists
	JNZ ipe64Exists
	MOV AL,0
	STOSB
	MOV	AX,CX			;Save ID's CRC32
	STOSW
	MOV	AX,BP
	STOSW
	MOV	AL,[StrLen]		;Length of ID
	STOSB
	JMP	ipe64ModuleOK

 ipe64IDExpected:
 ipe64InvalidOp:
	MOV SI,(_InvalidOperand)
	JMP	PrtErrorQuit

 ipe64DupDef:
	MOV SI,(_DupDef)
	JMP PrtErrorQuit

 ipe64Exists:
	TEST	BYTE [RefFlags],8

	PUSH	DS
	LDS	SI,[SymPos]

	JNZ ipe64ExistsOK

	TEST	BYTE [SI].seIDFlags,SYM_UNDEF
	JZ  ipe64DupDef
 ipe64ExistsOK:

	MOV AL,0
	STOSB
	MOV	AX,SI
	STOSW
	MOV	AX,DS
	STOSW
	MOV	AL,0
	STOSB
	CMP	BYTE [SI].seIDType,QWordID
	JZ  ipe64TypeOK
	MOV BYTE [SI].seIDType,QWordID
	OR  BYTE [RefFlags],10h
 ipe64TypeOK:
	POP DS
 ipe64ModuleOK:
	MOV	[_peBufferPTR],DI
	CALL	GetNext
	LES	DI,[_peBufferPTR]
	CMP	AH,Number
	JZ  ipe64ModuleOrdinal
	CMP	AX,Quote
	JNZ ipe64InvalidOp
	CMP DH,0
	JNZ ipe64InvalidOp
	CMP	DL,0
	JZ  ipe64InvalidOp
	MOV	AL,DL	;Store length of library name
	STOSB
	MOV	SI,(StrBuffer)	;Store the library name
	MOV	CX,DX
	REP	MOVSB
	ADD	DX,3			;Modulename, the nullchar and a word before the modname
	ADD	[_peModuleNamesLen],DX  ;Module Names Length
	ADD	[_peDirSize],DX
	ADD	WORD [_peSectionSize],8		;Increase the size of whole section. 8bytes for the pointer
	MOV	[_peBufferPTR],DI
	JMP ipe64GetModules
 ipe64ModuleOrdinal:
	MOV	AL,0
	STOSB
	MOV	AX,DX
	STOSW
	XOR	AX,AX
	STOSW			;??????????????????????
	MOV	[_peBufferPTR],DI
	JMP ipe64GetModules

ipe64Finalize2:
	MOV SI,(OWordNum)
	MOV AX,[ProgIP][-2]
	MOV [SI][1],AX
	MOV AL,[ProgIP][-3]
	MOV [SI],AL

	MOV AX,[_peDescSize]	;Descriptor length = library name pointer
	ADD AX,[_peLibNamesLen]	;Library names len+DescLen = module name pointer
	MOV [_peLibNamesLen],AX	;Store it

	ADD AX,[_peModuleNamesLen]	;Module Names Len+Module Names Pointer=FirstThunk
	MOV [_peModuleNamesLen],AX	;Store it
	MOV [_peLibTable],AX ;Fixed Pointer to First Thunk

	MOV BX,[pe64Seg]
	MOV AX,[BX].pesRVA
	MOV DX,[BX][2].pesRVA
	ADD AX,[pe64ImageBase]
	ADC DX,[pe64ImageBase][2]
	ADD AX,[_peModuleNamesLen]				;First Thunk
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
	POP CX		;Restore start of pointer of unprocessed stuff. We want to zero out everything to that point also
	MOV SI,CX	;which is also the unprocessed pointer
	XOR DI,DI	;Zero from address 0 to unprocessed start
	MOV AL,0
	REP STOSB
	ADD WORD [_peBufferPTR],2  ;Add length by the end bytes 00FFh
;	MOV [_peBufferPTR],AX	;init Source Pointer ????
	MOV [_peDirTable],AX	;init Directory Pointer
	MOV ES,[_peBufferSeg]	;Destination pointer
	JMP ipe64flGetLib

 ipe64Done:
	MOV SI,[_peLibTable]     ;First thunk start
	MOV DI,SI
	MOV CX,[_peSectionSize]	    ;Total size of import directory
	ADD DI,CX
	JMP AssembleDone

 ipe64flGetLib:
	MOV	CX,ES:[SI]  ;GetLen
	CMP CX,0FFh	    ;CX=00FFh - terminator
	JZ  ipe64Done

	MOV DI,[pe64Seg]
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
 ipe64flGetModules:
	CMP BYTE ES:[SI],0
	JNZ ipe64flModulesDone
	INC SI
	MOV AL,ES:[SI][4]
	CMP AL,0
	JZ  ipe64flExists
	MOV CL,AL
	MOV CH,QWordID
	MOV DI,ES:[SI]
	MOV BP,ES:[SI][2]
	PUSH	ES,SI
	MOV SI,(OWordNum)
	MOV BYTE [SI],0
	CALL	WriteSymbol
	POP SI,ES
	MOV BX,[_peBufferPTR]
	JMP ipe64flWriteModule

 ipe64flModulesDone:
	ADD WORD [_peModuleNamesLen],8
	ADD WORD [OWordNum][4],8    ;Null
	ADC WORD [OWordNum][6],0
	JMP ipe64flGetLib

 ipe64flExists:
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
	JZ  ipe64flWriteModule
	OR  BYTE [RefFlags],10h
 ipe64flWriteModule:
	ADD SI,5    ;Move from the Crc or SymPos

	LODS	BYTE ES:[SI]	;Get module name length
	CMP AL,0
	JZ  ipe64flOrdinal

	MOV CL,AL		;Prepare string length
	MOV CH,0

	MOV DI,[pe64Seg]
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

	ADD WORD [_peModuleNamesLen],8			;Since its a QWord
	ADD WORD [OWordNum][4],8
	ADC WORD [OWordNum][6],0
	JMP ipe64flGetModules
 ipe64flOrdinal:
	MOV DI,[_peModuleNamesLen]
	ES:MOVSW
	ES:MOVSW	
	XOR	AX,AX
	STOSW
	MOV AH,80h
	STOSW
	ADD WORD [_peModuleNamesLen],8
	ADD WORD [OWordNum][4],8
	ADC WORD [OWordNum][6],0
	JMP ipe64flGetModules
ImportPE64	ENDP

ExportPE64	PROC
	JMP	epe64Start

	epe64InvalidKW:
	JMP	InvalidKeyword
 
 epe64Start:
	TEST	BYTE [OutFlags][1],2
	JZ	epe64InvalidKW
	TEST	BYTE [pe64Flags],20h
	JZ	epe64InvalidKW
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

	MOV	DI,[pe64Seg]
	CMP	AX,[DI].pesRawPTR
	JNZ	epe64InvalidKW
	CMP	DX,[DI][2].pesRawPTR
	JNZ	epe64InvalidKW
	CALL	WriteOutFile
	OR	BYTE [Settings][1],3
	CALL	GetNext
	CMP	AX,Quote
	JNZ epe64LibExpected
	CMP	DH,0
	JNZ	epe64InvalidOp
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
	JMP epe64GetModule
 epe64LibExpected:
	JMP	InvalidOperand
 epe64Instr:
	CMP DX,(EndDirective)
	JZ  epe64Done
	JMP InvalidOperand
 epe64Done:
	JMP epe64Done2
 epe64gmEOL:
	CMP	BYTE [Msg],EndOfFile
	JZ  epe64Done
	ADD WORD [LineNumber],1
	ADC WORD [LineNumber][2],0
	MOV BYTE [EOLFlag],0
 epe64GetModule:
	CALL	GetNext
	CMP	AL,EndOfLine
	JZ  epe64gmEOL
	CMP	AX,CPUInstruction
	JZ  epe64Instr
	CMP	AH,Identifier
	JNZ epe64InvalidOp
	CMP	AL,UnknownID
	JNZ epe64Exists
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
	JMP	epe64IDOK

 epe64IDNotFound:
	MOV SI,(_IDNotFound)
	JMP	PrtErrorQuit

 epe64InvalidOp:
	JMP	InvalidOperand

 epe64Exists:
	LES	DI,[SymPos]
	MOV	DX,ES:[DI].seIDData	;They are stored in reverse
	MOV	AX,ES:[DI][2].seIDData
	CMP	BYTE ES:[DI].seIDType,DWordID
	JZ	epe64IDTypeOK
	MOV	BYTE ES:[DI].seIDType,DWordID
	OR	BYTE [RefFlags],10h
 epe64IDTypeOK:
	TEST	BYTE ES:[DI].seIDFlags,SYM_UNDEF
	JZ  epe64IDOK
	TEST	BYTE [RefFlags],8
	JNZ epe64IDNotFound
 epe64IDOK:
	LES	DI,[Temp2]
	SUB DX,[pe64ImageBase]
	SBB AX,[pe64ImageBase][2]
	STD
	STOSW
	MOV AX,DX
	STOSW
	CLD
	MOV	[Temp2],DI
	CALL	GetNext
	CMP AX,Quote
	JNZ epe64InvalidOp
	CMP DH,0
	JNZ epe64InvalidOp

	LES DI,[Temp2]
	MOV BX,[pe64Seg]
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
	JMP epe64GetModule

 epe64Done2:
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

	MOV SI,[pe64Seg]
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
	JZ  epe64CopyDone
 epe64CopyLoop:
	CMP SI,CX
	JBE epe64CopyDone
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
	JMP epe64CopyLoop
 epe64CopyDone:
	MOV	DI,BX
	JMP	AssembleDone
ExportPE64	ENDP


EndPE64	PROC
		PUSH	BX,CX
        MOV AX,[SI]
        MOV BX,[SI][2]
        MOV	CX,[SI][4]
        MOV	DX,[SI][6]
        SUB AX,[pe64ImageBase]
        SBB BX,[pe64ImageBase][2]
        SBB BX,[pe64ImageBase][4]
        SBB BX,[pe64ImageBase][6]
        
        MOV [pe64EPoint],AX
        MOV [pe64EPoint][2],BX
        MOV [pe64EPoint][4],CX
        MOV [pe64EPoint][6],DX
        POP	CX,BX
        RET
EndPE64	ENDP

;GetSegAddrPE64	PROC
;        XOR     AX,AX
;        MOV     DX,AX
;        STC
;        RET
;GetSegAddrPE64	ENDP


ImportSegPE64	PROC
        TEST    BYTE [pe64Flags],0F4h ;IF this is IMPORT/EXPORT/code/data OR IMPORT exists
        JNZ     ispe64Error
        OR      BYTE [pe64Flags],10h  ;This is IMPORT
        MOV     DI,[pe64Seg]
        MOV     AX,[DI].pesRVA
        MOV     [pe64ImportRVA],AX
        MOV     AX,[DI][2].pesRVA
        MOV     [pe64ImportRVA][2],AX
        OR      BYTE [DI].pesCharacter,40h			;data
        OR      BYTE [DI][3].pesCharacter,0C0h      ;Readable, writeable
        CLC
        RET
ispe64Error:
		STC
		RET
ImportSegPE64	ENDP

		
ExportSegPE64	PROC
        TEST    BYTE [pe64Flags],0F8h  ;IF this is IMPORT/EXPORT/code/data OR EXPORT exists
        JNZ     espe64Error
        OR      BYTE [pe64Flags],20h  ;This is EXPORT
        MOV     DI,[pe64Seg]
        MOV     AX,[DI].pesRVA
        MOV     [pe64ExportRVA],AX
        MOV     AX,[DI][2].pesRVA
        MOV     [pe64ExportRVA][2],AX
        OR      BYTE [DI].pesCharacter,40h      ;data
        OR      BYTE [DI][3].pesCharacter,40h   ;readable
        CLC
        RET
espe64Error:
		STC
		RET
ExportSegPE64	ENDP

CodeSegPE64	PROC
        MOV     AL,[pe64Flags]
        TEST    AL,0F0h     ;IF this is code,IMPORT,EXPORT OR data
        JNZ cspe64Error
        OR      BYTE [pe64Flags],80h          ;this is code
        MOV     DI,[pe64Seg]
        OR      BYTE [DI].pesCharacter,20h      ;code
        OR      BYTE [DI][3].pesCharacter,60h   ;readable, executable
        CLC
        RET
cspe64Error:
		STC
		RET
CodeSegPE64	ENDP

NotPagedSegPE64	PROC
		MOV     DI,[pe64Seg]
        OR      BYTE [DI][3].pesCharacter,4      ;Notpageable
        CLC
        RET
NotPagedSegPE64	ENDP

DiscardableSegPE64	PROC
        MOV     DI,[pe64Seg]
        OR      BYTE [DI][3].pesCharacter,2      ;Discardable
        CLC
        RET
DiscardableSegPE64	ENDP

ExecutableSegPE64	PROC
        MOV     AL,[pe64Flags]
        TEST    AL,80h
        JZ  xspe64Error
        CLC
        RET
xspe64Error:
		STC
		RET

ExecutableSegPE64	ENDP


ResSegPE64	PROC
        TEST    BYTE [pe64Flags][1],10h
        JNZ rspe64Error
        MOV     DI,[pe64Seg]
        MOV     AX,[DI].pesRVA
        MOV     [pe64ResourceRVA],AX
        MOV     AX,[DI][2].pesRVA
        MOV     [pe64ResourceRVA][2],AX
        OR      BYTE [pe64Flags][1],30h
        CLC
        RET
rspe64Error:
        STC
        RET
ResSegPE64	ENDP


ShareableSegPE64	PROC
        MOV     DI,[pe64Seg]
        OR      BYTE [DI][3].pesCharacter,10h      ;Shaareable
        CLC
        RET
ShareableSegPE64	ENDP


WritableSegPE64	PROC		
        MOV     AL,[pe64Flags]
        TEST    AL,80h      ;Is this code
        JNZ wspe64Error
        MOV     DI,[pe64Seg]
        OR      BYTE [DI][3].pesCharacter,80h      ;Writable
        CLC
        RET
wspe64Error:
		STC
		RET
WritableSegPE64	ENDP

		
DataSegPE64	PROC
        MOV     AL,[pe64Flags]
        TEST    AL,0F0h     ;IF this is code,IMPORT,EXPORT OR data
        JNZ dspe64Error
        OR      BYTE [pe64Flags],40h
        MOV     DI,[pe64Seg]
        OR      BYTE [DI].pesCharacter,40h      ;data
        OR      BYTE [DI][3].pesCharacter,40h   ;readable
        CLC
        RET
dspe64Error:
		STC
		RET
DataSegPE64	ENDP

ReadableSegPE64	PROC
        MOV     DI,[pe64Seg]
        OR      BYTE [DI][3].pesCharacter,40h      ;readable
        CLC
        RET
ReadableSegPE64	ENDP


PE64Stack	PROC		
        CMP     AL,Num32
        JA  PE64StackTooBig
        MOV     [pe64StackReserve],DX
        MOV     AX,[OWordNum][2]
        MOV     [pe64StackReserve][2],AX
        CALL    GetNext
        CMP AH,Number
        JZ  PE64GetStackCommit
        MOV BX,(pe64StackReserve)
        MOV AH,Num32
        JMP PE64StackOK

PE64StackTooBig:
		JMP	NumTooBig

PE64GetStackCommit:
        MOV BX,(OWordNum)
PE64StackOK:
        CMP AL,Num32
        JA  PE64StackTooBig
        MOV AX,[BX]
        MOV [pe64StackCommit],AX
        MOV AX,[BX][2]
        MOV [pe64StackCommit][2],AX
        JMP AssembleDone2
PE64Stack	ENDP


PE64Heap	PROC
        CMP     AL,Num64
        JA  pe64HpTooBig
        MOV	[pe64HeapReserve],DX
        MOV	AX,[OWordNum][2]
        MOV	[pe64HeapReserve][2],AX
        CALL    GetNext
        CMP AH,Number
        JZ  pe64HpCommit
        MOV BX,(pe64HeapReserve)
        MOV AH,Num64
        JMP PE64HeapOK
pe64HpCommit:
        MOV BX,(OWordNum)
pe64HeapOK:
        CMP AL,Num64
        JA  pe64HpTooBig
        MOV AX,[BX]
        MOV [pe64HeapCommit],AX
        MOV AX,[BX][2]
        MOV [pe64HeapCommit][2],AX
        MOV AX,[BX][4]
        MOV [pe64HeapCommit][4],AX
        MOV AX,[BX][6]
        MOV [pe64HeapCommit][6],AX
        JMP AssembleDone2
        
pe64HpTooBig:
		JMP	NumTooBig

PE64Heap	ENDP
