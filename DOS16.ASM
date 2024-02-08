ProcessCmd:
        XOR     DX,DX
        MOV     CX,DX
        MOV     WORD [Temp1],DX
        MOV     DS,WORD [PSPSeg]
        MOV     SI,80h
        LODSB
        MOV     CL,AL
        MOV     DI,OFFSET StrBuffer
        CALL    LCaseStr
        MOV     AX,AsmData
        MOV     DS,AX
        CMP     BYTE [StrBuffer],0
        JZ      CmdEnd
        MOV     SI,OFFSET StrBuffer
        MOV     DI,OFFSET Temp1
    CmdGetChar:
        LODSB
        CMP     AL,20h
        JZ      CmdGetNext
        CMP     AL,"-"
        JZ      CmdSwitch
        CMP     AL,"/"
        JZ      CmdSwitch
        CMP     AL,0Dh
        JBE     CmdEnd

        CMP     AL,"'"
        JZ      CmdQuote

        CMP     AL,'"'
        JZ      CmdQuote

        TEST    CX,CX
        JZ      CmdGetNewParam

        INC     CX
        JMP     CmdGetChar

    CmdQuote:
        JMP     CmdQuote2

    CmdEnd:
        MOV     AX,CX
        STOSW
        RET

    CmdGetNewParam:
        MOV     AX,SI
        DEC     AX
        STOSW
        INC     CX
        INC     DX
        JMP     CmdGetChar

    CmdGetNext:
        TEST    CX,CX
        JZ      CmdGetChar
        MOV     AX,CX
        STOSW
        XOR     CX,CX
        JMP     CmdGetChar
    CmdSwitch:
        LODSB
        MOV     AH,BYTE [SI]
        INC     SI
        CMP     AX,"+w"
        JZ      CmdShowSuppWarn
        CMP     AX,'sc'
        JZ      CmdCaseOn
        CMP     AX,'sj'
        JZ      CmdShortJump
        CMP     AX,'nj'
        JZ      CmdNearJump
        CMP     AX,'oj'
        JZ      CmdOptimizeJumps
        CMP     AX,'co'
        JZ      CmdOptimizeCond
        CMP     AX,'uo'
        JZ      CmdOptimizeUCond
        CMP     AX,'la'
        JZ      CmdLinkFile
        CMP     AX,'zm'
        JZ      CmdMZEXE
        JMP     CmdSwitch2
CmdShowSuppWarn:
        OR      BYTE [AsmFlags2][1],1
        JMP     CmdGetChar
CmdCaseOn:
        JMP     CmdGetChar
CmdShortJump:
        MOV     BYTE [DefJmpSize],ShortJmp
        JMP     CmdGetChar
CmdNearJump:
        MOV     BYTE [DefJmpSize],NearJmp
        JMP     CmdGetChar
CmdOptimizeCond:
        MOV     BYTE [CJmpSettingMask],0
        MOV     BYTE [EAMask],0FCh
        JMP     CmdGetChar
CmdOptimizeJumps:
        MOV     BYTE [CJmpSettingMask],0
CmdOptimizeUCond:
        MOV     BYTE [EAMask],0FCh
        MOV     BYTE [JmpSettingMask],0
        JMP     CmdGetChar
CmdCreateListing:
CmdLinkFile:
        JMP     CmdGetChar
CmdMZEXE:
        MOV     BYTE [OutFormat],OutMZ
        JMP     CmdGetChar

CmdPartEXE:
        LODSB
        CMP     AL,'e'
        JZ      CmdMZEXE
        XOR     CX,CX
        RET
CmdPartOMF:
        LODSB
        CMP     AL,"f"
        JNZ     CmdFail
        JMP     CmdPartObj2
CmdPartELF:
        LODSB
        CMP     AL,'f'
        JNZ     CmdFail
        LODSW
        MOV     BL,OutELF64
        CMP     AX,'64'
        JZ      CmdFormatOK
        MOV     BL,OutELF32
        CMP     AX,'23'
        JZ      CmdFormatOK
        SUB     SI,2
CmdFormatOK:
        MOV     BYTE [OutFormat],BL
        JMP     CmdGetChar
CmdPartObj:
        LODSB
        CMP     AL,'j'
        JNZ     CmdFail
CmdPartObj2:
        LODSW
        MOV     BL,OutOMF32
        CMP     AX,'23'
        JZ      CmdFormatOK
        MOV     BL,OutOMF16
        CMP     AX,'61'
        JZ      CmdFormatOK
        SUB     SI,2
        JMP     CmdFormatOK
CmdSwitch2:
        CMP     AX,'xe'
        JZ      CmdPartEXE
        CMP     AX,'le'
        JZ      CmdPartELF
        CMP     AX,'bo'
        JZ      CmdPartObj
        CMP     AX,'mo'
        JZ      CmdPartOMF
        CMP     AX,'ep'
        JZ      CmdPartPE
        CMP     AX,'oc'
        JZ      CmdPartCOFF
CmdFail:
        XOR     CX,CX
        RET
