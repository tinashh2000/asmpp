CLS
aa$ = COMMAND$
IF aa$ = "" THEN
        INPUT "Enter object file ", aa$
        IF aa$ = "" THEN END
END IF
OPEN aa$ FOR BINARY AS #1
DIM a AS STRING * 10000
DO
        b = SEEK(1)
        GET #1, , a
        lenn = SEEK(1) - b
        ptr = 1
        DO
                theword = ASC(MID$(a, ptr + 1, 1)) + (ASC(MID$(a, ptr + 2, 1)) * 256#)
                PRINT HEX$(ASC(MID$(a, ptr, 1))), HEX$(theword)
                ptr = ptr + theword + 3
        LOOP UNTIL ptr >= lenn
LOOP UNTIL EOF(1)

