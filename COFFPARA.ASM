CodeSegCoff32 PROC        
        MOV     AL,[cf32Flags]
        TEST    AL,0F0h     ;IF this is code,IMPORT,EXPORT OR data
        JNZ csCoff32Error
        OR      BYTE [cf32Flags],80h          ;this is code
        MOV     DI,[cf32Seg]
        OR      BYTE [DI].pesCharacter,20h      ;code
        OR      BYTE [DI][2].pesCharacter,50h      ;ALIGN16
        OR      BYTE [DI][3].pesCharacter,60h   ;readable, executable
        CLC
        RET
csCoff32Error:
		STC
		RET
CodeSegCoff32 ENDP

NotPagedSegCoff32 PROC
        MOV     DI,[cf32Seg]
        OR      BYTE [DI][3].pesCharacter,4      ;Notpageable
        CLC
        RET
NotPagedSegCoff32 ENDP

DiscardableSegCoff32  PROC
        MOV     DI,[cf32Seg]
        OR      BYTE [DI][3].pesCharacter,2      ;Discardable
        CLC
        RET
DiscardableSegCoff32  ENDP

ExecutableSegCoff32   PROC
        MOV     AL,[cf32Flags]
        TEST    AL,80h
        JZ  xsCoff32Error
        CLC
        RET
xsCoff32Error:
		STC
		RET

ExecutableSegCoff32   ENDP

ShareableSegCoff32    PROC
        MOV     DI,[cf32Seg]
        OR      BYTE [DI][3].pesCharacter,10h      ;Shaareable
        CLC
        RET
ShareableSegCoff32    ENDP

WritableSegCoff32 PROC     
        MOV     AL,[cf32Flags]
        TEST    AL,80h      ;Is this code
        JNZ wsCoff32Error
        MOV     DI,[cf32Seg]
        OR      BYTE [DI][3].pesCharacter,80h      ;Writable
        CLC
        RET
wsCoff32Error:
		STC
		RET
WritableSegCoff32 ENDP
		
DataSegCoff32 PROC
        MOV     AL,[cf32Flags]
        TEST    AL,0F0h     ;IF this is code,IMPORT,EXPORT OR data
        JNZ dsCoff32Error
        OR      BYTE [cf32Flags],40h        ;Dataseg
        MOV     DI,[cf32Seg]
        OR      BYTE [DI].pesCharacter,40h      ;data
        OR      BYTE [DI][3].pesCharacter,40h   ;readable
        CLC
        RET
dsCoff32Error:
		STC
		RET
DataSegCoff32 ENDP

ReadableSegCoff32 PROC
        MOV     DI,[cf32Seg]
        OR      BYTE [DI][3].pesCharacter,40h      ;readable
        CLC
        RET
ReadableSegCoff32 ENDP



OpenCoff32GetParam    PROC

 oCoff32gpGetParams:
	CALL	GetNextStr

	MOV DI,SI

	MOV CX,[StrLen]
	TEST	CX,CX
    JZ  oCoff32gpDone

	MOV AX,[StrCRC]
	MOV DX,[StrCRC][2]

	CMP CL,5
    JZ  oCoff32gpParams5

	CMP CL,6
    JZ  oCoff32gpParams6

	CMP CL,10
    JZ  oCoff32gpParams10
 oCoff32gpDone:
	RET

 oCoff32gpDebug:
    JMP oCoff32gpGetParams

 oCoff32gpParams5:

	CMP AX,544Fh
    JZ  oCoff32gpDebug
	JMP	oCoff32gpGetParams

 oCoff32gpParams6:
    JMP oCoff32gpGetParams
    
 oCoff32gpParams10:
	CMP AX,82E0h
    JZ  oCoff32gpExe
    JMP oCoff32gpGetParams

 oCoff32gpExe:
    AND WORD [cf32Character],NOT 2000h
    OR  WORD [cf32Character],2
    JMP oCoff32gpGetParams

OpenCoff32GetParam    ENDP

