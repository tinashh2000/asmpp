GetNextHash2:
    MOV DX,ES:[RepeatCount]
    MOV DI,OFFSET OWordNum
    MOV AX,DX
    STOSW
    XOR AX,AX
    STOSW
    STOSW
    STOSW
    MOV    AX,Number SHL 8 OR Num8
    MOV    BX,AsmData
    MOV    DS,BX
    MOV    WORD [InBufferPtr],SI
    RET

GetNextFindNextLinee:
    ADD     WORD ES:[LineNumber],1
    ADC     WORD ES:[LineNumber][2],0    
GetNextFindNextLine:
    MOV    BYTE ES:[EOLFlag],0
GetNextFindNextLineLoop:
    LODSB
    CMP     AL,0Ah
    JZ      GetNextFindNextLineDone
;    CMP     AL,"\"
;    JZ      GetNextFindNextLineSlash
    TEST    AL,AL
    JNZ     GetNextFindNextLineLoop
    CALL    ReadInFile
    TEST    AX,AX
    JNZ GetNextFindNextLineLoop    
    MOV BYTE ES:[Msg],EndOfFile
    JMP GetNextEOL
GetNextFindNextLineDone:
    TEST    BYTE ES:[EOLFlag],1
    JNZ     GetNextFindNextLinee
    JMP     GetNextEOL
GetNextFindNextLineSlash:
    TEST    BYTE ES:[EOLFlag],2
    JNZ     GetNextFindNextLineLoop
    OR      BYTE ES:[EOLFlag],1
    JMP     GetNextFindNextLineLoop
GetNextQuoteBufferEmpty:
    PUSH    CX,DX
    CALL    ReadInFile
    POP     DX,CX
    TEST    AX,AX
    JNZ     GetNextQuoteLoop
    MOV     BYTE ES:[Msg],EndOfFile
    JMP     GetNextMissingEndQuote

GetNextQuoteDone:
    CALL    GetNextChar
    LEA    DX,[DI][-StrBuffer]
    MOV    AX,Quote
    CALL    TranslateQuote
    CMP    AH,Number
    JNZ    GetNextQuoteDone2
    RET
GetNextQuoteDone2:    
    MOV    BP,SP
    CMP    WORD [BP],OFFSET GetOperand2
    JZ     GetNextQuoteDone3
    RET
GetNextQuoteDone3:
    MOV    BX,DX
    MOV    DX,20 SHL 8 OR Operator
    MOV    AX,Keyword
    RET

GetNextMissingEndQuote:
    JMP    GetNextMissingEndQuote2

GetNextReadFile:
    CALL    ReadInFile
    TEST    AX,AX
    JNZ    GetNextCharsInit
    MOV    BYTE ES:[Msg],EndOfFile
GetNextEOL:
    MOV AX,AsmData
    MOV DS,AX
    MOV    WORD [InBufferPtr],SI
GetNextEOL2:
    MOV    AX,EndOfLine
    MOV    BYTE [EOLFlag],AL
GetNextQuit:
    RET
GetNextQuote:
    MOV    DL,BYTE [SI][-1]
GetNextQuoteInit:
    MOV    DI,OFFSET StrBuffer
GetNextQuoteLoop:    
    LODSB
    CMP    AL,DL
    JZ     GetNextQuoteDone
    TEST    AL,AL
    JZ     GetNextQuoteBufferEmpty
    CMP    AL,0Ah
    JZ     GetNextMissingEndQuote
    STOSB
    CMP    DI,OFFSET StrBuffer+2048
    JB     GetNextQuoteLoop
    JMP    GetNextAlphaTooLong
GetNextComma:
    MOV    BYTE ES:[CommaFlag],80h
    AND    BYTE ES:[Settings],3Fh
    JMP    SHORT GetNextChars
EVEN 2
GetNext:
    PUSH    DS
    POP ES
    CMP    BYTE [EOLFlag],0
    JNZ    GetNextEOL2
GetNextInit:

    LDS    SI,[InBufferPtr]
	
GetNextCharsInit:
    MOV    BX,OFFSET CharDesc
    MOV    AH,0
GetNextChars:    
    LODSB
    ES:
    XLAT
    CMP    AL,SpaceChar
    JZ     GetNextChars
    CMP    AL,Alpha
    JZ     GetNextAlpha
    CMP    AL,Comma
    JZ     GetNextComma
    CMP    AL,Char0A
    JZ     GetNextEOL
    CMP    AL,Quote
    JZ     GetNextQuote
    CMP     AL,Hash
    JZ      GetNextHash
    TEST    AL,AL
    JZ     GetNextReadFile
    CMP    AL,SemiColon
    JZ     GetNextSemiColon
    CMP    AL,Slash
    JZ     GetNextNewLine
    MOV    BX,AsmData
    MOV    DS,BX
    MOV    WORD [InBufferPtr],SI
    RET
GetNextHash:
    JMP     GetNextHash2
GetNextNewLine:
    CALL    GetNextFindNextLine
    MOV    BYTE [EOLFlag],0
    JMP    GetNextInit
GetNextSemiColon:
    OR     BYTE ES:[EOLFlag],2
    JMP    GetNextFindNextLineLoop
GetNextAlphaBelowA:
    MOV    AH,0
    MOV    AL,BYTE [SI]
    MOV    BX,AX
    CMP    BYTE ES:[BX][NumberTable],0F0h
    JZ     GetNextAlpha2
    XOR    DX,DX
    JMP    GetNumber
