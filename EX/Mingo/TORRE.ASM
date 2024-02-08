
;========================================================;
;                                                        ;
; TORRE DE HANOI - Em Mingo Assembler! - Maio/2000       ;
;                                                        ;
; Feito por Eduardo Motta Buhrnheim (a.k.a. Mingo)       ;
;                                                        ;
; Baseado num programa feito por Christian Lykawka       ;
;                                Carlos Eduardo Anselmi  ;
;                                                        ;
;========================================================;
; http://mingus.cjb.net/                                 ;
; http://mahome.mingus.cjb.net/                          ;
; mingo@programador.mailbr.com.br                        ;
;========================================================;

;.model tiny
;.code

;--------------------------------------------------------
; programa principal

INICIO   proc
LP0:
         call    LIMPATEL
         call    PARTIDA
         call    ZERA
         call    LIMPATEL
         call    MONTA
         call    QUANTOS
         cmp     al,0
         je      LP4
         cmp     al,2
         je      LP2
LP5:
         call    LIMPATEL
         call    MONTA
LP1:
         call    MOVE
LP7:
         mov     bl,3
         call    STATUS
         lea     di,NR
         mov     bl,[di]
         cmp     cl,bl
         je      FIM
         cmp     al,1
         je      LP1
LP2:
         mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     cl,al
         mov     dx, offset MSG5
         mov     ah,9
         int     21h
LP3:
         mov     ah,0
         int     16h
         cmp     cl,2
         je      LP6
         cmp     al,27
         je      LP5
LP6:
         cmp     al,'N'
         je      LP0
         cmp     al,'n'
         je      LP0
         cmp     al,'S'
         je      LP4
         cmp     al,'s'
         je      LP4
         cmp     al,'L'
         je      LER
         cmp     al,'l'
         je      LER
         cmp     al,'G'
         je      GRAVAR
         cmp     al,'g'
         je      GRAVAR
         jmp     LP3
LP4:
         call    TEXT
         call    EXIT
FIM:
         mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     dx, offset MSG4
         mov     ah,9
         int     21h
         call    ESPERA
         mov     al,2
         jmp     LP2
LER:
         call    LEARQ
         jmp     LP8
GRAVAR:
         call    GRAVARQ
LP8:
         call    LIMPATEL
         call    MONTA
         mov     al,1
         jmp     LP7
INICIO   endp

;--------------------------------------------------------
; muda a cor dos caracteres (bl=cor)
COR      proc
         push    ax
         push    bx
         lea     di,CA
         mov     al,[di]
         cmp     al,bl
         je      CFIM
         lea     di,CA
         mov     [di],bl
         mov     ah,0bh
         mov     bh,1
         int     10h
CFIM:
         pop     bx
         pop     ax
         ret
COR      endp

;--------------------------------------------------------
; zera variaveis
ZERA     proc
         mov     di, offset T1
         mov     cx,30
ZLOOP:
         mov     al,0
         mov     [di],al
         inc     di
         loop    ZLOOP
         lea     di,NR
         mov     [di],cl
         lea     di,NJ0
         mov     [di],cl
         lea     di,NJ1
         mov     [di],cl
         lea     di,NJ2
         mov     [di],cl
         lea     di,NJ3
         mov     [di],cl
         ret
ZERA     endp

;--------------------------------------------------------
; limpa a tela reiniciando o modo grafico
LIMPATEL proc
         mov     ah,0
         mov     al,12h
         int     10h
         ret
LIMPATEL endp

;--------------------------------------------------------
; inicia modo texto
TEXT     proc
         mov     ah,0
         mov     al,3h
         int     10h
         ret
TEXT     endp

;--------------------------------------------------------
; posiciona o cursor (dh=linha & dl=coluna)
POSCUR   proc
         push    ax
         push    bx
         mov     ah,2
         xor     bh,bh
         int     10h
         pop     bx
         pop     ax
         ret
POSCUR   endp

;--------------------------------------------------------
; rotina de espera de uma tecla
ESPERA   proc
         mov     ah,07
         int     21h
         ret
ESPERA   endp

;--------------------------------------------------------
; prepara apontadores
PARTIDA  proc
         mov     ax,cs
         mov     ds,ax
         mov     es,ax
         mov     ax, offset T1
         dec     ax
         lea     di,P1
         mov     [di],ax
         mov     ax, offset T2
         dec     ax
         lea     di,P2
         mov     [di],ax
         mov     ax, offset T3
         dec     ax
         lea     di,P3
         mov     [di],ax
         ret
PARTIDA  endp

;--------------------------------------------------------
; rotina de saida do programa
EXIT     proc
         mov     dx, offset MSG6
         mov     ah,9
         int     21h
         mov     ax,4c00h
         int     21h
EXIT     endp

