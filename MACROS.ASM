AllocNoTxtMem:
        JMP     OutOfMacroSpace

AllocTextMem:
        MOV BX,AsmData
        MOV DS,BX
        MOV     BX,WORD [TxtMemSize]
        CMP     BX,1000h
        JBE     AllocTextMem2
        MOV     BX,1000h
AllocTextMem2:
        CMP     BX,10h
        JB      AllocNoTxtMem
        PUSH    BX
        CALL    AllocateMem
        POP     BX
        JC      AllocNoTxtMem
        SUB     [TxtMemSize],BX
        MOV     WORD [FreeTxtSeg],AX
        MOV     SI,WORD [TxtSegs]
        MOV     WORD [SI][TextSegment],AX
        MOV     ES,AX
        XOR     DI,DI
        MOV     WORD [NextTxtPos],DI
        ADD     SI,2
        MOV     WORD [TxtSegs],SI
        MOV     AX,BX
        MOV     CL,4
        SHL     AX,CL
        DEC     AX
        MOV     [TxtSegSize],AX
        RET

FreeTxtMem:
        PUSH    BX
        MOV AX,[TxtSegSize]
        MOV CL,4
        SHR AX,CL
        INC AX
        ADD [TxtMemSize],AX
        MOV BX,[TxtSegs]
        SUB BX,2
        MOV ES,[BX][TextSegment]
        CALL    FreeMem
        POP AX
        TEST    AX,AX
        JZ  FreeTxtMemDone
FreeTxtMemLoop:
        MOV CX,WORD [BX][TextSegment][-2]
        CMP AX,CX
        JZ  FreeTxtMemDone
        ADD WORD [TxtMemSize],1000h
        MOV ES,CX
        CALL    FreeMem
        SUB BX,2
        JNZ FreeTxtMemLoop
        ADD BX,2
FreeTxtMemDone:
        MOV [TxtSegs],BX
        MOV AX,[BX][TextSegment][-2]
        MOV [FreeTxtSeg],AX
        RET

RepeatNumExpected:
        JMP     NumExpected
RepeatNumTooBig:
        JMP     NumTooBig
RepeatAllocTxtMem:
        PUSH    DX
        CALL    AllocTextMem
        POP     DX
        JMP     RepeatMemOK
RepeatDirec:
        CALL    GetOperand
        CMP     AH,Number
        JNZ     RepeatNumExpected
        CMP     AL,Num16
        JA      RepeatNumTooBig
        LES     DI,DWORD [NextTxtPos]
        MOV     BX,ES
        TEST    BX,BX
        JZ      RepeatAllocTxtMem
RepeatMemOK:
        INC WORD [RepeatNest]
        MOV [Temp1],DI
        MOV [Temp2],ES
        MOV WORD [Temp3],1
        MOV AX,WORD [MacroStart]    ;Previous block start OFFSET
        STOSW
        MOV AX,WORD [MacroStart][2] ;Previous block start SEGMENT
        STOSW
        MOV AX,DX
        XCHG    AX,[RepeatCount]    ;Previous REPEAT count
        STOSW
        MOV AL,[MacroType]          ;Previous MACRO TYPE
        STOSB
        ADD DI,4    ;Save space FOR previous input buffer
        PUSH    ES,DI
        LDS SI,[InBufferPtr]
        CALL    GetNextFindNextLine
        CMP WORD [RepeatNest],1     ;IF nested don't copy - copied already!
        JA  RepeatFinalizeNest
        MOV BYTE [InstrPresent],0
RepeatGetText:
        CALL    GetNextCharI
        CMP AL,Alpha
        JNZ RepeatCopyLine
        MOV     BYTE [EOLFlag],0
        CALL    GetNext
        POP DI,ES
        CMP AL,CPUInstruction
        JNZ RepeatCopy
        CMP DX,OFFSET EndMDirective
        JZ  RepeatCopyEnd
        CMP DX,OFFSET RepeatDirective
        JZ  RepeatCopyNewRepeat
RepeatCopy:
        MOV SI,OFFSET StrBuffer
        MOV CX,[StrLen]
        REP MOVSB
        MOV AL,20h
        STOSB
        PUSH    ES,DI
RepeatCopyLine:
        POP DI,ES
        LDS SI,[InBufferPtr]
RepeatCopyLineLoop:
        LODSB
        TEST    AL,AL
        JZ  RepeatCopyReadFile
        STOSB
        CMP AL,0Ah
        JZ  RepeatCopyLF
        CMP AL,20h
        JA  RepeatCopyLineLoop
        CMP BYTE ES:[DI][-1],20h
        JA  RepeatCopyLineLoop
        DEC DI
        JMP RepeatCopyLineLoop
RepeatCopyLF:
        PUSH    ES,DI
        MOV DI,AsmData
        MOV DS,DI
        MOV [InBufferPtr],SI
        JMP RepeatGetText
RepeatFinalizeNest:
        MOV BYTE [MacroType],MRepeatID
        LES DI,[Temp1]
        MOV [MacroStart],DI
        MOV [MacroStart][2],ES
        PUSH    DS
        LDS AX,[InBufferPtr]
        POP DI,ES
        SUB DI,4
        STOSW
        MOV AX,DS
        STOSW
        POP DS
        MOV [NextTxtPos],DI
        MOV [FreeTxtSeg],ES
        JMP AssembleDone2
RepeatCopyEnd:
        XOR AX,AX
        DEC WORD [Temp3]
        JNZ RepeatCopyEndCont
        JMP RepeatEndOK
RepeatCopyNewRepeat:
        INC WORD [Temp3]
        JMP RepeatCopy
RepeatCopyReadFile:
        PUSH    DI,ES
        CALL    ReadInFile
        TEST    AX,AX
        JNZ RepeatCopyLine
        MOV AX,AsmData
        MOV DS,AX
        JMP AlreadyInBlock
RepeatEndOK:
        STOSW
        MOV [LineNumber],AX
        MOV [LineNumber][2],AX
        MOV [NextTxtPos],DI
        MOV [FreeTxtSeg],ES
        MOV BYTE [MacroType],MRepeatID
        LES DI,[Temp1]
        MOV [MacroStart],DI
        MOV [MacroStart][2],ES
        ADD DI,7
        PUSH    DS
        LDS AX,[InBufferPtr]
        STOSW
        MOV AX,DS
        STOSW
        POP DS
        MOV [InBufferPtr],DI
        MOV [DiskInSeg],ES
        JMP AssembleFile
RepeatCopyEndCont:
        MOV AL,0    ;END nested REPEAT
        STOSB
        LDS SI,[InBufferPtr]
        JMP RepeatCopyLineLoop
InvokeDirecFromCall:
        XOR     BX,BX
        MOV     WORD [Temp4],BX
        MOV     WORD [Temp7],BX
        CMP     BYTE [JmpSize],FarJmp
        JNZ     InvokeDirecFromCall2
        OR      BYTE [Temp1],4
        MOV     BYTE [JmpSize],BL
        CMP     WORD PTR RelocFlags,0
InvokeDirecFromCall2:
        CMP     WORD PTR RelocFlags,0
        MOV     WORD [Temp1],BX
        AND     BYTE [ProcFlags][1],NOT 0Ch
        JMP     InvokeDirec2

