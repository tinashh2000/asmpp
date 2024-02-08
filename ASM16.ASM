AssembleNewInstr:
        MOV     BYTE [InstrPresent],0
        SUB     WORD [LineNumber],1
        SBB     WORD [LineNumber][2],0
        JMP     AssembleFile
AssembleEndOfFile:        
        CMP     WORD [Pass],1
        JA      AssembleEndOfFile2
        MOV     AX,WORD [LineNumber]
        ADD     WORD [LinesCount],AX
        MOV     AX,WORD [LineNumber][2]
        ADC     WORD [LinesCount][2],AX
AssembleEndOfFile2:
        CMP     WORD [NumErrors],0
        JNZ     AssembleExit
        CMP     BYTE [EOLFlag],9Fh
        JZ      AssembleExit
        CALL    AssembleChangeInFile

        TEST    BYTE [InBlock],1
        JZ      AEOFSegOK
        CALL    CloseSegment
AEOFSegOK:
        MOV     BX,OFFSET OutFormat
        CMP     BYTE [BX],OutCOM
        JZ      AssembleEndOfFileExit
        CMP     BYTE [BX],OutBin
        JZ      AssembleEndOfFileExit
AssembleEndOfFileExit:
        CALL    EnterNewPass    
        CALL    CloseOutFile
        CLC
AssembleExit:
        RET
AssembleProgIPOverflow:
        MOV     AL,BYTE [AsmFlags]
        AND     AL,3
        CMP     AL,3
        JZ      AssembleDoneIPOK
        JMP     ProgIPOverflow

AssembleExtraChars:
        MOV     AL,BYTE [AsmFlags]
        AND     AL,81h
        CMP     AL,81h
        JZ      AssembleNewInstr
        JMP     ManyOperands

AssembleDone3:
        CALL    ResetAsmData
        CMP     BYTE [EOLFlag],EndOfLine
        JZ      AssembleDone4
        LDS     SI,DWORD [InBufferPtr]
        CALL    GetNextFindNextLine
AssembleDone4: 
        MOV     BYTE [Error],0
        JMP     AssembleFile
;        asdf
AssembleFileInit:
        MOV     CX,1000
        MOV     DS,[DiskInSeg]
        CALL    ReadInFile2
        MOV     AX,AsmData
        MOV     DS,AX
        JMP     AssembleFile

AssembleDone_CheckUninitData:
        CMP BX, 0
        JZ  AssembleDone_UninitOK

        MOV AX, BX
        MOV DX, 0
        CALL PrintInt

        MOV AL, 32
        CALL PrintChar

        MOV AX, [UninitData]
        MOV DX, [UninitData][2]
        CALL PrintHex

        XOR AX,AX
        MOV [UninitData], AX
        MOV [UninitData][2], AX

        MOV SI, (_UninitDataFound)
        JMP PrtError
AssembleDone:
        MOV     BX,DI
        SUB     BX,WORD [OBufferPtr]

;;;;Will comment out this section after proving that no instructions are injecting their code before flushing uninitialized data
;;;;This maybe a while
        MOV AX, 2
        CMP WORD [UninitData][0], 1
        SBB AL, AH
        CMP WORD [UninitData], 1
        SBB AL, AH
        JNZ AssembleDone_CheckUninitData
;;;;;End of section that will be commented out
AssembleDone_UninitOK:

        MOV     WORD [OBufferPtr],DI
        ADD     WORD [ProgIP],BX
        JC      AssUpdateEIP
AssembleDoneIPOK:
        CMP     DI,0FFC0h
        JBE     AssembleDone2
        JMP     AssembleWriteOutFile

AssUpdateRIP:
        CMP     BYTE [AddrMode],4
        JB      AssembleProgIPOverflow
        ADD     WORD [ProgIP][4],1
        ADC     WORD [ProgIP][6],0
        JC      AssembleProgIPOverflow
        JMP     AssembleDoneIPOK
AssUpdateEIP:
        CMP     BYTE [AddrMode],1
        JZ      AssembleProgIPOverflow
        ADD     WORD [ProgIP][2],1
        JC      AssUpdateRIP
        JMP     AssembleDoneIPOK

AssembleDone2:
        CALL    GetNext
        CMP     AL,EndOfLine
        JNZ     AssembleExtraChars
AssembleFile:
        MOV WORD [ExprStack],(ExprBuffer)
        
