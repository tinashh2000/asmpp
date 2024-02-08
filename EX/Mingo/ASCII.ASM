
; --------------------------------------------------------------------------
; ASCII.ASM - 06/1999 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
; Tabela ASCII na tela
; --------------------------------------------------------------------------
         mov   ax,3
         int   10h           ; limpa a tela

         mov   ax,0b800h
         mov   ds,ax
         mov   ax,0f00h
         mov   dx,280h
novamente:
         mov   cx,14h
coluna:
         mov   bx,0h
         add   bx,cx
         add   bx,dx

         push  bx
         inc   bx
         mov   [bx],ah
         pop   bx

         mov   [bx],al
         inc   al
         cmp   al,0ffh
         jnb   saida
         add   cx,4
         cmp   cx,148
         jnz   coluna
         add   dx,320
         jmp   novamente

saida:
         int   20h

; --------------------------------------------------------------------------
