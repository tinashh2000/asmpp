PSPSeg              DW      ?   ;PSP SEGMENT
UninitStartZero:
EVEN 2
Zeros               DQ      ?
SaveNum             DT      ?   ;saves temporary results IN expressions
EADisp              DQ      ?
EADispSize          DB      ?
EARegType           DB      ?
ModRM               DB      ?
Scale               DB      ?
BaseReg             DB      ?
IdxReg              DB      ?
SIBDisp             DW      ?
REXDisp             DW      ?
SIB                 DB      ?
RexOverride         DB      ?   ;Register EXtension override
Process             DB      ?
CurOp               DB      ?
ScalePos            DB      ?
EVEN 2
InstrPresent        DB      ?
EOLFlag             DB      ?   ;is set when it has NOT been processed
CommaFlag           DB      ?   ;is set when it has NOT been processed
SymFlags            DB      ?   ;Symbol flags
SymType             DB      ?   ;Symbol TYPE
SymLen              DB      ?   ;Symbol length
SymPos              DW      ?   ;Symbol data position in residence SEGMENT
SymSeg              DW      ?   ;Symbol resident SEGMENT
SymPosSeg           DW      ?
FreeSymSeg          DW      ?   ;A symbol SEGMENT thats NOT yet full
SymNextSpace        DW      ?   ;next free area IN symbol table
StrLen              DW      ?
InBufferSize        DW      ?
OBufferPtr          DW      ?
DiskOutSeg          DW      ?,?
DiskOutStart        DW      ?

StrStart			DW		?
StrType             DW      ?
StrCrc              DD      ?
StrPTR              DW      ?

NextMacPos          DW      ?
FreeMacSeg          DW      ?

NextTxtPos          DW      ?
FreeTxtSeg          DW      ?

TxtSegSize          DW      ?
TxtSegs             DW      ?
TextSegment         DW      10  DUP (?)

MacSegs             DW      ?
MacSegment          DW      10  DUP (?)

LocalSymSeg         DW      ?
LocalSymPtr         DW      ?
LocalDataStart      DW      ?
LocalSymLimit       DW      ?

SymbolSeg           DW      10  DUP (?)
NumSymbol           DW      10  DUP (?)
LinesCount          DW      2   DUP (?)
NumSymbols          DW      2   DUP (?)
NumErrors           DW      2   DUP (?)
NumWarnings         DW      2   DUP (?)
NumExtended         DW      ?

AsmFlags            DW      ?
AsmFlags2           DW      ?
OutFlags            DW      ?
OutFlags2           DW      ?

RemainBytes         DW      ?	;Hints the assembler as to how many bytes are yet to be written for this instruction

NumReferences       DD      ?
RefLineNumber       DD      ?
RefTableSeg         DW      ?
RefTablePtr         DW      ?
Settings            DW      ?

NumSegs             DW      ?

RelocFlags          DW      ?
RelocData           DW      ?,?                    
RelocFlags2         DW      ?
RelocData2          DW      ?,?
                    DD      ?



FileLevel           DW      ?
OutFileLen          DW      ?
Op1Type             DW      ?
Op1Data             DW      ?
Op2Type             DW      ?
Op2Data             DW      ?
Op3Type             DW      ?
Op3Data             DW      ?
AsmStack            DW      ?

ProcBlockIDLen              DW      ?
ProcBlockIDCrc              DD      ?
;ProcBlockIDCrc2             DD      ?
ProcBlockSymPos             DW      ?
ProcBlockSymSeg             DW      ?

StructBlockIDLen            DW      ?
StructBlockIDCrc            DD      ?
StructBlockIDCrc2           DD      ?
;StructBlockSymPos          DW      ?
;StructBlockSymSeg          DW      ?

MacroBlockIDLen             DW      ?
MacroBlockIDCrc             DD      ?
MacroBlockIDCrc2            DD      ?


SegBlockIDLen          DW      ?
SegBlockIDCrc          DD      ?
SegBlockIDCrc2         DD      ?
SegBlockSymPos         DW      ?
SegBlockSymSeg         DW      ?

BlockBak1           DD      ?
BlockBak2           DD      ?

ProcArgSize         DW      ?
ProcDispSize        DW      ?
Temp1               DW      ?
Temp2               DW      ?
Temp3               DW      ?
Temp4               DW      ?
Temp5               DW      ?
Temp6               DW      ?
Temp7               DW      ?
Temp8               DW      ?
Temp9               DW      ?
Temp10              DW      ?

ParamsDest DD 0
ParamsData			DW		(7*6 + 8) DUP(?)
;FmtBufferPtr1       DW      ?
;FmtBufferPtr2       DW      ?
;FmtBufferPtr3       DW      ?

;SegSize             DD      ?

UninitData          DD      ?
InitLineNumber      DD      ?
InitFilePos         DD      ?      
BytesReadBak        DD      ?
BytesRead           DD      ?
BytesWritten        DD      ?
FileSize            DD      ?
NewFileSize         DD      ?
LastProgSize        DD      ?
RepeatCount         DW      ?   ;Counter
RepeatLimit         DW      ?   ;Last value
RepeatNest          DD      ?
MacroCount          DD      ?
MacroStart          DD      ?
IfBlockCnt          DD      ?   ;Number of nestings of the IF blocks
InitIfBlockCnt      DD      ?   ;Initial IF block

AnotherFile         DB      64      DUP (?)
AnotherHandle       DW      ?

NewFile             DB      64      DUP (?)
NewHandle           DW      ?

OutFile             DB      64      DUP (?) ;Output file
OutHandle           DW      ?               ;Output file handle

CurFile             DB      64      DUP (?) ;Current file
CurHandle           DW      ?               ;Current file handle

LineNumber          DW      2       DUP (?) ;File's line number
ThisFileLen         DW      ?               ;Length of file name
Files               DB      72*8    DUP (?) ;Files can be nested to 5 levels
FileLen             DW      ?               ;Original source length
Overflow            DB      ?
OperandSize         DB      ?
AddrOverride        DB      ?   ;address override 67h
SegOverride         DB      ?   ;SEGMENT overrides
SymOpSize           DB      ?
ProcessSize         DB      ?
NeedSq              DB      ?
NeedOp              DB      ?
NeedBr              DB      ?
SaveNumSize         DB      ?
InBlock             DB      ?
InSegBlock          DB      ?
ExtMask             DB      ?
NextChar            DB      ?
CPUType             DB      ?   ;Indicates the CPU on which the ASM is running
Flushed             DB      ?
Msg                 DB      ?
Error               DB      ?
OutFormat           DB      ?
ProcFlags           DW      ?
MacroType           DB      ?
DefSymType          DB      ?

externStub			DB		?
externFileName		DB		128	DUP(?)
CmdSrcFiles         DB      40      DUP (?)
NumBuffer           DB      128     DUP (?)

MiscFmt             LABEL
                    DB      5120    DUP(?)

ExprBuffer          DW      1056    DUP (?) ;Expression buffer
StrBuffer           DB      2050    DUP (?)

OWordNum            DB      36      DUP (?)    
ProgIP              DQ      ?
Debug               DB      ?

MultiValue          DD      ?
ReserveValue        DD      ?

;AsmIDDirectivesRange DW ?, ?

FmtParams           DB      128  DUP(?)

OldPath             DB      128 DUP(?)
CurPath             DB      128 DUP(?)
UninitEndZero:
DB  0
