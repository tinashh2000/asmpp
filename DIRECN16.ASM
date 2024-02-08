DirectivesNStart:

IfOpError:
        JMP     InvalidEAEntry
IfDirec:        
        OR      BYTE [Settings][1],5 ;set bits 0 AND 3
        MOV     BYTE [InstrPresent],0
        CALL    GetOperand
        CMP     AH,Number
        JNZ     IfOpError
        XOR     AX,AX
        MOV     DI,OFFSET OWordNum
        MOV     CX,4
        REP     SCASW
        JZ      IfDirecFalse
IfDirecTrue:
        ADD     WORD [IfBlockCnt],1
        ADC     WORD [IfBlockCnt][2],0
        JMP     AssembleDone2
IfNotClosed:
        JMP     AlreadyInBlock
IfFatalError:
        JMP     AssembleEndOfFile
IfDirecFalse:
        MOV     BYTE [Temp3],0
        MOV     WORD [Temp1],0
        MOV     BYTE [Settings][1],0
        MOV     BYTE [InstrPresent],0
IfBlockFalse:
        CMP     BYTE [Msg],EndOfFile
        JZ      IfNotClosed
        CMP     BYTE [Error],QuitError
        JZ      IfFatalError
        CMP     BYTE [EOLFlag],0
        JNZ     IfBlockFalseSkip
        LDS     SI,DWORD [InBufferPtr]
        CALL    GetNextFindNextLine
IfBlockFalseSkip:
        ADD     WORD [LineNumber],1
        ADC     WORD [LineNumber][2],0
        MOV     BYTE [EOLFlag],0
IfDirecFalse2:
        CALL    GetNext
        CMP     AL,Hash
        JZ      IfDirecFalse2
        CMP     AL,CPUInstruction
        JNZ     IfBlockFalse
        CMP     DX,(EndIfDirective)
        JZ      IfEndIf
        CMP     DX,(ElseDirective)
        JZ      IfElse
        CMP     DX,(ElseIfDirective)
        JZ      IfElseIf
        CMP     DX,(IfDirective)
        JB      IfBlockFalse
        CMP     DX,(IfNDefDirective)
        JA      IfBlockFalse
        INC     WORD [Temp1]
        JMP     IfBlockFalse
IfElseIf:
        CMP     WORD [Temp1],0
        JNZ     IfBlockFalse
        CMP     BYTE [Temp3],0
        JNZ     IfBlockFalse
        JMP     IfDirec
IfElse:
        CMP     WORD [Temp1],0
        JNZ     IfBlockFalse
        CMP     BYTE [Temp3],0
        JNZ     IfBlockFalse

        ADD     WORD [IfBlockCnt],1
        ADC     WORD [IfBlockCnt][2],0

        SUB     WORD [LineNumber],1
        SBB     WORD [LineNumber][2],0
        JMP     AssembleFile
IfEndIf:
        CMP     WORD [Temp1],0
        JZ      IfEndIf2
        DEC     WORD [Temp1]
        JMP     IfBlockFalse
IfEndIf2:        
        JMP     AssembleDone2

HaltMac:
        MOV     BYTE [Error],0
        MOV     BYTE [Msg],0
        CALL    CloseOutFile
        MOV     AX,WORD [LineNumber]
        ADD     WORD [LinesCount],AX
        MOV     AX,WORD [LineNumber][2]
        ADD     WORD [LinesCount][2],AX
        RET

EndRsrcDefine:
        MOV     SI,OFFSET OWordNum-4
        POP     WORD [SI][6]
        PUSH    DI
        MOV     [SI][4],AX
        MOV     CH,ResourceID
        MOV     CL,[neRsrcIDLen]
        MOV     DI,BX
        MOV     BP,ES
        MOV     WORD [SI],0
        MOV     WORD [SI][2],0
        CALL    WriteSymbol
        POP     DI
        JMP     EndRsrcDone
EndResource:
        LES     SI,[neRsrcStart]
        MOV     DX,ES
        MOV     AX,[OBufferPTR]
        XOR     DI,DI
        ADD     AX,[FileSize]
        ADC     DI,[FileSize][2]
        SUB     AX,SI
        SBB     DI,DX
        PUSH    AX
        MOV     AX,SI
        MOV     CL,[neResourceAlign]
        MOV     BX,1
        SHL     BX,CL
        CALL    Div32
        OR      DI,DX
        LES     BX,[neRsrcPos]
        CMP     BYTE [neRsrcIDType],1
        JZ      EndRsrcDefine
        AND     BYTE ES:[BX][1],NOT 80h
        MOV     ES:[BX][4],AX   ;OFFSET
        POP     WORD ES:[BX][6] ;Length
EndRsrcDone:
        MOV     AL,[neRsrcCurSegBak]
        MOV     [CurSeg],AL
        TEST    DI,DI
        JNZ     EndRsrcOverflow
        JMP     AssembleDone2
EndRsrcOverflow:
        MOV     AX,0E07h
        INT 10h
        JMP     AssembleDone2

ENDDirec:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        AND     BYTE [Settings][1],NOT 2
        CMP     AL,EndOfLine
        JZ      EndDirecDone
        CMP     AL,CPUInstruction
        JZ      EndInstruc
        CMP     AH,Number
        JNZ     EndDirecManyOps
        CMP     BYTE [CurSeg],4
        JZ      EndDirecManyOps
        MOV     SI,OFFSET OWordNum
        CALL    FormatEnd
        JMP     AssembleDone2
EndDirecDone:
        CMP     BYTE [CurSeg],4
        JZ      EndResourcee
        JMP     AssembleDone2
EndInstruc:
        CMP     DX,OFFSET ResourceDirective
        JZ      EndResourcee
        CMP     DX,OFFSET IFDirective
        JZ      EndInvkEndIF
        JMP     InvalidKeyword
EndResourcee:
        JMP     EndResource
EndDirecManyOps:
        JMP     ManyOperands
EndInvkEndIf:
        JMP     EndIfDirec
EQDirecDupDef:
        JMP     DupDef
EQNumExpected:
        JMP     NumExpected

EQUDirec:
EQDirec:        
        MOV     BYTE [InstrPresent],2
        OR      BYTE [Settings][1],2
        PUSH    WORD [SymSeg]
        PUSH    WORD [SymPos]
        PUSH    CX,SI
        CALL    GetOperand
        POP     SI,CX
        POP     WORD [SymPos]
        POP     WORD [SymSeg]
        CMP     AH,Number
        JNZ     EQNumExpected
        TEST    SI,SYM_UNDEF
        JNZ     EQReferenced
        CMP     CL,UnknownID
        JZ      EQDirec2
        CMP     CL,ConstNumID
        JZ      EQExists      
        TEST    BYTE [RefFlags],8
        JNZ     EQExists
        JMP     DupDef
EQDirec2:
        MOV     CL,CH
        MOV     CH,ConstNumID
        MOV     SI,OFFSET OWordNum-4
        MOV     WORD [SI],0
        MOV     WORD [SI][2],0
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]
        CALL    WriteSymbol
        JMP     AssembleDone2
EQExists:
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI][1],07Fh
EQWrite:        
        MOV     SI,OFFSET OWordNum
        CALL    OverwriteSymbolAddress
        JMP     AssembleDone2
EQReferenced:
        PUSH    CX
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _RefEQU
        CALL    PrintError
        POP     CX
        JMP     EQExists
ForDirec:
        JMP     NotCoded
IRPDirec:
        JMP     NotCoded
OrgNumExpected:
        JMP     NumExpected
OrgNumTooBig:
        JMP     NumTooBig
OrgDirec:  
        CALL    GetOperand
OrgDirec2:
        CMP     AH,Number
        JNZ     OrgNumExpected
        TEST    BYTE [RefFlags][1],8
        JZ      OrgDirecFirst
