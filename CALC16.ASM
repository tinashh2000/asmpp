EVEN 2
Calc32:
        XOR     BL,BL
        XCHG    BL,BYTE [CurOp]
        TEST    BL,BL
        JZ      Calc32Add
        CMP     BL,AddOp
        JZ      Calc32Add
        CMP     BL,SubOp
        JZ      Calc32Sub
        CMP     BL,Period
        JZ      Calc32Add
        XOR     BH,BH
        SUB     BL,MulOp
        ADD     BX,BX
        JMP     WORD [BX][Calc32Labels]
EVEN 2
Calc32Add:
        ADD     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        ADC     WORD [DI][2],AX
        RET
EVEN 2
Calc32Sub:
        SUB     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        SBB     WORD [DI][2],AX
        RET
EVEN 2
Calc32Mul:
        MOV     BX,DX
        MOV     AX,WORD [DI][2]
        MUL     BX
        MOV     WORD [DI][2],AX
        MOV     AX,WORD [DI]
        MUL     BX   
        MOV     WORD [DI],AX
        ADD     WORD [DI][2],DX
        RET

__mul32:
        PUSH    BX

        PUSH    AX
        MOV AX,DX
        MUL CX
        MOV BX,AX
        POP AX

        MUL CX

        ADD DX,BX

        POP BX
        RET
EVEN 2
Calc32Div:
        MOV     BX,DX
        MOV     AX,WORD [DI][2]
        TEST    BX,BX
        JZ      Calc32LoadZero
        XOR     DX,DX
        DIV     BX
        MOV     WORD [DI][2],AX
        MOV     AX,WORD [DI]
        DIV     BX
        MOV     WORD [DI],AX
        RET
EVEN 2
Calc32Mod:
        MOV     BX,DX
        XOR     AX,AX
        XCHG    AX,WORD [DI][2]
        TEST    BX,BX
        JZ      Calc32LoadZero
        XOR     DX,DX
        DIV     BX
        MOV     AX,WORD [DI]
        DIV     BX
        MOV     WORD [DI],DX
        RET
EVEN 2
Calc32LT:
        MOV     AX,WORD [DI][2]
        CMP     AX,WORD [SI][2]
        JGE     Calc32LoadZero
        MOV     AX,WORD [DI]
        CMP     AX,WORD [SI]
        JGE     Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32GT:
        MOV     AX,WORD [DI][2]
        CMP     AX,WORD [SI][2]
        JLE     Calc32LoadZero
        MOV     AX,WORD [DI]
        CMP     AX,WORD [SI]
        JLE     Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32NE:
        MOV     AX,WORD [DI][2]
        CMP     AX,WORD [SI][2]
        JNZ     Calc32LoadOne
        MOV     AX,WORD [DI]
        CMP     AX,WORD [SI]
        JZ      Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32LoadZero:
        XOR     AX,AX
        MOV     WORD [DI],AX
        MOV     WORD [DI][2],AX
        RET        
EVEN 2
Calc32LE:
        MOV     AX,WORD [DI][2]
        CMP     AX,WORD [SI][2]
        JG      Calc32LoadZero
        MOV     AX,WORD [DI]
        CMP     AX,WORD [SI]
        JG      Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32GE:
        MOV     AX,WORD [DI][2]
        CMP     AX,WORD [SI][2]
        JL      Calc32LoadZero
        MOV     AX,WORD [DI]
        CMP     AX,WORD [SI]
        JL      Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32BoolEQ:
        MOV     AX,WORD [DI][2]
        CMP     AX,WORD [SI][2]
        JNZ     Calc32LoadZero
        MOV     AX,WORD [DI]
        CMP     AX,WORD [SI]
        JNZ     Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32BoolAnd:
        MOV     AX,WORD [DI][2]
        AND     AX,WORD [SI][2]
        JZ      Calc32LoadZero
        MOV     AX,WORD [DI]
        AND     AX,WORD [SI]
        JZ      Calc32LoadZero
        JMP     Calc32LoadOne

EVEN 2
Calc32LoadOne:
        MOV     AX,-1
        MOV     WORD [DI][2],AX
        MOV     WORD [DI],AX
        RET

EVEN 2
Calc32BoolXor:
        MOV     AX,WORD [DI][2]
        XOR     AX,WORD [SI][2]
        JZ      Calc32LoadZero
        MOV     AX,WORD [DI]
        XOR     AX,WORD [SI]
        JZ      Calc32LoadZero
        JMP     Calc32LoadOne
EVEN 2
Calc32BoolOr:
        MOV     AX,WORD [DI][2]
        OR      AX,WORD [SI][2]
        JZ      Calc32LoadZero
        MOV     AX,WORD [DI]
        OR      AX,WORD [SI]
        JZ      Calc32LoadZero
        JMP     Calc32LoadOne
        RET
EVEN 2
Calc32EQ:
        MOV     AX,WORD [SI]
        MOV     WORD [DI],AX
        MOV     AX,WORD [SI][2]
        MOV     WORD [DI][2],AX
        RET

EVEN 2
Calc32And:
        AND     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        AND     WORD [DI][2],AX
        RET
EVEN 2
Calc32XOR:
        XOR     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        XOR     WORD [DI][2],AX
        RET
EVEN 2
Calc32Or:
        OR      WORD [DI],DX
        MOV     AX,WORD [SI][2]
        OR      WORD [DI][2],AX
        RET
EVEN 2
Calc32Not:
        NOT     DX
        MOV     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        NOT     AX
        MOV     WORD [DI][2],AX
        RET
EVEN 2
Calc32Shl:
        AND     DL,1Fh  ;Mask the first 31 bits
        JZ      Calc32ShlLoopQuit
Calc32ShlLoop:
        SHL     WORD [DI],1
        RCL     WORD [DI][2],1
        DEC     DL
        JNZ     Calc32ShlLoop
Calc32ShlLoopQuit:
        RET
EVEN 2
Calc32Shr:
        AND     DL,1Fh  ;Mask the first 31 bits
        JZ      Calc32ShlLoopQuit
Calc32ShrLoop:
        SHR     WORD [DI][2],1
        RCR     WORD [DI],1
        DEC     DL
        JNZ     Calc32ShrLoop
        RET
EVEN 2
Calc32Rol:
        AND     DL,1Fh  ;Mask the first 31 bits
        JZ      Calc32ShlLoopQuit
Calc32RolLoop:
        SHL     WORD [DI][2],1
        RCL     WORD [DI],1
        DEC     DL
        JNZ     Calc32RolLoop
        RET
EVEN 2
Calc32Ror:
        AND     DL,1Fh  ;Mask the first 31 bits
        JZ      Calc32ShlLoopQuit
Calc32RorLoop:
        SHR     WORD [DI],1
        RCR     WORD [DI][2],1
        DEC     DL
        JNZ     Calc32RorLoop
        RET
EVEN 2
Calc32Sar:
        AND     DL,1Fh  ;Mask the first 31 bits
        JZ      Calc32ShlLoopQuit
Calc32SarLoop:
        RET
EVEN 2
Calc64:
        XOR     BL,BL
        XCHG    BL,BYTE [CurOp]
        TEST    BL,BL
        JZ      Calc64Add
        CMP     BL,AddOp
        JZ      Calc64Add
        CMP     BL,SubOp
        JZ      Calc64Sub
        CMP     BL,Period
        JZ      Calc64Add
        XOR     BH,BH
        SUB     BL,MulOp
        ADD     BX,BX
        JMP     WORD [BX][Calc64Labels]
Calc64Add:
        ADD     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        ADC     WORD [DI][2],AX
        MOV     AX,WORD [SI][4]
        ADC     WORD [DI][4],AX
        MOV     AX,WORD [SI][6]
        ADC     WORD [DI][6],AX
        RET
Calc64Sub:
        SUB     WORD [DI],DX
        MOV     AX,WORD [SI][2]
        SBB     WORD [DI][2],AX
        MOV     AX,WORD [SI][4]
        SBB     WORD [DI][4],AX
        MOV     AX,WORD [SI][6]
        SBB     WORD [DI][6],AX
        RET
Calc64Mul:
Calc64Div:
Calc64Mod:
Calc64LT:
Calc64GT:
Calc64EQ:
Calc64And:
Calc64XOR:
Calc64Or:
Calc64Not:
Calc64NE:
Calc64LE:
Calc64GE:
Calc64Shl:
Calc64Shr:
Calc64Rol:
Calc64Ror:
Calc64Sar:
Calc64BoolEQ:
Calc64BoolAnd:
Calc64BoolXor:
Calc64BoolOr:
        RET

CombineOperatorsDone:
        STC
CombineOperatorsDone2:
        RET
EVEN 2
CombineOperators:        
        CMP     AL,Period
        JB      CombineOperatorsDone2   ;the carry is already set save a clock!
CombineOperators2:
        CMP     AL,BoolOrOp
        JA      CombineOperatorsDone
        CMP     BYTE [CurOp],0
        JNZ     CombineOperators3
CombineAssignOp:
        MOV     BYTE [CurOp],AL
        CLC
        RET
CombineOperators3:
        MOV     AH,BYTE [CurOp]
        CMP     AL,AH
        JZ      CombineSameOperators
        CMP     AL,EqOp
        JNZ     CombineInvalidOperators
CombineEQOperators:
        MOV     AL,LEOp
        CMP     AH,LTOp
        JZ      CombineAssignOp
        MOV     AL,GEOp
        CMP     AH,GTOp
        JZ      CombineAssignOp
        MOV     AL,NEOp
        CMP     AH,NEPref
        JZ      CombineAssignOp
CombineInvalidOperators:
        JMP     InvalidOperators
CombineSameOperators:
        MOV     AL,ShlOp
        CMP     AH,LTOp
        JZ      CombineAssignOp
        MOV     AL,ShrOp
        CMP     AH,GTOp
        JZ      CombineAssignOp
        MOV     AL,BoolEqOp
        CMP     AH,EqOp
        JZ      CombineAssignOp
        MOV     AL,BoolAndOp
        CMP     AH,AndOp
        JZ      CombineAssignOp
        MOV     AL,BoolOrOp
        CMP     AH,OrOp
        JZ      CombineAssignOp
        MOV     AL,BoolXorOp
        CMP     AH,XorOp
        JZ      CombineAssignOp
        JMP     InvalidOperators
EVEN 2
GetInstrOperator:
        CMP     DX,ShlInstr
        MOV     AL,ShlOp
        JZ      GetInstrOperatorOK

        CMP     DX,ShrInstr
        MOV     AL,ShrOp
        JZ      GetInstrOperatorOK

        CMP     DX,RolInstr
        MOV     AL,RolOp
        JZ      GetInstrOperatorOK

        CMP     DX,RorInstr
        MOV     AL,RorOp
        JZ      GetInstrOperatorOK

        CMP     DX,SarInstr
        MOV     AL,SarOp
        JZ      GetInstrOperatorOK

        CMP     DX,XorInstr
        MOV     AL,XorOp
        JZ      GetInstrOperatorOK

        CMP     DX,AndInstr
        MOV     AL,AndOp
        JZ      GetInstrOperatorOK

        CMP     DX,OrInstr
        MOV     AL,OrOp
        JZ      GetInstrOperatorOK

        CMP     DX,NotInstr
        MOV     AL,NotOp
        JZ      GetInstrOperatorOK

        CMP     DX,DivInstr
        MOV     AL,DivOp
        JZ      GetInstrOperatorOK

        CMP     DX,NegInstr
        MOV     AL,SubOp
        JZ      GetInstrOperatorOK

        STC
        RET
EVEN 2
GetInstrOperatorOK:
        RET ;Carry flag is obviously off because its equal NOT below!

ProcessExpression64:
        MOV AH,0
        RET
ProcessExpression:        
        CMP     BYTE [OperandSize],_DWORD
        JA      ProcessExpression64
ExpressionInit:

        MOV     DI,WORD [ExprStack]
        MOV     WORD [Temp9],DI
        XOR     AX,AX
        STOSB
        STOSW
        STOSW
        MOV     WORD [ExprStack],DI
        MOV     BYTE [CurOp],AL
        DEC     AX
        MOV     BYTE [NeedOp],AL
        OR      BYTE [Process],1
        JMP     ExpressionLoop
ExprLowOperator:
        MOV     DI,WORD [ExprStack]
        MOV     SI,OFFSET OWordNum
        XOR     AL,AL
        CMP     BYTE [DI][-5],AL
        JZ      ExpressionEval ;ExprFirstEntry
        XCHG    AL,BYTE [CurOp]
        STOSB
        MOVSW
        MOVSW
        MOV     WORD [ExprStack],DI        
ExpressionLoop:
        CALL    GetNext        
ExpressionTest1:
        CMP     AH,Number
        JNZ     ExprTest2
        CMP     BYTE [NeedOp],1
        JZ      ExprMissingOperator
        CMP     AL,Num32
        JA      ExprNumTooBig
        MOV     AL,BYTE [CurOp]
        MOV     DI,OFFSET FirstOperators
        MOV     CX,WORD [Precedence][2]
        REPNZ   SCASB
        JNZ     ExprLowOperator
ExpressionEval:
        MOV     SI,OFFSET OWordNum
        MOV     DI,WORD [ExprStack]
        XOR     BX,BX
        SUB     DI,4
        CALL    Calc32
        MOV     BYTE [NeedOp],1
        JMP     ExpressionLoop
ExprNumTooBig:
        JMP     NumTooBig
ExprMissingOperator:
        JMP     MissingOperator
ExprTest2:
        CMP     AL,CPUInstruction
        JZ      ExprInstr
        CMP     AL,OpenBracket
        JZ      ExprOpenBr
        CMP     AL,CloseBracket
        JZ      ExprCloseBr
        CALL    CombineOperators
        JC      ExprInvalidEntry
        MOV     BYTE [NeedOp],0
        JMP     ExpressionLoop
ExprMissingCloseBr:
        JMP     MissingCloseBr
ExprInvalidEntry:
        CMP     AL,Question
        JZ      ExprQuestion
        CMP     AL,Keyword
        JZ      ExprKeyword
        CMP     AL,EndOfLine
        JZ      ExprMissingCloseBr
ExprInvalidEntry2:
        JMP     InvalidEAEntry
ExprQuestion:
        MOV     AH,Alpha
        CMP     BYTE [NextChar],CloseBracket
        JNZ     ExprInvalidEntry2
        INC     WORD [InBufferPtr]
        AND     BYTE [Process],NOT 1
        RET
ExprKeyword:
        CMP     DL,Operator
        JNZ     ExprInvalidEntry2
        CMP     DH,20
        JB      ExprKWOperator
        CMP     BYTE [CurOp],0
        JNZ     ExprInvalidEntry2
        MOV     BYTE [CurOp],DH
        MOV     BYTE [NeedOp],0
        JMP     ExpressionLoop
ExprKWOperator:
        CMP     DH,10
        JAE     ExprInvalidEntry2
        CALL    DoSpecialOperation
        JMP     ExpressionTest1
ExprInstr:
        CMP     BYTE [CurOp],0
        JNZ     ExprInvalidEntry2
        CALL    GetInstrOperator
        JC      ExprInvalidEntry2
        MOV     BYTE [CurOp],AL
        MOV     BYTE [NeedOp],0
        JMP     ExpressionLoop
ExprCloseBr:
        JMP     ExprEvaluate2
ExprOpenBr:
        PUSH    WORD [Temp9]
        MOV     AL,BYTE [CurOp]
        MOV     AH,BYTE [NeedOp]
        PUSH    AX
        CALL    ProcessExpression
        POP     AX
        POP     WORD [Temp9]
        MOV     BYTE [CurOp],AL
        MOV     BYTE [NeedOp],AH
        MOV     AX,Number SHL 8 OR Num8
        JMP     ExpressionTest1

ExprEvaluate2:
        MOV     BX,OFFSET StrBuffer
        MOV     AX,WORD [ExprStack]
        SUB     AX,5
        MOV     WORD [BX],AX
        MOV     BP,WORD [Temp9]
        MOV     WORD [ExprStack],BP
        CMP     AX,BP
        JZ      ExprEvaluateDone
        MOV     WORD [BX][0010],OFFSET Precedence+2
ExprChangeOp:
        MOV     BP,WORD [ExprStack]
        MOV     WORD [BX][4],BP
        ADD     BP,5
        MOV     WORD [BX][2],BP
        MOV     SI,WORD [BX][0010]
        LODSW
        MOV     BP,AX
        ADD     AX,OFFSET FirstOperators
        MOV     WORD [BX][6],AX
        MOV     WORD [BX][0010],SI
        LODSW
        TEST    AX,AX
        JZ      ExprEvaluateDone
        SUB     AX,BP
        MOV     WORD [BX][8],AX
ExprLoop:        
        MOV     SI,WORD [BX][2]
ExprLoopGetOp:
        LODSB
        TEST    AL,AL
        JZ      ExprBlankEntry
        MOV     DI,WORD [BX][6]
        MOV     CX,WORD [BX][8]
        INC     WORD [BX][0012]
        REPNZ   SCASB
        JNZ     ExprNextEntry        
        MOV     DX,WORD [SI]
        MOV     DI,WORD [BX][4]
        MOV     BYTE [CurOp],AL
        INC     DI
        MOV     BP,BX
        CALL    Calc32
        MOV     BX,BP
        MOV     BYTE [SI][-1],0
        JMP     ExprBlankEntry
ExprNextEntry:
        DEC     SI
        MOV     WORD [BX][4],SI
        INC     SI
ExprBlankEntry:
        LODSW
        LODSW
        CMP     SI,WORD [BX]
        JBE     ExprLoopGetOp
        JMP     ExprChangeOp
ExprEvaluateDone:

        CALL    GetNextCharI
        MOV     SI,WORD [Temp9]
        INC     SI
        MOV     AL,BYTE [NextChar]
        CMP     AL,Char0A
        JZ      ExprQuit
        CMP     AL,Comma
        JZ      ExprQuit
        CMP     AL,Colon
        JZ      ExprQuit
        CMP     AL,SemiColon
        JZ      ExprQuit

        MOV     DI,OFFSET OWordNum
        MOV     DX,WORD [SI]
        MOVSW
        MOVSW
        XOR     AX,AX
        STOSW
        STOSW
        MOV     AH,0
        RET
ExprQuit:
        JMP     GetNumSize32

DoStrNumExpected:
        JMP     NumExpected

DoStrLeft:
        CMP     AH,Number
        JNZ     DoStrNumExpected
        CMP     DX,CX
        JBE     DoStrLeftOK
        MOV     DX,CX
DoStrLeftOK:
        MOV     CX,DX
        MOV     DI,OFFSET StrBuffer
        REP     MOVSB
        MOV     AX,Quote
        RET

DoStrTest2:
        CMP     BH,13
        JZ      DoStrLeft
        CMP     BH,15
        JZ      DoStrRight
        JMP     InvalidOperand  ;Impossible

DoStrRight:
        CMP     AH,Number
        JNZ     DoStrNumExpected
        MOV     DI,OFFSET StrBuffer
        CMP     DX,CX
        JBE     DoStrRightOK
        MOV     DX,CX
DoStrRightOK:
        MOV     AX,CX
        SUB     AX,DX
        ADD     SI,AX
        MOV     CX,DX
        REP     MOVSB
        MOV     AX,Quote
        RET


StrOpNoBracket:
        JMP     MissingOpenBr
DoStrOperation:        
        CMP     BYTE [NextChar],OpenBracket
        JNZ     StrOpNoBracket
        INC     WORD [InBufferPtr]
        MOV     DL,BYTE [Settings][1]
        OR      BYTE [Settings][1],1
        PUSH    DX
        CALL    GetOperand
        CMP     AL,Quote
        JNZ     StrMissingQuote
        MOV     BP,SP
        MOV     BX,WORD [BP]
        CMP     BH,10
        JZ      DoStrxCase
        CMP     BH,11
        JZ      DoStrxCase
        MOV     SI,OFFSET StrBuffer
        MOV     DI,WORD [StrFree]
        PUSH    DI,DX
        MOV     CX,DX
        ADD     DX,DI
        CMP     DX,OFFSET StrBuffer+2048
        JA      DoStrTooLong
        REP     MOVSB
        MOV     WORD [StrFree],DI
        CALL    GetOperand
        MOV     BP,SP
        MOV     BX,WORD [BP][4]
        MOV     BYTE [Settings][1],BL
        CMP     BH,12
        JZ      DoStrMid
        POP     CX,SI,BX
        MOV     WORD [StrFree],SI
        CMP     BYTE [NextChar],CloseBracket
        JNZ     StrMissingCloseBr
        INC     WORD [InBufferPtr]        
        CMP     BH,14
        JZ      DoStrScan
        JMP     DoStrTest2
StrMissingQuote:
        JMP     InvalidOperand
StrMissingCloseBr:
        JMP     MissingCloseBr
DoStrTooLong:
        MOV     SI,WORD [OBufferPtr]
        JMP     GetNextAlphaTooLong
DoStrxCase:
        JMP     DoStrxCase2
        
DoStrMid:
        CMP     AH,Number
        JNZ     DoStrNumExpected2
        PUSH    DX
        CALL    GetOperand
        POP     BP
        POP     CX,SI,BX
        MOV     WORD [StrFree],SI
        CMP     AH,Number
        JZ      DoStrMidNumOK        
        DEC     WORD [InBufferPtr]
        MOV     BYTE [NextChar],AL
        CMP     AL,CloseBracket
        JZ      DoStrMidAdjust
        INC     WORD [InBufferPtr]
DoStrMidMissingBr:
        JMP     MissingCloseBr
DoStrMidNoStr:
        XOR     DX,DX
        MOV     AX,Quote
        RET
DoStrMidAdjust:
        MOV     DX,CX
        SUB     DX,BP
DoStrMidNumOK:
        CMP     BYTE [NextChar],CloseBracket
        JNZ     DoStrMidMissingBr
        INC     WORD [InBufferPtr]
        CMP     BP,CX
        JA      DoStrMidNoStr
        MOV     AX,BP
        ADD     AX,DX
        CMP     AX,CX
        JA      DoStrMidAdjust
        MOV     DI,OFFSET StrBuffer
        SUB     BP,1
        ADC     BP,0
        ADD     SI,BP
        MOV     CX,DX
        REP     MOVSB
        MOV     AX,Quote
        RET
DoStrNumExpected2:
        JMP     NumExpected
DoStrScanCheckQuote:
        CMP     AL,Quote
        JNZ     DoStrNumExpected2
        MOV     DL,BYTE [StrBuffer]
        JMP     DoStrScanNumOK
DoStrScan:
        CMP     AH,Number
        JNZ     DoStrScanCheckQuote
DoStrScanNumOK:
        MOV     DI,OFFSET OWordNum
        XOR     AX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     DI,SI
        MOV     AL,DL
        MOV     DX,CX
        REPNZ   SCASB
        JZ      DoStrScanDone
        MOV     CX,DX                
DoStrScanDone:
        SUB     DX,CX
        MOV     WORD [OWordNum],DX
        MOV     AX,Number SHL 8 OR Num8
        RET

DoStrxMissingCloseBr:
        JMP     MissingCloseBr

DoStrxCase2:
        CMP     BYTE [NextChar],CloseBracket
        JNZ     DoStrxMissingCloseBr
        INC     WORD [InBufferPtr]
        POP     BX
        MOV     BYTE [Settings][1],BL
        MOV     SI,OFFSET StrBuffer
        MOV     DI,SI
        MOV     CX,DX
        CMP     BH,11
        JZ      DoStrUCase
        CALL    LCaseStr
        MOV     AX,Quote
        RET
DoStrUCase:
        MOV     AX,Quote
        CALL    UCaseStr
        RET

dsoByte:
        MOV DX,1
        JMP DoSizeDone

dsoWord:
        MOV DX,2
        JMP DoSizeDone

dsoDWord:
        MOV DX,4
        JMP DoSizeDone

dsoFWord:
        MOV DX,6
        JMP DoSizeDone

dsoQWord:
        MOV DX,8
        JMP DoSizeDone

dsoTWord:
        MOV DX,10
        JMP DoSizeDone

dsoOWord:
        MOV DX,16
        JMP DoSizeDone

dsoKWDT:
        CMP DH,_BYTE
        JZ  dsoBYTE
        CMP DH,_WORD
        JZ  dsoWORD
        CMP DH,_DWORD
        JZ  dsoDWORD
        CMP DH,_FWORD
        JZ  dsoFWORD
        CMP DH,_QWORD
        JZ  dsoQWORD
        CMP DH,_TWORD
        JZ  dsoTWORD
        CMP DH,_OWORD
        JZ  dsoOWORD
        XOR DX,DX
        JMP DoSizeDone

dsoKeyword:
        POP AX
        CMP DL,DataType
        JZ  dsoKWDT
        XOR DX,DX
        JMP DoSizeDone

DoSizeOperation:
        MOV     AL,[Settings]
        PUSH    AX
        OR      BYTE [Process],4
        CALL    GetOperand
        AND     BYTE [Process],NOT 4
        CMP     AX,Keyword
        JZ  dsoKeyword
        POP     AX
        MOV     BL,[Settings]
        MOV     BH,BL
        AND     BH,NOT 3
        AND     AL,3
        OR      AL,BH
        OR      BYTE [Settings],AL

        MOV     AX,0 
        MOV     DX,AX
        MOV     DI,OFFSET OWordNum
        STOSW
        STOSW
        STOSW
        STOSW
        TEST    BL,1
        JZ      DoSizeDone
        LES     DI,DWORD [SymPos]
        MOV     AL,[SymType]
        CMP     AL,StructID
        JZ      DoSizeStruct
        CMP     AL,LabelID
        JAE     DoSizeDone
        MOV     DX,1
        CMP     AL,ByteID
        JZ      DoSizeDone
        MOV     BX,OFFSET OpSizeTable
        XLAT
        MOV     DL,AL
        JMP     DoSizeDone
DoSizeStruct:
        MOV     DX,ES:[DI].seIDData
DoSizeDone:
        PUSH    DS
        POP ES
        MOV     [OWordNum],DX

        MOV     AX,Number SHL 8 OR Num16
        RET

DoSpecialOperation:        
        CMP     DH,1
        JZ      DoDEFOperation
        CMP     DH,3
        JZ      _DoRVAOperation
        CMP     DH,4
        JZ      DoSegOperation
        CMP     DH,6
        JZ      DoSizeOperation
        RET
_DoRVAOperation:
		JMP		DoRVAOperation

DoDEFOperation:
        AND     BYTE [Settings],0FCh
        CALL    GetOperand
        MOV     AL,[Settings]
        AND     AL,2
        CMP     AL,1
        MOV     AX,0
        SBB     AX,AX
        MOV     DI,OFFSET OWordNum
        MOV     DX,AX
        STOSW
        STOSW
        STOSW
        STOSW
        MOV     AX,Number SHL 8 OR Num8
        RET

DoSegOperation:
        OR      BYTE [Settings][1],80h
        MOV     AX,AddOp
        TEST    BYTE [RelocFlags],1
        JNZ     DoSegOperation2
        OR      BYTE [RelocFlags],80h
        MOV     WORD [RelocFlags][2],0
        RET
DoSegOperation2:
        OR      BYTE [RelocFlags2],80h
        RET

Div32	PROC
        PUSH    AX
        MOV AX,DX
        XOR DX,DX
        DIV BX
        MOV SI,AX
        POP AX
        DIV BX
        XCHG    DX,SI
        RET
Div32	ENDP
