OpenNE16Format	PROC
        MOV AX,[neRelocSeg]
        TEST    AX,AX
        JNZ OpenNE16MemOK
        MOV BX,1000h
        CALL    AllocateMem
        JNC     OpenNE16MemOK
        MOV     BYTE [Error],QuitError
        MOV     SI,OFFSET _NotEnoughMem
        CALL    PrintError
        MOV     BYTE [Msg],EndOfFile
        MOV     SP,WORD [AsmStack]
        JMP     AssembleEndOfFile
OpenNE16MemOK:    
        MOV [neRelocSeg],AX
        MOV WORD [OutFlags],0100h
        XOR AX,AX
        MOV [neRelocPTR],AX
        MOV [neSeg],AX
        MOV [neSegAttr],AX
        MOV WORD [neShift],9
        MOV WORD [neHeapSize],1
        MOV WORD [neSegTable],40h
        MOV WORD [neFlags],030Ah
        MOV WORD [SegAlignment],200h
        MOV WORD [neStubSize],80h
        MOV BYTE [CurSeg], SEGMENT_NONE
        MOV BYTE [CurSeg][3], SEGMENT_NONE
        OR  BYTE [RefFlags],80h
        MOV WORD [neWinVersion],300h
        MOV WORD [neTargetOS],2
        RET
OpenNE16Format	ENDP

CloseNE16File	PROC
        MOV     BX,[OutHandle]
        MOV     DX,[neStubSize]
        ADD     DX,40h
        XOR     CX,CX
        MOV     AL,0
        CALL    FSeek
        MOV     DX,OFFSET neSegTableBuffer
        MOV     AX,[neSegEntries]
        MOV     CL,3
        SHL     AX,CL
        MOV     CX,AX
        MOV     BX,DX
        ADD     BX,CX
        MOV     WORD [BX],0
        MOV     WORD [BX][2],0
        ADD     CX,4
        MOV     BX,[OutHandle]
        CALL    FWrite
        MOV     AL,2
        XOR     CX,CX
        MOV     DX,CX
        CALL    FSeek
        ADD     [BytesWritten],AX
        ADC     [BytesWritten][2],DX
		XOR	BX,BX
		XCHG BX,[OutHandle]
        CALL    FClose
        CALL    PrintOutFile
        RET
CloseNE16File   ENDP

NE16Reloc	PROC
        MOV     DX,[RelocFlags]
        XOR     CX,CX
        TEST    BYTE DH,1
        JNZ     NE16Reloc2
        TEST    DL,16
        JNZ     NE16RelocPTR
        TEST    DL,80h
        JNZ     NE16RelocSeg
        MOV     CL,13
        TEST    DL,8
        JNZ     NE16Reloc2
        MOV     CL,5
        JMP     NE16Reloc2
NE16RelocPTR:
        MOV     WORD [SI],0FFFFh
        MOV     CL,11
        TEST    DL,8
        JNZ     NE16Reloc2
        MOV     CL,3
        JMP     NE16Reloc2
NE16Reloc8B:
        MOV     CL,0
        JMP     NE16Reloc2
NE16RelocSeg:
        MOV     CL,2
        MOV     WORD [SI],0FFFFh
NE16Reloc2:
        TEST    DL,20h
        JZ      NE16Reloc3
NE16RelocExt:
        MOV     CH,1
        TEST    WORD [RelocData],8000h
        JZ      NE16Reloc3
        INC     CH
NE16Reloc3:
        PUSH    DI,ES
        MOV     BX,DI
        LES     DI,[neRelocPTR]
        MOV     AX,CX
        STOSW
        MOV     AX,BX
        XOR     BX,BX
        ADD     AX,[FileSize]
        ADC     BX,[FileSize][2]
        SUB     AX,[neSegStart]
        SBB     AX,[neSegStart][2]
        STOSW
        MOV     AX,[RelocData]
        MOV     CX,[RelocData][2]
        TEST    DL,20h
        JZ      NE16Reloc4
        TEST    AH,80h
        JZ      NE16Reloc4
        AND     AH,NOT 80h
NE16Reloc4:
        STOSW
        MOV     AX,CX
        STOSW
        MOV     [neRelocPTR],DI
        MOV     BYTE [RelocFlags],0
        POP ES,DI
        RET
NE16Reloc	ENDP
		

InitNE16	PROC
		JMP	ine16Start
