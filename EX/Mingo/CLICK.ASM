
; --------------------------------------------------------------------------
; CLICK.ASM - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov       bx,76
         in        al,97
         push      ax
p0:
         and       al,252
         out       97,al
         mov       cx,148
p1:
         loop      p1
         or        al,2
         out       97,al
         mov       cx,2048
p2:
         loop      p2
         dec       bx
         jnz       p0
         pop       ax
         out       97,al

         int       20h
