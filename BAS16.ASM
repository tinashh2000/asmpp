WriteOutOMF:
        JMP     WriteOutOMF2

WriteOutFileCOM:
        CMP     BYTE [Msg],EndOfFile
        JZ      WriteOutFileFmtOK
        AND     AH,5
        CMP     AH,5
        JZ      WriteOutFileFmtOK
        MOV     BYTE [OutFormat],OutBIN
        JMP     WriteOutFileFmtOK
WriteOutFileTestProc:
        MOV     AX,WORD [OBufferPtr]
        CMP     AX,WORD [BlockBak1]
        JZ      WriteOutFileProcOK
        AND     BYTE [ProcFlags],NOT 80h
        JMP     WriteOutFileProcOK
WriteOutFileP:
        PUSH    DS
        PUSH    ES
        MOV     AX,AsmData
        MOV     ES,AX
        MOV     DS,AX
        CALL    UpdateProgIP
        JMP     WriteOutFile2
WriteOutFile:
        PUSH    DS
        PUSH    ES
        MOV     AX,AsmData
        MOV     ES,AX
        MOV     DS,AX
WriteOutFile2:
        TEST    BYTE [ProcFlags],80h
        JNZ     WriteOutFileTestProc
WriteOutFileProcOK:
        CMP     BYTE [NumErrors],0
        JNZ     WriteOutFileTrunc2
        MOV     AL,[OutFormat]
        CMP     AL,OutOMF16
        JZ      WriteOutOMF
        CMP     AL,OutOMF32
        JZ      WriteOutOMF
        MOV     BL,[AsmFlags]
        MOV     AH,BL   ;Maybe used check WriteOutFileCOM
        AND     BL,9
        CMP     BL,9
        JZ      WriteOutFileTrunc
        CMP     AL,OutCOM
        JZ      WriteOutFileCOM
WriteOutFileFmtOK:
        CALL    WriteOutFileWrite
WriteOutFileDone:
        POP     ES
        POP     DS
        RET
WriteOutFileTrunc:
        CMP     BYTE [Msg],EndOfFile
        JZ      WriteOutFileFmtOK
WriteOutFileTrunc2:
        MOV     AX,WORD [DiskOutStart]
        MOV     WORD [OBufferPtr],AX
        POP     ES
        POP     DS
        RET

WriteOutFileWrite:
        MOV     BX,WORD [OutHandle]
        TEST    BX,BX
        JNZ     WriteOutFileWrite2
        CALL    OpenOutFile
        MOV     BX,WORD [OutHandle]
WriteOutFileWrite2:
        MOV     CX,WORD [OBufferPtr]
        MOV     AX,WORD [DiskOutStart]
        TEST    BYTE [ProcFlags],80h
        JZ      WriteOutFileWrite3
        MOV     WORD [BlockBak1],AX
WriteOutFileWrite3:
        SUB     CX,AX

        MOV     WORD [OBufferPtr],AX
        MOV     DX,AX
        PUSH    DS
        MOV     DS,WORD [DiskOutSeg]
        PUSH    DS
        POP     ES
        CALL    FWrite
        POP DS
        ADD     WORD [FileSize],AX
        ADC     WORD [FileSize][2],0
        RET

OpenOutFile:
        MOV     SI,OFFSET OutFile
        MOV     DX,SI
        CMP     BYTE [SI],0
        JZ      OpenCreateOutFile
OpenOutFile2:
        XOR     CX,CX
        CALL    FCreate
        JC      OpenOutFilePrintError
        MOV     WORD [OutHandle],AX
        CLC
        RET
OpenCreateFileCMD:
        MOV     DX,SI
        MOV     DI,OFFSET OutFile
        REP     MOVSB
        MOV     AL,0
        STOSB
        JMP     OpenOutFile2
OpenCreateOutFile:
        CALL    MakeOutFileName
        XOR     CX,CX
        CALL    FCreate
        JC      OpenOutFilePrintError
        MOV     WORD [OutHandle],AX
        CLC
        RET
OpenOutFilePrintError:
        MOV     SI,AsmData
        MOV     DS,SI
        CALL    PrintFileError
        MOV     BYTE [Error],QuitError
        MOV     SP,WORD [AsmStack]
        JMP     AssembleEndOfFile

MakeOutFileName:
        MOV     SI,OFFSET Files
        MOV     DI,OFFSET OutFile
        MOV     CX,WORD [FileLen]
        MOV     BX,CX
        PUSH    DI
        MOV     DI,SI
        MOV     AL,"."
        REPNZ   SCASB
        POP     DI
        JNZ     MakeOutFileNameExtOK
        INC     CX
MakeOutFileNameExtOK:
        SUB     BX,CX
        MOV     CX,BX
        REP     MOVSB
        MOV     AL,BYTE [OutFormat]
        AND     AL,0Fh
		MOV		CL,4
		MUL		CL
        MOV     SI,OFFSET OutExtensions
        ADD     SI,AX
		MOVSW
        MOVSW
        LEA     AX,[DI][-OutFile]
        MOV     [OutFileLen],AX
        MOV     AL,0
        STOSB
        RET

PrintOutFile:
        MOV     SI,OFFSET Msg1
        CALL    PrintStr
        MOV     SI,OFFSET OutFile
        CMP     BYTE [SI],0
        JZ      PrintNoOutFile
        CALL    PrintStr
        CALL    PrintLF
        RET
PrintNoOutFile:
        MOV     SI,OFFSET Msg8
        CALL    PrintStr
        RET
InitVars:
        MOV     DI,OFFSET UninitStartZero
        MOV     CX,(UninitEndZero-UninitStartZero)
        XOR     AX,AX
        SHR     CX,1
        REP     STOSW
        ADC     CL,CL
        REP     STOSB
        CALL    ResetAsmData
        MOV     WORD [SegAlignment],16
        MOV     BYTE [RadixValue],10
        MOV     BYTE [TargetCPU],0FFh
        MOV     BYTE [DefSymType],LabelID
        MOV     WORD [JmpSettingMask],0303h
        MOV     WORD [JmpSize],0
        MOV     WORD [Pass],1
        MOV     WORD [Addr16Disp],0
        MOV     WORD [Addr32Disp],1
        MOV     WORD [Addr64Disp],1
        MOV     WORD [RefFlags],3
        MOV     WORD [TxtMemSize],2500h
        MOV     WORD [CurSeg],SEGMENT_NONE
        MOV     WORD [EAMask],3
        MOV     WORD [StrFree],OFFSET StrBuffer+257
InitLCaseTable:
        MOV     DI,OFFSET LCaseTable
        MOV     CL,65
InitLCaseTableLoop:
        STOSB
        INC     AL
        DEC     CL
        JNZ     InitLCaseTableLoop
        ADD     DI,26
        CMP     AL,65
        MOV     AL,"["
        MOV     CL,164
        JZ      InitLCaseTableLoop
        RET
WriteOutStats:
        CALL    PrintLF
        MOV     SI,OFFSET PrtAddresses
        MOV     AX,WORD [NumExtended]
        SUB     WORD [NumSymbols],AX
WriteOutStatsLoop:
        LODSW
        TEST    AX,AX
        JZ      WriteOutStatsZero
        MOV     BP,AX
        LODSW
        MOV     BX,AX
        MOV     AX,WORD [BX]
        MOV     DX,WORD [BX][2]
        TEST    AX,AX
        JNZ     WriteOutStatOK
        TEST    DX,DX
        JZ      WriteOutStatsLoop
WriteOutStatOK:
        PUSH    DX,AX,SI
        MOV     SI,BP
        CALL    PrintStr
        POP     SI,AX,DX
WriteOutStatsPrintInt:        
        PUSH    SI
        PUSH    AX,DX
        MOV AL," "
        CALL    PrintChar
        POP DX,AX
        CALL    PrintInt
        POP SI
        LODSW
        TEST    AX,AX
        JZ  WriteOutStatsLF
        SUB SI,2
        PUSH    SI
        MOV AL,","
        CALL    PrintChar
        MOV AL,20h
        CALL    PrintChar
        POP     SI
        JMP     Writeoutstatsloop
WriteOutStatsLF:
        PUSH    SI
        CALL    PrintLF
        POP SI
        JMP WriteOutStatsLoop
WriteOutStatsZero:
        CMP WORD [SI],0
        JNZ WriteOutStatsLF
WriteOutStatsDone:
        RET

WriteMultiBytes:
        PUSH    AX,BX,CX,DX,SI
        CALL    WriteMultiBytesx
        POP SI,DX,CX,BX,AX
        RET

WriteMultiBytesx PROC
        PUSH    BP
        MOV BP,SP
        SUB SP,8

        MOV [BP-4],CX
        MOV [BP-4][2],BX