InitNE16Pass1:
        OR  BYTE [RefFlags],16
        MOV WORD [neSegEntries],0
        MOV WORD [neRelocPTR],0
        RET
ine16Start:	
        CMP WORD [Pass],1
        JZ  InitNE16Pass1
        LES DI,[neRelocPTR]
        CMP WORD [neRes],0
        JNZ InitNE16ResOK
        MOV SI,OFFSET Files
        MOV [neRes],DI
        MOV AX,[FileLen]
        MOV CX,AX
        STOSB
        REP MOVSB
        ADD AX,4
        MOV [neResSize],AX
        XOR AX,AX
        STOSW       ;NULL Ordinal
        STOSB       ;END baba
InitNE16ResOK:
        CMP WORD [neNonRes],0
        JNZ InitNE16NonResOK
        MOV [neNonRes],DI
        MOV SI,OFFSET OutFile
        MOV AX,[OutFileLen]
        MOV CX,AX
        STOSB
        REP MOVSB
        ADD AX,4
        MOV [neNonResSize],AX
        XOR AX,AX
        STOSW       ;NULL Ordinal
        STOSB       ;END baba
InitNE16NonResOK:
        CMP WORD [neEntry],0
        JNZ InitNE16EntryOK
        MOV [neEntry],DI
        MOV AL,0
        STOSB
        MOV [neEntrySize],1
InitNE16EntryOK:
        CMP WORD [neInitSS],0
        JNZ InitNE16SSOK
        MOV AX,[neAutoSeg]
        MOV [neInitSS],AX
InitNE16SSOK:
        MOV SI,OFFSET DosStub
        LES DI,[OBufferPTR]
        MOV CX,[neStubSize]
        REP MOVSB
        MOV BX,DI
        MOV AX,"EN"
        STOSW
        MOV AX,0407h
        STOSW
        PUSH    DI
        ADD DI,2
        MOV AX,[neEntrySize]
        STOSW
        XOR AX,AX
        STOSW
        STOSW
        MOV SI,OFFSET neFlags
        MOV CX,11
        REP MOVSW
        MOV AX,40h
        STOSW
        MOV BX,[neSegEntries]
        MOV CL,3
        SHL BX,CL
        PUSH    BX
        ADD AX,BX
        ADD AX,4
        STOSW
        ADD AX,[neResourceSize]
        STOSW
        ADD AX,[neResSize]
        STOSW
        MOV BX,[neModRefEntries]
        ADD AX,BX
        ADD AX,BX
        STOSW
        ADD AX,[neImportsSize]
        ADD AX,[neStubSize]
        ADD AX,[neEntrySize]
        STOSW
        XOR AX,AX
        STOSW
        MOV SI,OFFSET neMovable
        MOV CX,8
        REP MOVSW
        MOV WORD ES:[DI-4],CX
        MOV SI,OFFSET neSegTableBuffer
        POP CX
        REP MOVSB
        XOR AX,AX
        STOSW
        STOSW
        PUSH    WORD [neNonResSize]
        PUSH    WORD [neNonRes]
        PUSH    WORD [neEntrySize]
        PUSH    WORD [neEntry]
        PUSH    WORD [neStubSize]
        PUSH    WORD [neImportsSize]
        PUSH    WORD [neImports]
        PUSH    WORD [neModRefEntries]
        PUSH    WORD [neModRef]
        PUSH    WORD [neResSize]
        PUSH    WORD [neRes]
        PUSH    WORD [neResourceSize]
        PUSH    WORD [neResource]
        MOV     DS,[neRelocSeg]

        POP SI      ;RESOURCE
        POP CX      ;SIZE
        REP MOVSB

        POP SI      ;Res
        POP CX      ;SIZE
        REP MOVSB

        POP SI      ;ModRef
        POP CX      ;SIZE
        REP MOVSW

        POP SI      ;Imports
        POP CX      ;SIZE
        REP MOVSB

        MOV DX,DI
        POP BX
        SUB DX,BX   ;StubSize

        POP SI      ;Entry
        POP CX      ;SIZE
        REP MOVSB

        POP SI      ;NonRes
        POP CX      ;SIZE
        REP MOVSB

        MOV CX,AsmData
        MOV DS,CX
        MOV [OBufferPTR],DI
        POP DI
        MOV AX,DX
        STOSW
        CALL    SegmentAlign
        MOV WORD [neSegEntries],0
        RET
