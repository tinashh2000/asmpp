
; --------------------------------------------------------------------------
; CLICKS.ASM - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.model tiny
.code

start    proc
         mov     cx,40       ; numero de clicks
clicks:
         push    cx
         mov     dx,320      ; pitch
         mov     bx,256      ; duracao
         in      al,61h
         and     al,252      ; 11111100b
click:
         xor     al,2
         out     61h,al
         add     dx,37448
         mov     cl,3
         ror     dx,cl
         mov     cx,dx
         and     cx,511
         or      cx,10
click_pause:
         loop    click_pause ; espera
         dec     bx
         jnz     click
         and     al,252      ; 11111100b
         out     61h,al
         mov     bx,2        ; delay clicks
         xor     ah,ah
         int     1Ah
         add     bx,dx
click_delay:
         int     1Ah
         cmp     dx,bx
         jne     click_delay
         pop     cx
         loop    clicks
         mov     ax,4C00h
         int     21h
start endp

end start
