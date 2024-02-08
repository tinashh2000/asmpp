EVEN 2
ConvDecNum:        
        XOR     BP,BP
        XOR     CX,CX
        MOV     BYTE [SI][1],CL
        STD
        CMP     DI,3
        JBE     ConvDecNum8
        CMP     DI,5
        JBE     ConvDecNum16
        CMP     DI,10
        JBE     ConvDecNum32
        JMP     ConvDecNum64
EVEN 2
ConvDecNum8:
        XOR AX,AX
        MOV CX,AX
ConvDecNum8Loop:        
        MOV CL,[SI]
        DEC     DI
        JZ      ConvDecNum8Done
        MOV AL,[SI][-1]
        DEC DI
        JZ  ConvDecNum8x
        MOV AH,[SI][-2]
 ConvDecNum8x:
        AAD
        MOV BL,10
        MUL     BL
        ADD     CL,AL
        ADC     CH,AH
ConvDecNum8Done:
        MOV     DX,CX
        TEST    DH,DH
        JNZ     ConvDecNum16Done
        MOV     WORD [OWordNum],DX
        MOV     AX,(Number SHL 8 ) OR Num8
        CLD
        RET
ConvDecNum16:
        MOV     BX,OFFSET Num16Table
ConvDecNum16Loop:
        LODSB
        XOR     AH,AH
        MUL     WORD [BX]

        ADD     BP,AX
        ADC     CL,DL      ;Carry can never carry before the last BYTE

        ADD     BX,2
        DEC     DI
        JNZ     ConvDecNum16Loop

        CMP CL,0
        JNZ     ConvDecNum32Done

        MOV     DX,BP
ConvDecNum16Done:
        MOV     WORD [OWordNum],DX
        MOV     AX,(Number SHL 8 ) OR Num16
        CLD
        RET

ConvDecNum32:
        MOV     BX,OFFSET Num32Table
ConvDecNum32Loop:
        LODSB
        XOR     AH,AH
        PUSH    AX
        MUL     WORD [BX]
        ADD     BP,AX
        ADC     CX,DX
        POP     AX
        MUL     WORD [BX][2]
        ADD     BX,4
        ADD     CX,AX
        DEC     DI
        JNZ     ConvDecNum32Loop
        ADC     BYTE [OWordNum][4],DL
        JNZ     ConvDecNum48Done
ConvDecNum32Done:
        MOV     WORD [OWordNum],BP
        MOV     WORD [OWordNum][2],CX
        MOV     AX,(Number SHL 8 ) OR Num32
        MOV     DX,BP
        CLD
        RET

ConvDecNum64:        
        MOV     BX,OFFSET Num32Table
ConvDec64Loop32:
        LODSB
        XOR     AH,AH
        PUSH    AX
        MUL     WORD [BX]
        ADD     BP,AX
        ADC     CX,DX
        POP     AX
        MUL     WORD [BX][2]
        DEC     DI
        ADD     CX,AX
        ADC     WORD [OWordNum][4],DX
        ADD     BX,4
        CMP     BX,OFFSET Num48Table
        JAE     ConvDec64Enter48
        JMP     ConvDec64Loop32
ConvDecNum48Done:
        MOV     AX,(Number SHL 8 ) OR Num48
        JMP     ConvDecNumDone
ConvDec64Enter48:
ConvDec64Loop48:
        LODSB
        XOR     AH,AH
        MOV     WORD [Temp10],AX
        MUL     WORD [BX]
        ADD     BP,AX
        ADC     CX,DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][2]
        ADD     CX,AX
        ADC     WORD [OWordNum][4],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][4]
        ADD     WORD [OWordNum][4],AX
        ADC     WORD [OWordNum][6],DX
        DEC     DI
        JZ      ConvDecNum48Done
        ADD     BX,6
        CMP     BX,OFFSET Num64Table
        JAE     ConvDec64Enter64
        JMP     ConvDec64Loop48
EVEN 2
ConvDec64Enter64:
ConvDec64Loop64:
        LODSB
        XOR     AH,AH
        MOV     WORD [Temp10],AX
        MUL     WORD [BX]
        ADD     BP,AX
        ADC     CX,DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][2]
        ADD     CX,AX
        ADC     WORD [OWordNum][4],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][4]
        ADD     WORD [OWordNum][4],AX
        ADC     WORD [OWordNum][6],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][6]
        ADD     WORD [OWordNum][6],AX
        ADC     WORD [OWordNum][8],DX
        DEC     DI
        JZ      ConvDecNum64Done
        ADD     BX,8
        CMP     BX,OFFSET Num80Table
        JAE     ConvDecEnter80
        JMP     ConvDec64Loop64
ConvDecNum64Done:
        MOV     AX,(Number SHL 8 ) OR Num64
ConvDecNumDone:
        MOV     WORD [OWordNum],BP
        MOV     WORD [OWordNum][2],CX
        MOV     DX,BP
        CLD
        RET
EVEN 2
ConvDecEnter80:
ConvDecLoop80:
        LODSB
        XOR     AH,AH
        MOV     WORD [Temp10],AX
        MUL     WORD [BX]
        ADD     BP,AX
        ADC     CX,DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][2]
        ADD     CX,AX
        ADC     WORD [OWordNum][4],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][4]
        ADD     WORD [OWordNum][4],AX
        ADC     WORD [OWordNum][6],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][6]
        ADD     WORD [OWordNum][6],AX
        ADC     WORD [OWordNum][8],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][8]
        ADD     WORD [OWordNum][8],AX
        ADC     WORD [OWordNum][0010],DX
        DEC     DI
        JZ      ConvDecNum80Done
        ADD     BX,10
        CMP     BX,OFFSET Num128Table
        JAE     ConvDecLoop128
        JMP     ConvDecLoop80
ConvDecNum80Done:
        MOV     AX,(Number SHL 8 ) OR Num80
        JMP     ConvDecNumDone
EVEN 2
ConvDecLoop128:
        LODSB
        XOR     AH,AH
        MOV     WORD [Temp10],AX
        MUL     WORD [BX]
        ADD     BP,AX
        ADC     CX,DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][2]
        ADD     CX,AX
        ADC     WORD [OWordNum][4],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][4]
        ADD     WORD [OWordNum][4],AX
        ADC     WORD [OWordNum][6],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][6]
        ADD     WORD [OWordNum][6],AX
        ADC     WORD [OWordNum][8],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][8]
        ADD     WORD [OWordNum][8],AX
        ADC     WORD [OWordNum][0010],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][0010]
        ADD     WORD [OWordNum][0010],AX
        ADC     WORD [OWordNum][0012],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][0012]
        ADD     WORD [OWordNum][0012],AX
        ADC     WORD [OWordNum][0014],DX
        MOV     AX,WORD [Temp10]
        MUL     WORD [BX][0014]
        ADD     WORD [OWordNum][0014],AX
        ADC     WORD [OWordNum][0016],DX
        DEC     DI
        JZ      ConvDec128Done
        ADD     BX,16
        CMP     BX,OFFSET Num256Table
        JAE     ConvDecLoop256
        JMP     ConvDecLoop128
ConvDec128Done:
        MOV     AX,(Number SHL 8 ) OR Num128
        JMP     ConvDecNumDone
ConvDecLoop256:
        JMP     ConvDecNumDone

EVEN 2
ConvHexNum:
        XOR     BP,BP
        MOV     BX,DI
        SHR     DI,1
        ADC     BX,BP   ;must have an EVEN value
        MOV     DI,OFFSET OWordNum
        MOV     CL,4
        DEC     SI
        STD
ConvHexLoop:
        LODSW
        SHL     AL,CL
        OR      AL,AH
        MOV     BYTE [DI],AL
        INC     DI
        SUB     BX,2
        JNZ     ConvHexLoop
        CLD
        MOV     AL,BYTE [DI][NumSizeTable][-OWordNum][-1]
        MOV     AH,Number
        MOV     DX,WORD [OWordNum]
        RET

EVEN 2
ConvBinNum:        
        XOR     DX,DX
        XOR     CX,CX
        MOV     BX,DI
        MOV     DI,OFFSET OWordNum
        MOV     CH,8
        STD
ConvBinLoop:
        LODSB
        SHR     AL,1
        ADC     DL,CL
        ROR     DL,1
        DEC     CH
        JZ      ConvBinUpdate
        DEC     BX
        JNZ     ConvBinLoop
ConvBinDone:
        MOV     CL,CH
        SHR     DL,CL
        MOV     BYTE [DI],DL
ConvBinDone2:
        CLD
        MOV     AL,BYTE [DI][NumSizeTable][-OWordNum]
        MOV     AH,Number
        MOV     DX,WORD [OWordNum]
        RET
ConvBinUpdate:
        MOV     BYTE [DI],DL
        INC     DI
        MOV     DL,0
        MOV     CH,8
        DEC     BX
        JNZ     ConvBinLoop
        DEC     DI
        JMP     ConvBinDone2