OrgLogical:
        MOV     BX,DS
        MOV     ES,BX
        MOV     SI,OFFSET OWordNum
        MOV     DI,OFFSET ProgIP
        MOV     CX,4
        REP     MOVSW
        MOV     CL,BYTE [AddrMode]
        ADD     CL,CL
        OR      CL,0C0h
        CMP     AH,CL
        JA      OrgNumOverflow
        JMP     AssembleDone2
OrgDirecFirst:
        TEST    BYTE [InBlock],0FEh
        JNZ     OrgLogical
        OR      BYTE [RefFlags][1],8
        CMP     AL,Num16
        JA      OrgLogical
        CALL    MarkInitORG
        JC      OrgLogical
        JMP     AssembleDone2
OrgNumOverflow:
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _ProgIPOverflow
        CALL    PrintError
        JMP     AssembleDone2

EchoMac:        
        OR      BYTE [Settings][1],5 ;set bits 0 AND 3
        MOV     AL,BYTE [RadixValue]
        MOV     BYTE [Temp1],AL
        MOV     BYTE [InstrPresent],0
        JMP     EchoLoop2
EchoLoop:
        MOV     AL,32
        CALL    PrintChar
EchoLoop2:        
        MOV     BYTE [CommaFlag],0
        MOV     WORD [StrLen],0
EchoLoopGetHash:
        CMP BYTE [NextChar], Hash
        JZ  EchoHashChar
        CALL    GetOperand
        MOV     BX,DS
        MOV     ES,BX
        CMP     AH,Number
        JZ      EchoNumber
        CMP     AL,Quote
        JZ      EchoQuote
        CMP     AL,Hash
        JZ      EchoSpecial
        CMP     WORD [StrLen],0
        JNZ     EchoRAWAlpha
        CMP     AL,EndOfLine
        JNZ     EchoLoop
        CALL    PrintLF
        JMP     AssembleDone2
EchoHashChar:
PUSHAD
    MOV AL,'#'
    CALL PrintChar
    MOV AL,'!'
    CALL PrintChar
POPAD
    JMP EchoLoopGetHash
EchoRAWAlpha:
        MOV     SI,OFFSET StrBuffer
        MOV     CX,WORD [StrLen]
        CALL    PrintStrFixed        
        JMP     EchoLoop
EchoSpecial:
        JMP     EchoSpecial2
EchoNumber:
        CMP     AL,Alpha
        JZ      EchoRAWAlpha
        MOV     AX,DX
        MOV     DX,WORD [OWordNum][2]
EchoNumber2:
        MOV     BL,BYTE [Temp1]
        CMP     BL,2
        JZ      EchoPrtBin
        CMP     BL,8
        JZ      EchoPrtOct
        CMP     BL,10
        JNZ     EchoPrtHex
        CALL    PrintInt
        JMP     EchoLoop
EchoPrtBin:
        CALL    PrintBin
        JMP     EchoLoop
EchoPrtOct:
        CALL    PrintOct
        JMP     EchoLoop
EchoPrtHex:
        CALL    PrintHex
        JMP     EchoLoop
EchoQuote:
        MOV     CX,DX
        MOV     SI,OFFSET StrBuffer
        CALL    PrintStrFixed
        JMP     EchoLoop
EchoExit:
        JMP     AssembleDone2
EchoSpecial2:
        MOV     WORD [StrLen],0
        AND     BYTE [Settings],0FCh
        CALL    GetOperand
        CMP     AH,Number
        JZ      EchoAscChar
        CMP     AL,EndOfLine
        JZ      EchoExit
EchoSpecial3:
        MOV     CX,WORD [StrLen]
        MOV     AX,DS
        MOV     ES,AX
        TEST    CH,CH
        JNZ     EchoRAWAlpha
        CMP     CX,1
        JA      EchoRAWAlpha
        MOV     SI,OFFSET StrBuffer
        CALL    LCaseStr
        MOV     CX,WORD [StrLen]
        MOV     SI,OFFSET StrBuffer
        CMP     CX,1
        JZ      EchoSpecialL1
        JMP     EchoLoop
EchoAscChar:
        TEST    BYTE [Settings],3
        JNZ     EchoSpecial3
        MOV     AL,DL
        CALL    PrintChar
        JMP     EchoLoop2
EchoSpecialL1:
        MOV     AL,BYTE [StrBuffer]
        CMP     AL,'h'
        JZ      EchoNumberHex
        CMP     AL,'d'
        JZ      EchoNumberDec
        CMP     AL,'b'
        JZ      EchoNumberBin
        CMP     AL,'o'
        JZ      EchoNumberOct
        CALL    PrintChar
        JMP     EchoLoop
EchoNumberHex:
        MOV     BYTE [Temp1],16
        JMP     EchoLoop2
EchoNumberDec:
        MOV     BYTE [Temp1],10
        JMP     EchoLoop2
EchoNumberOct:
        MOV     BYTE [Temp1],8
        JMP     EchoLoop2
EchoNumberBin:
        MOV     BYTE [Temp1],2
        JMP     EchoLoop2


EndIfDirec:
        XOR     AX,AX
        MOV     BX,OFFSET IfBlockCnt
        CMP     WORD [BX],AX
        JNZ     EndIfOK
        CMP     WORD [BX][2],AX
        JZ      ElseIfMissingIf
EndIfOK:
        SUB     WORD [BX],1
        SBB     WORD [BX][2],0
        JMP     AssembleDone2

ElseIfMissingIf:
        JMP     InvalidKeyword

ElseDirec:
        XOR     AX,AX   ;IF ELSE is executed from here, it means that it was
        CMP     AX,WORD [IfBlockCnt]    ;true. It has to be false
        JNZ     ElseFalse2
        CMP     AX,WORD [IfBlockCnt][2]
        JZ      ElseIfMissingIf
ElseFalse2:
        MOV     BYTE [Temp3],10
        MOV     WORD [Temp1],AX
        MOV     BYTE [InstrPresent],0
        JMP     IfBlockFalse

EndMDirec:
        MOV     AL,BYTE [InBlock]
        TEST    AL,8
        JZ      EndXEndMismatch
        AND     BYTE [InBlock],NOT 8
        JMP     AssembleDone2
EndXEndMismatch:
        JMP     UnmatchedEnd
EndPDirec:        
        MOV     AL,BYTE [InBlock]
        TEST    AL,4
        JZ      EndXEndMismatch
        TEST    AL,0FAh
        JNZ     EndXEndMismatch

        AND     BYTE [InBlock],NOT 4
        XOR     AX,AX
        MOV     WORD [LocalSymPtr],AX
        AND     WORD [ProcFlags],300h
        MOV     WORD [ProcArgSize],AX
EndPDone:
        JMP     AssembleDone2
EndSDirec:        
        MOV     AL,BYTE [InBlock]
        TEST    AL,3
        JZ      EndXEndMismatch        
        TEST     AL,2
        JNZ     EndStruc

        TEST    AL,0FCh
        JNZ     EndXEndMismatch

        AND     BYTE [InBlock],NOT 1
        CALL    CloseSegment
        MOV     BYTE [CurSeg],0FEh
        JMP     AssembleDone2
EndStruc:
        AND     BYTE [InBlock],NOT 2
        AND     BYTE [ExtMask],NOT SYM_STRUCT
        MOV     SI,OFFSET EADisp
        MOV     DI,OFFSET ProgIP
        MOV     AX,WORD [DI]
        MOVSW
        MOVSW
        MOVSW                       
        MOVSW
        MOV     ES,WORD [SIBDisp]
        MOV     DI,WORD [BaseReg]
        MOV     WORD ES:[DI].seIDData,AX
        MOV     AX,WORD [NumSymbols]
        SUB     AX,WORD [BlockBak1]
        MOV     WORD ES:[DI][2].seIDData,AX
        MOV     AL,BYTE [CurSeg][1]
        MOV     BYTE [CurSeg],AL
        MOV     AX,WORD [EADispSize]
        MOV     WORD [OBufferPtr],AX
        JMP     AssembleDone2