IFDEF   WIN16
GetWinMessage:
        CALL    PeekMessage,AsmData,OFFSET msgw,0,0,0,PM_REMOVE
        TEST    AX,AX
        JZ      WinMessageOK
        CALL    TranslateMessage,AsmData,OFFSET msgw
        CALL    DispatchMessage,AsmData,OFFSET msgw
        JMP GetWinMessage
WinMessageOK:
        CMP     BYTE [EOLFlag],09Fh
        JNZ     WinMessageEOLOK
        JMP AssembleEndOfFile
WinMessageEOLOK:
ENDIF

        XOR     AX,AX
        MOV     WORD [InstrPresent],AX
        MOV     WORD [Op1Type],AX
        MOV     WORD [Settings],AX
        MOV     WORD [RelocFlags],AX
        MOV     BYTE [OperandSize],AL
        MOV     WORD [REXDisp],AX
        MOV     WORD [REXOverride],AX
		
        INC     AL
        MOV     BYTE [Flushed],AL
        ADD     WORD [LineNumber],AX
        ADC     WORD [LineNumber][2],0
AssembleFile3:
        MOV     AX,WORD [InBufferPtr]
        MOV     WORD [LineStartPtr],AX
        CALL    GetNext
AssembleLineProcess:
        CMP     AL,CPUInstruction
        JNZ     AssembleGetType2
AssembleInstruction:
        MOV     BYTE [InstrPresent],1
        MOV     BYTE [SymOpSize],0
        MOV     BX,DX
        MOV     DX,WORD [BX]
        ADD     BX,2
        CMP     BYTE [CurSeg],1
        JNZ     AssembleInstrNoCodeSeg

AssembleInstruction_Invoke:
        JMP     DX
AssembleInstrNoCodeSeg:
        CMP     DX, (DirectivesStart)
        JB      AssembleInvalidInstr
        CMP DX, (DirectivesEnd)
        JA      AssembleInvalidInstr
        CMP     BYTE [CurSeg],0FEh
        JZ      AssembleInstrNoSeg
        JMP     DX

AssembleInstrNoSeg:
;        CMP     DX, (StrucDirective)
;        JB      AssembleInstrNoSeg2
        CMP [BX], 0xFAFB
        JZ AssembleInstruction_Invoke
        CMP [BX], 0xFAFD
        JZ AssembleInstruction_Invoke
;        JMP     DX
AssembleInstrNoSeg2:
        MOV     SI,OFFSET _NoDataSeg
        JMP     PrtError2

AssembleWriteUninitData:
        CMP     BYTE [CurSeg][3],1
        JNZ     AssembleInvalidInstr2
        PUSH    DX,BX
        MOV     DI,WORD [OBufferPtr]
        CALL    WriteUninitData
        POP     BX
        RET     ;Notice that we pushed 2 variables, 
                ;but popped 1. DX becomes TOS then we return, 
                ;effectively jumping to it

AssembleWriteOutFile:
        CALL    WriteOutFile
        JC      AssembleWriteOutError
        JMP     AssembleFile
AssembleWriteOutError:
        RET
AssembleInvalidInstr:
        CMP     BYTE [CurSeg],0FFh
        JZ      AssembleWriteUninitData
AssembleInvalidInstr2:
        MOV     SI,OFFSET _NoCodeSeg
        JMP     PrtError2
AssemblePeriod:
        JMP     AssemblePeriod2
AssembleGetType2:
        CMP     AL,Keyword
        JZ      AssembleKeyword
        CMP     AH,Identifier
        JZ      _AssembleID
        CMP     AL,Period
        JZ      AssemblePeriod
        CMP     BYTE [Msg],EndOfFile
        JZ      AssembleEOF
        CMP     AL,EndOfLine
        JZ      AssembleEOL
        CMP     AL,Hash
        JZ      AssembleLineInvk3
        JMP     AssembleLine2
AssembleEOF:
        JMP     AssembleEndOfFile
AssembleEOL:
        JMP     AssembleFile
AssembleLineInvk3:
        JMP     AssembleFile3
AssembleLineInvk2:
        JMP     AssembleDone3
_asmDataType:
        JMP     asmDataType
