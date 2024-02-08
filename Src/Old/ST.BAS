OPEN "cpu16.crc" FOR INPUT AS #1
OPEN "cpu16.asm" FOR OUTPUT AS #2
OPTION BASE 0
DIM CrcIdx(1000)  AS STRING
cc = 0
pptr = 0
DO
        LINE INPUT #1, a$
        a$ = RTRIM$(a$)
        a = INSTR(a$, ":")
        IF a THEN
                IF ASC(MID$(a$, a - 1)) < 60 THEN
                        cc$ = LEFT$(a$, a - 1)
                        PRINT #2, a$
                        BackPos = SEEK(2)
                        PRINT #2, STRING$(119, 32)
                        PRINT #2, "        dw  " + cc$ + "High," + cc$ + "Desc"
                ELSEIF RIGHT$(a$, 5) = "desc:" THEN
                        ThisPos = SEEK(2)
                        SEEK 2, BackPos
                        sss$ = "        db  " + MID$(sss$, 2) + "," + RIGHT$("000" + LTRIM$(STR$(cc)), 3)
                        PRINT #2, sss$
                        SEEK 2, ThisPos
                        sss$ = ""
                        PRINT #2, cc$ + "High:"
                        FOR count = 0 TO pptr - 1
                                PRINT #2, CrcIdx(count)
                        NEXT
                        PRINT #2, a$
                        cc = 0
                        pptr = 0
                        cc$ = ""
                ELSE
                        PRINT #2, a$
                        sss$ = sss$ + "," + RIGHT$("000" + LTRIM$(STR$(cc)), 3)
                END IF
        ELSEIF UCASE$(LEFT$(LTRIM$(a$), 2)) = "DD" THEN
                aa = INSTR(UCASE$(a$), "DD")
                MID$(a$, aa, 2) = "dw"
                cc = cc + 1
                aa = INSTR(a$, "0")
                CrcIdx(pptr) = LEFT$(a$, aa + 4) + "h" + MID$(a$, aa + 10) + " high"
                a$ = LEFT$(a$, aa) + MID$(a$, aa + 5) + " low"
                PRINT #2, a$
                pptr = pptr + 1
        ELSE
                PRINT #2, a$
        END IF
LOOP UNTIL EOF(1)