;--------------------------------------------------------
; grava o arquivo de um jogo
GRAVARQ  proc
         push    ax
         push    bx
         push    cx
         push    dx
         mov     ah,03ch
         mov     cx,0
         mov     dx, offset NOMEARQ
         int     21h
         jc      GERRO
         push    ax
         mov     bx,ax
         mov     ah,040h
         mov     cx,43
         mov     dx, offset BLDADOS
         int     21h
         mov     ah,03eh
         pop     bx
         int     21h
GERRO:   pop     dx
         pop     cx
         pop     bx
         pop     ax
         ret
GRAVARQ  endp

;--------------------------------------------------------
; le o arquivo de um jogo
LEARQ    proc
         push    ax
         push    bx
         push    cx
         push    dx
         mov     ah,03dh
         mov     al,2
         mov     dx, offset NOMEARQ
         int     21h
         jc      LERRO
         push    ax
         mov     bx,ax
         mov     ah,03fh
         mov     cx,43
         mov     dx, offset BLDADOS
         int     21h
         mov     ah,03eh
         pop     bx
         int     21h
LERRO:   pop     dx
         pop     cx
         pop     bx
         pop     ax
         ret
LEARQ    endp

;--------------------------------------------------------
; poe o dado (bh) na pilha da torre (bl=1,2 ou 3)
POE      proc
         push    ax
         cmp     bl,1
         je      PP1
         cmp     bl,2
         je      PP2
         lea     di,P3
         mov     ax,[di]
         inc     ax
         mov     [di],ax
         mov     di,ax
         mov     [di],bh
         pop     ax
         ret
PP2:
         lea     di,P2
         mov     ax,[di]
         inc     ax
         lea     di,P2
         mov     [di],ax
         mov     di,ax
         mov     [di],bh
         pop     ax
         ret
PP1:
         lea     di,P1
         mov     ax,[di]
         inc     ax
         mov     [di],ax
         mov     di,ax
         mov     [di],bh
         pop     ax
         ret
POE      endp

;--------------------------------------------------------
; tira o dado (bh) da pilha da torre (bl=1,2 ou 3)
TIRA     proc
         push    ax
         cmp     bl,1
         je      TP1
         cmp     bl,2
         je      TP2
         lea     di,P3
         mov     ax,[di]
         mov     si,ax
         mov     bh,[si]
         mov     di,ax
         push    dx
         mov     dl,0
         mov     [di],dl
         pop     dx
         dec     ax
         lea     di,P3
         mov     [di],ax
         pop     ax
         ret
TP2:
         lea     di,P2
         mov     ax,[di]
         mov     si,ax
         mov     bh,[si]
         mov     di,ax
         push    dx
         mov     dl,0
         mov     [di],dl
         pop     dx
         dec     ax
         lea     di,P2
         mov     [di],ax
         pop     ax
         ret
TP1:
         lea     di,P1
         mov     ax,[di]
         mov     si,ax
         mov     bh,[si]
         mov     di,ax
         push    dx
         mov     dl,0
         mov     [di],dl
         pop     dx
         dec     ax
         lea     di,P1
         mov     [di],ax
         pop     ax
         ret
TIRA     endp

;--------------------------------------------------------
; pergunta a quantidade de roscas e inicia a torre 1
; (retorna al=0 para F3, al=2 para ESC, senao al=1)
QUANTOS  proc
         mov     dh,23
         mov     dl,18
         call    POSCUR
         mov     ah,9
         mov     dx, offset MSG1
         int     21h
HMLp1:   mov     ah,0
         int     16h
         cmp     al,0
         je      HMESP
         cmp     al,27
         je      HMOPC
         cmp     al,'3'
         jb      HMLp1
         cmp     al,'9'
         ja      HMLp1
         sub     al,'0'
         lea     di,NR
         mov     [di],al
         mov     ah,0
         mov     cx,ax
         mov     bl,1
         mov     bh,al
HMLp2:   call    POE
         dec     bh
         loop    HMLp2
         mov     al,1
         ret
HMESP:   cmp     ah,03dh ;=F3
         je      HMFIM
         jmp     HMLp1
HMFIM:   mov     al,0
         ret
HMOPC:   mov     al,2
         ret
QUANTOS  endp

;--------------------------------------------------------
; retorna em (bh) o topo da torre(bl=1,2 ou 3) e em (cl) o numero de elementos
STATUS   proc
         push    ax
         cmp     bl,1
         je      SP1
         cmp     bl,2
         je      SP2
         lea     di,P3
         mov     si,[di]
         mov     bh,[si]
         mov     ax, offset T3
         sub     si,ax
         inc     si
         mov     cx,si
         pop     ax
         ret