AssembleKeyword:
        CMP     DL,DataType
        JZ      _asmDataType
        CMP     DL,SegReg
        JZ      AssembleSegReg
        CMP     DL,SegReg386
        JZ      AssembleSegReg
        CMP     DX,1 SHL 8 OR Operator
        JZ      AssembleDefType
        JMP     InvalidKeyword
AssembleDefType:
        CALL    GetNext
        CMP AL,Keyword
        JNZ DefInvkInvalid
        CMP DL,DataType
        JNZ DefInvkInvalid
        DEC DH
        OR  DH,80h
        MOV [DefSymType],DH
        JMP     AssembleFile
DefInvkInvalid:        
        JMP OperandSizeRequired
_AssembleID:
        JMP AssembleID

AssembleSegReg:
        MOV     AL,BYTE [NextChar]
        SUB     AL,Colon    ;Must become zero IF colon
        CMP     AL,1        ;Compare it to one, IF its zero then CF=1
        ADC     WORD [InBufferPtr],0
        CMP     DL,SegReg386
        JZ      AssembleSegReg386
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        ADD     DH,26h
        MOV     BYTE [SegOverride],DH
        JMP     AssembleFile3
AssembleSegReg386:
        ADD     DH,64h
        MOV     BYTE [SegOverride],DH
        JMP     AssembleFile3


AssembleInstrError:
        JMP     ExpectedInstr

AssembleDupDef:
        JMP     DupDef

AssembleEndXX:

        CMP     BYTE [InBlock],0    ;If no open block
        JZ      AssembleEndXUnmatched

;        MOV DX, [BX][2]

        CMP     BX,OFFSET EndMDirective
        JZ  aEndM

        CMP     BX,OFFSET EndSDirective
        JZ  aEndS

        CMP     BX,(EndPDirective)
        JNZ AssembleInstrError
aEndP:
        MOV     SI,OFFSET ProcBlockIDCrc
        JMP     AssembleEndX2
aEndS:
        MOV     SI,OFFSET StructBlockIDCrc
        TEST    BYTE [InBlock],2
        JNZ     AssembleEndX2
        MOV     SI,OFFSET SegBlockIDCrc
        TEST    BYTE [InBlock],1
        JNZ     AssembleEndX2
        JMP     AssembleEndXUnmatched
aEndM:
        MOV     SI,OFFSET MacroBlockIDCrc
AssembleEndX2:
        MOV     DI,OFFSET Temp1
        MOV     CX,2
        REPZ    CMPSW
        JNZ     AssembleEndXUnmatched
        JMP     WORD [BX]
AssembleEndXUnmatched:
        JMP     UnmatchedEnd


AssembleUnmatchedEnd:
        MOV     SI,OFFSET _UnmatchedEnd
        JMP     PrtError

AssembleIDNotFound:
        JMP     IDNotFound

AssembleLine2:
        CMP     AL,OpenSqBracket
        JZ      AssembleOpenSq
AssembleLine2Error:
        JMP     ExpectedInstr
AssembleOpenSq:
        MOV     BYTE [StrLen],0
        CALL    GetNext
        MOV     AL,BYTE [StrLen]
        CMP     AL,3
        JZ      AssembleOpenSq3
        CMP     AL,4
        JZ      AssembleOpenSq4
        JMP     ExpectedInstr
AssembleMissingCloseSq:
        JMP     MissingCloseSq
AssembleBITSNumExpected:
        JMP     NumExpected
AssembleBITSNumTooBig:
        JMP     NumTooBig
AssembleOpenSq4:
        CMP     WORD [StrBuffer],"ib"
        JNZ     AssembleLine2Error
        CMP     WORD [StrBuffer][2],"st"
        JNZ     AssembleLine2Error
        MOV     BYTE [InstrPresent],1
        CALL    GetNext
        CMP     AH,Number
        JNZ     AssembleBITSNumExpected
        CMP     BYTE [NextChar],CloseSqBracket
        JNZ     AssembleMissingCloseSq
        INC     WORD [InBufferPtr]
        CMP     AL,Num8
        JNZ     AssembleBITSNumTooBig
        CMP     DL,16
        JZ      AssembleBITS16
        CMP     DL,32
        JZ      AssembleBITS32
        CMP     DL,64
        JNZ     AssembleLine2Error
        JMP     Use64Direc
