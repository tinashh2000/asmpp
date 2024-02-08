
;----------------------------------------------------------------------------
; FORADOAR.ASM - 28/05/2000 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.386
.org 100h

foradoar proc
         push    0a000h
         pop     es          ; inicializa ES
         push    es
         pop     ds          ; inicializa DS

         mov     al,13h          
         int     10h         ; modo grafico (320x200x256c)

         mov     dx,3c8h
         cbw               
         out     dx,al
         inc     dx
looppal:
         out     dx,al
         out     dx,al
         out     dx,al
         inc     ax
         jnz     looppal     ; Escala de cinza na palette

loopprincipal:
         mov     si,32001
         mov     cx,0
         push    si
         push    cx
         pop     di
         pop     cx

aleatorio:
         push    bx
         mov     bx,di
         inc     bx
         mov     dx,[bx]
         mul     dx
         mov     [bx],dx
         pop     bx
         inc     ax
         stosw
         loop    aleatorio

         mov     ah,1
         int     16h
         jz      loopprincipal

lbt:
         mov     ah,6
         mov     dl,0FFh
         int     21h
         jnz     lbt         ; limpa o Buffer do teclado

         mov     ax,3
         int     10h         ; modo texto

         int     20h         ; fim do programa
foradoar endp

         end     foradoar