WriteMultiBytesStart:
        TEST    BYTE [RefFlags],80h
        JNZ     WriteMultiBytesUninitX
WriteMultiBytesOK:
        MOV     ES,WORD [DiskOutSeg]
WriteMultiBytes1:
        MOV CX,[BP-4]
        CMP WORD [BP-4][2],0
        JZ  WriteMultiBytesSO
        MOV CX,0FFFFh
 WriteMultiBytesSO:
        MOV     BX,0FFF0h
        SUB     BX,DI
        CMP     CX,BX
        JAE     WriteMultiBytes2
        MOV     BX,CX
WriteMultiBytes2:
        SUB     [BP-4],BX
        SBB     [BP-4][2],0
        MOV     CX,BX
        MOV     AL,DL
        MOV     AH,AL
        SHR     CX,1
        REP     STOSW
        ADC     CL,CL
        REP     STOSB
        CMP     DI,0FFF0h
        JAE     WriteMultiBytesOut
        CALL    UpdateProgIP
WriteMultiBytesDone:
        MOV SP,BP
        POP BP
        RET
 
WriteMultiBytesUninitX:
        CALL    WriteUninitData
        JMP WriteMultiBytesStart

WriteMultiBytesOut:
        PUSH    AX
        CALL    UpdateProgIP
        CALL    WriteOutFile
        POP     AX
        MOV     CX,WORD [Temp1]
        MOV     DI,[OBufferPtr]
        JMP     WriteMultiBytes1

WriteMultiBytesX ENDP


WriteMultiWords:
        TEST    BYTE [RefFlags],80h
        JZ		WriteMultiWords2
        CALL    WriteUninitData		
WriteMultiWords2:
        PUSH    AX,BX,CX,DX,SI
        CALL    WriteMultiWordsX
        POP SI,DX,CX,BX,AX
        RET

WriteMultiWordsX PROC
        PUSH    BP
        MOV BP,SP
        SUB SP,8

        MOV [BP-4],CX     ;Num of transfers
        MOV [BP-4][2],BX
        MOV BX,AX   ;Size of each transfer
        MOV     ES,WORD [DiskOutSeg]
WriteMultiWordsInit:
        CMP     DI,0FFE0h
        JAE     WriteMultiWordsOut

        MOV     AX,0FFFAh
        SUB     AX,DI
        XOR     DX,DX
        DIV     BX                  ;Get the number of transfers possible
        MOV CX,AX
        CMP WORD [BP-4][2],0
        JNZ WriteMultiWordsCountOK
        CMP CX,[BP-4]
        JBE WriteMultiWordsCountOK
        MOV CX,[BP-4]
WriteMultiWordsCountOK:
        SUB [BP-4],CX
        SBB [BP-4][2],0
        CMP     BL,2
        JZ      WriteMultiWordsXf
        MOV AX,CX
WriteMultiWordsLoop:
        MOV CX,BX
        MOV SI,(OWordNum)
        SHR CX,1
        REP MOVSW
        DEC AX
        JNZ WriteMultiWordsLoop
        JMP WriteMultiWordsNext
WriteMultiWordsXf:
        MOV     AX,WORD [OWordNum]
        REP     STOSW
WriteMultiWordsNext:
        CMP WORD [BP-4][2],0
        JNZ WriteMultiWordsInit
        CMP WORD [BP-4],0
        JNZ WriteMultiWordsInit
WriteMultiWordsDone:
        CALL    UpdateProgIP
        MOV SP,BP
        POP BP
        RET

WriteMultiWordsOut:        
        PUSH    BX
        CALL    UpdateProgIP
        CALL    WriteOutFile
        POP     BX
        MOV     DI,[OBufferPtr]
        JMP     WriteMultiWordsInit

WriteMultiWordsX ENDP

GetStrFile:
        CALL    GetRAWLine
        MOV     SI,OFFSET StrBuffer
        MOV     DI,SI
GetStrFileInit:
        LODSB
        TEST    AL,AL
        JZ      GetStrFileDone
        CMP     AL,32
        JBE     GetStrFileInit
        CMP     AL,34
        JZ      GetStrFileQuote
        CMP     AL,39
        JZ      GetStrFileQuote
        STOSB
GetStrFileLoop:
        LODSB
        CMP     AL,32
        JBE     GetStrFileDone
        STOSB
        JMP     GetStrFileLoop
GetStrFileQuote:
        MOV     AH,AL
