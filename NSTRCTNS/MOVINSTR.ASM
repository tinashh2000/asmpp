MoveMemRegOpt64:
        CMP BYTE [EADispSize],8
        JZ MoveMemRegOpt
        JMP MoveMemRegNoOpt
MoveMemRegOpt:
        CMP     CL,Reg64
        JA      MoveMemRegNoOpt
        CMP     WORD [BaseReg],0
        JNZ     MoveMemRegNoOpt
        CMP BYTE [AddrMode],4
        JAE MoveMemRegOpt64
MoveMemRegOptOK:
        CALL    WriteOverrides
        CMP     CL,Reg8
        JZ      MoveMemAL
        MOV     AH,0A3h
        CMP     CL,Reg16
        JZ      MoveMemAX
        CMP     CL,Reg64
        JZ      MoveMemRAX
        CMP     CL,Reg32
        JNZ     MoveInvalidOpS2
MoveMemEAX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
MoveMofsStoreAddr:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,AH
        STOSB
        AND     BYTE [EARegType],NOT 80h
        CALL    WriteEADataDispOK
        JMP     AssembleDone
MoveMemRAX:
        OR      BYTE [REXOverride],48h
        JMP     MoveMofsStoreAddr
MoveMemAX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     MoveMofsStoreAddr
MoveMemInvalidOp:
        JMP     InvalidAddrMode
MoveMemAL:
        MOV     AH,0A2h
        JMP     MoveMofsStoreAddr
MoveMem:
        CMP     BL,Keyword
        JZ      MoveMemReg
        CMP     BH,Number
        JNZ     MoveInvalidOpS2
        MOV     AX,0C7h
        JMP     TranslateMemImm
MoveMemReg:
        CMP     CL,SegReg
        JAE     MoveMemReg2
        TEST    CH,CH
        JZ      MoveMemRegOpt
MoveMemRegNoOpt:
        MOV     AL,89h
        JMP     TranslateMemReg
MoveMemReg2:
        JZ      MoveMemSReg
        CMP     CL,SegReg386
        JZ      MoveMemSReg386
        JMP     AssembleDone
MoveInvalidOpS2:
        JMP     InvalidOperand2
MoveMemSReg386:
        ADD     CH,4
MoveMemSReg:
        CALL    WriteOverrides
        SHL     CH,1
        SHL     CH,1
        SHL     CH,1
        OR      BYTE [ModRM],CH
        CALL    GetOperandSize
        CMP     AH,_DWORD
        JZ      MoveMem32SReg
        CMP     AH,_QWORD
        JZ      MoveMem64SReg
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     MoveMemSRegWrite
MoveMem32SReg:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
MoveMemSRegWrite:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,8Ch
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
MoveMem64SReg:
        CMP     BYTE [AddrMode],32
        JBE     MoveMemSRegWrite
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     MoveMemSRegWrite
MoveMem11:
        JMP     MoveMem
MoveInstr:
        CALL    GetTwoOperands
        CMP     AL,Mem
        JZ      MoveMem11
        CMP     AL,Keyword
        JNZ     MoveInvalidOpF
        CMP     BL,Keyword
        JNZ     MoveRegX
        CMP     DL,LMReg64
        JA      MoveRegXXX
        CMP     CL,SegReg
        JAE     MoveXX
        MOV     AH,8Bh
        JMP     TranslateReg
MoveRegXXX:
        JMP     MoveXXX2
MoveXX:
        JMP     MoveXX2
MoveAXMem:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     MoveMofsStoreAddr
MoveALMem:
        MOV     AH,0A0h
        JMP     MoveMofsStoreAddr
MoveRAXMem:
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        JMP     MoveMofsStoreAddr
MoveRegX:
        CMP     BH,Number
        JZ      MoveRegImm
        CMP     BL,Mem
        JNZ     MoveInvalidOpS
MoveRegMem:
        CMP     DL,SegReg386
        JZ      MoveSReg386Mem
        CMP     DL,SegReg
        JZ      MoveSRegMem
MoveRegMem2:
        TEST    DH,DH
        JZ      MoveRegMemOpt
MoveRegMemNoOpt:
        MOV     AL,8Bh
        JMP     TranslateRegMem
MoveInvalidOpF:
        JMP     InvalidOperand1
MoveInvalidOpS:
        JMP     InvalidOperand2
MoveRegMemOpt:
        CMP     WORD [BaseReg],0
        JNZ     MoveRegMemNoOpt
        CMP     DL,Reg64
        JA      MoveRegMemNoOpt
        CMP     BYTE [AddrMode],4
        JB      MoveRegMemOptOK
        CMP     BYTE [EADispSize],8
        JNZ MoveRegMemNoOpt