ExitDirec:
        JMP     NotCoded
IRPSMac:
        JMP     NotCoded
AlignNumExpected:
        JMP     NumExpected
AlignDirec:
        CALL    GetOperand
        CMP     AH,Number
        JZ      AlignDirecNum
        CMP     AL,EndOfLine
        JNZ     AlignNumExpected
        MOV     AL,Num8
        MOV     DL,BYTE [AddrMode]
        MOV     DH,0
        ADD     DL,DL
AlignDirecNum:
        MOV     BX,DX
        TEST    BX,BX
        JZ  AlignDone
        XOR     DX,DX
        CMP     BYTE [AddrMode],2
        JZ      AlignAddr32
        JA      AlignAddr64
        MOV     AX,WORD [ProgIP]
        DIV     BX
AlignFill:
        TEST    DX,DX
        JZ      AlignDone
        SUB     BX,DX
        MOV     CX,BX
        CALL    ReserveData16
AlignDone:
        JMP     AssembleDone2
AlignAddr32:
        MOV     AX,WORD [ProgIP][2]
        DIV     BX
        MOV     AX,WORD [ProgIP]
        DIV     BX
        JMP     AlignFill
AlignAddr64:
        MOV     AX,WORD [ProgIP][6]
        DIV     BX
        MOV     AX,WORD [ProgIP][4]
        DIV     BX
        MOV     AX,WORD [ProgIP][2]
        DIV     BX
        MOV     AX,WORD [ProgIP]
        DIV     BX
        JMP     AlignFill
ExitMDirec:
        JMP     NotCoded
IfDefDirec:
        OR      BYTE [Settings][1],5 ;set bits 0 AND 3
        MOV     BYTE [InstrPresent],0
        AND     BYTE [Settings],0FCh
        CALL    GetOperand
        MOV     AL,BYTE [Settings]
        AND     AL,3
        CMP     AL,3
        JZ      IfDefFalse
        ADD     WORD [IfBlockCnt],1
        ADC     WORD [IfBlockCnt][2],0
        JMP     AssembleDone2
IfDefFalse:
        JMP     IfDirecFalse
MacroDirec:
        JMP     NotCoded
FunctionDirec:
        JMP     NotCoded
RadixDirec:
        MOV     BYTE [RadixValue],10
        CALL    GetOperand
        CMP     AH,Number
        JNZ     RadixNumExpected
        CMP     AL,Num8
        JNZ     RadixBad
        CMP     DL,16
        JZ      RadixOK
        CMP     DL,10
        JZ      RadixOK
        CMP     DL,8
        JZ      RadixOK
        CMP     DL,2
        JZ      RadixOK
RadixBad:
        JMP     BadRadix
RadixOK:
        MOV     BYTE [RadixValue],DL
        JMP     AssembleDone2
RadixNumExpected:
        JMP     NumExpected

StackDirec:
        CALL    GetOperand
        CMP     AH,Number
        JNZ     RadixNumExpected
        MOV     AH,BYTE [OutFormat]
        CMP     AH,OutMZ
        JZ      _MZStack
        CMP     AH,OutNE16
        JZ      _NE16Stack
        CMP     AH,OutPE32
        JZ      _PE32Stack
        CMP     AH,OutPE64
        JZ      _PE64Stack
        MOV     DI,OFFSET StrBuffer
        MOV     AX,"ts"
        STOSW
        MOV     AX,"ca"
        STOSW
        MOV     AX,"k"
        STOSW
        JMP     InvalidKeyword

_MZStack:
		JMP		MZStack
		
_NE16Stack:
		JMP		NE16Stack
		
_PE32Stack:	
		JMP		PE32Stack

_PE64Stack:
		JMP		PE64Stack
		

HeapNumExpected:
        JMP NumExpected

HeapDirec:
        CALL    GetOperand
        CMP     AH,Number
        JNZ     HeapNumExpected
        MOV     AH,BYTE [OutFormat]
        CMP     AH,OutMZ
        JZ      MZHeap
        CMP     AH,OutNE16
        JZ      NE16Heap
        CMP     AH,OutPE32
        JZ      _PE32Heap
        CMP     AH,OutPE64
        JZ      _PE64Heap
        MOV     DI,OFFSET StrBuffer
        MOV     AX,"eh"
        STOSW
        MOV     AX,"pa"
        STOSW
        MOV     AL,0
        STOSB
        JMP     InvalidKeyword
NE16Heap:
        JMP     AssembleDone2

MZHeap:
        JMP     AssembleDone2

HeapNumTooBig:
        JMP     NumTooBig

_PE32Heap:
		JMP	PE32Heap

_PE64Heap:
		JMP	PE64Heap

Use16Direc:
        CALL    _USE16
        JMP     AssembleDone2

Use32Direc:
        CALL    _USE32
        JMP     AssembleDone2

Use64Direc:
        CALL    _USE64
        JMP     AssembleDone2

_USE16:
        OR      BYTE [RefFlags],2
        MOV     BYTE [AddrMode],1
        MOV     AL,0
        MOV     BYTE [Addr16Disp],AL
        INC     AX
        MOV     BYTE [Addr32Disp],AL
        MOV     BYTE [Addr64Disp],AL
        RET

_USE32:
        OR      BYTE [RefFlags],2
        MOV     BYTE [AddrMode],2
        MOV     AL,1
        MOV     BYTE [Addr16Disp],AL
        DEC     AX
        MOV     BYTE [Addr32Disp],AL
        MOV     BYTE [Addr64Disp],AL
        RET

_USE64:
        OR      BYTE [RefFlags],2
        MOV     BYTE [AddrMode],4
        MOV     AL,1
        MOV     BYTE [Addr16Disp],AL
        DEC     AX
        MOV     BYTE [Addr32Disp],AL
        MOV     BYTE [Addr64Disp],AL
        RET

ExternIDExpected:
        MOV     SI,OFFSET _InvalidOperand
        JMP     PrtError
Ignored:
        MOV BYTE [Error],130
        MOV SI,OFFSET _Ignored
        JMP     PrtError
ExternDupDef:
        CMP     AH,Identifier
        JNZ     ExternIDExpected
        TEST    BYTE [RefFlags],8
        JNZ     ExternDirecIDOK
        MOV     SI,OFFSET _DupDef
        JMP     PrtError

ExternDirecDone:
        PUSH    DS
        POP     ES
        JMP     AssembleDone2
        
ExternDirec:
        MOV     BYTE [InstrPresent],0
        MOV AL,[OutFormat]
        CMP AL,OutCOFF32
        JZ  ExternDirecLoop
        CMP AL,OutCOFF64
        JZ  ExternDirecLoop
        CMP AL,OutOMF16
        JZ  ExternDirecLoop
        CMP AL,OutOMF32
        JNZ Ignored
ExternDirecLoop:
        CALL    GetNext
        CMP     AL,EndOfLine
        JZ      ExternDirecDone
        CMP     AX,Identifier SHL 8 OR UnknownID
        JNZ     ExternDupDef
