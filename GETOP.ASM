GetOperandInvalidAddr:
        JMP     InvalidAddrMode

GetOperandSegWrite386:
        ADD     DH,64h
        MOV     BYTE [SegOverride],DH
        JMP     GetOperand

GetOperandEA16:
        MOV     BYTE [EADispSize],2
        JMP     GetOperandProcessOK
GetOperandEA32:
        MOV     BYTE [EADispSize],4
        JMP     GetOperandProcessOK
GetOperandInProcess2:
        RET

GetOperandLMReg:
        CMP     BYTE [AddrMode],4
        JB      GetOperandInvalidAddr
        MOV     BYTE [REXDisp],1
        OR      BYTE [Settings],16
        RET
GetOperandInProcess:
        TEST    BYTE [Process],NOT 2
        JNZ     GetOperandInProcess2
        CMP     DH,_WORD
        JZ      GetOperandEA16
        CMP     DH,_DWORD
        JZ      GetOperandEA32
        CMP     DH,_QWORD
        JNZ     GetOperandInProcess2
        MOV     BYTE [EADispSize],8
        JMP     GetOperandProcessOK

GetOperandSegReg:        
        MOV     BL,0
        CMP     CH,OpenSqBracket
        JZ 	GetOperandSegReg_Override
		
	CMP CH, Colon
	JNZ	GetOperandKWDone
        INC     WORD [InBufferPtr]
GetOperandSegReg_Override:	
        OR      BYTE [Settings],80h
        CMP     DL,SegReg386
        JZ      GetOperandSegWrite386
        MOV     CL,3
        SHL     DH,CL
        ADD     DH,26h
        MOV     BYTE [SegOverride],DH
        JMP     GetOperand

GetOperandKW2:
        CMP     DL,SegReg
        JZ      GetOperandSegReg
        CMP     DL,SegReg386
        JZ      GetOperandSegReg
        JB      GetOperandLMReg
        CMP     DL,Operator
        JZ      GetOperandKWOperator
        CMP     DL,DataType
        JZ      GetOperandDataType
        CMP     DL,SSEReg
        JNZ     GetOperandKW2_Ret
        CMP	DH, 8
        JAE	GetOperandLMReg
GetOperandKW2_Ret:
        RET
GetOperandDataType:
        CMP     BYTE [Process],0
        JNZ     GetOperandInProcess
        MOV     BYTE [OperandSize],DH
GetOperandProcessOK:        
        OR      BYTE [Settings],40h
;        CALL    GetNextInit
        CALL    GetNext
        JMP     GetOperand2
GetOperandSpecialOperator:
        CMP     DH,10
        JAE     GetOperandSpecialOp2
        CALL    DoSpecialOperation
        JMP     GetOperand2
GetOperandSpecialOp3:
        MOV     DX,BX
        JMP     ProcessQuote
GetOperandSpecialOp2:
        CMP     DH,20
        JZ      GetOperandSpecialOp3
        CALL    DoStrOperation
        CMP     AH,Number
        JZ      GetOperandSpecialNum
        JMP     ProcessQuoteInit
GetOperandSpecialNum:
        CALL    GetNextCharI
        JMP     GetOperand2
GetOperandKW:        
        CMP     DL,Reg64
        JAE     GetOperandKW2
GetOperandKWDone:
        RET

GetOperandKWOperator:
        CMP     DH,PtrOp
        JZ      GetOperandPTR
        CMP     DH,20
        JBE     GetOperandSpecialOperator
        MOV     AL,DH
        JMP     GetOperandOperator
GetOperandPTR:
        MOV     BYTE [NeedSq],0
        JMP     ProcessEA
GetOperandEnterEA2:
        MOV     SI,OFFSET OWordNum
        INC     WORD [InBufferPtr]
        JMP     GetOperandEnterEA2NumberOK
GetOperandTestSq:
        CMP     CH,OpenSqBracket
        JZ      GetOperandEnterEA2
GetOperandGetSize:
        RET
GetOperandInvalidInstr:
        MOV     AL,CPUInstruction
GetOperandInvalidKW:
        CMP     BYTE [InstrPresent],0
        JZ      GetOperandDone
        JMP     InvalidKeyword