MoveRegMemOptOK:
        CALL    WriteOverrides
        CMP     DL,Reg8
        JZ      MoveALMem
        JB      MoveInvalidOpF
        MOV     AH,0A1h
        CMP     DL,Reg32
        JB      MoveAXMem
        JA      MoveRAXMem
MoveEAXMem:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        JMP     MoveMofsStoreAddr
MoveSReg386Mem:
        ADD     DH,4
MoveSRegMem:
        CMP     DH,1
        JZ      MoveCSDest2
        CALL    WriteOverrides
        CALL    CheckOpSize16
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      BYTE [ModRM],DH
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        MOV     AL,08Eh
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
MoveRegImm:
        MOV     AL,DH
        CMP     DL,Reg8
        JZ      MoveR8Imm
        CMP     DL,Reg16
        JZ      MoveR16Imm
        CMP     DL,Reg32
        JZ      MoveR32Imm
        CMP     DL,Reg64
        JZ      MoveR64Imm
        JMP     MoveRegImm2
MoveCSDest2:
        JMP     CSDest
MoveR8Imm:
        CMP     BL,Num8
        JA      MoveRegNumTooBig
        ADD     AL,0B0h
        MOV     AH,CL
        STOSW
        JMP     AssembleDone
MoveR16Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
MoveR16Imm2:
        CMP     BL,Num16
        JA      MoveRegNumTooBig
        ADD     AL,0B8h
        STOSB
        CALL    Write16Imm
        JMP     AssembleDone
MoveR32Imm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
MoveR32Imm2:
        CMP     BL,Num32
        JA      MoveRegNumTooBig
        ADD     AL,0B8h
        STOSB
        CALL    Write32Imm
        JMP     AssembleDone
MoveR64Imm:
        MOV     AH,AL
        MOV     AL,48h
MoveR64Imm2:
        CMP     BL,Num64
        JA      MoveRegNumTooBig
        CMP     BL,Num32
        JA      MoveR64Imm64
        STOSB
        MOV     AL,0C7h
        OR      AH,0C0h
        STOSW
        CALL    Write32Imm
        JMP     AssembleDone
MoveR64Imm64:
        ADD     AH,0B8h
        STOSW
        CALL    Write64Imm
        JMP     AssembleDone
MoveInvalidAddrMode:
        JMP     InvalidAddrMode
MoveRegNumTooBig:
        JMP     NumTooBig
MoveLowRegImm:
        MOV     AL,40h
        STOSB
        MOV AL,DH
        JMP     MoveR8Imm
MoveLMR8Imm:
        MOV AL,41h
        STOSB
        MOV AL,DH
        JMP     MoveR8Imm
MoveLMR16Imm:
        MOV     WORD ES:[DI],6641h
        ADD     DI,2
        JMP     MoveR16Imm2
MoveLMR32Imm:
        MOV     AL,41h
        STOSB
        MOV AL,DH
        JMP     MoveR32Imm2
MoveLMR64Imm:
        MOV     AH,AL
        MOV     AL,49h
        JMP     MoveR64Imm2
MoveRegImm2:
        CMP     DL,LMLowReg
        JZ      MoveLowRegImm
        CMP     DL,LMReg8
        JZ      MoveLMR8Imm
        CMP     DL,LMReg16
        JZ      MoveLMR16Imm
        CMP     DL,LMReg32
        JZ      MoveLMR32Imm
        CMP     DL,LMReg64
        JZ      MoveLMR64Imm
        JMP     InvalidOperand1
MoveCSDest:
        JMP     CSDest
MoveSegReg386:
        ADD     DH,4
MoveSegReg:
        CMP     DH,1
        JZ      MoveCSDest
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      DH,CH
        OR      DH,0C0h
        CMP     CL,Reg16
        JZ      MoveSRegR16
        JB      MoveSRegInvalidOp
        CMP     CL,Reg64
        JBE     MoveSRegR162
        CMP     CL,LMReg16
        JZ      MoveSRegLMR16
        JB      MoveSRegInvalidOp
        CMP     CL,LMReg64
        JBE     MoveSRegLMR162
MoveSRegInvalidOp:
        JMP     InvalidOperand2
MoveSRegR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
MoveSRegR162:
        MOV     AL,8Eh
        MOV     AH,DH
        STOSW
        JMP     AssembleDone
MoveSRegLMR16:
        MOV     AX,66h
        STOSB
MoveSRegLMR162:
        MOV AL,41h
        STOSB
        MOV     AL,8Eh
        MOV     AH,DH
        STOSW
        JMP     AssembleDone

MoveXXX2:
        CMP     DL,SegReg386
        JZ      MoveSegReg386
        JB      MoveSegReg
        CMP     DL,CtrlReg64
        JZ      MoveCtrlReg64
        JB      MoveCtrlReg
        CMP     DL,DbgReg64
        JZ      MoveDbgReg64
        JB      MoveDbgReg
        CMP     DL,TestReg
        JZ      MoveTestReg
        JMP     InvalidOperand1
