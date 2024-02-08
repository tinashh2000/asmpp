.FORMAT MZ
.RADIX 10
;.8086

.LANG STDCALL
;.OPTION  INSANE 0x41

INCLUDE     'PE.INC'
INCLUDE     'MZ.INC'
INCLUDE     'NE.INC'
INCLUDE     'A16.INC'   ;constants
INCLUDE     'OMF.INC'
INCLUDE     'COFF.INC'

BootSeg SEGMENT Code
    MOV AX,Code
    PUSH    AX
    PUSH    WORD (Main)
    RETF
BootSeg ENDS

AsmData SEGMENT

;ECHO "Start", $
    INCLUDE	'cpu16n.asm'   ;cpu instruction lists

;ECHO "CPU16",$
    INCLUDE	'crc16.asm'   ;crc encoding routines

;ECHO "CRC16", $
    INCLUDE 'ENG16.asm' ;message strings IN Shona language

;ECHO "ENG16", $
    INCLUDE	'a16.asm'     ;data definitions

;ECHO "A16",$
    INCLUDE	'instr16n.asm' ;cpu instructions directory

;ECHO "INSTR16", $
InBufferPtr	    DW	    0
DiskInSeg	    DW	    0
LineStartPtr	    DW	    0
    INCLUDE	'uninit16.asm'
;ECHO $

ECHO "Data Length",$
AsmData ENDS

;DEB = 1
;ADEB = 1
;IPRT    =   1
CODE SEGMENT 'CODE' CODE USE16
    ORG     0
Main:
    JMP     Start

ECHO ""
ECHO "***************************************************"
ECHO "*                     START                       *"
ECHO "***************************************************"
ECHO ""
ECHO ""

mMark = $  
INCLUDE     'asm16.asm'   ;assembler routines

IFDEF IPRT
    ECHO "ASM16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'bas16.asm'   ;general routines

IFDEF IPRT
    ECHO "BAS16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'calc16.asm'  ;calculation routines

IFDEF IPRT
    ECHO "CALC16.ASM",$-mMark
ENDIF

mMark = $

DirectivesStart:
INCLUDE     'direcw16.asm' ;assembly directives handler
INCLUDE     'direcn16.asm' ;assembly directives handler
DirectivesEnd:

IFDEF IPRT
    ECHO "DIRECN16.ASM", $-mMark
ENDIF

mMark = $
INCLUDE     'dos16.asm'   ;dos functions
IFDEF IPRT
    ECHO "DOS16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'err16.asm'   ;error printing routines

IFDEF IPRT
    ECHO "ERR16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'expr16.asm'  ;expressions AND ea processing

IFDEF IPRT
    ECHO "EXPR16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'file16.asm'  ;file access routines

IFDEF IPRT
    ECHO "FILE16.ASM",$-mMark
ENDIF

mMark = $
INCLUDE     'func16.asm'  ;different functions
INCLUDE     'GETTWO.asm'  ;GetTwoOperands
INCLUDE     'GETOP.asm'  ;GetOperand
INCLUDE     'PASS.asm'  ;different functions

IFDEF IPRT
    ECHO "FUNC16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'line16.asm'  ;line processing routine

IFDEF IPRT
    ECHO "LINE16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'macros.asm'  ;macros handling

IFDEF IPRT
    ECHO "MACROS.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'num16.asm'   ;numbers AND calculations

IFDEF IPRT
    ECHO "NUM16.ASM",$-mMark
ENDIF

mMark = $

INCLUDE     'out16.asm'   ;output files formatting

IFDEF IPRT
    ECHO "OUT16.ASM",$-mMark
ENDIF

mMark = $
INCLUDE     'str16.asm'   ;string manipulation routines

IFDEF IPRT
    ECHO "STR16.ASM",$-mMark
ENDIF

mMark = $
INCLUDE     'sym16.asm'   ;Symbol searching AND writing

IFDEF IPRT
    ECHO "STR16.ASM",$-mMark
ENDIF

mMark = $
INCLUDE     'prt.asm'		;print routines

IFDEF IPRT
    ECHO "PRT.ASM",$-mMark
ENDIF

