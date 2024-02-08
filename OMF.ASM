OMF_DATA_POS    =   0FFFFh - 1024
OMF_DATA_SIZE   =   1000

OMF_RELOC_POS   =   OMF_DATA_POS - 4096     ;0FFFFh - (4096+1024)
OMF_RELOC_SIZE  =   4000

OMF_PUBLIC_POS  =   OMF_RELOC_POS - 2048    ;0FFFFh - (4096+1024+2048)
OMF_PUBLIC_SIZE =   2000

StoreOMFIdx	PROC
        CMP     AX,7Fh
        JBE     StoreOMFIdxOK
        XCHG    AL,AH
        OR      AL,80h
        STOSB
        MOV     AL,AH
        INC     WORD ES:[BX]
StoreOMFIdxOK:
        STOSB
        RET
StoreOMFIdx		ENDP

StoreOMFIdx2	PROC
        MOV BH,AH
        OR  BH,80h
        CMP AX,80h
        CMC
        MOV BYTE ES:[DI],BH
        ADC DI,0
        STOSB
        RET
StoreOMFIdx2	ENDP

OMFReloc	PROC
        PUSH    DI
        MOV DX,DI
        SUB DX,(OMF_DATA_POS)
        LEA     DX,[DI][-(OMF_DATA_POS)] ;Get reloc position
;        MOV [BBBBAK],DX
        MOV     DI,[omfRelocPTR]           ;Reloc entry pointer
        MOV     AX,DI
        ADD     DI,OMF_RELOC_POS   ;Calculate length of reloc entries
        TEST    AX,AX
        JNZ     OMFRelocEntryOK ;IF NONE existed ENTER new reloc entry
        MOV     AL,9Dh
        CMP     BYTE [OutFormat],OutOMF32   ;IF < omf32 use 9C
        SBB     AL,0
        STOSB
        ADD     DI,2
OMFRelocEntryOK:
;    MOV [omfOGL],DI
        XCHG    DH,DL
        MOV     AX,DX
        OR      AL,0C0h
        MOV     DH,[RelocFlags]
        MOV     DL,50h
OMFRelocDispOK:
        TEST    DH,RELOC_SEGMENT
        JNZ     OMFRelocSeg
        TEST    DH,RELOC_EXTERN
        JNZ     OMFRelocExtern
        OR      AL,4
        OR      DL,4
        TEST    DH,10h
        JNZ     OMFRelocFarPTR
        JMP     OMFRelocWrite
OMFRelocSeg:
        OR      AL,8
        OR      DL,4
        TEST    DH,RELOC_EXTERN
        JZ      OMFRelocWrite
        OR      DL,6
        JMP     OMFRelocWrite
OMFRelocExtern:
        OR      AL,4
        OR      DL,6
        TEST    DH,RELOC_POINTER
        JZ      OMFRelocWrite
OMFRelocFarPTR:
        OR      AL,0Ch
OMFRelocWrite:
        MOV BL,DH
        AND BL,8
        ADD BL,BL
        ADD BL,BL
        OR  AL,BL

        MOV     BYTE [RelocFlags],0
        STOSW
        MOV     AL,DL
        STOSB
        AND DH,RELOC_RELATIVE
        JZ  OMFRelocDispOK2
        AND BYTE ES:[DI][-3],NOT RELOC_RELATIVE
        NOT DH
        AND DH,BYTE ES:[DI][-3]
        TEST    BYTE [RelocFlags][1],1  ;8Bit
        JZ  OMFRelocRel
        AND DH,NOT 4
OMFRelocRel:
        AND DH,NOT 18h  ;24
        MOV BYTE ES:[DI][-3],DH
        AND     BYTE ES:[DI][-1],NOT 70h
        MOV     AX,[omfSeg]
        CALL    StoreOMFIdx2
OMFRelocDispOK2:
        MOV     AX,[RelocData]
        OR  AH,80h
        CALL    StoreOMFIdx2
OMFRelocFinal:
        SUB     DI,OMF_RELOC_POS
        MOV     [omfRelocPTR],DI
        XOR     AX,AX
        CMP     DI,OMF_RELOC_POS + OMF_RELOC_SIZE ;0FFFFh-1124
        JAE     OMFRelocFlush
        POP     DI
        RET
OMFRelocFlush:
        PUSH    ES
        PUSH    SI
        CALL    WriteOutFile
        POP     SI
        POP     ES
        ADD     SP,2    ;The DI saved above
        MOV     DI,[OBufferPtr]
        RET