GetNextAlpha:    
    MOV    DI,OFFSET StrBuffer
    DEC    SI
    CMP    BYTE [SI],65
    JB     GetNextAlphaBelowA
GetNextAlpha2:
    MOV    CX,-1   ;Make CX=0
    MOV    DX,CX   ;DX=CX=0xFFFF
GetNextAlphaInit:
    XOR    AH,AH
GetNextAlphaLoop:    
    LODSB
    MOV    BX,AX
    CMP    BYTE ES:[BX][CharDesc],Alpha
    JNZ    GetNextAlphaProcessInit
    MOV    BL,BYTE ES:[BX][LCaseTable]
    MOV    BH,AH
    STOSB
    
    XOR    BL,CL
    ADD    BX,BX
    ADD    BX,BX
    
    MOV    CL,CH
    MOV    CH,DL
    MOV    DL,DH
    MOV    DH,AH
    XOR    CX,WORD ES:[BX][Crc32Buffer]
    XOR    DX,WORD ES:[BX][Crc32Buffer][2]
    CMP    DI,OFFSET StrBuffer+128
    JB     GetNextAlphaLoop
GetNextAlphaTooLong:
    MOV    BX,AsmData
    MOV    DS,BX
    MOV    WORD [InBufferPtr],SI
    MOV    SI,OFFSET _IDTooLong
    CALL    PrintError
GetNextExitError:
    LDS    SI,DWORD [InBufferPtr]
    CALL    GetNextFindNextLine
    MOV AX,AsmData
    MOV DS,AX
    MOV    SP,WORD [AsmStack]
    CMP    BYTE [Msg],EndOfFile
    JZ     GetNextExitEndOfFile
    MOV    BYTE [Error],0
    CALL    ResetAsmData
    JMP    AssembleFile
GetNextExitEndOfFile:
    MOV    AL,0
    JMP    AssembleEndOfFile
GetNextAlphaBufferEmpty:
    PUSH    CX,DX
    CALL    ReadInFile
    POP     DX,CX
    TEST    AX,AX
    JNZ     GetNextAlphaInit
    MOV     BX,AsmData
    MOV     DS,BX
    MOV     BYTE [Msg],EndOfFile
    MOV     BYTE [NextChar],EndOfLine
    JMP     SHORT GetNextAlphaProcess2
GetNextAlphaProcessInit:    
    JB     GetNextAlphaBufferEmpty
GetNextAlphaProcess:    
    DEC    SI
    CALL    GetNextChar
GetNextAlphaProcess2:
    SUB    DI,OFFSET StrBuffer

;    MOV     WORD [StrCrc32], CX
;    MOV     WORD [StrCrc32][2], DX

    MOV    WORD [StrLen],DI
    MOV    BL,BYTE [StrBuffer]
    MOV    BH,0
    MOV    BL,[BX][LCaseTable]
    MOV    SI,BX   ;AH is zero, i think should be BH ??
    CMP    BL,97
    MOV    BX,DI    
    JB     GetNextAlphaProcess3
;Remember CX has the lower CRC32
    MOV    AX,CX
    XOR    CX,CX
    DEC    DI        ;IF its above 'a' but is NOT a keyword
    JZ     SearchSymbol
    CMP    BX,16
    JA     SearchSymbol
	
    ADD    BX,BX	;Length. Multiply by 2 to get the 16-bit offset into kw_labels.	
    MOV    BP,WORD [BX][kw_labels]
	SUB		SI, 97	;97 to make a zero based index
	SHL		SI, 1	;Multiply by 2
    MOV    BX,WORD ES:[BP][SI]	;BP=kewyword start, SI = first letter
			;Since first lower case letter is 97, subtrct 98. 
			;BP points to keyword start + 1 - this 
			;contains byte sized indices into each letter
    MOV    CX,WORD ES:[BP][SI][2]	;End offset of letter
    MOV    SI,CX	;SI = end offset for this letter
    SUB    CX,BX	;CX = CX - BX (End offset - start offset). Now CX has the number of words to compare
    ADD    BX,BX	;BX *= 2. BX is the letter number to start from. *2 to add it to (16-bit) pointer
    ADD    BP,(27*2);Go past letter indices. 27 because the last 16bit values tells us where z ends
    LEA    DI,[BP][4]	;Also go past the 2 (16bit)pointers for keywordsHigh and KeywDesc 
    ADD    DI,BX	;Add the letter index to avoid searching letters before the one we found
SearchKeywordLoop:    
    REPNZ   SCASW	;Search in pointer DI for AX
    JNZ    SearchSymbol	;;If nothing is found
    LEA    BX,[SI][-1]	;Point BX to last letter.
    SUB    BX,CX	;BX - CX = the offset that was found
    ADD    BX,BX	;BX *= 2 to convert it to 16-bit offset
    ADD    BX,WORD ES:[BP]	;Add to keywordsHigh
    CMP    DX,WORD [BX]		;If DX is also the same CRC that we expect, then we found a keyword
    JNZ    SearchKeywordLoop	;If not
    SUB    SI,CX
    DEC    SI
    ADD    SI,SI
    ADD    SI,WORD ES:[BP][2]
    MOV    DX,WORD [SI]
    XOR    AH,AH
    MOV    AL,Keyword
    CMP    DX,OFFSET InstructionsStart
    JB     SearchKeywordDone
    CMP    DX,OFFSET InstructionsEnd
    JAE     SearchKeywordDone
    MOV    AL,CPUInstruction
SearchKeywordDone:
    RET

GetOperandRetAlpha:
    CMP    AL,UnknownID
    JNZ    GetOperandID4
    MOV    AX,Number SHL 8 OR Alpha
    RET

