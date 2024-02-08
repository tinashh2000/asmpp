;By Tinashe Mutandagayi tinashh2000@yahoo.com

;RMINT.APP shows how a crazy desperate programmer can invoke DOS
;interrupts while running protected mode. It helps to create protected
;applications that need routines like the disk,video services. etc.
;The program runs in protected mode, when an interrupt is made, the
;system switches to real mode to execute the interrupt then returns to
;protected mode after the interrupt is served.
;This example does not pass valid segment registers to the real-mode
;interrupt handler. Another example demonstates how to pass valid segment
;registers.

;Must be run under pure DOS without any protected mode or v86 program loaded.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.

Linear  =   8
Code32  =   16
Data32  =   24
Code16  =   32
Data16  =   40

DescTable   struc
    Limit   dw  ?
    BaseL   dw  ?
    BaseH   db  ?
    DescType    db  ?
    DescSize    db  ?
    BaseHH  db  ?
DescTable   ends

    mov eax,cs
    mov ds,ax
    mov es,ax
    mov [RealCSIP][0002],ax
    mov [MiniRM][0002],ax
    shl eax,4
    mov [Code32Sel]BaseL,ax
    mov [Data32Sel]BaseL,ax
    mov [Code16Sel]BaseL,ax
    mov [Data16Sel]BaseL,ax
    mov ebx,eax
    shr eax,16
    mov [Code32Sel]BaseH,al
    mov [Data32Sel]BaseH,al
    mov [Code16Sel]BaseH,al
    mov [Data16Sel]BaseH,al

    lea eax,[ebx][GDT]
    mov [GDTR][0002],eax

    lea eax,[ebx][IDT]
    mov [IDTR][0002],eax

    mov [RealCSIP],offset ExeRM
    mov [MiniRM],offset RMIntHandler
    sidt    [RealIDT]
    cli
    lidt    [IDTR]
    lgdt    [GDTR]
    mov eax,cr0
    or  al,1
    mov cr0,eax
    jmp Code32:StartPM
use32
StartPM:
    mov ax,Data32
    mov ds,ax
    mov es,ax
    mov gs,ax
    mov ax,Linear
    mov fs,ax
    mov ax,3
    int 10h
    jmp Code16:StartRM
use16
Int00:
    push    word (00*4)
    jmp short IntHandler
Int01:
    push    word (01*4)
    jmp short IntHandler
Int02:
    push    word (02*4)
    jmp short IntHandler
Int03:
    push    word (03*4)
    jmp short IntHandler
Int04:
    push    word (04*4)
    jmp short IntHandler
Int05:
    push    word (05*4)
    jmp short IntHandler
Int06:
    push    word (06*4)
    jmp short IntHandler
Int07:
    push    word (07*4)
    jmp short IntHandler
Int08:
    push    word (08*4)
    jmp short IntHandler
Int09:
    push    word (09*4)
    jmp short IntHandler
Int0A:
    push    word (10*4)
    jmp short IntHandler
Int0B:
    push    word (11*4)
    jmp short IntHandler
Int0C:
    push    word (12*4)
    jmp short IntHandler
Int0D:
    push    word (13*4)
    jmp short IntHandler
Int0E:
    push    word (14*4)
    jmp short IntHandler
Int0F:
    push    word (15*4)
    jmp short IntHandler
Int10:    
    push    word (16*4)
    jmp short IntHandler
Int11:
    push    word (17*4)
    jmp short IntHandler
Int12:
    push    word (18*4)
IntHandler:
    cli
    push    eax
    mov eax,cr0
    and al,not 1
    mov cr0,eax
    mov ax,Data16
    mov ds,ax
    pop eax
    jmp dword cs:[MiniRM]
RMIntHandler:
    push    word (0)
    pop gs
    lidt    cs:[RealIDT]
    sti
    push    eax
    movzx   eax,sp
    movzx eax,word ss:[eax+04] ;SP=EAX
    mov eax,gs:[eax]
    mov cs:[MiniRM],eax
    pop eax
    add esp,2
    pushf
    call    dword cs:[MiniRM]
    cli
    lgdt cs:[GDTR]
    lidt cs:[IDTR]
    push    eax
    mov eax,cr0
    or  al,1
    mov cr0,eax
    pop eax
    jmp Code16:ReturnInt
ReturnInt:
    iretd   ;32-Bit return to 32-Bit protected mode

use32
Unhandled:
    jmp Code16:StartRM

use16
StartRM:
    mov eax,cr0
    and al,not 1
    mov cr0,eax
    mov ax,Data16
    mov ds,ax
    mov es,ax
    jmp dword cs:[RealCSIP]
ExeRM:
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov fs,ax
    mov gs,ax
    lidt [RealIDT]
    sti
    mov ah,4ch
    int 21h

GDT         dw  0
            dw  0
            db  0
            db  0
            db  0
            db  0
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

IDT         dw  Int00   ;00
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int01   ;01
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int02   ;02
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int03   ;03
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int04   ;04
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int05   ;05
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int06   ;06
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int07   ;07
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int08   ;08
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int09   ;09
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int0A   ;0A
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int0B   ;0B
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int0C   ;0C
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int0D   ;0D
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int0E   ;0E
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int0F   ;0F
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int10   ;10
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int11   ;11
            dw  Code16
            db  0
            db  8Eh
            dw  0
IDTR        dw  $-IDT-1
            dd  ?
RealCSIP    dd  ?
MiniRM      dd  ?
RealIDT     df  ?