OMFReloc	ENDP

OpenOMFFormat	PROC
        MOV     BX,WORD [NewHandle]
        TEST    BX,BX
        JNZ     OpenOMFNewExists
        CALL    CreateNewFile
        MOV     BX,WORD [NewHandle]
OpenOMFNewExists:
        XOR     CX,CX
        MOV     DX,CX
        MOV     AL,0
        CALL    FSeek
OpenOMFNewOK:
        MOV     AX,WORD [DiskOutStart]
        MOV     [omfOBufferPtr],AX
        MOV     AX,OMF_DATA_POS
        MOV     [OBufferPtr],AX
        XOR     AX,AX
        MOV     [omfRelocPTR],AX
        MOV     [omfSegSize],AX
        MOV     [omfSegSize][2],AX
        MOV     WORD [omfExtern],AX
        MOV     BYTE [CurSeg],0FEh
        MOV     BYTE [CurSeg][3],0FEh
        OR      BYTE [RefFlags],80h
        MOV     DI,OFFSET omfBuffer
        MOV     AL,80h
        STOSB
        MOV     AX,[FileLen]
        MOV AH,0
        MOV     CX,AX
        ADD     AX,2
        STOSW
        MOV     AL,CL
        STOSB
        MOV     SI,OFFSET CurFile
        REP     MOVSB
        MOV     AL,0
        STOSB
        MOV     AL,88h
        STOSB
        MOV     AX,42
        STOSW
        XOR     AX,AX
        STOSW
        MOV     AL,38
        STOSB
        MOV     SI,OFFSET CorpInfo
        MOV     CX,19
        REP     MOVSW
        MOV     AL,0
        STOSB
        MOV     AL,96h
        STOSB        
        MOV     [omfRecStartPTR],DI        
        MOV     AX,9
        STOSW
        MOV     SI,OFFSET DefNames
        MOV     CX,4
        REP     MOVSW
        MOV     AL,CL
        STOSB
        MOV     [omfBufferPTR],DI
        MOV     BYTE [OutFlags],80h
        INC     AX
        MOV     BYTE [SegAlignment],AL
        MOV     WORD [omfSeg],AX
        MOV     WORD [omfClass],AX
        MOV     WORD [omfSegName],AX
        INC AX
        MOV     WORD [omfNames],AX
        MOV     WORD [omfPublicPTR],OMF_PUBLIC_POS
        OR      BYTE [ExtMask],SYM_NEEDSRELOC
        RET
OpenOMFFormat	ENDP

CloseOMF32File	PROC
        CALL    SegDefOMF
        JMP CloseOMFFile
CloseOMF32File	ENDP

CloseOMF16File	PROC
        CALL    SegDefOMF
        JMP CloseOMFFile
CloseOMF16File	ENDP

CloseOMFFile	PROC

        MOV     DX,OFFSET omfBuffer
        MOV     CX,[omfBufferPTR]
        SUB     CX,DX
        MOV     BX,[NewHandle]
        MOV     DI,BX
        CALL    FWrite

        XOR     CX,CX
        MOV     DX,CX
        MOV     BX,WORD [OutHandle]
        MOV     AL,0
        CALL    FSeek

        MOV     SI,[OutHandle]
        CALL    FCopy

        MOV     BX,SI
		MOV		WORD [OutHandle],0
        CALL    FClose

        MOV     BX,DI
        XOR     CX,CX
        MOV     DX,CX
        MOV     AL,2
        CALL    FSeek

        ADD     [BytesWritten],AX
        ADC     [BytesWritten][2],DX
        MOV     BX,DI
        CALL    FClose

        MOV     DX,OFFSET OutFile
        CALL    FDelete

;        MOV     DX,OFFSET OutFile
;        MOV     DI,OFFSET _CustomFile
;        CALL    FRename

        MOV     DX,OFFSET NewFile
        MOV     DI,OFFSET OutFile
        CALL    FRename
        CALL    PrintOutFile

;        XOR AX,AX
;        MOV [ProgIP],AX
;        MOV [ProgIP][2],AX
;        MOV [ProgIP][4],AX
;        MOV [ProgIP][6],AX
        RET
CloseOMFFile	ENDP

WriteOutOMF2:

        MOV     SI,OMF_DATA_POS
        MOV     DI,AsmData
        MOV     DS,DI
        MOV     DI,[omfOBufferPTR]
        MOV     CX,[OBufferPtr]
        SUB     CX,SI
        MOV     [OBufferPTR],SI
        MOV     AX,[DiskOutSeg]
        MOV     ES,AX
        TEST    CX,CX
        JZ      WriteOutOMFWriteReloc
        MOV     AL,0A0h
        STOSB
        MOV     BX,DI
        ADD DI,2
        MOV     AX,[omfSeg]
        CALL    StoreOMFIdx
		
        CMP BYTE [OutFormat],OutOMF16
        JZ  WriteOutOMFSeg16
        INC BYTE ES:[BX][-1]    ;Make it 0A1
        MOV AX,WORD [omfSegSize]
        STOSW
        ADD AX,CX
        MOV WORD [omfSegSize],AX
        MOV AX,WORD [omfSegSize][2]
        STOSW
        ADC AX,0
        MOV WORD [omfSegSize][2],AX
        JMP WriteOutOMFTestLimit
WriteOutOMFSeg16:
        MOV     AX,[omfSegSize]
        STOSW
        ADD     AX,CX
        MOV     [omfSegSize],AX
WriteOutOMFTestLimit:
        MOV     AL,0
        ADC     AL,AL
        OR      BYTE [Overflow],AL
        REP     MOVS BYTE ES:[DI],ES:[SI]
        MOV     AL,0
        STOSB
        LEA AX,[DI][-2]
        SUB AX,BX
        MOV WORD ES:[BX],AX
WriteOutOMFWriteReloc:
        MOV CX,0
        XCHG    CX,[omfRelocPTR]    ;SIZE of fix-up entries
        TEST    CX,CX
        JZ      WriteOutOMFRelocOK        
        MOV     SI,OMF_RELOC_POS
        SUB     CX,2
        MOV     WORD ES:[SI][1],CX
        MOVS    WORD ES:[DI],ES:[SI]
        REP     MOVS BYTE ES:[DI],ES:[SI]
        MOV     AL,0
        STOSB
WriteOutOMFRelocOK:
        MOV AX,AsmData
        MOV DS,AX

        CMP     BYTE [Msg],EndOfFile
        JZ      WriteOutOMFEOF
        CMP     DI,OMF_PUBLIC_POS - 1024  ;0FFFFh-(4096+2048+2148)
        JAE     WriteOutOMFFlush__
        MOV AX,AsmData
        MOV DS,AX
        MOV     [omfOBufferPtr],DI
        MOV     WORD [OBufferPtr],OMF_DATA_POS
        TEST    BYTE [ProcFlags],80h
        CLC
        JNZ     WriteOutOMFUpdProc
        POP     ES
        POP     DS
        RET
WriteOutOMFFlush__:
        JMP     WriteOutOMFFlush
WriteOutOMFEOF:
        CMP BYTE [Overflow],0
        JZ      WriteOutOMFEOF2
        MOV     BYTE [Error],80h
        PUSH    DI
        MOV     SI,OFFSET _ProgIPOverflow
        CALL    PrintError
        POP DI
WriteOutOMFEOF2:
        MOV     SI,OMF_PUBLIC_POS     ;0FFFFh-(4096+1024+2048)
        MOV     CX,WORD [omfPublicPTR]
        SUB     CX,SI
        REP     MOVS BYTE ES:[DI],ES:[SI]
        MOV     AL,8Bh
        CMP BYTE [OutFormat],OutOMF32
        SBB AL,0
        STOSB
        TEST    BYTE [OutFlags],2
        JZ  WriteOutOMFEOF3
        JMP WriteOutOMFInitAddr

WriteOutOMFEOF3:
        MOV     AX,2
        STOSW
        MOV     AL,0
        STOSW
        JMP     WriteOutOMFFlush

WriteOutOMFUpdProc:
        MOV     WORD [BlockBak1],OMF_DATA_POS
        POP     ES
        POP     DS
        RET

WriteOutOMFInitAddr:
        MOV BX,DI
        MOV     AX,6
        STOSW
        MOV     AX,50C1h
        STOSW
        MOV     AX,[omfInitCS]
        CALL    StoreOMFIdx
        MOV     SI,OFFSET omfInitIP
        MOV CX,2
        CMP     BYTE [OutFormat],OutOMF32
        SBB CL,0
        REP MOVSW
        MOV     AL,0
        STOSB
        LEA AX,[DI][-2]
        SUB AX,BX
        MOV WORD ES:[BX],AX
