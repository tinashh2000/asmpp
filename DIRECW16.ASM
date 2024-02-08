DirectivesWStart:

DUWriteUninit:
        CALL    WriteUninitData
        MOV     AL,BYTE [OWordNum]
        STOSB
        JMP     DUDirecGetNext

DUUseDB:
        MOV     SI,OFFSET _DUForUnicode
        JMP     PrtError

DUDirec:
        OR      BYTE [Settings][1],3
        MOV     BYTE [Temp1],0
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DUDirec1:
        CMP     AL,CPUInstruction
        JZ      DUInstr
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,Quote
        JZ      DUQuote
        CMP     AL,Question
        JZ      DUReserve
        CMP     AH,Number
        JNZ     DUNumExpected
        CMP     AL,Num16
        JA      DUNumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DUWriteUninit
        MOV     AX,DX
        STOSW
DUDirecGetNext:
        CMP     DI,0FFFAh
        JAE     DUDirecFlush
DUDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DUDirec1
        CMP     AL,EndOfLine
        JZ      DUDone
        CMP     AL,Keyword
        JNZ     DUNumExpected
        JMP     AssembleDone
DUReserve:
        JMP     DUUseDB

DUNumTooBig:
        JMP     NumTooBig
DUNumExpected:
        JMP     NumExpected
DUDone:
        JMP     AssembleDone
DUInstr:        
        CMP     DX,OFFSET DUPDirective
        JNZ     DUNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DUNumExpected
        JMP     DUUseDB

DUQuote:
        TEST    DX,DX
        JZ      DUDirecGetNext
        MOV     CX,DX
        MOV     SI,OFFSET StrBuffer
        CALL    WriteUnicodeStrChain
        JMP     DUDirecGetNext
DUDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DUDirecBufferOK

DxDirecDupDef:
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        MOV     SI,OFFSET ProgIP
        ADD     DI,4
        MOV     DL,CL
        MOV     CX,2
        REPZ    CMPSW
        JNZ     DxDirecDupDef2
        TEST    DL,40h
        JZ      DxDirecInvoke
        MOV     CX,2
        REPZ    CMPSW
        JZ      DxDirecInvoke
DxDirecDupDef2:
        JMP     DupDef
DxDirecID:        
        TEST    SI,SYM_UNDEF
        JNZ     DxDirecExists
        TEST    BYTE [RefFlags],8
        JNZ     DxDirecExists
        CMP     CL,UnknownID
        JNZ     DxDirecDupDef
DxDirecID2:
        MOV     CL,CH
        MOV     CH,BYTE [BX][4]
        PUSH    BX
        MOV     SI,OFFSET ProgIP-4
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]
        CALL    WriteSymbol
        POP     BX
        JMP     DxDirecInvoke
DxDirecExists:
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI].seIDFlags,NOT SYM_UNDEF
        TEST    BYTE ES:[DI].seIDFlags,FMT_PUBLIC
        JZ      DxDirecWrite
        MOV     SI,OFFSET StrBuffer+256
        PUSH    CX,BX
        PUSH    DS
        POP     ES
        CALL    PublicDef
        POP     BX,CX
        LES     DI,DWORD [SymPos]
DxDirecWrite:
        CALL    OverwriteSymbolAddressChk
DxDirecInvoke:
        CMP     BYTE [NextChar],Char0A
        JZ      DxDirecDone
        CMP     BYTE [NextChar],SemiColon
        JZ      DxDirecDone
        LES     DI,[OBufferPtr]
        MOV     DX,WORD [BX]
        JMP     WORD [BX]
DxDirecDone:
        JMP     AssembleDone2
DxDirecMismatch:
        PUSH    BX,DI
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _RefMismatch
        CALL    PrintError
        POP     DI,BX
        JMP     DxDirecWrite
DBWriteUninit:        

        CALL    WriteUninitData

        MOV     AL,BYTE [OWordNum]
        STOSB
        JMP     DBDirecGetNext

DBDirec:
        OR      BYTE [Settings][1],3
        MOV     BYTE [Temp1],0

        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DBDirec1:
        CMP     AL,CPUInstruction
        JZ      DBInstr
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,Quote
        JZ      DBQuote
        CMP     AL,Question
        JZ      DBReserve
        CMP     AH,Number
        JNZ     DBNumExpected
        CMP     AL,Num8
        JA      DBNumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DBWriteUninit

        MOV     AL,DL
        STOSB
