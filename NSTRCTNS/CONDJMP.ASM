
CondJump32OutOfRange2:
        TEST    BYTE [Settings],1
        JZ      CondJump32OutOfRange3
        TEST    BYTE [RefFlags],16
        JNZ     CondJump32ShortOK
CondJump32OutOfRange3:
        JMP     JumpOutOfRange
CondJumpNumTooBig:
        JMP     NumTooBig
CondJump32Reloc:
        JMP     CondJump32Reloc2
CondJump32OutOfRange:
        CMP     BYTE [JmpSize],ShortJmp
        JZ      CondJump32OutOfRange2
CondJumpNear32:
        MOV     AL,0Fh
        MOV     AH,[Temp2]
        ADD     AH,10h
        STOSW
        SUB     DX,4
        SBB     CX,0
        MOV     AX,DX
        STOSW
        MOV     AX,CX
        STOSW
        JMP     AssembleDone
CondJumpLabelExpected:
        JMP     LabelExpected
CondJump32:
        CALL    GetJump32Size
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     CondJump32Reloc
;        TEST    BYTE [RelocFlags],1
;        JNZ     CondJump32Reloc
        MOV     CX,WORD [OWordNum][2]
        SUB     DX,2
        SBB     CX,0
        SUB     DX,WORD [ProgIP]
        SBB     CX,WORD [ProgIP][2]
        CMP     BYTE [JmpSize],NearJmp
        JZ      CondJumpNear32
        CMP     DX,-128
        JL      CondJump32OutOfRange
        CMP     DX,127
        JG      CondJump32OutOfRange
        TEST    CX,CX
        JZ      CondJump32ShortOK
        CMP     CX,-1
        JNZ     CondJump32OutOfRange
        CMP     DH,0FFh
        JNZ     CondJump32OutOfRange
CondJump32ShortOK:
        MOV     AL,BYTE [Temp2]
        MOV     AH,DL
        STOSW
        JMP     AssembleDone
CondJump:
        MOV     AL,BYTE [DefJmpSize]
        MOV     BYTE [JmpSize],AL
        OR      BYTE [Settings][1],2
CondJumpInit:
        MOV     AL,BYTE [BX]
        MOV     BYTE [Temp2],AL
        MOV     BYTE [InstrPresent],3
CondJump2:
        CALL    GetOperand
        CMP     AL,Keyword
        JZ      CondJumpKW
CondJumpImm:
        CMP     AH,Number
        JNZ     CondJumpLabelExpected
        MOV     BL,BYTE [Settings]
        AND     BL,BYTE [CJmpSettingMask]
        LES     DI,DWORD [OBufferPtr]
CondJumpImm2:
        CMP     BYTE [AddrMode],2
        JZ      CondJump32
        JA      CondJump64
        CALL    GetJump16Size
;        TEST    BYTE [RelocFlags],1
;        JNZ     CondJump16Reloc
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     CondJump16Reloc

        SUB     DX,WORD [ProgIP]
        SUB     DX,2
        CMP     BYTE [JmpSize],NearJmp
        JZ      CondJumpNear16
        CMP     DX,-128
        JL      CondJump16OutOfRange
        CMP     DX,127
        JG      CondJump16OutOfRange
CondJump16Short:
        MOV     AL,BYTE [Temp2]
        MOV     AH,DL
        STOSW
        JMP     AssembleDone
CondJump16Reloc:
        JMP     CondJump16Reloc2
CondJump16OutOfRange2:
        TEST    BYTE [Settings],1
        JZ      CondJump16OutOfRange3
        TEST    BYTE [RefFlags],16
        JNZ     CondJump16Short
CondJump16OutOfRange3:
        JMP     JumpOutOfRange
CondJump16OutOfRange:
        CMP     BYTE [JmpSize],ShortJmp
        JZ      CondJump16OutOfRange2
CondJumpNear16:
        SUB     DX,2
        MOV     AH,BYTE [Temp2]
        ADD     AH,10h
        MOV     AL,0Fh
        STOSW
        MOV     AX,DX
        STOSW
        JMP     AssembleDone
CondJumpKW:
        CMP     DL,DistSpec
        JNZ     CondInvalidKW
        MOV     AL,0
        CMP     BYTE [JmpSize],1
        SBB     AL,AL
        AND     AL,DH
        OR      BYTE [JmpSize],AL
        JMP     CondJump2
CondInvalidKW:
        JMP     InvalidKeyword

