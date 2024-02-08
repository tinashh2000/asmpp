EVEN 2
OverwriteSymbol	PROC
;BP:DI - Pointer to sympos
;Symbol name length  CL
;Symbol TYPE CH
;DS:SI	-	Flags,Extrab
;DS:SI+2 - ExtraW
;DS:SI - 32-bit Data
OverwriteSymbolStart:
		MOV		ES,BP	;DI already points to sym
        MOV     WORD [SymPos],DI
        MOV     WORD [SymSeg],ES
        MOV     AX,CX       ;Len,TYPE
        STOSW
		ADD	DI,2		;Skip high crc
        LODSW       ;Flags,Extrab
        AND AL,NOT 1
        MOV DL,[Pass]
        AND DL,1
        OR  DL,[ExtMask]
        OR  AL,DL
        STOSW
        MOVSW       ;ExtraW
        MOVSW       ;Data
        MOVSW
        TEST    AL,SYM_EXT
        JNZ     OverwriteSymbolExt
OverwriteSymbolDone:
        RET

OverwriteSymbolExt:
        MOV     BX,OFFSET SymNextSpace		;Not that, if we once wrote this symbol, it must already be in a position where extended space is available
        MOV     AX,WORD [BX]
        MOV     BX,WORD [NumSegs]
        XOR     AX,AX		;Len and type = 0
        STOSW
        MOVSW
        MOVSW
        MOVSW
        AND     CH,NOT SYM_EXT          ;40h
        SUB     SI,10
        RET
OverwriteSymbol		ENDP


AllocateSymbolSpace	PROC
        MOV     BL,BYTE [AsmFlags]
        AND     BL,41h
;        CMP     BL,41h
;        JNZ     WriteSymbolOut2

        PUSH    BP,AX,CX
        CALL    GetFreeMem
        CMP     BX,10h  ;We can't have a symbol table less than 256 bytes
        JB      AllocateSymbolOutOfSpace
        CMP     BX,1000h
        JBE     AllocateSymSpace
        MOV     BX,1000h
AllocateSymSpace:
        MOV     BP,BX
        CALL    AllocateMem
        JC      AllocateSymbolOutOfSpace
        MOV     BX,WORD [NumSegs]
        ADD     BX,2
        MOV     WORD [FreeSymSeg],AX
        MOV     WORD [BX][SymbolSeg],AX
        MOV     WORD [NumSegs],BX
        MOV     CL,4
        SHL     BP,CL
        MOV     AX,BP
        DEC     AX
        MOV     BP,SymDefSize/2
        XOR     DX,DX
        MOV     WORD [SymNextSpace],DX
        DIV     BP        
        MOV     WORD [BX][SymDataStart],AX
        SUB     AX,2
        MOV     WORD [SymMaxSymbols],AX
        POP     CX,DI,BP
		RET
AllocateSymbolOutOfSpace:
        MOV     BYTE [Error],QuitError
        MOV     SI,OFFSET _SymSpaceOut
        CALL    PrintError
        MOV     BYTE [Msg],EndOfFile
        MOV     SP,WORD [AsmStack]
        JMP     AssembleEndOfFile
AllocateSymbolSpace	ENDP

EVEN 2
WriteSymbol	PROC
;BP:DI - crc32 value
;Symbol name length  CL
;Symbol TYPE CH
;DS:SI	-	Flags,Extrab
;DS:SI+2 - ExtraW
;DS:SI - 32-bit Data
WriteSymbolStart:
        MOV     ES,WORD [FreeSymSeg]
        MOV     AX,DI
        MOV     DI,WORD [SymNextSpace]
        CMP     DI,WORD [SymMaxSymbols]
        JAE     WriteSymbolOut
WriteSymbol2:
        STOSW
        MOV     WORD [SymNextSpace],DI
        SUB     DI,2
        MOV     AX,SymDefSize/2
        MUL     DI
        MOV     DI,WORD [NumSegs]
        ADD     AX,WORD [DI][SymDataStart]  ;SymDataStart of this SEGMENT
        INC     WORD [DI][NumSymbol]    ;Number of symbols IN this SEGMENT

        MOV     DI,AX
        MOV     WORD [SymPos],AX
        MOV     AX,CX       ;Len,TYPE
        STOSW
        MOV     AX,BP		;High CRC
        STOSW
        LODSW       ;Flags,Extrab
        AND AL,NOT 1
        MOV DL,[Pass]
        AND DL,1
        OR  DL,[ExtMask]
        OR  AL,DL
        STOSW
        MOVSW       ;ExtraW
        MOVSW       ;Data
        MOVSW
        INC     WORD [NumSymbols]
        MOV     WORD [SymSeg],ES
        TEST    AL,SYM_EXT			;If the AL we wrote above, has an EXT flag
        JNZ     WriteSymbolExt
WriteSymbolDone:
        RET
