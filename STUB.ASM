IFDEF ??ASMPP
    OPTION OUT "STUB.EXE"
ENDIF

    ORG 0
    DW  "ZM"
    DW  (ProgEnd+511) AND 1FFh
    DW  (ProgEnd+511) SHR 9
    DW  0
    DW  2   ;Header SIZE IN paras
    DW  10h ;Min heap
    DW  10h ;Max heap
    DW  2       ;SS
    DW  60h     ;SP
    DW  0   ;STACK
    DW  0       ;IP
    DW  2       ;CS
    DW  40h     ;Reloc
    DB  3Ch-$ DUP(0)
    DD  80h
Start:
    MOV AX,CS
    MOV DS,AX
    MOV DX,(Msg-Start)
    MOV AH,9
    INT 21h
    MOV AX,4CFFh
    INT 21h
Msg DB  "This program is not designed for DOS.",13,10,"$"
    DB  80h-$ DUP(0)
END Start
ProgEnd:
