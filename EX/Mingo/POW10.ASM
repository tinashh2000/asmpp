

; --------------------------------------------------------------------------
; POW10.ASM - 07/1999 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
; Este programa demonstra a atuacao do Mingo Assembler com o emprego de ins-
; trucoes do co-processador. Exibe em hexadecimais valores reais resultantes
; da elevacao de 10 aos expoentes que variam de 3 a 39, a intervalos de 3 em
; 3. Funcionando corretamente produz:
;
; 03H    447A0000H
; 06H    49742400H
; 09H    4E6E6B28H
; 0CH    5368D4A5H
; 0FH    58635FA9H
; 12H    5D5E0B6BH
; 15H    6258D727H
; 18H    6753C21CH
; 1BH    6C4ECB8FH
; 1EH    7149F2CAH
; 21H    76453719H
; 24H    7B4097CEH
; 27H    7F800000H
; --------------------------------------------------------------------------
.model tiny
.387
;.code
	org 100h
Start:
programa proc
         finit
         fild      [milhar]
         fld1
eleva_loop:
         fmul      st,st(1)
         fst       [elev_10]

         lea       si,elev
         lodsb
         add       al,3
         push      es
         push      ds
         pop       es
         lea       di,elev
         stosb
         pop       es

         lea       bx,eleva
         call      exibicao
         mov       cx,4
         lea       bx,result
         lea       si,elev_10
         add       si,3
         std
valor:
         lodsb
         call      exibicao
         loop      valor

         lea       dx,eleva
         mov       ah,9
         int       21h

         lea       si,elev
         lodsb
         cmp       al,38
         jb        eleva_loop

         fcompp
         int       20h
programa endp

exibicao proc
         push      ax
         push      cx
         mov       cl,4
         shr       al,cl
         pop       cx
         call      simbolo
         pop       ax
         call      simbolo
         ret
exibicao endp

tabasc   db    '0123456789ABCDEF'
simbolo  proc
         and       al,0fh
         push      bx
         lea       bx,tabasc
         xlat      [tabasc]
         pop       bx
         mov       [bx],al
         inc       bx
         ret
simbolo  endp

elev_10  dd    0
eleva    db    '  H    '
result   db    '        H',13,10,'$'
elev     db    0
milhar   dd    1000
ctrl_87  dd    03bfh
end Start
