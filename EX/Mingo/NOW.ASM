
; --------------------------------------------------------------------------
; NOW (exibe a data e a hora do sistema) - 09/04/1999 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         lea       dx,Texto1
         mov       ah,9
         int       21h

         mov       ah,2ah
         int       21h

         push      cx
         push      dx

         mov       ah,0
         mov       al,dl
         call      EscreveValor  ; Dia

         mov       dl,2fh        ; /
         call      EscreveLetra

         pop       dx
         mov       ah,0
         mov       al,dh
         call      EscreveValor  ; Mes

         mov       dl,2fh        ; /
         call      EscreveLetra

         pop       ax
         call      EscreveValor  ; Ano

         lea       dx,Texto2
         mov       ah,9
         int       21h

         mov       ah,2ch
         int       21h

         push      dx
         push      cx

         mov       ah,0
         mov       al,ch
         call      EscreveValor  ; Hora

         mov       dl,68h        ; h
         call      EscreveLetra
         mov       dl,20h
         call      EscreveLetra

         pop       ax
         mov       ah,0
         call      EscreveValor  ; Min

         mov       dl,6dh        ; m
         call      EscreveLetra
         mov       dl,20h
         call      EscreveLetra

         pop       dx
         mov       al,dh
         mov       ah,0
         call      EscreveValor  ; Seg

         mov       dl,73h        ; s
         call      EscreveLetra

         int       20h           ; sai do programa

EscreveLetra:
         mov       ah,2
         int       21h
         ret

EscreveValor:
         push      ax
         mov       bx,10
         mov       cx,0
Divide:
         mov       dx,0
         div       bx
         push      dx
         inc       cx
         cmp       ax,0
         jne       Divide
Escreve:
         pop       ax
         add       al,48         ; 0
         mov       dl,al
         call      EscreveLetra
         loop      Escreve
         pop       dx
         ret

Texto1   db    'Data: $'
Texto2   db    0Dh,0Ah,'Hora: $'