CmdPartCOFF:
        LODSW
        CMP     AX,'ff'
        JNZ     CmdFail
        LODSW
        MOV     BL,OutCOFF64
        CMP     AX,'46'
        JZ      CmdFormatOK
        MOV     BL,OutCOFF32
        CMP     AX,'23'
        JZ      CmdFormatOK
        SUB     SI,2
        JMP     CmdFormatOK
CmdPartPE:
        LODSW
        MOV     BL,OutNE16
        CMP     AX,'61'
        JZ      CmdFormatOK
        MOV     BL,OutPE64
        CMP     AX,'46'
        JZ      CmdFormatOK
        MOV     BL,OutPE32
        CMP     AX,'23'
        JZ      CmdFormatOK
        SUB     SI,2
        JMP     CmdFormatOK        

CmdQuote2:
        MOV BL,AL

        TEST    CX,CX
        JNZ     CmdQuoteRemoveQuote

        MOV     AX,SI   ;Dont record the quote
        STOSW
        INC     DX
        JMP CmdQuoteLoop

CmdQuoteRemoveQuote:

        PUSH    CX,SI,DI

        MOV DI,SI
        MOV AL,0
        MOV CX,-1
        REPNZ   SCASB
        NEG CX

        MOV DI,SI
        DEC DI
        REP MOVSB

        POP DI,SI,CX
        DEC SI

CmdQuoteLoop:

        LODSB
        CMP     AL,BL
        JZ      CmdQuote2End

        CMP     AL,0Dh
        JZ      CmdQuoteEOL

        INC     CX

        JMP     CmdQuoteLoop

CmdQuoteEOL:
        JMP     CmdEnd

CmdQuote2End:
        PUSH    CX,SI,DI
        MOV DI,SI

        MOV AL,0
        MOV CX,-1
        REPNZ   SCASB
        NEG CX

        MOV DI,SI
        DEC DI

        REP MOVSB

        POP DI,SI,CX
        DEC SI

        JMP     CmdGetChar

ExitProg	PROC
        MOV     AH,4Ch
        MOV     AL,0FFh
        CMP     WORD [NumErrors],1
        ADC     AL,0
        INT     21h
ExitProg	ENDP

ResizeMem	PROC
        PUSH    ES
        PUSH    CS
        POP     ES
        MOV     AH,4Ah
        INT     21h
        POP ES
        RET
ResizeMem	ENDP

AllocateMem	PROC
        MOV     AH,48h
        INT     21h
        RET
AllocateMem	ENDP

FreeMem	PROC
        MOV     AH,49h
        INT     21h
        RET
FreeMem	ENDP

PrintChar	PROC
        PUSH    DX
        MOV     DL,AL
        MOV     AH,02h
        INT     21h
        POP     DX
        RET
PrintChar	ENDP

ClearScreen	PROC
        MOV     AX,3
        INT     10h
        RET
ClearScreen	ENDP

GetFreeMem	PROC
        MOV     BX,0FFFFh
        MOV     AH,48h
        INT     21h
        RET
GetFreeMem	ENDP

DosPathNotFound:
        MOV     SI,OFFSET _PathNotFound
        JMP     DosPrintError
DosTooManyFiles:
        MOV     SI,OFFSET _TooManyFiles
        JMP     DosPrintError
DosAccessDenied:
        MOV     SI,OFFSET _AccessDenied
        JMP     DosPrintError
DosInvalidDrive:
        MOV     SI,OFFSET _InvalidDrive
        JMP     DosPrintError
DosFileNotFound:
        MOV     SI,OFFSET _FileNotFound
DosPrintError:
        PUSH    BX
        CMP     WORD [AsmStack],0
        JNZ     DosPrintError2
        CALL    PrintStr
        JMP     DosPrintError3
DosPrintError2:
        CALL    PrintError
DosPrintError3:
        POP     SI
        CALL    PrintStr
DosPrintErrorLF:
        CALL    PrintLF
        RET

PrintFileError	PROC
        MOV     BX,AsmData
        MOV     DS,BX
        MOV     BYTE [Error],QuitError
        MOV     BX,DX
        CMP     WORD [AsmStack],0
        JNZ     PrintFileError2
        PUSH    AX,BX
        MOV     SI,OFFSET FatalTxt
        CALL    PrintStr
        POP     BX,AX
        INC     WORD [NumErrors]
PrintFileError2:
        CMP     AL,2
        JZ      DosFileNotFound
        CMP     AL,3
        JZ      DosPathNotFound
        CMP     AL,4
        JZ      DosTooManyFiles
        CMP     AL,6
        JZ      DosAccessDenied
        CMP     AL,15
        JZ      DosInvalidDrive
        INC     WORD [NumErrors]
        PUSH    AX
        MOV     SI,OFFSET Err
        CALL    PrintStr
        POP     AX
        XOR     DX,DX
        CALL    PrintInt
        CALL    PrintLF
        RET
PrintFileError	ENDP

GetSysTime	PROC
        MOV     AH,2Ch
        INT     21h
        RET
GetSysTime	ENDP

GetSysDate	PROC
        MOV     AH,2Ah
        INT     21h
        RET
GetSysDate	ENDP
