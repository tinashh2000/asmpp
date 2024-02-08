JumpDWord:
        CMP     BYTE [AddrMode],2
        JAE     JumpMem32
        MOV     AH,5 SHL 3
        JMP     JumpMem16
JumpMemUnknown2:
        CALL    GetOperandSize
        MOV     AL,AH
        MOV     AH,4 SHL 3
        CMP     AL,_WORD
        JZ      JumpMem16
        CMP     AL,_DWORD
        JZ      JumpDWord
        CMP     AL,_QWORD
        JZ      JumpMem64
        MOV     AH,5 SHL 3
        CMP     AL,_TWORD
        JZ      JumpMem64
        CMP     AL,_FWORD
        JZ      JumpMem32
        JMP     InvalidOperandSize
JumpNearMem2:
        CMP     BYTE [AddrMode],2
        JZ      JumpMem32
        JB      JumpMem16
        JMP     JumpMem64
JumpNearMem:
        CALL    GetOperandSize
        MOV     AL,AH
        MOV     AH,4 SHL 3
        CMP     AL,_WORD
        JZ      JumpMem16
        CMP     AL,_DWORD
        JZ      JumpMem32
        CMP     AL,_QWORD
        JZ      JumpMem64
        JMP     InvalidOperandSize
JumpMem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     JumpMemWrite
JumpMem64:
        MOV     BYTE [REXDisp],1
        OR      BYTE [REXOverride],48h
        JMP     JumpMemWrite
JumpFarMem2:
        CMP     BYTE [AddrMode],2
        JB      JumpMem16
        JA      JumpMem64
JumpMem32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
JumpMemWrite:
        OR      BYTE [ModRM],AH
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,0FFh
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
JumpMemUnknown:
        JMP     JumpMemUnknown2
Jump32Reloc:
        JMP     Jump32Reloc2
JumpFarMem:
        CALL    GetOperandSize
        MOV     AL,AH
        MOV     AH,5 SHL 3
        CMP     AL,_DWORD
        JZ      JumpMem16
        CMP     AL,_FWORD
        JZ      JumpMem32
        CMP     AL,_TWORD
        JZ      JumpMem64
        JMP     InvalidOperandSize
Jump32OutOfRange:
        CMP     BYTE [JmpSize],ShortJmp
        JZ      Jump32OutOfRange2
JumpNear32:
        SUB     DX,3
        SBB     CX,0
        MOV     AL,0E9h
        STOSB
        MOV     AX,DX
        STOSW
        MOV     AX,CX
        STOSW
        JMP     AssembleDone

Jump32OutOfRange2:
        TEST    BYTE [Settings],1
        JZ      Jump32OutOfRange3
        TEST    BYTE [RefFlags],16
        JNZ     Jump32ShortOK
Jump32OutOfRange3:
        JMP     JumpOutOfRange

JumpMem:
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AL,[JmpSize]
        CMP     AL,FarJmp
        JZ      JumpFarMem
        CMP     AL,NearJmp
        JNZ     JumpMemUnknown
        JMP     JumpNearMem
JumpInstr322:
        CALL    GetJump32Size
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     Jump32Reloc
        MOV     CX,WORD [OWordNum][2]
        SUB     DX,2
        SBB     CX,0
        SUB     DX,WORD [ProgIP]
        SBB     CX,WORD [ProgIP][2]
        MOV     SI,WORD [Temp2]
        CMP     BYTE [JmpSize],NearJmp
        JZ      JumpNear32
        CMP     DX,-128
        JL      Jump32OutOfRange
        CMP     DX,127
        JG      Jump32OutOfRange
        TEST    CX,CX
        JZ      Jump32ShortOK
        CMP     CX,-1
        JNZ     Jump32OutOfRange
        CMP     DH,0FFh
        JNZ     Jump32ShortOK
Jump32ShortOK:
        MOV     AH,DL
        MOV     AL,0EBh
        STOSW
        JMP     AssembleDone
JumpInstr32:
        JMP     JumpInstr322
JumpInstr:
        MOV     BYTE [JmpSize],0
        MOV     BYTE [InstrPresent],3
JumpInstr2:
        MOV     WORD [Temp2],BX
JumpGetOp:
        CALL    GetOperand
        CMP     AL,Mem
        JZ      JumpMem
        CMP     AL,Keyword
        JZ      JumpKW
        CMP     AH,Number
        JNZ     JumpLabelExpected
        MOV     CL,[NextChar]
        CMP     CL,Colon
        JZ      JumpInstrFar
        CMP     CL,Comma
        JZ      JumpInstrFar
        MOV     BL,BYTE [JmpSettingMask]
        AND     BL,BYTE [Settings]
        LES     DI,[OBufferPtr]
        CMP     BYTE [JmpSize],0FFh
        JZ      JmpFarExtern
        CMP     BYTE [AddrMode],2
        JZ      JumpInstr32
        JA      JumpInstr64
        CALL    GetJump16Size
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     Jump16Reloc
        SUB     DX,WORD [ProgIP]
        SUB     DX,2
        MOV     SI,WORD [Temp2]
        CMP     BYTE [JmpSize],NearJmp
        JZ      JumpNear16
        CMP     DX,-128
        JL      Jump16OutOfRange
        CMP     DX,127
        JG      Jump16OutOfRange
Jump16Short:
        MOV     AL,0EBh
        MOV     AH,DL
        STOSW
        JMP     AssembleDone
JumpLabelExpected:
        JMP     LabelExpected
