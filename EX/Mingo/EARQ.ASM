
; --------------------------------------------------------------------------
; Escreve um Arquivo-texto - 04/1999 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

        .model tiny
        .code

start   PROC
        push    ax
        push    bx
        push    cx
        push    dx
        mov     ah,3Ch
        mov     cx,0
        mov     dx,offset NOMEARQ
        int     21h
        push    ax
        mov     ah,40h
        pop     bx
        push    bx
        mov     cx,35             ; numero de BYTES
        mov     dx,offset TEXTO
        int     21h

        mov     ah,3eh
        pop     bx

        int     21h
        pop     dx
        pop     cx
        pop     bx
        pop     ax

        int     20h               ; volta para o DOS

TEXTO   db 'Testando a escrita de um arquivo!',0Dh,0Ah ; 35 BYTES

NOMEARQ db 'TESTE.TXT',0

start   ENDP
        END     start
