
InpALDX:
        MOV     AL,0ECh
        STOSB
        JMP     AssembleDone
InpAXDX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        MOV     AL,0EDh
        STOSB
        JMP     AssembleDone
InpRAXDX:
        MOV     BYTE ES:[DI],48h
        INC DI
InpEAXDX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        MOV     AL,0EDh
        STOSB
        JMP     AssembleDone
InpGetDX:
        CMP     CX,(2 SHL 8) OR Reg16
        JNZ     PortDXImmExpected
        CMP     DL,Reg8
        JZ      InpALDX
        CMP     DL,Reg16
        JZ      InpAXDX
        CMP     DL,Reg32
        JZ      inpEAXDX
        CMP     DL,Reg64
        JZ      InpRAXDX
        JMP     PortAccumExpected
InpInstr:
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JNZ     PortAccumExpected
        TEST    DH,DH
        JNZ     PortAccumExpected
        CMP     BL,Keyword
        JZ      InpGetDX
        CMP     BH,Number
        JNZ     PortDXImmExpected
        CMP     BL,Num8
        JNZ     PortNumTooBig
        MOV     AH,CL
        MOV     AL,0E5h
        CMP     DL,Reg64
        JZ      InpRAXImm
        CMP     DL,Reg32
        JZ      InpEAXImm
        CMP     DL,Reg16
        JZ      InpAXImm
        CMP     DL,Reg8
        JNZ     PortAccumExpected
InpALImm:
        DEC     AL
        STOSW
        JMP     AssembleDone
InpAXImm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSW
        JMP     AssembleDone
InpRAXImm:
        MOV     BYTE ES:[DI],48h
        INC DI
InpEAXImm:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        STOSW
        JMP     AssembleDone
PortAccumExpected:
        JMP     AccumExpected
PortDXImmExpected:
        JMP     DXImmExpected
PortNumTooBig:
        JMP     NumTooBig
OutPInstr:
        CALL    GetTwoOperands
        CMP     AL,Keyword
        JZ      OutGetDX
        CMP     AH,Number
        JNZ     PortDXImmExpected
        CMP     AL,Num8
        JNZ     PortNumTooBig
        CMP     BL,Keyword
        JNZ     PortAccumExpected
        TEST    CH,CH
        JNZ     PortAccumExpected
        MOV     AH,DL
        MOV     AL,0E7h
        CMP     CL,Reg32
        JZ      OutImmEAX
        CMP     CL,Reg16
        JZ      OutImmAX
        CMP     CL,Reg8
        JNZ     PortAccumExpected
        DEC     AL
        STOSW
        JMP     AssembleDone
OutImmRAX:
        MOV     BYTE ES:[DI],48h
        INC DI
OutImmEAX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        STOSW
        JMP     AssembleDone
OutImmAX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSW
        JMP     AssembleDone
OutGetDX:
        CMP     DX,(2 SHL 8) OR Reg16
        JNZ     PortDXImmExpected
        MOV     AL,0EFh
        CMP     BL,Keyword
        JNZ     PortAccumExpected
        CMP     CL,Reg64
        JZ      OutDXRAX
        CMP     CL,Reg32
        JZ      OutDXEAX
        CMP     CL,Reg16
        JZ      OutDXAX
        CMP     CL,Reg8
        JNZ     PortAccumExpected
        DEC     AL
        STOSB
        JMP     AssembleDone
OutDXAX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr16Disp]
        STOSB
        JMP     AssembleDone
OutDXRAX:
        MOV     BYTE ES:[DI],48h
        INC DI        
OutDXEAX:
        MOV     BYTE ES:[DI],66h
        ADD     DI,WORD [Addr32Disp]
        STOSB
        JMP     AssembleDone