InitNE16	ENDP


CloseNE16Seg	PROC
        CMP     WORD [neSeg],0
        JZ      cne16SegQuit
        MOV     DI,[neSegEntries]
        MOV     CL,3
        SHL     DI,CL
        ADD     DI,OFFSET neSegTableBuffer
        MOV     BX,[SegAlignment]
        DEC     BX
        MOV     AX,BX
        XOR     DX,DX
        ADD     AX,[neSegStart]
        ADC     DX,[neSegStart][2]
        INC     BX
        CALL    Div32
        STOSW               ;SEGMENT start
        MOV     AX,[FileSize]
        MOV     DX,[FileSize][2]
        ADD     AX,[OBufferPTR]
        ADC     DX,0
        SUB     AX,[neSegStart]
        SBB     DX,[neSegStart][2]
        PUSH    DX
        STOSW               ;Length
        MOV     AX,[neSegAttr]
        STOSW
        MOV     AX,[DI-4]
        ADD     AX,[UninitData]
        ADC     DX,[UninitData][2]
        STOSW
        POP     AX
        OR      DX,AX
        CMP     BYTE [CurSeg],SEGMENT_STACK
        JNZ     cne16SegStackOK
        CMP     WORD [neInitSS],0
        JNZ     cne16SegStackOK
        MOV     [neInitSP],AX
        MOV     AX,[neSeg]
        MOV     [neInitSS],AX
        XOR     AX,AX

        MOV [ProgIP],AX
        MOV [ProgIP][2],AX
        MOV [ProgIP][4],AX
        MOV [ProgIP][6],AX

        MOV     [UninitData],AX
        MOV     [UninitData][2],AX
		JMP		cne16SegStackOK
cne16SegQuit:
        RET
cne16SegStackOK:
        PUSH    DX
        CMP     WORD [neRelocPTR],0
        JZ      cne16RelocOK
        OR      BYTE [DI-3],1
        LES     DI,[OBufferPTR]
        LDS     SI,[neRelocPTR]        
        MOV     AX,SI
        MOV     CL,3
        SHR     AX,CL
        STOSW
        MOV     CX,SI
        XOR     SI,SI
        CALL    WriteStrChain1
        MOV     AX,AsmData
        MOV     DS,AX
        MOV     ES,AX
        MOV     [OBufferPTR],DI
cne16RelocOK:
        POP     DX
        INC     WORD [neSegEntries]
        XOR     AX,AX
        MOV     [neSegAttr],AX
        TEST    DX,DX
        JNZ     cne16SegOverflow
        RET

cne16SegOverflow:
        INC     WORD [neSegEntries]
        MOV     BYTE    [Error],80h
        MOV     SI,OFFSET _ProgIPOverflow
        CALL    PrintError        
        RET
CloseNE16Seg	ENDP


ImportNE16	PROC
        MOV AX,[OutFlags]
        AND AX,101h
        CMP AX,100h
        JNZ ImportInvalidKW
        LES DI,[OBufferPtr]
        TEST    DI,DI
        JNZ ImportInvalidKW
        CMP     BYTE [CurSeg],SEGMENT_NONE
        JNZ ImportInvalidKW
        AND     BYTE [OutFlags][1],NOT 1
        MOV [neModRefEntries],DI    ;Initialize count
        MOV DI,1000
        MOV AL,0
        STOSB
        MOV WORD [Temp5],DI
GetLib:
        CALL    GetNext
        CMP AX,Quote
        JNZ ImportLibExpected
        MOV BX,[neModRefEntries]      ;Module Ref Pointer
        CMP BX,1000
        JAE LibsOverflow
        MOV ES,[DiskOutSeg]
        MOV DI,[Temp5]
        LEA AX,[DI][-1000]
        MOV WORD ES:[BX],AX
        ADD BX,2
        MOV AX,BX
        SHR AX,1
        MOV [Temp1],AX
        MOV WORD [neModRefEntries],BX
        MOV SI,OFFSET StrBuffer
        MOV AX,DX
        MOV CX,AX
        STOSB
        REP MOVSB
        MOV [Temp5],DI
        MOV BYTE [Temp4],LocalID
        JMP GetLibNames
GetLibsInstr:
        CMP DX,OFFSET (EndDirective)
        JZ  GetLibsDone
        CMP DX,OFFSET (ImportDirective)
        JZ  GetLib
ImportInvalidKW:
        MOV SI,OFFSET _InvalidOperand
        JMP     PrtErrorQuit
ImportIDExpected:
        MOV SI,OFFSET _LabelExpected
        CALL    PrtErrorRet
        JMP     GetLibNames
ImportLibExpected:
        MOV SI,OFFSET _InvalidOperand
        CALL    PrtErrorRet
        JMP     GetLibNames
ImportDupDef:
        MOV SI,OFFSET _DupDef
        CALL    PrtErrorRet
        MOV     SI,OFFSET StrBuffer
        MOV     CX,[StrLen]
        CALL    PrintStrFixed
        JMP     GetLibNames
LibsOverflow:
        JMP HeaderLarge
GetLibsDone:
        JMP GetLibsDone2
LibNumTooBig:
        MOV SI,OFFSET _NumTooBig
        CALL    PrtErrorRet
        JMP     GetLibNames
GetLibNext:
        ADD WORD [LineNumber],1
        ADC WORD [LineNumber][2],0
        CMP BYTE [Msg],EndOfFile
        JZ  GetLibsDone
        MOV BYTE [EOLFlag],0
GetLibNames:
        CALL    GetNext
        CMP AL,EndOfLine
        JZ  GetLibNext
        CMP AX,CPUInstruction
        JZ  GetLibsInstr
        CMP AH,Identifier
        JNZ ImportIDExpected
        TEST    BYTE [RefFlags],8
        JNZ GetLibNamesOK
        CMP AL,UnknownID
        JNZ ImportDupDef
GetLibNamesOK:
        PUSH    AX,DI,BP
        PUSH    WORD [StrLen]
        CALL    GetNext
        MOV BX,[Temp1]
        CMP AH,Number
        JZ  LibOrdinal
        CMP AX,Quote
        JNZ ImportLibExpected
        MOV CX,DX
        OR  BH,80h
        MOV ES,[DiskOutSeg]
        MOV DI,[Temp5]
        MOV SI,CX
        INC SI
        JZ  LibsOverflow
        ADD SI,DI
        JC  LibsOverflow
        MOV SI,OFFSET StrBuffer
        LEA DX,[DI-1000]
        MOV AL,CL
        STOSB
        REP MOVSB
        MOV [Temp5],DI
        JMP LibGetType
LibOrdinal:
        CMP AL,Num16
        JA  LibNumTooBig
LibGetType:
        POP AX
        MOV CL,AL
        MOV SI,(OWordNum)
        MOV [SI][4],BX
        MOV [SI][6],DX
        CMP BYTE [NextChar],Colon
        JNZ LibWriteType
        INC WORD [InBufferPtr]
LibWriteType:
        POP BP,DI,AX
        CMP AL,UnknownID
        JNZ GetLibNames
        MOV CH,[Temp4]
        MOV WORD [SI],FMT_EXTERN
        CALL    WriteSymbol
        JMP GetLibNames
GetLibsOverflow:
        JMP HeaderLarge
GetLibsDone2:
        SHR [neModRefEntries],1
GetLibsWriteImport:
        MOV DI,[neRelocPTR]
        MOV CX,[neModRefEntries]
        MOV AX,[Temp5]
        SUB AX,1000
        ADD AX,CX
        ADD AX,CX
        ADD AX,DI
        JC  GetLibsOverflow
        XOR SI,SI
        PUSH    DS
        MOV [neModRef],DI
        MOV DX,[Temp5]
        MOV ES,[neRelocSeg]
        MOV DS,[DiskOutSeg]
        REP MOVSW
        MOV BX,DI
        MOV SI,1000
        SUB DX,SI
        MOV CX,DX
        REP MOVSB
        MOV AL,0
        STOSB
        POP DS
        INC DX
        MOV [neImports],BX
        MOV [neImportsSize],DX
        MOV [neRelocPTR],DI
        JMP AssembleDone2
ImportNE16	ENDP

ExportNE16	PROC
        JMP AssembleDone2
ExportNE16	ENDP


EndNE16	PROC
        MOV [neInitIP],DX
        MOV AX,[neSeg]
        TEST    BYTE [Settings],1
        JZ  EndNE16AddrOK
        MOV AX,[OWordNum][-2]
EndNE16AddrOK:
        MOV [neInitCS],AX
        RET