Start:

    MOV     AX,AsmData
    MOV     ES,AX
    MOV     WORD ES:[PSPSeg],DS
    MOV     DS,AX

    MOV AX,[OBufferPTR]
    MOV DX,(MiscFmt)
    MOV AX,[FileSize]

    MOV     SI,OFFSET CorpInfo
    CALL    PrintStr
    CALL    InitVars ; LCaseTable
    CALL    ProcessCmd
    TEST    DX,DX
    JZ	    AsmUsage
    MOV     CX,[Temp1][2]

    MOV     DI,OFFSET CurFile
    MOV     SI,WORD [Temp1]

    CALL    GetCurPath

    MOV DI,(StrBuffer)	    ;Copy filename to STRBuffer
    REP     MOVSB
    MOV AL,0
    STOSB

    MOV DI,(StrBuffer-128)   ;Destination of new file
    MOV SI,(StrBuffer)

    PUSH    SI		    ;Source of filename
    PUSH    DI		    ;Destination
    CALL    GenerateFileName

    MOV CX,AX
    MOV     WORD [FileLen],AX
    MOV     WORD [ThisFileLen],AX

    MOV SI,DI
    MOV DI,(CurFile)
    PUSH    CX,SI
    REP MOVSB
    POP     SI,CX	     ;Restore SI to point to filename

    MOV     DI,OFFSET Files
    REP     MOVSB
    MOV     SI,OFFSET Temp1+4
    DEC     DX
    TEST    DX,DX
    JZ	    AsmOutFileOK
    MOV     DI,OFFSET CmdSrcFiles
AsmGetFiles:
    CMP     DX,1
    JZ	    AsmGetOutFile
AsmGetFiles2:	 
    MOVSW
    MOVSW
    DEC     DX
    JMP     AsmGetFiles
AsmUsage:
    MOV     SI,OFFSET Usage
    CALL    PrintStr
    JMP     ExitProg
AsmGetOutFile:	  
    OR	    BYTE [RefFlags][1],16
    MOV     AX,[SI][2]
    MOV     SI,WORD [SI]
    MOV     WORD [OutFileLen],AX
    MOV     CX,AX
    MOV     DI,OFFSET OutFile
    REP     MOVSB
    MOV     BYTE [DI],0
AsmOutFileOK:
    MOV     BYTE [Temp1],0
AsmInitInFile:
    MOV     AL,0
    MOV     DX,OFFSET CurFile
    CALL    FOpen
    JC	    AsmChangeFileExtension
    MOV     WORD [CurHandle],AX
    MOV     SI,OFFSET Msg0
    CALL    PrintStr
    MOV     SI,OFFSET CurFile
    CALL    PrintStr
    CALL    PrintLF
    JMP     AllocateMemory
Asm8Ext:
    MOV     AX,[FileLen]
    INC     AX
    MOV     [FileLen],AX
    MOV     DI,WORD [Temp1][2]
    MOV     AX,"8."
    STOSW
    JMP     AsmInitInFile
AsmASExt:
    MOV     AX,[FileLen]
    ADD     AX,2
    MOV     [FileLen],AX
    MOV     DI,WORD [Temp1][2]
    MOV     AX,"a."
    STOSW
    MOV     AX,"s"
    STOSW
    JMP     AsmInitInFile
AsmChangeFileExtension:
    CMP     BYTE [Temp1],5
    JA	    PrintFileErr
    MOV     BL,BYTE [Temp1]
    INC     BYTE [Temp1]
    CMP     BL,1 
    JB	    AsmTestExtension
    JZ	    AsmAsmExt
    CMP     BL,3
    JB	    Asm8Ext
    JZ	    AsmASExt
AsmIncExt:
    MOV     DI,WORD [Temp1][2]
    MOV     AX,"i."
    STOSW
    MOV     AX,"cn"
    STOSW
    JMP     AsmInitInFile

AsmAPPExt:
    MOV     WORD [Temp1][2],DI
    MOV     AX,"a."
    STOSW
    MOV     AX,"pp"
    STOSW
    MOV BYTE [DI],0
    JMP     AsmInitInFile
AsmAsmExt:    
    MOV     DI,WORD [Temp1][2]
    MOV     AX,"a."
    STOSW
    MOV     AX,"ms"
    STOSW
    JMP     AsmInitInFile
AsmTestExtension:
    PUSH    AX
    MOV     DI,(CurFile)
    MOV     CX,WORD [ThisFileLen]
    ADD     WORD [ThisFileLen],4
    MOV     AL,"."
    REPNZ   SCASB
    POP     AX
    JNZ     AsmAPPExt
