
; --------------------------------------------------------------------------
; FATORIAL.ASM - 10/1999 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov   cx,8          ; valor para obter o fatorial (0..8)
         push  cx
         mov   ax,cx
         call  @escvalor
         pop   cx

         mov   dl,33
         call  @escletra     ; '!'

         mov   dl,61
         call  @escletra     ; '='

         call  @fatorial
         call  @escvalor

         int   20h

; --------------------------------------------------------------------------
; Fatorial => CX!=AX
; --------------------------------------------------------------------------
@fatorial:
         mov   ax,1
         jcxz  @@fatozero1
@@novamente:
         imul  cx
         loop  @@novamente
@@fatozero1:
         ret

; --------------------------------------------------------------------------
; Escreve valor AX-word/AL-byte (depende de @escletra)
; call  @escvalor
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
