
; --------------------------------------------------------------------------
; BUZINA.ASM - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.model tiny
;.code

start    proc
         mov       cx,30     ;tempo da buzina

novoclick:
         push      cx
         mov       dx,1024   ;espera inicial
         mov       bx,288
         in        al,61h
         and       al,252    ;11111100b

som:
         xor       al,2
         out       61h,al
         add       dx,64000
         mov       cl,1
         ror       dx,cl
         mov       cx,dx
         and       cx,511
         or        cx,16

espera:
         loop      espera

         dec       bx
         jnz       som
         and       al,252
         out       61,al
         mov       cx,64000

silencio:
         loop      silencio

         pop       cx
         loop      novoclick

         mov       ax,4C00h
         int       21h
start    endp

         end       start
