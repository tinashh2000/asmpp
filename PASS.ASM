
EnterNewPassCheckEndAddress:
        MOV     AX,WORD [FileSize]
        ADD     AX,BP
        MOV     CX,WORD [FileSize][2]
        ADC     CX,0
        CMP     AX,WORD [LastProgSize]
        JNZ     EnterNewPass2
        CMP     CX,WORD [LastProgSize][2]
        JNZ     EnterNewPass2
        RET
EnterNewPassFail:
        CMP     BYTE [Pass],1
;        JA      EnterNewPassCheckEndAddress
EnterNewPassFail2:
        RET
EnterNewPass:

        MOV     BP,WORD [OBufferPtr]
        SUB     BP,WORD [DiskOutStart]
        CMP     WORD [NumErrors],0
        JNZ     EnterNewPassFail2
        TEST    BYTE [RefFlags],16
        JZ      EnterNewPassFail
        AND     BYTE [RefFlags],NOT 90h
EnterNewPass2:       
        INC     BYTE [Pass]
        OR      BYTE [RefFlags],8
        XOR     DX,DX
        MOV     CX,DX
        MOV     AX,CX
        MOV     BYTE [Addr16Disp],AL
        MOV     BYTE [RefFlags][1],AL
        MOV     BYTE [Msg],AL
        MOV     WORD [UninitData],AX
        MOV     WORD [UninitData][2],AX
        MOV     WORD [InBlock],AX
        MOV     BYTE [ExtMask],AL
        INC     AX
        MOV     WORD [CurSeg],AX
        MOV     BYTE [AddrMode],AL
        MOV     BYTE [Addr32Disp],AL
        MOV     BYTE [Addr64Disp],AL
        MOV     AX,WORD [FileSize]
        ADD     AX,BP
        MOV     WORD [LastProgSize],AX
        MOV     AX,WORD [FileSize][2]
        ADC     AX,CX
        MOV     WORD [LastProgSize][2],AX
        MOV     AX,WORD [DiskOutStart]
        MOV     WORD [OBufferPtr],AX
        MOV     AX,WORD [InitLineNumber]
        MOV     WORD [LineNumber],AX
        MOV     AX,WORD [InitLineNumber][2]
        MOV     WORD [LineNumber][2],AX
        MOV     AX,WORD [InitIfBlockCnt]
        MOV     WORD [IfBlockCnt],AX
        MOV     AX,WORD [InitIfBlockCnt][2]
        MOV     WORD [IfBlockCnt][2],AX
        MOV     DX,WORD [InitFilePos]
        MOV     CX,WORD [InitFilePos][2]
        MOV     WORD [BytesRead],DX
        MOV     WORD [BytesRead][2],CX
        MOV     BX,WORD [CurHandle]
        MOV     AL,0
        CALL    FSeek
        CALL    InitOutFile
        MOV     BYTE [Flushed],1
        MOV     SP,WORD [AsmStack]
        JMP     AssembleFileInit
