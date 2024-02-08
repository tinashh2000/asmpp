
; --------------------------------------------------------------------------
; LEDCAPS.ASM - 10/1999 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
; LIGA/DESLIGA <Caps Lock>
; --------------------------------------------------------------------------

         mov   bx,40h
         mov   es,bx
         mov   bx,17h
         mov   ax,es:[bx]
         xor   al,01000000b
         mov   es:[bx],ax

         int   20h

; --------------------------------------------------------------------------
