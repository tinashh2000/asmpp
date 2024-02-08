AaxInstr:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,[OBufferPtr]
        MOV     CH,0Ah
        CMP     AL,EndOfLine
        JZ      AaxStore
        CMP     AH,Number
        JNZ     AaxNumExpected
        CMP     AL,Num8
        JNZ     AaxNumTooBig
        MOV     CH,DL
AaxStore:
        MOV     AH,CH
        LODSB
        STOSW
        JMP     AssembleDone
AaxNumExpected:
        JMP     NumExpected
AaxNumTooBig:
        JMP     NumTooBig

Imm8op:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,[OBufferPtr]
Imm8op1:
        CMP     AH,Number
        JNZ     Imm8NumExpected
        CMP     AL,Num8
        JNZ     Imm8NumTooBig
        MOV     AH,DL
        LODSB
        CMP     AX,03CDh
        JZ      Imm8Int3
        STOSW
        JMP     AssembleDone
Imm8Int3:
        DEC     AL
        STOSB
        JMP     AssembleDone
Imm8NumTooBig:
        JMP     NumTooBig
Imm8NumExpected:
        JMP     NumExpected

LxS2MemExpected:
        JMP     MemOpExpected
LxS2Instr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     BL,Mem
        JNZ     LxS2MemExpected
        CMP     AL,Keyword
        JNZ     LxS2InvalidOpF
        CALL    WriteOverrides
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      BYTE [ModRM],DH
        CMP     DL,Reg16
        JZ      LxS2R16
        CMP     DL,Reg32
        JZ      LxS2R32
        CMP     DL,Reg64
        JZ      LxS2R64
        OR      BYTE [REXOverride],44h
        CMP     DL,LMReg16
        JZ      LxS2R16
        CMP     DL,LMReg32
        JZ      LxS2R32
        CMP     DL,LMReg64
        JZ      LxS2R64
LxS2InvalidOpF:
        JMP     InvalidOperand1
LxS2R16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     LxS2StoreMem
LxS2R32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
LxS2StoreMem:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOVSW
        CALL    WriteEAData
        JMP     AssembleDone
LxS2R64:
        OR      BYTE [REXOverride],48h
        JMP     LxS2StoreMem
LxS1MemExpected:
        JMP     MemOpExpected
LxS1Instr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     BL,Mem
        JNZ     LxS1MemExpected
        CMP     AL,Keyword
        JNZ     LxS1InvalidOpF
        CALL    WriteOverrides
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      BYTE [ModRM],DH
        CMP     DL,Reg16
        JZ      LxS1R16
        CMP     DL,Reg32
        JZ      LxS1R32
        CMP     DL,Reg64
        JZ      LxS1R64
        OR      BYTE [REXOverride],44h
        CMP     DL,LMReg16
        JZ      LxS1R16
        CMP     DL,LMReg32
        JZ      LxS1R32
        CMP     DL,LMReg64
        JZ      LxS1R64
LxS1InvalidOpF:
        JMP     InvalidOperand1
LxS1R16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     LxS1StoreMem
LxS1R32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
LxS1StoreMem:
        MOV     AL,BYTE [REXOverride]
LxS1StoreMem2:
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOVSB
        CALL    WriteEAData
        JMP     AssembleDone
LxS1R64:
        OR      BYTE [REXOverride],48h
        JMP     LxS1StoreMem2

LEANoMem:
        CMP     BH,Number
        JNZ     LEAInvalidOperand2
        PUSH    AX,SI
        MOV     AX,DS
        MOV     ES,AX
        CALL    NumToEA
        POP     SI,AX
        JMP     LEAP2
LEAPInstr:        
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     BL,Mem
        JNZ     LEANoMem
LEAP2:
        CMP     AL,Keyword
        JNZ     LEAInvalidOperand
        LES     DI,DWORD [OBufferPtr]
        CALL    WriteOverrides
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      BYTE [ModRM],DH
        CMP     DL,Reg16
        JZ      LEAR16
        CMP     DL,Reg32
        JZ      LEAR32
        CMP     DL,Reg64
        JZ      LEAR64
        OR      BYTE [REXOverride],44h
        CMP     DL,LMReg16
        JZ      LEAR16
        CMP     DL,LMReg32
        JZ      LEAR32
        CMP     DL,LMReg64
        JZ      LEAR64
LEAInvalidOperand:
        JMP     InvalidOperand1
LEAInvalidOperand2:
        JMP     InvalidOperand2