ExternDirecIDOK:
        MOV     [Temp1],DI
        MOV     [Temp2],BP

		PUSH	WORD [SymSeg]
		PUSH	WORD [SymPos]
		POP		WORD [Temp3]
		POP		WORD [Temp4]

        MOV     SI,OFFSET StrBuffer
        MOV     AL,[StrLen]
        CALL    ExternDef
        PUSH    AX,DX           ;To be written on symbol
        MOV     AL,[NextChar]
        MOV     AH,AL
        SUB     AL,Colon
        MOV     CL,[StrLen]
        MOV     CH,[AddrMode]
        MOV     CH,(LabelID)
        CMP     AL,1
        ADC     WORD [InBufferPtr],0
        CMP     AH,Colon
        JNZ     ExternDirecDefType
        PUSH    CX
        CALL    GetNext
        POP CX
        CMP     AL,CPUInstruction
        JZ      ExternInstr
        CMP     AL,Keyword
        JNZ     ExternOpSizeReq
        CMP     DL,DistSpec
        JZ      ExternDistSpec
        CMP     DX,4 SHL 8 OR Operator
        JZ      ExternSegID
        CMP     DL,DataType
        JNZ     ExternOpSizeReq
        DEC     DH
        MOV     CH,DH
ExternDirecDefType:
		TEST	BYTE [RefFlags],8
		JNZ	ExternDirecDefTypeOverwrite
        LES     DI,[Temp1]
        MOV     BP,ES
        MOV     SI,OFFSET OWordNum-4
        POP     WORD [SI][6]
        POP     WORD [SI][4]
        MOV     BYTE [SI],FMT_EXTERN
        CALL    WriteSymbol
        MOV     BYTE [CommaFlag],0
        JMP     ExternDirecLoop
ExternDirecDefTypeOverwrite:
        LES     DI,[Temp3]
        MOV     BP,ES
        MOV     SI,OFFSET OWordNum-4
        POP     WORD [SI][6]
        POP     WORD [SI][4]
        MOV     BYTE [SI],FMT_EXTERN
        CALL    OverwriteSymbol
        MOV     BYTE [CommaFlag],0
        JMP     ExternDirecLoop


ExternSegID:
        MOV     CH,SegmentID
        JMP     ExternDirecDefType
ExternOpSizeReq:
        MOV     SI,OFFSET _InvalidOperandSize
        JMP     PrtError
ExternInstr:
        CMP     DX,OFFSET LabelDirective
        JZ      ExternDistNear
        CMP     DX,OFFSET ProcDirective
        JNZ     ExternOpSizeReq
ExternDistNear:
        MOV     CH,LabelID
        JMP     ExternDirecDefType
ExternDistFar:
        MOV     CH,LocalID
        JMP     ExternDirecDefType
ExternDistSpec:
        CMP     DH,2
        JZ      ExternDistNear
        CMP     DH,3
        JZ      ExternDistFar
        JMP     ExternOpSizeReq

PublicIgnore:
        JMP Ignored
PublicSkip:
        CALL    GetRAWLine
        JMP     AssembleFile

GlobalDirec:
PublicDirec:        
        CMP     WORD [Pass],1
        JNZ     PublicSkip
        MOV AL,[OutFormat]
        CMP AL,OutCOFF32
        JZ  PublicDirecOK
        CMP AL,OutCOFF64
        JZ  PublicDirecOK
        CMP AL,OutOMF16
        JZ  PublicDirecOK
        CMP AL,OutOMF32
        JNZ PublicIgnore
        JMP PublicDirecOK
PublicTestLen2:
        MOV     BX,OFFSET LCaseTable
        MOV     AX,[StrBuffer]
        XLAT
        XCHG    AL,AH
        XLAT
        CMP     AX,"on"
        JNZ     PublicGetVar
        OR      BYTE [ExtMask],FMT_PUBLIC
        CMP     WORD [Pass],1
        JNZ     PublicONDone
        OR  BYTE [RefFlags],16
PublicONDone:
        JMP     AssembleDone2
PublicTestLen3:
        MOV     BX,OFFSET LCaseTable
        MOV     AX,[StrBuffer]
        XLAT
        XCHG    AL,AH
        XLAT
        CMP     AX,"of"
        JNZ     PublicGetVar
        MOV     AL,[StrBuffer][2]
        XLAT
        CMP     AL,"f"
        JNZ     PublicGetVar
        AND     BYTE [ExtMask],NOT FMT_PUBLIC
        JMP     AssembleDone2        

PublicDirecOK:
        MOV     BYTE [InstrPresent],0
PublicDirecLoop:
        MOV     WORD [StrLen],0
        CALL    GetNext
        CMP     AL,EndOfLine
        JZ      PublicDone
        MOV     CX,AX
        MOV     AX,[StrLen]
        CMP     AX,3
        JZ      PublicTestLen3
        CMP     AX,2
        JZ      PublicTestLen2
PublicGetVar:
        CMP     CH,Identifier
        JNZ     PublicIDExpected
        MOV     AL,[NextChar]
        SUB     AL,Colon
        MOV     CH,[StrLen]
        CMP     AL,1
        JNC     PublicGetType        
        MOV     [Temp1],DI
        MOV     [Temp2],BP
        PUSH    CX
        ADC     WORD [InBufferPtr],0
        CALL    GetNext
        POP CX
        CMP     AL,CPUInstruction
        JZ      PublicInstr
        CMP     AL,Keyword
        JNZ     PublicInvalidType
        CMP     DL,DistSpec
        JZ      PublicProcOK
        CMP     DL,DataType
        JNZ     PublicInvalidType
        DEC     DH
PublicTypeOK:
        CMP     CL,UnknownID
        JZ      PublicDefUnknown1
        JMP     PublicOverwrite
PublicGetType:
        MOV     DH,BYTE [AddrMode]
        DEC     DH
        MOV DH,(LabelID)
        CMP     CL,UnknownID
        JZ      PublicDefUnknown
PublicOverwrite:
        LES     DI,[SymPos]
        OR      BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        OR      BYTE [RefFlags],16
        JMP     PublicDirecLoop
PublicDone:
        JMP     AssembleDone2
PublicInstr:
        CMP     DX,OFFSET LabelDirective
        JZ      PublicProcOK
        CMP     DX,OFFSET ProcDirective
        JNZ     PublicInvalidType
PublicProcOK:
        MOV     DX,LabelID
        JMP     PublicTypeOK
PublicInvalidType:
        MOV     SI,OFFSET _InvalidOperandSize
        JMP     PrtError
PublicIDExpected:
        MOV     SI,OFFSET _InvalidOperand
        JMP     PrtError
PublicDefUnknown1:
        LES     DI,[Temp1]
        MOV     BP,ES
PublicDefUnknown:
        MOV SI,OFFSET Zeros
        MOV     CL,CH
        MOV     CH,DH
        MOV     BYTE [SI],FMT_PUBLIC OR SYM_UNDEF
        CALL    WriteSymbol
        JMP     PublicDirecLoop

FormatDirec		PROC

        CMP     DI,OFFSET OutFile

        CMP     BYTE [FileLevel],0
        JNZ     FormatInvalidKW

        MOV		BYTE [externStub],0

        MOV     AX,WORD [OBufferPtr]
        SUB     AX,WORD [DiskOutStart]
        JNZ     FormatNotFirst

        CMP     WORD [FileSize],AX
        JNZ     FormatNotFirst

        CMP     WORD [FileSize][2],AX
        JNZ     FormatNotFirst

        XOR     AX,AX
        MOV     DI,OFFSET ProgIP
        STOSW
        STOSW
        STOSW
        STOSW
        JMP     FormatDirec2

FormatInvalidKW:
        JMP     InvalidKeyword

FormatNotFirst:
        MOV     AL,BYTE [AsmFlags]
        AND     AL,11h
        CMP     AL,11h
        JNZ     FormatInvalidKW
        CMP     WORD [NumErrors],0
        JNZ     FormatDirecNewFMT
        CALL    EnterNewPass
FormatDirecNewFMT:
        CALL    CloseOutFile
        MOV     WORD [OutFileLen],0
        MOV     BYTE [OutFile],0

        CALL    ResetAllData
