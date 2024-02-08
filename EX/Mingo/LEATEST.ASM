
; --------------------------------------------------------------------------
; Teste do comando LEA - 04/1999 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         lea   dx,texto

         mov   ah,9
         int   21h

         int   20h

texto    db 'Teste do comando LEA',0Dh,0Ah
         db 'Load Effective Address OFFSET', 0Dh, 0Ah
         db '$'
