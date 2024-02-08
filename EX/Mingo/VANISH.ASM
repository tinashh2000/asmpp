
; --------------------------------------------------------------------------
; VANISH.ASM - Mingo Vanish - 05/1998 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.model   tiny
.code

start    PROC
         mov       ax,47104
         mov       ds,ax
         mov       al,7

P1:
         xor       bx,bx
         xor       cx,cx
P2:
         mov       ah,[bx]
         cmp       ah,20h
         jz        P5
         jb        P3
         dec       ah
         jmp       P4
P3:
         mov       ah,20h
P4:
         mov       [bx],ah
         mov       cx,1
P5:
         inc       bx
         mov       [bx],al
         dec       bx
         cmp       bx,4000
         ja        P6
         inc       bx
         inc       bx
         jmp       P2
P6:
         sub       cx,1
         jz        P1
         xor       bx,bx
         xor       dx,dx
         mov       ah,2
         int       10h

         mov       ah,4Ch
         mov       al,0
         int       21h

start    ENDP

         end       start