DBDirecGetNext:
        CMP     DI,0FFFAh
        JAE     DBDirecFlush
DBDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DBDirec1
        CMP     AL,EndOfLine
        JZ      DBDone
        CMP     AL,Keyword
        JNZ     DBNumExpected
        JMP     AssembleDone
DBReserve:
        MOV     CX,1
        CALL    ReserveData16
        JMP     DBDirecGetNext
DBReserve2:
        CALL    ReserveData
        JMP     DBDirecGetNext
DBNumTooBig:
        JMP     NumTooBig
DBNumExpected:
        JMP     NumExpected
DBDone:
        JMP     AssembleDone
DBQuote:
        TEST    DX,DX
        JZ      DBDirecGetNext
        MOV     CX,DX
        MOV     SI,OFFSET StrBuffer
        CALL    WriteStrChain
        JMP     DBDirecGetNext

DBInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DBNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DBNumExpected
        MOV     BYTE [Temp1],0

        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DBReserve2
        CMP     AH,Number
        JNZ     DBNumExpected
        CMP     AL,Num8
        JNZ     DBNumTooBig

        CALL    WriteMultiBytes
        JMP     DBDirecGetNext
DBDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DBDirecBufferOK
DDWriteUninit:
        CALL    WriteUninitData
        CALL    Write32Imm
        JMP     DDDirecGetNext

DDNumTooBig:
        JMP     NumTooBig
DDNumExpected:
        JMP     NumExpected

DDDirec:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DDDirec1:
        CMP     AL,CPUInstruction
        JZ      DDInstr
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,Question
        JZ      DDReserve
        CMP     AH,Number
        JNZ     DDNumExpected
        CMP     AL,Num32
        JA      DDNumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DDWriteUninit
        CALL    Write32Imm
DDDirecGetNext:
        CMP     DI,0FFFAh-4
        JAE     DDDirecFlush
DDDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DDDirec1
        CMP     AL,EndOfLine
        JZ      DDDone
        CMP     AL,Keyword
        JNZ     DDNumExpected
        JMP     AssembleDone
DDReserve:
        MOV     CX,4
        CALL    ReserveData16
        JMP     DDDirecGetNext
DDReserve2:
        MOV     AX,CX
        MOV     DX,BX
        MOV     CX,4
        CALL    __mul32
        MOV CX,AX
        MOV BX,DX
        CALL    ReserveData
        JMP     DDDirecGetNext
DDDone:
        JMP     AssembleDone
DDInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DDNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DDNumExpected
        MOV     BYTE [Temp1],0
        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DDReserve2
        CMP     AH,Number
        JNZ     DFNumExpected
        CMP     AL,Num32
        JA      DFNumTooBig
        MOV     AX,4
        CALL    WriteMultiWords
        JMP     DDDirecGetNext
DDDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DDDirecBufferOK
DFWriteUninit:
        CALL    WriteUninitData
        MOV     AX,WORD [OWordNum]
        JMP     DFWrite2
DFDirec:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DFDirec1:
        CMP     AL,CPUInstruction
        JZ      DFInstr
        CMP     AL,Question
        JZ      DFReserve
        MOV     ES,WORD [DiskOutSeg]
        CMP     AH,Number
        JNZ     DFNumExpected
        CMP     AL,Num48
        JA      DFNumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DFWriteUninit
        MOV     AX,DX
DFWrite2:
        STOSW
        MOV     AX,WORD [OWordNum][2]
        STOSW
        MOV     AX,WORD [OWordNum][4]
        STOSW
DFDirecGetNext:
        CMP     DI,0FFFAh-6
        JAE     DFDirecFlush
DFDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DFDirec1
        CMP     AL,EndOfLine
        JZ      DFDone
        CMP     AL,Keyword
        JNZ     DFNumExpected
        JMP     AssembleDone
DFNumTooBig:
        JMP     NumTooBig
DFNumExpected:
        JMP     NumExpected
DFDone:
        JMP     AssembleDone
DFDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DFDirecBufferOK
DFReserve:
        MOV     CX,6
        CALL    ReserveData16
        JMP     DFDirecGetNext
DFReserve2:
        MOV     AX,CX
        MOV     DX,BX
        MOV     CX,6
        CALL    __mul32
        MOV CX,AX
        MOV BX,DX
        CALL    ReserveData
        JMP     DFDirecGetNext
DFInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DFNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DFNumExpected
        MOV     BYTE [Temp1],0

        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DFReserve2
        CMP     AH,Number
        JNZ     DQNumExpected
        CMP     AL,Num32
        JA      DQNumTooBig
        MOV     AX,6
        CALL    WriteMultiWords
        JMP     DFDirecGetNext
DQWriteUninit:
        CALL    WriteUninitData
        JMP     DQWrite2
DQDirec:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DQDirec1:
        CMP     AL,CPUInstruction
        JZ      DQInstr
        MOV     ES,WORD [DiskOutSeg]
        CMP     AL,Question
        JZ      DQReserve
        CMP     AH,Number
        JNZ     DQNumExpected
        CMP     AL,Num64
        JA      DQNumTooBig
;        CALL    Write64Imm2
        TEST    BYTE [RefFlags],80h
        JNZ     DQWriteUninit
DQWrite2:
        MOV     SI,OFFSET OWordNum
        MOVSW
        MOVSW
        MOVSW
        MOVSW
DQDirecGetNext:
        CMP     DI,0FFFAh-8
        JAE     DQDirecFlush
DQDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DQDirec1
        CMP     AL,EndOfLine
        JZ      DQDone
        CMP     AL,Keyword
        JNZ     DQNumExpected
        JMP     AssembleDone
DQNumExpected:
        JMP     NumExpected
DQNumTooBig:
        JMP     NumTooBig
DQDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DQDirecBufferOK
DQReserve:
        MOV     CX,8
        CALL    ReserveData16
        JMP     DQDirecGetNext
DQReserve2:
        MOV     AX,CX
        MOV     DX,BX
        MOV     CX,8
        CALL    __mul32
        MOV CX,AX
        MOV BX,DX
        CALL    ReserveData
        JMP     DQDirecGetNext

DQDone:
        JMP     AssembleDone
DQInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DQNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DQNumExpected
        MOV     BYTE [Temp1],0

        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DQReserve2
        CMP     AH,Number
        JNZ     DTNumExpected
        CMP     AL,Num32
        JA      DTNumTooBig
        MOV     AX,8
        CALL    WriteMultiWords
        JMP     DQDirecGetNext
DTWriteUninit:
        CALL    WriteUninitData
        JMP     DTWrite2
DTDirec:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DTDirec1:
        CMP     AL,CPUInstruction
        JZ      DTInstr
        CMP     AL,Question
        JZ      DTReserve
        MOV     ES,WORD [DiskOutSeg]        
        CMP     AH,Number
        JNZ     DTNumExpected
        CMP     AL,Num80
        JA      DTNumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DTWriteUninit
DTWrite2:
        MOV     SI,OFFSET OWordNum
        MOV     CX,5
        REP     MOVSW
DTDirecGetNext:
        CMP     DI,0FFFAh-10
        JAE     DTDirecFlush
DTDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DTDirec1
        CMP     AL,EndOfLine
        JZ      DTDone
        CMP     AL,Keyword
        JNZ     DTNumExpected
        JMP     AssembleDone
DTNumExpected:
        JMP     NumExpected
DTNumTooBig:
        JMP     NumTooBig
DTDone:
        JMP     AssembleDone
DTDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DTDirecBufferOK
DTReserve:
        MOV     CX,10
        CALL    ReserveData16
        JMP     DTDirecGetNext
DTReserve2:
        MOV     AX,CX
        MOV     DX,BX
        MOV     CX,10
        CALL    __mul32
        MOV CX,AX
        MOV BX,DX
        CALL    ReserveData
        JMP     DTDirecGetNext
DTInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DTNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DTNumExpected
        MOV     BYTE [Temp1],0
        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DTReserve2
        CMP     AH,Number
        JNZ     DWNumExpected
        CMP     AL,Num32
        JA      DWNumTooBig
        MOV     AX,10
        CALL    WriteMultiWords
        JMP     DTDirecGetNext
