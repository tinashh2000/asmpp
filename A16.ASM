EVEN 2
ExprStack           DW      ExprBuffer
StrFree             DW      StrBuffer+257
EAMask              DW      03
FirstMaxSymbols     DW      9362
SymMaxSymbols       DW      9362  ;Maximum number of symbols*2
SymDataStart:
        DW      9364,9 DUP (0)
        DW      0
RefFlags            DW      3
CharDescPtr         DW      CharDesc
Addr16Disp          DW      0
Addr32Disp          DW      1
Addr64Disp          DW      1
SSERegDisp          DW      0
AddrMode            DW      1    ;16-bit real mode 2=32-bit,4=64-bit
Pass                DD      1

ExpectedMemSize		DB		0

TxtMemSize          DW      2500h

SegmentType         DB      0
CurSeg              DD      0FEh
CPULabels           DW      8086,8087,186,187,286,287,386,387,486,487,586,587,686,687,0

;***************************************************
;*              PRECEDENCE TABLE                   *
;***************************************************

Precedence          DW      0,9,11,16,25,0,0
                    DW      5   DUP (0)
FirstOperators      DB      MulOp,DivOp,ModOp,Period,ShlOp,ShrOp,RolOp,RorOp,SarOp
                    DB      AddOp,SubOp
                    DB      AndOp,XorOp,OrOp,NotOp,EQOp
                    DB      NEOp,LTOp,GTOp,LEOp,GEOp
                    DB      BoolEQOp,BoolAndOp,BoolXorOp,BoolOrOp

;***************************************************
;*              USEFUL KEYWORDS                    *
;***************************************************

PrecedenceEnd:

Extra2      DB  "on",0

Extra3      DB  "out","off","cls","src",0

Extra4      DB  "case","uses","stub"
            DB  "code","data","heap","tiny","flat"
            DB  "auto","iopl"
            DB  "date","time"
            DB  "lang",0

Extra5      DB  "reset","begin","model","stack","idata","udata"
            DB  "asmpp","flags","osize",0

Extra6      DB  "insane","preced","txtmem","import","export"
            DB  "iflags","outpos","format","rflags",0

Extra7      DB  "movable","preload",0

Extra8      DB  "resource"
            DB  "readable",0

Extra9      DB  "writeable","shareable",0

Extra10     DB  "executable","conforming",0

Extra11     DB  "discardable","notpageable"
            DB  "relocatable",0

RelocName           DB  ".reloc  "

Formats3            DB      "com","exe","bin","elf","omf",0
Formats4            DB      "coff","ne16","pe32","pe64",0
Formats5            DB      "elf32","elf64","omf16","omf32",0
Formats6            DB      "coff32","coff64",0
;Extensions          DB      ".com.exe.obj.lib.bin",0,0,0,0

OutExtensions		DB	".com.bin.exe.exe.exe.exe.obj.obj.obj.obj",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


f3Table             DW      FormatError,FormatCom,FormatMZ,FormatBIN,FormatELF32,FormatOMF32,FormatError,FormatError
f4Table				DW		FormatError,FormatCOFF32,FormatNE16,FormatPE32,FormatPE64,FormatError,FormatError,FormatError
f5Table				DW		FormatError,FormatELF32,FormatELF64,FormatOMF16,FormatOMF32,FormatError,FormatError,FormatError
f6Table				DW		FormatError,FormatCOFF32,FormatCOFF64,FormatError,FormatError,FormatError,FormatError,FormatError

DefNumSize          DB      Num16,Number
JmpSize             DB      0   ;SHORT,NEAR OR FAR
DefJmpSize          DB      0   ;Default jump SIZE
JmpSettingMask      DB      03h ;Symbol Mask to hide use of symbols
CJmpSettingMask     DB      03h ;FOR conditional jumps.
TargetCPU           DB      0FFh
RadixValue          DB      10
SegAlignment        DW      16
DefNames            DB      7,"??ASMPP"
DosStub:
INCLUDEBIN  'bin\stub.exe'

EVEN    2
;***************************************************
;*     EXPRESSION EVALUATING LABELS                *
;***************************************************

Calc32Labels    DW  Calc32Mul,Calc32Div,Calc32Add,Calc32Sub,Calc32Mod
                DW  Calc32NE,Calc32LT,Calc32GT,Calc32EQ,Calc32And,Calc32XOR
                DW  Calc32Or,Calc32Not,Calc32NE,Calc32LE,Calc32GE,Calc32Shl
                DW  Calc32Shr,Calc32Rol,Calc32Ror,Calc32Sar,Calc32BoolEQ
                DW  Calc32BoolAnd,Calc32BoolXor,Calc32BoolOr