AssembleOpenSq3:
        CMP     WORD [StrBuffer],"ro"
        JNZ     AssembleLine2Error
        CMP     BYTE [StrBuffer][2],"g"
        JNZ     AssembleLine2Error
        MOV     BYTE [InstrPresent],1
        CALL    GetNext
        CMP     AH,Number
        JNZ     AssembleBITSNumExpected
        CMP     BYTE [NextChar],CloseSqBracket
        JNZ     AssembleMissingCloseSq
        INC     WORD [InBufferPtr]
        JMP     OrgDirec2
AssembleBITS32:
        JMP     Use32Direc
AssembleBITS16:
        JMP     Use16Direc

AssemblePeriod2:
        MOV     WORD [StrLen],0
        CALL    GetNext
        CMP     AH,Number
        JZ      AssembleCPUSpecs
        CMP     AL,Keyword
        JZ      InvkAssembleKeyword
        CMP     AL,CPUInstruction
        JZ      InvkAssembleInstr
        MOV     AX,WORD [StrLen]
        CMP     AH,0
        JNZ     InvkAssembleInstr
        PUSH    DS
        POP ES
        MOV SI,OFFSET StrBuffer
        MOV DI,OFFSET StrBuffer
        MOV CL,AL
        MOV CH,0
        CALL    LCaseStr
        MOV     AL,BYTE [StrLen]
        CMP     AL,4
        JZ      AssemblePeriodLen4
        CMP     AL,5
        JZ      _AssemblePeriodLen5
AssemblePeriodFail:
        JMP     AssembleDone3
InvkAssembleInstr:
        JMP     AssembleInstruction
_AssemblePeriodLen5:
        JMP     AssemblePeriodLen5
InvkAssembleKeyword:
        JMP     AssembleKeyword
AssembleCPUSpecs:
        JMP     AsmCPUSpecs

AssemblePeriodLen4:
        MOV     SI,OFFSET StrBuffer
        MOV     DI,OFFSET Extra4
        MOV     CX,4
        CALL    SearchStr
        TEST    AX,AX
        JZ      InvkAssembleNextLine
        CMP     AL,4
        JZ      AssembleCodeSeg
        CMP     AL,5
        JZ      AssembleDataSeg
        CMP     AL,6
        JZ      AssembleHeap
        CMP     AL,13
        JZ      AssembleLang
InvkAssembleNextLine:
        JMP     AssembleDone3

AssembleHeap:
        JMP     HeapDirec
        
AssembleLang:
    CALL    GetNext
    JMP     AssembleLang2

AssembleCodeSeg:
    MOV [Temp1], 0
    MOV [Temp2],0
    XOR CX,CX
    CALL    SegmentDirec
    JMP		AssembleDone2

    MOV     SI,(StrBuffer-1)
    MOV     BYTE [SI],"."
    MOV     CX,5
    CALL    SegmentDirecNoLabel
    JMP     AssembleDone2

    MOV     BYTE [CurSeg],SEGMENT_CODE

    CALL    SegmentAlign
    MOV     SI,(StrBuffer-1)
    MOV     BYTE [SI],"."
    MOV     CX,5
    CALL    FormatSegClass
    CALL    CodeSegment
    CALL    ReadableSegment
    CALL    ExecutableSegment
    JMP     AssembleDone2

AssembleIDataSeg:
AssembleUDataSeg:
AssembleDataSeg:
        MOV     BYTE [CurSeg],SEGMENT_DATA
        CALL    SegmentAlign
        MOV     SI,(StrBuffer-1)
        MOV     BYTE [SI],"."
        MOV     CX,5
        CALL    FormatSegClass
        CALL    DataSegment
        CALL    ReadableSegment
        CALL    WritableSegment
AssembleDataSegDone:
        JMP     AssembleDone2

AssemblePeriodLen5:
        MOV     SI,StrBuffer
        MOV     DI,OFFSET Extra5
        MOV CX,5
        CALL    SearchStr
        CMP     AX,3
        JZ  AssembleModel
        CMP     AX,4
        JZ  AssembleStack
        CMP     AX,5
        JZ  AssembleIDataSeg
        CMP     AX,6
        JZ  AssembleUDataSeg
        JMP AssembleDone3

AssembleStack:
        JMP StackDirec

AssembleModel:
        MOV WORD [StrLen],0
        CALL    GetNext
        CMP     AL,EndOfLine
        JZ  AssembleDataSegDone
        CALL    GetNext
        CMP AL,EndOfLine
        JZ  AssembleDataSegDone