WriteOutOMFFlush:
        INC WORD [NumTimes][2]
        MOV     AX,AsmData
        MOV     ES,AX
        MOV     DS,AX
        MOV     [OBufferPtr],DI
        CALL    WriteOutFileWrite
        MOV AX,AsmData
        MOV DS,AX
        MOV     WORD [omfOBufferPtr],0
        MOV     WORD [OBufferPtr],OMF_DATA_POS

        TEST    BYTE [ProcFlags],80h
        CLC
        JNZ     WriteOutOMFUpdProc     

        POP     ES
        POP     DS
        RET


GroupDupDef:
        JMP     DupDef
GroupIgnore:
        JMP     Ignored

GroupDirec:
        MOV     AL,[OutFormat]
        CMP     AL,OutOMF16
        JZ      GroupDirecOK
        CMP     AL,OutOMF32
        JNZ     GroupIgnore
GroupDirecOK:
        MOV     BYTE [InstrPresent],1
        TEST    CL,80h
        JNZ     GroupExists
        TEST    BYTE [RefFlags],8
        JNZ     GroupExists
        CMP     CL,UnknownID
        JNZ     GroupDupDef
        MOV     SI,OFFSET OWordNum
        MOV     AX,[omfGrp]
        MOV     [SI],AX
        MOV     CL,CH
        MOV     CH,GroupID
        MOV     DI,WORD [Temp1]
        MOV     BP,WORD [Temp2]
        CALL    WriteSymbol
        JMP     GroupGetSegs
GroupExists:
        LES     DI,DWORD [SymPos]
        AND     BYTE ES:[DI][1],70h  ;Clear the all bits except the extended.
        OR      BYTE ES:[DI][1],GroupID
        MOV     AX,[omfGrp]
        MOV     WORD ES:[DI][4],AX
GroupGetSegs:
        PUSH    DS
        POP ES
        MOV SI,OFFSET StrBuffer+256
        CALL    NamesDef
        MOV DI,OFFSET StrBuffer+256
        MOV AL,9Ah
        STOSB
        MOV BX,DI
        XOR AX,AX
        STOSW
        MOV AX,[omfNames]
        CALL    StoreOMFIdx
        INC WORD [omfNames]
        MOV [Temp1],DI
        MOV BYTE [InstrPresent],0
        MOV WORD [Temp4],0
GroupGetSegsLoop:
        INC WORD [Temp4]
        CALL    GetNext
        CMP AL,EndOfLine
        JZ  GroupFinalize
        CMP AH,Identifier
        JNZ GroupError
        TEST    AL,80h
        JNZ GroupOKUnd
        CMP AL,UnknownID
        JZ  GroupOKUnd
        AND AL,0Fh
        CMP AL,SegmentID
        JZ  GroupOK
GroupError:
        MOV BYTE [Error],127
        JMP InvalidOperand
GroupOKUnd:
        TEST    BYTE [RefFlags],8
        JNZ GroupIDNotFound
        OR  BYTE [RefFlags],16
GroupOK:
        LES SI,[SymPos]
        MOV BX,ES:[SI][4]
        PUSH    DS
        POP ES
        MOV DI,[Temp1]
        MOV AL,0FFh
        STOSB
        MOV AX,BX
        MOV BX,StrBuffer+257
        CALL    StoreOMFIdx
        MOV [Temp1],DI
        JMP GroupGetSegsLoop
GroupIDNotFound:
        JMP GetOperandIDNotFound2
GroupFinalize:
        MOV BYTE [Error],0
        MOV DI,[Temp1]
        MOV AL,0
        STOSB
        SUB DI,OFFSET StrBuffer+259
        LEA CX,[DI][3]
        MOV WORD [StrBuffer][257],DI
        MOV SI,OFFSET StrBuffer+256
        MOV DI,[omfPublicPTR]
        MOV ES,[DiskOutSeg]
        MOV DX,CX
        ADD DX,DI
        JC  GroupFlushPubBuffer
        CMP DX,OMF_PUBLIC_POS + OMF_PUBLIC_SIZE    ;0FFFFh-(4096+1100)
        JAE GroupFlushPubBuffer
GroupPubBufferOK:
        REP MOVSB
        MOV [omfPublicPTR],DI        
        JMP AssembleDone2
GroupFlushPubBuffer:
        PUSH    SI,CX
        MOV     DX,OMF_PUBLIC_POS   ;0FFFFh-(4096+1024+2048)
        MOV     WORD [omfPublicPTR],DX
        MOV     CX,DI
        SUB     CX,DX
        MOV     BX,[OutHandle]
        PUSH    DS
        PUSH    ES
        POP     DS
        CALL    FWrite
        POP DS
        POP CX,SI
        MOV DI,[omfPublicPTR]
        JMP GroupPubBufferOK