Calc64Labels    DW  Calc64Mul,Calc64Div,Calc64Add,Calc64Sub,Calc64Mod
                DW  Calc64NE,Calc64LT,Calc64GT,Calc64EQ,Calc64And,Calc64XOR
                DW  Calc64Or,Calc64Not,Calc64NE,Calc64LE,Calc64GE,Calc64Shl
                DW  Calc64Shr,Calc64Rol,Calc64Ror,Calc64Sar,Calc64BoolEQ
                DW  Calc64BoolAnd,Calc64BoolXor,Calc64BoolOr

;***************************************************
;*            NUMBER CONVERSION TABLES             *
;***************************************************
EVEN 4
Num16Table  DW  00001
            DW  00010
            DW  00100
            DW  01000
            DW  10000

Num32Table  DD  0000000001  ;10^0
            DD  0000000010  ;10^1
            DD  0000000100  ;10^2
            DD  0000001000  ;10^3
            DD  0000010000  ;10^4
            DD  0000100000  ;10^5
            DD  0001000000  ;10^6
            DD  0010000000  ;10^7
            DD  0100000000  ;10^8
            DD  1000000000  ;10^9

Num48Table  DD  0540BE400h
            DW  00002h                                      ;10^10
            DD  04876E800h
            DW  00017h                                      ;10^11
            DD  0D4A51000h
            DW  000E8h                                      ;10^12
            DD  04E72A000h
            DW  00918h                                      ;10^13
            DD  0107A4000h
            DW  05AF3h                                      ;10^14

Num64Table  DD  0A4C68000h,000038D7Eh                       ;10^15
            DD  06FC10000h,0002386F2h                       ;10^16
            DD  05D8A0000h,001634578h                       ;10^17
            DD  0A7640000h,00DE0B6B3h                       ;10^18
            DD  089E80000h,08AC72304h                       ;10^19

Num80Table  DD  063100000h,06BC75E2Dh                       ;10^20
            DW  000000005h

            DD  0DEA00000h,035C9ADC5h                       ;10^21
            DW  000000036h

            DD  0B2400000h,019E0C9BAh                       ;10^22
            DW  00000021Eh

            DD  0F6800000h,002C7E14Ah                       ;10^23
            DW  00000152Dh

            DD  0A1000000h,01BCECCEDh                       ;10^24
            DW  00000D3C2h

Num128Table DD  04A000000h,016140148h,000084595h,000000000h ;10^25
            DD  0E4000000h,0DCC80CD2h,00052B7D2h,000000000h ;10^26
            DD  0E8000000h,09FD0803Ch,0033B2E3Ch,000000000h ;10^27
            DD  010000000h,03E250261h,0204FCE5Eh,000000000h ;10^28
            DD  0A0000000h,06D7217CAh,0431E0FAEh,000000001h ;10^29
            DD  040000000h,04674EDEAh,09F2C9CD0h,00000000Ch ;10^30
            DD  080000000h,0C0914B26h,037BE2022h,00000007Eh ;10^31
            DD  000000000h,085ACEF81h,02D6D415Bh,0000004EEh ;10^32
            DD  000000000h,038C15B0Ah,0C6448D93h,00000314Dh ;10^33
            DD  000000000h,0378D8E64h,0BEAD87C0h,00001ED09h ;10^34
            DD  000000000h,02B878FE8h,072C74D82h,000134261h ;10^35
            DD  000000000h,0B34B9F10h,07BC90715h,000C097CEh ;10^36
            DD  000000000h,000F436A0h,0D5DA46D9h,00785EE10h ;10^37
            DD  000000000h,0098A2240h,05A86C47Ah,04B3B4CA8h ;10^38

Num160Table DD  000000000h,05F655680h,08943ACC4h,0F050FE93h ;10^39
            DD  000000002h

            DD  000000000h,0B9F56100h,05CA4BFABh,06329F1C3h ;10^40
            DD  00000001Dh

            DD  000000000h,04395CA00h,09E6F7CB5h,0DFA371A1h ;10^41
            DD  000000125h

            DD  000000000h,0A3D9E400h,0305ADF14h,0BC627050h ;10^42
            DD  000000B7Ah

            DD  000000000h,06682E800h,0E38CB6CEh,05BD86321h ;10^43
            DD  0000072CBh

            DD  000000000h,0011D1000h,0E37F2410h,09673DF52h ;10^44
            DD  000047BF1h

            DD  000000000h,00B22A000h,0E2F768A0h,0E086B93Ch ;10^45
            DD  0002CD76Fh

            DD  000000000h,06F5A4000h,0DDAA1640h,0C5433C60h ;10^46
            DD  001C06A5Eh

            DD  000000000h,059868000h,0A8A4DE84h,0B4A05BC8h ;10^47
            DD  0118427B3h

            DD  000000000h,07F410000h,09670B12Bh,00E4395D6h ;10^48
            DD  0AF298D05h

