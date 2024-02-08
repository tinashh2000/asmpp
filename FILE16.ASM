F_FILESTART	= 0
F_FILEPOS	= 1
F_FILEEND	= 2

dfOpen	PROC	fName:WORD,Mode:WORD
	PUSH	DX
	MOV	AL,[Mode]
	MOV	DX,fName
	MOV	AH,3Dh
	INT	21h
	POP	DX
	RET
dfOpen	ENDP

FOpen:
        MOV     AH,3Dh
        INT     21h
        RET
        
FError	PROC
        CALL    PrintFileError
        MOV     SP,WORD [AsmStack]
        MOV     BYTE [Error],QuitError
        JMP     AssembleEndOfFile
FError	ENDP

dfRead	PROC	Handle:WORD,BufferPTR:WORD,BufferSeg:WORD,NumBytes:WORD
	PUSH	BX,CX,DX
	LDS	DX,[BufferPTR]
	MOV	CX,[NumBytes]
	MOV	AH,3Fh
	MOV	BX,[Handle]
	INT	21h
	POP	DX,CX,BX
	RET
dfRead	ENDP

FRead:
        MOV     AH,3Fh
        INT     21h
        JC      FError
        RET

FClose:
        MOV     AH,3Eh
        INT     21h
        RET
FCreate:
        MOV     AH,3Ch
        INT     21h
        RET
FDelete:
        MOV     AH,41h
        INT     21h
        RET
FRename:
        MOV     AH,56h
        INT     21h
        RET
FWrite:
        MOV     AH,40h
        INT     21h
        JC      FError
        RET
FSeek:
        MOV     AH,42h
        INT     21h
        JC      FError
        RET

FGetPos:
        XOR     CX,CX
        XOR     DX,DX
        MOV     AH,42h
		MOV		AL,F_FILEPOS
        INT     21h
        JC      FError
        RET

FGetSize:
		XOR CX,CX
		MOV DX,CX
		MOV AL,F_FILEEND
		CALL	FSeek
		RET

FCopy:
        MOV     CX,0FFFFh
        MOV     DX,WORD [DiskOutStart]
        SUB     CX,DX
        MOV     DS,WORD [DiskOutSeg]
FCopyLoop:
        MOV     BX,SI
        CALL    FRead
        TEST    AX,AX
        JZ      FCopyDone
        MOV     CX,AX
        MOV     BX,DI
        CALL    FWrite
        JMP     FCopyLoop
FCopyDone:
        MOV     AX,AsmData
        MOV     DS,AX
        RET