FlushOMFBuffer	PROC
        MOV     DX,OFFSET omfBuffer
        MOV     CX,[omfBufferPTR]
        SUB     CX,DX
        MOV     WORD [omfBufferPTR],DX
        MOV     BX,[NewHandle]
        CALL    FWrite
        ADD     WORD [NewFileSize],AX
        ADC     WORD [NewFileSize][2],0
        OR      BYTE [OutFlags],80h
        AND     BYTE [OutFlags],NOT 40h
        RET
FlushOMFBuffer	ENDP
		
	
ExternDefOMF	PROC
        MOV     DI,[omfBufferPTR]
        MOV     CL,AL
        MOV     AL,[OutFlags]
        AND     AL,0C0h
        CMP     AL,0C0h
        JZ      ExternDefOMF16BufOK
        OR      BYTE [OutFlags],0C0h
        MOV     AL,8Ch
        STOSB
        MOV     [omfRecStartPTR],DI
        MOV     AX,1
        STOSW
        INC     DI
        MOV     [omfBufferPTR],DI
ExternDefOMF16BufOK:
        MOV     DI,[omfRecStartPTR]
        MOV     CH,0
        ADD     [DI],CX
        ADD     WORD [DI],2
        MOV     DI,[omfBufferPTR]
        DEC     DI
        MOV     AL,CL
        STOSB
        REP     MOVSB
        MOV     AX,CX
        STOSW
        MOV     [omfBufferPTR],DI
        INC     WORD [omfExtern]
        CMP     DI,OFFSET omfBuffer+(4096-280)
        JA      ExternDefFlush
        MOV     AX,[omfExtern]
        XOR     DX,DX
        RET
ExternDefFlush:
        CALL    FlushOMFBuffer
        MOV     AX,[omfExtern]
        XOR     DX,DX
        RET
ExternDefOMF	ENDP


PublicOMF	PROC
        PUSH    ES
        MOV     DI,WORD [omfPublicPTR]
        MOV     ES,[DiskOutSeg]
        MOV     AL,8Fh  ;will be made 90 OR 91 below! Maths daddy
        STOSB
        MOV     BX,DI
        ADD     DI,2
        MOV     AX,0    ;[omfGrp]
        CALL    StoreOMFIdx
        MOV     AX,[omfSeg]
        CALL    StoreOMFIdx
        MOV     CX,[SI]
        MOVSB
        INC     SI
        REP     MOVSB
        MOV SI,OFFSET ProgIP
        CMP BYTE [OutFormat],OutOMF32
        MOV CL,2
        SBB CL,0
        ADD BYTE ES:[BX][-1],CL
        REP MOVSW
        XOR     AX,AX
        STOSW
        LEA     AX,[DI-2]
        SUB     AX,BX
        MOV     ES:[BX],AX

PublicDefOMFCheckBuf:
        CMP     DI,OMF_PUBLIC_POS + OMF_PUBLIC_SIZE ;0FFFFh-(4096+1100)
        JAE     PublicOMFFlush
        MOV     WORD [omfPublicPTR],DI
        POP     ES
        RET

PublicOMFFlush:
        MOV     DX,OMF_PUBLIC_POS
        MOV     WORD [omfPublicPTR],DX
        MOV     CX,DI
        SUB     CX,DX
        MOV     BX,[OutHandle]
        PUSH    DS
        PUSH    ES
        POP     DS
        CALL    FWrite
        POP DS
        POP ES
        RET
PublicOMF	ENDP



SegDefOMF	PROC
        CMP     WORD [OBufferPtr],OMF_DATA_POS
        JZ      SegDefOMFFileOK
        CALL    WriteOutFile
SegDefOMFFileOK:
        OR      BYTE [OutFlags],80h
        AND     BYTE [OutFlags],NOT 40h
        MOV     DI,WORD [omfBufferPTR]
        MOV     AL,98h
        STOSB
        MOV BX,DI
        ADD DI,2
        MOV     AL,60h
        STOSB
        XOR     AX,AX
        MOV     CX,AX
        CMP BYTE [OutFormat],OutOMF16
        JZ  SegDefOMF16
        OR  BYTE ES:[DI][-1],1
        XCHG    AX,[omfSegSize]
        ADD AX,[UninitData]
        STOSW
        MOV AX,CX
        INC BYTE ES:[BX][-1]
        XCHG    AX,[omfSegSize][2]
        ADC AX,[UninitData][2]
        JMP SegDefSizeOK