LEAR16:
        CALL    CheckOpSize16
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     LEAMemWrite
LEAR32:
        CALL    CheckOpSize32
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
LEAMemWrite:
        MOV     AL,BYTE [REXOverride]
LEAMemWrite2:
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,8Dh
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
LEAR64:
        CALL    CheckOpSize64
        OR      BYTE [REXOverride],48h
        JMP     LEAMemWrite2


RepPrefix:        
        XOR     AL,AL
        MOV     BYTE [InstrPresent],AL
        XCHG    AL,BYTE [SegOverride]
        LES     DI,DWORD [OBufferPtr]
        CMP     AL,1
        CMC
        MOV     BYTE ES:[DI],AL
        ADC     DI,0
        MOV     SI,BX
        MOVSB
RepPrefixCheckNext:
        PUSH    DI
        CALL    GetOperand
        POP     DI
        CMP     AL,CPUInstruction
        JZ      RepPrefixOtherInstr
RepPrefixDone:
        JMP     AssembleDone
RepPrefixOtherInstr:
        CALL    UpdateProgIP
        CMP     DX,OFFSET RepPrefix
        JZ      RepPrefixCheckNext
        MOV     BX,DX
        MOV     DX,WORD [BX]
        ADD     BX,2
        JMP     DX
Ret64InvalidAddr:
        JMP InvalidAddrMode
Ret64Instr:
        CMP     BYTE [AddrMode],4
        JB  Ret64InvalidAddr
        PUSH    BX
        CALL    GetOperand
        POP SI
        LES     DI,DWORD [OBufferPtr]
;        MOV BYTE ES:[DI],48h	Ret in 64-bit doesnt need rex.w
;        INC DI
        JMP RetInstr2
Ret16Instr:
        PUSH    BX
        CALL    GetOperand
        POP SI
        LES     DI,DWORD [OBufferPtr]
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr16Disp]
        JMP RetInstr2
Ret32Instr:
        CMP BYTE [AddrMode],2
        JA  Ret32InvalidMode
        PUSH    BX
        CALL    GetOperand
        POP SI
        LES     DI,DWORD [OBufferPtr]
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr32Disp]
        JMP RetInstr2
Ret32InvalidMode:
        JMP InvalidAddrMode

RetfP32Instr:
        PUSH    BX
        CALL    GetOperand
        POP SI
        LES     DI,DWORD [OBufferPtr]
        MOV BYTE ES:[DI],66h
        ADD DI,[Addr32Disp]
		JMP	RetInstr2
		
RetfPInstr:
		CMP	BYTE [AddrMode],4
		JNZ	retPInstr
RetfP64Instr:
        PUSH    BX
        CALL    GetOperand
        POP SI
        LES     DI,DWORD [OBufferPtr]
		MOV BYTE ES:[DI],48h	;In 64-bit mode, always put a REX.W byte
        INC DI
		JMP	RetInstr2
RetPInstr:
        PUSH    BX
        CALL    GetOperand
        POP SI
        LES     DI,DWORD [OBufferPtr]
RetInstr2:
        CMP     AL,EndOfLine
        JNZ     RetPInstrGetImm
RetInstr2NoImm:
        MOV     AL,[ProcFlags]
        TEST    AL,20h
        JZ      RetPInstr2
        MOV SI,OFFSET RetFInstr+2
RetPInstr2:
        TEST    AL,10h
        JNZ     RetPInstrProcLocal
        TEST    AL,08
        JNZ     RetPInstrProcArg
RetPInstrRetOK:
        MOVSB
        JMP     AssembleDone
RetPInstrProcLocal:
        TEST    AL,4
        JNZ     RetPInstrProcLocal86
        MOV     AL,0C9h
        STOSB
        TEST    AL,8
        JNZ     RetPInstrProcArg2
        MOVSB
        JMP     AssembleDone
RetPInstrProcLocal86:
        MOV     AX,0E58Bh
        STOSW
        MOV     AL,5Dh
        STOSB
        TEST    AL,8
        JNZ     RetPInstrProcArg2
        MOVSB
        JMP     AssembleDone
RetPInstrProcArg:
        MOV     AL,5Dh
        STOSB
RetPInstrProcArg2:
        MOV     BX,[ProcArgSize]
        TEST    BX,BX
        JZ      RetPInstrRetOK
        LODSB
        DEC     AL
        STOSB        
        MOV     AX,BX
        STOSW
        JMP     AssembleDone
RetPInstrGetImm0:
        MOV WORD [ProcArgSize],0
        JMP RetInstr2NoImm
RetPInstrGetImm:
        CMP     AH,Number
        JNZ     RetNumExpected
        CMP     AL,Num16
        JA      RetNumTooBig
        TEST DX,DX
        JZ RetPInstrGetImm0
        LODSB
        DEC     AL
        STOSB
        CALL    Write16Imm2
        JMP     AssembleDone
RetNumExpected:
        JMP     NumExpected
RetNumTooBig:
        JMP     NumTooBig
R16RM16:
        JMP     AssembleDone
SetError:
        JMP     ByteOperandExpected
SetInstr:        
        MOV     BYTE [OperandSize],_BYTE
        OR      BYTE [Settings],40h
        PUSH    BX
        CALL    GetOperand
        POP     SI
        LES     DI,DWORD [OBufferPtr]
        CMP     AL,Keyword
        JNZ     SetGetMem
        CMP     DL,Reg8
        JZ      SetR8
        CMP     DL,LMReg8
        JZ      SetLM8
        CMP     DL,LMLowReg
        JNZ     SetError
        MOV     AL,40h
        JMP     SetLM8Store
SetLM8:
        MOV     AL,41h
SetLM8Store:
        STOSB
SetR8:
        MOVSW
        OR      DH,0C0h
        MOV     AL,DH
        STOSB
        JMP     AssembleDone
SetGetMem:
        CMP     AL,Mem
        JNZ     SetError
        CALL    CheckOpSize8
        CALL    WriteOverrides
SetMemSizeOK:
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOVSW
        CALL    WriteEAData
        JMP     AssembleDone


XchgOptRLMR:
        MOV     AL,41h
        STOSB
        JMP     XchgOptReg2
XchgOptInvalidOpS:
        JMP     InvalidOperand2
XchgOptR64LMR64:
        MOV     AL,49h
        STOSB
        ADD     CH,90h
        MOV     AL,CH
        STOSB
        JMP     AssembleDone
XchgOptR16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        CMP     CL,LMReg16
        JZ      XchgOptRLMR
        CMP     CL,Reg16
        JNZ     XchgOptInvalidOpS
XchgOptReg2:
        ADD     CH,90h
        MOV     AL,CH
        STOSB
        JMP     AssembleDone
XchgOptR32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        CMP     CL,LMReg32
        JZ      XchgOptRLMR
        CMP     CL,Reg32
        JZ      XchgOptReg2
        JMP     InvalidOperand2
XchgOptR64:
        CMP     CL,LMReg64
        JZ      XchgOptR64LMR64
        CMP     CL,Reg64
        JNZ     XchgOptInvalidOpS
        MOV     AL,48h
        STOSB
        JMP    XchgOptReg2
XchgNotKeyword:
        CMP     AL,Mem
        JNZ     XchgInvalidOpF
        CMP     BL,Keyword
        JNZ     XchgInvalidOpS
        MOV     AL,87h
        JMP     TranslateMemReg
XchgPInstr:
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     XchgNotKeyword
        CMP     BL,Keyword
        JNZ     XchgRegCheckMem
        CMP     DL,Reg64
        JA      XchgPInstrRegs2
        TEST    DH,DH
        JNZ     XchgPInstrRegs2
XchgPInstrRegOpt:
        MOV     BL,DH
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      DH,CH
        OR      DH,0C0h
        CMP     DL,Reg16
        JZ      XchgOptR16
        CMP     DL,Reg32
        JZ      XchgOptR32
        CMP     DL,Reg64
        JZ      XchgOptR64
        CMP     DL,Reg8
        JNZ     XchgInvalidOpF
        MOV     AH,87h
        JMP     TranslateR8
XchgInvalidOpF:
        JMP     InvalidOperand1
XchgInvalidOpS:
        JMP     InvalidOperand2
XchgPInstrRegs3:
        TEST    CH,CH
        JNZ     XchgPInstrRegs4
        XCHG    DX,CX
        JMP     XchgPInstrRegOpt
XchgPInstrRegs2:
        CMP     CL,Reg64
        JB      XchgPInstrRegs3
XchgPInstrRegs4:
        MOV     AH,87h
        JMP     TranslateReg
XchgRegCheckMem:
        CMP     BL,Mem
        JNZ     XchgInvalidOpS
        MOV     AL,087h
        JMP     TranslateRegMem

