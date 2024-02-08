FORMAT PE32
.LANG STDCALL
.STACK 8192
.HEAP 8192

PUBLIC ON

Code SEGMENT '.text' CODE
NOP
NOP
NOP
Start:
    MOV EAX,Start
    CALL	PrintHex
    CALL    MessageBox,0,(_Hello),(_Hello),0
    CALL    ExitProcess,0

PrintHex	PROC

        MOV     EDI,(_hexnum)
	MOV	CL,8
        MOV     EBX,EAX
 phLoop:
        ROL     EBX,4
        MOV     AL,BL
        AND     AL,0Fh
        ADD     AL,48
	STOSB
	DEC	CL
	JNZ	phLoop
	MOV	AL,0
        STOSB
	SUB	EDI,9
	CALL	MessageBox,0,EDI,EDI,0
	RET
ENDP

Data SEGMENT '.data' DATA WRITEABLE
_Hello  DB  "Hello From Here",0
_hexnum	DB	20 DUP(0)

IData SEGMENT '.idata' IMPORT

    IMPORT  "KERNEL32.DLL"          ;Define library

        ExitProcess,"ExitProcess"   ;Its modules
        CreateFile,"CreateFileA"

    IMPORT  "USER32.DLL"            ;Another library

        MessageBox,"MessageBoxA"    ;Its modules

    END                             ;End of definition

END Start                           ;End of file (Ignored), EntryPoint=Start