GetNextAlphaProcess3:
    JMP    GetNextAlphaProcess4

GetOperandEQDirec:
    CMP    DI,[Temp1]
    JNZ    GetOperandUnknownID3
    CMP    BP,[Temp2]
    JNZ    GetOperandUnknownID3
    JMP    GetOperandEQDirec2
GetOperandConst:
    JMP    GetOperandConst2

GetOperandCustomID:
    MOV AX,Keyword
;    MOV DH,DL
;    MOV DL,DataType
    RET

EVEN 2
SearchSymbol:
    CALL    FindSymbol
    CMP AX,(Identifier SHL 8) OR CustomID
    JZ      GetOperandCustomID
    CMP     BYTE [InstrPresent],0
    JZ      SearchSymbolDoneNoInstr
    MOV     DX,DS
    MOV     ES,DX

    MOV     AH,Number
    CMP     AL,UnknownID
    JZ      GetOperandUnknownID
    TEST    CL,SYM_UNDEF    ;Flags
    JNZ     GetOperandEnterRef
GetOperandID3:
    CMP     AL,StructID
    JAE     GetOperandConst
    TEST    CL,SYM_NEEDSRELOC | FMT_PUBLIC | FMT_EXTERN | SYM_STRUCT
    JNZ     GetOperandPublic
    CMP     AL,LabelID
    JAE     GetOperandID4
GetOperandMem:
    OR     BYTE [Settings],40h
    CMP    BYTE [SymOpSize],0
    JNZ    GetOperandID4
    INC    AX
    MOV    BYTE [SymOpSize],AL
GetOperandID4:
    MOV    AX,Number SHL 8 OR Num16    ;WORD [DefNumSize]
    MOV    DX,WORD [OWordNum]
SearchSymbolDone:
    RET


SearchSymbolDoneNoInstr:    
    PUSH    DS
    POP     ES
    TEST    BYTE [Settings][1],4
    JNZ     GetOperandRetAlpha
    RET

GetOperandUnknownID:    
    CMP    BYTE [OperandSize],0
    JNZ    GetOperandUnknownIDMemOP
    CMP    BYTE [Op1Type],Keyword
    JZ     GetOperandUnknownIDGetFirstReg
GetOperandUnknownID1:
    MOV    CH,[DefSymType]
GetOperandUnknownID2:
    MOV    SI,OFFSET Zeros
    CMP    BYTE [InstrPresent],2
    JZ     GetOperandEQDirec
GetOperandUnknownID3:
    MOV     BYTE [SI],SYM_UNDEF
    MOV     CL,BYTE [StrLen]
    CALL    WriteSymbol
    PUSH    DS
    POP     ES
    MOV     DI,OFFSET OWordNum
    XOR     AX,AX
    STOSW
    STOSW
    STOSW
    STOSW
    MOV     AL,CH
    MOV     CL,SYM_UNDEF
    JMP     SHORT GetOperandEnterRef2

GetOperandPublic:
    JMP     GetOperandPublic2

GetOperandEnterRef:
    CMP     AL,UnknownID
    JZ      GetOperandUnknownID
    TEST    BYTE [Settings][1],20h
    JNZ    GetOperandLocalSym
GetOperandEnterRef2:
    OR      BYTE [Settings],3
    TEST    BYTE [RefFlags],8
    JNZ     GetOperandIDNotFound
    OR      BYTE [RefFlags],16
GetOperandIDOK:
    CMP     BYTE [InstrPresent],3
    JNZ     GetOperandID33
    TEST    BYTE [EAMask],3
    JNZ     GetOperandID33
    MOV     BYTE [JmpSize],ShortJmp
GetOperandID33:
    JMP     GetOperandID3

GetOperandUnknownIDMemOP:
    TEST    BYTE [Settings],40h
    JZ      GetOperandUnknownID1
    MOV     CH,BYTE [OperandSize]
    DEC     CH
;    OR      CH,80h
    JMP     GetOperandUnknownID2
GetOperandUnknownIDGetFirstReg:
    MOV     BL,BYTE [Op1Data]
    TEST    BYTE [Process],2
    JNZ     GetOperandUnknownIDGetFirstReg3
    CMP     BL,Reg8
    JZ      GetOperandUnknownIDGetFirstReg3
    CMP     BL,LMLowReg
    JZ      GetOperandUnknownIDGetFirstReg3
    CMP     BL,LMReg8
    JZ      GetOperandUnknownIDGetFirstReg3
GetOperandUnknownIDGetFirstRegFail:
    JMP     GetOperandUnknownID1
GetOperandIDNotFound:
    JMP    GetOperandIDNotFound2
GetOperandLocalSym:
    JMP     GetOperandLocal

GetOperandGroupID:
    JMP GetOperandID4

GetOperandUnknownIDGetFirstReg3:
    MOV    SI,OFFSET OpTranslate
    MOV    BH,0
    MOV    CH,BYTE [BX][SI][-Reg8]
GetOperandUnknownIDGetFirstRegOK:
    JMP    GetOperandUnknownID2

GetOperandIDNotFound2:
    PUSH    AX
    MOV     SI,OFFSET _IDNotFound
    CALL    PrintError
    MOV     SI,OFFSET StrBuffer
    MOV     CX,WORD [StrLen]
    CALL    PrintStrFixed
    CALL    PrintLF
    POP AX
    JMP     GetOperandIDOK