MoveDbgReg64:
        CMP     BYTE [AddrMode],4
        JB      MoveSpecialInvalidAddrMode
        MOV     AL,44h
        STOSB
MoveDbgReg:
        MOV     AX,230Fh
        XCHG    DH,CH
        JMP     MoveSpecialReg2
MoveTestReg:
        MOV     AX,260Fh
        XCHG    DH,CH
        JMP     MoveSpecialReg2

MoveCtrlReg64:
        CMP     BYTE [AddrMode],4
        JB      MoveSpecialInvalidAddrMode
        MOV     AL,44h
        STOSB
MoveCtrlReg:
        XCHG    DH,CH
        MOV     AX,220Fh
MoveSpecialReg2:
        CMP     BL,Keyword
        JNZ     MoveInvalidOpS3
        STOSW
        SHL     CH,1
        SHL     CH,1
        SHL     CH,1
        OR      DH,CH
        MOV     AL,DH
        OR      AL,0C0h
        STOSB
        CMP     CL,Reg64
        JZ      MoveSpecialRegR64
        CMP     CL,Reg32
        JNZ     MoveInvalidOpS3
        CMP     BYTE [AddrMode],4
        JAE     MoveSpecialInvalidAddrMode
        JMP     AssembleDone
MoveSpecialRegR64:
        CMP     BYTE [AddrMode],4
        JB      MoveSpecialInvalidAddrMode
        JMP     AssembleDone
MoveInvalidOpS3:
        JMP     InvalidOperand2
MoveSpecialInvalidAddrMode:
        JMP     InvalidAddrMode
MoveXCtrlReg64:
        CMP     BYTE [AddrMode],4
        JB      MoveSpecialInvalidAddrMode
MoveXCtrlReg:
        MOV     AX,200Fh
        JMP     MoveSpecialReg2

MoveXDbgReg64:
        CMP     BYTE [AddrMode],4
        JB      MoveSpecialInvalidAddrMode
MoveXDbgReg:
        MOV     AX,210Fh
        JMP     MoveSpecialReg2

MoveXTestReg:
        MOV     AX,240Fh
        JMP     MoveSpecialReg2
MoveXX2:
        CMP     CL,SegReg
        JZ      MoveXSReg
        CMP     CL,SegReg386
        JZ      MoveXSReg386
        XCHG    CL,DL
        CMP     DL,CtrlReg
        JZ      MoveXCtrlReg
        CMP     DL,CtrlReg64
        JZ      MoveXCtrlReg64
        CMP     DL,DbgReg
        JZ      MoveXDbgReg
        CMP     DL,DbgReg64
        JZ      MoveXDbgReg64
        CMP     DL,TestReg
        JZ      MoveXTestReg
        JMP     InvalidOperand1
MoveXSReg386:
        ADD     CH,4
MoveXSReg:
        SHL     CH,1
        SHL     CH,1
        SHL     CH,1
        OR      DH,CH
        OR      DH,0C0h
        MOV     AH,DH
        MOV     AL,8Ch
        CMP     DL,Reg16
        JZ      MoveR16SReg
        CMP     DL,Reg32
        JZ      MoveR32SReg
        CMP     DL,Reg64
        JZ      MoveR64SReg
        CMP     DL,LMReg16
        JZ      MoveLMR16SReg
        CMP     DL,LMReg32
        JZ      MoveLMR32SReg
        CMP     DL,LMReg64
        JZ      MoveLMR64SReg
        JMP     InvalidOperand1
MoveR16SReg:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSW
        JMP     AssembleDone
MoveR32SReg:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        STOSW
        JMP     AssembleDone
MoveR64SReg:
        MOV     BYTE ES:[DI],48h
        INC     DI
        STOSW
        JMP     AssembleDone
MoveLMR16SReg:
        MOV     WORD ES:[DI],4166h
        ADD     DI,2
        STOSW
        JMP     AssembleDone
MoveLMR32SReg:
        MOV     BYTE ES:[DI],41h
        INC     DI
        STOSW
        JMP     AssembleDone
MoveLMR64SReg:
        MOV     BYTE ES:[DI],49h
        INC     DI
        STOSW
        JMP     AssembleDone



CMovInstr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        XOR     BP,BP
        CMP     AL,Keyword
        JNZ     CMoveInvalidOpF
        CMP     BL,Mem
        JZ      CMoveRegMem
        CMP     BL,Keyword
        JNZ     CMoveInvalidOpS
        JMP     TranslateRegRegExt
CMoveInvalidOpF:
        JMP     InvalidOperand1
CMoveInvalidOpS:
        JMP     InvalidOperand2
CMoveRegMem:
        JMP     TranslateRegMemExt