WriteSymbolOut:
		CALL	AllocateSymbolSpace
		JMP	WriteSymbolStart

WriteSymbolExt:
        MOV     BX,OFFSET SymNextSpace
        MOV     AX,WORD [BX]
        CMP     AX,WORD [SymMaxSymbols]
        JAE      WriteSymbolExtSpaceOut
        ADD     WORD [BX],2
        MOV     BX,WORD [NumSegs]
        INC     WORD [BX][NumSymbol]    ;Number of symbols IN this SEGMENT
        INC     WORD [NumSymbols]
        XOR     AX,AX
        STOSW
;        ADD     SI,4
        MOVSW
        MOVSW
        MOVSW
        INC     WORD [NumExtended]
        AND     CH,NOT SYM_EXT          ;40h
        SUB     SI,10
        RET
WriteSymbolExtSpaceOut:
        SUB SI,4
        AND     BYTE ES:[DI-7],NOT SYM_EXT  ;Erase the extended bit
        MOV     AX,WORD [AsmFlags]
        AND     AX,0101h
        CMP     AX,0101h
        JZ      WriteSymbolDone
        MOV     BYTE ES:[DI][-8],0  ;Invalidate the length.
        MOV     BX,WORD [SymNextSpace]
        MOV     DI,ES:[BX][-2]
        JMP     WriteSymbolStart
WriteSymbol	ENDP

FindSymbolNotFound:
		MOV     DI,WORD [SymPosSeg]
        CMP     DI,WORD [NumSegs]
        JAE     FindSymbolNotFound22
        ADD     DI,2
        MOV     WORD [SymPosSeg],DI
        MOV     ES,WORD [DI][SymbolSeg]
        MOV     CX,WORD [DI][NumSymbol]
        XOR     DI,DI
        JMP     FindSymbolLoop
FindSymbolNotFound22:
        JMP     FindSymbolNotFound2
EVEN 2
FindSymbol:
        AND     BYTE [Settings][1],NOT 20h
        MOV     ES,WORD [SymbolSeg]
        XOR     DI,DI
        MOV     WORD [SymPosSeg],DI
        MOV     CX,WORD [NumSymbol]
        MOV     BP,DX
        TEST    CX,CX
        JZ      FindSymbolNotFound
FindSymbolLoop:
        REPNZ   SCASW
        JNZ     FindSymbolNotFound
        MOV     BX,AX
        LEA     SI,[DI][-1]
        SHR     SI,1
        MOV     AX,SymDefSize
        MUL     SI
        MOV     SI,WORD [SymPosSeg]
        ADD     AX,WORD [SI][SymDataStart]
        MOV     SI,AX
        CMP     BP,WORD ES:[SI].seIDCrcH
        MOV     AX,BX
        JNZ     FindSymbolLoop
        MOV     BL,BYTE ES:[SI]
        CMP     BL,BYTE [StrLen]
        JNZ     FindSymbolLoop
        MOV     DI,AX
        MOV     BX,OFFSET OWordNum-4

        MOV     CX,WORD ES:[SI].seIDFlags
        MOV     WORD [BX],CX

        MOV     AX,WORD ES:[SI].seIDcwExtra
        MOV     WORD [BX][2],AX

        MOV     DX,WORD ES:[SI].seIDData
        MOV     WORD [BX][4],DX

        MOV     AX,WORD ES:[SI][2].seIDData
        MOV     WORD [BX][6],AX

        MOV     AL,BYTE ES:[SI].seIDType
        MOV     BYTE [SymType],AL

        TEST    AL,SYM_EXT
        JNZ     FindSymbolCopy2
        MOV WORD [BX][8],0
        MOV WORD [BX][10],0
FindSymbolFinal:
        MOV AH,CL
;        INC AH
        XOR AH,[Pass]
        AND AH,1
        ADD AH,AH        
        OR  AH,1
        OR      BYTE [Settings],AH
        MOV     WORD [SymPos],SI
        MOV     WORD [SymSeg],ES
        MOV     AH,Identifier
        RET

FindSymbolCopy2:
        MOV     AX,WORD ES:[SI][0010]
        MOV     WORD [BX][8],AX
        MOV     AX,WORD ES:[SI][0012]
        MOV     WORD [BX][10],AX
        MOV     AL,BYTE ES:[SI].seIDType
        JMP     FindSymbolFinal            

FindSymbolNotFound2:
        MOV     CX,[LocalSymPtr]
        TEST    CX,CX
        JNZ     FindSymbolLocal
FindSymbolNotFound3:
        MOV     DI,AX
        MOV     AL,UnknownID
        MOV     BYTE [SymType],AL
        MOV     AH,Identifier
        OR      BYTE [Settings],3
        XOR     CX,CX
        RET

FindSymbolLocal:
        XOR     DI,DI
        MOV     ES,WORD [LocalSymSeg]
        SHR     CX,1
