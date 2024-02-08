
; --------------------------------------------------------------------------
; MODO-X 320x400x256c - 12/2000 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.model tiny
.code
.386

org 100h

inicio   proc
         push      cs
         pop       ds
         mov       ax,0A000h
         mov       es,ax
         call      Set320x400
         mov       ah,2Ch
         int       21h
         lea       bx,Random
         mov       [bx],dx
         mov       si,256
         call      Randy
         mov       bp,ax
         call      circles
MainLoop:
         call      MakeRandomPalette
         lea       bx,PageNo
         mov       ax,[bx]
         cmp       ax,0
         je        SetPage1
         mov       ax,0A800h
         mov       es,ax
         mov       dx,3D4h
         mov       ax,0Ch
         out       dx,ax
         mov       [bx],0
         jmp       Start
SetPage1:
         mov       ax,0A000h
         mov       es,ax
         mov       dx,3D4h
         mov       ax,800Ch
         out       dx,ax
         lea       bx,PageNo
         mov       [bx],1
Start:
         call      Randy
         and       ax,0003h
         cmp       al,0
         je        Circ
         cmp       al,1
         je        Sqar
         cmp       al,2
         je        tiltcirc
         jmp       TiltSqar
Circ:
         call      Randy
         inc       ax
         mov       bp,ax
         call      circles
         jmp       CheckKey
Sqar:
         call      Randy
         inc       ax
         mov       bp,ax
         call      DoSquares
         jmp       CheckKey
TiltCirc:
         call      Randy
         inc       ax
         mov       bp,ax
         call      tcircles
         jmp       CheckKey
TiltSqar:
         call      Randy
         inc       ax
         mov       bp,ax
         call      DoTiltSquares
CheckKey:
         mov       ah,0Bh
         int       21h
         cmp       al,0
         jne       GetOut
         mov       dx,3dah   ;  Aguardo do Retraco
loop_4:                      ;
         in        al,dx     ;
         and       al,8      ;
         jnz       loop_4    ;
loop_5:                      ;
         in        al,dx     ;
         and       al,8      ;
         jz        loop_5    ;
         jmp       MainLoop
GetOut:
         mov       ax,3
         int       10h
         xor       ax,ax
         int       16h
         mov       ax,4C00h
         int       21h
PageNo   dw 1
inicio   endp

circles  proc
         mov       bl,00010001b 
         mov       di,0         

         mov       cx,0         ; For Y := 0 to 399 do
ForYCirc:
         push      cx
         mov       cx,0         ; For X := 0 to 319 do
ForXCirc:
         mov       ax,bp
         mul       cx
         add       si,ax
         mov       dx,3C4h
         mov       ah,bl
         mov       al,2
         out       dx,ax
         mov       ax,si
         mov       es:[di],al
         rol       bl,1         
         cmp       bl,00010001b 
         jne       DoNextXCirc  
         inc       di           
DoNextXCirc:
         inc       cx           ; Next X
         cmp       cx,320
         jl        ForXCirc
         pop       cx
         mov       ax,bp        
         mul       cx           
         add       si,ax        
         inc       cx           ; Next Y
         cmp       cx,400
         jl        ForYCirc
         ret
circles  endp

tcircles proc
         mov       bl,00010001b 
         mov       di,0         
         mov       cx,0         ; For Y := 0 to 399 do
ForYTiltCirc:
         push      cx
         mov       cx,0         ; For X := 0 to 319 do
ForXTiltCirc:
         mov       ax,bp        
         mul       cx           
         add       si,ax        
         mov       dx,3C4h      
         mov       ah,bl
         mov       al,2
         out       dx,ax
         mov       ax,si        
         mov       es:[di],al
         rol       bl,1         
         cmp       bl,00010001b 
         jne       DoNextXTiltCirc
         inc       di
DoNextXTiltCirc:
         inc       cx           ; Next X
         cmp       cx,320
         jl        ForXTiltCirc
         pop       cx
         mov       ax,bp
         mul       cx    
         sub       si,ax  
         inc       cx           ; Next Y
         cmp       cx,400
         jl        ForYTiltCirc
         ret
tcircles endp

DoSquares          proc
         mov       bl,00010001b 
         mov       di,0         
         mov       cx,0         ; For Y := 0 to 399 do
ForYSqr:
         push      si
         lea       si,CurrY
         mov       [si],cx
         pop       si
         push      cx
         mov       cx,0         ; For X := 0 to 319 do
ForXSqr:
         push      si
         lea       si,CurrX
         mov       [si],cx
         mov       ax,bp   
         lea       si,CurrY
         mov       dx,[si] 
         pop       si
         mul       dx
         add       si,ax 
         mov       dx,3C4h   
         mov       ah,bl
         mov       al,2
         out       dx,ax
         mov       ax,si 
         mov       es:[di],al
         rol       bl,1
         cmp       bl,00010001b 
         jne       DoNextXSqr   
         inc       di           
