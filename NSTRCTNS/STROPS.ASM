
LodSPInstr:
        CALL    GetOperand
        MOV     BP,6+1
        MOV     BYTE [Temp1],0ADh
        JMP     ScaSSegOK

ScaSCantSegES:
        JMP     CantESOverride
ScaSMemExpected:
        JMP     ByteOperandExpected
ScaSInvalidAddress:
        JMP     InvalidEAEntry
ScaSPInstr:
        CALL    GetOperand
        MOV     BYTE [Temp1],0AFh
ScaSInstr2:
        MOV     BP,7+1
        MOV     AH,0
        XCHG    AH,[SegOverride]
        TEST    AH,AH
        JZ      ScaSSegOK
        CMP     AH,26h
        JNZ     ScaSCantSegES
ScaSSegOK:
        CMP     BYTE [EADispSize],0
        JNZ     ScaSInvalidAddress
        CMP     AL,Mem
        JNZ     ScaSMemExpected
        MOV     AX,WORD [BaseReg]
        CMP     AX,BP
        JZ      ScaSBaseRegOK
        XCHG    AL,AH
        CMP     AX,BP
        JNZ     ScaSInvalidAddress
ScaSBaseRegOK:
        LES     DI,DWORD [OBufferPtr]
        XOR     AX,AX
        XCHG    AX,[AddrOverride]
        STOSB
        CMP     AL,1
        SBB     DI,0
        MOV AL,AH
        STOSB
        CMP AL,1
        SBB DI,0
        MOV     BL,[Temp1]
        MOV     AL,[REXOverride]
        MOV     AH,[OperandSize]
        CMP     AH,ByteID+1
        JZ      ScaSByte
        CMP     AH,WordID+1
        JZ      ScaSWord
        CMP     AH,DWordID+1
        JZ      ScaSDWord
        CMP     AH,QWordID+1
        JZ      ScaSQWord
        TEST    AH,AH
        JZ      ScaSOpSizeReq
        JMP     InvalidOperandSize
ScaSOpSizeReq:
        JMP     OperandSizeRequired
ScaSByte:
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        DEC     AL
        STOSB
        JMP     AssembleDone
ScaSWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        STOSB
        JMP     AssembleDone
ScaSDWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        STOSB
        JMP     AssembleDone
ScaSQWord:
        OR      AL,48h
        MOV     AH,BL
        MOV     WORD ES:[DI],AX
        ADD     DI,2
        JMP     AssembleDone

StoSPInstr:
        CALL    GetOperand
        MOV     BYTE [Temp1],0ABh
        JMP     ScaSInstr2
        


MovSMemOpExpected:
        JMP     MemOpExpected
MovSInvalidAddress:
        JMP     InvalidEAEntry
MovSOpSizeMismatch:
        JMP     OperandSizeMismatch
MovSPInstr:
        MOV     AX,7+1
        MOV     WORD [Temp2],AX
        DEC     AX
        MOV     WORD [Temp3],AX
        MOV     WORD [Temp1],01A5h
MovSPInstr2:
        CALL    GetOperand
        CMP     AL,Mem
        JNZ     MovSMemOpExpected
        CMP     BYTE [EADispSize],0
        JNZ     MovSInvalidAddress
        MOV     AL,[EARegType]
        MOV     [Temp4],AL
        MOV     AX,[Temp2]
        MOV     BX,WORD [BaseReg]
        CMP     AX,BX
        JZ      MovSBaseRegOK
        XCHG    AL,AH
        CMP     AX,BX
        JNZ     MovSInvalidAddress
MovSBaseRegOK:
        MOV     AL,[OperandSize]
        MOV     AH,0
        XCHG    AH,[SegOverride]
        MOV     [Temp2],AX
        CALL    GetOperand
        CMP     AL,Mem
        JNZ     MovSMemOpExpected
        CMP     BYTE [EADispSize],0
        JNZ     MovSInvalidAddress
        MOV     AX,[Temp3]
        MOV     BX,WORD [BaseReg]
        CMP     AX,BX
        JZ      MovSBaseRegOK2
        XCHG    AL,AH
        CMP     AX,BX
        JNZ     MovSInvalidAddress
MovSBaseRegOK2:
        MOV     AL,[EARegType]
        CMP     AL,BYTE [Temp4]
        JNZ     MovSOpSizeMismatch
        MOV     AL,[OperandSize]
        MOV     AH,BYTE [Temp2]
        CMP     AL,AH
        JZ      MovSOpSizeOK
        TEST    AL,AL
        JZ      MovSOpSizeOK
        TEST    AH,AH
        JNZ     MovSOpSizeMismatch
MovSOpSizeOK:
        OR      AH,AL
        JZ      MovSOpSizeReq
        MOV     AL,[SegOverride]
        MOV     BL,[Temp2][1]
        CMP     BYTE [Temp1][1],1
        JZ      MovSFirstDest
        XCHG    AL,BL
        TEST    BL,BL
        JZ      MovSSegRegOK
        CMP     BL,26h
        JZ      MovSSegRegOK
MovSCantES:
        JMP     CantESOverride
MovSOpSizeReq:
        JMP     OperandSizeRequired
MovSFirstDest:
        TEST    BL,BL
        JZ      MovSSegRegOK
        CMP     BL,26h
        JNZ     MovSCantES
MovSSegRegOK:
        MOV     BH,AH
        MOV     [SegOverride],AL
        LES     DI,[OBufferPtr]
        XOR     AX,AX
        XCHG    AX,WORD [AddrOverride]
        STOSB   ;ES:[DI]=AL
        CMP     AL,1    ;AL ,1
        SBB     DI,0    ;DI=DI-CF. Subtracts IF below
        MOV     AL,AH
        STOSB
        CMP     AL,1
        SBB     DI,0
        MOV     AL,[REXOverride]
        MOV     BL,[Temp1]
        CMP     BH,ByteID+1
        JZ      MovSByte
        CMP     BH,WordID+1
        JZ      MovSWord
        CMP     BH,DWordID+1
        JZ      MovSDWord
        CMP     BH,QWordID+1
        JZ      MovSQWord
        JMP     InvalidOperandSize
MovSByte:
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        DEC     AL
        STOSB
        JMP     AssembleDone
MovSWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        STOSB
        JMP     AssembleDone
MovSDWord:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,BL
        STOSB
        JMP     AssembleDone
MovSQWord:
        OR      AL,48h
        MOV     AH,BL
        MOV     WORD ES:[DI],AX
        ADD     DI,2
        JMP     AssembleDone

CmpSPInstr:
        MOV     AX,6+1
        MOV     WORD [Temp2],AX
        INC     AX
        MOV     WORD [Temp3],AX
        MOV     WORD [Temp1],00A7h
        JMP     MovSPInstr2