InvokeDirecNoTxtMem:
        PUSH    AX
        CALL    AllocTextMem
        POP AX
        JMP     InvokeTxtMemOK
InvokeDirecGetKW:
        CMP DL,DistSpec
        JNZ InvokeDirecKWOK ;InvokeDirecInvalidKW
        CMP DH,FarJmp
        JNZ InvokeDirecGet
        OR  BYTE [Temp1],4
        JMP InvokeDirecGet
InvokeDirecInvalidKW:
        JMP InvalidKeyword
InvokeDirec:
        XOR     AX,AX
        MOV     BYTE [JmpSize],AL
        MOV     WORD [Temp1],AX
        MOV     WORD [Temp4],AX
        MOV     WORD [Temp7],AX
        AND     BYTE [ProcFlags][1],NOT 0Ch
InvokeDirecGet:
        CALL    GetOperand
        MOV     CL,[NextChar]
InvokeDirec2:
        CMP AL,Keyword
        JZ  InvokeDirecGetKW
InvokeDirecKWOK:
        CMP CL,Alpha
        JZ  InvokeNextOK
        CMP CL,Comma
        JZ  InvokeNextOKK
        OR  BYTE [Temp1],2
        CMP CL,OpenBracket
        JZ  InvokeNextOKK
        JMP CallProcessOp
InvokeNextOKK:
        INC     WORD [InBufferPtr]
InvokeNextOK:
        CMP     WORD [FreeTxtSeg],0
        JZ  InvokeDirecNoTxtMem
InvokeTxtMemOK:        
        LES     DI,[NextTxtPos]
        MOV     [Temp2],DI  ;Save the start pointer
        MOV     [Temp3],ES  ;Save the start SEGMENT
        MOV     BL,[JmpSize]
        MOV     BYTE [Temp1][1],BL
        MOV     BYTE [Error],127
        CMP     AH,Number
        JZ      InvokeLabel
        CMP     AL,Mem
        JZ      InvokeMem
        CMP     AL,Keyword
        JZ      InvokeKW
        JMP     InvalidOperand1
InvokeKW:
        JMP     InvokeStoreKW        
InvokeLabel:
        JMP     InvokeStoreNumAddr

InvokeMemNewTxt:
        PUSH    AX
        CALL    AllocTextMem
        POP     AX
InvokeMem:
        MOV     BX,[TxtSegSize]
        SUB     BX,DI
        CMP     BX,20
        JB      InvokeMemNewTxt
        MOV     BX,DI
        MOV     AL,[RelocFlags]
        AND     AL,1    ;41h = Reloc
        ADD     AL,40h
        STOSB
        XOR AX,AX
        XCHG    AX,[AddrOverride]
        STOSW
        CALL    GetOperandSize
        MOV     AL,[REXOverride]
        STOSW
        MOV     AL,[ModRM]
        STOSB
        MOV     AL,[SIB]
        MOV     AH,[SIBDisp]
        STOSW
        MOV     AX,[EADispSize]
        STOSW
        MOV     CL,AL
        MOV     CH,0
        TEST    BYTE [RelocFlags],1
        JZ      InvokeMemRelocOK
        MOV     AL,[RelocFlags]
        STOSB
        MOV     SI,OFFSET RelocData
        MOVSW
        MOVSW
        TEST    AL,80h+20h
        JNZ     InvokeMemDispOK
;        JMP     InvokeMemDispOK
InvokeMemRelocOK:
        MOV     SI,OFFSET   EADisp
        REP     MOVSB
InvokeMemDispOK:
        SUB     BX,DI
        NEG     BX
        MOV     AL,BL
        STOSB
        JMP     InvokeGetArgs

InvokeStoreNumAddrNewSeg:
        PUSH    AX
        CALL    AllocTextMem        
        POP AX
InvokeStoreNumAddr:
        MOV BX,[TxtSegSize]
        SUB BX,12
        CMP DI,BX
        JA  InvokeStoreNumAddrNewSeg
        CMP AL,Num64
        JA  InvokeNumTooBigInvk
        JMP InvokeStoreNum2

InvokeStoreNumRelocOK:
        STOSB
InvokeStoreNumRelocOKK:
        MOV CH,0
        MOV SI,OFFSET OWordNum
        REP MOVSB
InvokeStoreNumOK:
        SUB BX,DI
        NEG BX
        MOV AL,BL
        STOSB
        JMP InvokeGetArgs

InvokeStoreNumNewSeg:
        PUSH    AX
        PUSH    DI
        CALL    AllocTextMem
        MOV AL,0A0h
        STOSB
        POP AX
        STOSW
        MOV AL,3
        STOSB
        POP AX
        JMP InvokeStoreNum2

InvokeNumTooBigInvk:
        JMP InvokeNumTooBig

InvokeStoreNumOpSize:
        MOV AH,[OperandSize]
        MOV AL,1
        CMP AH,_BYTE
        JZ  InvokeStoreNum3
        INC AX
        CMP AH,_WORD
        JZ  InvokeStoreNum3
        MOV AL,4
        CMP AH,_DWORD
        JZ  InvokeStoreNum3
        MOV SI,OFFSET _InvalidOperandSize
        JMP InvokeError
InvokeStoreNumOp1:
        TEST    BYTE [Temp1],8
        JNZ InvokeStoreNumLangOK
        TEST    BYTE [ProcFlags][1],2
        JNZ InvokeStoreNumLangOK
        JMP InvokeGetFwdShift

InvokeStoreNumSym:
        MOV AL,[AddrMode]
        ADD AL,AL
InvokeStoreNum3:
        MOV CL,AL
        ADD AL,AL
        TEST    BYTE [RelocFlags],1
        JZ  InvokeStoreNumRelocOK
        OR  AL,1
        MOV AH,[RelocFlags]
        STOSW
        MOV SI,OFFSET RelocData
        MOVSW
        MOVSW
        TEST    AH,80h+20h
        JZ  InvokeStoreNumRelocOKK
        JMP InvokeStoreNumOK
InvokeKWLang:
        JMP InvokeKWLang2

InvokeStoreNum:
        CMP WORD [Temp4],1
        JZ  InvokeStoreNumOp1
InvokeStoreNumLangOK:
        CMP AL,Num32
        JA  InvokeNumTooBigInvk
        MOV BX,[TxtSegSize]
        SUB BX,8
        CMP DI,BX
        JA  InvokeStoreNumNewSeg        
InvokeStoreNum2:
        MOV BX,DI
        CMP BYTE [OperandSize],0
        JNZ InvokeStoreNumOpSize
        MOV AH,[Settings]
        AND AH,[EAMask]
        TEST AH,1
        JNZ InvokeStoreNumSym
        AND AL,0Fh
        CMP AL,1
        JNZ InvokeStoreNumSym
        TEST    BYTE [OWordNum],80h
        JZ  InvokeStoreNum3
        INC AL
        JMP InvokeStoreNumSym

InvokeStoreKW:
        CMP DL,Lang
        JZ  InvokeKWLang
        CMP WORD [Temp4],1
        JZ  InvokeStoreKWOp1
InvokeStoreKWLangOK:
        MOV BX,[TxtSegSize]
        SUB BX,5
        CMP DI,BX
        JA  InvokeStoreKWNewSeg
        MOV AL,30h
        STOSB
        MOV AX,DX
        STOSW
        MOV AL,3
        STOSB
        JMP InvokeGetArgs