BSwapPInstr:        
        CALL    GetOperand
        LES     DI,[OBufferPtr]
        CMP     AL,Keyword
        JNZ     BSwapInvalidOp
        CMP     DL,Reg16
        JZ      BSwapReg16
        CMP     DL,Reg32
        JZ      BSwapReg32
        CMP     DL,Reg64
        JZ      BSwapReg64
        CMP     DL,LMReg16
        JZ      BSwapLMReg16
        CMP     DL,LMReg32
        JZ      BSwapLMReg32
        CMP     DL,LMReg64
        JZ      BSwapLMReg64
BSwapInvalidOp:
        JMP     InvalidOperand
BSwapReg16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,0Fh
        MOV     AH,DH
        ADD     AH,0C8h
        STOSW
        JMP     AssembleDone
BSwapReg32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,0Fh
        MOV     AH,DH
        ADD     AH,0C8h
        STOSW
        JMP     AssembleDone
BSwapReg64:
        MOV     AL,48h
        STOSB
        MOV     AL,0Fh
        MOV     AH,DH
        ADD     AH,0C8h
        STOSW
        JMP     AssembleDone
BSwapLMReg16:
        MOV     AL,66h
        STOSB
        MOV     AL,41h
        STOSB
        MOV     AL,0Fh
        MOV     AH,DH
        ADD     AH,0C8h
        STOSW
        JMP     AssembleDone
BSwapLMReg32:
        MOV     AL,41h
        STOSB
        MOV     AL,0Fh
        MOV     AH,DH
        ADD     AH,0C8h
        STOSW
        JMP     AssembleDone
BSwapLMReg64:
        MOV     AL,49h
        STOSB
        MOV     AL,0Fh
        MOV     AH,DH
        ADD     AH,0C8h
        STOSW
        JMP     AssembleDone
BSwapInvalidAddrMode:
        JMP     InvalidAddrMode
EnterPInstr:
        CALL    GetTwoOperands
        CMP     AH,Number
        JNZ     EnterNumExpected
        CMP     BH,Number
        JNZ     EnterNumExpected
        CMP     AL,Num16
        JA      EnterNumTooBig
        CMP     BL,Num8
        JA      EnterNumTooBig
        MOV     AL,0C8h
        STOSB
        XCHG    CX,DX
        CALL    Write16Imm
        MOV     AL,DL
        STOSB
        JMP     AssembleDone
EnterNumExpected:
        JMP     NumExpected
EnterNumTooBig:
        JMP     NumTooBig

Imm32Op:
        OR      BYTE [Settings][1],2
        PUSH    BX
        CALL    GetOperand
        POP     SI
        AND     BYTE [Settings][1],NOT 2
        LES     DI,[OBufferPtr]
        CMP     AH,Number
        JNZ     EnterNumExpected
        CMP     AL,Num32
        JA      EnterNumTooBig
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOVSB
        CALL    Write32Imm
        JMP     AssembleDone


ArplPInstr:
        CALL    GetTwoOperands
        LES     DI,DWORD [OBufferPtr]
        CMP     BL,Keyword
        JNZ     ArplPInvalidOpS
        CMP     CL,LMReg16
        JZ      ArplPRegOK
        CMP     CL,Reg16
        JNZ     ArplPInvalidOpS
ArplPRegOK:
        CMP     AL,Mem
        JZ      ArplPMemReg
        CMP     AL,Keyword
        JNZ     ArplPInvalidOpF
        MOV     AH,63h
        XCHG    DX,CX
        JMP     TranslateReg
ArplPInvalidOpF:
        JMP     InvalidOperand1
ArplPInvalidOpS:
        JMP     InvalidOperand2
ArplPMemReg:
        MOV     AL,63h
        JMP     TranslateMemReg
BoundInvalidAddr:
        JMP     InvalidAddrMode
BoundPInstr:
        CMP     BYTE [AddrMode],4
        JAE     BoundInvalidAddr
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     BoundInvalidOpF
        CMP     BL,Mem
        JNZ     BoundInvalidOpS
        LES     DI,DWORD [OBufferPtr]
        CALL    WriteOverrides
        SHL     DH,1
        SHL     DH,1
        SHL     DH,1
        OR      BYTE [ModRM],DH
        MOV     BYTE ES:[DI],66h
        MOV     BX,OFFSET Addr16Disp
        MOV     AH,_DWORD
        CMP     DL,Reg16
        JZ      BoundRegOK
        CMP     DL,Reg32
        JNZ     BoundInvalidOpF
        MOV     AH,_QWORD
        MOV     BX,OFFSET Addr32Disp
