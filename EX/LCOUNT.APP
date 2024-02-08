;This program opens a text file, counts all the lines in it. Thats all!

        jmp     Start
include prt16.inc
include file16.inc
Start:
        mov     si,offset Msg
        call    PrintStr
        mov     ax,cs
        mov     es,ax
        mov     si,80h
        lodsb
        test    al,al
        jz      LCountUsage
        xor     cx,cx   ;File length
        mov     di,offset CmdLine
GetFileNameRemoveSpace:
        lodsb
        cmp     al,32
        jz      GetFileNameRemoveSpace
        cmp     al,9
        jz      GetFileNameRemoveSpace
        dec     si
GetFileNameLoop:
        lodsb
        cmp     al,0Dh
        jz      InitFiles
        inc     cx
        stosb
        jmp     GetFileNameLoop
LCountUsage:
        mov     si,offset Usage
        jmp     LCountExitError
InitFiles:
        mov     al,0
        stosb
        mov     ax,cs
        mov     ds,ax
        mov     al,ReadOnly
        mov     dx,offset CmdLine
        call    FOpen
        jc      FileError
        mov     word [Handle],ax
        xor     ax,ax
        mov     word [LineCount],ax
        mov     word [LineCount][0002],ax
LCountReadMore:        
        mov     bx,word [Handle]
        mov     cx,32768
        mov     dx,offset FileBuffer
        call    FRead
        jc      FileError
        test    ax,ax
        jz      LCountDone
        mov     di,offset FileBuffer
        mov     cx,ax   ;Bytes read
LCountLoop:
        mov     al,0Ah
        cmp     al,0
        repnz   scasb
        jnz     LCountReadMore
        add     word [LineCount],1
        adc     word [LineCount][0002],0
        jmp     LCountLoop
LCountDone:
        les     ax,dword [LineCount]    ;Avoid using memory twice but es
        mov     dx,es                   ;is altered!
        call    PrintInt
        mov     al,0
        jmp     LCountExit
FileError:
        mov     si,offset FileErr
LCountExitError:
        call    PrintStr
        mov     al,0FFh
LCountExit:
        mov ah,4Ch
        int 21h

Msg     db  "Line counter utility",13,10
        db  "Developed by Tinashe Mutandagayi (17 Dec 2006)",13,10,13,10,0
Usage   db  "Usage:     LCount <FileName>",13,10,13,10
        db  "It prints the number of lines found in FileName",13,10
        db  "Use it as you please",13,10,0

FileErr     db  "Disk/File Error",13,10,0
CmdLine db  128 dup(0)
LineCount   dd  0
Handle  dw  0
FileBuffer:
