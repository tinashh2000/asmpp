INCLUDE     'mz.asm'    ;MZ executable
INCLUDE     'ne.asm'    ;NE executable
INCLUDE     'elf.asm'   ;ELF 32 AND 64
INCLUDE     'pe32.asm'	;PE32
INCLUDE     'pe64.asm'	;PE64
INCLUDE     'omf.asm'	;OMF16 AND 32
INCLUDE     'coff32.asm'  ;COFF32 AND 64
INCLUDE     'coff64.asm'  ;COFF32 AND 64

CloseOutFile	PROC
        CMP     WORD [NumErrors],0
        JNZ     CloseOutRemoveFile
CloseOutFileSizeOK:
        MOV     AX,WORD [OBufferPtr]
        CMP     AX,WORD [DiskOutStart]
        JZ      CloseOutFileWriteOK
        MOV     BYTE [Msg],EndOfFile
        CALL    WriteOutFile
        MOV     BYTE [Msg],0
		JMP	CloseOutFileWriteOK
CloseOutRemoveFile:
        MOV     BX,WORD [OutHandle]
        TEST    BX,BX
        JZ      CloseOutFileRemoveOK
        CALL    FClose
        MOV     SI,OFFSET OutFile
        MOV     DX,SI
        CALL    FDelete
        MOV     WORD [SI],0
CloseOutFileRemoveOK:
        RET
CloseOutFileBlank:
        TEST    BYTE [RefFlags],80h
        JNZ     CloseOutFileSizeOK2
        RET		
CloseOutFileWriteOK:        
        XOR     AX,AX
        CMP     WORD [FileSize][2],AX
        JNZ     CloseOutFileSizeOK2
        CMP     WORD [FileSize],AX
        JZ      CloseOutFileBlank
CloseOutFileSizeOK2:
        CMP     BYTE [OutFormat],OutCOM
        JZ      CloseOutFileExit
        MOV     AL,00
        XOR     DX,DX
        XOR     CX,CX
        MOV     BX,WORD [OutHandle]
        CALL    FSeek
        MOV     AL,BYTE [OutFormat]
        CMP     AL,OutMZ
        JZ      CloseMZ
        CMP     AL,OutCOFF32
        JZ      CloseCOFF32
		
        CMP     AL,OutCOFF64
        JZ      CloseCOFF64
		
        CMP     AL,OutELF32
        JZ      CloseELF32
        CMP     AL,OutELF64
        JZ      CloseELF64
        CMP     AL,OutNE16
        JZ      CloseNE16
        CMP     AL,OutPE32
        JZ      ClosePE32
        CMP     AL,OutPE64
        JZ      ClosePE64
        CMP     AL,OutOMF16
        JZ      CloseOMF16
        CMP     AL,OutOMF32
        JZ      CloseOMF32
CloseOutFileExit:
        CALL    PrintOutFile
        XOR     BX,BX
        XCHG    BX,WORD [OutHandle]
        CALL    FClose
        MOV     AX,WORD [FileSize]
        ADD     WORD [BytesWritten],AX
        MOV     AX,WORD [FileSize][2]
        ADC     WORD [BytesWritten][2],AX
CloseOutFileExit2:
        RET
CloseOMF16:
        JMP     CloseOMF16File
CloseOMF32:
        JMP     CloseOMF32File
CloseCOFF32:
        JMP     CloseCOFF32File
CloseCOFF64:
        JMP     CloseCOFF64File
CloseELF32:
        JMP     CloseELF32File
CloseELF64:
        JMP     CloseELF64File
CloseNE16:
        JMP     CloseNE16File
ClosePE32:
        JMP     ClosePE32File
ClosePE64:
        JMP     ClosePE64File
CloseMZ:
        JMP     CloseMZFile
CloseOutFile	ENDP

		
InitOutFile	PROC
        MOV     AX,[DiskOutStart]
        MOV     [OBufferPTR],AX
        XOR     AX,AX
        MOV     [UninitData],AX
        MOV     [UninitData][2],AX
        MOV     [OutFlags],AX
        CMP     BYTE [OutFormat],OutCOM
        JZ      InitOutFileNameOK
        MOV     AL,0FFh
        TEST    BYTE [RefFlags][1],30h
        JNZ InitOutFileNameOK
        CALL    MakeOutFileName