InvokeGetArgs:        
        INC WORD [Temp4]
        MOV AL,0
        MOV BYTE [SymOpSize],AL
        MOV BYTE [OperandSize],AL
        MOV BYTE [RelocFlags],AL
        MOV BYTE [Settings],AL
        PUSH    ES,DI
        CALL    GetOperand
        POP DI,ES
        CMP AH,Number
        JZ  InvokeStoreNum
        CMP AL,Keyword
        JZ  InvokeStoreKW
        CMP BYTE [StrLen],1
        JZ  InvokeGetArgsMayBeC
InvokeGetArgsNotC:
        CMP AL,Mem
        JZ  InvokeStoreMem
        CMP AL,CPUInstruction
        JZ  InvokeGetArgsInstr
        JMP InvokeInvalidArg

InvokeStoreKWOp1:
        TEST    BYTE [Temp1],8
        JNZ InvokeStoreKWLangOK
        TEST    BYTE [ProcFlags][1],2
        JNZ InvokeStoreKWLangOK
        JMP InvokeGetFwdShift
InvokeStoreKWNewSeg:
        PUSH    DX
        PUSH    DI
        CALL    AllocTextMem
        MOV AL,0A0h
        STOSB
        POP AX
        STOSW
        MOV AL,3
        STOSB        
        POP DX
        JMP InvokeStoreKW
InvokeStoreMemOp1:
        TEST    BYTE [Temp1],8
        JNZ InvokeStoreMemLangOK
        TEST    BYTE [ProcFlags][1],2
        JNZ InvokeStoreMemLangOK
        JMP InvokeGetFwdShift

InvokeGetArgsInstr:
        DEC BYTE [Temp4]
        JNZ InvokeInvalidArgInvk
        CMP DX,OFFSET SysCallInstr
        JZ  InvokeLangCC
InvokeInvalidArgInvk:
        JMP InvokeInvalidArg
InvokeGetArgsMayBeC:
        CMP BYTE [Temp4],1
        JNZ InvokeGetArgsNotC
        MOV BL,BYTE [StrBuffer]
        OR  BL,20h
        CMP AL,"c"
        JNZ InvokeGetArgsNotC
InvokeLangCC:
        TEST    BYTE [Temp1],8
        JNZ InvokeInvalidArgInvk
        OR  BYTE [Temp1],8
        OR  BYTE [ProcFlags][1],0Ch
        JMP InvokeGetArgs

InvokeStoreMem:
        CMP WORD [Temp4],1
        JZ  InvokeStoreMemOp1
InvokeStoreMemLangOK:
        MOV BX,[TxtSegSize]
        MOV CL,[SIBDisp]
        ADD CL,[REXDisp]
        ADD CL,[EADispSize]        
        ADD CL,10
        MOV CH,0
        ADD CX,DI
        JC  InvokeStoreMemNewSeg
        CMP CX,[TxtSegSize]
        JA  InvokeStoreMemNewSeg
        MOV BX,DI
        MOV AL,[RelocFlags]
        AND AL,1
        ADD AL,40h
        STOSB   ;TYPE
        INC DI  ;Reserve space
        XOR AX,AX
        XCHG    AX,[AddrOverride]
        STOSB
        CMP AL,1
        SBB DI,0
        MOV AL,AH
        STOSB
        CMP AL,1
        SBB DI,0
        MOV AL,[REXOverride]
        CALL    GetOperandSize
        CMP AH,_WORD
        JZ  InvokeStoreMem16
        CMP AH,_DWORD
        JZ  InvokeStoreMem32
        CMP AH,_QWORD
        JZ  InvokeStoreMem64
        MOV SI,OFFSET _InvalidOperandSize
        JMP InvokeError

InvokeStoreMemNewSeg:
        PUSH    DI
        CALL    AllocTextMem
        MOV AL,0A0h
        STOSB
        POP AX
        STOSW
        MOV AL,3
        STOSB
        JMP InvokeStoreMem

InvokeInvalidAddr:
        MOV SI,OFFSET _InvalidAddrMode
        JMP InvokeError
InvokeStoreMem16:
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr16Disp]
        JMP InvokeStoreMem2
InvokeStoreMem64:
        CMP BYTE [AddrMode],4
        JB  InvokeInvalidAddr
        OR  AL,48h
        OR  BYTE [REXDisp],1
        JMP InvokeStoreMem2
InvokeStoreMem32:
        CMP BYTE [AddrMode],2
        JA  InvokeInvalidAddr
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr32Disp]
InvokeStoreMem2:
        MOV ES:[DI],AL
        ADD DI,[REXDisp]
        MOV AL,0FFh
        MOV AH,[ModRM]
        OR  AH,48
        STOSW
        MOV AL,[SIB]
        MOV ES:[DI],AL
        ADD DI,[SIBDisp]
        LEA AX,[DI][-2]
        SUB AX,BX
        MOV ES:[BX][1],AL        
        MOV AX,[EADispSize]
        STOSW
        MOV CL,AL
        TEST    BYTE [RelocFlags],1
        JZ  InvokeStoreMemRelocOK
        MOV AL,[RelocFlags]
        STOSB
        MOV SI,OFFSET RelocData
        MOVSW
        MOVSW
        TEST    AL,80h+20h
        JNZ InvokeStoreMemDispOK
;        JMP InvokeStoreMemDispOK
InvokeStoreMemRelocOK:
        MOV CH,0
        MOV SI,OFFSET EADisp
        REP MOVSB
InvokeStoreMemDispOK:
        SUB BX,DI
        NEG BX
        MOV AL,BL
        STOSB
        JMP InvokeGetArgs

InvokeNumTooBig:
        MOV SI,OFFSET _InvalidOperand
        JMP InvokeError
InvokeInvalidArg:
        CMP AL,EndOfLine
        JZ  InvokeProcessArgs
        CMP AL,CloseBracket
        JZ  InvokeProcessArgsCB
InvokeInvalidArg2:
        MOV SI,OFFSET _InvalidOperand
InvokeError:
        MOV AX,AsmData
        MOV DS,AX
        MOV ES,AX
        CALL    PrintError
        LES BX,[Temp2]
        MOV [NextTxtPos],BX
        MOV CX,ES
        CMP CX,[FreeTxtSeg]
        JZ  InvokeErrorMemOK
        MOV BX,ES
        CALL    FreeTxtMem
InvokeErrorMemOK:
        JMP AssembleDone3
InvokeMissingOB:
        MOV SI,OFFSET _MissingOpenBr
        JMP InvokeError
InvokeMissingCB:
        MOV SI,OFFSET _MissingCloseBr
        JMP InvokeError
InvokeProcessArgsCB:
        TEST    BYTE [Temp1],2
        JZ  InvokeMissingOB
        JMP InvokeProcessArgsOK
InvokeProcessArgs:
        TEST    BYTE [Temp1],2
        JNZ InvokeMissingCB
InvokeProcessArgsOK:
        LEA BX,[DI][-1]
        PUSH    ES
        LES DI,[OBufferPtr]
        POP DS
        JMP InvokeProcessArgsLoop
