;By Tinashe Mutandagayi tinashh2000@yahoo.com

;STAC.APP is a program that comes with ASM++ v6.89. It switches to protected
;mode.

;It demonstates:
;1. How to enter protected mode
;2. Printing while in protected mode.
;3. How much space stack a far call occupies in 32-bit protected mode


Linear=8
Code32=16  
Data32=24
Code16=32
Data16=40
main:
    mov eax,cs
    mov bl,ah
    shr bl,4
    shl eax,4
    mov word [Code32Sel+2],ax
    mov word [Data32Sel+2],ax
    mov word [Code16Sel+2],ax
    mov word [Data16Sel+2],ax
    xchg ebx,eax
    mov byte [Code32Sel+4],al
    mov byte [Data32Sel+4],al
    mov byte [Code16Sel+4],al
    mov byte [Data16Sel+4],al
    mov ax,cs
    shl eax,16
    mov ax,offset ExitPM
    mov dword [RealAddr],eax
    lea eax,[ebx+GDT]
    mov dword [GDTR+2],eax
    lgdt fword [GDTR]
    cli
    mov eax,cr0
    or  al,1
    mov cr0,eax
    jmp Code32:Enter32
use32
Enter32:
    mov ax,Linear
    mov ds,ax
    mov es,ax
    mov ax,Data32
    mov ss,ax
    mov esp,1000h
    push cs
    call PrintESP
    jmp Code16:Enter16
PrintESP:
    mov edi,0B8100h
    mov eax,07200720h
    mov cx,80
    rep stosd
    mov edi,0B8100h
    mov ebx,esp
    mov cl,8
    mov ah,7
PrintESPLoop:
    rol ebx,4
    mov al,bl
    and al,0Fh
    add al,48
    cmp al,57
    ja  PrintESPAlpha
    stosw
    dec cl
    jnz PrintESPLoop
    retf
PrintESPAlpha:
    add al,7
    stosw
    dec cl
    jnz PrintESPLoop
    retf
use16
Enter16:
    mov ax,Data16
    mov ds,ax
    mov eax,cr0
    and al,0FEh
    mov cr0,eax
    jmp dword [RealAddr]
ExitPM:
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    sti
    mov ah,4Ch
    int 21h
RealAddr    dd  0

GDT:
            dw  0
            dw  0
            dw  0
            dw  0
LinearSel   dw  0FFFFh
            dw  0
            db  0
            db  92h
            db  0CFh
            db  0
Code32Sel   dw  0FFFFh
            dw  0
            db  0
            db  9Ah
            db  0CFh
            db  0
Data32Sel   dw  0FFFFh
            dw  0
            db  0
            db  92h
            db  0CFh
            db  0
Code16Sel   dw  0FFFFh
            dw  0
            db  0
            db  9Ah
            db  0
            db  0
Data16Sel   dw  0FFFFh
            dw  0
            db  0
            db  92h
            db  0
            db  0
GDTR        dw  $-GDT-1
            dd  0