GetStrFileQuote2:
        LODSB
        CMP     AL,AH
        JZ      GetStrFileDone
        TEST    AL,AL
        JZ      GetStrFileMissingQuote
        STOSB
        JMP     GetStrFileQuote2
GetStrFileMissingQuote:
        PUSH    CX,DI,AX
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _MissingEndQuote
        CALL    PrintError
        POP     AX
        MOV     AL,AH
        CALL    PrintChar
        MOV     AL,")"
        CALL    PrintChar
        CALL    PrintLF
        POP     DI,CX
GetStrFileDone:
        RET

GetCurPath:
        PUSH    CX,DX,SI
        MOV AH,19h
        INT 21h
        ADD AL,"A"
        MOV AH,":"
        MOV [DI],AX
        MOV BYTE [DI][2],"\"
        ADD DI,3
        MOV AH,47h
        MOV DL,0
        MOV SI,DI
        INT 21h
        MOV AL,0
        MOV CX,-1
        REPNZ   SCASB
        DEC DI
        DEC DI

        CMP BYTE [DI],"\"
        JZ  gcpOK
        MOV WORD [DI][1],"\"
        ADD DI,2
 gcpOK:
        POP SI,DX,CX
        RET


GetCurFilePath:
        PUSH    CX,SI

        PUSH    DI
        MOV DI,(CurFile)
        MOV AL,0
        MOV CX,-1
        REPNZ   SCASB

        NEG CX

        MOV AL,"\"
        STD
        REPNZ   SCASB
        CLD
        JNZ gcfpDone

        MOV SI,(CurFile)
        MOV CX,DI
        SUB CX,SI
        ADD CX,2

        POP DI
        REP MOVSB
        MOV BYTE [DI],0
        PUSH    DI
        
 gcfpDone:
        POP DI

        POP SI,CX
        RET

GenerateFileName    PROC
        PUSH    BP
        MOV BP,SP

        PUSH    CX,DX,SI,DI

        XOR DX,DX

        MOV SI,[BP][6]      ;Source

        CMP BYTE [SI][1],":"
        JZ  gfnNoPath

        MOV DI,(CurFile)
        MOV CX,-1
        MOV AL,0
        REPNZ   SCASB

        NEG CX

        DEC CX
        DEC DI

        MOV AL,"\"
        STD
        REPNZ   SCASB
        CLD

        MOV CX,DI
        MOV DI,[BP][4]      ;Destination
        JNZ gfnPathOK       ;If no slash was found, no there is no path

        INC CX              ;Point just after the slash
        INC CX

        PUSH    SI
        MOV SI,(CurFile)

        SUB CX,SI
        
        ADD DX,CX           ;FileNameLen
        REP MOVSB           ;Copy path
        POP SI

 gfnAnalyzePath:
        CMP BYTE [SI],"."
        JZ  gfnDOT
        CMP BYTE [SI],"\"
        JZ  gfnSlash
        CMP BYTE [SI],"/"
        JZ  gfnSlash
 gfnPathOK:
        PUSH    DI
        MOV DI,SI
        MOV CX,-1
        MOV AL,0
        REPNZ   SCASB
        POP DI
        NEG CX

        DEC CX          ;Point the char just before the NULL char
        DEC CX
        ADD DX,CX
        REP MOVSB

        MOV AL,0
        STOSB
 gfnDone:
        MOV AX,DX
        POP DI,SI,DX,CX
        POP BP
        RET 4

 gfnSlash:
        XOR DX,DX
        MOV DI,[BP][4]      ;Reset the path
        JMP gfnPathOK

 gfnDOT:        
        CMP WORD [SI][1],"\."
        JZ  gfnPrev
        INC SI
        INC SI
        CMP BYTE [SI][1],"\"
        JZ  gfnAnalyzePath

 gfnNoPath:
        XOR DX,DX
        MOV DI,[BP][4]      ;Reset the path
        JMP gfnPathOK

 gfnPrev:
        ADD SI,3
        MOV AL,"\"
        DEC DI
        DEC DI
        MOV CX,DX           ;FileName Len
        STD
        REPNZ   SCASB
        CLD
        JNZ gfnNoPath

        CMP BYTE [DI],":"
        JZ  gfnDriveOnly
        INC DI
        INC DI
        MOV BYTE [DI],0
        JMP gfnAnalyzePath

 gfnDriveOnly:
        INC DI
        INC DI
        MOV BYTE [DI],0
        JMP gfnAnalyzePath

GenerateFileName    ENDP
