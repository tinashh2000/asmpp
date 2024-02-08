
; --------------------------------------------------------------------------
; ALOMUNDO.ASM - Set/2000 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov       ax,3        ;
         int       10h         ; limpa a tela

         mov       ax,1301h    ;
         mov       bh,0        ;
         mov       bl,11       ; atributo da cor
         mov       dh,0        ; linha
         mov       dl,0        ; coluna
         mov       cx,12       ; cx = tamanho da mensagem em caracteres
         lea       bp,MENSAGEM ;
         int       10h         ; Exibe a mensagem

         int       20h         ; Termino do programa

MENSAGEM db        'Alo Mundo!',13,10

; --------------------------------------------------------------------------
