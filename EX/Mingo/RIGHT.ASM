
; --------------------------------------------------------------------------
; RIGHT.ASM - 05/1998 - Mingo Assembler
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
         mov       cx,80

marca1:
         mov       bx,156
marca2:
         mov       di,0
marca3:
         add       bx,di
         mov       ax,[bx]
         add       bx,2
         mov       [bx],ax
         sub       bx,di
         sub       bx,2
         add       di,160
         cmp       di,3840
         jb        marca3
         dec       bx
         dec       bx
         cmp       bx,-2
         jnz       marca2
         mov       ax,1824
         mov       bx,0
marca4:
         mov       [bx],ax
         add       bx,160
         cmp       bx,3840
         jb        marca4
         loop      marca1
         xor       bx,bx
         xor       dx,dx
         mov       ah,2
         int       10h

         mov       ah,4Ch
         int       21h

start    ENDP

         end       start
