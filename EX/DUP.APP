;This program simply duplicates lines. Its faster for the string buffer to
;have more lines than for more lines count
jmp     start
QuitError=255
include file16.inc
include prt16.inc
start:
        mov     si,offset IntroMsg
        call    PrintStr

        mov     al,readonly
        mov     dx,offset filename
        xor     cx,cx
        call    fcreate
        jc      file_open_failed
        mov     word [handle],ax
        mov     bx,ax
        mov     si,10   ;Lines count
write_loop:
        mov     cx,(buffer_end-buffer_start)    ;Size of buffer
        mov     dx,offset buffer_start  ;Buffer address
        call    fwrite  ;Write it
        jc      file_write_failed
        dec     si      ;loop as long as the count is not zero
        jnz     write_loop
        xor     al,al
prog_quit:
        mov     ah,4ch
        int     21h
file_write_failed:
        mov     si,offset write_error
        call    printstr
        mov     al,-1
        jmp     prog_quit
file_open_failed:
        mov     si,offset open_error
        call    printstr
        mov     al,-1
        jmp     prog_quit
open_error      db      "An error occured while trying to open the file",13,10,0
write_error     db      "An error occured while writing to file",13,10,0
IntroMsg        db      "This program originally creates a file DUP.TXT",13,10
                db      "with duplicated text in it. You can modify it to",13,10
                db      "perform your tasks",13,10,0
filename        db      "dup.txt",0
handle          dw      0
buffer_start:
    db  "This file was created by DUP",13,10
buffer_end:
