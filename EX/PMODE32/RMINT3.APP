;By Tinashe Mutandagayi tinashh2000@yahoo.com

;This is a modification of RMINT2.APP

;You can use this program for any reason without my permission but I would
;be more than happy if you send me an e-mail.

;Must be run under pure DOS without any protected mode or v86 program loaded.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.

Linear  =   8
Code32  =   16
Data32  =   24
Shared  =   32
Code16  =   40
Data16  =   48

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
    mov [SharedSel]BaseL,ax
    mov [Code16Sel]BaseL,ax
    mov [Data16Sel]BaseL,ax
    mov ebx,eax
    shr eax,16
    mov [Code32Sel]BaseH,al
    mov [Data32Sel]BaseH,al
    mov [SharedSel]BaseH,al
    mov [Code16Sel]BaseH,al
    mov [Data16Sel]BaseH,al

    lea eax,[ebx][GDT]
    mov [GDTR][0002],eax

    lea eax,[ebx][IDT]
    mov [IDTR][0002],eax

    mov [RealCSIP],offset ExeRM
    mov [MiniRM],offset RMIntHandler

    mov [DSReg],ds  ;Save real mode DS and ES
    mov [ESReg],es

    and esp,0FFFFh  ;Make sure ESP is in the 64K limit. Usually it is

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
    sti
    mov ax,Data32
    mov ds,ax
    mov es,ax
    mov gs,ax
    mov ax,Shared
    mov fs,ax
    mov ax,3
    int 10h
    mov dx,offset HelloMsg
    mov ah,9
    int 21h
WaitForTimer:
    movzx ax,byte fs:[Ticks]
    mov cl,18
    div cl
    mov dl,al
    mov ah,3
    sub ah,al
    mov al,ah
    add al,"0"
    mov ah,7
    mov cx,Linear
    mov gs,cx
    mov word gs:[0B80A0h],ax
    cmp dl,2
    jbe WaitForTimer
    mov dx,offset PressAKey
    mov ah,9
    int 21h
    mov ah,0
    int 16h
    jmp Code16:StartRM
use16
Int00:
    push    word (00h*4)
    jmp IntHandler
Int01:
    push    word (01h*4)
    jmp IntHandler
Int02:
    push    word (02h*4)
    jmp IntHandler
Int03:
    push    word (03h*4)
    jmp IntHandler
Int04:
    push    word (04h*4)
    jmp IntHandler
Int05:
    push    word (05h*4)
    jmp IntHandler
Int06:
    push    word (06h*4)
    jmp IntHandler
Int07:
    push    word (07h*4)
    jmp IntHandler
Int08:
    push word (Shared)
    pop gs
    inc byte gs:[Ticks]
    push    word (08h*4)
    jmp IntHandler
Int09:
    push    word (09h*4)
    jmp IntHandler
Int0A:
    push    word (0Ah*4)
    jmp IntHandler
Int0B:
    push    word (0Bh*4)
    jmp IntHandler
Int0C:
    push    word (0Ch*4)
    jmp IntHandler
Int0D:
    push    word (0Dh*4)
    jmp IntHandler
Int0E:
    push    word (0Eh*4)
    jmp IntHandler
Int0F:
    push    word (0Fh*4)
    jmp IntHandler
Int10:
    push    word (10h*4)
    jmp IntHandler
Int11:
    push    word (11h*4)
    jmp IntHandler
Int12:
    push    word (12h*4)
    jmp IntHandler
Int13:
    push    word (13h*4)
    jmp IntHandler
Int14:
    push    word (14h*4)
    jmp IntHandler
Int15:
    push    word (15h*4)
    jmp IntHandler
Int16:
    push    word (16h*4)
    jmp IntHandler
Int17:
    push    word (17h*4)
    jmp IntHandler
Int18:
    push    word (18h*4)
    jmp IntHandler
Int19:
    push    word (19h*4)
    jmp IntHandler
Int1A:
    push    word (1Ah*4)
    jmp IntHandler
Int1B:
    push    word (1Bh*4)
    jmp IntHandler
Int1C:
    push    word (1Ch*4)
    jmp IntHandler
Int1D:
    push    word (1Dh*4)
    jmp IntHandler
Int1E:
    push    word (1Eh*4)
    jmp IntHandler
Int1F:
    push    word (1Fh*4)
    jmp IntHandler
Int20:
    push    word (20h*4)
    jmp IntHandler
Int21:
    push    word (21h*4)
    jmp IntHandler
Int22:
    push    word (22h*4)
    jmp IntHandler
Int23:
    push    word (23h*4)
    jmp IntHandler
Int24:
    push    word (24h*4)
    jmp IntHandler
Int25:
    push    word (25h*4)
    jmp IntHandler
Int26:
    push    word (26h*4)
    jmp IntHandler
Int27:
    push    word (27h*4)
    jmp IntHandler
Int28:
    push    word (28h*4)
    jmp IntHandler
Int29:
    push    word (29h*4)
    jmp IntHandler
Int2A:
    push    word (2Ah*4)
    jmp IntHandler
Int2B:
    push    word (2Bh*4)
    jmp IntHandler
Int2C:
    push    word (2Ch*4)
    jmp IntHandler
Int2D:
    push    word (2Dh*4)
    jmp IntHandler
Int2E:
    push    word (2Eh*4)
    jmp IntHandler
Int2F:
    push    word (2Fh*4)
    jmp IntHandler
Int30:
    push    word (30h*4)
    jmp IntHandler
Int31:
    push    word (31h*4)
    jmp IntHandler
Int32:
    push    word (32h*4)
    jmp IntHandler
