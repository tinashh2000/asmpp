
; --------------------------------------------------------------------------
; BOLA.ASM - Dec-27-2000 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

inicio:
         mov       ax,10h
         int       10h

loop_principal:
         call      desenha_bola
         call      aguarda_retraco
         call      apaga_bola

         lea       bx,sentY
         lea       di,posY
         mov       dl,[bx]
         cmp       dl,1
         jne       retornoY
         mov       dl,[di]
         cmp       dl,79
         jge       p1Y
         inc       dl
         mov       [di],dl
         jmp       prossegueY
p1Y:
         mov       [bx],0
retornoY:
         mov       dl,[di]
         cmp       dl,0
         jle       p2Y
         dec       dl
         mov       [di],dl
         jmp       prossegueY
p2Y:
         mov       [bx],1
prossegueY:

         lea       bx,sentX
         lea       di,posX
         mov       dl,[bx]
         cmp       dl,1
         jne       retornoX
         mov       dl,[di]
         cmp       dl,24
         jge       p1X
         inc       dl
         mov       [di],dl
         jmp       prossegueX
p1X:
         mov       [bx],0
retornoX:
         mov       dl,[di]
         cmp       dl,0
         jle       p2X
         dec       dl
         mov       [di],dl
         jmp       prossegueX
p2X:
         mov       [bx],1
prossegueX:

         mov       ah,1
         int       16h
         jz        loop_principal

         xor       ax,ax
         int       16h

         mov       ax,3
         int       10h

         int       20h

desenha_bola:
         mov       ah,2
         mov       bh,0
         lea       di,posX
         mov       dh,[di] ; linha
         lea       di,posY
         mov       dl,[di] ; coluna
         int       10h
         mov       ax,096fh
         mov       bl,14
         mov       cx,1
         int       10h
         ret

apaga_bola:
         mov       ah,2
         mov       bh,0
         lea       di,posX
         mov       dh,[di] ; linha
         lea       di,posY
         mov       dl,[di] ; coluna
         int       10h
         mov       ax,0920h
         mov       bl,14
         mov       cx,1
         int       10h
         ret

aguarda_retraco:
         mov       dx,3dah
@@espe:
         in        al,dx
         and       al,8
         jnz       @@espe
@@retr:
         in        al,dx
         and       al,8
         jz        @@retr
         ret

posX     dw      1
posY     dw      1
sentX    dw      1
sentY    dw      1

         end     inicio