DWWriteUninit:
        CALL    WriteUninitData
        MOV     DX,WORD [OWordNum]
        CALL    Write16Imm2
        JMP     DWDirecGetNext
DWDirec:
    cmp word [LineNumber], 7
    jz DWDirec_br
    cmp word [LineNumber], 5728
    jnz DWDirec_1
DWDirec_br:    
;    int 3
    LFS AX, [InBufferPTR]
DWDirec_1:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DWDirec1:
        CMP     AL,CPUInstruction
        JZ      DWInstr
        CMP     AL,Question
        JZ      DWReserve
        MOV     ES,WORD [DiskOutSeg]
        CMP     AH,Number
        JNZ     DWNumExpected
        CMP     AL,Num16
        JA      DWNumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DWWriteUninit
        CALL    Write16Imm2
DWDirecGetNext:
        CMP     DI,0FFFAh-2
        JAE     DWDirecFlush
DWDirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DWDirec1
        CMP     AL,EndOfLine
        JZ      DWDone
        CMP     AL,Keyword
        JNZ     DWNumExpected
        JMP     AssembleDone
DWNumExpected:
        JMP     NumExpected
DWNumTooBig:
        JMP     NumTooBig
DWDirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DWDirecBufferOK
DWReserve:
        MOV     CX,2
        CALL    ReserveData16
        JMP     DWDirecGetNext
DWReserve2:
        ADD     CX,CX
        ADC     BX,BX
        CALL    ReserveData
        JMP     DWDirecGetNext
DWDone:
        JMP     AssembleDone
DWInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DWNumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DWNumExpected
        MOV     BYTE [Temp1],0

        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DWReserve2
        CMP     AH,Number
        JNZ     DONumExpected
        CMP     AL,Num32
        JA      DONumTooBig
        MOV     AX,2
        CALL    WriteMultiWords
        JMP     DWDirecGetNext
DOWriteUninit:
        CALL    WriteUninitData
        JMP     DOWrite2
DODirec:
        OR      BYTE [Settings][1],2
        CALL    GetOperand
        MOV     DI,WORD [OBufferPtr]
DODirec1:
        CMP     AL,CPUInstruction
        JZ      DOInstr
        CMP     AL,Question
        JZ      DOReserve
        MOV     ES,WORD [DiskOutSeg]
        CMP     AH,Number
        JNZ     DONumExpected
        CMP     AL,Num128
        JA      DONumTooBig
        TEST    BYTE [RefFlags],80h
        JNZ     DOWriteUninit
DOWrite2:
        MOV     SI,OFFSET OWordNum
        MOV     CX,8
        CLI
        REP     MOVSW
        STI
DODirecGetNext:
        CMP     DI,0FFFAh-16
        JAE     DODirecFlush
DODirecBufferOK:
        MOV     BYTE [CommaFlag],7Fh
        PUSH    DI
        CALL    GetOperand
        POP     DI
        AND     BYTE [CommaFlag],7Fh
        JZ      DODirec1
        CMP     AL,EndOfLine
        JZ      DODone
        CMP     AL,Keyword
        JNZ     DONumExpected
        JMP     AssembleDone
DONumExpected:
        JMP     NumExpected
DONumTooBig:
        JMP     NumTooBig
DODirecFlush:
        CALL    UpdateProgIP
        CALL    WriteOutFile
        MOV     DI,[OBufferPtr]
        JMP     DODirecBufferOK
DOReserve:
        MOV     CX,16
        CALL    ReserveData16
        JMP     DODirecGetNext
DOReserve2:
        MOV     AX,CX
        MOV     DX,BX
        MOV     CX,16
        CALL    __mul32
        MOV CX,AX
        MOV BX,DX
        CALL    ReserveData
        JMP     DODirecGetNext

DODone:
        JMP     AssembleDone

