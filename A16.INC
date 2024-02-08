SymbolEntry STRUC
    seIDLen         DB  ?   ;IDLength
    seIDType        DB  ?   ;IDType
    seIDCrcH        DW  ?   ;IDCrc HIGH
    seIDFlags       DB  ?   ;IDFlags
    seIDcbExtra     DB  ?   ;ID Extra BYTE
    seIDcwExtra     DW  ?   ;ID Extra WORD
    seIDData        DD  ?   ;ID Data OR address
 SymDefSize  =   $
SymbolEntry ENDS


AVX_PARAMS 	STRUC
	avxOperandSize	DB	?
	avxMaskRegister	DB	?
	avxRoundingCtl	DB	?
	avxErrorHandling DB ?

	avxBroadcastSize DB ?
	avxNumParams 	DB ?
	avxCommas		DB ?    ;1 for each place where there is a comma
                    DB ?


	avxPType_1		DW	?
	avxPValue_1 	DW	?, ?
	
	avxPType_2		DW	?
	avxPValue_2 	DW	?, ?
	
	avxPType_3		DW	?
	avxPValue_3 	DW	?, ?
	
	avxPType_4		DW	?
	avxPValue_4 	DW	?, ?

	avxPType_5		DW	?
	avxPValue_5 	DW	?, ?	

	avxPType_6		DW	?
	avxPValue_6 	DW	?, ?

	avxPType_7		DW	?
	avxPValue_7 	DW	?, ?
AVX_PARAMS	ENDS


SEGMENT_CODE    = 1
SEGMENT_DATA    = 2
SEGMENT_STACK   = 3
SEGMENT_NONE    = 0FEh
SEGMENT_CLOSED  = 0FFh

RELOC_PRESENT       =       0x01
RELOC_ADDR          =       0x02
RELOC_32BIT         =       0x08
RELOC_POINTER       =       0x10
RELOC_EXTERN        =       0x20
RELOC_RELATIVE      =       0x40
RELOC_SEGMENT       =       0x80
RELOC_8BIT          =       0x100

FMT_PUBLIC          =       0x40    ;OMF,PE,COFF
FMT_EXTERN          =       0x20    ;OMF,PE,COFF

SYM_EXT             =       0x80    ;Extended Flag
SYM_STRUCT          =       0x10    ;Symbol of a struct
SYM_UNDEF           =       0x08    ;Undefined
SYM_NEEDSRELOC		=		0x04	;Needs Reloc
SYM_PASS            =       0x01    ;Pass AND 1

Alpha               =       001
Number              =       002
HexNum              =       003
FloatNum            =       004
SpaceChar           =       005
EndOfLine           =       006
Comma               =       007
OpenSqBracket       =       011
CloseSqBracket      =       012
OpenBracket         =       013
CloseBracket        =       014
Colon               =       015
SemiColon           =       016
Hash                =       017
Slash               =       018
OpenCBracket        =       019
CloseCBracket       =       020
LoadEIP             =       021
LoadInitEIP         =       022
Question            =       023
Period              =       030 ;Period is NOT indirectly an ADD operator
MulOp               =       031
DivOp               =       032
AddOp               =       033
SubOp               =       034
ModOp               =       035
NePref              =       036
LTOp                =       037
GTOp                =       038
EqOp                =       039
AndOp               =       040
XorOp               =       041
OrOp                =       042
NotOp               =       043
NEOp                =       044
LEOp                =       045
GEOp                =       046
ShlOp               =       047
ShrOp               =       048
RolOp               =       049
RorOp               =       050
SarOp               =       051
BoolEQOp            =       052
BoolAndOp           =       053
BoolXorOp           =       054
BoolOrOp            =       055
PtrOp            	=       056

ByteID              =       000  ;8
WordID              =       001  ;16
DWordID             =       002  ;32
FWordID             =       003  ;48
QWordID             =       004  ;64
TWordID             =       005  ;80
OWordID             =       006  ;128
LabelID             =       017
LocalID             =       018
StructID            =       019
MacroID             =       020   ;Macros,=  ,FUNCTION
SegmentID           =       021
ConstNumID          =       022
GroupID             =       023
ResourceID          =       024
CustomID            =       025

MMacroID            =       001
MEquID              =       002
MFUNCTIONID         =       003
MRepeatID           =       004

AVX_ROUNDING_CTL    =   70
AVX_SAE_ROUNDING_CTL=   71
AVX_Kx_MASKREG      =   72
AVX_Kx_REG          =   73
AVX_BOUND_REG       =   74
AVX_ERROR_HANDLING_MODE=74

AVX_K0_REG          =       0
AVX_K1_REG          =       1
AVX_K2_REG          =       2
AVX_K3_REG          =       3
AVX_K4_REG          =       4
AVX_K5_REG          =       5
AVX_K6_REG          =       6
AVX_K7_REG          =       7
AVX_ZERO_MASKREG    =       40h

;Error handling modes
AVX_ERROR_HANDLING_ER       =   1
AVX_ERROR_HANDLING_SAE      =   2


Reg8                =       081
Reg16               =       082
Reg32               =       083
Reg64               =       084
LMLowReg            =       085
LMReg8              =       086             
LMReg16             =       087
LMReg32             =       088
LMReg64             =       089
SegReg              =       090
SegReg386           =       091
CtrlReg             =       092
CtrlReg64           =       093 ;CR8-CR15
DbgReg              =       094
DbgReg64            =       095 ;DR8-DR15
TestReg             =       096
FPUReg              =       097
MMXReg              =       098
SSEReg              =       099	;XMM0 - XMM15
avxReg				=		101	;YMM0 - YMM31
avx512Reg			=		102	;ZMM0 - ZMM31

DataType            =       105
DistSpec            =       106
DataDef             =       107
DefEnd              =       108
Lang                =       109
Options             =       111
MacroKW             =       112
Operator            =       113

;NoOpInstr           =       114
;NoOp16Instr         =       115
;NoOp32Instr         =       116
;NoOp64Instr         =       117

Mem                 =       118
Quote               =       120
Keyword             =       121
CPUInstruction      =       122
UnknownID           =       123
Identifier          =       124
Num8                =       11000001b    ;lower bits indicate the SIZE IN bytes
Num16               =       11000010b
Num32               =       11000100b
Num48               =       11000110b
Num64               =       11001000b
Num80               =       11001010b
Num128              =       11010000b
Num256              =       11100000b
;Char0D              =      250
Char0A              =       251
EndOfBlock          =       252
EndOFFile           =       254
QuitError           =       255

_BYTE               =       01
_WORD               =       02
_DWORD              =       03
_FWORD              =       04
_QWORD              =       05
_TWORD              =       06
_OWORD              =       08

;_RAX                =       00
;_RCX                =       01
;_RDX                =       02
;_RBX                =       03
;_RSP                =       04
;_RBP                =       05
;_RSI                =       06
;_RDI                =       07

ShortJmp            =       01
NearJmp             =       02
FarJmp              =       03

OutCOM              =       0x00 ;Output com file <=   64K,ORG 0100h
OutBin              =       0x01 ;raw binary
OutMZ               =       0x02 ;MS-DOS executable
OutNE16             =       0x03 ;NE16 pe
OutPE32             =       0x04 ;win32 pe
OutPE64             =       0x05 ;win64 pe
OutCOFF32           =       0x06 ;Common Object 32
OutCOFF64           =       0x07 ;Common Object 64
OutOMF16            =       0x08 ;MS-DOS Object =   OutObj
OutOMF32            =       0x09 ;32-bit OBJ
OutELF32            =       0x0A ;linux elf 32
OutELF64            =       0x0B ;linux elf 64

DescOfs             =       4*6553
MaxSymbols          =       6553
BuffLimit           =       0AFFEh
DiskInPtr           =       0
DiskOutPtr          =       0

;ReadOnly        EQU 00
;WriteOnly       EQU 01
;ReadWrite       EQU 02

thisVersion				=	0218h
DefStubSize = 40h
