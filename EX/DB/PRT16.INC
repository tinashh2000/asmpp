;Routine for printing, used by many files that print messages and statistics.
;This routine performs the BIOS character display functions rather than the
;MS-DOS functions (output redirection is not possible).

PrintStr:
        mov     ah,0Eh
PrintStrLoop:
        lodsb
        int     10h
        cmp     byte [si],0
        jnz     PrintStrLoop
        ret

PrintStrFixed:
        test    cx,cx
        jz      PrintStrfixedend
        mov     ah,0Eh
PrintStrFixedLoop:
        lodsb
        int     10h        
        dec     cx
        jnz     PrintStrfixedLoop
PrintStrFixedEnd:
        ret

PrintLF:
        mov     ax,0E0Dh
        int     10h
        mov     al,0Ah
        int     10h
        ret

PrintInt:        
        mov     di,offset NumBuffer+12
        xor     cx,cx
        push    es
        mov     bx,cs
        mov     es,bx
        mov     bx,10
        std
PrintIntLoop:
        push    ax
        mov     ax,dx
        xor     dx,dx
        div     bx
        mov     si,ax
        pop     ax
        div     bx
        push    ax
        mov     al,dl
        add     al,48
        cs:
        stosb
        mov     dx,si
        pop     ax
        inc     cl
        test    dx,dx
        jnz     PrintIntLoop
        cmp     ax,10
        jae     PrintIntLoop
        test    al,al
        jz      PrintintPrintStr
        add     al,48
        cs:
        stosb
        inc     cl
PrintIntPrintStr:
        cld
        lea     si,[di+1]
        call    PrintStrfixed
        pop     es
        ret

PrintOct:
        mov     di,offset NumBuffer+12
        xor     cx,cx
        push    es
        mov     bx,cs
        mov     es,bx
        mov     bx,8
        std
        jmp     PrintIntLoop
PrintBin:
        mov     di,offset NumBuffer+32
        xor     cx,cx
        push    es
        mov     bx,cs
        mov     es,bx
        mov     bx,8
        std
        jmp     PrintIntLoop

PrintHex:
        push    ax
        mov     ax,dx
        call    PrintHexWord
        pop     ax
        call    PrintHexWord
        ret

PrintHexWord:
        mov     cx,404h
        mov     bx,ax
PrintHexWordLoop:
        rol     bx,cl
        mov     al,bl
        and     al,0Fh

        add     al,48
        mov     ah,7
        mov     dh,0FFh ;Must be 0xff if > 58
        cmp     al,58   ;is al > 58
        adc     dh,0    ;inc dh if below
        and     ah,dh   ;erase ah if < 58
        add     al,ah   ;al+ah->ah

        mov     ah,0Eh
        int     10h
        dec     ch
        jnz     PrintHexWordLoop
        ret
NumBuffer      db      128 dup(0)