GetOperandEQDirec2:
    TEST    BYTE [RefFlags],8
    JNZ     GetOperandIDNotFound
    OR      BYTE [Settings],3
    OR      BYTE [RefFlags],16
    PUSH    DS
    POP ES
    MOV     DI,OFFSET OWordNum
    XOR     AX,AX
    STOSW
    STOSW
    STOSW
    STOSW
    MOV    DX,AX
    MOV    AX,Number SHL 8 OR Num16
    RET

GetOperandStructID:
    JMP     GetOperandStructID2

GetOperandSegID:
    TEST    BYTE [Settings][1],40h
    JNZ gosidInvk
    MOV SI,OFFSET OWordNum
    MOV     BL,81h
    CALL    EnterReloc    
gosidInvk:
    JMP     GetOperandID4
    
GetOperandConst2:
    JZ      GetOperandStructID
    CMP     AL,SegmentID
    JZ      GetOperandSegID
    CMP     AL,GroupID
    JZ      GetOperandGroupID

    AND     BYTE [Settings],NOT 1
    MOV     AL,Num16
    MOV     DX,WORD [OWordNum]
    CMP     WORD [OWordNum][2],0
    JNZ     GetOperandConstSizeOK
    TEST    DH,DH
    JNZ     GetOperandConstSizeOK
    DEC     AX
GetOperandConstSizeOK:
    RET
GetNextQuestion2:
    CMP    BYTE [StrBuffer][1],"?"
    JNZ    GetNextAlphaInvk
    JMP    GetNextQuestion3
GetNextQuestion:    
    CMP    BX,1
    JA     GetNextQuestion2
    MOV    AX,Question
    RET

GetNextAlphaProcess4:
    CMP    SI,"?"
    JZ     GetNextQuestion
    CMP    SI,"$"
    MOV    AX,CX   ;CX has LOW WORD of crc
    JZ     GetNextProcessCurrency
GetNextAlphaInvk:
    JMP    SearchSymbol

GetNextProcessCurrency:
    CMP    BX,1
    JZ     GetNextLoadEIP
    JMP    GetNextLoadEIP2

GetNextLoadEIP:
    MOV    SI,OFFSET ProgIP
GetNextLoadEIP2:    
    MOV    DI,OFFSET OWordNum
    MOV    DX,WORD [SI]
    MOV    CX,4
    REP    MOVSW
    MOV    AX,Number SHL 8 OR Num16
    RET
GetOperandLocalEAOK2:
    MOV AL,BYTE [AddrMode]
    MOV BYTE [EARegType],AL
    MOV    AX,Number SHL 8 OR Num16
    RET
GetOperandLocalError:
    JMP    InvalidEAEntry

GetOperandLocalEAWrite:
    MOV BYTE [SI],5+1
GetOperandLocalEAOK:
    CMP BYTE [EARegType],0
    JZ  GetOperandLocalEAOK2
    MOV AL,BYTE [AddrMode]
    CMP AL,[EARegType]
    JNZ GetOperandLocalError
    MOV    AX,Number SHL 8 OR Num16
    RET

GetOperandLocalEA:
    MOV    WORD [OWordNum],AX
    MOV    DX,AX
    MOV    AX,[BaseReg]
    CMP    AL,5+1
    JZ     GetOperandLocalEAOK
    CMP    AH,5+1
    JZ     GetOperandLocalEAOK
    MOV    SI,OFFSET BaseReg
    TEST    AL,AL
    JZ     GetOperandLocalEAWrite
    INC    SI
    TEST    AH,AH
    JZ     GetOperandLocalEAWrite
    JMP    InvalidEAEntry

GetOperandLocal:
    MOV     SI,OFFSET OWordNum
    MOV     DI,OFFSET EADisp
    MOV     DL,AL
    AND     AL,0Fh
    MOV     BH,0
    MOV     AH,BH
    CMP     AL,LabelID
    JAE     GetOperandLocalSizeOK
    OR      BYTE [Settings],41h
    CMP     BYTE [SymOpSize],1
    SBB     AH,AH
    AND     AH,AL
    OR      BYTE [SymOpSize],AH
GetOperandLocalSizeOK:
    MOV     BL,AL
    LODSW
    TEST    DL,10h
    MOV     DX,[SI]
    JZ      GetOperandLocalStore
    TEST    BYTE [ProcFlags],2
    JNZ GetOperandLocalDispOK
    MOV BL,[BX][OpSizeTable][-1]
    MOV CX,[ProcArgSize]
    ADD AX,BX
    SUB CX,AX
    SBB DX,0
    MOV AX,CX
GetOperandLocalDispOK:
    ADD AL,[ProcDispSize]
    ADC AH,0
    ADC DX,0
GetOperandLocalStore:
    TEST    BYTE [Process],2
    JNZ    GetOperandLocalEA
    STOSW
    MOV AX,DX
    STOSW
    XOR AX,AX
    MOV CX,8
    REP STOSW
    OR  BYTE [Process],2
    MOV BYTE [BaseReg],5+1
    MOV AL,BYTE [AddrMode]
    MOV BYTE [EARegType],AL
    AND BYTE [Settings],NOT 3
    JMP ProcessEALoop


GetOperandStructEl:
    AND     BYTE [Settings],NOT 3
    MOV     CL,0
    JMP     GetOperandID3

GetOperandPublic2:
    TEST    CL,FMT_EXTERN
    JNZ     GetOperandExtern
    TEST    CL,SYM_STRUCT
    JNZ     GetOperandStructEl
    TEST    BYTE [Settings][1],40h
    JNZ gopInvk
    PUSH    AX
    MOV BL,1
    CALL    EnterReloc
    POP AX
gopInvk:
    MOV     CL,0
    JMP GetOperandID3

GetOperandExtern:
    MOV CL,0
    MOV     BL,21h
    CMP     AL,LabelID
    JAE     GetOperandExtern3
    OR      BYTE [Settings],43h
    MOV     AH,0
    INC     AX
    CMP     BYTE [OperandSize],1
    SBB     AH,AH
    AND     AH,AL
    OR      [OperandSize],AH
    DEC     AX
GetOperandExtern3:
    CMP     AL,LocalID
    JZ      GetOperandExtern5
    MOV     AH,0
    SUB     AL,SegmentID
    CMP     AL,1
    ADC     AH,AH
    ROR     AH,1
    OR      BL,AH
GetOperandExtern4:
    TEST    BYTE [Settings][1],40h
    JNZ goeInvk
    CALL    EnterReloc
goeInvk:
    MOV    AX,Number SHL 8 OR Num16
    XOR    DX,DX
    RET
GetOperandExtern5:
    OR     BL,10h
    MOV    BYTE [JmpSize],0FFh
    JMP    GetOperandExtern4
GetOperandStructID2:
    AND    BYTE [Settings],NOT 2
    XOR    AX,AX
    MOV    DI,OFFSET OWordNum
    MOV    DX,AX
    STOSW
    STOSW
    STOSW
    STOSW
    MOV    AX,Number SHL 8 OR Num16
    RET

GetNextQuestion3:
    PUSH    AX,DX
    MOV    SI,OFFSET StrBuffer+2
    MOV    DI,SI
    LEA    CX,[BX][-2]
    MOV DX,SI
    CALL    LCaseStr
    MOV SI,DX
    LEA    CX,[BX][-2]
    CMP    BX,5
    JZ     GetNextVar3
    CMP    BX,6
    JZ     GetNextVar4
    CMP    BX,7
    JZ     GetNextVar5
    CMP    BX,8
    JZ     GetNextVar6
GetNextVarsFail:
    POP    DX,AX
    JMP    SearchSymbol
GetNextVar3:
    MOV    DI,OFFSET Extra3
    CALL   SearchStr
    DEC    AX
    JZ     GetNextOutVar
    CMP    AL,4
    JZ     GetNextSrcVar
    JMP    GetNextVarsFail
GetNextVar4:
    MOV    DI,OFFSET Extra4
    CALL   SearchStr
    CMP    AL,11
    JZ     GetNextDateVar
    CMP    AL,12
    JZ     GetNextTimeVar
    JMP    GetNextVarsFail

GetNextSrcVar:
    MOV    SI,OFFSET CurFile
    MOV    DI,OFFSET StrBuffer
    MOV    CX,WORD [ThisFileLen]
    MOV    DX,CX
    MOV    AX,Quote
    REP    MOVSB
    ADD    SP,4
    JMP    GetNextQuoteDone2
GetNextVar5:
    MOV    DI,OFFSET Extra5
    CALL    SearchStr
    CMP     AL,7
    JZ      GetNextAPPVar
    CMP     AL,8
    JZ     GetNextFlagsVar
    CMP     AL,9
    JZ     GetNextOSizeVar
    JMP    GetNextVarsFail
GetNextVar6:
    MOV     DI,OFFSET Extra6
    CALL    SearchStr
    CMP     AL,6
    JZ      GetNextIFlagsVar
    CMP     AL,7
    JZ      GetNextOutPosVar
    CMP     AL,8
    JZ      GetNextFormatVar
    CMP     AL,9
    JZ      GetNextRFlagsVar
    JMP     GetNextVarsFail

GetNextOutVar:
    MOV    SI,OFFSET OutFile
    MOV    DI,OFFSET StrBuffer
    MOV    CX,WORD [OutFileLen]
    MOV    DX,CX
    MOV    AX,Quote
    REP    MOVSB
    ADD    SP,4
    JMP    GetNextQuoteDone2
GetNextDateVar:
    CALL    GetSysDate
    JMP    GetNextDateVar2

GetNextTimeVar:
    CALL    GetSysTime
    JMP    GetNextTimeVar2

GetNextAPPVar:
    MOV    DX,060Ch
GetNextWriteVarToNum:
    MOV    AX,DX
    MOV    DI,OFFSET OWordNum
    STOSW
    XOR    AX,AX
    STOSW
    STOSW
    STOSW
    MOV    AX,Number SHL 8 OR Num8
    ADD    SP,4
    RET
GetNextFlagsVar:
    MOV    DX,WORD [Settings]
    JMP    GetNextWriteVarToNum
GetNextOSizeVar:
    MOV    DX,WORD [DiskOutStart]
    JMP    GetNextWriteVarToNum
GetNextIFlagsVar:
    MOV    DX,WORD [AsmFlags]
    JMP    GetNextWriteVarToNum
GetNextOutPosVar:
    MOV    AX,WORD [OBufferPtr]
    SUB    AX,WORD [DiskOutStart]
    XOR    DX,DX
    ADD    AX,WORD [FileSize]
    ADC    DX,WORD [FileSize][2]

    ADD     AX,WORD [UninitData]
    ADC     DX,WORD [UninitData][2]

    MOV    DI,OFFSET OWordNum
    STOSW
    XCHG    AX,DX
    STOSW
    XOR    AX,AX
    STOSW
    STOSW
    MOV    AX,Number SHL 8 OR Num8
    ADD    SP,4
    RET
GetNextFormatVar:
    MOV    DL,BYTE [OutFormat]
    MOV    DH,0
    JMP    GetNextWriteVarToNum

GetNextRFlagsVar:
    MOV    DX,WORD [RefFlags]
    JMP    GetNextWriteVarToNum

GetNextDateVar2:
    MOV    DI,OFFSET StrBuffer
    MOV    AL,DL
    AAM
    XCHG    AL,AH
    ADD    AX,3030h
    STOSW
    MOV    AL,"-"
    STOSB
    MOV    AL,DH
    AAM
    XCHG    AL,AH
    ADD    AX,3030h
    STOSW
    MOV    AL,"-"
    STOSB

    MOV AX,CX
    XOR DX,DX
    PUSH        DI
    CALL        intToStr
    POP DI

    PUSH    DS
    MOV AX,AsmData
    MOV DS,AX
    MOV SI,(NumBuffer)
    REP MOVSB
    POP DS

    LEA    DX,[DI][-StrBuffer]
    MOV    AX,Quote
    ADD    SP,4
    JMP    GetNextQuoteDone2

GetNextTimeVar2:
  
    MOV    DI,OFFSET StrBuffer
    MOV    AL,CH
    AAM
    XCHG    AL,AH
    ADD    AX,3030h
    STOSW
    MOV    AL,":"
    STOSB
    MOV    AL,CL
    AAM
    XCHG    AL,AH
    ADD    AX,3030h
    STOSW
    MOV    AL,":"
    STOSB
    MOV    AL,DH
    AAM
    XCHG    AL,AH
    ADD    AX,3030h
    STOSW
    MOV    AL,":"
    STOSB
    MOV    AL,DL
    AAM
    XCHG    AL,AH
    ADD    AX,3030h
    STOSW
    LEA    DX,[DI][-StrBuffer]
    MOV    AX,Quote
    ADD    SP,4
    JMP    GetNextQuoteDone2

GetNumberBufferEmpty:
    PUSH    DX
    CALL    ReadInFile
    POP    DX
    TEST    AX,AX
    MOV    AH,0
    JNZ    GetNumberChk
    MOV    BYTE ES:[Msg],EndOfFile
    MOV    BX,32
    JMP    GetNumber3
GetNumberChk:
    CMP    DI,OFFSET StrBuffer
    JZ     GetNumber
    JMP    GetNumberLoop

EVEN 2
GetNumber:
    XOR AX,AX   ;Add padding. Calculating hex numbers is easier if they are aligned 
                ;so we need to leave the space for alignment
                ;These 0's have no impact on the final number
    STOSW
GetNumber_SkipLeadingZeroes:
    CMP    BYTE [SI],"0"
    JNZ    GetNumberLoop    
    INC SI
    JMP    GetNumber_SkipLeadingZeroes
GetNumberLoopCheck:
    CMP    DI,OFFSET StrBuffer+256
    JAE    GetNumTooBigInvk
GetNumberLoop:    
    LODSB
    MOV    BX,AX
    MOV    AL,BYTE ES:[BX][NumberTable]
    CMP    AL,15
    JA     GetNumber2
    STOSB
    CMP    AL,10
    JB     GetNumberLoopCheck
    MOV    DL,16
    INC    DH
    JMP    GetNumberLoopCheck
GetNumberMayBeHex:
    MOV    BX,DI
    SUB    BX,(StrBuffer + 2)    ;DI-1-StrBuffer must be zero
    JNZ    GetNumberError2
    MOV    DL,16
    INC    DH
    JMP    GetNumber_SkipLeadingZeroes
GetNumberError2:
    JMP    GetNumberError
GetNumTooBigInvk:
    JMP    GetNumTooBig
GetNumber2:
    INC    AL
    JZ     GetNumberBufferEmpty
    MOV    CL,BYTE [SI][-1]
    CMP    CL,"x"
    JZ     GetNumberMaybeHex
    CMP    CL,"_"
    JZ     GetNumberLoop
GetNumber3:
    MOV    AL, BYTE ES:[BX][CharDesc]
    MOV    CL,BYTE ES:[BX][LCaseTable]
    MOV    BX,DI
    MOV    WORD ES:[StrLen],DI
    SUB    DI, (StrBuffer + 2)
    CMP    AL,Alpha
    JNZ    GetNumberRadix
    CMP    DI,256
    JAE    GetNumTooBig
    PUSH   BP,BX
    CALL   GetNextChar
    MOV    BP,DI

    XOR    AX,AX
    MOV    DI,OFFSET OWordNum
    STOSW
    STOSW
    STOSW
    STOSW
    MOV    DI,BP
    POP    BX,BP
    LEA    SI,[BX-1]
    CMP    CL,"h"
    JZ     GetHexNumber
    CMP    CL,"d"
    JZ     GetDecNumber
    CMP    CL,"o"
    JZ     GetOctNumber
    CMP    CL,"b"
    JZ     GetBinNumber
    JMP    NumberError
GetNumberRadix:
    DEC    SI
    PUSH    BX
    CALL    GetNextChar
    MOV    BX,DI
    XOR    AX,AX
    MOV    DI,OFFSET OWordNum
    STOSW
    STOSW
    STOSW
    STOSW
    MOV    DI,BX
    POP    BX
    LEA    SI,[BX-1]
    CMP    BYTE [SI],9
    JA     GetNumberMayBeRadix
    CMP    DI,256
    JAE    GetNumTooBig
    TEST    DL,DL
    JNZ    GetHexNumber
    MOV    AL,BYTE [RadixValue]    
    CMP    AL,10
    JZ     GetDecNumber
    CMP    AL,16
    JZ     GetHexNumber
    CMP    AL,2
    JZ     GetBinNumber
    CMP    AL,8
    JZ     GetOctNumber