AssembleLang2:
        CMP BYTE [StrLen],1
        JZ  AssembleModelLen1
        CMP AL,CPUInstruction
        JZ  AssembleModelInstr
        CMP AL,Keyword
        JNZ AssembleDataSegDone
        CMP DL,Lang
        JNZ AssembleDataSegDone
        CMP DH,1
        JZ  AssembleLangBasic
        CMP DH,2
        JZ  AssembleLangC
AssembleLangStdCall:
        AND BYTE [ProcFlags][1],0C0h
        OR  BYTE [ProcFlags][1],2
        JMP AssembleDone2
AssembleModelInstr:
        CMP DX,OFFSET SysCallInstr
        JZ  AssembleLangC
        JMP AssembleDone3
AssembleLangBasic:
        AND BYTE [ProcFlags][1],0C0h
        JMP AssembleDone2
AssembleModelLen1:
        MOV AL,BYTE [StrBuffer]
        CMP AL,"C"
        JZ  AssembleLangC
        CMP AL,"c"
        JZ  AssembleLangC
        JMP AssembleDone2
AssembleLangC:
        AND BYTE [ProcFlags][1],0C0h
        OR  BYTE [ProcFlags][1],3
        JMP AssembleDone2
AssembleIDStruct2:
        LES     AX,DWORD [SymPos]
        MOV     WORD [Temp3],AX
        MOV     WORD [Temp4],ES
        TEST    SI,SYM_UNDEF
        JNZ     AssembleIDStructExists
        CMP     CL,UnknownID
        JZ      AssembleDefStruc
        TEST    BYTE [RefFlags],8
        JNZ     AssembleIDStructExists
        JMP     DupDef
AssembleIDStructExists:
        MOV     AX,WORD [Temp1]
        MOV     DX,WORD [Temp2]
        MOV     BYTE [StrLen],CH
        PUSH    CX
        CALL    FindSymbol
        POP     CX
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        TEST    BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        JZ  AssembleIDStructOverwrite
        PUSH    DS
        POP ES
        MOV     SI,OFFSET StrBuffer-2
        MOV     AX,WORD [StrLen]
        MOV     [SI],AX
        CALL    PublicDef
        LES     DI,DWORD [SymPos]
AssembleIDStructOverwrite:
        CALL    OverwriteSymbolAddressChk
        JMP     AssembleDefStruc2
AssembleDefStruc:
        MOV     CL,CH
        MOV     CH,LabelID
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]
        MOV     SI,OFFSET ProgIP-4
        MOV     BYTE [SI],0
        CALL    WriteSymbol
AssembleDefStruc2:
        CALL    GetNext
        LES     SI,DWORD [Temp3]
        CMP     AL,LTOp
        JNZ     AssembleDefStrucNoInit
        MOV     BP,WORD ES:[SI].seIDData
        MOV     WORD [Temp1],BP
        CALL    GetNextCharI
        JMP     AssembleDone2
AssembleDefStrucNoInit:
        CMP     AL,EndOfLine
        JNZ     AssembleDefStructManyOp
        MOV     CX,WORD ES:[SI].seIDData
        XOR BX,BX
        MOV     DL,0
        MOV     DI,WORD [OBufferPtr]
        CALL    WriteMultiBytes
        JMP     AssembleDone
AssembleDefStructManyOp:
        JMP     ManyOperands

AsmCPUSpecs:
        CMP     AL,Num16
        JA      acsAssembleNextLine
        MOV     DI,OFFSET CPULabels
        MOV     AX,DX
        MOV     CX,14
        REPNZ   SCASW
        JNZ     acsAssembleNextLine
        SUB     CL,13
        NEG     CL
        MOV     BYTE [TargetCPU],CL
        MOV     AL,0
        CMP     CL,5
        JA      AssemblePutJmpSize
        MOV     AL,ShortJmp
AssemblePutJmpSize:
        MOV     BYTE [DefJmpSize],AL
acsAssembleNextLine:
        JMP     AssembleDone3


_AssembleDupDef:
        JMP     AssembleDupDef
AssembleDefineLabelOverwrite:
        TEST    BYTE [RefFlags],8
        JNZ     AssembleOverwriteLabel2
        TEST    CL,SYM_UNDEF
        JZ      _AssembleDupDef

