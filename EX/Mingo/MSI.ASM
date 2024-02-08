
; --------------------------------------------------------------------------
; MINGO SYSTEM INFORMATION (Mingo Assembler) - 04/1999 - By Mingo
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
         mov   ax,3
         int   10h           ; limpa a tela
; --------------------------------------------------------------------------
         lea   dx,Titulo
         call  @escfrase
; --------------------------------------------------------------------------
         lea   dx,MensDOS
         call  @escfrase

         mov   ah,30h
         int   21h

         push  ax
         mov   ah,0
         call  @escvalor

         mov   dl,46
         call  @escletra

         pop   ax
         mov   al,ah
         mov   ah,0
         call  @escvalor
; --------------------------------------------------------------------------
         lea   dx,MensSer
         call  @escfrase

         int   11h
         and   ax,0E00h
         shr   ax,9

         call  @escvalor
; --------------------------------------------------------------------------
         lea   dx,MensPar
         call  @escfrase

         int   11h
         and   ax,0C000h
         shr   ax,14

         call  @escvalor
; --------------------------------------------------------------------------
         mov   dx,201h
         mov   al,1
         out   dx,al
         mov   cx,2
espera:
         loop  espera        ; aguarda um momento
         in    al,dx
         and   al,0fh
         cmp   al,0fh
jne no_game
         lea   dx,Mensgps
         call  @escfrase
         jmp   endgame
no_game:
         lea   dx,Mensgpn
         call  @escfrase
endgame:
; --------------------------------------------------------------------------
         lea   dx,MensBdt
         call  @escfrase

         push  ds
         mov   bx,1
         mov   ax,0F000h
         mov   ds,ax
         mov   dx,0FFF5h
         add   si,ax
         mov   cx,8
         mov   ah,40h
         int   21h
         pop   ds
; --------------------------------------------------------------------------
         lea   dx,MensPId
         call  @escfrase
         mov   ah,0C0h
         int   15h
         push  ds
         mov   ax,es
         mov   ds,ax
         add   bx,2
         mov   si,bx
         lodsb
         mov   ah,0
         call  @escvalor
         pop   ds
; --------------------------------------------------------------------------
         lea   dx,MensPsm
         call  @escfrase
         mov   ah,0C0h
         int   15h
         push  ds
         mov   ax,es
         mov   ds,ax
         add   bx,3
         mov   si,bx
         lodsb
         mov   ah,0
         call  @escvalor
         pop   ds
; --------------------------------------------------------------------------
         lea   dx,MensPbr
         call  @escfrase
         mov   ah,0C0h
         int   15h
         push  ds
         mov   ax,es
         mov   ds,ax
         add   bx,4
         mov   si,bx
         lodsb
         mov   ah,0
         call  @escvalor
         pop   ds
; --------------------------------------------------------------------------
         lea   dx,Linha
         call  @escfrase
; --------------------------------------------------------------------------
         int   20h           ; sai do programa
; --------------------------------------------------------------------------
; Procedures:
; --------------------------------------------------------------------------
@escfrase:
         mov   ah,9
         int   21h
         ret
; --------------------------------------------------------------------------
@escletra:
         mov   ah,2
         int   21h
         ret
; --------------------------------------------------------------------------
@escvalor:
         push  ax
         mov   bx,10
         mov   cx,0
@@divide:
         mov   dx,0
         div   bx
         push  dx
         inc   cx
         cmp   ax,0
         jne   @@divide
@@escreve:
         pop   ax
         add   al,48
         mov   dl,al
         call  @escletra
         loop  @@escreve
         pop   dx
         ret
; --------------------------------------------------------------------------
; Dados
; --------------------------------------------------------------------------
Titulo   DB    'Mingo System Information (Mingo Assembler) - 04/1999',0Dh,0Ah
         DB    'http://mingus.cjb.net/ - http://mahome.mingus.cjb.net/',0Dh,0Ah
         DB    'mingo@programador.mailbr.com.br',0Dh,0Ah,0Dh,0Ah,24h

Linha    DB    0Dh,0Ah,24h

MensDOS  DB    'Operating System: DOS Version $'
MensSer  DB    0Dh,0Ah,'Serial Ports: $'
MensPar  DB    0Dh,0Ah,'Parallel Ports: $'
Mensgps  DB    0Dh,0Ah,'Game Port: Installed$'
Mensgpn  DB    0Dh,0Ah,'Game Port: Not Installed$'
MensBdt  DB    0Dh,0Ah,'B.I.O.S. Date: $'
MensPId  DB    0Dh,0Ah,'Computer Identification:'
MensPmd  DB    0Dh,0Ah,'- Model: $'
MensPsm  DB    0Dh,0Ah,'- Submodel: $'
MensPbr  DB    0Dh,0Ah,'- B.I.O.S. Revision: $'
