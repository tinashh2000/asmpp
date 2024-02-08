PrtError2:
        CALL    PrintError
        MOV     SI,OFFSET StrBuffer
        MOV     CX,WORD [StrLen]
        CALL    PrintStrFixed
PrtError3:
        CALL    PrintLF
        MOV     SP,WORD [AsmStack]
        CMP     BYTE [Error],QuitError
        JZ      PrtErrorFatal
        JMP     AssembleDone3
PrtErrorFatal:
        JMP     AssembleEndOfFile
PrtError:
        CALL    PrintError
        MOV     SP,WORD [AsmStack]
        JMP     AssembleDone3

FileNameExpected:
        MOV SI,(_FileNameExpected)
        JMP     PrtError

notenoughmemory:
	MOV	BYTE [Error],QuitError
	MOV	SI,OFFSET _NotEnoughMem
	CALL	PrintError
	MOV	BYTE [Msg],EndOfFile
	MOV	SP,WORD [AsmStack]
	JMP	AssembleEndOfFile

expectedinstr:
        MOV     SI,OFFSET _expectedinstr
        JMP     PrtError
numtoobig:
        MOV     SI,OFFSET _numtoobig
        JMP     PrtError
manyoperands:
        MOV     SI,OFFSET _manyoperands
        JMP     PrtError
numexpected:
        MOV     SI,OFFSET _numexpected
        JMP     PrtError
invalidaddrmode:
        MOV     SI,OFFSET _invalidaddrmode
        JMP     PrtError
dximmexpected:
        MOV     SI,OFFSET _dximmexpected
        JMP     PrtError
accumexpected:
        MOV     SI,OFFSET _accumexpected
        JMP     PrtError
missingcomma:
		
        MOV     SI,OFFSET _missingcomma
        JMP     PrtError

CommaError:
		
        MOV     SI,OFFSET _CommaError
        JMP     PrtError
csdest:
        MOV     SI,OFFSET _csdest
        JMP     PrtError
operandsizemismatch:
        MOV     SI,OFFSET _operandsizemismatch
        JMP     PrtError
combinationnotallowed:
        MOV     SI,OFFSET _combinationnotallowed
        JMP     PrtError
invalidoperandsize:
        MOV     SI,OFFSET _invalidoperandsize
        JMP     PrtError
operandsizerequired:
        MOV     SI,OFFSET _operandsizerequired
        JMP     PrtError
byteoperandexpected:
        MOV     SI,OFFSET _byteoperandexpected
        JMP     PrtError
InvalidRegister:
        MOV     SI,OFFSET _InvalidRegister
        JMP     PrtError
InvalidOperand:
        CMP     AL,EndOfLine
        JZ      FewOperands
        CMP     BL,EndOfLine
        JZ      FewOperands
        MOV     SI,OFFSET _InvalidOperand
        JMP     PrtError
InvalidOperand1:
        CMP     AL,EndOfLine
        JZ      FewOperands
        MOV     SI,OFFSET _InvalidOperand1
        JMP     PrtError
InvalidOperand2:
        MOV     SI,OFFSET _InvalidOperand2
        JMP     PrtError
InvalidOperand3:
        MOV     SI,OFFSET _InvalidOperand3
        JMP     PrtError

fewoperands:
        MOV     SI,OFFSET _fewoperands
        JMP     PrtError
MemOpExpected:
        MOV     SI,OFFSET _MemOpExpected
        JMP     PrtError
LabelExpected:
        MOV     SI,OFFSET _LabelExpected
        JMP     PrtError
ProgIPOverflow:
        MOV     BYTE [Error],QuitError
        MOV     SI,OFFSET _ProgIPOverflow
        CALL    PrintError
        RET
JumpOutOfRange:
        CMP     DX,127
        JG      JumpAboveRange
JumpBelowRange:
        NEG     DX
        SUB     DX,127
        MOV     SI,OFFSET _JumpBelowRange
JumpOutOfRangePrt:
        MOV     AX,DX
        PUSH    AX
        CALL    PrintError
        POP     AX
        XOR     DX,DX
        CALL    PrintInt
        CALL    PrintLF
JumpOutOfRangeRet:
        MOV     SP,WORD [AsmStack]
        JMP     AssembleDone3
JumpAboveRange:
        CMP     WORD [NumErrors],0
        JNZ     JumpOutOfRangeRet
JumpAboveRange2:
        SUB     DX,127
        MOV     SI,OFFSET _JumpAboveRange
        JMP     JumpOutOfRangePrt
NoRValue:
        MOV     SI,OFFSET _NoRValue
        JMP     PrtError
NoLValue:
        MOV     SI,OFFSET _NoLValue
        JMP     PrtError
CommentNoTerminator:
        MOV     SI,OFFSET _CommentNoTerminator
        JMP     PrtError
BadRadix:
        MOV     SI,OFFSET _BadRadix
        JMP     PrtError
MissingOperator:
        MOV     SI,OFFSET _MissingOperator
        JMP     PrtError
InvalidOperators:
        MOV     SI,OFFSET _InvalidOperators
        JMP     PrtError
DupDef:
        MOV     SI,OFFSET _DupDef
        JMP     PrtError
IDNotFound:
        MOV     SI,OFFSET _IDNotFound
        JMP     PrtError2
MissingLabel:
        MOV     SI,OFFSET _MissingLabel
        JMP     PrtError
ImmCLExpected:
        MOV     SI,OFFSET _ImmCLExpected
        JMP     PrtError
NotCoded:
        CMP     BYTE [Pass],1
        JNZ     NotCoded2
        MOV     BYTE [Error],128
        MOV     SI,OFFSET _NotCoded
        JMP     PrtError2
NotCoded2:
        MOV     SP,WORD [AsmStack]
        JMP     AssembleDone3
InvalidKeyword:
        MOV     SI,OFFSET _InvalidKeyword
        JMP     PrtError2
SelOfsExpected:
        MOV     SI,OFFSET _SelOfsExpected
        JMP     PrtError
AlreadyInBlock:
        MOV     SI,OFFSET _AlreadyInBlock
        JMP     PrtError
UnmatchedEnd:
        MOV     SI,OFFSET _UnmatchedEnd
        JMP     PrtError2
CantESOverride:
        MOV     SI,OFFSET _CantESOverride
        JMP     PrtError
MissingOpenBr:
        MOV     SI,OFFSET _MissingOpenBr
        JMP     PrtError
MissingCloseBr:
        MOV     SI,OFFSET _MissingCloseBr
        JMP     PrtError

OutOfMacroSpace:
        MOV     SI,OFFSET _OutOfMacroSpace
PrtFatalError:
        MOV     BYTE [Error],QuitError
PrtErrorQuit:
        MOV AX,AsmData
        MOV DS,AX
        CALL    PrintError
        MOV     BYTE [Msg],EndOfFile
        MOV     SP,WORD [AsmStack]
        JMP     AssembleEndOfFile

UninitSeg:
        MOV     SI,OFFSET _UninitSeg
        JMP     PrtError

HeaderLarge:
        MOV     SI,OFFSET _HeaderLarge
        JMP     PrtFatalError