GetOperandNumber:        
        CMP     BYTE [Process],0
        JNZ     GetOperandDone
        TEST    BYTE [Settings],0C0h
        JNZ     GetOperandEnterEA
GetOperandNumberCheckNext:
        CMP     CH,Alpha
        JZ      GetOperandEnterCalc
        CMP     CH,Period
        JB      GetOperandTestSq
        CMP     CH,BoolOrOp
        JA      GetOperandGetSize
GetOperandEnterCalc:
        JMP     CalcNumbers
GetOperand:
        AND     [Settings][1],NOT 16
				
        CALL    GetNext	
		
GetOperand2:
        MOV     CH,BYTE [NextChar]
		
        CMP     AL,Keyword
        JZ      GetOperandKW
        CMP     AH,Number
        JZ      GetOperandNumber
        CMP     AL,OpenSqBracket
        JZ      GetOperandEA
        CMP     AL,OpenBracket
        JZ      GetOperandExpr
        CMP     AL,BoolOrOp
        JA      GetOperand3
        CMP     AL,Period
        JA      GetOperandOperator
GetOperandDone:
        RET
GetOperand3:
        CMP     AL,CPUInstruction
        JNZ     GetOperandDone
        CALL    GetInstrOperator        
        JC      GetOperandInvalidInstr
GetOperandOperator:
        CMP     BYTE [Process],0
        JNZ     GetOperandDone
        MOV     BYTE [CurOp],AL
        XOR     AX,AX
        MOV     DI,OFFSET SaveNum
        CMP     BYTE [OperandSize],_DWORD
        JA      GetOperandEnterCalc64
        STOSW
        STOSW
        JMP     CalcGetNumber
GetOperandEnterCalc64:
        MOV     CX,4
        REP     STOSW
        JMP     CalcGetNumber64
GetOperandEnterEA:
        TEST    BYTE [Settings][1],2
        JNZ     GetOperandNumberCheckNext
        TEST    BYTE [Settings],20h
        JNZ     GetOperandNumberCheckNext
        MOV     BYTE [NeedSq],0
        MOV     BX,AX
        MOV     DI,OFFSET EADisp
        MOV     CX,10
        XOR     AX,AX
        REP     STOSW
        MOV     AX,BX
        OR      BYTE [Process],2
        TEST    BYTE [Settings][1],16
        JNZ     GetOperandEnterEAReloc
        JMP     ProcessEALoop2
EVEN 2
GetOperandEA:

        CMP     BYTE [Process],0
        JNZ     GetOperandDone
        MOV     BYTE [NeedSq],1
        JMP     ProcessEA
GetOperandEnterEAReloc:
        JMP     GetOperandEnterEAReloc2
GetOperandDone2:
        RET
		
		
CalcNum64:
        JMP     CalcNumbers64
EVEN 2
GetOperandExpr:
        CMP     BYTE [Process],0
        JNZ     GetOperandDone
        CALL    ProcessExpression
        AND     BYTE [Process],NOT 1
        TEST    AH,AH
        JNZ     GetOperandDone2
CalcNumbers:
        CMP     BYTE [OperandSize],_DWORD
        JA      CalcNum64
        MOV     DI,OFFSET SaveNum
        MOV     SI,OFFSET OWordNum
        MOVSW
        MOVSW
CalcGetOperator:
        CALL    GetNext
        CMP     AL,CPUInstruction
        JZ      CalcInstr
        CMP     AL,Keyword
        JZ      CalcKeyword
CalcTestOperator:
        CALL    CombineOperators
        JC      CalcMissingOperator
CalcGetNumber:        
        CALL    GetNext
CalcProcessInput:
        CMP     AH,Number
        JNZ     CalcTestOperator2
        CMP     AL,Num32
        JA      CalcNumTooBig
CalcOperateNumbers:
        MOV     SI,OFFSET OWordNum
        MOV     DI,OFFSET SaveNum
        CALL    Calc32
        MOV     AL,BYTE [NextChar]
        CMP     AL,Colon
        JZ      CalcDone
        CMP     AL,Comma
        JZ      CalcDone
        CMP     AL,Char0A
        JZ      CalcDone
        CMP     AL,SemiColon
        JZ      CalcDone
        JMP     CalcGetOperator
