
; --------------------------------------------------------------------------
; CURLIG.ASM - Liga o Cursor - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov       ah,1
         mov       ch,12
         mov       cl,13
         int       10h
         int       20h
