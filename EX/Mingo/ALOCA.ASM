
; --------------------------------------------------------------------------
; ALOCA.ASM - 03/2000 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
; Exemplo da alocacao de memoria, exibe em hexadecimal o SEGMENTO alocado,
; havendo algum erro na alocacao, o programa termina sem exibir nada.
; --------------------------------------------------------------------------

         mov   ah,4Ah       ; Funcao (Inicialmente ES aponta o bloco)
         mov   bx,128       ; Numero de paragrafos
         int   21h          ; ### Redimensionamento da memoria ###
         jc    erro         ; Se ocorrer um erro

         mov   ah,48h       ; Funcao
         mov   bx,64        ; Numero de paragrafos
         int   21h          ; ### Aloca a memoria ###
         jc    erro         ; Se ocorrer um erro
         push  ax           ; Armazena o segmento

         call  @numhexa     ; Exibe o segmento em hexadecimal

         mov   dl,68h
         call  @escletra    ; Exibe 'h'

         pop   ax           ; recupera o segmento
         mov   es,ax        ; coloca o segmento em ES
         mov   ah,49h       ; Funcao
         int   21h          ; ### Desaloca a memoria ###

erro:
         int   20h          ; Termino do programa

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
         add   al,7          ; 'A'-'9'-1
@@hex_ok:
         mov   dl,al
         call  @escletra
         pop ax
         loop @@digi_hex
         ret
; --------------------------------------------------------------------------
@escletra:
         mov   ah,2
         int   21h
         ret
; --------------------------------------------------------------------------
