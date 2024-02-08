
; --------------------------------------------------------------------------
; TEXTO.ASM - Apresentando Textos - 05/1998 - Mingo Assembler
; Eduardo Motta BÅhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

         mov       ax,3
         int       10h

         mov       dx,OFFSET texto
         mov       ah,9
         int       21h

         int       20h

texto    db 0Dh,0Ah
         db 'Tabela dos Modos de Video Padrao IBM-PC',0Dh,0Ah
         db 0Dh,0Ah
         db ' Modo Tipo    Resolucao Cores Endereco',0Dh,0Ah
         db ' ---- ------- --------- ----- --------',0Dh,0Ah
         db '  00   Texto    40x25     16    B800',0Dh,0Ah
         db '  01   Texto    40x25     16    B800',0Dh,0Ah
         db '  02   Texto    80x25     16    B800',0Dh,0Ah
         db '  03   Texto    80x25     16    B800',0Dh,0Ah
         db '  04  Grafico  320x200    4     B800',0Dh,0Ah
         db '  05  Grafico  320x200    4     B800',0Dh,0Ah
         db '  06  Grafico  640x200    2     B800',0Dh,0Ah
         db '  07   Texto    80x25     2     B000',0Dh,0Ah
         db '  0D  Grafico  320x200    16    A000',0Dh,0Ah
         db '  0E  Grafico  640x200    16    A000',0Dh,0Ah
         db '  0F  Grafico  640x350    2     A000',0Dh,0Ah
         db '  10  Grafico  640x350   4/16   A000',0Dh,0Ah
         db '  11  Grafico  640x480    2     A000',0Dh,0Ah
         db '  12  Grafico  640x480    16    A000',0Dh,0Ah
         db '  13  Grafico  320x200   256    A000',0Dh,0Ah
         db '$'