DOInstr:
        CMP     DX,OFFSET DUPDirective
        JNZ     DONumExpected
        CMP     BYTE [Temp1],90h
        JNZ     DONumExpected
        MOV     BYTE [Temp1],0

        PUSH    WORD [SaveNum],WORD [SaveNum][2],DI
        CALL    GetOperand
        POP     DI,BX,CX
        CMP     AL,Question
        JZ      DOReserve2
        CMP     AH,Number
        JNZ     DONumExpected
        CMP     AL,Num32
        JA      DONumTooBig
        MOV     AX,16
        CALL    WriteMultiWords
        JMP     DODirecGetNext

DUPDirec:
        JMP     NotCoded

InvokeLabelExp:
        JMP     LabelExpected

IncludeRCDirec:
        XOR BYTE [debug],1
        JMP AssembleDone2
IncludeLibDirec:
        JMP     NotCoded

IncludeBinDirec:

        MOV     AX,DS
        MOV     ES,AX
        CALL    GetStrFile
        CMP     DI,OFFSET StrBuffer
        JZ      IncludeInvalidFile
        XOR     AL,AL
        STOSB
        MOV     AL,0
        MOV     DX,OFFSET StrBuffer

        CALL    FOpen
        JC      IncludeBinPrtError
        MOV     [Temp1],AX
IncludeBinDirecCopyLoop:
        MOV     CX,0FFFFh
        MOV     BX,[Temp1]
        PUSH    DS
        LDS     DX,[OBufferPtr]
        SUB     CX,DX
        CALL    FRead
        POP DS
        JC      IncludeBinPrtError
        ADD     DX,AX
        MOV     DI,DX
        CALL    UpdateProgIP
        CMP     DI,0FFFAh
        JA      IncludeBinFlushOutput
        MOV     BX,[Temp1]
        CALL    FClose
        JMP     AssembleFile
IncludeBinFlushOutput:
        CALL    WriteOutFile
        JMP     IncludeBinDirecCopyLoop

IncludeBinPrtError:
        PUSH    AX
        MOV     BX,[Temp1]
        CALL    FClose    
        POP AX
        MOV     BYTE [Error],QuitError
        MOV     SP,WORD [AsmStack]
        JMP     PrintFileError
       
_LoadStub:
        CALL LoadStubFile,0
        JMP AssembleDone2

LoadStubFile    PROC fName:WORD

		MOV		DX,fName
		TEST	DX,DX
		JNZ		lsfFNameOK
		
        MOV     AL,BYTE [NextChar]
        SUB     AL,Colon
        CMP     AL,1
        ADC     WORD [InBufferPtr],0
        CALL    GetStrFile
        CMP     DI,OFFSET StrBuffer
        JZ      OptionStubInvalidFile
        MOV     AL,0
        STOSB
        MOV     DX,OFFSET StrBuffer
 lsfFNameOK:
		MOV	AL,0
        CALL    FOpen
        JC      LoadStubFError       
        MOV     BX,AX
        MOV     CX,32766
		MOV		DI,ES
        PUSH	DS
        LES     DX,[OBufferPtr]
        PUSH	ES
        POP	DS
        CALL    FRead
        POP	DS
        JC      LoadStubFError
        CMP     AX,32700
        JA      LoadStubInvalidFmt
        MOV     SI,DX
        MOV     AX,WORD ES:[SI]
        CMP     DI,"ZM"
        JZ      LoadStubMZ
        CMP     DI,"MZ"
        JZ      LoadStubMZ
LoadStubInvalidFmt:
        MOV     SI,_InvalidFmt
        JMP     PrtError

LoadStubFError:
        MOV     BYTE [Error],QuitError
        MOV     SP,WORD [AsmStack]
        JMP     PrintFileError

LoadStubMZ:
        MOV WORD [SI],"ZM"      ;Make sure its MZ not the other way
;        MOV     WORD [StubSize],AX
        ADD     DX,AX
        MOV     WORD [OBufferPtr],DX
        TEST    AL,0Fh
        JZ      LoadStub2
        MOV     BL,AL
        AND     BX,0Fh
        SUB     BL,16
        NEG     BL
        ADD     AX,BX
LoadStub2:
        MOV     WORD [OBufferPtr],AX        
        RET
LoadStubFile    ENDP

ResourceInvalidKW:
        JMP InvalidKeyword
