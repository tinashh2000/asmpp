
; --------------------------------------------------------------------------
; SOBE.ASM - 05/1998 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov       cx,25

repete:
         mov       dl,0Ah
         mov       ah,2
         int       21h

         mov       dx,3DAh
espe:
         in        al,dx
         and       al,8
         jnz       espe
retr:
         in        al,dx
         and       al,8
         jz        retr

         loop      repete
         int       20h
