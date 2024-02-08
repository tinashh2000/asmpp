
; --------------------------------------------------------------------------
; ONDA3D.ASM - 01/Jan/2001 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.model tiny
.386
;.code

inicio   proc
         push      0a000h
         pop       es
         push      cs
         pop       ds
         mov       ax,13h
         int       10h

         mov       ax,0      ;  FOR U
         lea       si,U      ;
         mov       [si],ax   ;
         push      ax        ;
         mov       ax,50     ;
         pop       cx        ;
         xchg      cx,ax     ;
         sub       cx,ax     ;
         jge       U1        ;
         jmp       U3        ;
U1:                          ;
         inc       cx        ;
U2:                          ;
         push      cx        ;

         mov       ax,0      ; FOR X
         lea       si,X      ;
         mov       [si],ax   ;
         push      ax        ;
         mov       ax,50     ;
         pop       cx        ;
         xchg      cx,ax     ;
         sub       cx,ax     ;
         jge       X1        ;
         jmp       X3        ;
X1:                          ;
         inc       cx        ;
X2:                          ;
         push      cx        ;

         lea       si,X
         mov       ax,[si]
         sub       ax,25
         mov       bx,ax
         imul      bx
         push      ax
         lea       si,U
         mov       ax,[si]
         sub       ax,25
         mov       bx,ax
         imul      bx
         pop       bx
         add       ax,bx
         shr       ax,3
         mov       dx,0
         mov       bx,255
         idiv      bx
         mov       bx,dx
         lea       si,stab
         mov       al,[bx+si]
         mov       ah,0
         lea       si,Y
         mov       [si],ax

         mov       ax,5
         lea       si,X
         mov       bx,[si]
         imul      bx
         add       ax,5
         lea       si,U
         add       ax,[si]
         push      ax
         mov       ax,2
         lea       si,U
         mov       bx,[si]
         imul      bx
         lea       si,Y
         add       ax,[si]
         mov       dx,ax
         pop       bx
         call      ponto

         pop       cx        ; NEXT X
         dec       cx        ;
         jz        X3        ;
         lea       si,X      ;
         mov       ax,[si]   ;
         inc       ax        ;
         mov       [si],ax   ;
         jmp       X2        ;
X3:                          ;

         pop       cx        ; NEXT U
         dec       cx        ;
         jz        U3        ;
         lea       si,U      ;
         mov       ax,[si]   ;
         inc       ax        ;
         mov       [si],ax   ;
         jmp       U2        ;
U3:                          ;

         xor       ax,ax
         int       16h
         mov       ax,3
         int       10h
         mov       ax,4c00h
         int       21h
inicio   endp

ponto    proc
         mov       ax,320
         imul      dx
         add       bx,ax
         mov       al,15     ; cor
         mov       es:[bx],al
         ret
ponto    endp

U        dw 0
X        dw 0
Y        dw 0

; tabela do seno    => round(sin(x*6*pi/255)*12)+50
stab     db 50,51,52,53,53,54,55,56,57,57,58,59,59,60,60,61,61,61,62,62,62
         db 62,62,62,62,62,61,61,61,60,60,59,58,58,57,56,56,55,54,53,52,51
         db 50,50,49,48,47,46,45,44,44,43,42,42,41,40,40,39,39,39,38,38,38
         db 38,38,38,38,38,39,39,39,40,40,41,41,42,43,43,44,45,46,47,47,48
         db 49,50,51,52,53,53,54,55,56,57,57,58,59,59,60,60,61,61,61,62,62
         db 62,62,62,62,62,62,61,61,61,60,60,59,58,58,57,56,56,55,54,53,52
         db 51,50,50,49,48,47,46,45,44,44,43,42,42,41,40,40,39,39,39,38,38
         db 38,38,38,38,38,38,39,39,39,40,40,41,41,42,43,43,44,45,46,47,47
         db 48,49,50,51,52,53,53,54,55,56,57,57,58,59,59,60,60,61,61,61,62
         db 62,62,62,62,62,62,62,61,61,61,60,60,59,58,58,57,56,56,55,54,53
         db 52,51,50,50,49,48,47,46,45,44,44,43,42,42,41,40,40,39,39,39,38
         db 38,38,38,38,38,38,38,39,39,39,40,40,41,41,42,43,43,44,45,46,47
         db 47,48,49,50

         end       inicio