ResourceDirec:
        TEST    BYTE [OutFlags],1
        JNZ ResourceInvalidKW
        LES DI,[OBufferPtr]
        TEST    DI,DI
        JNZ ResourceInvalidKW
        MOV [Temp1],DI
        MOV [Temp2],ES
        CALL    GetNext
        MOV WORD [neResourceAlign],9
        CMP AX,EndOfLine
        JZ  ResourceEOL
        CMP AH,Number
        JNZ ResourceNumExpec
        CMP AL,Num16
        JA  ResourceNumBig
        MOV WORD [neResourceAlign],DX
        JMP ResourceGetTypes
ResourceNumExpec:
        JMP ResourceNumExp
ResourceNumBig:
        JMP ResourceNumTooBig
ResourceInstr:
        CMP DX,OFFSET EndDirective
        JZ  ResourceEnd
        JMP ResourceInvalidOp
ResourceEnd:
        JMP ResourceEnd2
ResourceEOL:
        ADD WORD [LineNumber],1
        ADC WORD [LineNumber][2],0
        MOV BYTE [EOLFlag],0
        CMP BYTE [Msg],EndOfFile
        JZ  ResourceEnd
ResourceGetTypes:
        CALL    GetNext
        CMP AX,EndOfLine
        JZ  ResourceEOL
        CMP AX,CPUInstruction
        JZ  ResourceInstr
        CMP AX,Keyword
        JNZ ResourceInvalidOp
        CMP DX,7 SHL 8 OR Operator
        JNZ ResourceInvalidOp
        CALL    GetNext
        CMP AH,Number
        JZ  ResourceTypeNum
        JMP InvalidOperand
ResourceInvalidOp:
        JMP InvalidOperand
ResourceTypeNum:
        CMP AL,Num16
        JA  ResourceNumBig
        TEST    DX,8000h
        JNZ ResourceNumBig
        OR  DH,80h
        MOV [Temp3],DX
        CALL    GetNext
        CMP AH,Number
        JNZ ResourceNumExp
        CMP AL,Num16
        JA  ResourceNumTooBig
        TEST    DX,DX
        JZ  ResourceGetTypes
        MOV [Temp5],DX
        LES DI,[Temp1]
        CMP DI,0FFFFh-12
        JAE ResourceOverflow
        MOV AX,[Temp3]  ;TYPE
        STOSW
        MOV AX,DX       ;Count
        STOSW
        XOR AX,AX
        STOSW
        STOSW
        MOV [Temp1],DI  ;Save pointer
ResourceGetLoop:
        CMP WORD [Temp1],0FFFFh-16
        JA  ResourceOverflow
        MOV BYTE [InstrPresent],0
        CALL    GetNext
        CMP AX,EndOfLine
        JZ  ResourceEOL2
        MOV BYTE [InstrPresent],1
        CMP AH,Identifier
        JNZ ResourceLabelExp
        CMP AL,UnknownID
        JNZ ResourceLabelOK
        TEST    BYTE [RefFlags],8
        JNZ ResourceIDNotFound
        OR      BYTE [RefFlags],16
        XOR AX,AX
        MOV DX,AX
        JMP ResourceWrite
ResourceEndd:
        JMP ResourceEnd2
ResourceEOL2:
        ADD WORD [LineNumber],1
        ADC WORD [LineNumber][2],0
        MOV BYTE [EOLFlag],0
        CMP BYTE [Msg],EndOfFile
        JZ  ResourceEndd
        JMP ResourceGetLoop
ResourceIDNotFound:
        JMP IDNotFound
ResourceNumTooBig:
        JMP NumTooBig
ResourceNumExp:
        JMP NumExpected
ResourceLabelExp:
        MOV SI,OFFSET _RCLabelExpected
        JMP PrtError
ResourceOverflow:
        JMP HeaderLarge
ResourceLabelOK:
        CMP AL,ResourceID
        JNZ ResourceLabelExp
        LES DI,[SymPos]
        MOV AX,ES:[DI].seIDData
        MOV DX,ES:[DI][2].seIDData
