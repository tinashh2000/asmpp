
; --------------------------------------------------------------------------
; PLASMA - Nov/2000 - Mingo Assembler Pro
; Eduardo Motta Buhrnheim (a.k.a. Mingo)
; http://mingus.cjb.net/
; http://mahome.mingus.cjb.net/
; mingo@programador.mailbr.com.br
; --------------------------------------------------------------------------

.286
.model tiny
;.code

jmp inicio

vidseg   equ    0a000h
cr       equ    13
lf       equ    10

retraco:
         mov    dx,3dah
@vert1:  in     al,dx
         test   al,8
         jz     @vert1
@vert2:  in     al,dx
         test   al,8
         jnz    @vert2
         ret

plasma:
         mov    ax,vidseg
         mov    es,ax

         lea    bx,i
         mov    ah,[bx]
         add    ah,255
         mov    [bx],ah

         lea    bx,j
         mov    ah,[bx]
         add    ah,1
         mov    [bx],ah

         mov    di,0         ; endereco
         mov    si,25
         mov    ax,si
         shl    ax,4
         add    di,ax
         shl    ax,2
         add    di,ax
         add    di,5
@l0:
         mov    bx,si
         push   si

         lea    si,i
         add    bx,[si]

         and    bx,0ffh

         lea    si,stab
         mov    dl,[bx+si]

         lea    si,j
         mov    bx,[si]

         lea    si,ctab
         mov    dh,[bx+si]

         mov    cx,5
         pop    si
@l1:
         mov    bx,cx
         add    bl,dl
         push   si

         lea    si,stab
         mov    al,[bx+si]

         pop    si
         mov    bx,si
         push   si
         add    bl,dh

         lea    si,ctab
         add    al,[bx+si]

         pop    si
         mov    es:[di],al
         inc    di
         inc    cx
         cmp    cx,75
         jne    @l1
         add    di,10
         inc    si
         cmp    si,175
         jne    @l0
         ret

inicio:
         push   es

         mov    ax,0013h     ;
         int    10h          ;
         mov    dx,03c4h     ;
         mov    ax,0604h     ;
         out    dx,ax        ;
         mov    dx,03d4h     ;
         mov    ax,4109h     ;
         out    dx,ax        ;
         mov    ax,0014h     ;
         out    dx,ax        ;
         mov    ax,0e317h    ;
         out    dx,ax        ;
         mov    ax,vidseg    ;
         mov    es,ax        ;
         xor    di,di        ;
         xor    ax,ax        ;
         mov    cx,32000     ;
         rep    stosw        ; entra no modo-x

         mov    cx,64
palette:
         mov    dx,3c8h
         mov    al,cl
         out    dx,al        ; cor
         inc    dx
         mov    al,0
         out    dx,al        ; vermelho
         mov    al,cl
         shr    al,1
         out    dx,al        ; verde
         out    dx,al        ; azul

         mov    dx,3c8h
         mov    al,cl
         add    al,127
         out    dx,al        ; cor
         inc    dx
         mov    al,0
         out    dx,al        ; vermelho
         mov    al,cl
         shr    al,2
         out    dx,al        ; verde
         mov    al,cl
         shr    al,1
         out    dx,al        ; azul

         mov    dx,3c8h
         mov    ah,cl
         mov    al,128
         sub    al,ah
         out    dx,al        ; cor
         inc    dx
         mov    al,0
         out    dx,al        ; vermelho
         mov    al,cl
         shr    al,1
         out    dx,al        ; verde
         out    dx,al        ; azul

         mov    dx,3c8h
         mov    ah,cl
         mov    al,255
         sub    al,ah
         inc    al
         out    dx,al        ; cor
         inc    dx
         mov    al,0
         out    dx,al        ; vermelho
         mov    al,cl
         shr    al,2
         out    dx,al        ; verde
         shl    al,1
         out    dx,al        ; azul

         loop   palette

         mov    ax,cs        ;
         mov    ds,ax        ;  coloca CS em DS