Num192Table DD  000000000h,0F88A0000h,0E066EBB2h,08EA3DA61h ;10^49
            DD  0D79F8232h,000000006h

            DD  000000000h,0B5640000h,0C40534FDh,0926687D2h ;10^50
            DD  06C3B15F9h,000000044h

            DD  000000000h,015E80000h,0A83411E9h,0B8014E3Bh ;10^51
            DD  03A4EDBBFh,0000002ACh

            DD  000000000h,0DB100000h,09208B31Ah,0300D0E54h ;10^52
            DD  04714957Dh,000001ABAh

            DD  000000000h,08EA00000h,0B456FF0Ch,0E0828F4Dh ;10^53
            DD  0C6CDD6E3h,000010B46h

            DD  000000000h,092400000h,00B65F67Dh,0C5199909h ;10^54
            DD  0C40A64E6h,0000A70C3h

            DD  000000000h,0B6800000h,071FBA0E7h,0B2FFFA5Ah ;10^55
            DD  0A867F103h,0006867A5h

            DD  000000000h,021000000h,073D4490Dh,0FDFFC788h ;10^56
            DD  0940F6A24h,004140C78h

            DD  000000000h,04A000000h,0864ADA83h,0EBFDCB54h ;10^57
            DD  0C89A2571h,028C87CB5h

Num224Table DD  000000000h,0E4000000h,03EEC8920h,037E9F14Dh ;10^58
            DD  0D6057673h,097D4DF19h,000000001h

            DD  000000000h,0E8000000h,0753D5B48h,02F236D04h ;10^59
            DD  05C36A080h,0EE50B702h,00000000Fh

            DD  000000000h,010000000h,0946590D9h,0D762422Ch ;10^60
            DD  09A224501h,04F272617h,00000009Fh

            DD  000000000h,0A0000000h,0CBF7A87Ah,069D695BDh ;10^61
            DD  00556B212h,017877CECh,000000639h

            DD  000000000h,040000000h,0F7AC94CAh,02261D969h ;10^62
            DD  03562F4B8h,0EB4AE138h,000003E3Ah

            DD  000000000h,080000000h,0ACBDCFE6h,057D27E23h ;10^63
            DD  015DD8F31h,030ECCC32h,000026E4Dh

            DD  000000000h,000000000h,0BF6A1F01h,06E38ED64h ;10^64
            DD  0DAA797EDh,0E93FF9F4h,000184F03h

            DD  000000000h,000000000h,07A25360Ah,04E3945EFh ;10^65
            DD  08A8BEF46h,01C7FC390h,000F31627h

            DD  000000000h,000000000h,0C5741C64h,00E3CBB5Ah ;10^66
            DD  0697758BFh,01CFDA3A5h,0097EDD87h

            DD  000000000h,000000000h,0B6891BE8h,08E5F518Bh ;10^67
            DD  01EA97776h,021E86476h,05EF4A747h

Num256Table DD  000000000h,000000000h,0215B1710h,08FB92F75h ;10^68
            DD  0329EAAA1h,05313EC9Dh,0B58E88C7h,000000003h

            DD  000000000h,000000000h,04D8EE6A0h,09D3BDA93h ;10^69
            DD  0FA32AA4Fh,03EC73E23h,0179157C9h,000000025h

            DD  000000000h,000000000h,007950240h,0245689C1h ;10^70
            DD  0C5FAA71Ch,073C86D67h,0EBAD6DDCh,000000172h

            DD  000000000h,000000000h,04BD21680h,06B61618Ah ;10^71
            DD  0BBCA8719h,085D4460Dh,034C64A9Ch,000000E7Dh

            DD  000000000h,000000000h,0F634E100h,031CDCF66h ;10^72
            DD  055E946FEh,03A4ABC89h,00FBEEA1Dh,0000090E4h

            DD  000000000h,000000000h,09E10CA00h,0F20A1A05h ;10^73
            DD  05B1CC5EDh,046EB5D5Dh,09D752524h,00005A8E8h

            DD  000000000h,000000000h,02CA7E400h,074650438h ;10^74
            DD  08F1FBB4Bh,0C531A5A5h,02693736Ah,000389916h

            DD  000000000h,000000000h,0BE8EE800h,08BF22A31h ;10^75
            DD  0973D50F2h,0B3F07877h,081C2822Bh,00235FADDh

            DD  000000000h,000000000h,071951000h,07775A5F1h ;10^76
            DD  0E8652979h,00764B4ABh,0119915B5h,0161BCCA7h

            DD  000000000h,000000000h,06FD2A000h,0AA987B6Eh ;10^77
            DD  013F39EBEh,049EF0EB7h,0AFFAD912h,0DD15FE86h