FormatDirec2:
        XOR     AX,AX
        MOV     BYTE [RefFlags],AL
        MOV     WORD [StrLen],AX
        MOV     WORD [OutHandle],AX
        MOV     WORD [NewHandle],AX
        MOV     BYTE [InstrPresent],AL
FormatDirecGetFormat:
        CALL    GetRAWLine
        CMP DI,(StrBuffer)
        JZ  FormatError

        MOV DI,(StrBuffer)

        MOV CX,[StrLen]

        PUSH    CX
        MOV AL,32
        REPNZ   SCASB
        POP CX
        JNZ FormatDirecGetFormat2
        MOV CX,DI
        SUB CX,(StrBuffer)+1
        PUSH    CX

        SUB CX,[StrLen]
        NEG CX

        MOV SI,DI
        MOV DI,(FmtParams)
        REP MOVSB

        POP CX
FormatDirecGetFormat2:		
        MOV [StrLen],CX
        MOV     AX,DS
        MOV     ES,AX
        CALL    MarkInitPos
        MOV     SI,OFFSET StrBuffer
        MOV     DI,SI
        MOV     CX,WORD [StrLen]    ;IF NOT alpha its zero.
        CALL    LCaseStr
        MOV     SI,OFFSET StrBuffer
        MOV     CX,WORD [StrLen]
        XOR     AX,AX
		CMP		CX,7				;If length is > 7
		JAE		FormatError
        CMP     CL,2
        JZ      FormatLen2
        JB      FormatError
        CMP     CL,4
        JB      FormatLen3
        JZ      FormatLen4
        CMP     CL,6
        JB      FormatLen5
        JZ      FormatLen6
FormatError:
        MOV     SI,OFFSET _FormatRequired
        CALL    PrintError
        JMP     AssembleDone3

FormatCOM:
        MOV     WORD [ProgIP],100h
        MOV     BYTE [BX],OutCOM
        JMP     AssembleDone2

FormatLen2:
        MOV     AX,WORD [SI]
        MOV     SI,OFFSET OutFormat
        CMP     AX,"zm"
        JZ      FormatMZ
        CMP     AX,"ep"
        JZ      FormatPE32
        JMP     FormatError

FormatLen3:
        MOV     DI,OFFSET Formats3
		MOV		BX,(f3Table)
		JMP		FormatSearch

FormatLen4:
        MOV     DI,OFFSET Formats4
		MOV		BX,(f4Table)
FormatSearch:
        CALL    SearchStr
        MOV     SI,OFFSET OutFormat
		AND		AL,7
		MOV		AH,0
		ADD		BX,AX
		ADD		BX,AX
		JMP		[BX]

FormatLen5:
        MOV     DI,OFFSET Formats5
		MOV		BX,(f5Table)
		JMP		FormatSearch

FormatLen6:
        MOV     DI,OFFSET Formats6
		MOV		BX,(f6Table)
		JMP		FormatSearch

FormatOMF16:
        MOV     BYTE [SI],OutOMF16
        CALL	_Use16
        JMP     FormatInitOut

FormatMZ:
        MOV     BYTE [SI],OutMZ
        CALL	_Use16
        JMP     FormatInitOut

FormatNE16:
        MOV     BYTE [SI],OutNE16
        CALL	_Use16
        JMP     FormatInitOut

FormatPE32:
        MOV     BYTE [SI],OutPE32
        CALL	_Use32
        JMP     FormatInitOut

FormatPE64:
        MOV     BYTE [SI],OutPE64
        CALL	_Use64
        JMP     FormatInitOut

FormatBin:
        MOV     BYTE [SI],OutBin
        CALL	_Use16
        JMP     FormatInitOut

FormatELF32:
        MOV     BYTE [SI],OutELF32
        CALL	_Use32
        JMP     FormatInitOut

FormatELF64:
        MOV     BYTE [SI],OutELF64
        CALL	_Use64
        JMP     FormatInitOut
		
FormatCOFF32:
        MOV     BYTE [SI],OutCOFF32
        CALL	_Use32
        JMP     FormatInitOut

FormatCOFF64:
        MOV     BYTE [SI],OutCOFF64
        CALL	_Use64
        JMP     FormatInitOut

FormatOMF32:
        MOV     BYTE [SI],OutOMF32
        CALL	_Use32
        JMP     FormatInitOut

FormatInitOut:
        PUSH    DS
        POP     ES
        XOR     AX,AX
        MOV     DI,OFFSET MiscFmt
        MOV     CX,5120/2
        REP     STOSW
        CALL    InitOutFile
        JMP     AssembleDone2
FormatDirec		ENDP


IfNDefDirec	PROC
        OR      BYTE [Settings][1],5 ;set bits 0 AND 3
        MOV     BYTE [InstrPresent],0
        AND     BYTE [Settings],0FCh
        CALL    GetOperand
        MOV     AL,BYTE [Settings]
        AND     AL,3
        CMP     AL,3
        JNZ     IfNDefFalse
        ADD     WORD [IfBlockCnt],1
        ADC     WORD [IfBlockCnt][2],0
        JMP     AssembleDone2
	IfNDefFalse:
        JMP     IfDirecFalse
IfNDefDirec	ENDP

StrucDirec:
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]

        MOV     WORD [StructBlockIDCrc],DI
        MOV     WORD [StructBlockIDCrc][2],BP
        MOV     BYTE [StructBlockIDLen],CH
        
        CMP     CL,UnknownID
        JNZ     StrucDupDef

        MOV     SI,OFFSET Zeros
        MOV     CL,CH
        MOV     CH,StructID
        MOV     BYTE [SI],0
        CALL    WriteSymbol
        JMP	StrucIDOK

StrucDupDef:
        TEST    BYTE [RefFlags],8
        JNZ     StrucIDOK
        JMP     DupDef

StrucInBlock:
        JMP     AlreadyInBlock
        
StrucIDOK:

        MOV     AX,DS
        MOV     ES,AX

        TEST    BYTE [InBlock],0F8h
        JNZ     StrucInBlock

        MOV     AX,WORD [SymPos]    ;Save information needed later FOR
        MOV     WORD [BaseReg],AX   ;entering the struct INTO a table.
        MOV     AX,WORD [SymSeg]
        MOV     WORD [SIBDisp],AX

        MOV     AX,WORD [NumSymbols]
        MOV     WORD [BlockBak1],AX
        MOV     AX,WORD [NumSymbols][2]
        MOV     WORD [BlockBak1][2],AX

        OR      BYTE [InBlock],2

        MOV     AX,WORD [OBufferPtr]    ;We must never flush this
        MOV     WORD [EADispSize],AX

        MOV     AL,BYTE [CurSeg]    ;We must back this before changing it
        MOV     BYTE [CurSeg][1],AL

        MOV     BYTE [CurSeg],2

        MOV     SI,OFFSET ProgIP
        MOV     DI,OFFSET EADisp
        MOVSW
        MOVSW
        MOVSW
        MOVSW
        MOV     DI,OFFSET ProgIP
        XOR     AX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        OR      BYTE [ExtMask],SYM_STRUCT
        JMP     AssembleDone2

CommentDirec:
        PUSH    DS
        POP ES
        LDS     SI,[InBufferPtr]
        LODSB
        MOV     ES:[InBufferPtr],SI
        CMP AL,0Ah
        JNZ CommentDirecCharOK
        PUSH    CS
        POP DS
        MOV SI,OFFSET _CommentNoTerminator
        JMP PrtError
CommentDirecCharOK:
        MOV     AH,AL
        PUSH    AX
        CALL    GetNextFindNextLine
        POP AX
        CMP BYTE [Msg],EndOfFile
        JZ  CommentDirecEOF
        LDS SI,[InBufferPtr]
