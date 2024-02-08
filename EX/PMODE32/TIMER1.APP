;By Tinashe Mutandagayi tinashh2000@yahoo.com

;TIMER1.APP is simple protected mode that comes with ASM++v6.89
;Demonstates:
;1. Timer and keyboard interrupt handling and acknowledging
;2. Masking interrupts
;3. Switching to protected mode and switching back to realmode

;Works on 386 or better with color graphics card.
;Must be run under pure DOS without any protected mode or v86 program loaded.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.

            org     100h
use16
LinearSelector      equ 08
Code32Selector      equ 16
Data32Selector      equ 24
Code16Selector      equ 32
Data16Selector      equ 40
Start:
            xor     eax,eax ;Get physical base segment address
            mov     ax,cs
            xor     bx,bx
            shl     eax,4
            mov     ebx,eax
            shr     ebx,16
            mov     word [Code32Sel+2],ax   ;Initialize base 15:0
            mov     word [Data32Sel+2],ax
            mov     word [Code16Sel+2],ax
            mov     word [Data16Sel+2],ax

            xchg    ebx,eax    ;Saves a byte for each move with accumulator AL
            mov     byte [Code32Sel+4],al   ;Initialize base 23:16
            mov     byte [Data32Sel+4],al
            mov     byte [Code16Sel+4],al
            mov     byte [Data16Sel+4],al

;            mov     byte [Code32Sel+7],ah  ;Initialize base 31:24
;            mov     byte [Data32Sel+7],ah  ;This is not initialized since
;            mov     byte [Code16Sel+7],ah  ;CS<<4 can never be greater than
;            mov     byte [Data16Sel+7],ah  ;20-bits

            lea     eax,[ebx+IDT]           ;Get physical address of IDT
            mov     dword [IDTR+2],eax

            lea     eax,[ebx+GDT]           ;Get physical address of GDT
            mov     dword [GDTR+2],eax

            mov     word [Code16CSIP],Start16 ;Save return address
            mov     word [Code16CSIP+2],cs

            cli     ;Disable interrupts
            sidt    fword [IDTR16]  ;Back-up real mode IDT before changing it

            lgdt    fword [GDTR]    ;load GDT
            lidt    fword [IDTR]    ;load IDT

            mov     eax,cr0     ;get MSW
            or      al,1        ;set PE bit
            mov     cr0,eax     ;turn on protected mode
            jmp     Code32Selector:Start32  ;load CS with PM32 selector
use32
Start32:    ;Begin executing in 32-Bit protected mode
            mov     ax,Data32Selector
            mov     ss,ax
            mov     ds,ax
            mov     ax,LinearSelector
            mov     es,ax
            mov     byte [es:0B8020h],'0'
            xor     ebp,ebp
            mov     al,0FCh ;Mask all interrupts,enable timer and keyboard
            out     21h,al  ;interrupts only (bit 0 and 1)
            sti     ;Enable maskable interrupts
Loop32:
            cmp     byte [KeyFlag],1
            jbe     Loop32
LoopDone:
            cli     ;Disable maskable interrupts
            jmp     Code16Selector:ExecCode16   ;Load CS with PM16 selector
use16
ExecCode16: ;Start executing 16-Bit protected mode
            mov     ax,Data16Selector
            mov     ds,ax
            mov     ss,ax
            mov     eax,cr0 ;Get MSW
            and     al,0FEh ;turn off PE bit
            mov     cr0,eax ;Turn off protected mode
            jmp     dword [Code16CSIP]  ;Load CS with real mode selector
Start16: ;16-Bit real mode starts here
            mov     ax,cs
            mov     ds,ax
            mov     ss,ax
            mov     es,ax
            lidt    fword [IDTR16]
            xor     al,al
            out     21h,al
            sti
            mov     ax,4C00h
            int     21h
use32           ;Invoked while in protected mode
TimerHandler:   ;Timer interrupt handler
            push    ax
            mov     al,byte [es:0B8020h]
            inc     al
            cmp     al,'9'
            jbe     TimerHandlerOK
            mov     al,'0'
TimerHandlerOK:
            mov     byte [es:0B8020h],al
            mov     al,20h  ;Acknowledge the interrupt
            out     20h,al
            pop     ax
            iret

KBHandler:
            push    ax 
            in      al,60h
            inc     byte [KeyFlag]  ;Set the KeyFlag (triggers a quit)
            mov     al,20h  ;Acknowledge the interrupt
            out     20h,al
            pop     ax
            iret

NoHandler:
            mov     byte [es:0B8022h],"E"
            mov     byte [es:0B8024h],"r"
            mov     byte [es:0B8026h],"r"
            mov     byte [es:0B8028h],"o"
            mov     byte [es:0B802Ah],"r"
            jmp     $

KeyFlag     db  0
Code16CSIP  dd  0

GDT:
NullDesc    dw  0
            dw  0
            db  0
            db  0
            db  0
            db  0
LinearSel   dw  0FFFFh  ;Limit 15:0
            dw  0       ;Base 15:0
            db  0       ;Base 23:16
            db  92h     ;Present,Data
            db  0CFh    ;4K Granul,32-Bit,Limit 19:16
            db  0       ;Base 31:24
Code32Sel   dw  0FFFFh  ;Limit 15:0
            dw  0       ;Base 15:0
            db  0       ;Base 23:16
            db  9Ah     ;Present,Code
            db  0CFh    ;4K Granul,32-Bit,Limit 19:16
            db  0       ;Base 31:24

Data32Sel   dw  0FFFFh  ;Limit 15:0
            dw  0       ;Base 15:0
            db  0       ;Base 23:16
            db  92h     ;Present,Data
            db  0CFh    ;4K Granul,32-Bit,Limit 19:16
            db  0       ;Base 31:24

Code16Sel   dw  0FFFFh  ;Limit 15:0
            dw  0       ;Base 15:0
            db  0       ;Base 23:16
            db  9Ah     ;Present,Data
            db  0       ;4K Granul,32-Bit,Limit 19:16
            db  0       ;Base 31:24

Data16Sel   dw  0FFFFh  ;Limit 15:0
            dw  0       ;Base 15:0
            db  0       ;Base 23:16
            db  92h     ;Present,Data
            db  0       ;4K Granul,32-Bit,Limit 19:16
            db  0       ;Base 31:24
GDTEnd:

IDT:
            dw  NoHandler   ;00
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;01
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;02
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;03
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;04
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;05
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;06
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;07
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  TimerHandler    ;08
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  KBHandler   ;09
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;0A
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;0B
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0

            dw  NoHandler   ;0C
            dw  Code32Selector
            db  0
            db  8Eh
            dw  0
IDTEnd:


GDTR        dw  (GDTEnd-GDT)-1
            dd  0
IDTR        dw  (IDTEnd-IDT)-1
            dd  0
IDTR16      dw  0
            dd  0