InitOutFileNameOK:
        AND     BYTE [RefFlags][1],NOT 32
        XOR     AX,AX
        MOV     DI,OFFSET ProgIP
        MOV     CX,4
        REP     STOSW
        MOV     DI,OFFSET FileSize  ;Reset filesize AND newfilesize
        STOSW
        STOSW
        CMP     BYTE [OutFormat],OutCOM
        JZ      InitOutFileOK
        MOV     CX,AX
        MOV     DX,AX
        MOV     BX,WORD [OutHandle]
        TEST    BX,BX
        JZ      InitOutFileNew
        CALL    FSeek
        JMP     InitOutFileOK
InitOutFileNew:
        MOV     DX,OFFSET OutFile
        XOR     CX,CX
        CALL    FCreate
        JNC     InitOutFileNewOK
        JMP     OpenOutFilePrintError
InitOutFileNewOK:
        MOV     [OutHandle],AX
InitOutFileOK:
        MOV     AL,BYTE [OutFormat]
        CMP     AL,OutMZ
        JZ      _OpenMZFormat
        CMP     AL,OutCOM
        JZ      _OpenCOMFormat
        CMP     AL,OutBIN
        JZ      _OpenBINFormat
        CMP     AL,OutNE16
        JZ      _OpenNE16Format
        CMP     AL,OutOMF16
        JZ      _OpenOMFFormat
        CMP     AL,OutOMF32
        JZ      _OpenOMFFormat
        CMP     AL,OutCOFF32
        JZ      _OpenCOFF32Format
        CMP     AL,OutCOFF64
        JZ      _OpenCOFF64Format
        CMP     AL,OutPE32
        JZ      _OpenPE32Format
        CMP     AL,OutPE64
        JZ      _OpenPE64Format
        RET

_OpenCOMFormat:
        MOV     WORD [ProgIP],100h
_OpenBINFormat:
        MOV     WORD [SegAlignment],1
        MOV     BYTE [CurSeg], SEGMENT_CODE
        RET

_OpenMZFormat:
        JMP     OpenMZFormat

_OpenNE16Format:
        JMP     OpenNE16Format

_OpenCOFF32Format:
		JMP		OpenCOFF32Format

_OpenCOFF64Format:
		JMP		OpenCOFF64Format

_OpenPE32Format:
        JMP     OpenPE32Format
		
_OpenPE64Format:
        JMP     OpenPE64Format
		
_OpenELF32Format:
        JMP     OpenELF32Format

_OpenELF64Format:
        JMP     OpenELF64Format

_OpenOMFFormat:
        JMP     OpenOMFFormat
InitOutFile	ENDP
		
		

GetSegAddr	PROC
        XOR     DX,DX
        MOV     AL,[OutFormat]
        CMP     AL,OutMZ
        JZ      _GetSegAddrMZ
        CMP     AL,OutOMF16
        JZ      _GetSegAddrOMF
        CMP     AL,OutOMF32
        JZ      _GetSegAddrOMF
        CMP     AL,OutNE16
        JZ      _GetSegAddrNE16
;        CMP     AL,OutPE32
;        JZ      _GetSegAddrPE32
;        CMP     AL,OutPE64
;        JZ      _GetSegAddrPE64
        XOR     AX,AX
        MOV     DX,AX
        CLC
        RET
_GetSegAddrMZ:
		JMP		GetSegAddrMZ

_GetSegAddrNE16:
		JMP		GetSegAddrNE16

;_GetSegAddrPE32:
;		JMP		GetSegAddrPE32

;_GetSegAddrPE64:
;		JMP		GetSegAddrPE64
		
_GetSegAddrOMF:
		JMP		GetSegAddrOMF
GetSegAddr	ENDP

CloseSegment	PROC
        CMP     BYTE [CurSeg],0FFh
        JNZ     CloseSegment2
        MOV     AL,[CurSeg][3]
        MOV     [CurSeg],AL
