CallDWord:
        CMP     BYTE [AddrMode],2
        JAE     CallMem32
        MOV     AH,3 SHL 3
        JMP     CallMem16
CallMemUnknown2:
        CALL    GetOperandSize
        MOV     AL,AH
        MOV     AH,2 SHL 3
        CMP     AL,_WORD
        JZ      CallMem16
        CMP     AL,_DWORD
        JZ      CallDWord
        CMP     AL,_QWORD
        JZ      CallMem64
        MOV     AH,3 SHL 3
        CMP     AL,_TWORD
        JZ      CallMem64
        CMP     AL,_FWORD
        JZ      CallMem32
        JMP     InvalidOperandSize
CallNearMem2:
        CMP     BYTE [AddrMode],2
        JZ      CallMem32
        JB      CallMem16
        JMP     CallMem64
CallNearMem:
        CALL    GetOperandSize
        MOV     AL,AH
        MOV     AH,2 SHL 3
        CMP     AL,_WORD
        JZ      CallMem16
        CMP     AL,_DWORD
        JZ      CallMem32
        CMP     AL,_QWORD
        JZ      CallMem64
        JMP     InvalidOperandSize
CallMem16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     CallMemWrite
CallMem64:
        MOV     BYTE [REXDisp],1
        OR      BYTE [REXOverride],48h
        JMP     CallMemWrite
CallFarMem2:
        CMP     BYTE [AddrMode],2
        JB      CallMem16
        JA      CallMem64
CallMem32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
CallMemWrite:
        OR      BYTE [ModRM],AH
        MOV     AL,BYTE [REXOverride]
        MOV     BYTE ES:[DI],AL
        ADD     DI,WORD [REXDisp]
        MOV     AL,0FFh
        STOSB
        CALL    WriteEAData
        JMP     AssembleDone
CallFarMem:
        CALL    GetOperandSize
        MOV     AL,AH
        MOV     AH,3 SHL 3
        CMP     AL,_DWORD
        JZ      CallMem16
        CMP     AL,_FWORD
        JZ      CallMem32
        CMP     AL,_TWORD
        JZ      CallMem64
        JMP     InvalidOperandSize
CallMem:        
        LES     DI,[OBufferPtr]
        CALL    WriteOverrides
        MOV     AL,BYTE [JmpSize]
        CMP     AL,FarJmp
        JZ      CallFarMem
        CMP     AL,0FFh
        JZ      CallFarMem
        CMP     AL,NearJmp
        JNZ     CallMemUnknown
        JMP     CallNearMem
CallMemUnknown:
        JMP     CallMemUnknown2
Call32Reloc:
        JMP     Call32Reloc2
CallInstr32:
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     Call32Reloc
        MOV     CX,WORD [OWordNum][2]
        SUB     DX,5
        SBB     CX,0
        SUB     DX,WORD [ProgIP]
        SBB     CX,WORD [ProgIP][2]
        MOV     AL,0E8h
        STOSB
        MOV     AX,DX
        STOSW
        MOV     AX,CX
        STOSW
        JMP     AssembleDone
CallLabelExpected:
        JMP     LabelExpected
CallInstrInvoke:
        JMP     InvokeDirecFromCall
CallPInstr:
        MOV     BYTE [JmpSize],0
        MOV     WORD [Temp2],BX
CallGetOp:
        CALL    GetOperand
CallProcessOp:
        MOV     CL,BYTE [NextChar]
        CMP     CL,Comma
        JZ      CallInstrInvoke
        CMP     CL,OpenBracket
        JZ      CallInstrInvoke
        CMP     AL,Keyword
        JZ      CallKW
        CMP     AL,Mem
        JZ      CallMem
        CMP     AH,Number
        JNZ     CallLabelExpected
        CMP     CL,Colon
        JZ      CallInstrFar
        LES     DI,[OBufferPtr]
CallDisp:
        CMP     BYTE [JmpSize],0FFh
        JZ      CallFarExtern
        CMP     BYTE [AddrMode],2
        JZ      CallInstr32
        JA      CallInstr64
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     Call16Reloc        
        SUB     DX,3
        SUB     DX,WORD [ProgIP]
        MOV     AL,0E8h
        STOSB
        MOV     AX,DX
        STOSW
        JMP     AssembleDone
Call16Reloc:
        JMP     Call16Reloc2
CallFarExtern:        
        MOV     AL,09Ah
CallFarExtern2:
        STOSB
        CMP     BYTE [AddrMode],2
        JB      CallFarExtrn16
        OR      BYTE [RelocFlags],18h
        CALL    Write32Relo
        MOV     AX,[OWordNum][4]
        STOSW
        JMP     AssembleDone
CallFarExtrn16:
        OR      BYTE [RelocFlags],10h
        CALL    Write16Relo
        MOV     AX,[OWordNum][2]
        STOSW
        JMP     AssembleDone
CallKW:
        CMP     DL,DistSpec
        JZ      CallDist
        JMP     CallKW2
CallDist:
        CMP     DH,ShortJmp
        JZ      CallInvalidKW
        MOV     AL,0
        CMP     BYTE [JmpSize],1
        SBB     AL,AL
        AND     DH,AL
        MOV     BYTE [JmpSize],DH
        JMP     CallGetOp
CallInvalidKW:
        JMP     InvalidKeyword
CallInstrFar:
        JMP     CallInstrFar2
Call64Reloc:
        JMP     Call64Reloc2
CallInstr64:
        MOV     AL,[RelocFlags]
        AND     AL,0A1h
        CMP     AL,021h
        JAE     Call64Reloc
        MOV     SI,OFFSET OWordNum
        MOV     CX,WORD [SI][2]
        MOV     BP,WORD [SI][4]
        MOV     BX,WORD [SI][6]
        XOR     AX,AX
        SUB     DX,5
        SBB     CX,AX
        SBB     BP,AX
        SBB     BX,AX
        MOV     SI,OFFSET ProgIP
        SUB     DX,WORD [SI]
        SBB     CX,WORD [SI][2]
        SBB     BP,WORD [SI][4]
        SBB     BX,WORD [SI][6]
        MOV     AL,0E8h
        STOSB
        MOV     AX,DX
        STOSW
        MOV     AX,CX
        STOSW
        JMP     AssembleDone
CallKW2:
        LES     DI,DWORD [OBufferPtr]
        CMP     DL,Reg16
        JZ      CallReg16
        CMP     DL,Reg32
        JZ      CallReg32
        MOV     AH,40h
        CMP     DL,Reg64
        JZ      CallReg64
        OR      AH,41h
        CMP     DL,LMReg16
        JZ      CallReg16LM
        CMP     DL,LMReg32
        JZ      CallReg32LM
        CMP     DL,LMReg64
        JZ      CallReg64
        JMP     InvalidKeyword
CallReg32:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
CallRegStore:
        MOV     AL,0FFh
        MOV     AH,0C0h OR 10h
        OR      AH,DH
        STOSW
        JMP     AssembleDone
CallReg16LM:
        MOV     AL,66h
        STOSW
        JMP     CallRegStore
CallReg16:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        JMP     CallRegStore                
CallReg64:
        OR      AH,48h
        MOV     AL,AH
        STOSB
        JMP     CallRegStore
CallReg32LM:
        MOV     AL,AH
        STOSB
        JMP     CallRegStore
CallFarNumTooBig:
        JMP     NumTooBig
CallFarNumExpected:
        JMP     SelOfsExpected
CallInstrFar2:
        MOV BYTE [Temp1],9Ah
CallInstrFar3:
        INC WORD [InBufferPTR]
        CMP AH,Num16
        JA  CallFarNumTooBig
        PUSH    DX
        MOV     SI,OFFSET RelocFlags
        MOV     DI,OFFSET EADisp
        MOVSW
        MOVSW
        MOVSW
        AND     BYTE [SI-6],NOT 1
        CALL    GetOperand
        CMP AH,Number
        JNZ CallFarNumExpected
        LES DI,[OBufferPTR]
        MOV AH,AL
        MOV AL,[Temp1]
        STOSB
        CMP BYTE [AddrMode],2
        JB  CallInstrFar16
;		JA	CallInstrFar64,
        CMP AH,Num32
        JA  CallFarNumTooBig
        CALL    Write32Imm
        JMP CallInstrFar16WriteSeg
;CallInstrFar64:
;		MOV BYTE ES:[DI][-1], 48H
;		STOSB
 ;       CMP AH,Num64
  ;      JA  CallFarNumTooBig
   ;     CALL    Write64Imm
    ;    JMP CallInstrFar16WriteSeg
CallInstrFar16:
        CMP     AH,Num16
        JA      CallFarNumTooBig
        CALL    Write16Imm2
CallInstrFar16WriteSeg:
        PUSH    ES
        PUSH    DS
        POP ES
        MOV SI,OFFSET EADisp
        MOV DX,DI
        MOV DI,OFFSET RelocFlags
        MOVSW
        MOVSW
        MOVSW
        MOV DI,DX
        POP ES
        POP CX
        MOV WORD [OWordNum],CX
        CALL    Write16Imm
        JMP     AssembleDone
Call16Reloc2:
        OR      BYTE [RelocFlags],40h
        MOV     AL,0E8h
        STOSB
        CALL    Write16Relo
        JMP     AssembleDone
Call64Reloc2:
Call32Reloc2:
        OR      BYTE [RelocFlags],48h
        MOV     AL,0E8h
        STOSB
        CALL    Write32Relo
        JMP     AssembleDone