PrintFileErr:
    MOV     DI,WORD [Temp1+2]
    MOV     WORD [DI],"a."
    MOV     WORD [DI][2],"pp"
    CALL    PrintFileError
    JMP     ExitProg
AsmMAllocError:
    MOV     SI,OFFSET _MAllocError
    JMP     AsmMemError
AsmNotEnoughMem:
    MOV     SI,OFFSET _NotEnoughMem
AsmMemError:
    MOV     BYTE [Error],QuitError
    CALL    PrintError
    JMP     AsmEnd    
GetFreeMemOut32k:
    MOV     BX,1000h
    CALL    AllocateMem
    JC	    AsmMAllocError
    MOV     WORD [SymbolSeg],AX
    MOV     WORD [FreeSymSeg],AX
    MOV     BX,1000h
    CALL    AllocateMem
    JNC     GetFreeMemOut32k2
    MOV     BP,BX
    CALL    AllocateMem
    JC	    AsmMAllocError
    SUB     BP,1000h
    NEG     BP
    SUB     AX,BP
    MOV     CL,4
    SHL     BP,CL
    MOV     WORD [DiskOutStart],BP
GetFreeMemOut32k2:
    MOV     WORD [DiskOutSeg],AX
    JMP     AsmMemOK
GetFreeMemNotEnoughOut:
    SUB     BP,1000h
    JC	    AsmNotEnoughMem
    CMP     BP,2048
    JAE     GetFreeMemOut32k
    MOV     BX,2048
    CALL    AllocateMem
    JC	    AsmMAllocError
    SUB     AX,2048
    MOV     WORD [DiskOutSeg],AX
    CALL    GetFreeMem
    MOV     BP,BX
    CALL    AllocateMem
    JC	    AsmMAllocError
    MOV     WORD [SymbolSeg],AX
    MOV     WORD [FreeSymSeg],AX
    MOV     WORD [DiskOutStart],32768
    JMP     AsmCalcSymbolLimits
AsmMAllocError2:
    MOV     SI,OFFSET _MAllocError
    JMP     AsmMemError
AllocateMemory:    

IFDEF ??ASMPP
    IF (??FORMAT==0)
	ECHO '.COM file created'
	MOV	BX,1000h
	CALL	ResizeMem
    ENDIF
ENDIF

    MOV     BX,0C00h
    CALL    AllocateMem
    JC	    AsmMAllocError2
    MOV     WORD [DiskInSeg],AX
    PUSH    DS
    MOV     DS,AX
    MOV     WORD DS:[0],0
    POP     DS
    CALL    GetFreeMem
    MOV     BP,BX
    CMP     BP,2000h
    JB	    GetFreeMemNotEnoughOut
    MOV     BX,1000h
    CALL    AllocateMem
    JC	    AsmMAllocError2

    MOV     WORD [SymbolSeg],AX
    MOV     WORD [FreeSymSeg],AX
    MOV     BX,1000h
    CALL    AllocateMem
    JC	    AsmMAllocError2
    MOV     WORD [DiskOutSeg],AX
    JMP     AsmMemOK
GetFreeMemNotEnoughRef:
AsmCalcSymbolLimits:
    MOV     CL,4
    SHL     BP,CL
    MOV     AX,BP
    XOR     DX,DX
    MOV     BP,5
    DIV     BP
    MOV     WORD [SymDataStart],AX
    SUB     AX,2
    MOV     WORD [SymMaxSymbols],AX
    MOV     WORD [FirstMaxSymbols],AX
AsmMemOK:
    MOV     AX,WORD [DiskOutStart]
    MOV     WORD [OBufferPtr],AX
    MOV     WORD [AsmStack],SP
    SUB     WORD [AsmStack],2
    JMP     AsmAssembleFile
AsmAssembleFile:    
    STI
    CALL    InitOutFile
    CALL    AssembleFileInit
AsmEnd:
    MOV AX,AsmData
    MOV ES,AX
    MOV DS,AX
    CALL    WriteOutStats
    JMP     ExitProg

;END Main
AsmDataSeg  DW	    AsmData   ;Data SEGMENT

ECHO ""
ECHO ""
ECHO "Code Length",$
CODE ENDS