EndNE16	ENDP


GetSegAddrNE16	PROC
        MOV     AX,[neSeg]
        INC AX
        STC
        RET
GetSegAddrNE16	ENDP


NE16SegClass	PROC
        PUSH    DS
        POP ES
        MOV     AX,[SI]
        MOV     DX,[SI][2]
        OR      AX,2020h
        OR      DX,2020h
        CMP     CX,5
        JZ      NE16StackClass
        CMP     CX,4
        JA      NE16SegClassDone
        CMP     AX,"ad"
        JZ      NE16DataClass
        CMP     AX,"ua"
        JNZ     NE16SegClassDone
        CMP     DX,"ot"
        JNZ     NE16SegClassDone
        CMP     WORD [neAutoSeg],0
        JNZ     NE16SegClassData2
        MOV     AX,[neSeg]
        INC     AX
        MOV     [neAutoSeg],AX
        JMP     NE16SegClassData2
NE16StackClass:
        CMP     AX,"ts"
        JNZ     NE16SegClassDone
        CMP     DX,"ca"
        JNZ     NE16SegClassDone
        MOV     AL,[SI][4]
        OR      AL,20h
        CMP     AL,"k"
        JNZ     NE16SegClassDone
        MOV     BYTE [CurSeg],SEGMENT_STACK
        OR      BYTE [neSegAttr],1
        RET
NE16DataClass:
        CMP     DX,"at"
        JNZ     NE16SegClassDone
NE16SegClassData2:
        MOV     BYTE [CurSeg],SEGMENT_DATA
        OR      BYTE [neSegAttr],1
NE16SegClassDone:
        RET
NE16SegClass	ENDP


NE16InitSeg	PROC
        XOR     AX,AX
        MOV     [UninitData],AX
        MOV     [UninitData][2],AX

        MOV     AX,[neSeg]
        INC     AX
        MOV     [neSeg],AX
        MOV     [ProgIP][-2],AX
        MOV     AX,WORD [FileSize]
        MOV     DX,WORD [FileSize][2]
        ADD     AX,[OBufferPTR]
        ADC     DX,0
        MOV     [neSegStart],AX
        MOV     [neSegStart][2],DX
        CMP     BYTE [CurSeg],SEGMENT_DATA
        JNZ     NE16SegOK
        OR      BYTE [neSegAttr],1
NE16SegOK:
        MOV WORD [neRelocPTR],0
        STC
        RET
NE16InitSeg	ENDP

ImportSegNE16	PROC
        CLC
        RET
ImportSegNE16	ENDP

ExportSegNE16	PROC
        CLC
        RET
ExportSegNE16	ENDP

CodeSegNE16	PROC
        CLC
        RET
CodeSegNE16	ENDP

ResSegNE16	PROC
        CLC
        RET
ResSegNE16	ENDP

NotPagedSegNE16	PROC
        CLC
        RET
NotPagedSegNE16	ENDP

DiscardableSegNE16	PROC
        CLC
        RET
DiscardableSegNE16	ENDP

ConformingSegNE16	PROC
        CLC
        RET
ConformingSegNE16	ENDP

ExecutableSegNE16	PROC
        CLC
        RET
ExecutableSegNE16	ENDP

ShareableSegNE16	PROC		
        CLC
        RET
ShareableSegNE16	ENDP

WritableSegNE16	PROC
        CLC
        RET
WritableSegNE16	ENDP


DataSegNE16	PROC        
		CLC
        RET
DataSegNE16	ENDP


AutoSegNE16	PROC			
        MOV     AX,[neSeg]
        INC     AX
        MOV     [neAutoSeg],AX
        CLC
        RET
AutoSegNE16	ENDP

IOPLSegNE16	PROC
        CLC
        RET
IOPLSegNE16	ENDP

MovableSegNE16	PROC
        CLC
        RET
MovableSegNE16	ENDP


PreloadSegNE16	PROC
        CLC
        RET
PreloadSegNE16	ENDP


ReadableSegNE16	PROC
        CLC
        RET
ReadableSegNE16	ENDP


NE16Stack	PROC
        CMP     AL,Num16
        JA      NE16StackTooBig
        MOV     [neStackSize],DX
        JMP     AssembleDone2
        
NE16StackTooBig:
        JMP     NumTooBig

NE16Stack	ENDP