ResourceWrite:
        LES DI,[Temp1]
        STOSW
        MOV AX,DX
        STOSW
        MOV [Temp1],DI
        CALL    GetNext
        CMP AH,Number
        JNZ ResourceNumExp
        CMP AL,Num16
        JA  ResourceNumTooBig
        MOV [Temp3],DX
        CALL    GetNext
        CMP AH,Number
        JNZ ResourceNumExp
        CMP AL,Num16
        JA  ResourceNumTooBig
        MOV [Temp6],DX
        CALL    GetNext
        CMP AH,Number
        JNZ ResourceNumExp
        CMP AL,Num16
        JA  ResourceNumTooBig
        MOV [Temp7],DX
        CALL    GetNext
        CMP AH,Number
        JNZ ResourceNumExp
        CMP AL,Num16
        JA  ResourceNumTooBig
        LES DI,[Temp1]
        MOV AX,[Temp3]
        STOSW
        MOV AX,[Temp6]
        STOSW
        MOV AX,[Temp7]
        STOSW
        MOV AX,DX
        STOSW
        MOV [Temp1],DI
        DEC WORD [Temp5]
        JZ  ResourceTypes
        JMP ResourceGetLoop
ResourceTypes:
        JMP ResourceGetTypes
ResourceOverfloww:
        JMP ResourceOverflow
ResourceEnd2:        
        LES DI,[neRelocPTR]
        MOV [neResource],DI
        MOV AX,[neResourceAlign]
        XOR SI,SI
        LDS CX,[Temp1]
        MOV BX,DI
        ADD BX,CX
        JC  ResourceOverfloww
        STOSW
        REP MOVSB
        XOR AX,AX
        STOSW
        STOSW
        MOV AX,AsmData
        MOV DS,AX
        MOV [neRelocPTR],DI
        MOV AX,[Temp1]
        ADD AX,6
        MOV [neResourceSize],AX
        JMP AssembleDone2

RCDefine:
        XOR     AX,AX
        MOV     [UninitData],AX
        MOV     [UninitData][2],AX
        AND     [RefFlags],NOT 80h
        CMP     BYTE [CurSeg],0FEh
        MOV     BYTE [CurSeg],SEGMENT_CODE
        MOV     BYTE [CurSeg][3],1
        JNZ     RCDefineOK
        TEST    BYTE [OutFlags],1
        JNZ     RCDefineOK
        CALL    InitFirstSeg
RCDefineOK:
        OR      BYTE [OutFlags],1
        AND     BYTE [RefFlags][1],NOT 8
        OR      BYTE [Settings][1],1
        PUSH    WORD [SymSeg]
        PUSH    WORD [SymPos]
        PUSH    WORD [Temp1]
        PUSH    WORD [Temp2]
        PUSH    WORD [SegAlignment]
        PUSH    CX
        MOV     CL,[neResourceAlign]
        MOV     AX,1
        SHL     AX,CL
        MOV     [SegAlignment],AX
        CALL    SegmentAlign
        POP     CX
        POP     WORD [SegAlignment]
        POP     SI
        POP     AX
        POP     BX
        POP     DX
        PUSH    DS
        POP ES
        TEST    CL,80h
        JNZ     RCDefineExists
        CMP     CL,UnknownID
        JNZ     RCDefineDupDef
        MOV     [neRsrcCrc],AX
        MOV     [neRsrcCrc][2],SI
        MOV     [neRsrcIDLen],CH
        MOV     BYTE [neRsrcIDType],1
        JMP     RCGetPos
RCDefineDupDef:
        TEST    BYTE [RefFlags],8
        JNZ RCDefineExists
RCDefineDupDef2:
        JMP     DupDef
RCDefineExists:
        AND     CL,0Fh
        CMP     CL,StructID
        JZ      RCDefineDupDef2
        MOV     BYTE [neRsrcIDType],0
        MOV     [neRsrcPos],BX
        MOV     [neRsrcPos][2],DX
RCGetPos:
        MOV     AX,[OBufferPTR]
        XOR     DX,DX
        ADD     AX,[FileSize]
        ADC     DX,[FileSize][2]
        MOV     [neRsrcStart],AX
        MOV     [neRsrcStart][2],DX
        MOV     AL,[CurSeg]
        MOV     [neRsrcCurSegBak],AL
        MOV     BYTE [CurSeg],4
        JMP     AssembleDone2

DirectivesWEnd: