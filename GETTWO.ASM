GetTwoOperandsFirstMem:
        MOV WORD [Op1Type],Mem
        JMP GetTwoOperandsConvNum
GetTwoOperandsFirstNum:
        MOV     AL,BYTE [Settings]
        AND     AL,3
        TEST    AL,1
        JZ      GetTwoOperands1OK
        CMP     BYTE [SymType],OWordID
        JBE     GetTwoOperandsFirstMem
        TEST    BYTE [RefFlags],8
        JNZ GetTwoOperandsConvNum
        CMP     AL,3
        JNZ     GetTwoOperands1OK
        CMP     BYTE [SymType],UnknownID
        JNZ     GetTwoOperands1OK
GetTwoOperandsConvNum:
        MOV     AX,AsmData
        MOV     ES,AX
        CALL    NumToEA
        MOV     AX,WORD [SymPos]
        MOV     WORD [Temp1],AX
        MOV     AX,WORD [SymSeg]
        MOV     WORD [Temp2],AX
        CALL    GetOperand        
        CMP     AL,Keyword
        JNZ     GetTwoOperandsGet1
        MOV     BL,DL
        CMP     BL,SegReg386
        JA      GetTwoOperandsGet1
        TEST    BYTE [RefFlags],8
        JNZ GetTwOperandsNumTypeOK
        LES     DI,[Temp1]
        MOV     BH,0
        MOV     AL,BYTE [BX][OpTranslate][-Reg8]
        MOV     BYTE ES:[DI][1],AL
GetTwOperandsNumTypeOK:
        MOV     BX,Keyword
        MOV     CX,DX
        MOV     AX,Mem
        JMP     GetTwoOperand2OK
EVEN 2
GetTwoOperands:        

        CALL    GetOperand
        MOV     BYTE [CommaFlag],7Fh
        MOV     WORD [Op1Type],AX
        MOV     WORD [Op1Data],DX

        CMP     AH,Number
        JZ      GetTwoOperandsFirstNum
GetTwoOperands1OK:

        CALL    GetOperand

GetTwoOperandsGet1:
        MOV     WORD [Op2Type],AX
        MOV     WORD [Op2Data],DX
        MOV     BX,AX
        MOV     CX,DX
        MOV     AX,WORD [Op1Type]
        MOV     DX,WORD [Op1Data]		
	
GetTwoOperand2OK:
        AND     BYTE [CommaFlag],7Fh
        JNZ     GetTwoOperandsNoComma
        LES     DI,[OBufferPtr]
        RET

GetTwoOperandsNoComma:
        CMP     AL,EndOfLine
        JZ      GetTwoFewOperands
        CMP     BL,EndOfLine
        JZ      GetTwoFewOperands
        JMP     MissingComma
GetTwoFewOperands:
        JMP     FewOperands