DoNextXSqr:
         inc       cx           ; Next X
         cmp       cx,320
         jl        ForXSqr
         pop       cx
         mov       ax,bp 
         push      si
         lea       si,CurrX
         mov       dx,[si] 
         pop       si
         mul       dx
         add       si,ax 
         inc       cx           ; Next Y
         cmp       cx,400
         jl        ForYSqr
         ret
CurrX    dw ?
CurrY    dw ?
DoSquares          endp

DoTiltSquares      proc
         mov       bl,00010001b
         mov       di,0
         mov       cx,0         ; For Y := 0 to 399 do
ForYTiltSqr:
         lea       bx,CurrTiltY
         mov       [bx],cx
         push      cx
         mov       cx,0         ; For X := 0 to 319 do
ForXTiltSqr:
         lea       bx,CurrTiltX
         mov       [bx],cx
         mov       ax,bp
         lea       bx,CurrTiltY
         mov       dx,[bx]
         mul       dx
         add       si,ax
         mov       dx,3C4h
         mov       ah,bl
         mov       al,2
         out       dx,ax
         mov       ax,si
         mov       es:[di],al
         rol       bl,1
         cmp       bl,00010001b
         jne       DoNextXTiltSqr
         inc       di
DoNextXTiltSqr:
         inc       cx           ; Next X
         cmp       cx,320
         jl        ForXTiltSqr
         pop       cx
         mov       ax,bp
         lea       bx,CurrTiltX
         mov       dx,[bx]
         mul       dx
         add       si,ax
         inc       cx           ; Next Y
         cmp       cx,400
         jl        ForYTiltSqr
         ret
CurrTiltX dw ?
CurrTiltY dw ?
DoTiltSquares      endp

Randy    proc                   ; Retorna um inteiro aleatorio em AX
GetTime:
         mov       ah,2Ch
         int       21h
         lea       bx,Random
         mov       ax,[bx]
         add       ax,13
         mul       dx
         add       dx,23
         mul       dx
         shr       dx,3
         add       ax,dx
         and       ax,7FFFh
         mov       [bx],ax
         ret
Random   dw ?
Randy    endp

MakeRandomPalette  proc
         call      Randy
         lea       bx,vermelho
         mov       [bx],al
         call      Randy
         lea       bx,verde
         mov       [bx],al
         call      Randy
         lea       bx,azul
         mov       [bx],al
         mov       cx,0
NextPal:
         mov       al,cl
         mov       dx,03C8h
         out       dx,al
         inc       dx

         lea       bx,vermelho
         mov       al,[bx]      
         and       al,3Fh
         out       dx,al
         lea       bx,verde
         mov       al,[bx]     
         and       al,3Fh
         out       dx,al
         lea       bx,azul
         mov       al,[bx]      
         and       al,3Fh
         out       dx,al

         lea       bx,vermelho
         mov       al,[bx]
         inc       al
         mov       [bx],al
         lea       bx,verde
         mov       al,[bx]
         inc       al
         mov       [bx],al
         lea       bx,azul
         mov       al,[bx]
         inc       al
         mov       [bx],al

         inc       cx
         cmp       cx,256
         jl        NextPal
         ret
vermelho dw  ?
verde    dw  ?
azul     dw  ?
MakeRandomPalette  endp

Set320x400         proc
         mov       ax,13h
         int       10h
         mov       dx,3C4h
         mov       al,4
         out       dx,al
         inc       dx
         in        al,dx
         and       al,11110111b ; NOT 08h
         or        al,04h
         out       dx,al
         mov       dx,3CEh
         mov       al,5
         out       dx,al
         inc       dx
         in        al,dx
         and       al,11110101b ; NOT 10h
         out       dx,al
         dec       dx
         mov       al,6
         out       dx,al
         inc       dx
         in        al,dx
         and       al,11111101b ; NOT 02h
         out       dx,al
         mov       dx,3C4h
         mov       ax,0F02h  ; (0Fh shl 8) + 2
         out       dx,ax
         mov       ax,0A000h
         mov       es,ax
         sub       di,di
         mov       ax,di
         mov       cx,8000h
         rep       stosw
         mov       dx,3D4h
         mov       al,9
         out       dx,al
         inc       dx
         in        al,dx
         and       al,11100000b ; NOT 1Fh
         out       dx,al
         dec       dx
         mov       al,14h
         out       dx,al
         inc       dx
         in        al,dx
         and       al,10111111b ; NOT 40h
         out       dx,al
         dec       dx
         mov       al,17h
         out       dx,al
         inc       dx
         in        al,dx
         or        al,40h
         out       dx,al
         ret
Set320x400         endp

         end       inicio