CommentDirecFindChar:
        LODSB
        TEST    AL,AL
        JZ  CommentDirecFetchInput
        CMP AL,0Ah
        JZ  CommentDirecNextLine
        CMP AL,AH
        JNZ CommentDirecFindChar
        PUSH    ES
        POP DS
        MOV [InBufferPtr],SI
        JMP     AssembleDone2
CommentDirecNextLine:
        ADD WORD ES:[LineNumber],1
        ADC WORD ES:[LineNumber][2],0
        JMP CommentDirecFindChar
CommentDirecFetchInput:
        PUSH    AX
        CALL  ReadInFile
        TEST    AX,AX
        POP AX
        JNZ CommentDirecFindChar
CommentDirecEOF:
        PUSH    ES
        POP DS
        MOV SI,OFFSET _CommentNotClosed
        MOV BYTE [Error],128
        JMP PrtError

IncludeInvalidFile:
        MOV     SI,OFFSET _FileNameExpected
        JMP     IncludeQuitError
IncludeTooNested:
        MOV     SI,OFFSET _FilesTooNested
IncludeQuitError:
        MOV     BYTE [Error],QuitError
        CALL    PrintError
        RET

IncludeDirec:
        MOV     AX,DS
        MOV     ES,AX
        CMP     BYTE [FileLevel],5
        JA      IncludeTooNested
IncludeGetLine:
        CALL    GetStrFile
        CMP     DI,OFFSET StrBuffer
        JZ      IncludeInvalidFile

        MOV BX,(StrBuffer)
        MOV BYTE [DI],0

        MOV CX,SI
        SUB CX,BX

        MOV DI,(StrBuffer-70)
        PUSH    BX
        PUSH    DI
        CALL    GenerateFileName
        ADD DI,AX
 IncludeGetFileOK:
        XOR     AX,AX
        MOV     [BytesRead],AX
        MOV     [BytesRead][2],AX
        MOV     DX,AX
        MOV     CX,AX
        XCHG    DX,[BytesReadBak]  ;Get value AND reset
        XCHG    CX,[BytesReadBak][2] ;Get value AND reset
        ADD     DX,[InBufferPtr]   ;Point File pointer to the line after the INCLUDE
        ADC     CX,0
        MOV     BX,WORD [CurHandle]
        MOV     AL,0
        CALL    FSeek
        MOV     BX,[FileLevel]
        MOV     AX,72
        MUL     BX
        MOV     BX,AX
        PUSH    DI
        MOV     SI,OFFSET CurFile   ;Copy the state of the current file
        LEA     DI,[BX][Files]
        MOV     CX,36
        REP     MOVSW
        MOV     WORD [Temp7],DI     ;Save new free INCLUDE file area.
        MOV     DX,(StrBuffer-70)
        MOV     AL,0
        CALL    FOpen
        POP     DI
        JC      IncludeFileError
        MOV     WORD [CurHandle],AX
        LEA     CX,[DI][-(StrBuffer-70)]
        MOV     SI,OFFSET StrBuffer
        MOV     DI,OFFSET CurFile
        REP     MOVSB
        XOR     AX,AX
        MOV     WORD [LineNumber],AX
        MOV     WORD [LineNumber][2],AX
        LEA     AX,[DI][-CurFile][-1] ;Subtract 1 FOR the null termination
        MOV     WORD [ThisFileLen],AX
        INC     BYTE [FileLevel]        
        MOV     BYTE [Flushed],0
        JMP     AssembleFileInit
IncludeFileError:
        MOV     BYTE [Error],QuitError
        MOV     SP,WORD [AsmStack]
        JMP     PrintFileError

SegmentInBlock:
        JMP     AlreadyInBlock

SegmentDirecNoLabel	PROC
        MOV     [Temp1],0
		MOV		[Temp2],0
		XOR		CX,CX
		CALL	SegmentDirec
		RET
SegmentDirecNoLabel	ENDP

SegmentDirec	PROC
        MOV     AL,BYTE [InBlock]
        TEST    AL,0FEh
        JNZ     SegmentInBlock
        AND     [RefFlags],NOT 80h
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]        

        MOV     WORD [SegBlockIDCrc],DI
        MOV     WORD [SegBlockIDCrc][2],BP
        MOV     BYTE [SegBlockIDLen],CH

        PUSH    AX,CX,SI
        CALL    CloseSegment
        POP     SI,CX,AX

        TEST    AL,1
        JZ      SegDirecOK
        MOV     BYTE [CurSeg],0FEh
SegDirecOK:
        CMP     BYTE [CurSeg],0FEh
        MOV     BYTE [CurSeg],1
        MOV     BYTE [CurSeg][3],1
        JNZ     SegmentOK
        TEST    BYTE [OutFlags],1
        JNZ     SegmentOK

        PUSH    CX,SI
        CALL    InitFirstSeg
        POP SI,CX

SegmentOK:
        PUSH    WORD [SymSeg]
        PUSH    WORD [SymPos]
        PUSH    CX,SI

        OR      BYTE [OutFlags],1
        AND     BYTE [RefFlags][1],NOT 8
        OR      BYTE [Settings][1],1

        MOV BYTE [CurSeg],SEGMENT_CODE
        CALL    SegmentAlign
        PUSH    DS
        POP ES
        XOR     AX,AX
        MOV     DI,OFFSET ProgIP
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     WORD [Temp4],AX
        INC AX
        MOV WORD [Temp3],AX
        JMP SegmentDirecGetArgs

SegUse16:
        CALL    _USE16
        JMP SegmentDirecGetArgs

SegUse32:
        CALL    _USE32
        JMP SegmentDirecGetArgs

SegUse64:
        CALL    _USE64
        JMP SegmentDirecGetArgs

SegmentInstr:
        TEST    BYTE [Temp4],4
        JNZ SegInvalidKW
        CMP DX,(Use16Directive)
        JZ  SegUse16
        CMP DX,(Use32Directive)
        JZ  SegUse32
        CMP DX,(Use64Directive)
        JZ  SegUse64
        CMP DX,(ImportDirective)
        JZ  SegImport
        CMP DX,(ExportDirective)
        JZ  SegExport
SegInvalidKW:
        JMP InvalidKeyword

SegImport:
        CALL    ImportSegment
        JC  SegInvalidKW
        JMP SegmentDirecGetArgs

SegExport:
        CALL    ExportSegment
        JC  SegInvalidKW
        JMP SegmentDirecGetArgs

SegmentDirecClass:
        TEST    BYTE [Temp4],1
        JNZ SegmentInvalidOp
        MOV SI,OFFSET StrBuffer
        CALL    FormatSegClass
        OR      BYTE [Temp4],1
        JMP     SegmentDirecGetArgs
        
SegmentInvalidOp:
        JMP     InvalidOperand
SegmentDirecGetArgs:
        XOR     AX,AX
        MOV     WORD [StrLen],AX
        MOV     BYTE [InstrPresent],AL
		CALL    GetNext
        CMP     AL,Keyword
        JZ      SegmentDirecKW
        CMP     AL,Quote
        JZ      SegmentDirecClass
        CMP     AL,CPUInstruction
        JZ  SegmentInstr
        CMP     AL,EndOfLine
        JZ      SegmentWriteID
        JMP     SegmentGetParam
SegmentWriteID:
        POP     SI,CX
        POP     WORD [SymPos]
        POP     WORD [SymSeg]
SegmentNameOK:
		TEST	CX,CX
		JZ		SegmentInit
        TEST    SI,SYM_UNDEF
        JNZ     SegmentExists
        CMP     CL,UnknownID
        JZ      SegmentDef
        TEST    BYTE [RefFlags],8
        JNZ     SegmentExists
        JMP     DupDef
SegmentDirecKW:
        JMP     SegmentWriteID
