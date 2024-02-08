;By Tinashe Mutandagayi tinashh2000@yahoo.com

;LDT.APP demonstates the use of a Local Descriptor Table.
;It took me a long time before I could understand why its there.

;It demonstates:
;The initializing the LDT
;Using an LDT to address an area in the video memory

;Works on 386 or better with color graphics card.
;Must be run under pure DOS without any protected mode or v86 program loaded.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.

format mz
Code32  equ 8
Data32  equ 16
Code16  equ 24
Data16  equ 32
LDTSel  equ 40
Linear  equ 48
VideoSel    equ 0 or 4    ;Read from LDT. Bit 2 shows that its being read
                          ;from the LDT than the GDT.
Start:
    mov eax,cs
    mov ds,ax
    mov es,ax
    mov word [RMAddr],Real16
    mov word [RMAddr+2],ax
    shl eax,4
    mov [Code32Sel+2],ax
    mov [Data32Sel+2],ax
    mov [Code16Sel+2],ax
    mov [Data16Sel+2],ax
    mov ebx,eax
    shr eax,16
    mov byte [Code32Sel+4],al
    mov byte [Data32Sel+4],al
    mov byte [Code16Sel+4],al
    mov byte [Data16Sel+4],al
    lea eax,[ebx+GDT]
    mov dword [GDTR+2],eax

    lea eax,[ebx+LDTDesc]
    mov [LDT32+2],ax
    shr eax,16
    mov byte [LDT32+4],al
    cli
    lgdt fword [GDTR]
    mov eax,cr0
    or  al,1
    mov cr0,eax
    jmp Code32:Enter32
use32
Enter32:    
    mov ax,Linear
    mov fs,ax
    xor byte fs:[417h],40h

    mov ax,LDTSel
    lldt ax
    mov ax,VideoSel ;First segment selector in LDT
    mov es,ax
    mov ax,Data32
    mov ds,ax
    xor edi,edi
    mov esi, LDTStr
    mov ah,7
PrintLoop:
    lodsb
    stosw
    cmp byte [esi],0
    jnz PrintLoop
    jmp Code16:Enter16
    
use16
Enter16:
    mov ax,Data16
    mov ds,ax
    mov es,ax
    mov eax,cr0
    and al,0FEh
    mov cr0,eax
    jmp dword [ds:RMAddr]
Real16:
    mov ax,cs
    mov ds,ax
    mov es,ax
    sti
    mov ax,4C00h
    int 21h
LDTStr  db  "This text was stored using an LDT descriptor to this location",0
GDT         dw  0
            dw  0
            dw  0
            dw  0
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
LDT32       dw  7
            dw  0
            db  0
            db  82h
            db  0
            db  0
LinearSel   dw  0FFFFh
            dw  0
            db  0
            db  92h
            db  0CFh
            db  0
GDTR        dw  $-GDT-1
            dd  0

LDTDesc     dw  0FFFFh
            dw  8000h   ;Base of video memory 0B8000h
            db  0Bh
            db  92h
            db  0CFh
            db  0
RMAddr      dd  0