CalcKeyword:
        CMP     DL,Operator
        JNZ     CalcMissingOperator
        CMP     DH,20
        JB      CalcKWOperator
        CMP     BYTE [CurOp],0
        JNZ     CalcInvalidEntry
        MOV     BYTE [CurOp],DH
        JMP     CalcGetNumber
CalcKWOperator:
        CMP     DH,10
        JAE     CalcInvalidEntry
        CALL    DoSpecialOperation
        JMP     CalcProcessInput
CalcInstr:
        CALL    GetInstrOperator
        MOV     BYTE [CurOp],AL
        JNC     CalcGetNumber
        MOV     BYTE [CurOp],0
        MOV     BYTE [Temp1],90h
        MOV     AL,CPUInstruction
        CMP     DX,OFFSET DUPDirective
        JZ      CalcDone2
        JMP     InvalidKeyword
CalcTestOperator2:
        CMP     AL,OpenBracket
        JZ      CalcNewExpr
        CMP     AL,Keyword
        JZ      CalcKeyword
        CALL    CombineOperators
        JNC     CalcGetNumber
CalcInvalidEntry:
        JMP     InvalidEAEntry
CalcMissingOperator:
        CMP     AL,OpenSqBracket
        JZ      GetOperandEnterEA3
        JMP     MissingOperator
CalcNumTooBig:
        JMP     NumTooBig
CalcNewExpr:
        MOV     AL,BYTE [CurOp]
        PUSH    AX
        CALL    ProcessExpression
        AND     BYTE [Process],NOT 1
        POP     AX
        MOV     BYTE [CurOp],AL
        JMP     CalcOperateNumbers
CalcDone:
        MOV     SI,OFFSET SaveNum
GetNumSize32:
        MOV     DI,OFFSET OWordNum
        MOV     DX,WORD [SI]
        CMP     WORD [SI][2],0
        JNZ     CalcDoneMayBe32
CalcDoneTest16:
        MOVSW
        MOVSW
        XOR     AX,AX
        STOSW
        STOSW
        MOV     AX,Number SHL 8 OR Num8
        MOV     CL,DH
        INC     CL  ;IF CL=0 it becomes 0, IF 0FF it becomes zero.
        CMP     CL,1 ;IF its 1 OR below
        JBE     CalcDone2
        MOV     AL,Num16
        CMP     DX,-128
        JL      CalcDone2
        CMP     DX,127
        JG      CalcDone2
        MOV     AL,Num8
CalcDone2:
        RET

CalcDoneMayBe32:
        CMP     WORD [SI][2],-1
        JNZ     CalcDoneNum32
        CMP     DX,0FFh
        JA      CalcDoneTest16
CalcDoneNum32:
        MOVSW
        MOVSW
        XOR     AX,AX
        STOSW
        STOSW
        MOV     AX,Number SHL 8 OR Num32
        RET
CalcNumbers64:
CalcGetNumber64:
        RET

GetOperandEnterEA3:
        MOV     SI,OFFSET SaveNum
GetOperandEnterEA2NumberOK:
        MOV     BX,AsmData
        MOV     ES,BX
        MOV     DI,OFFSET EADisp
        MOVSW
        MOVSW
        MOVSW
        MOVSW
        XOR     AX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     BYTE [NeedSq],1
        MOV     BYTE [EADispSize],2
        TEST    BYTE [Settings][1],16
        JNZ GetOperandEnterEAReloc4
        JMP     ProcessEAInit2
GetOperandEnterEAReloc4:        
        MOV BX,OFFSET ProcessEAInit2
        JMP GetOperandEnterEAReloc3
GetOperandEnterEAReloc2:
        MOV BX,OFFSET ProcessEALoop2
GetOperandEnterEAReloc3:
        MOV DI,OFFSET RelocFlags2
        TEST    BYTE [RelocFlags2],1
        JNZ GetOperandEnterEARelocOK
        MOV DI,OFFSET RelocFlags
GetOperandEnterEARelocOK:
        MOV CL,[DI]
        AND CL,1
        ADD CL,CL
        OR  [DI],CL
        JMP BX