BoundRegOK:
        MOV     AL,BYTE [OperandSize]
        CMP     AL,AH
        JZ      BoundSizeOK
        TEST    AL,AL
        JNZ     BoundInvalidSize
BoundSizeOK:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [BX]
        MOV     AL,62h
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
BoundInvalidSize:
        JMP     InvalidOperandSize            
BoundInvalidOpF:
        JMP     InvalidOperand1
BoundInvalidOpS:
        JMP     InvalidOperand2


MMemOpExpected:
        JMP     MemOpExpected
MemOp:
        MOV     SI,BX
        MOV     DI,OFFSET Temp1
        MOVSW
        MOVSW
        CALL    GetOperand
        CMP     AL,Mem
        JNZ     MMemOpExpected
        MOV     AL,[OperandSize]
        TEST    AL,AL
        JZ      MemOpSizeOK
        CMP     AL,[Temp2][1]
        JNZ     MemOpInvalidSize
MemOpSizeOK:
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AX,WORD [Temp1]
        STOSW
        MOV     AL,BYTE [Temp2]
        OR      [ModRM],AL
        CALL    WriteEAData
        JMP     AssembleDone
MemOpInvalidSize:
        JMP     InvalidOperandSize
MemOp2:
        MOV     SI,BX
        MOV     DI,OFFSET Temp1
        MOVSW
        MOVSB
        CALL    GetOperand
        CMP     AL,Mem
        JNZ     MMemOpExpected
        MOV     AL,[OperandSize]
        TEST    AL,AL
        JZ      MemOp2SizeOK
        CMP     AL,BYTE [Temp2]
        JNZ     MemOp2InvalidSize
MemOp2SizeOK:
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AX,WORD [Temp1]
        OR      [ModRM],AH
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
MemOp2InvalidSize:
        JMP     InvalidOperandSize

MovDPInstr:
        JMP     AssembleDone

CmpXchgPInstr:
        CALL    GetTwoOperands
        LES     DI,DWORD [OBufferPtr]
        CMP     BL,Keyword
        JNZ     CmpXChgInvalidOpS
        MOV     SI,OFFSET CmpXchgInstr+2
        OR      BP,1
        CMP     AL,Mem
        JZ      CmpXChgMem
        CMP     AL,Keyword
        JNZ     CmpXchgInvalidOpF
        XCHG    CX,DX
        JMP     TranslateRegRegExt
CmpXChgMem:
        JMP     TranslateMemRegExt
CmpXChgInvalidOpF:
        JMP     InvalidOperand1
CmpXChgInvalidOpS:
        JMP     InvalidOperand2
CmpXChg8BMemExpected:
        JMP     MemOpExpected
CmpXChg8BPInstr:
        CALL    GetOperand
        MOV     BL,_QWORD
CmpXChg8B2:
        CMP     AL,Mem
        JNZ     CmpXChg8BMemExpected
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      CmpXChg8SizeOK
        CMP     AL,BL
        JNZ     CmpXchgInvalidOpSize
CmpXChg8SizeOK:
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AX,0C70Fh
        STOSW
        OR      BYTE [ModRM],8
        CALL    WriteEAData
        JMP     AssembleDone
CmpXchgInvalidOpSize:
        JMP     InvalidOperandSize
CmpXChg16BPInstr:
        CALL    GetOperand
        OR      BYTE [REXOverride],48h
        MOV     BYTE [REXDisp],1
        MOV     BL,_OWORD
        JMP     CmpXChg8B2

XAddPInstr:
        CALL    GetTwoOperands
        OR      BP,1
        MOV     SI,OFFSET XAddInstr+2
        CMP     BL,Keyword
        JNZ     XAddInvalidOpS
        CMP     AL,Mem
        JZ      XAddMemReg
        CMP     AL,BL
        JNZ     XAddInvalidOpF
        XCHG    CX,DX
        JMP     TranslateRegRegExt
XAddMemReg:
        JMP     TranslateMemRegExt
XAddInvalidOpF:
        JMP     InvalidOperand1
XAddInvalidOpS:
        JMP     InvalidOperand2
BitScanRegExpected:
        JMP     InvalidOperand1
BitScanInstr:
        PUSH    BX
        CALL    GetTwoOperands
        POP     SI
        CMP     AL,Keyword
        JNZ     BitScanRegExpected
        XOR     BP,BP
        CMP     BL,Mem
        JZ      BitScanMem
        CMP     BL,Keyword
        JNZ     BitScanInvalidOpS
        JMP     TranslateRegRegExt