CloseSegment2:
        MOV     AL,[OutFormat]
        CMP     AL,OutOMF16
        JZ      _CloseOMFSeg
        CMP     AL,OutOMF32
        JZ      _CloseOMFSeg
        CMP     AL,OutNE16
        JZ      _CloseNE16Seg
        CMP     AL,OutMZ
        JZ      _CloseMZSeg
        CMP     AL,OutCOFF32
        JZ      _CloseCOFF32Seg
        CMP     AL,OutCOFF64
        JZ      _CloseCOFF64Seg
        CMP     AL,OutPE32
        JZ      _ClosePE32Seg
        CMP     AL,OutPE64
        JZ      _ClosePE64Seg
        RET

_CloseOMFSeg:
		JMP		CloseOMFSeg

_CloseNE16Seg:
		JMP	CloseNE16Seg

_CloseMZSeg:
        JMP MZCloseSeg

_CloseCOFF32Seg:
		JMP	CloseCOFF32Seg

_CloseCOFF64Seg:
		JMP	CloseCOFF64Seg
		
_ClosePE32Seg:
		JMP		ClosePE32Seg

_ClosePE64Seg:
		JMP		ClosePE64Seg

CloseSegment	ENDP

ExternDef	PROC
        MOV     BL,[OutFormat]
        CMP     BL,OutOMF16
        JZ      _ExternDefOMF
        CMP     BL,OutOMF32
        JZ      _ExternDefOMF
        CMP     BL,OutCOFF32
        JZ      _ExternCOFF32
        CMP     BL,OutCOFF64
        JZ      _ExternCOFF64
        RET

_ExternDefOMF:
		JMP		ExternDefOMF

_ExternCOFF32:
        JMP     ExternCOFF32

_ExternCOFF64:
        JMP     ExternCOFF64

ExternDef	ENDP

PublicDef	PROC
        MOV     BL,[OutFormat]
        CMP     BL,OutOMF16
        JZ      _PublicOMF
        CMP     BL,OutOMF32
        JZ      _PublicOMF
        CMP     BL,OutCOFF32
        JZ      _PublicCOFF32
        CMP     BL,OutCOFF64
        JZ      _PublicCOFF64
        CMP     BL,OutPE32
        JZ      _PublicPE32
        CMP     BL,OutPE64
        JZ      _PublicPE64
        RET

_PublicOMF:
		JMP	PublicOMF

_PublicCOFF32:
		JMP		PublicCOFF32

_PublicCOFF64:
		JMP		PublicCOFF64

_PublicPE32:
        RET

_PublicPE64:
        RET

PublicDef	ENDP
		
SegDef	PROC
        AND     BYTE [RefFlags][1],NOT 8
        MOV     AL,[OutFormat]
        CMP     AL,OutOMF16
        JZ      _SegDefOMF
        CMP     AL,OutOMF32
        JZ      _SegDefOMF
        RET

_SegDefOMF:
		JMP		SegDefOMF
SegDef	ENDP

NamesDef	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutOMF16
        JZ      _NamesDefOMF
        CMP     AL,OutOMF32
        JZ      _NamesDefOMF
        RET

_NamesDefOMF:
		JMP		NamesDefOMF
NamesDef	ENDP
		
MarkInitORG	PROC
        MOV     BL,[OutFormat]
        CMP     BL,OutCOM
        JZ      MarkInitCOM
        CMP     BL,OutBIN
        JZ      MarkInitPadd
        CMP     BL,OutOMF16
        JZ      _MarkInitOMF16
        CMP     BL,OutOMF32
        JZ      _MarkInitOMF32
MarkInitPadd:
        MOV     CX,DX
        SUB     CX,[ProgIP]
        JC      MarkInitPaddDone
        XOR BX,BX
        MOV     DI,[OBufferPtr]
        MOV     DL,0
        CALL    WriteMultiBytes
        CALL    UpdateProgIP
MarkInitPaddDone:
        CLC
        RET

_MarkInitOMF32:
		JMP		MarkInitOMF32
		
_MarkInitOMF16:
		JMP		MarkInitOMF16


MarkInitCOM:
        CMP     DX,100h
        JB      MarkInitComToBin
        SUB     DX,100h
        JNZ     MarkInitPadd