Num288Table DD  000000000h,000000000h,05E3A4000h,0A9F4D250h ;10^78
            DD  0C7843372h,0E3569326h,0DFCC7AB6h,0A2DBF142h
            DD  000000008h

;***************************************************
;*         SUMMARY PRINTING LABELS                 *
;***************************************************

PrtAddresses    DW  msg2,NumErrors
                DW  msg3,NumWarnings
                DW  msg4,BytesWritten
                DW  msg5,Pass
                DW  msg6,NumSymbols
                DW  msg7,LinesCount
                DW  0,0

;***************************************************
;*                 KEYWORD LABELS                  *
;***************************************************

;EVEN 2
;kw_labels:
;    DW  0,0,(keyword2+1),(keyword3+1),(keyword4+1),(keyword5+1),(keyword6+1);
;	DW  (keyword7+1), (keyword8+1), (keyword9+1), (keyword10+1), (keyword11+1) 
;	DW	(keyword12+1), (keyword13+1), (keyword14+1), (keyword15+1), (keyword16+1)
;	DW  (keyword17+1), (keyword18+1)


EVEN 2
kw_labels:
    DW  0,0,(Keyword2),(Keyword3),(Keyword4),(Keyword5),(Keyword6)
	DW  (Keyword7), (Keyword8), (Keyword9), (Keyword10), (Keyword11) 
	DW	(Keyword12), (Keyword13), (Keyword14), (Keyword15), (Keyword16)
	DW  (Keyword17), (Keyword18)

;***************************************************
;*                 NUMBER SIZE TABLE               *
;***************************************************

EVEN 2
NumSizeTable    DB  Num8,Num16
                DB  Num32,Num32
                DB  Num48,Num48
                DB  Num64,Num64
                DB  Num80,Num80
                DB  Num128,Num128,Num128,Num128,Num128,Num128
                DB  16  DUP (Num256)

;***************************************************
;*            CHARACTER DESCRIPTION TABLE          *
;***************************************************

EVEN 2
CharDesc            DB      0
                    DB      9   DUP (SpaceChar)
                    DB      Char0A
                    DB      21  DUP (SpaceChar)
                    DB      SpaceChar,NePref,Quote,Hash,Alpha,ModOp,AndOp
                    DB      Quote,OpenBracket,CloseBracket,MulOp,AddOp,Comma
                    DB      SubOp,Period,DivOp
                    DB      10  DUP (Alpha)
                    DB      Colon,SemiColon,LTOp,EQOp,GTOp,Alpha
                    DB      27  DUP (Alpha)
                    DB      OpenSqBracket,Slash,CloseSqBracket,XorOp,Alpha
                    DB      Quote
                    DB      26  DUP (Alpha)
                    DB      OpenCBracket,OrOp,CloseCBracket,NotOp
                    DB      128 DUP (Alpha)

;***************************************************
;*              LCASE TABLE                        *
;***************************************************

EVEN 2
LCaseTable:
                    DB      65  DUP(0)
                    DB      "abcdefghijklmnopqrstuvwxyz"
                    DB      164 DUP(0)

;***************************************************
;*               NUMBER TABLE                      *
;***************************************************

NumberTable:
                    DB      0FFh
                    DB      47  DUP(0F0h)
                    DB      0,1,2,3,4,5,6,7,8,9 ;0-9
                    DB      07  DUP(0F0h)
                    DB      10,11,12,13,14,15   ;A-F
                    DB      26  DUP(0F0h)
                    DB      10,11,12,13,14,15   ;a-f
                    DB      154 DUP(0F0h)

;***************************************************
;*       OPERAND TRANSLATION TABLE                 *
;***************************************************

OpTranslate         DB      ByteID,WordID,DWordID
                    DB      QWordID,ByteID,ByteID
                    DB      WordID,DWordID,QWordID
                    DB      WordID,WordID
OpSizeTable         DB      2,2,4,6,8,10,16

;_CustomFile DB "MYFILE.DAT",0

NumTimes        DD  0
                DD  0


;AsmIDDirectives DW (DBDirective)
;                DW (DDDirective)
;                DW (DFDirective)
;                DW (DODirective)
;                DW (DODirective)
;                DW (DQDirective)
;                DW (DTDirective)
;                DW (DUDirective)
;                DW (DUPDirective)
;                DW (DWDirective)
;
;	DW (EQUDirective)
;	DW (GroupDirective)
;	DW (LabelDirective)
;	DW (MacroDirective)
;	DW (ProcDirective)
;	DW (StrucDirective)
;
;AsmIDEndDirectives	DW (EndMDirective)
;					DW (EndPDirective)
;					DW (EndSDirective)
;
;
;omfOGL          DD  0
;BBBBAK          dw 0