SegmentExists:        
        LES     DI,DWORD [SymPos]
        MOV     BYTE ES:[DI].seIDType,SegmentID ;Clear the all bits except the extended.
        AND     BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        TEST    BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        JZ      SegmentExistsPubOK
        MOV     SI,OFFSET StrBuffer+256
        PUSH    CX
        PUSH    DS
        POP     ES
        CALL    PublicDef
        POP     CX
        LES     DI,DWORD [SymPos]
SegmentExistsPubOK:
        MOV     AL,1
        ADD     DI,(seIDData)
        CALL    GetSegAddr
        MOV     ES:[DI],AX
        MOV     ES:[DI][2],DX
;        JNC     segDirecDone
SegmentInit:
        PUSH    DS
        POP ES
        MOV     SI,OFFSET StrBuffer+256
        CALL    FormatInitSeg
segDirecDone:
        MOV     BYTE [InBlock],1
        JMP     AssembleDone2
SegmentDef:
        MOV     CL,CH
        MOV     CH,SegmentID
        MOV     AL,0
        CALL    GetSegAddr

        TEST	CX,CX
        JZ		SegmentInit
        
        MOV     SI,OFFSET OWordNum-4
        MOV     BYTE [SI],0
        MOV     [SI][4],AX
        MOV     [SI][6],DX
        MOV     DI,WORD [SegBlockIDCrc]
        MOV     BP,WORD [SegBlockIDCrc][2]
        CALL    WriteSymbol
		JMP		SegmentInit

sp4Code:
        CALL    CodeSegment
spCheckError:
        JC      spError
        JMP     SegmentDirecGetArgs
spError:
        JMP     InvalidOperand

sp4Data:
        CALL    DataSegment
        JMP     spCheckError

sp4Auto:
        CALL    AutoSegment
        JMP     spCheckError

sp4IOPL:
        CALL    IOPLSegment
        JMP     spCheckError

sp7Movable:
        CALL    MovableSegment
        JMP     SegmentDirecGetArgs

sp7Preload:
        CALL    PreloadSegment
        JMP     SegmentDirecGetArgs

SegmentAT:
        JMP SegmentAT2

SegmentParam4:
        MOV     DI,(Extra4)
        CALL    SearchStr
        CMP     AX,4
        JZ      sp4Code
        CMP     AX,5
        JZ      sp4Data
        CMP     AX,9
        JZ      sp4Auto
        CMP     AX,10
        JZ      sp4IOPL
        JMP     InvalidOperand

SegmentParam7:
        MOV     DI,(Extra7)
        CALL    SearchStr
        CMP     AX,1
        JZ      sp7Movable
        CMP     AX,2
        JZ      sp7Preload
        JMP     InvalidOperand

SegmentParam2:
        MOV     AX,[StrBuffer]
        OR      AX,2020h
        CMP     AX,"ta"
        JZ      SegmentAT
        JMP     InvalidOperand

SegmentGetParam:
        MOV     SI,(StrBuffer)
        MOV     AX,[StrLen]
        CMP     AX,2
        JZ      SegmentParam2
        MOV     CX,AX
        CMP     AX,4
        JZ      SegmentParam4
        CMP     AX,7
        JZ      SegmentParam7
        CMP     AX,8
        JZ      SegmentParam8
        CMP     AX,9
        JZ      SegmentParam9
        CMP     AX,10
        JZ      SegmentParam10
        CMP     AX,11
        JZ      SegmentParam11
        JMP     InvalidOperand
SegmentParam8:
        MOV     DI,(Extra8)
        CALL    SearchStr
        CMP     AX,1
        JZ      sp8Resource
        CMP     AX,2
        JZ      sp8Readable
        JMP     InvalidOperand

SegmentParam9:
        MOV     DI,(Extra9)
        CALL    SearchStr
        CMP     AX,1
        JZ      sp9Writable
        CMP     AX,2
        JZ      sp9Shareable
        JMP     InvalidOperand

SegmentParam10:
        MOV     DI,(Extra10)
        CALL    SearchStr
        CMP     AX,1
        JZ      sp10Executable
        CMP     AX,2
        JZ      sp10Conforming
        JMP     InvalidOperand

SegmentParam11:
        MOV     DI,(Extra11)
        CALL    SearchStr
        CMP     AX,1
        JZ      sp11Discardable
        CMP     AX,2
        JZ      sp11NotPaged
        JMP     InvalidOperand

sp8Readable:
        CALL    ReadableSegment
        JMP     spCheckError

sp8Resource:
        CALL    ResourceSegment
        JMP     spCheckError

sp9Writable:
        CALL    WritableSegment
        JMP     spCheckError

sp9Shareable:
        CALL    ShareableSegment
        JMP     spCheckError

sp10Executable:
        CALL    ExecutableSegment
        JMP     spCheckError

sp10Conforming:
        CALL    ConformingSegment
        JMP     spCheckError

sp11Discardable:
        CALL    DiscardableSegment
        JMP     spCheckError

sp11NotPaged:
        CALL    NotPagedSegment
        JMP     spCheckError

SegmentAT2:
        CALL    GetNext
        CMP AH,Number
        JNZ SegmentATNumExpected
        OR  BYTE [RefFlags][1],8
        CALL    MarkInitORG
        JNC SegmentATDone
        MOV SI,OFFSET OWordNum
        MOV DI,OFFSET ProgIP
        MOVSW
        MOVSW
        MOVSW
        MOVSW
SegmentATDone:
        OR  BYTE [Temp4],2
        JMP SegmentDirecGetArgs

SegmentATNumExpected:
        JMP NumExpected

SegmentDirec	ENDP


XStructDirec:
        JMP     NotCoded
EndRepeatDirec:
        JMP     NotCoded
OptionError:
        JMP     InvalidOperand
OptionDirec:        
        MOV     WORD [StrLen],0
        MOV     BYTE [InstrPresent],0
        CALL    GetNext
        MOV     BX,DS
        MOV     ES,BX
        MOV     BX,WORD [StrLen]
        MOV     SI,OFFSET StrBuffer
        TEST    BX,BX
        JZ      OptionError
        TEST    BH,BH
        JNZ     OptionError
        MOV     CX,BX
        CMP     BL,3
        JZ      OptionLen3
        CMP     BL,4
        JZ      OptionLen4
        CMP     BL,5
        JZ      OptionLen5
        CMP     BL,6
        JZ      OptionLen6
        JMP     OptionError
OptionLen3:
        MOV     DI,OFFSET Extra3
        CALL    SearchStr
        TEST    AX,AX
        JZ      OptionError
        JMP     OptionLen3Found
OptionLen4:
        MOV     DI,OFFSET Extra4
        CALL    SearchStr
        TEST    AX,AX
        JZ      OptionError
        JMP     OptionLen4Found
OptionLen5:        
        MOV     DI,OFFSET Extra5
        CALL    SearchStr
        TEST    AX,AX
        JZ      OptionError
        JMP     OptionLen5Found
OptionLen6:
        MOV     DI,OFFSET Extra6
        CALL    SearchStr
        TEST    AX,AX
        JZ      OptionError
        JMP     OptionLen6Found
OptionLen3Found:        
        CMP     AL,1
        JZ      OptionOut
        CMP     AL,3
        JZ      OptionCls
        JMP     AssembleDone2
OptionOutInvalidFile:
        MOV     BYTE [Error],QuitError
        MOV     SI,OFFSET _FileNameExpected
        JMP     IncludeQuitError
OptionCls:
        CALL    ClearScreen
        JMP     AssembleDone2
OptionOut:        
        MOV     AL,BYTE [NextChar]
        SUB     AL,Colon
        CMP     AL,1
        ADC     WORD [InBufferPtr],0
        CALL    GetStrFile
        CMP     DI,OFFSET StrBuffer
        JZ      OptionOutInvalidFile
        PUSH    DI
        CALL    CloseOutFile
        POP     DI
        MOV     BX,WORD [OutHandle]
        TEST    BX,BX
        JNZ     OptionOutFileClosed
        CALL    FClose