Jump16Reloc:
        JMP     Jump16Reloc2
Jump16OutOfRange2:
        TEST    BYTE [Settings],1
        JZ      Jump16OutOfRange3
        TEST    BYTE [RefFlags],16
        JNZ     Jump16Short
Jump16OutOfRange3:
        JMP     JumpOutOfRange
JumpKW:
        CMP     DL,DistSpec
        JZ      JumpDist
        JMP     JumpKW2
JumpInstrFar:
        JMP     JumpInstrFar2
Jump16OutOfRange:
        CMP     BYTE [JmpSize],ShortJmp
        JZ      Jump16OutOfRange2
JumpNear16:
        DEC     DX
        MOV     AL,0E9h
        STOSB
        MOV     AX,DX
        STOSW
        JMP     AssembleDone
JmpFarExtern:
        MOV     AL,09Bh
        JMP     CallFarExtern2
JumpDist:
        MOV     AL,0
        CMP     BYTE [JmpSize],1    ;is JmpSize=1
        SBB     AL,AL   ;IF below then AL=0xFF
        AND     AL,DH   ;IF JmpSize>0 then DH=0
        OR      BYTE [JmpSize],AL
        JMP     JumpGetOp
JumpInstr64:
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     Jump64Reloc
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
        JZ      JumpNear64
        DEC     AX
        TEST    BX,BX
        JZ      Jump64TestShort2
        CMP     BX,AX
        JNZ     Jump64OutOfRange
Jump64TestShort2:
        TEST    BP,BP
        JZ      Jump64TestShort3
        CMP     BX,AX
        JNZ     Jump64OutOfRange
Jump64TestShort3:
        TEST    CX,CX
        JZ      Jump64TestShort4
        CMP     BX,AX
        JNZ     Jump64OutOfRange
Jump64TestShort4:
        CMP     DX,-128
        JL      Jump64OutOfRange
        CMP     DX,127
        JG      Jump64OutOfRange
Jump64Short:
        MOV     AH,DL
        MOV     AL,0EBh
        STOSW
        JMP     AssembleDone
Jump64OutOfRange2:
        TEST    BYTE [Settings],1
        JZ      Jump64OutOfRange3
        TEST    BYTE [RefFlags],16
        JNZ     Jump64Short
Jump64OutOfRange3:
        JMP     JumpOutOfRange
Jump64Reloc:
        JMP     Jump64Reloc2
Jump64OutOfRange:
       CMP      BYTE [JmpSize],ShortJmp
       JZ       Jump64OutOfRange2
JumpNear64:
        MOV     AL,0E9h
        STOSB
        XOR     SI,SI
        MOV     AX,DX
        SUB     AX,3
        STOSW
        MOV     AX,CX
        SBB     AX,SI
        STOSW
        SBB     BP,SI
        JNZ     JumpNearOverflow
JumpNear64OK1:
        SBB     BX,SI
        JNZ     JumpNearOverflow2
JumpNear64OK:
        JMP     AssembleDone
JumpNearOverflow:
        CMP     BP,-1
        JZ      JumpNear64OK1
        JMP     JumpNearOverflow3
JumpNearOverflow2:
        CMP     BX,-1
        JZ      JumpNear64OK
JumpNearOverflow3:
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _JumpTooBig
        PUSH    DI
        CALL    PrintError
        POP     DI
        JMP     AssembleDone
JumpKW2:
        LES     DI,DWORD [OBufferPtr]
        CMP     DL,Reg16
        JZ      JumpReg16
        CMP     DL,Reg32
        JZ      JumpReg32
        MOV     AH,40h
        CMP     DL,Reg64
        JZ      JumpReg64
        OR      AH,41h
        CMP     DL,LMReg16
        JZ      JumpReg16LM
        CMP     DL,LMReg32
        JZ      JumpReg32LM
        CMP     DL,LMReg64
        JZ      JumpReg64
        JMP     InvalidKeyword
JumpReg32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
JumpRegStore:
        MOV     AL,0FFh
        MOV     AH,0C0h OR 20h
        OR      AH,DH
        STOSW
        JMP     AssembleDone
JumpReg16LM:
        MOV     AL,66h
        STOSW
        JMP     JumpRegStore
JumpReg16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     JumpRegStore                
JumpReg64:
        OR      AH,48h
        MOV     AL,AH
        STOSB
        JMP     JumpRegStore
JumpReg32LM:
        MOV     AL,AH
        STOSB
        JMP     JumpRegStore
JumpFarNumTooBig:
        JMP     NumTooBig
JumpFarNumExpected:
        JMP     SelOfsExpected
JumpInstrFar2:
        MOV     BYTE [Temp1],0EAh
        JMP     CallInstrFar3
Jump16Reloc2:
        OR      BYTE [RelocFlags],40h
        CMP     BYTE [JmpSize],ShortJmp
        JZ      JumpShortReloc
        MOV     AL,0E9h
        STOSB
        CALL    Write16Relo
        JMP     AssembleDone
JumpShortReloc:
        OR  BYTE [RelocFlags][1],1
        MOV     AL,0EBh
        STOSB
        CALL    Write16Relo
        DEC     DI
        JMP     AssembleDone
Jump64Reloc2:
Jump32Reloc2:
        OR      BYTE [RelocFlags],48h
        CMP     BYTE [JmpSize],ShortJmp
        JZ      JumpShortReloc
        MOV     AL,0E9h
        STOSB
        CALL    Write32Relo
        JMP     AssembleDone        
