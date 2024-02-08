
; --------------------------------------------------------------------------
; ILC.ASM - Interpreta a linha de comandos - 03/2000 - Mingo Assembler
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------
; Apos compilado, ao digitar na linha de comandos "ilc teste", o retorno
; sera a exibicao da STRING "teste".
; --------------------------------------------------------------------------

         lea   di,STRING

         mov   si,80h    ; Endereco fundamental da STRING do parametro
         mov   cx,[si]   ; Tamanho total da STRING do parametro
         mov   ch,0
         inc   si        ; Pulando o BYTE de tamanho
         inc   si        ; Pulando o espaco que separa o comando do parametro
         rep   movsb     ; Move a STRING para ES:[DI]
         mov   al,0      ;
         stosb           ; Converte em ASCIIZ
         lea   bx,STRING ; Coloca em BX o endereco da STRING
         call  EXIBASCZ  ; Exibe STRING ASCIIZ
         int   20h       ; Retorna ao DOS

EXIBASCZ PROC
MAISUM:
         mov   al,[bx]
         cmp   al,0      ; Verifica se AL possui o valor 0
         jz    FIM       ; Salta para FIM se AL for 0
         push  bx
         call  IMPRIME
         pop   bx
         inc   bx        ; Incrementa BX
         jmp   MAISUM
FIM:
         ret             ; Retorna
EXIBASCZ ENDP

IMPRIME  PROC
         mov   ah,14     ;
         mov   bl,7      ;
         mov   bh,0      ;
         int   10h       ; Exibe o caractere indicado em AL
         ret             ; Retorna
IMPRIME  ENDP

STRING   db    256 dup (?)

; --------------------------------------------------------------------------
