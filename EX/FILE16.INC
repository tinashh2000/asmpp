;This file is part of ASM++ 's DOS file routines!
;This file is used by LCOUNT.APP,DUP.APP and CRC.APP etc to manipulate files.
;These routines work in DOS. On my PC they work quite fine.

ReadOnly        equ 00
WriteOnly       equ 01
ReadWrite       equ 02
FOpen:
        mov     ah,3Dh
        int     21h
        ret
FRead:
        mov     ah,3fh
        int     21h
        ret
FClose:
        mov     ah,3eh
        int     21h
        ret
FCreate:
        mov     ah,3ch
        int     21h
        ret
FDelete:
        mov     ah,41h
        int     21h
        ret
FRename:
        mov     ah,56h
        int     21h
        ret
FWrite:
        mov     ah,40h
        int     21h
        ret
FSeek:
        mov     ah,42h
        int     21h
        ret

FGetPos:
        xor     cx,cx
        xor     dx,dx
        mov     ax,4201h
        int     21h
        ret
