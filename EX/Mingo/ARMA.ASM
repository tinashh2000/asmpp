
; --------------------------------------------------------------------------
; ARMA.ASM - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.model tiny
.code

start PROC

         mov     cx,4       ; numero de tiros

         cli
arma:
         push    cx
         mov     dx,21000
         mov     bx,100
         mov     al,182     ; 10110110b
         out     43h,al
retorno:
         mov     ax,bx
         out     42h,al
         mov     al,ah
         out     42h,al
         in      al,61h
         mov     ah,0
         or      ax,3       ; 00000011b
         out     61h,al
         inc     bx

         mov     cx,15
repete:
         loop    repete

         dec     dx
         cmp     dx,0
         jnz     retorno
         in      al,61h
         and     al,252     ; 11111100b
         out     61h,al
         pop     cx
         loop    arma

         sti

         mov     ah, 4Ch
         mov     al, 0
         int     21h

start ENDP

end start
