
; --------------------------------------------------------------------------
; FOGO.ASM - Set/2000 - Mingo Assembler Pro
; -> Eduardo Motta Buhrnheim (a.k.a. Mingo)
; -> Gaffer/PRoMETHEUS (gaffer@ar.com.au)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.MODEL TINY
.386

;.CODE

         ORG       100h

.STARTUP
         push      0A000h
         pop       es

         mov       al,13h
         int       10h

         mov       al,63
         mov       cx,770  ;768+2
         mov       di,191  ;63*3+2
         push      di
         rep       stosb

         pop       di
         xor       ax,ax
         call      PaletteGen  ; Verde
         inc       ah
         call      PaletteGen
         xor       di,di
         call      PaletteGen  ; Vermelho
         inc       di
         call      PaletteGen  ; Azul

         mov       ax,1012h
         cwd
         mov       cl,255
         int       10h

MainLoop:
         inc       cx
         mov       di,OFFSET Buffer
         mov       bl,99
@@L1:
         add       di,639
         mov       al,[di]
         sub       di,639
         add       di,640
         mov       dl,[di]
         sub       di,640
         add       ax,dx
         add       di,641
         mov       dl,[di]
         sub       di,641
         add       ax,dx
         add       di,1280
         mov       dl,[di]
         sub       di,1280
         add       ax,dx
         shr       ax,2
         jz        @@ZERO
         dec       ax
@@ZERO:
         mov       [di],al
         add       di,1280
         mov       dl,[di]
         sub       di,1280
         add       ax,dx
         shr       ax,1
         add       di,320
         mov       [di],al
         sub       di,320
         inc       di
         loop      @@L1
         mov       cx,320
         add       di,cx
         dec       bx
         jnz       @@L1
@@L2:
         in        ax,40h

         push      cx
         push      bx
         lea       bx,semente
         mov       cx,[bx]
         add       ax,cx
         add       cx,ax
         mov       [bx],cx
         pop       bx
         pop       cx
         mov       ah,al
         mov       [di],ax
         add       di,2
         mov       [di],ax
         add       di,2
         loop      @@L2
         xor       ax,ax

         xor       di,di
         mov       si,OFFSET Buffer ;+ 320
         add       si,320
         mov       cx,15200 ;(320/4)*95*2
         rep       movsd

         push      ax
         mov       ah,1
         int       16h
         pop       ax
         jz        mainloop

         mov       ax,03h
         int       10h

;----------------------------------------------------------------------------
lbt:
         mov       ah,6
         mov       dl,0FFh
         int       21h
         jnz       lbt         ; limpa o Buffer do teclado
;----------------------------------------------------------------------------
         int       20h

PaletteGen:
         mov       cl,64
@@PL2:
         stosb
         add       al,ah
         inc       di
         inc       di
         loop      @@PL2
         ret

semente  dw 0
buffer   db 0

END