AssembleOverwriteLabel2:
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        TEST    BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        JZ      AssembleOverwriteLabel
        PUSH    DS
        POP ES
        MOV     SI,OFFSET StrBuffer-2
        MOV     AX,WORD [StrLen]
        MOV     [SI],AX
        CALL    PublicDef
        LES     DI,DWORD [SymPos]
AssembleOverwriteLabel:
        CALL    OverwriteSymbolAddressChk
AssembleLabelDone:
        INC     WORD [InBufferPtr]
        MOV WORD [Settings],0
        JMP     AssembleFile3
AssembleLabelMismatch:
        CMP     BYTE [Pass],1
        JA      AssembleOverwriteLabel
        MOV     SI,OFFSET _RefMismatch
        MOV     BYTE [Error],128
        CALL    PrintError
        JMP     AssembleOverwriteLabel

AssembleDefineConst:
        INC     WORD [InBufferPtr]
        MOV     BYTE [InstrPresent],1
        POP     SI,CX
        JMP     EQDirec
AssembleDefineLabel:
        CMP     AL,UnknownID
        JNZ     AssembleDefineLabelOverwrite
        MOV     CL,BYTE [StrLen]
        MOV     CH,LabelID
        MOV     SI,OFFSET ProgIP-4
        CALL    WriteSymbol
        JMP     AssembleLabelDone

AssembleCustomID:
        CMP     AL,StructID
        JZ      AssembleIDStruct
        JMP     AssembleInstrError

AssembleIDStruct:
        JMP     AssembleIDStruct2


AssembleID:
        MOV     SI,WORD [InBufferPtr]
        MOV     WORD [LineStartPtr],SI
        MOV     BL,BYTE [NextChar]
        CMP     BL,Colon
        JZ      AssembleDefineLabel
        MOV     AH,BYTE [StrLen]
        PUSH    AX,CX
        MOV     WORD [Temp1],DI
        MOV     WORD [Temp2],BP
        CMP     BL,EQOp
        JZ      AssembleDefineConst
        MOV     SI,OFFSET StrBuffer
        MOV     CX,[StrLen]
        MOV     DI,OFFSET StrBuffer+258
        MOV     WORD [DI][-2],CX
        REP     MOVSB
        PUSH    WORD [SymPos], WORD [SymPos][2]
        CALL    GetNext
        POP     WORD [SymPos][2], WORD [SymPos]
        POP     SI,CX
        CMP     AH,Identifier
        JZ      AssembleCustomID
        CMP     AL,Keyword
        JZ      AssembleIDDataType
        CMP     AL,CPUInstruction
        JNZ     _AssembleInstrError
        MOV     BX,DX
        MOV DX, [BX]


        CMP     DX,OFFSET DirectivesStart
        JB      _AssembleInstrError
        CMP     DX,OFFSET DirectivesEnd
        JA     _AssembleInstrError

    ;;Here we only focus on directives that expect/allow an identifier just 
    ;;before the directive keyword, eg. PrtStr PROC, or PrtStr ENDP

        CMP WORD [BX][2], 0xFAFD    ;EndM, EndP, EndS etc have this signature on the secondary pointer
        JZ  _AssembleEndXX

        CMP WORD [BX][6], 0A0Fh
        JNZ _AssembleInstrError

;        CMP WORD [BX][8], 0E0Dh    ;We no longer use this for EndM, EndP, EndS, instead, FAFD is used 
;        JZ  _AssembleEndXX

        CMP WORD [BX][8], 0E0Ch
        JNZ _AssembleInstrError

AssembleCallDef:
        MOV     BYTE [InstrPresent],1
        JMP     WORD [BX][2]
 AssembleIDDataType:
        MOV DI,[Temp1]
        MOV BP,[Temp2]
        CMP DL,DataType
        JNZ _AssembleInstrError
        MOV DL,0FFh
        JMP asmDataType
_AssembleEndXX:
        JMP     AssembleEndXX

_AssembleInstrError:
        JMP     AssembleInstrError

asmDataType:
        XOR BX,BX
        CMP DL,0FFh
        CMC
        ADC BX,BX
        ADD BX,BX

        CMP DH,_BYTE
        JZ  asmDB
        CMP DH,_WORD
        JZ  asmDW
        CMP DH,_DWORD
        JZ  asmDD
        CMP DH,_FWORD
        JZ  asmDF
        CMP DH,_QWORD
        JZ  asmDQ
        CMP DH,_TWORD
        JZ  asmDT
        CMP DH,_OWORD
        JZ  asmDO
        JMP     InvalidKeyword
 asmDB:
        MOV DX,(DBDirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET
 asmDW:
        MOV DX,(DWDirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET
 asmDD:
        MOV DX,(DDDirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET
 asmDF:
        MOV DX,(DFDirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET
 asmDQ:
        MOV DX,(DQDirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET
 asmDT:
        MOV DX,(DTDirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET
 asmDO:
        MOV DX,(DODirective)
        ADD BX,DX
        MOV     BYTE [InstrPresent],1
        PUSH    WORD [BX]
        MOV BX,DX
        RET

NoOperand:
        LES     DI,[OBufferPtr]
        XOR     AL,AL
        XCHG    AL,BYTE [SegOverride]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     AL,BYTE [BX]
        STOSB
        JMP     AssembleDone
NoOpW:
        LES     DI,[OBufferPtr]
        XOR     AL,AL
        XCHG    AL,BYTE [SegOverride]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     AX,WORD [BX]
        STOSW
        JMP     AssembleDone
NoOperand16:
        LES     DI,[OBufferPtr]
        XOR     AL,AL
        XCHG    AL,BYTE [SegOverride]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,BYTE [BX]
        STOSB
        JMP     AssembleDone
NoOperand32:
        LES     DI,[OBufferPtr]
        XOR     AL,AL
        XCHG    AL,BYTE [SegOverride]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,BYTE [BX]
        STOSB
        JMP     AssembleDone
NoOperand64:
        CMP     BYTE [AddrMode],4
        JB      NoOperand64Error
        LES     DI,[OBufferPtr]
        XOR     AL,AL
        XCHG    AL,BYTE [SegOverride]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     AL,48h
        MOV     AH,BYTE [BX]
        STOSW
        JMP     AssembleDone
NoOperand64Error:
        JMP     InvalidAddrMode
NoOpf:
        LES     DI,[OBufferPtr]
        MOV     SI,BX
        MOVSW
        MOVSB
        JMP     AssembleDone

INCLUDE "NSTRCTNS\BITINST.ASM"        
INCLUDE "NSTRCTNS\CONDJMP.ASM"     
INCLUDE "NSTRCTNS\BASICINS.ASM"
INCLUDE "NSTRCTNS\CALLINST.ASM"
INCLUDE "NSTRCTNS\JMPINSTR.ASM"
INCLUDE "NSTRCTNS\INCDEC.ASM"
INCLUDE "NSTRCTNS\MOVINSTR.ASM"
INCLUDE "NSTRCTNS\SHIFTINS.ASM"
INCLUDE "NSTRCTNS\TEST.ASM"
INCLUDE "NSTRCTNS\PMINSTR.ASM"
INCLUDE "NSTRCTNS\MOVXX.ASM"
INCLUDE "NSTRCTNS\MMXSSE.ASM"
INCLUDE "NSTRCTNS\INSOUTS.ASM"
INCLUDE "NSTRCTNS\STROPS.ASM"
INCLUDE "NSTRCTNS\SHXD.ASM"
INCLUDE "NSTRCTNS\IMUL.ASM"
INCLUDE "NSTRCTNS\FPU.ASM"
INCLUDE "NSTRCTNS\SSECMP.ASM"
INCLUDE "NSTRCTNS\SIMDMIX.ASM"
INCLUDE "NSTRCTNS\SNGLOP.ASM"
INCLUDE "NSTRCTNS\PUSHPOP.ASM"
INCLUDE "NSTRCTNS\PORTINS.ASM"
INCLUDE "NSTRCTNS\OTHER.ASM"

INCLUDE "NSTRCTNS\SSEAVX\SSER_RM.ASM"
INCLUDE "NSTRCTNS\SSEAVX\SSERRMI.ASM"
INCLUDE "NSTRCTNS\SSEAVX\MMXEXTRA.ASM"
INCLUDE "NSTRCTNS\SSEAVX\MMXSSERM.ASM"
INCLUDE "NSTRCTNS\SSEAVX\PENDING.ASM"
INCLUDE "NSTRCTNS\SSEAVX\AVXKRRM.ASM"