GetNumTooBig:
    JMP    NumTooLarge
GetOctNumber:
    TEST    DL,DL
    JNZ    GetNumberError
    TEST    DI,DI
    JZ     GetNumberLoadZero
    MOV    AX,(Number SHL 8) OR Num8
    XOR    DX,DX
    RET
GetHexNumber:
    TEST    DI,DI
    JZ     GetNumberLoadZero
    JMP    ConvHexNum
    RET

GetNumberError:
    JMP    NumberError

GetDecNumber:
    TEST    DL,DL
    JNZ    GetNumberError
    TEST    DI,DI
    JZ     GetNumberLoadZero    
    JMP    ConvDecNum
    RET

GetBinNumber:
    TEST    DL,DL
    JNZ    GetNumberError
    TEST    DI,DI
    JZ     GetNumberLoadZero
    CALL    ConvBinNum
    RET

GetNumberMayBeRadix:
    DEC    DH
    JNZ    GetHexNumber
    XOR    DL,DL
    DEC    DI
    MOV    AL,BYTE [SI]
    DEC    SI

    CMP    DI,256
    JAE    GetNumTooBig

    CMP    AL,0Bh
    JZ     GetBinNumber
    CMP    AL,0Dh
    JZ     GetDecNumber
    INC    DI
    INC    SI
    CMP    BYTE [RadixValue],16
    JZ     GetHexNumber
    JMP    NumberError

EVEN 2
GetNumberLoadZero:
    MOV    AX,(Number SHL 8) OR Num8
    XOR    DX,DX
    RET

NumTooLarge:
    MOV    AL,")"
    CALL    PrintChar
    MOV    SI,OFFSET _NumTooBig
    JMP    GetNextPrintError2

NumberError:
    MOV    SI,OFFSET _InvalidNum
GetNextPrintError2:
    CALL    PrintError
    JMP    GetNextExitError

GetNextMissingEndQuote2:
    MOV    SI,OFFSET _MissingEndQuote
    PUSH    DX
    CALL    PrintError
    POP    AX
    CALL    PrintChar
    MOV    AL,")"
    CALL    PrintChar
    CALL    PrintLF
    JMP    GetNextExitError

GetNextInvalidAddr:
    CMP    BYTE [InstrPresent],0
    JZ     GetNextRet2
    MOV    SI,OFFSET _InvalidAddrMode
    CALL    PrintError
    JMP    GetNextExitError

GetNextRet2:
    RET

ReadFileRemoveRepNest:
    MOV ES:[InBufferPtr],BX
    MOV SI,BX
    MOV DS,ES:[DiskInSeg]
    MOV AX,1
    JMP ReadInFile_Exit

ReadFileRemoveRep:
    DEC WORD ES:[RepeatNest]
    MOV ES:[NextTxtPos],SI
    MOV ES:[FreeTxtSeg],DS
    LODSW
    MOV ES:[MacroStart],AX
    LODSW
    MOV ES:[MacroStart][2],AX
    LODSW
    MOV ES:[RepeatCount],AX
    LODSB
    MOV ES:[MacroType],AL
    CMP WORD ES:[RepeatNest],0
    JA  ReadFileRemoveRepNest
    LDS SI,[SI]
    MOV ES:[InBufferPtr],SI
    MOV ES:[DiskInSeg],DS
    MOV AX,1
    JMP ReadInFile_Exit

ReadFileRepNest:
    LDS SI,[SI][7]
    MOV ES:[InBufferPtr],SI
    MOV ES:[DiskInSeg],DS
    MOV AX,1
    JMP ReadInFile_Exit

ReadFileRep:
    MOV BX,SI
    LDS    SI,ES:[MacroStart]
    DEC WORD ES:[RepeatCount]
    JZ  ReadFileRemoveRep
    CMP WORD ES:[RepeatNest],1
    JA  ReadFileRepNest
    ADD SI,11
    MOV ES:[InBufferPtr],SI
    MOV ES:[DiskInSeg],DS
    XOR AX,AX
    MOV ES:[LineNumber],AX
    MOV ES:[LineNumber][2],AX
    INC AX
    JMP ReadInFile_Exit

ReadFileMacro:
    MOV    AL,ES:[MacroType]
    CMP AL,MRepeatID
    JZ  ReadFileRep
    MOV BYTE ES:[MacroType],0
    JMP ReadInFile_MacroOK

NumReads DD 0

ReadInFile: 
    MOV BX,AsmData
    MOV ES,BX
    CMP    BYTE ES:[MacroType],0
    JNZ    ReadFileMacro
ReadInFile_MacroOK:    
    MOV    AX,ES:[InBufferSize]
    SUB    AX,SI
    JA     ReadInFile_Exit
    MOV    CX,BuffLimit
ReadInFile2:
    XOR    DX,DX
    MOV    BX,WORD ES:[CurHandle]
    CALL   FRead
    MOV    SI,AX
    MOV    ES:[InBufferSize],AX
    XOR    BX,BX
    MOV    WORD [SI],BX
    MOV    SI,DX
    CMP    BYTE ES:[Flushed],1
    JNZ    ReadInFileCalcBytesRead
    MOV    BYTE ES:[Flushed],0
    MOV    BP,WORD ES:[BytesRead]
    MOV    WORD ES:[BytesReadBak],BP
    MOV    BP,WORD ES:[BytesRead][2]
    MOV    WORD ES:[BytesReadBak][2],BP
ReadInFileCalcBytesRead:
    ADD    WORD ES:[BytesRead],AX
    ADC    WORD ES:[BytesRead][2],BX
    MOV    WORD ES:[InBufferPtr],SI
ReadInFile_Exit:
    RET

GetRAWLine:
    MOV    AX,AsmData
    MOV    ES,AX
    MOV    DI,OFFSET StrBuffer
    LDS    SI,DWORD [InBufferPtr]
GetRAWLineLoop:
    LODSB
    TEST    AL,AL
    JZ     GetRAWLineBufferEmpty
    CMP    AL,0Ah
    JZ     GetRAWLineDone
    CMP    AL,";"
    JZ     GetRAWLineComment
    CMP    AL,32
    JBE    GetRAWLineStoreSpace
    STOSB
    JMP    GetRAWLineLoop
GetRAWLineStoreSpace:
    MOV    AL,32
    STOSB
    JMP    GetRAWLineLoop
GetRAWLineComment:
    PUSH    DI
    CALL    GetNextFindNextLine
    POP    DI
    MOV    BYTE [EOLFlag],0
;    ADD     WORD ES:[LineNumber],1
;    ADC     WORD ES:[LineNumber][2],0
    RET
    
GetRAWLineDone:
    MOV    AX,AsmData
    MOV    DS,AX
    MOV    WORD [InBufferPtr],SI
    LEA    AX,[DI][-StrBuffer]
    MOV    WORD [StrLen],AX
    XOR    AX,AX
    MOV    ES:[DI],AX
;    ADD     WORD ES:[LineNumber],1
;    ADC     WORD ES:[LineNumber][2],0
    MOV    BYTE [EOLFlag],EndOfLine
    RET

GetRAWLineBufferEmpty:
    PUSH    CX,DX
    CALL    ReadInFile
    POP     DX,CX
    TEST    AX,AX
    JNZ     GetRAWLineLoop
    MOV     BYTE ES:[Msg],EndOfFile
    JMP     GetRAWLineDone
    
EVEN 2
GetNextCharI:
    MOV     BX,AsmData
    MOV     ES,BX
    LDS     SI,DWORD [InBufferPtr]
GetNextChar:
    MOV     BX,OFFSET CharDesc
GetNextCharLoop:    
    LODSB
    ES:
    XLAT
    CMP    AL,SpaceChar
    JZ     GetNextCharLoop
    CMP    AL,Slash
    JZ     GetNextSlash
    TEST    AL,AL
    JZ     GetNextCharBufferEmpty
GetNextCharFound:
    MOV    BX,AsmData
    MOV    DS,BX
    MOV    BYTE [NextChar],AL
    DEC    SI
    MOV    WORD [InBufferPtr],SI
    RET
GetNextCharBufferEmpty:
    PUSH    CX,DX
    CALL    ReadInFile
    POP     DX,CX
    TEST    AX,AX
    JNZ     GetNextChar
    MOV     BYTE ES:[Msg],EndOfFile
    MOV     AL,EndOfLine
    INC     SI
    JMP     GetNextCharFound
GetNextSlash:
    CALL    GetNextFindNextLine
    MOV     BYTE [EOLFlag],0
    JMP     GetNextCharI

GetNextStr  PROC
    PUSH    BX,CX,DX,SI,DI
    MOV SI,[StrPTR]

    MOV CX,-1
    MOV DX,CX

    XOR DI,DI
    MOV AH,0

 gnsRemSpace:
    LODSB
    CMP AL,0
    JZ  gnsDone
    CMP AL,0Ah
    JZ  gnsDone
    CMP AL,32
    JBE gnsRemSpace
    

    MOV	BX,AX

    CMP BYTE [BX][CharDesc],Quote
    JZ	gnsQuote

    DEC SI
    MOV	[StrStart],SI

    CMP BYTE [BX][CharDesc],Alpha
    JnZ gnsNotAlpha

    MOV	BYTE [StrType],Alpha
    
    CMP	AL,"0"
    JB	gnsLoop
    CMP	AL,"9"
    JA	gnsLoop
 gnsNumber:
	MOV	BYTE [StrType],Number
 gnsLoop:
    LODSB

    CMP AL,0
    JZ  gnsDone

    CMP AL,32
    JBE gnsDone
    
    MOV BX,AX

 gnsCalcCRC:

    MOV BL,[BX][LCaseTable]
    
    XOR BL,CL
    ADD BX,BX
    ADD BX,BX

    MOV CL,CH
    MOV CH,DL
    MOV DL,DH
    MOV DH,AH

    XOR CX,[BX][Crc32Buffer]
    XOR DX,[BX][Crc32Buffer][2]

    INC DI

    JMP gnsLoop
 gnsNotAlpha:
	MOV	AL,[BX][CharDesc]

	CMP	AL,Comma
	JZ	gnsDone
	
    MOV	BYTE [StrType],AL
    JMP gnsCalcCRC
 gnsQuote:
	MOV	[StrStart],SI
	MOV BYTE [StrType],Quote
	MOV	AH,AL
 gnsQuoteLoop:
	LODSB
	CMP	AH,AL
	JZ	gnsQuoteDone
	CMP	AL,32
	JB	gnsDone
	INC	DI
	JMP	gnsQuoteLoop	
 gnsQuoteDone:
	
 gnsDone:
    MOV [StrLen],DI

	MOV	AL,[StrType]
	MOV	AH,0
    MOV [StrCRC],CX
    MOV [StrCRC][2],DX
    MOV [StrPTR],SI

    POP DI,SI,DX,CX,BX
    RET
GetNextStr ENDP