InvokeProcessNumber:
        CMP AL,3
        JBE InvokePushNum8
        CMP AL,5
        JBE InvokePushNum16
InvokePushNum32:
        PUSH    ES
        MOV BYTE ES:[DI],66h
        MOV ES,CS:[AsmDataSeg]
        ADD DI,ES:[Addr32Disp]
        POP ES
        TEST    AL,1
        MOV AL,68h
        STOSB
        JNZ  InvokePushNum32Reloc
        MOVSW
        MOVSW
        JMP InvokeProcessArgsLoop
InvokePushNum32Reloc:
        LODSB
        PUSH    ES,DI
        MOV DI,AsmData
        MOV ES,DI
        MOV ES:[RelocFlags],AL
        MOV DI,OFFSET RelocData
        MOVSW
        MOVSW
        MOV DI,OFFSET OWordNum
        TEST    AL,80h+20h
        JNZ InvokePushNum32Reloc2
        MOV DX,[SI]
        MOVSW
        MOVSW
        JMP InvokePushNum32Reloc3
InvokePushNum32Reloc2:
        XOR AX,AX
        MOV DX,AX
        STOSW
        STOSW
InvokePushNum32Reloc3:
        POP DI,ES
        PUSH DS,BX
        MOV AX,AsmData
        MOV DS,AX
        CALL    Write32Imm
        POP BX,DS
        JMP InvokeProcessArgsLoop            
InvokePushNum8:        
        MOV AH,[SI]
        MOV AL,6Ah
        STOSW
        JMP InvokeProcessArgsLoop
InvokePushNum16:
        PUSH    ES
        MOV BYTE ES:[DI],66h
        MOV ES,CS:[AsmDataSeg]
        ADD DI,ES:[Addr16Disp]
        POP ES
        TEST    AL,1
        MOV AL,68h
        STOSB
        JNZ  InvokePushNum16Reloc
        MOVSW
        JMP InvokeProcessArgsLoop
InvokePushNum16Reloc:
        LODSB
        PUSH DS,BX
        PUSH    ES,DI
        MOV DI,AsmData
        MOV ES,DI
        MOV ES:[RelocFlags],AL
        PUSH    DI
        MOV DI,OFFSET RelocData
        MOVSW
        MOVSW
        POP DS
        POP DI,ES
        TEST    AL,80h+20h
        JNZ InvokePushNum16Reloc2
        LODSW
        MOV DX,AX
        JMP InvokePushNum16Reloc3
InvokePushNum16Reloc2:
        XOR DX,DX
InvokePushNum16Reloc3:
        MOV WORD [OWordNum],DX
        CALL    Write16Imm2
        POP BX,DS
        JMP InvokeProcessArgsLoop
InvokePrevSeg:
        INC DI
        LODSW
        PUSH    ES,DI,AX
        MOV BX,AsmData
        MOV DS,BX
        XOR BX,BX
        CALL    FreeTxtMem
        MOV DS,[FreeTxtSeg]
        POP BX,DI,ES
        DEC BX
        JMP InvokeProcessArgsLoop

InvokePushSegReg3_2:
        MOV AL,0Fh
        ADD AH,AH
        ADD AH,AH
        ADD AH,AH
        ADD AH,0A0h
        STOSW
        JMP InvokeProcessArgsLoop
InvokePushSegReg:
        ADD AH,AH
        ADD AH,AH
        ADD AH,AH
        MOV AL,06h
        ADD AL,AH
        STOSB
        JMP InvokeProcessArgsLoop

InvokeProcessGetAddr:
        JMP InvokeProcessGetAddr2
InvokeProcessArgsFlush:
;        JMP InvokeProcessArgsFlush2
InvokeProcessArgsFlush2:
        PUSH    BX
        PUSH    DS
        MOV AX,AsmData
        MOV DS,AX
        CALL    WriteOutFileP
        MOV DI,WORD [OBufferPtr]
        POP DS
        POP BX
InvokeProcessArgsLoop:
        CMP DI,0FFE0h
        JA  InvokeProcessArgsFlush
        MOV AL,[BX]
        MOV AH,0
        MOV SI,BX
        SUB SI,AX
        LEA BX,[SI][-1]
        CMP BYTE [SI],0A0h
        JZ  InvokePrevSeg
        MOV ES,CS:[AsmDataSeg]
        DEC WORD ES:[Temp4]
        MOV ES,ES:[DiskOutSeg]
        JZ  InvokeProcessGetAddr
        LODSB
        CMP AL,40h
        JZ  InvokeProcessMemArg
        CMP AL,41h
        JZ  InvokeProcessMemArg
        CMP AL,30h
        JZ  InvokeProcessKW
        JMP InvokeProcessNumber
InvokeProcessKW:
        LODSW
        CMP AL,Reg16
        JZ  InvokePushR16
        CMP AL,Reg32
        JZ  InvokePushR32
        CMP AL,Reg64
        JZ  InvokePushR64
        CMP AL,LMReg16
        JZ  InvokePushLMR16
        CMP AL,LMReg64
        JZ  InvokePushLMR64
        CMP AL,SegReg
        JZ  InvokePushSegReg
        CMP AL,SegReg386
        JZ  InvokePushSegReg3
        JMP InvokeInvalidArg2
InvokePushSegReg3:
        JMP InvokePushSegReg3_2
InvokeInvalidAddrMode:
        MOV SI,OFFSET _InvalidAddrMode
        JMP InvokeError

InvokePushR16:
        PUSH    ES
        MOV BYTE ES:[DI],66h
        MOV ES,CS:[AsmDataSeg]
        ADD DI,ES:[Addr16Disp]
        POP ES
        MOV AL,50h
        ADD AL,AH
        STOSB
        JMP InvokeProcessArgsLoop

InvokeProcessMemArg:
        JMP InvokeProcessMemArg2
InvokePushR32:
        PUSH    ES
        MOV BYTE ES:[DI],66h
        MOV ES,CS:[AsmDataSeg]
        ADD DI,ES:[Addr32Disp]
        CMP BYTE ES:[AddrMode],2
        POP ES
        JA  InvokeInvalidAddrMode
        MOV AL,50h
        ADD AL,AH
        STOSB
        JMP InvokeProcessArgsLoop
InvokePushLMR16:
        MOV AX,4166h
        STOSW
        MOV AL,50h
        ADD AL,AH
        STOSB
        JMP InvokeProcessArgsLoop

InvokePushLMR64:
        MOV AL,49h
        STOSB
InvokePushR64:
        MOV AL,50h
        ADD AL,AH
        STOSB
        JMP InvokeProcessArgsLoop

InvokeProcessMemArg2:
        MOV DL,AL
        LODSB
        MOV CL,AL
        MOV CH,0
        REP MOVSB
        LODSW
        TEST    AL,AL
        JZ  InvokeProcessArgsLoopInvk
        PUSH    ES
        MOV ES,CS:[AsmDataSeg]
        MOV ES:[EADispSize],AX
        POP ES
        MOV CL,AL
        MOV CH,0
        TEST    DL,1
        JNZ InvokeProcessMemReloc
        REP MOVSB
InvokeProcessArgsLoopInvk:
        JMP InvokeProcessArgsLoop

