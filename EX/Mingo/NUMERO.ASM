
; --------------------------------------------------------------------------
; NUMERO.ASM - 06/1999 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
; Exibe o NUMERO colocado em AX, tanto em DECIMAL como em HEXADECIMAL
; --------------------------------------------------------------------------

         mov   ax,1234

         push  ax
         call  @escvalor     ; valor em DECIMAL

         mov   dl,64h
         call  @escletra     ; 'd'

         mov   dl,0dh
         call  @escletra

         mov   dl,0ah
         call  @escletra

         pop   ax
         call  @numhexa      ; valor em HEXADECIMAL

         mov   dl,68h
         call  @escletra     ; 'h'

         int   20h

; --------------------------------------------------------------------------
; Escreve valor AX-word (HEXADECIMAL)
; --------------------------------------------------------------------------
@numhexa:
         mov   cx,4
@@digi_hex:
         rol   ax,1
         rol   ax,1
         rol   ax,1
         rol   ax,1
         push  ax
         and   al,0fh
         add   al,30h        ; '0'
         cmp   al,39h        ; '9'
         jbe   @@hex_ok
         add   al,7          ;'A'-'9'-1
@@hex_ok:
         mov   dl,al
         call  @escletra
         pop   ax
         loop  @@digi_hex
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