SP2:
         lea     di,P2
         mov     si,[di]
         mov     bh,[si]
         mov     ax, offset T2
         sub     si,ax
         inc     si
         mov     cx,si
         pop     ax
         ret
SP1:
         lea     di,P1
         mov     si,[di]
         mov     bh,[si]
         mov     ax, offset T1
         sub     si,ax
         inc     si
         mov     cx,si
         pop     ax
         ret
STATUS   endp

;--------------------------------------------------------
; incrementa o numero de jogadas
INCNJ    proc
         lea     di,NJ0
         mov     al,[di]
         cmp     al,9
         je      LNJ0
         inc     al
         lea     di,NJ0
         mov     [di],al
         ret
LNJ0:    mov     al,0
         lea     di,NJ0
         mov     [di],al
         lea     di,NJ1
         mov     al,[di]
         cmp     al,9
         je      LNJ1
         inc     al
         lea     di,NJ1
         mov     [di],al
         ret
LNJ1:    mov     al,0
         lea     di,NJ1
         mov     [di],al
         lea     di,NJ2
         mov     al,[di]
         cmp     al,9
         je      LNJ2
         inc     al
         lea     di,NJ2
         mov     [di],al
         ret
LNJ2:    mov     al,0
         lea     di,NJ2
         mov     [di],al
         lea     di,NJ3
         mov     al,[di]
         cmp     al,9
         je      LNJ3
         inc     al
         lea     di,NJ3
         mov     [di],al
         ret
LNJ3:    mov     al,0
         lea     di,NJ3
         mov     [di],al
         ret
INCNJ    endp

;--------------------------------------------------------
; monta a tela do jogo
MONTA    proc
         mov     bl,9
         call    COR
         mov     dh,1
         mov     dl,13
         call    POSCUR
         mov     ah,9
         mov     dx, offset TITULO
         int     21h
         mov     dh,4
         mov     dl,30
         call    POSCUR
         mov     ah,9
         mov     dx, offset NUMERO
         int     21h
         mov     dh,26
         mov     dl,33
         call    POSCUR
         mov     ah,9
         mov     dx, offset ESCFIM
         int     21h
         mov     dh,4
         mov     dl,48
         call    POSCUR
         mov     bh,0
         mov     cx,1
         mov     ah,10
         lea     di,NJ0
         mov     al,[di]
         add     al,'0'
         int     10h
         dec     dl
         call    POSCUR
         lea     di,NJ1
         mov     al,[di]
         add     al,'0'
         int     10h
         dec     dl
         call    POSCUR
         lea     di,NJ2
         mov     al,[di]
         add     al,'0'
         int     10h
         dec     dl
         call    POSCUR
         lea     di,NJ3
         mov     al,[di]
         add     al,'0'
         int     10h
         mov     dh,21
         mov     dl,5
         call    POSCUR
         mov     bh,0
         mov     al,220
         mov     ah,10
         mov     cx,70
         int     10h
         mov     dh,9
         mov     dl,20
         call    POSCUR
         mov     al,'1'
         mov     ah,10
         mov     cx,1
         mov     bh,0
         int     10h
         mov     dh,9
         mov     dl,40
         call    POSCUR
         mov     al,'2'
         mov     ah,10
         mov     cx,1
         mov     bh,0
         int     10h
         mov     dh,9
         mov     dl,60
         call    POSCUR
         mov     al,'3'
         mov     ah,10
         mov     cx,1
         mov     bh,0
         int     10h
         mov     si,0
MLp1:    mov     dx,20
         sub     dx,si
         mov     dh,dl
         mov     dl,20 
         push    si
         lea     di,T1
         add     si,di
         mov     al,[si]
         pop     si
         sub     dl,al
         call    POSCUR
         mov     cl,al
         mov     ch,0
         add     cx,cx
         inc     cx
         add     al,'0'
         cmp     al,'0'
         jne     MLp2
         mov     al,'|'
         mov     bl,5
         call    COR
         jmp     MLp21
MLp2:    mov     bl,14
         call    COR
         mov     al,220
MLp21:   xor     bh,bh
         mov     ah,0ah
         int     10h
         inc     si
         cmp     si,10
         jne     MLp1
         mov     si,0
MLp3:    mov     dx,20
         sub     dx,si
         mov     dh,dl
         mov     dl,40
         push    si
         lea     di,T2
         add     si,di
         mov     al,[si]
         pop     si
         sub     dl,al
         call    POSCUR
         mov     cl,al
         mov     ch,0
         add     cx,cx
         inc     cx
         add     al,'0'
         cmp     al,'0'
         jne     MLp4
         mov     al,'|'
         mov     bl,5
         call    COR
         jmp     MLp41
MLp4:    mov     bl,14
         call    COR
         mov     al,'Ü'