MarkInitCOMExit:
        STC
        RET
MarkInitComToBin:
        CMP     WORD [ProgIP],0
        JNZ     MarkInitCOMExit
        MOV     BYTE [OutFormat],OutBIN
        JMP     MarkInitPadd
MarkInitOrg	ENDP


EnterReloc	PROC
        MOV     BH,BL
        OR      BYTE [Settings][1],16
        MOV     AL,[Process]
        AND     AL,2
        OR      BL,AL
        MOV     SI,OFFSET OWordNum        
        TEST    BYTE [RelocFlags],1
        JNZ     EnterReloc2
EnterReloc1:
        MOV     DI,OFFSET RelocFlags+2
        OR      BYTE [DI][-2],BL
        TEST    BH,80h+20h
        JZ  EnterRelocExtra
        MOVSW   ;Reloc1 Data
        MOVSW
        LEA     DI,[SI][-4]
        XOR     AX,AX
        STOSW   ;Reset OWordNum
        STOSW
        STOSW
        STOSW
        RET
EnterRelocExtra:
        MOV AX,[SI][-2]
        STOSW
        MOV AL,[SI][-3]
        MOV AH,0
        STOSW
        RET
EnterReloc2:
        MOV     AH,[RelocFlags]
        AND     AH,2
        CMP     AL,AH
        JZ  EnterReloc1
        MOV     DI,OFFSET RelocFlags2+2
        OR      BYTE [DI][-2],BL
        TEST    BH,80h+20h
        JZ  EnterRelocExtra
        MOVSW
        MOVSW
        LEA     DI,[SI][-4]
        XOR     AX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        RET
EnterReloc	ENDP

FormatEnd	PROC
        OR      BYTE [OutFlags],2
        MOV AL,[OutFormat]
        CMP AL,OutMZ
        JZ  _EndMZ
        CMP AL,OutOMF16
        JZ  _EndOMF16
        CMP AL,OutOMF32
        JZ  _EndOMF32
        CMP AL,OutNE16
        JZ  _EndNE16
        CMP AL,OutCOFF32
        JZ  _EndCOFF32
        CMP AL,OutCOFF64
        JZ  _EndCOFF64
        CMP AL,OutPE32
        JZ  _EndPE32
        CMP AL,OutPE64
        JZ  _EndPE64
        RET

_EndCOFF32:
		JMP	EndCOFF32

_EndCOFF64:
		JMP	EndCOFF64

_EndPE32:
		JMP	EndPE32

_EndPE64:
		JMP	EndPE64

_EndMZ:
		JMP	EndMZ

_EndOMF16:
		JMP	EndOMF16

_EndOMF32:
		JMP	EndOMF32

_EndNE16:
		JMP	EndNE16

FormatEnd	ENDP

FormatSegClass	PROC
        MOV     CX,DX
        MOV AL,[OutFormat]
        CMP AL,OutOMF16
        JZ  _OmfSegClass
        CMP AL,OutOMF32
        JZ  _OmfSegClass
        CMP AL,OutNE16
        JZ  _NE16SegClass
        CMP AL,OutCOFF32
        JZ  _COFFSegClass
        CMP AL,OutCOFF64
        JZ  _COFFSegClass
        CMP AL,OutPE32
        JZ  _COFFSegClass
        CMP AL,OutPE64
        JZ  _COFFSegClass
        RET

_COFFSegClass:
		SUB	SI,2
		MOV WORD [SI],CX
        JMP COFFSectionClass

_NE16SegClass:
		JMP	NE16SegClass

_OmfSegClass:
		JMP	OmfSegClass
FormatSegClass	ENDP

FormatInitSeg	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutMZ
        JZ      _MZInitSeg
        CMP     AL,OutOMF16
        JZ      _OMFInitSeg
        CMP     AL,OutOMF32
        JZ      _OMFInitSeg
        CMP     AL,OutNE16
        JZ      _NE16InitSeg
        CMP     AL,OutCOFF32
        JZ      _COFF32InitSeg
        CMP     AL,OutCOFF64
        JZ      _COFF64InitSeg
        CMP     AL,OutPE32
        JZ      _PE32InitSeg
        CMP     AL,OutPE64
        JZ      _PE64InitSeg
        RET

_MZInitSeg:
		JMP		MZInitSeg

_COFF32InitSeg:
		JMP	COFF32InitSeg

_COFF64InitSeg:
		JMP	COFF64InitSeg

_PE32InitSeg:
        JMP PE32InitSeg

_PE64InitSeg:
        JMP PE64InitSeg

_NE16InitSeg:
		JMP	NE16InitSeg
		
_OMFInitSeg:
		JMP	OMFInitSeg

FormatInitSeg	ENDP

InitFirstSeg	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutNE16
        JZ  _InitNE16
        CMP     AL,OutCOFF32
        JZ  _InitCOFF32
        CMP     AL,OutCOFF64
        JZ  _InitCOFF64
        CMP     AL,OutPE32
        JZ  _InitPE32
        CMP     AL,OutPE64
        JZ  _InitPE64
        RET

_InitNE16:
        JMP InitNE16

_InitCOFF32:
		JMP	InitCOFF32

_InitCOFF64:
		JMP	InitCOFF64

_InitPE32:
        JMP InitPE32

_InitPE64:
        JMP InitPE64

InitFirstSeg	ENDP

ImportSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _ImportSegPE32
        CMP     AL,OutPE64
        JZ      _ImportSegPE64
        CMP     AL,OutNE16
        JZ      _ImportSegNE16
        STC
        RET

_ImportSegPE32:
		JMP	ImportSegPE32

_ImportSegPE64:
		JMP	ImportSegPE64

_ImportSegNE16:
		JMP	ImportSegNE16

ImportSegment	ENDP

ExportSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _ExportSegPE32
        CMP     AL,OutPE64
        JZ      _ExportSegPE64
        CMP     AL,OutNE16
        JZ      _ExportSegNE16
        STC
        RET

_ExportSegPE32:
		JMP	ExportSegPE32

_ExportSegPE64:
		JMP	ExportSegPE64

_ExportSegNE16:
		JMP	ExportSegNE16

ExportSegment	ENDP

CodeSegment	PROC
        MOV BYTE [SegmentType],1

        MOV     AL,[OutFormat]
		
        CMP     AL,OutCOFF32
        JZ      _CodeSegCOFF32
		
        CMP     AL,OutCOFF64
        JZ      _CodeSegCOFF64
		
        CMP     AL,OutPE32
        JZ      _CodeSegPE32
        CMP     AL,OutPE64
        JZ      _CodeSegPE64
        CMP     AL,OutNE16
        JZ      _CodeSegNE16
 CodeSegError:
;        STC
        CLC
        RET

_CodeSegCOFF32:
		JMP	CodeSegCOFF32

_CodeSegCOFF64:
		JMP	CodeSegCOFF32

_CodeSegPE32:
		JMP	CodeSegPE32

_CodeSegPE64:
		JMP	CodeSegPE64

_CodeSegNE16:
		JMP	CodeSegNE16

CodeSegment	ENDP

DataSegment	PROC
        MOV BYTE [SegmentType],1
        MOV     AL,[OutFormat]
        CMP     AL,OutCOFF32
        JZ      _DataSegCOFF32
        CMP     AL,OutCOFF64
        JZ      _DataSegCOFF64
        CMP     AL,OutPE32
        JZ      _DataSegPE32
        CMP     AL,OutPE64
        JZ      _DataSegPE64
        CMP     AL,OutNE16
        JZ      _DataSegNE16
 DataSegError:
;        STC
        RET

_DataSegCOFF32:
		JMP		DataSegCOFF32

_DataSegCOFF64:
		JMP		DataSegCOFF32

_DataSegPE32:
		JMP		DataSegPE32

_DataSegPE64:
		JMP		DataSegPE64

_DataSegNE16:
		JMP		DataSegNE16

DataSegment	ENDP

AutoSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutNE16
        JZ      _AutoSegNE16
        STC
        RET

_AutoSegNE16:
		JMP		AutoSegNE16

AutoSegment	ENDP

IOPLSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutNE16
        JZ      _IOPLSegNE16
        STC
        RET

_IOPLSegNE16:
		JMP	IOPLSegNE16
		
IOPLSegment	ENDP

MovableSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutNE16
        JZ      _MovableSegNE16
        STC
        RET

_MovableSegNE16:
		JMP		MovableSegNE16
		
MovableSegment	ENDP

PreloadSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutNE16
        JZ      _PreloadSegNE16
        STC
        RET

_PreloadSegNE16:
		JMP		PreloadSegNE16

PreloadSegment	ENDP

ReadableSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _ReadableSegPE32
        CMP     AL,OutPE64
        JZ      _ReadableSegPE64
        CMP     AL,OutNE16
        JZ      _ReadableSegNE16
        STC
        RET

_ReadableSegPE32:
		JMP		ReadableSegPE32
		
_ReadableSegPE64:
		JMP		ReadableSegPE64

_ReadableSegNE16:
		JMP		ReadableSegNE16
ReadableSegment	ENDP
	
WritableSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _WritableSegPE32
        CMP     AL,OutPE64
        JZ      _WritableSegPE64
        CMP     AL,OutNE16
        JZ      _WritableSegNE16

_WritableSegPE32:
		JMP		WritableSegPE32

_WritableSegPE64:
		JMP		WritableSegPE64

_WritableSegNE16:
		JMP		WritableSegNE16
WritableSegment	ENDP
		
ShareableSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _ShareableSegPE32
        CMP     AL,OutPE64
        JZ      _ShareableSegPE64
        CMP     AL,OutNE16
        JZ      _ShareableSegNE16
        STC
        RET

_ShareableSegPE32:
		JMP		ShareableSegPE32

_ShareableSegPE64:
		JMP		ShareableSegPE64

_ShareableSegNE16:
		JMP		ShareableSegNE16

ShareableSegment	ENDP

ExecutableSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _ExecutableSegPE32
        CMP     AL,OutPE64
        JZ      _ExecutableSegPE64
        CMP     AL,OutNE16
        JZ      _ExecutableSegNE16
		STC
        RET

_ExecutableSegPE32:
		JMP		ExecutableSegPE32

_ExecutableSegPE64:
		JMP		ExecutableSegPE64

_ExecutableSegNE16:
		JMP		ExecutableSegNE16

ExecutableSegment	ENDP

ConformingSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutNE16
        JZ      _ConformingSegNE16
        STC
        RET

_ConformingSegNE16:
		JMP	ConformingSegNE16
		
ConformingSegment	ENDP

DiscardableSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _DiscardableSegPE32
        CMP     AL,OutPE64
        JZ      _DiscardableSegPE64
        CMP     AL,OutNE16
        JZ      _DiscardableSegNE16
        STC
        RET

_DiscardableSegPE32:
		JMP		DiscardableSegPE32

_DiscardableSegPE64:
		JMP		DiscardableSegPE64
		
_DiscardableSegNE16:
		JMP		DiscardableSegNE16

DiscardableSegment	ENDP
		
NotPagedSegment	PROC
        MOV     AL,[OutFormat]
        CMP     AL,OutPE32
        JZ      _NotPagedSegPE32
        CMP     AL,OutPE64
        JZ      _NotPagedSegPE64
        CMP     AL,OutNE16
        JZ      _NotPagedSegNE16
        STC
        RET

_NotPagedSegPE32:
		JMP		NotPagedSegPE32

_NotPagedSegPE64:
		JMP		NotPagedSegPE64

_NotPagedSegNE16:
		JMP	NotPagedSegNE16

NotPagedSegment	ENDP		

ResourceSegment	PROC
        MOV     AL,[OutFormat]
        CMP AL,OutNE16
        JZ  _ResSegNE16
        CMP AL,OutPE32
        JZ  _ResSegPE32
        CMP AL,OutPE64
        JZ  _ResSegPE64
        STC
        RET

_ResSegNE16:
		JMP	ResSegNE16

_ResSegPE32:
		JMP	ResSegPE32

_ResSegPE64:
		JMP	ResSegPE64

ResourceSegment	ENDP
