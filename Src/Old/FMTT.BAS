OPEN "crc.asm" FOR INPUT AS #1
OPEN "crc.app" FOR OUTPUT AS #2
DO
        a% = 1
        LINE INPUT #1, a$
        IF LEFT$(a$, 1) = " " THEN
                a$ = "    " + LTRIM$(a$)
                a% = 5
        END IF
        'DO
                a% = INSTR(a%, a$, CHR$(32))
                IF a% THEN
                        b% = a% + (NOT (4 - (a% MOD 5)) AND 1)
                        a$ = LEFT$(a$, a% - 1) + SPACE$(4 - (b% MOD 5)) + LTRIM$(MID$(a$, a% + 1))
                        a% = a% + (4 - (a% MOD 5))
                END IF
        'LOOP UNTIL a% = 0
        PRINT #2, a$
LOOP UNTIL EOF(1)