Int33:
    push    word (33h*4)
    jmp IntHandler
Int34:
    push    word (34h*4)
    jmp IntHandler
Int35:
    push    word (35h*4)
    jmp IntHandler
Int36:
    push    word (36h*4)
    jmp IntHandler
Int37:
    push    word (37h*4)
    jmp IntHandler
Int38:
    push    word (38h*4)
    jmp IntHandler
Int39:
    push    word (39h*4)
    jmp IntHandler
Int3A:
    push    word (3Ah*4)
    jmp IntHandler
Int3B:
    push    word (3Bh*4)
    jmp IntHandler
Int3C:
    push    word (3Ch*4)
    jmp IntHandler
Int3D:
    push    word (3Dh*4)
    jmp IntHandler
Int3E:
    push    word (3Eh*4)
    jmp IntHandler
Int3F:
    push    word (3Fh*4)
    jmp IntHandler
Int40:
    push    word (40h*4)
    jmp IntHandler
Int41:
    push    word (41h*4)
    jmp IntHandler
Int42:
    push    word (42h*4)
    jmp IntHandler
Int43:
    push    word (43h*4)
    jmp IntHandler
Int44:
    push    word (44h*4)
    jmp IntHandler
Int45:
    push    word (45h*4)
    jmp IntHandler
Int46:
    push    word (46h*4)
    jmp IntHandler
Int47:
    push    word (47h*4)
    jmp IntHandler
Int48:
    push    word (48h*4)
    jmp IntHandler
Int49:
    push    word (49h*4)
    jmp IntHandler
Int4A:
    push    word (4Ah*4)
    jmp IntHandler
Int4B:
    push    word (4Bh*4)
    jmp IntHandler
Int4C:
    push    word (4Ch*4)
    jmp IntHandler
Int4D:
    push    word (4Dh*4)
    jmp IntHandler
Int4E:
    push    word (4Eh*4)
    jmp IntHandler
Int4F:
    push    word (4Fh*4)
    jmp IntHandler
Int50:
    push    word (50h*4)
;    jmp IntHandler
IntHandler:    
    cli
    push    eax
    mov ax,Shared
    mov gs,ax
    mov gs:[DSBak],ds   ;Save DS and ES registers
    mov gs:[ESBak],es
    mov eax,cr0         ;Turn off protected mode
    and al,not 1
    mov cr0,eax
    pop eax
    jmp dword cs:[MiniRM]   ;Intersegment jump to real-mode code...
RMIntHandler:
    push    word (0)        ;...here
    pop gs                  ;GS=0
    lidt    cs:[RealIDT]    ;Load real mode IDT
    sti                     ;Enable interrupts
    int 3
    push    eax             ;EAX may contain info needed by the handler.
    movzx eax,word ss:[esp+04] ;Note that ESP+0000=EAX
    mov eax,gs:[eax]           ;Get the far address of the handler
    mov cs:[TempAddr],eax        ;Save it
    pop eax
    add esp,2
    mov ds,cs:[DSReg]
    mov es,cs:[ESReg]
    pushf
    call    dword cs:[TempAddr]
    pushf   ;Return flags as they are to the user
    cli
    lgdt cs:[GDTR]
    lidt cs:[IDTR]
    push    eax
    mov eax,cr0
    or  al,1
    mov cr0,eax
    pop eax
    popf
    jmp Code16:ReturnInt
ReturnInt:
    mov ds,cs:[DSBak]   ;Restore segment registers
    mov es,cs:[ESBak]
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
SharedSel   dw  0FFFFh
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
            dw  Int12   ;12
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int13   ;13
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int14   ;14
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int15   ;15
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int16   ;16
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int17   ;17
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int18   ;18
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int19   ;19
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int1A   ;1A
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int1B   ;1B
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int1C   ;1C
            dw  Code16
            db  0
            db  8Eh 
            dw  0
            dw  Int1D   ;1D
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int1E   ;1E
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int1F   ;1F
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int20   ;20
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int21   ;21
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int22   ;22
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int23   ;23
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int24   ;24
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int25   ;25
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int26   ;26
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int27   ;27
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int28   ;28
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int29   ;29
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int2A   ;2A
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int2B   ;2B
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int2C   ;2C
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int2D   ;2D
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int2E   ;2E
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int2F   ;2F
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int30   ;30
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int31   ;31
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int32   ;32
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int33   ;33
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int34   ;34
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int35   ;35
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int36   ;36
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int37   ;37
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int38   ;38
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int39   ;39
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int3A   ;3A
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int3B   ;3B
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int3C   ;3C
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int3D   ;3D
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int3E   ;3E
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int3F   ;3F
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int40   ;40
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int41   ;41
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int42   ;42
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int43   ;43
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int44   ;44
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int45   ;45
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int46   ;46
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int47   ;47
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int48   ;48
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int49   ;49
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int4A   ;4A
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int4B   ;4B
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int4C   ;4C
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int4D   ;4D
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int4E   ;4E
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int4F   ;4F
            dw  Code16
            db  0
            db  8Eh
            dw  0
            dw  Int40   ;50
            dw  Code16
            db  0
            db  8Eh
            dw  0
IDTR        dw  $-IDT-1
            dd  ?

HelloMsg    db  "Hello world from interrupt 21",13,10
            db  "3 seconds delay...",13,10,"$"
PressAKey   db  "Press any key to return to DOS",13,10,"$"
Ticks       db  0
RealCSIP    dd  ?
MiniRM      dd  ?
TempAddr    dd  ?
RealIDT     df  ?
DSReg       dw  ?
ESReg       dw  ?

DSBak       dd  ?
ESBak       dd  ?
GSBak       dd  ?