BitScanInvalidOpS:
        JMP     InvalidOperand2
BitScanMem:
        JMP     TranslateRegMemExt
SwapGSPInstr:
        LES     DI,DWORD [OBufferPtr]
        MOV     AX,010Fh
        STOSW
        MOV     AL,0F8h
        STOSB
        JMP     AssembleDone


        
PrefetchMemOpExpected:
        JMP     MemOpExpected
PrefetchInvalidOpSize:
        JMP     InvalidOperandSize
PrefetchPInstr:
        PUSH    BX
        CALL    GetOperand
        POP     SI
        CMP     AL,Mem
        JNZ     PrefetchMemOpExpected
        MOV     AL,BYTE [OperandSize]
        TEST    AL,AL
        JZ      PrefetchOpSizeOK
        CMP     AL,_BYTE
        JNZ     PrefetchInvalidOpSize
PrefetchOpSizeOK:
        LES     DI,DWORD [OBufferPtr]
        CALL    WriteOverrides
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,0Fh
        STOSB
        MOVSB
        LODSB
        OR      BYTE [ModRM],AL
        CALL    WriteEAData
        JMP     AssembleDone

XlatMemExpected:
        JMP     MemOpExpected
XlatInvalidAddress:
        JMP     InvalidEAEntry
XlatInvalidOpSize:
        JMP     InvalidOperandSize
xlatpinstr:
        CALL    GetOperand
        CMP     AL,EndOfLine
        JZ      XlatNoOp
        CMP     AL,Mem
        JNZ     XlatMemExpected
        CMP     BYTE [EADispSize],0
        JNZ     XlatInvalidAddress
        CMP     WORD [BaseReg],3+1
        JNZ     XlatInvalidAddress
        CMP     BYTE [OperandSize],ByteID+1
        JA      XlatInvalidOpSize
XlatNoOp:
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AL,[REXOverride]
        MOV     ES:[DI],AL
        ADD     DI,[REXDisp]
        MOV     AL,0D7h
        STOSB
        JMP     AssembleDone

MWaitInvalidOpF:
        JMP     InvalidOperand1
MWaitInvalidOp:
        CMP     DH,0
        JNZ     MWaitInvalidOpF
MWaitInvalidOpS:
        JMP     InvalidOperand2
MWaitPInstr:
        MOV     AL,[NextChar]
        CMP     AL,Char0A
        JZ      MWaitOpOK
        CMP     AL,SemiColon
        JZ      MWaitOpOK
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     MWaitInvalidOpF
        CMP     AL,BL
        JNZ     MWaitInvalidOpS
        CMP     DL,Reg32
        JNZ     MWaitInvalidOpF
        CMP     DL,CL
        JNZ     MWaitInvalidOpS
        MOV     DL,CH
        CMP     DX,0 SHL 8 OR 1
        JNZ     MWaitInvalidOp
MWaitOpOK:
        LES     DI,[OBufferPtr]
        MOV     AX,010Fh
        STOSW
        MOV     AL,0C9h
        STOSB
        JMP     AssembleDone
MonitorPInstr:
        MOV     AL,[NextChar]
        CMP     AL,Char0A
        JZ      MonitorOpOK
        CMP     AL,SemiColon
        JZ      MonitorOpOK
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     MWaitInvalidOpF
        CMP     AL,BL
        JNZ     MWaitInvalidOpS
        CMP     DL,Reg32
        JNZ     MWaitInvalidOpF
        CMP     CL,DL
        JNZ     MWaitInvalidOpS
        MOV     DL,CH
        CMP     DX,0 SHL 8 OR 1
        JNZ     MWaitInvalidOp
        CALL    GetNext
        CMP     AL,Keyword
        JNZ     MWaitInvalidOp
        CMP     DX,2 SHL 8 OR Reg32
        JNZ     MonitorInvalidOp3
MonitorOpOK:
        LES     DI,[OBufferPtr]
        MOV     AX,010Fh
        STOSW
        MOV     AL,0C8h
        STOSB
        JMP     AssembleDone
MonitorInvalidOp3:
        JMP     InvalidOperand3

IretXInstr:
        LES     DI,[OBufferPtr]
		CMP	BYTE [AddrMode], 4
		JZ iretXq
		MOV AL,0CFh
		STOSB
		JMP AssembleDone
		
iretXq:
		MOV	AX, 0CF48h
		STOSW
		JMP	AssembleDone