CondJump64Reloc:
        JMP     CondJump32Reloc2
CondJump64:
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     CondJump64Reloc

        CALL    GetJump64Size
        MOV     SI,OFFSET OWordNum
        MOV     CX,WORD [SI][2]
        MOV     BP,WORD [SI][4]
        MOV     BX,WORD [SI][6]
        XOR     AX,AX
        SUB     DX,2
        SBB     CX,AX
        SBB     BP,AX
        SBB     BX,AX
        MOV     SI,OFFSET ProgIP
        SUB     DX,WORD [SI]
        SBB     CX,WORD [SI][2]
        SBB     BP,WORD [SI][4]
        SBB     BX,WORD [SI][6]
        CMP     BYTE [JmpSize],NearJmp
        JZ      CondJumpNear64
        DEC     AX
        TEST    BX,BX
        JZ      CondJump64TestShort2
        CMP     BX,AX
        JNZ     CondJump64OutOfRange
CondJump64TestShort2:
        TEST    BP,BP
        JZ      CondJump64TestShort3
        CMP     BX,AX
        JNZ     CondJump64OutOfRange
CondJump64TestShort3:
        TEST    CX,CX
        JZ      CondJump64TestShort4
        CMP     BX,AX
        JNZ     CondJump64OutOfRange
CondJump64TestShort4:
        CMP     DX,-128
        JL      CondJump64OutOfRange
        CMP     DX,127
        JG      CondJump64OutOfRange
CondJump64Short:
        MOV     AH,DL
        MOV     AL,BYTE [Temp2]
        STOSW
        JMP     AssembleDone
CondJump64OutOfRange2:
        TEST    BYTE [Settings],1
        JZ      CondJump64OutOfRange3
        TEST    BYTE [RefFlags],16
        JNZ     CondJump64Short
CondJump64OutOfRange3:
        JMP     JumpOutOfRange
CondJump64OutOfRange:
       CMP      BYTE [JmpSize],ShortJmp
       JZ       CondJump64OutOfRange2
CondJumpNear64:
        MOV     AH,BYTE [Temp2]
        ADD     AH,10h
        MOV     AL,0Fh
        STOSW
        XOR     SI,SI
        MOV     AX,DX
        SUB     AX,4
        STOSW
        MOV     AX,CX
        SBB     AX,SI
        STOSW
        SBB     BP,SI
        JNZ     CondJumpNearOverflow
CondJumpNear64OK1:
        SBB     BX,SI
        JNZ     CondJumpNearOverflow2
CondJumpNear64OK:
        JMP     AssembleDone
CondJumpNearOverflow:
        CMP     BP,-1
        JZ      CondJumpNear64OK1
        JMP     CondJumpNearOverflow3
CondJumpNearOverflow2:
        CMP     BX,-1
        JZ      CondJumpNear64OK
CondJumpNearOverflow3:
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _JumpTooBig
        PUSH    DI
        CALL    PrintError
        POP     DI
        JMP     AssembleDone
CondJump16Reloc2:
        OR      BYTE [RelocFlags],40h
        CMP     BYTE [JmpSize],ShortJmp
        JZ      CondJumpShortReloc
        MOV     AL,0Fh
        MOV     AH,BYTE [Temp2]
        ADD     AH,10h
        STOSW
        CALL    Write16Relo
        JMP     AssembleDone
CondJumpShortReloc:
        OR      BYTE [RelocFlags][1],1
        MOV     AL,BYTE [Temp2]
        STOSB
        CALL    Write16Relo
        DEC     DI
        JMP     AssembleDone
CondJump32Reloc2:
        OR      BYTE [RelocFlags],48h
        CMP     BYTE [JmpSize],ShortJmp
        JZ      CondJumpShortReloc
        MOV     AL,0Fh
        MOV     AH,BYTE [Temp2]
        ADD     AH,10h
        STOSW
        CALL    Write32Relo
        JMP     AssembleDone   


Loop32NumExpected:
        JMP     LabelExpected
Loop32Instr:
        CALL    GetOperand
        CMP     AH,Number
        JNZ     Loop32NumExpected
        LES     DI,[OBufferPtr]
        MOV     BYTE ES:[DI],67h
        ADD     DI,WORD [Addr32Disp]
        MOV     BYTE [JmpSize],ShortJmp
        JMP     CondJumpImm2
Loop16Instr:
        MOV     BYTE [JmpSize],ShortJmp
        JMP     CondJumpInit