FindSymbolLocalLoop:
        REPNZ   SCASW
        JNZ     FindSymbolNotFound3
        MOV     BX,AX
        LEA     SI,[DI][-2]
        MOV     AX,SymDefSize/2
        MUL     SI
        ADD     AX,[LocalDataStart]
        MOV     SI,AX
        CMP     BP,ES:[SI][2]
        MOV     AX,BX
        JNZ     FindSymbolLocalLoop
        MOV     BL,BYTE ES:[SI]
        CMP     BL,BYTE [StrLen]
        JNZ     FindSymbolLocalLoop
        OR      WORD [Settings],2001h
        MOV     DI,AX
        MOV     BX,OFFSET OWordNum
        MOV     AX,WORD ES:[SI][4]
        MOV     WORD [BX],AX
        MOV     AX,WORD ES:[SI][6]
        MOV     WORD [BX][2],AX
        MOV     AL,BYTE ES:[SI][1]
        MOV     BYTE [SymType],AL
        XOR     SI,SI
        MOV     CX,SYM_UNDEF
        MOV     WORD [BX][4],SI
        MOV     WORD [BX][6],SI
        MOV     AH,Identifier
        RET

OverwriteSymbolAddressChkExt:
        ADD     DI,2
        MOV     CX,3
        REP     CMPSW
        JNZ     OverwriteSymbolAddressChk2
        MOV     AL,0
        JMP     OverwriteSymbolAddressChk2
OverwriteSymbolAddressChk:
        MOV     SI,OFFSET ProgIP
        MOV     AX,[SI][-2]
        MOV     ES:[DI].seIDcwExtra,AX
        MOV     AL,[SI][-3]
        MOV     ES:[DI].seIDcbExtra,AL
        MOV     DL,ES:[DI].seIDType

        ADD     DI,(seIDData)
        MOV     CX,2
        MOV     AL,16
        REP     CMPSW
        JNZ     OverwriteSymbolAddressChk2
        TEST    DL,SYM_EXT
        JNZ     OverwriteSymbolAddressChkExt
        MOV     AL,0
OverwriteSymbolAddressChk2:
        MOV     CL,DL
        OR      BYTE [RefFlags],AL
        MOV     DI,WORD [SymPos]
        MOV     SI,OFFSET ProgIP

OverwriteSymbolAddress:

        MOV AL,[Pass]
        AND AL,1

        MOV CL,ES:[DI].seIDType
        AND BYTE ES:[DI].seIDFlags,NOT 1
        OR  BYTE ES:[DI].seIDFlags,AL

        ADD     DI,(seIDData)
        MOVSW
        MOVSW
        TEST    CL,SYM_EXT
        JNZ     OverwriteSymbolAddressExt
        RET
OverwriteSymbolAddressExt:
        ADD     DI,2
        MOVSW
        MOVSW
        MOVSW
        RET

WriteLocalGetSymSeg:
        PUSH    BP,DI,CX
        CALL    GetFreeMem
        CMP     BX,10h  ;We can't have a symbol table less than 256 bytes
        JB      WriteLocalSymbolOut
        CMP     BX,271h
        JBE     LocalAlloc
        MOV     BX,271h
LocalAlloc:
        MOV     BP,BX
        CALL    AllocateMem
        JC      WriteLocalSymbolOut
        MOV     WORD [LocalSymSeg],AX
        MOV     CL,4
        SHL     BP,CL
        MOV     AX,BP
        DEC     AX
        MOV     BP,(SymDefSize/2)
        XOR     DX,DX
        MOV     WORD [LocalSymPtr],DX
        DIV     BP        
        MOV     WORD [LocalDataStart],AX
        SUB     AX,2
        MOV     WORD [LocalSymLimit],AX
        POP     CX,DI,BP
        JMP WriteLocalSymbol
WriteLocalSymbolOut:
        MOV SI,OFFSET _SymSpaceOut
        MOV BYTE [Error],255
        CALL    PrintError
        MOV     SP,WORD [AsmStack]
        JMP     AssembleEndOfFile
WriteLocalSymbol:
        MOV     AX,[LocalSymSeg]
        TEST    AX,AX
        JZ      WriteLocalGetSymSeg
        MOV     ES,AX
        MOV     AX,DI
        MOV     DI,WORD [LocalSymPtr]
        CMP     DI,WORD [LocalSymLimit]
        JA      WriteLocalSymbolOut
        STOSW
        MOV     WORD [LocalSymPtr],DI
        SUB     DI,2
        MOV     AX,SymDefSize/2
        MUL     DI
        ADD     AX,WORD [LocalDataStart]
        MOV     DI,AX
        MOV     AX,CX
        STOSW
        MOV     AX,BP
        STOSW
        MOV     AX,WORD [SI]
        STOSW
        MOV     AX,WORD [SI][2]
        STOSW
        RET
