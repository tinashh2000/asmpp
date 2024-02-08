
; --------------------------------------------------------------------------
; SBARS.ASM (Scroll Bars) - 12/2000 - Mingo Assembler
; -> Eduardo Motta Buhrnheim [mingo@programador.mailbr.com.br]
; -> Gustavo V. Vargas [gvargas@mailbr.com.br]
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; --------------------------------------------------------------------------

.model tiny
;.code
.386

org 100h

base     equ       3c8h
tela     equ       0a000h

; --------------------------------------------------------------------------
        JMP inicio

inicio   proc
         push      tela
         pop       es
         mov       ax,13h
         int       10h

         xor       di,di
         mov       cx,199
         xor       al,al
loop_1:
         push      cx
         mov       cx,320
         rep       stosb
         inc       al
         pop       cx
         loop      loop_1

         mov       al,0
         mov       cx,199
loop_2:
         call      colorset
         loop      loop_2
loop_3:
         lea       bx,master
         lea       ax,r
         mov       [bx],ax
         lea       bx,slave
         lea       ax,g
         mov       [bx],ax
         lea       bx,slave2
         lea       ax,b
         mov       [bx],ax

         lea       bx,r
         inc       bx
         mov       al,[bx]
         call      placebar

         lea       bx,master
         lea       ax,g
         mov       [bx],ax
         lea       bx,slave
         lea       ax,r
         mov       [bx],ax

         lea       bx,g
         inc       bx
         mov       al,[bx]
         call      placebar

         lea       bx,master
         lea       ax,b
         mov       [bx],ax
         lea       bx,slave2
         lea       ax,g
         mov       [bx],ax

         lea       bx,b
         inc       bx
         mov       al,[bx]
         call      placebar

         lea       bx,r
         inc       bx
         mov       al,[bx]
         mov       bl,1
         call      desloc

         lea       bx,r
         inc       bx
         mov       [bx],al

         lea       bx,g
         inc       bx
         mov       al,[bx]
         mov       bl,2
         call      desloc

         lea       bx,g
         inc       bx
         mov       [bx],al

         lea       bx,b
         inc       bx
         mov       al,[bx]
         mov       bl,4
         call      desloc

         lea       bx,b
         inc       bx
         mov       [bx],al
         push      ax

         mov       dx,3dah   ;
loop_4:                      ;
         in        al,dx     ;
         and       al,8      ;
         jnz       loop_4    ;
loop_5:                      ;
         in        al,dx     ;
         and       al,8      ;
         jz        loop_5    ;

         mov       ah,0bh
         int       21h
         or        al,al
         pop       ax
         jz        loop_3

         xor       ax,ax
         int       16h
         mov       ax,3
         int       10h

         int       20h
inicio   endp

; --------------------------------------------------------------------------

desloc   proc
         lea       di,flag
         test      [di],bl
         jnz       pr_d_ret_1
         inc       al
         cmp       al,160
         jnz       pr_d_ret_2
         or        [di],bl
         jmp       pr_d_ret_2
pr_d_ret_1:
         dec       al
         cmp       al,1
         jnz       pr_d_ret_2
         not       bx
         and       [di],bl
pr_d_ret_2:
         ret
desloc   endp

; --------------------------------------------------------------------------

placebar proc
         xor       ah,ah
         xor       bx,bx
         mov       cx,15
pr_pb_loop_1:
         call      colorset
         lea       di,master
         mov       bx,[di]
         add       word ptr [bx],4
         loop      pr_pb_loop_1
         mov       cx,5
pr_pb_loop_2:
         call      colorset
         lea       di,slave
         mov       bx,[di]
         add       word ptr [bx],12
         lea       di,slave2
         mov       bx,[di]
         add       word ptr [bx],12
         loop      pr_pb_loop_2
         mov       cx,5
pr_pb_loop_3:
         call      colorset
         lea       di,slave
         mov       bx,[di]
         sub       word ptr [bx],12
         lea       di,slave2
         mov       bx,[di]
         sub       word ptr [bx],12
         loop      pr_pb_loop_3
         mov       cx,15
pr_pb_loop_4:
         call      colorset
         lea       di,master
         mov       bx,[di]
         sub       word ptr [bx],4
         loop      pr_pb_loop_4
         ret
placebar endp

; --------------------------------------------------------------------------

colorset proc
         mov       dx,base
         out       dx,al
         inc       dx
         push      ax
         lea       bx,r
         mov       al,[bx]
         out       dx,al
         lea       bx,g
         mov       al,[bx]
         out       dx,al
         lea       bx,b
         mov       al,[bx]
         out       dx,al
         pop       ax
         inc       al
         ret
colorset endp

r        db        0, 1
g        db        0, 60
b        db        0, 120

master   dw        ?
slave    dw        ?
slave2   dw        ?

flag     db        0

         end       inicio