SegDefOMF16:
        XCHG    AX,[omfSegSize]
        ADD     AX,[UninitData]
SegDefSizeOK:
        ADC     CL,CL
        OR      BYTE [Overflow],CL
        STOSW
        MOV     AX,[omfSegName]
        CALL    StoreOMFIdx
        MOV     AX,[omfClass]
        CALL    StoreOMFIdx
        MOV     AL,1
        STOSB
        MOV     AL,0
        STOSB
        LEA AX,[DI][-2]
        SUB AX,BX
        MOV WORD ES:[BX],AX
        MOV AX,[omfNames]
        MOV [omfSegName],AX
        INC WORD [omfSeg]
        INC WORD [omfNames]
        MOV     [omfBufferPTR],DI
        CMP     BYTE [Overflow],0
        JNZ     SegDefTooLarge
        CMP     DI,OFFSET omfBuffer+(4096-280)
        JA      SegDefFlush
        RET
SegDefFlush:
        CALL    FlushOMFBuffer
        RET

SegDefTooLarge:
        MOV     BYTE    [Error],80h
        MOV     SI,OFFSET _ProgIPOverflow
        CALL    PrintError
        RET
SegDefOMF	ENDP


NamesDefOMF	PROC
        TEST    BYTE [OutFlags],0C0h
        JZ      NamesDefOMFBufOK
        AND     BYTE [OutFlags],NOT 0C0h
        MOV     DI,[omfBufferPTR]
        MOV     AL,96h
        STOSB
        MOV     [omfRecStartPTR],DI
        MOV     AX,1
        STOSW
        INC     DI
        MOV     [omfBufferPTR],DI
NamesDefOMFBufOK:        
        MOV     DI,[omfRecStartPTR]
        MOV     CX,[SI]
        INC     CX
        ADD     [DI],CX
        DEC     CX
        MOV     DI,[omfBufferPTR]
        DEC     DI
        MOVSB
        INC     SI
        REP     MOVSB
        MOV     AL,0
        STOSB
        MOV     [omfBufferPTR],DI
        CMP     DI,OFFSET omfBuffer+(4096-280)
        JA      NamesDefFlush
        RET
NamesDefFlush:
        CALL    FlushOMFBuffer
        RET
NamesDefOMF	ENDP



EndOMF16	PROC
        MOV [omfInitIP],DX
        MOV AX,[omfSeg]
        TEST    BYTE [Settings],1
        JZ  EndOMF16AddrOK
        MOV AX,[OWordNum][-2]
EndOMF16AddrOK:
        MOV [omfInitCS],AX
        RET
EndOMF16	ENDP

EndOMF32	PROC
        MOV AX,[SI][2]
        MOV [omfInitIP][2],AX
        MOV [omfInitIP],DX
        MOV AX,[omfSeg]
        TEST    BYTE [Settings],1
        JZ  EndOMF32AddrOK
        MOV AX,[OWordNum][-2]
EndOMF32AddrOK:
        MOV [omfInitCS],AX
        RET
EndOMF32	ENDP


GetSegAddrOMF	PROC
        MOV     AX,[omfSeg]
        INC AX
        STC
        RET
GetSegAddrOMF	ENDP

CloseOMFSeg	PROC
        RET
CloseOMFSeg	ENDP

OmfSegClass	PROC		
        SUB     SI,2
        MOV     [SI],CX
        CALL    NamesDef
        MOV     AX,[omfNames]
        MOV     [Temp3],AX
        INC     WORD [omfNames]
        MOV AX,[omfSeg]
        INC AX
        RET
OmfSegClass	ENDP

OMFInitSeg	PROC
        XOR     AX,AX
        MOV     [UninitData],AX
        MOV     [UninitData][2],AX

        CALL    NamesDef
        CALL    SegDef
        MOV     AX,[Temp3]
        MOV     [omfClass],AX
        MOV     AX,[omfSeg]
        MOV     [ProgIP][-2],AX
        RET
OMFInitSeg	ENDP



MarkInitOMF32	PROC
        MOV     AX,[OWordNum][2]
        MOV     [omfSegSize][2],AX
        MOV     [omfSegSize],DX
        STC
        RET
MarkInitOMF32	ENDP

MarkInitOMF16	PROC
        MOV     [omfSegSize],DX
        STC
        RET
MarkInitOMF16	ENDP
