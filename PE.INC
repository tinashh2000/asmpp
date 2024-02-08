IMAGE_REL_I386_DIR32	=	0006h
IMG_RELOCS_STRIPPED     =   0001h
IMG_EXECUTABLE          =   0002h
IMG_LINE_NUMS_STRIPPED  =   0004h
IMG_LOCAL_SYMS_STRIPPED =   0008h
IMG_AGGRESSIVE_WS_TRIM  =   0010h
IMG_BYTES_REVERSED_LO   =   0080h
IMG_32BIT_MACHINE       =   0100h
IMG_DEBUG_STRIPPED      =   0200h
IMG_NO_REMOVABLE        =   0400h
IMG_NO_NETWORK          =   0800h
IMG_SYSTEM              =   1000h
IMG_DLL                 =   2000h
IMG_UP_SYSTEM           =   4000h
IMG_BYTES_RESERVED_HIGH =   8000h

RELOC_HIGH_WORD         =   1
RELOC_LOW_WORD          =   2
RELOC_DWORD             =   3
RELOC_TWO_WORDS         =   4
RELOC_MIPS_JUMP         =   5
RELOC_MIPS_JUMP16       =   9
RELOC_QWORD             =   10
RELOC_FWORD             =   11

PESection   STRUC
;asdf
    p2esVirtualSize     DD  ?
    pesName             DB  8   DUP(?)
    pesVirtualSize      DD  ?
    pesRVA              DD  ?
    pesRawSize          DD  ?
    pesRawPTR           DD  ?
    pesRelocPTR         DD  ?
    pesLinesNumbersPTR	DD  ?
    pesNumReloc         DW  ?
    pesNumLineNumbers   DW  ?
    pesCharacter        DD  ?
PESection   ENDS

PE32Format    STRUC
    ORG MiscFmt
    pe32Signature     DD	?
    pe32Machine       DW  ?
    pe32NumSections   DW	?
    pe32TimeDateStamp DD	?
    pe32PTRSymbols    DD	?
    pe32NumSymbols    DD	?
    pe32SizeOptional  DW	?
    pe32Character     DW	?

    pe32Magic         DW  ?
    pe32Version       DW  ?
    pe32CodeSize      DD  ?
    pe32IDataSize     DD	?
    pe32UDataSize     DD	?
    pe32EPoint	    DD	?
    pe32CodeBase	    DD	?
    pe32DataBase	    DD	?   
    pe32ImageBase     DD	?
    pe32SectionAlign  DD	?
    pe32FileAlign     DD	?
    pe32OSVersion     DD	?
    pe32ImageVersion  DD	?
    pe32SubSysVersion DD	?
    pe32Win32Val	    DD	?
    pe32ImageSize     DD	?
    pe32HeadersSize   DD	?
    pe32CheckSum	    DD	?
    pe32SubSystem		DW	?
    pe32DLLCharacter	DW	?
    pe32StackReserve	DD	?
    pe32StackCommit		DD	?
    pe32HeapReserve		DD	?
    pe32HeapCommit		DD	?
    pe32LoaderFlags		DD	?
    pe32NumRVAs			DD	?
    pe32ExportRVA		DD	?
    pe32ExportSize		DD	?
    pe32ImportRVA		DD	?
    pe32ImportSize		DD	?
    pe32ResourceRVA		DD  ?
    pe32ResourceSize	DD  ?
    pe32ExceptionRVA	DD  ?
    pe32ExceptionSize	DD  ?
    pe32SecurityRVA		DD  ?
    pe32SecuritySize	DD  ?
    pe32BaseRelocRVA	DD  ?
    pe32BaseRelocSize	DD  ?
    pe32DebugRVA		DD  ?
    pe32DebugSize 		DD  ?
    pe32CopyrightRVA	DD  ?
    pe32CopyrightSize	DD  ?
    pe32GlobalPtrRVA	DD  ?
    pe32GlobalPtrSize	DD  ?
    pe32TSLRVA			DD  ?
    pe32TSLSize			DD  ?
    pe32ConfigRVA 		DD  ?
    pe32ConfigSize		DD  ?
    pe32BoundImportRVA	DD  ?
    pe32BoundImportSize	DD  ?
    pe32IATRVA			DD  ?
    pe32IATSize			DD  ?
    pe32DIDRVA			DD  ?
    pe32DIDSize			DD  ?
    pe32COMHeaderRVA	DD  ?
    pe32COMHeaderSize	DD  ?
						DD  ?
						DD  ?

    pe32Sections		DB  4000    DUP(?)
    pe32RelocRVA		DD  ?
    pe32RelocStart		DW  ?
    pe32Seg				DW  ?
    pe32SegAttr			DD  ?
    pe32StubSize		DD  ?
    pe32RelocPTR		DW  ?
    pe32RelocSeg		DW  ?
    pe32Flags			DW  ?
PE32Format    ENDS

PE64Format    STRUC
    ORG MiscFmt
    pe64Signature     DD  ?
    pe64Machine       DW  ?
    pe64NumSections   DW  ?
    pe64TimeDateStamp DD  ?
    pe64PTRSymbols    DD  ?
    pe64NumSymbols    DD  ?
    pe64SizeOptional  DW  ?
    pe64Character     DW  ?

    pe64Magic	      DW  ?
    pe64Version       DW  ?
    pe64CodeSize      DD  ?
    pe64IDataSize     DD  ?
    pe64UDataSize     DD  ?
    pe64EPoint	      DD  ?
    pe64CodeBase      DD  ?
    pe64ImageBase     DQ  ?
    pe64SectionAlign  DD  ?
    pe64FileAlign     DD  ?
    pe64OSVersion     DD  ?
    pe64ImageVersion  DD  ?
    pe64SubSysVersion DD  ?	
    pe64Win32Val      DD  ?
    pe64ImageSize     DD  ?
    pe64HeadersSize   DD  ?	
    pe64CheckSum      DD  ?
    pe64SubSystem     DW  ?
    pe64DLLCharacter  DW  ?
    pe64StackReserve  DQ  ?
    pe64StackCommit   DQ  ?
    pe64HeapReserve   DQ  ?
    pe64HeapCommit    DQ  ?
    pe64LoaderFlags   DD  ?
    pe64NumRVAs       DD  ?
    pe64ExportRVA     DD  ?
    pe64ExportSize    DD  ?
    pe64ImportRVA     DD  ?
    pe64ImportSize    DD  ?
    pe64ResourceRVA	  DD  ?
    pe64ResourceSize	  DD  ?
    pe64ExceptionRVA	  DD  ?
    pe64ExceptionSize	  DD  ?
    pe64SecurityRVA		DD  ?
    pe64SecuritySize	  DD  ?
    pe64BaseRelocRVA	  DD  ?
    pe64BaseRelocSize	  DD  ?
    pe64DebugRVA	  DD  ?
    pe64DebugSize	  DD  ?
    pe64CopyrightRVA	  DD  ?
    pe64CopyrightSize	  DD  ?
    pe64GlobalPtrRVA	  DD  ?
    pe64GlobalPtrSize	  DD  ?
    pe64TSLRVA		  DD  ?
    pe64TSLSize 	  DD  ?
    pe64ConfigRVA	  DD  ?
    pe64ConfigSize	  DD  ?
    pe64BoundImportRVA	  DD  ?
    pe64BoundImportSize   DD  ?
    pe64IATRVA		  DD  ?
    pe64IATSize 	  DD  ?
    pe64DIDRVA		  DD  ?
    pe64DIDSize 	  DD  ?
    pe64COMHeaderRVA	  DD  ?
    pe64COMHeaderSize	  DD  ?
						DD  ?
						DD  ?
    pe64Sections	  DB  4000    DUP(?)
    pe64RelocRVA	  DD  ?
    pe64RelocStart	  DW  ?
    pe64Seg		  DW  ?
    pe64SegAttr 	  DD  ?
    pe64StubSize	  DW  ?
    pe64RelocPTR	  DW  ?
    pe64RelocSeg	  DW  ?
    pe64Flags		  DW  ?
PE64Format    ENDS

cf32Format    STRUC
    ORG MiscFmt
    cf32Machine         DW ?
    cf32NumSections     DW ?
    cf32TimeDateStamp   DD ?
    cf32PTRSymbols      DD ?
    cf32NumSymbols      DD ?
    cf32SizeOptional    DW ?
    cf32Character       DW ?

    cf32Sections        DB 4000    DUP(?)
    cf32RelocRVA        DD ?
    cf32RelocStart      DW ?
    cf32Seg             DW ?
    cf32SegAttr         DD ?
    cf32StubSize        DW ?
    cf32RelocPTR        DW ?
    cf32RelocSeg        DW ?
    cf32RelocSize       DD ?
    cf32HeadersSize     DW ?
    cf32Flags           DW ?
	cf32SymbolTablePTR  DW ?
	cf32SymbolTableSeg	DW ?
	cf32SymbolTableStart	DD	?
	cf32SymbolTableSize		DD	?


	cf32ThisSection				DW	?
	cf32ThisSectionSymbolPos	DW	?

	cf32StringTablePTR	DW ?
	cf32StringTableSeg	DW ?
	cf32StringTableStart	DD	?
;    cf32StringTableSize     DD  ?
cf32Format    ENDS

cf64Format    STRUC
    ORG MiscFmt
    cf64Machine         DW ?
    cf64NumSections     DW ?
    cf64TimeDateStamp   DD ?
    cf64PTRSymbols      DD ?
    cf64NumSymbols      DD ?
    cf64SizeOptional    DW ?
    cf64Character       DW ?

    cf64Sections        DB 4000    DUP(?)
    cf64RelocRVA        DD ?
    cf64RelocStart      DW ?
    cf64Seg             DW ?
    cf64SegAttr         DD ?
    cf64StubSize        DW ?
    cf64RelocPTR        DW ?
    cf64RelocSeg        DW ?
    cf64RelocSize       DD ?
    cf64HeadersSize     DW ?
    cf64Flags           DW ?
	cf64SymbolTablePTR  DW ?
	cf64SymbolTableSeg	DW ?
	cf64SymbolTableStart	DD	?
	cf64SymbolTableSize		DD	?


	cf64ThisSection				DW	?
	cf64ThisSectionSymbolPos	DW	?

	cf64StringTablePTR	DW ?
	cf64StringTableSeg	DW ?
	cf64StringTableStart	DD	?
;    cf64StringTableSize     DD  ?
cf64Format    ENDS

PEImportVars    STRUC
	ORG	Temp2
	_peBufferPTR		DW	?	;	=	(Temp2)
	_peBufferSeg		DW	?	;	=	(Temp3)
	_peLibNamesLen		DW	?	;	=	(Temp4)
	_peSectionSize		DW	?	;	=	(Temp5)
	_peDescSize			DW	?	;	=	(Temp6)
	_peModuleNamesLen	DW	?	;	=	(Temp7)
	_peDirSize			DW	?	;	=	(Temp8)
	_peDirTable			DW	?	;	=	(Temp9)
	_peLibTable			DW	?	;	=	(Temp10)
PEImportVars    ENDS

PEFlags:

PE_FIRST_CODE_SEG	=	2
PE_FIRST_DATA_SEG	=	4
PE_IMPORT_SEG		=	16
PE_EXPORT_SEG		=	32
PE_DATA_SEG			=	64
PE_CODE_SEG			=	128

COFFRelocation	STRUC
	cfReloRVA		DD	?
	cfReloSymTblIdx	DD	?
	cfReloTyp		DW	?
COFFRelocation	ENDS

IMAGE_SYM_CLASS_END_OF_FUNCTION     = -1,
IMAGE_SYM_CLASS_NULL                = 0x0000
IMAGE_SYM_CLASS_AUTOMATIC           = 0x0001
IMAGE_SYM_CLASS_EXTERNAL            = 0x0002
IMAGE_SYM_CLASS_STATIC              = 0x0003,
IMAGE_SYM_CLASS_REGISTER            = 0x0004,
IMAGE_SYM_CLASS_EXTERNAL_DEF        = 0x0005,
IMAGE_SYM_CLASS_LABEL               = 0x0006,
IMAGE_SYM_CLASS_UNDEFINED_LABEL     = 0x0007,
IMAGE_SYM_CLASS_MEMBER_OF_STRUCT    = 0x0008,
IMAGE_SYM_CLASS_ARGUMENT            = 0x0009,
IMAGE_SYM_CLASS_STRUCT_TAG          = 0x000A,
IMAGE_SYM_CLASS_MEMBER_OF_UNION     = 0x000B,
IMAGE_SYM_CLASS_UNION_TAG           = 0x000C,
IMAGE_SYM_CLASS_TYPE_DEFINITION     = 0x000D,
IMAGE_SYM_CLASS_UNDEFINED_STATIC    = 0x000E,
IMAGE_SYM_CLASS_ENUM_TAG            = 0x000F,
IMAGE_SYM_CLASS_MEMBER_OF_ENUM      = 0x0010,
IMAGE_SYM_CLASS_REGISTER_PARAM      = 0x0011,
IMAGE_SYM_CLASS_BIT_FIELD           = 0x0012,

IMAGE_SYM_CLASS_FAR_EXTERNAL        = 0x0044

IMAGE_SYM_CLASS_BLOCK               = 0x0064,
IMAGE_SYM_CLASS_FUNCTION            = 0x0065,
IMAGE_SYM_CLASS_END_OF_STRUCT       = 0x0066,
IMAGE_SYM_CLASS_FILE                = 0x0067,

IMAGE_SYM_CLASS_SECTION             = 0x0068,
IMAGE_SYM_CLASS_WEAK_EXTERNAL       = 0x0069

IMAGE_REL_I386_ABSOLUTE 	=	0
IMAGE_REL_I386_DIR16     	=	1
IMAGE_REL_I386_REL16     	=	2
IMAGE_REL_I386_DIR32     	=	6
IMAGE_REL_I386_DIR32NB   	=	7
IMAGE_REL_I386_SEG12     	=	9
IMAGE_REL_I386_SECTION   	=	10
IMAGE_REL_I386_SECREL    	=	11
IMAGE_REL_I386_REL32     	=	20

IMAGE_REL_AMD64_ABSOLUTE    =    0x0000
IMAGE_REL_AMD64_ADDR64      =    0x0001
IMAGE_REL_AMD64_ADDR32      =    0x0002
IMAGE_REL_AMD64_ADDR32NB    =    0x0003
IMAGE_REL_AMD64_REL32       =    0x0004
IMAGE_REL_AMD64_REL32_1     =    0x0005
IMAGE_REL_AMD64_REL32_2     =    0x0006
IMAGE_REL_AMD64_REL32_3     =    0x0007
IMAGE_REL_AMD64_REL32_4     =    0x0008
IMAGE_REL_AMD64_REL32_5     =    0x0009
IMAGE_REL_AMD64_SECTION     =    0x000A
IMAGE_REL_AMD64_SECREL      =    0x000B
IMAGE_REL_AMD64_SECREL7     =    0x000C

;Bit 0
;   1   -   First code segment
;   2   -   First data segment
;	3
;	4	-	Import Seg
;	5	-	Export Seg
;	6	-	Data Seg
;	7	-	Code Seg
;	8	-	Reloc info has been placed??
;	9	-	Reloc??
;	10
;	11
;	12
;	13
;	14
;	15
	