repete:

         call   retraco
         call   plasma

         in     al,60h
         cmp    al,1
         je     Fim

         jmp    repete
fim:
         mov    ax,3         ;
         int    10h          ; modo-texto

         pop    es
         mov    ax,1301h     ;
         mov    bh,0         ;
         mov    bl,11        ; atributo da cor
         mov    dh,0         ; linha
         mov    dl,0         ; coluna
         mov    cx,116       ; cx = tamanho da mensagem em caracteres
         lea    bp,texto     ;
         int    10h          ; Exibe a mensagem

lbt:
         mov    ah,6         ;
         mov    dl,0FFh      ;
         int    21h          ;
         jnz    lbt          ; limpa o Buffer do teclado

         mov    ax,4c00h     ;
         int    21h          ; fim do programa

; tabela do seno    => round(sin(2*pi*x/255)*128)+128
stab     db 128,131,134,137,141,144,147,150,153,156,159,162,165,168,171,174
         db 177,180,183,186,189,191,194,197,199,202,205,207,209,212,214,217
         db 219,221,223,225,227,229,231,233,235,236,238,240,241,243,244,245
         db 246,248,249,250,251,252,252,253,254,254,255,255,255,000,000,000
         db 000,000,000,000,255,255,254,254,253,253,252,251,250,249,248,247
         db 246,245,243,242,240,239,237,236,234,232,230,228,226,224,222,220
         db 218,215,213,211,208,206,203,201,198,195,193,190,187,184,181,179
         db 176,173,170,167,164,161,158,155,152,148,145,142,139,136,133,130
         db 126,123,120,117,114,111,108,104,101,098,095,092,089,086,083,080
         db 077,075,072,069,066,063,061,058,055,053,050,048,045,043,041,038
         db 036,034,032,030,028,026,024,022,020,019,017,016,014,013,011,010
         db 009,008,007,006,005,004,003,003,002,002,001,001,000,000,000,000
         db 000,000,000,001,001,001,002,002,003,004,004,005,006,007,008,010
         db 011,012,013,015,016,018,020,021,023,025,027,029,031,033,035,037
         db 039,042,044,047,049,051,054,057,059,062,065,067,070,073,076,079
         db 082,085,088,091,094,097,100,103,106,109,112,115,119,122,125,128

; tabela do cosseno => round(cos(2*pi*x/255)*128)+128;
ctab     db 000,000,000,000,255,255,255,254,254,253,252,251,250,249,248,247
         db 246,245,244,242,241,239,238,236,234,232,231,229,227,225,223,220
         db 218,216,214,211,209,206,204,201,199,196,193,191,188,185,182,179
         db 176,174,171,168,165,162,158,155,152,149,146,143,140,137,134,130
         db 127,124,121,118,115,111,108,105,102,099,096,093,090,087,084,081
         db 078,075,072,070,067,064,061,059,056,053,051,048,046,044,041,039
         db 037,034,032,030,028,026,024,023,021,019,018,016,014,013,012,010
         db 009,008,007,006,005,004,003,003,002,002,001,001,000,000,000,000
         db 000,000,000,000,001,001,002,002,003,003,004,005,006,007,008,009
         db 010,012,013,014,016,018,019,021,023,024,026,028,030,032,034,037
         db 039,041,044,046,048,051,053,056,059,061,064,067,070,072,075,078
         db 081,084,087,090,093,096,099,102,105,108,111,115,118,121,124,127
         db 130,134,137,140,143,146,149,152,155,158,162,165,168,171,174,176
         db 179,182,185,188,191,193,196,199,201,204,206,209,211,214,216,218
         db 220,223,225,227,229,231,232,234,236,238,239,241,242,244,245,246
         db 247,248,249,250,251,252,253,254,254,255,255,255,000,000,000,000
i        dw 0
j        dw 90

texto    db 'Plasma by Eduardo Motta BÅhrnheim (a.k.a. Mingo) [11/2000]',cr,lf
         db 'http://mingus.cjb.net/ - http://mahome.mingus.cjb.net/',cr,lf

         end    inicio
