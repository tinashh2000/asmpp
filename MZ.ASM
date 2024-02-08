OpenMZFormat	PROC
        MOV BYTE [CurSeg],SEGMENT_CODE
        MOV BYTE [CurSeg][3],1
        MOV     AX,400h
        MOV     [mzInitSP],AX
        MOV     AX,40h
        MOV     [mzStackSize],AX
        MOV     [mzMinMemory],AX
        MOV     [mzHeapSize],AX
        XOR     AX,AX
        MOV     [mzNumReloc],AX     
        MOV     AL,32
        MOV     [mzHeaderSize],AX
        MOV     WORD [NewFileSize],28
        MOV     BX,[DiskOutStart]
        ADD     BX,AX
        MOV     [OBufferPtr],BX
        MOV     WORD [mzRelocPTR],OFFSET mzRelocBuffer
        MOV     BYTE [SegAlignment],16
        MOV     BX,[NewHandle]
        TEST    BX,BX
        JZ      OpenMZFormatDone
        XOR     CX,CX
        MOV     DX,28
        MOV     AL,0
        CALL    FSeek
OpenMZFormatDone:
        RET
OpenMZFormat	ENDP


CloseMZFile	PROC
		JMP	cmzStart
 CloseMZRemoveFile:
        JMP     CloseOutRemoveFile
 cmzStart:		
        CMP     WORD [FileSize][0002],0
        JNZ     CloseMZFileNameOK
        CMP     WORD [FileSize],32
        JBE     CloseMZRemoveFile
CloseMZFileNameOK:
        CALL    PrintOutFile        
        MOV     BP,WORD [mzNumReloc]
        MOV     SI,OFFSET FileSize
        MOV     AX,WORD [SI]
        MOV     WORD [Temp1],AX
        MOV     AX,WORD [SI][0002]
        MOV     WORD [Temp2],AX
        TEST    BP,BP
        JZ      CloseMZFileNameReloc1OK
        MOV     CX,WORD [mzRelocPTR]
        SUB     CX,(mzRelocBuffer)
        JZ      CloseMZReloc1BuffOK
        MOV     BX,WORD [NewHandle]
        CALL    MZRelocFlush
CloseMZReloc1BuffOK:
        MOV     AX,WORD [NewFileSize]
        MOV     CX,AX
        SUB     CX,16
        NEG     CX
        AND     CX,0Fh
        MOV     BX,WORD [NewHandle]
        MOV     DX,(mzHeaderBuffer)
        CALL    FWrite
        ADD     WORD [NewFileSize],AX
        ADC     WORD [NewFileSize][2],0
        MOV     AX,WORD [NewFileSize]
        MOV     DX,WORD [NewFileSize][2]
        SUB     AX,32
        SBB     DX,0
        ADD     WORD [SI],AX
        ADC     WORD [SI][0002],DX
CloseMZFileNameReloc1OK:
        MOV     AX,WORD [SI]
        ADD     WORD [BytesWritten],AX
        MOV     AX,WORD [SI][0002]
        ADC     WORD [BytesWritten][0002],AX
        MOV     DI,OFFSET mzHeaderBuffer
        MOV     AX,'ZM'
        STOSW   ;Header signature
        MOV     AX,WORD [SI]
        MOV     BX,AX
        AND     AH,1
        MOV     BL,BH
        AND     BL,0FEh
        MOV     BH,BYTE [SI][0002]
        SHR     BH,1
        ADC     BL,0
        ROR     BL,1
        STOSW           ;Last 512 bytes IN file
        CMP     AX,1    ;IF AX > 0 then AX=AX+1
        MOV     AX,BX
        CMC
        ADC     AL,0
        STOSW           ;Number of 512 BYTE pages IN file
        XOR     DX,DX
        MOV     AX,BP
        STOSW           ;Number of relocatables
        CMP     AX,1
        CMC
        SBB     AX,DX
        ADD     AX,AX   ;DX:AX=AX*4
        ADC     DX,00
        ADD     AX,AX
        ADC     DX,00
        MOV     BX,16
        CALL    Div32      ;DX:AX=DX:AX/16 to get paragraphs
        CMP     SI,1
        CMC
        ADC     AX,2    ;ADD two paragraphs to the SIZE
        STOSW           ;Number of bytes IN header
        MOV     AX,WORD [UninitData]
        MOV     DX,WORD [UninitData][0002]
        MOV     BX,16
        CALL    Div32
        CMP     SI,1
        CMC
        ADC     AX,WORD [mzMinMemory]
        STOSW           ;Minimum memory to be allocated
        MOV     BX,AX
        MOV     AX,[mzHeapSize]
        CMP     AX,BX
        JAE     MZHeapOK
        MOV     AX,BX
MZHeapOK:
        STOSW           ;Maximum allocatable paragraphs of memory
        MOV     AX,WORD [mzInitSS]
        TEST    AX,AX
        JNZ     CloseMZStackSSOK
        MOV     AX,WORD [Temp1]
        ADD     AX,WORD [UninitData]
        MOV     DX,WORD [Temp2]
        ADC     DX,WORD [UninitData][0002]
        MOV     BX,16
        CALL    Div32
        SUB     AX,2
        CMP     SI,1
        CMC
        ADC     AX,0
CloseMZStackSSOK:
        STOSW
        MOV     AX,WORD [mzInitSP]
        STOSW
        XOR     AX,AX
        STOSW
        MOV     AX,WORD [mzInitIP]
        STOSW
        MOV     AX,WORD [mzInitCS]
        STOSW
        MOV     AX,01Ch
        STOSW           ;Relocatable OFFSET
        XOR     AX,AX
        STOSW           ;Overlay
        TEST    BP,BP
        JZ      CloseMZNoReloc        
CloseMZRelocFileOK:
        XOR     DX,DX   ;Point Newhandle to start of file
        MOV     CX,DX
        MOV     AL,0
        MOV     BX,WORD [NewHandle]
        CALL    FSeek
        MOV     DX,OFFSET mzHeaderBuffer    ;Write header
        MOV     CX,01Ch
        MOV     BX,WORD [NewHandle]
        CALL    FWrite
        XOR     CX,CX   ;Point NewFile to END of file
        MOV     DX,CX
        MOV     AL,2
        MOV     BX,WORD [NewHandle]
        MOV     DI,BX
        CALL    FSeek
        MOV     DX,[mzHeaderSize]
        XOR     CX,CX   ;Point OutFile to 32 from start of file
        MOV     AL,0
        MOV     BX,WORD [OutHandle]
        MOV     SI,BX
        CALL    FSeek
        CALL    FCopy
        MOV     BX,SI
        CALL    FClose
        MOV     BX,DI
        CALL    FClose
        MOV     DX,OFFSET OutFile
        CALL    FDelete
        MOV     DX,OFFSET NewFile
        MOV     DI,OFFSET OutFile
        CALL    FRename
        RET
CloseMZNoReloc:        
        XOR     AX,AX
        STOSW
        STOSW
        MOV     DX,OFFSET mzHeaderBuffer
        LEA     CX,[DI][-mzHeaderBuffer]
        MOV     BX,WORD [OutHandle]
        CALL    FWrite
        XOR     DX,DX
        XOR     CX,CX
        MOV     AL,2
        MOV     BX,WORD [OutHandle]
        CALL    FSeek
        CALL    FClose
		MOV		WORD [OutHandle],0
        RET
CloseMZFile	ENDP

MZReloc	PROC
        MOV     SI,OFFSET RelocData
        MOV     AX,DI
        INC     WORD [mzNumReloc]
        XOR     DX,DX        
        SUB     AX,WORD [mzHeaderSize]
        SBB     DX,DX
        ADD     AX,[FileSize]
        ADC     DX,[FileSize][0002]

        SUB     AX,[DiskOutStart]
        SBB     DX,0        
        TEST    DX,DX
        JZ      MZRelocOfsOK
        MOV     CL,4
        MOV     BL,DL
        MOV     DX,AX
        SHR     DX,CL
        SHL     BL,CL
        OR      DH,BL
        AND     AX,0Fh
MZRelocOfsOK:
        MOV     BX,WORD [mzRelocPTR]
        MOV     WORD [BX][0002],DX
        MOV     WORD [BX],AX
        ADD     BX,4
        MOV     WORD [mzRelocPTR],BX
        MOV     BYTE [RelocFlags],0
        SUB     BX,OFFSET mzRelocBuffer+4090
        JAE     MZRelocFlush ;Must be carry otherwise its NEAR limit
        RET
MZRelocFlush:        
        CMP     WORD [NewHandle],0
        JZ      MZRelocCreateNew
        MOV     BX,WORD [NewHandle]
        CALL    FGetPos
        PUSH    DI
        MOV     BX,WORD [NewHandle]
        MOV     CX,WORD [mzRelocPTR]
        MOV     DX,OFFSET mzRelocBuffer
        MOV     WORD [mzRelocPTR],DX
        SUB     CX,DX
        CALL    FWrite
        ADD     WORD [NewFileSize],AX
        ADC     WORD [NewFileSize][0002],0
        POP     DI
        RET
MZRelocCreateNew:
        PUSH    SI,DI,ES
        CALL    CreateNewFile
        MOV     CX,WORD [mzRelocPTR]
        MOV     DX,OFFSET mzHeaderBuffer
        SUB     CX,DX
        CALL    FWrite
        MOV     WORD [NewFileSize],AX
        MOV     WORD [NewFileSize][0002],0
        MOV     WORD [mzRelocPTR],OFFSET mzRelocBuffer
        POP     ES,DI,SI
        RET
MZReloc	ENDP

GetSegAddrMZ	PROC
        MOV     BX,[SegAlignment]
        MOV     AX,WORD [OBufferPtr]
        SUB     AX,WORD [mzHeaderSize]
        SUB     AX,WORD [DiskOutStart]

        ADD     AX,WORD [FileSize]
        ADC     DX,WORD [FileSize][2]

        ADD     AX,WORD [UninitData]
        ADC     DX,WORD [UninitData][2]

        DEC     BX
        ADD     AX,BX
        ADC     DX,0
        INC     BX
        CALL    Div32

        XOR     DX,DX
        CLC
        RET
GetSegAddrMZ	ENDP

EndMZ	PROC
        MOV [mzInitIP],DX
        MOV AX,[mzSeg]
        TEST    BYTE [Settings],1
        JZ  EndMZAddrOK
        MOV AX,[OWordNum][-2]
EndMZAddrOK:
        MOV [mzInitCS],AX
        RET
EndMZ	ENDP


MZInitSeg	PROC

        XOR DX,DX
        CALL    GetSegAddrMZ
        MOV [mzSeg],AX
        MOV [ProgIP][-2],AX
        RET
MZInitSeg	ENDP

MZCloseSeg  PROC
    XOR AX,AX
    MOV [ProgIP],AX
    MOV [ProgIP][2],AX
    MOV [ProgIP][4],AX
    MOV [ProgIP][6],AX
    RET
MZCloseSeg  ENDP

MZStack	PROC
        CMP     AL,Num16
        JA      MZStackTooBig
        MOV     AL,DL
        AND     AL,0Fh
        MOV     WORD [mzInitSP],DX
        MOV     CL,4
        SHR     DX,CL
        CMP     AL,1
        CMC
        ADC     DX,0
        MOV     AX,WORD [mzStackSize]    ;Subtract initial STACK space
        SUB     WORD [mzMinMemory],AX
        MOV     WORD [mzStackSize],DX    ;Store specified STACK space
        ADD     WORD [mzMinMemory],DX
        JMP     AssembleDone2
MZStackTooBig:
        JMP     NumTooBig

MZStack	ENDP