Mlp41:   xor     bh,bh
         mov     ah,0ah
         int     10h
         inc     si
         cmp     si,10
         jne     MLp3
         mov     si,0
MLp5:    mov     dx,20
         sub     dx,si
         mov     dh,dl
         mov     dl,60
         push    si
         lea     di,T3
         add     si,di
         mov     al,[si]
         pop     si
         sub     dl,al
         call    POSCUR
         mov     cl,al
         mov     ch,0
         add     cx,cx
         inc     cx
         add     al,'0'
         cmp     al,'0'
         jne     MLp6
         mov     al,'|'
         mov     bl,5
         call    COR
         jmp     MLp61
MLp6:    mov     bl,14
         call    COR
         mov     al,'Ü'
MLp61:   xor     bh,bh
         mov     ah,0ah
         int     10h
         inc     si
         cmp     si,10
         jne     MLp5
         ret
MONTA    endp

;--------------------------------------------------------
; faz um movimento e testa erros (devolve al=0 se houve ESC, senao al=1)
MOVE     proc
         jmp     MCONT
MFIM:    mov     al,0
         ret
MCONT:   mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     dx, offset MSG2
         mov     ah,9
         int     21h
MMLp1:   mov     ah,0
         int     16h
         cmp     al,27
         je      MFIM
         cmp     al,'1'
         jb      MMLp1
         cmp     al,'3'
         ja      MMLp1
         mov     dl,al
         sub     dl,'0'
         push    dx
         mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     dx, offset MSG3
         mov     ah,9
         int     21h
MMLp2:   mov     ah,0
         int     16h
         cmp     al,27
         je      MFIM
         cmp     al,'1'
         jb      MMLp2
         cmp     al,'3'
         ja      MMLp2
         pop     dx
         mov     dh,al
         sub     dh,'0'
         cmp     dl,dh
         je      MERRO3
         mov     bl,dl
         call    STATUS
         cmp     cl,0
         je      MERRO1
         mov     al,bh
         mov     bl,dh
         call    STATUS
         cmp     bh,0
         je      MMLp3
         cmp     al,bh
         ja      MERRO2
MMLp3:   mov     bl,dl
         call    TIRA
         mov     bl,dh
         call    POE
         call    INCNJ
MMlp4:   call    LIMPATEL
         call    MONTA
         mov     al,1
         ret
MERRO1:  mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     dx, offset MSGERRO1
         mov     ah,9
         int     21h
         call    ESPERA
         jp      MMlp4
MERRO2:  mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     dx, offset MSGERRO2
         mov     ah,9
         int     21h
         call    ESPERA
         jp      MMlp4
MERRO3:  mov     dh,23
         mov     dl,10
         call    POSCUR
         mov     dx, offset MSGERRO3
         mov     ah,9
         int     21h
         call    ESPERA
         jp      MMlp4
MOVE     endp

.data

; mensagens
TITULO   db 'TORRE DE HANOI - Eduardo Motta Buhrnheim (a.k.a. Mingo)$'
NUMERO   db 'N§ de jogadas:$'
ESCFIM   db '[ESC] Opcoes$'
MSG1     db 'Digite o numero de roscas (3-9 ou F3=Exit!):$'
MSG2     db 'Digite a torre de origem:  $'
MSG3     db 'Digite a torre de destino: $'
MSG4     db 'PARABENS!!! Voce conseguiu transportar todas as roscas!!!$'
MSG5     db 'Jogar (N)ovamente, (S)air, (L)er ou (G)ravar o jogo?               $'
MSG6     db 'TORRE DE HANOI - Em Mingo Assembler! - Maio/2000',0dh,0ah
         db 0dh,0ah
         db 'Feito por Eduardo Motta Buhrnheim (a.k.a. Mingo)',0dh,0ah
         db 0dh,0ah
         db 'Baseado num programa feito por Christian Lykawka',0dh,0ah
         db '                               Carlos Eduardo Anselmi',0dh,0ah
         db '$'
MSGERRO1 db 'A torre de origem esta vazia!$'
MSGERRO2 db 'Rosca MAIOR sobre a MENOR!$'
MSGERRO3 db 'A torre de DESTINO e a mesma de ORIGEM!$'
NOMEARQ  db 'TORRE.DAT',0

; variaveis
BLDADOS  db 0            ; byte nulo
T1       db 10 dup (0)   ; pilhas para torres
T2       db 10 dup (0)
T3       db 10 dup (0)
P1       dw 0            ; apontadores para as pilhas
P2       dw 0
P3       dw 0
NJ0      db 0            ; digitos do numero de jogadas
NJ1      db 0
NJ2      db 0
NJ3      db 0
NR       db 0            ; numero de rosquinhas
CA       db 255          ; cor atual
                         ; total=43 bytes

end      INICIO
