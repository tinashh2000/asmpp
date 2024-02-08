
; --------------------------------------------------------------------------
; BEEP.ASM - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov     cx,2      ; numero de BEEPs
         mov     ax,3591
         beep:
         int     10h
         loop    beep

         int     20h