InvokeProcessMemReloc:
        LODSB
        PUSH    DS,BX
        PUSH    ES,DI
        MOV DI,AsmData
        MOV ES,DI
        MOV ES:[RelocFlags],AL
        PUSH    DI
        MOV DI,OFFSET RelocData
        MOVSW
        MOVSW
        MOV DI,OFFSET EADisp
        TEST    AL,80h+20h
        JNZ InvokeProcessMemReloc2
        REP MOVSB
        JMP InvokeProcessMemReloc3
InvokeProcessMemReloc2:
        XOR AX,AX
        REP STOSB
InvokeProcessMemReloc3:
        POP DS
        POP DI,ES
        CALL    WriteEADataDispOK
        POP BX,DS
        JMP InvokeProcessArgsLoop        

InvokeCallKW:
        LODSW
        MOV DX,AsmData
        MOV DS,DX
        MOV DX,AX
        MOV BYTE [Error],0
        CALL    UpdateProgIP
        MOV AL,[Temp1][1]
        MOV [JmpSize],AL
        JMP CallKW
InvokeProcessGetAddr2:
        LODSB
        CMP AL,30h
        JZ  InvokeCallKW
        PUSH    ES,DI
        MOV DI,AsmData
        MOV ES,DI
        PUSH    DI
        MOV BYTE ES:[Error],0        
        CMP AL,40h
        JZ  InvokeCallMem
        CMP AL,41h
        JZ  InvokeCallMem
        MOV DI,OFFSET OWordNum
        MOV CL,AL
        SHR CL,1
        MOV CH,0
        JNC InvokeNumNoReloc
        LODSB
        MOV ES:[RelocFlags],AL
        PUSH    DI
        MOV DI,OFFSET RelocData
        MOVSW
        MOVSW
        POP DI
        TEST    AL,80h+20h
        JNZ InvokeNumReloc2
        MOV DX,[SI]
        REP MOVSB
        JMP InvokeNumReloc3
InvokeNumReloc2:
        XOR AX,AX
        MOV DX,AX
        REP STOSB
InvokeNumReloc3:
        JMP InvokeNumOK
InvokeNumNoReloc:
        MOV DX,[SI]
        REP MOVSB
InvokeNumOK:
        POP DS
        POP DI,ES
        MOV AL,[Temp1][1]
        MOV [JmpSize],AL
        TEST    BYTE [Temp1],4
        JZ  InvokeNumUpd
        MOV AL,0Eh
        STOSB
InvokeNumUpd:
        CALL    UpdateProgIP
        JMP CallDisp

InvokeCallMem:
        MOV CL,AL
        LODSW
        MOV ES:[AddrOverride],AX
        LODSW
        MOV ES:[REXOverride],AL
        MOV ES:[OperandSize],AH
        LODSB
        MOV ES:[ModRM],AL
        LODSW
        MOV ES:[SIB],AL
        MOV ES:[SIBDisp],AH
        LODSW
        MOV ES:[EADispSize],AX
        TEST    CL,1
        MOV CL,AL
        MOV CH,0
        MOV DI,OFFSET EADisp
        JNZ InvokeCallMemReloc
InvokeCallMemRelocOK:
        REP MOVSB
InvokeCallMemDone:
        POP DS
        POP DI,ES
        MOV AL,[Temp1][1]
        MOV [JmpSize],AL
        CALL    UpdateProgIP
        JMP CallMem
InvokeCallMemReloc:
        LODSB
        MOV ES:[RelocFlags],AL
        MOV DI,OFFSET RelocData
        MOVSW
        MOVSW
        MOV DI,(EADisp)

        TEST    AL,80h+20h
        JZ  InvokeCallMemRelocOK
        MOV AL,0
        REP STOSB
        JMP InvokeCallMemDone
InvokeKWLang2:        
        DEC WORD [Temp4]
        JNZ InvokeKWInvalidArgInvk
        TEST    BYTE [Temp1],8
        JZ  InvokeKWLangOK2
InvokeKWInvalidArgInvk:
        JMP InvokeInvalidArg
InvokeKWLangOK2:
        AND BYTE [ProcFlags][1],NOT 0Ch
        OR  BYTE [Temp1],8
        CMP DH,1
        JZ  InvokeLangBasic
        CMP DH,2
        JZ  InvokeLangC
        OR  BYTE [ProcFlags][1],8
        JMP InvokeGetArgs
InvokeLangC:
        OR  BYTE [ProcFlags][1],0Ch
        JMP InvokeGetArgs
InvokeLangBasic:
        MOV [Temp5],DI
        MOV [Temp6],ES
        MOV DI,[OBufferPtr]
        JMP InvokeFwdGet
InvokeGetFwdShift:
        MOV [Temp5],DI
        MOV [Temp6],ES
        MOV DI,[OBufferPtr]
        JMP InvokeFwdGet2
        
InvokeFwdNoBr:
        MOV SI,OFFSET _MissingCloseBr
        JMP InvokeError

InvokeFwdR16:
        MOV BYTE ES:[DI],66h
        ADD DI,WORD [Addr16Disp]
        MOV AL,50h
        ADD AL,DH
        STOSB
        JMP InvokeFwdCheckIP
InvokeFwdR32:
        CMP BYTE [AddrMode],2
        JA  InvokeFwdInvalidAddr
        MOV BYTE ES:[DI],66h
        ADD DI,WORD [Addr32Disp]
        MOV AL,50h
        ADD AL,DH
        STOSB
        JMP InvokeFwdCheckIP
InvokeFwdLMR16:
        MOV AX,4166h
        STOSW
        MOV AL,50h
        ADD AL,AH
        STOSB
        JMP InvokeFwdCheckIP
InvokeFwdLMR64:
        MOV AL,49h
        STOSB
InvokeFwdR64:
        MOV AL,50h
        ADD AL,DH
        STOSB
        JMP InvokeFwdCheckIP
InvokeFwdInvalidAddr:
        MOV SI,OFFSET _InvalidAddrMode
        JMP InvokeError
InvokeFwdDoneBr:
        TEST    BYTE [Temp1],2
        JNZ InvokeFwdDone2
        MOV SI,OFFSET _MissingOpenBr
        JMP InvokeError
InvokeFwdDone:
        TEST    BYTE [Temp1],2
        JNZ InvokeFwdNoBr
InvokeFwdDone2:
        LDS SI,[Temp5]
        DEC SI
        MOV BL,[SI]
        MOV BH,0
        SUB SI,BX
        JMP InvokeProcessGetAddr2
InvokeFwdKW:
        CMP DL,Reg16
        JZ  InvokeFwdR16
        CMP DL,Reg32
        JZ  InvokeFwdR32
        CMP DL,Reg64
        JZ  InvokeFwdR64
        CMP DL,LMReg16
        JZ  InvokeFwdLMR16
        CMP DL,LMReg64
        JZ  InvokeFwdLMR64
        CMP DL,SegReg
        JZ  InvokeFwdSegReg
        CMP DL,SegReg386
        JZ  InvokeFwdSegReg3
        JMP InvokeInvalidArg2
InvokeFwdFlush:
        PUSH    DS
        MOV AX,AsmData
        MOV DS,AX
        CALL    WriteOutFileP
        MOV DI,[OBufferPtr]
        POP DS
        JMP InvokeFwdGet