OptionOutFileClosed:
        MOV     SI,OFFSET StrBuffer
        LEA     CX,[DI][-StrBuffer]
        MOV     WORD [OutFileLen],CX
        MOV     DI,OFFSET OutFile
        REP     MOVSB
        MOV     BYTE [DI],CL
        MOV     BX,CX
        XCHG    BX,WORD [OutHandle]
        TEST    BX,BX
        JZ      OptionOpenOutFile
        CALL    FClose
OptionOpenOutFile:
        MOV     SI,OFFSET ProgIP
        MOV     DI,OFFSET EADisp
        MOVSW
        MOVSW
        MOVSW
        MOVSW
        OR  BYTE [RefFlags][1],32
        CALL    InitOutFile
        MOV     SI,OFFSET EADisp
        MOV     DI,OFFSET ProgIP
        MOVSW
        MOVSW
        MOVSW
        MOVSW
OptionOutFileDone:
        JMP     AssembleFile
OptionLen4Found:
        CMP     AL,3
        JZ      OptionStub
        JMP     AssembleDone2
OptionStub:
        MOV     AL,BYTE [OutFormat]
        CMP     AL,OutNE16
        JZ      OptionStubOK
        CMP     AL,OutPE32
        JZ      OptionStubOK
        CMP     AL,OutPE64
        JZ      OptionStubOK
OptionStubErr:
        JMP     InvalidKeyword
OptionStubOK:
        XOR     AX,AX
        CMP     WORD [FileSize],AX
        JNZ     OptionStubErr
        CMP     WORD [FileSize][2],AX
        JNZ     OptionStubErr
        MOV     AX,WORD [DiskOutStart]
        ADD     AX,DefStubSize
        CMP     AX,WORD [OBufferPtr]
        JA      OptionStubErr
        CALL    LoadStubFile
        JMP     AssembleDone2
OptionLen5Found:
        CMP     AL,1
        JZ      OptionReset
        CMP     AL,2
        JZ      OptionBegin
        JMP     AssembleDone2

OptionReset:
        CALL    ResetAllData
        JMP     AssembleDone2

OptionBegin:
        CALL    MarkInitPos
        JMP     AssembleDone2

OptionLen6Found:
        CMP     AL,1
        JZ      OptionInsane
        JMP     AssembleDone2
OptionInsaneError:
        JMP     InvalidOperand
OptionInsane:
        CALL    GetOperand
        CMP     AH,Number
        JZ      OptionInsaneNumber
        CMP     AL,EndOfLine
        JNZ     OptionInsaneError
        OR      BYTE [AsmFlags],1
        JMP     AssembleDone2
OptionInsaneNumber:
        CMP     AL,Num32
        JA      OptionInsaneNumTooBig
        MOV     CX,WORD [OWordNum][2]
        AND     WORD [AsmFlags],CX
        OR      WORD [AsmFlags],DX
        TEST    BYTE [AsmFlags][1],2
        JNZ     OptionInsaneAlwaysExtended
        JMP     AssembleDone2
OptionInsaneAlwaysExtended:
        MOV     BYTE [ExtMask],SYM_EXT
        JMP     AssembleDone2
OptionInsaneNumTooBig:
        JMP     NumTooBig
OptionStubInvalidFile:
        JMP     OptionOutInvalidFile


LabelSizeExp:
        JMP InvalidOperandSize
LabelDupDef:
        JMP DupDef
LabelDirec:
        PUSH    WORD [SymSeg]
        PUSH    WORD [SymPos]
        PUSH    CX,SI
        CALL    GetNext
        MOV BL,LabelID
        POP     SI,CX
        POP     WORD [SymPos]
        POP     WORD [SymSeg]
        CMP AL,EndOfLine
        JZ  LabelOpOK
        CMP AL,Keyword
        JNZ LabelSizeExp
        CMP DL,DataType
        JNZ LabelSizeExp
        MOV BL,DH
        DEC BL
LabelOpOK:
        TEST    SI,SYM_UNDEF
        JNZ LabelOpDefOK
        TEST    BYTE [RefFlags],8
        JNZ LabelOpDefOK
        CMP CL,UnknownID
        JNZ LabelDupDef
        JMP LabelWrite
LabelOpDefOK:
        LES DI,[SymPos]
        AND BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        TEST    BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        JZ  LabelOverwrite
        MOV SI,OFFSET StrBuffer+256
        PUSH    CX,BX
        PUSH    DS
        POP ES
        CALL    PublicDef
        POP BX,CX
        LES DI,[SymPos]
LabelOverwrite:
        CALL    OverwriteSymbolAddressChk
        JMP AssembleDone2
LabelWrite:
        MOV CL,CH
        MOV DI,[Temp1]
        MOV BP,[Temp2]
        MOV CH,BL
        MOV SI,OFFSET ProgIP-4
        MOV BYTE [SI],0
        CALL    WriteSymbol
        JMP AssembleDone2

ExportDirec:
        OR  BYTE [Settings][1],3
        XOR AX,AX
        MOV DI,OFFSET Temp1
        MOV CX,8
        REP STOSW
        MOV BYTE [InstrPresent],AL
        MOV AL,[OutFormat]
        CMP AL,OutNE16
        JZ  _ExportNE16
        CMP AL,OutPE32
        JZ  _ExportPE32
        CMP AL,OutPE64
        JZ  _ExportPE64
        JMP InvalidKeyword
        JMP AssembleDone2
_ExportNE16:
        JMP ExportNE16
_ExportPE32:
        JMP ExportPE32
_ExportPE64:
        JMP ExportPE64
		
ImportDirec:
        OR  BYTE [Settings][1],3
        XOR AX,AX
        MOV DI,OFFSET Temp1
        MOV CX,8
        REP STOSW
        MOV BYTE [InstrPresent],AL
        MOV AL,[OutFormat]
        CMP AL,OutNE16
        JZ  _ImportNE16
        CMP AL,OutPE32
        JZ  _ImportPE32
        CMP AL,OutPE64
        JZ  _ImportPE64
        JMP InvalidKeyword
 
 _ImportPE32:
        JMP ImportPE32

 _ImportPE64:
        JMP ImportPE64

 _ImportNE16:
        JMP ImportNE16

TypedefDirec        PROC
        CMP BYTE [Pass],1
        JA  TypeDefDone
        MOV BYTE [InstrPresent],0
        CALL    GetNext
        CMP     AL,Keyword
        JNZ     TypedefExpDataType
;        CMP     DL,DataType
;        JNZ     TypedefExpDataType
        PUSH    DX
        CALL    GetNext
        POP     DX
        CMP     AH,Identifier
        JNZ     TypeDefIDExp
        CMP     AL,UnknownID
        JNZ     TypeDefDupDef

        MOV     CL,BYTE [StrLen]
        MOV     CH,CustomID
        MOV     SI,OFFSET OWordNum

        PUSH    DI
        MOV DI,SI
        XOR AX,AX
        STOSW
        STOSW
        MOV AX,DX
        STOSW
        XOR AX,AX
        STOSW
        POP DI
        CALL    WriteSymbol
        JMP     AssembleDone2
TypeDefDone:
       JMP     AssembleDone3

TypedefExpDataType:
        MOV SI,(_ExpDataType)
        JMP PrtError

TypedefDupDef:
        MOV SI,(_DupDef)
        JMP PrtError

TypedefIDExp:
        MOV SI,(_IDExpected)
        JMP PrtError

TypedefDirec        ENDP

DirectiveMissingLabel:  ;If a directive expects an ID
        MOV     SI,OFFSET _MissingLabel
        JMP     PrtError

DirectivesNEnd: