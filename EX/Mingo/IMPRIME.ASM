
; --------------------------------------------------------------------------
; IMPRIME (utilizando a impressora) - 09/04/1999 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov   ah,40h        ; escreve para
         mov   bx,4          ; impressora
         mov   cx,15         ; 15 caracteres
         lea   dx,Texto
         int   21h

         int   20h           ; sai do programa

Texto    db    'Hello World!',0Dh,0Ah
         db    0Ch