InvokeFwdCheckIP:
        CMP DI,0FFE0h
        JA  InvokeFwdFlush
InvokeFwdGet:
        INC WORD [Temp4]
        MOV BYTE [SymOpSize],0
        MOV BYTE [OperandSize],0
        MOV BYTE [RelocFlags],0
        MOV BYTE [Settings],0
        PUSH    DI
        CALL    GetOperand
        POP DI
InvokeFwdGet2:
        MOV ES,[DiskOutSeg]
        CMP AH,Number
        JZ  InvokeFwdNum
        CMP AL,Mem
        JZ  InvokeFwdMem
        CMP AL,Keyword
        JZ  InvokeFwdKW
        CMP AL,EndOfLine
        JZ  InvokeFwdDone__
        CMP AL,CloseBracket
        JNZ InvokeInvalidArgInvk2
        JMP InvokeFwdDoneBr
InvokeFwdDone__:
        JMP InvokeFwdDone
InvokeInvalidArgInvk2:
        JMP InvokeInvalidArg
InvokeFwdSegReg3:
        MOV AL,0Fh
        ADD DH,DH
        ADD DH,DH
        ADD DH,DH
        ADD DH,0A0h
        MOV AH,DH
        STOSW
        JMP InvokeFwdCheckIP
InvokeFwdSegReg:
        ADD DH,DH
        ADD DH,DH
        ADD DH,DH
        ADD DH,06h
        MOV AL,DH
        STOSB
        JMP InvokeFwdCheckIP
InvokeFwdMem:
        CALL    GetOperandSize
        MOV CL,[REXOverride]
        CMP AH,_WORD
        JZ  InvokeFwdMem16
        CMP AH,_DWORD
        JZ  InvokeFwdMem32
        CMP AH,_QWORD
        JZ  InvokeFwdMem64
        MOV SI,OFFSET _InvalidOperandSize
        JMP InvokeError
InvokeFwdMem16:
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr16Disp]
        JMP InvokeFwdMemWrite
InvokeFwdMem32:
        CMP BYTE [AddrMode],2
        JA  InvokeFwdInvalidAddr1
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr32Disp]
        JMP InvokeFwdMemWrite

InvokeFwdNum:
        MOV CL,[OperandSize]
        TEST    CL,CL
        JNZ InvokeFwdBySize
        MOV CL,[Settings]
        AND CL,[EAMask]
        TEST    CL,1
        JNZ InvokeFwdByAddr
        CMP AL,Num8
        JNZ InvokeFwdByAddr
        CMP DX,127
        JG  InvokeFwdByAddr
        CMP DX,-128
        JL  InvokeFwdByAddr
InvokeFwdNum8:
        MOV AL,6Ah
        MOV AH,DL
        STOSW
        JMP InvokeFwdCheckIP

InvokeFwdInvalidAddr1:
        MOV SI,OFFSET _InvalidAddrMode
        JMP InvokeError

InvokeFwdMem64:
        CMP BYTE [AddrMode],4
        JB  InvokeFwdInvalidAddr1
        OR  CL,48h
        OR  BYTE [REXDisp],1
        JMP InvokeFwdMemWrite

InvokeFwdByAddr:
        CMP BYTE [AddrMode],2
        JB  InvokeFwdNum16
InvokeFwdNum32:
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr32Disp]
        MOV AL,68h
        STOSB
        CALL    Write32Imm
        JMP InvokeFwdCheckIP
InvokeFwdBySize:
        CMP CL,_BYTE
        JZ  InvokeFwdNum8
        CMP CL,_WORD
        JZ  InvokeFwdNum16
        CMP CL,_DWORD
        JZ  InvokeFwdNum32
        MOV SI,OFFSET _InvalidOperandSize
        JMP InvokeError
InvokeFwdNum16:
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr16Disp]
        MOV AL,68h
        STOSB
        CALL    Write16Imm2
        JMP InvokeFwdCheckIP

InvokeFwdMemWrite:
        XOR AX,AX
        XCHG    AX,[AddrOverride]
        STOSB
        CMP AL,1
        SBB DI,0
        MOV AL,AH
        STOSB
        CMP AL,1
        SBB DI,0
        OR  BYTE [ModRM],48
        MOV ES:[DI],CL
        ADD DI,[REXDisp]
        MOV AL,0FFh
        STOSB
        CALL    WriteEAData
        JMP InvokeFwdCheckIP

;TEMP1
;0      -   FAR Imm external
;1      -   Must END with )
;2      -   FAR specification
;3      -   Language has been specified
ProcInBlock:
        JMP     AlreadyInBlock
ProcDirec:
        TEST    BYTE [InBlock],0FEh
        JNZ     ProcInBlock
        MOV     BYTE [ProcFlags],0
        MOV     BYTE [JmpSize],0
        OR      BYTE [InBlock],4
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]
        MOV     WORD [ProcBlockIDCrc],DI
        MOV     WORD [ProcBlockIDCrc][2],BP
        MOV     BYTE [ProcBlockIDLen][1],CH
        TEST    SI,SYM_UNDEF
        JNZ     ProcExists
        CMP     CL,UnknownID
        JZ      ProcWriteSym
        TEST    BYTE [RefFlags],8
        JNZ     ProcExists
        JMP     DupDef
ProcWriteSym:
        MOV     CL,CH
        MOV     CH,LabelID
        MOV     SI,OFFSET ProgIP-4
        MOV     BYTE [SI],0
        CALL    WriteSymbol
        JMP     ProcDirec2
ProcExists:
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        TEST    BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        JZ      ProcExistsWrite
        MOV     SI,OFFSET StrBuffer+256
        PUSH    DS
        POP     ES
        CALL    PublicDef
        LES     DI,DWORD [SymPos]
ProcExistsWrite:
        CALL    OverwriteSymbolAddressChk
ProcDirec2:
        MOV     AL,[ProcFlags][1]
        AND     AL,3
        OR      [ProcFlags],AL
        JMP     ProcDirec3
ProcInstr:
        CMP DX,OFFSET SysCallInstr+2
        JNZ ProcInvalidKW
        AND BYTE [ProcFlags],NOT 2
        JMP ProcDirec3
ProcDirec3:
        MOV     BYTE [CommaFlag],7Fh
        XOR     AX,AX
        MOV     WORD [StrLen],AX
        MOV     BYTE [InstrPresent],AL
        CALL    GetNext
        AND     BYTE [CommaFlag],7Fh
        JZ      ProcGetArguments
        CMP     AL,OpenBracket
        JZ      ProcGetArgumentsBr
        CMP     AL,Keyword
        JZ      ProcKeyword
        CMP     AL,CPUInstruction
        JZ      ProcInstr
        CMP     AL,EndOfLine
        JZ      ProcDirecDone
        CMP     WORD [StrLen],1
        JZ      ProcLen1
        JMP     ProcGetArguments
ProcLen1:
        MOV DL,BYTE [StrBuffer]
        CMP DL,"C"
        JZ  ProcLangNRvs
        CMP DL,"c"
        JZ  ProcLangNRvs
        JMP ProcGetArguments
ProcKeyword:
        CMP DL,DistSpec
        JZ  ProcDistSpec
        CMP DL,Lang
        JZ  ProcLang
        JMP InvalidKeyword
ProcInvalidKW:
        JMP InvalidKeyword
ProcLang:
        CMP DH,1
        JNZ ProcLangNRvs
        AND BYTE [ProcFlags],NOT 2
        JMP ProcDirec3
ProcDistSpec:
        CMP BYTE [JmpSize],0
        JNZ ProcInvalidKW
        CMP DL,ShortJmp
        JZ  ProcInvalidKW
        MOV BYTE [JmpSize],DH
        CMP DH,NearJmp
        JZ  ProcDirec3
        OR  BYTE [ProcFlags],20h
        JMP ProcDirec3
ProcDirecDone:
        MOV     AX,[OBufferPtr]
        MOV     WORD [BlockBak1],AX
        OR      BYTE [ProcFlags],80h
        JMP AssembleDone2
ProcLangNRvs:
        OR  BYTE [ProcFlags],2
        JMP ProcDirec3
ProcGetArgumentsBr:
        OR      BYTE [Temp1],1
ProcGetArguments:
        CMP     AH,Identifier
        JNZ     ProcArgsIDExp
        CMP     AL,UnknownID
        JNZ     ProcArgsDupDef
        PUSH    DI  ;Save it, it contains lower CRC code
        PUSH    DS
        POP     ES
        MOV     DI,OFFSET BlockBak1 ;Initialize
        XOR     AX,AX
        MOV     CX,8
        REP     STOSW
        POP     DI
        MOV     [Temp4],AX
        MOV     BYTE [Error],127
        MOV     AL,[AddrMode]
        MOV     AH,AL
        OR      AL,090h
        MOV     [Temp3],AL
        ADD     AH,AH
        MOV     [Temp1],AH
        ADD     AH,AH
        CMP     BYTE [JmpSize],FarJmp
        JNZ ProcJmpSizeOK
        ADD     AH,[Temp1]
ProcJmpSizeOK:
        MOV     BYTE [ProcDispSize],AH  ;Initial dispacement        
        JMP     ProcArgsLoop2
ProcArgsIDExp:
        MOV     SI,OFFSET _InvalidOperand
        JMP     PrtError
ProcArgsDupDef:
        JMP     DupDef
ProcArgsDoneBr:        
ProcArgsDone:
        MOV     BYTE [Error],0
        JMP     ProcArgsDone2
ProcArgsLoop:
        INC WORD [Temp4]
        CALL    GetNext
        CMP AL,EndOfLine
        JZ  ProcArgsDone
        CMP AL,CloseBracket
        JZ  ProcArgsDoneBr
        CMP AX,Identifier SHL 8 OR UnknownID
        JNZ ProcGetArguments
ProcArgsLoop2:
        MOV     CL,[StrLen]
        CMP     BYTE [NextChar],Colon
        JNZ     ProcArgsWrite
        INC     WORD [InBufferPtr]
        PUSH    CX,DI,BP
        CALL    GetNext
        POP     BP,DI,CX
        CMP     AL,Keyword
        JZ      ProcArgsKW
        CMP     AH,Identifier
        JNZ     ProcArgsInvalidType
        CMP     AL,LocalID
        JZ      ProcArgsInvalidType
        CMP     AL,StructID
        JBE      ProcArgsPointer
ProcArgsInvalidType:
        JMP     InvalidOperandSize

ProcArgsKW:
        CMP     DL,DataType
        JNZ     ProcArgsInvalidType        
        MOV     DL,1
        CMP     DH,_WORD
        JBE     ProcArgs32
        INC DX
        CMP     DH,_DWORD
        JZ  ProcArgs32
        INC DX
        CMP     DH,_FWORD
        JZ  ProcArgs32
        INC DX
        CMP     DH,_QWORD
        JZ      ProcArgs32
        INC DX
        CMP     DH,_TWORD
        JZ      ProcArgs32
        MOV DL,8
        CMP     DH,_OWORD
        JZ      ProcArgs32
ProcArgsPointer:
        MOV     AL,[AddrMode]
        ADD     AL,AL
        MOV     BYTE [Temp1],AL
        DEC     AL
        OR      AL,090h
        MOV     [Temp3],AL
        JMP     ProcArgsWrite
ProcArgs32:
        ADD     DL,DL
        OR      DH,090h
        MOV     BYTE [Temp3],DH
        MOV     BYTE [Temp1],DL
ProcArgsWrite:
        MOV     CH,[Temp3]
        MOV     SI,OFFSET BlockBak1
        CALL    WriteLocalSymbol
        MOV     AX,[Temp1]
        ADD     [SI],AX
        MOV     AL,[AddrMode]
        OR      AL,090h
        MOV     [Temp3],AL
        JMP     ProcArgsLoop
ProcArgsDone2:
        MOV     AX,[BlockBak1]
        MOV     [ProcArgSize],AX
        MOV     AL,BYTE [Temp1]
        MOV     [ProcDispSize][1],AL
        LES     DI,[OBufferPtr]
        MOV     AL,88h
        CMP     BYTE [AddrMode],2
        JBE     ProcArgsx86
        OR      AL,40h
        OR      BYTE [ProcFlags],AL
        MOV     AX,5548h
        STOSW
        MOV     AX,8B48h
        STOSW
        MOV     AL,0ECh
        STOSB
        MOV     [BlockBak1],DI
        JMP     AssembleDone
ProcArgsx86:
        JZ      ProcArgs86OK
        OR      AL,4
ProcArgs86OK:
        OR      BYTE [ProcFlags],AL
        MOV     AL,55h
        STOSB
        MOV     AX,0EC8Bh
        STOSW
        MOV     [BlockBak1],DI
        JMP     AssembleDone
CantLocals:
        JMP     InvalidKeyword
LocalDirec:
        TEST    BYTE [ProcFlags],80h
        JZ      CantLocals
        MOV     AX,WORD [OBufferPtr]
        CMP     AX,[BlockBak1]
        JNZ     CantLocals
        TEST    BYTE [ProcFlags],8
        JNZ     LocalDirecArgsOK
        LES     DI,[OBufferPtr]
        CMP     BYTE [AddrMode],2
        JBE     LocalDirecx86
        OR      BYTE [ProcFlags],48h
        MOV     AX,5548h
        STOSW
        MOV     AX,8B48h
        STOSW
        MOV     AL,0ECh
        STOSB
        CALL    UpdateProgIP
        MOV     [BlockBak1],DI
        JMP     LocalDirecArgsOK
LocalDirecx86:
        MOV     AL,8
        JZ      LocalDirecx86OK
        OR      AL,4
LocalDirecx86OK:
        OR      BYTE [ProcFlags],AL
        MOV     AL,55h
        STOSB
        MOV     AX,0EC8Bh
        STOSW
        CALL    UpdateProgIP
        MOV     [BlockBak1],DI
LocalDirecArgsOK:
        MOV     DI,OFFSET BlockBak1
        PUSH    DS
        POP     ES
        XOR     AX,AX
        MOV     [Temp4],AX
        STOSW
        STOSW
        TEST    BYTE [ProcFlags],10h
        JNZ     LocalDirec2
        STOSW
        STOSW
LocalDirec2:
        MOV     DI,OFFSET Temp1
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     BYTE [InstrPresent],AL
        MOV     BYTE [Error],127
        MOV     AL,[AddrMode]
        MOV     AH,AL
        ADD     AH,AH
        OR      AL,80h
        MOV     WORD [Temp1],AX
        JMP     LocalDirecLoop

LocalDirecKW:
        CMP     DL,DataType
        JNZ     LocalDirecInvalidArg
        MOV     AL,1
        CMP     DH,_BYTE
        JZ      LocalDirecKW2
        MOV     AL,DH
        MOV     BX,OFFSET OpSizeTable-1
        XLAT
LocalDirecKW2:
        MOV     BYTE [Temp2],AL
        MOV     CH,DH
        OR      CH,080h
        JMP     LocalDirecWrite
LocalDirecInvalidArg:
        JMP     InvalidOperand
LocalDirecDupDef:
        JMP     DupDef
LocalDirecLoop:
        CALL    GetNext
        CMP     AL,EndOfLine
        JZ      LocalDirecDone
        MOV     CL,0
        CMP     AL,Colon
        JZ      LocalDirecGetType
        CMP     AL,Keyword
        JZ      LocalDirecKW
        CMP     AH,Identifier
        JNZ     LocalDirecInvalidArg
        CMP     AL,UnknownID
        JNZ     LocalDirecDupDef
        MOV     CL,[StrLen]
        CMP     BYTE [NextChar],Colon
        JNZ     LocalDirecWriteDefType
        INC     WORD [InBufferPtr]
LocalDirecGetType:
        PUSH    CX,DI,BP
        CALL    GetNext
        POP     BP,DI,CX
        CMP     AL,CPUInstruction
        JZ      LocalInstr
        CMP     AL,Keyword
        JZ      LocalDirecKW
        CMP     AH,Identifier
        JNZ     LocalDirecInvalidArg
        CMP     AL,StructID OR 80h
        JZ      LocalDIrecStructType
LocalDirecLabel:
        MOV     CH,LabelID OR 80h
        MOV     AL,[AddrMode]
        ADD     AL,AL
        MOV     BYTE [Temp2],AL
        JMP     LocalDirecWrite
LocalInstr:
        JMP     LocalInstr2
LocalDirecWriteDefType:
        MOV     CH,BYTE [Temp1]
        MOV     AL,[Temp1][1]
        MOV     BYTE [Temp2],AL
LocalDirecWrite:
        INC     WORD [Temp4]
        MOV     SI,OFFSET BlockBak2
        MOV     AX,[Temp2]
        SUB     WORD [SI],AX
        SBB     WORD [SI][2],0
        TEST    CL,CL
        JZ      LocalDirecLoop
        CALL    WriteLocalSymbol
        MOV     BYTE [Temp2+1],0
        JMP     LocalDirecLoop
LocalDirecDone:
        MOV     BYTE [Error],0
        JMP     LocalDirecDone2
LocalDirecStructType:
        LES     SI,DWORD [SymPos]
        MOV     AX,WORD ES:[SI][4]
        MOV     WORD [Temp2],AX
        MOV     CH,LabelID OR 80h
        JMP     LocalDirecWrite
LocalDirecDoneNoArgs:
        JMP     AssembleDone2
LocalDirecDone2:
        CMP     WORD [Temp4],1
        MOV     AL,0FFh
        ADC     AL,0
        AND     AL,10h
        JZ      LocalDirecDoneNoArgs
        OR      BYTE [ProcFlags],AL
        MOV     BX,1
        MOV     BYTE [Error],0
        LES     DI,[OBufferPtr]
        TEST    DI,DI
        JZ      LocalDirecDone3
        TEST    BYTE [ProcFlags],10h
        JZ      LocalDirecDone3
LocalDirecDone3:
        MOV     AX,0EC81h
        MOV     DX,WORD [BlockBak2]
        TEST    BYTE [ProcFlags],4
        JNZ     LocalDirec8086
        TEST    BYTE [ProcFlags],40h
        JZ      LocalDirecDone4
        MOV     BYTE ES:[DI],48h
        INC     DI
LocalDirecDone4:
        STOSW
        MOV     AX,0
        SUB     AX,DX
        STOSW
        PUSH    AX
        MOV     DX,WORD [BlockBak2][2]
        MOV     AX,0
        SBB     AX,DX
        STOSW
        POP     DX
        CMP     AX,0FFFFh
        JZ      LocalDirecDone5
        TEST    AX,AX
        JNZ     LocalDirecDone6
        CMP     DH,0
        JNZ     LocalDirecDone6
        MOV     AX,DX
        MOV     BL,3
        JMP     LocalDirecTest8b
LocalDirecDone5:
        CMP     DH,0FFh
        JNZ     LocalDirecDone6
        MOV     AX,DX
        MOV     BL,3
        JMP     LocalDirecTest8b
LocalDirec8086:
        STOSW
        MOV     AX,DX
        NEG     AX
        STOSW
LocalDirecTest8b:
        CMP     AX,127
        JG      LocalDirecDone6
        CMP     AX,-128
        JL      LocalDirecDone6
        SUB     DI,BX
        ADD     BYTE ES:[DI-3],2
LocalDirecDone6:
        MOV     WORD [BlockBak1],DI
        JMP     AssembleDone

LocalInstrInvalid:
        JMP     InvalidOperand
LocalInstrNumTooBig:
        JMP     NumTooBig
LocalInstr2:
        MOV BYTE [Temp2],1
        CMP DX,(DBDirective)
        JB  LocalInstrInvalid
        CMP DX,(DODirective)
        JA  LocalInstrInvalid
        MOV BX,DX
        MOV CH,[BX][4]
        OR  CH,80h
        MOV     AL,[NextChar]
        CMP     AL,Comma
        JZ      LocalInstrGetInstr
        PUSH    CX,BX,DI,BP
        CALL    GetOperand
        POP BP,DI,BX,CX
        CMP AL,EndOfLine
        JZ  LocalInstrGetInstr
        CMP AH,Number
        JNZ LocalInstrInvalid
        CMP AL,Num16
        JA  LocalInstrNumTooBig
        MOV [Temp2],DX
LocalInstrGetInstr:
        MOV AL,[BX][4]
        CMP AX,ByteID
        JZ  LocalInstrDone
        CMP AL,WordID
        JZ  LocalInstrDW
        CMP AL,DWordID
        JZ  LocalInstrDD
        CMP AL,FWordID
        JZ  LocalInstrDF
        CMP AL,TWordID
        JZ  LocalInstrDT
        CMP BX,QWordID
        JZ  LocalInstrDQ
        CMP BX,OWordID
        JZ  LocalInstrDO
LocalInstrDone:
        JMP LocalDirecWrite

LocalInstrDW:
        MOV AX,2
        JMP LocalInstrMUL
LocalInstrDD:
        MOV AX,4
        JMP LocalInstrMUL
LocalInstrDF:
        MOV AX,6
        JMP LocalInstrMUL
LocalInstrDQ:
        MOV AX,8
        JMP LocalInstrMUL
LocalInstrDT:
        MOV AX,10
        JMP LocalInstrMUL
LocalInstrDO:
        MOV AX,16
        JMP LocalInstrMUL
LocalInstrMUL:
        MUL WORD [Temp2]
        MOV [Temp2],AX
        JMP LocalDirecWrite
