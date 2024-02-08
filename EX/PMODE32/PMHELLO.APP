;By Tinashe Mutandagayi tinashh2000@yahoo.com

;PMHELLO.APP produces is a MZ executable(that prints a hello message while in
;(protected mode.) after being assembled with ASM++ v6.89

;It demonstates:
;1. Initializing protected mode and returning to real mode
;2. How to access the video text memory

;Works on 386 or better with color graphics card.
;Must be run under pure DOS without any protected mode or v86 program loaded.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.

FORMAT MZ   ;remove this to produce a .COM
LinearSelector  equ 08
Code32Selector  equ 16
Data32Selector  equ 24
Code16Selector  equ 32
Data16Selector  equ 40
start:
    mov eax,cs  ;Load CS
    mov ds,ax   ;Make DS=ES=CS because initially DS,ES point to the PSP
    mov es,ax
    mov bl,ah   ;bl=EAX>>28
    shl eax,4   ;EAX<<4 to get the code segment's physical base address
    shr bl,4
    mov word [Code32Sel+2],ax   ;Initialize Base 15:0 descriptors
    mov word [Data32Sel+2],ax
    mov word [Code16Sel+2],ax
    mov word [Data16Sel+2],ax
    xchg eax,ebx
    mov byte [Code32Sel+4],al   ;Initialize Base 24:16
    mov byte [Data32Sel+4],al
    mov byte [Code16Sel+4],al
    mov byte [Data16Sel+4],al

    mov ax,cs       ;EAX=CS<<16 or StartRM16
    shl eax,16
    mov ax,offset StartRM16 ;The address is used to get back to real16 mode
    mov dword [RMCSIP],eax


    lea eax,[ebx+GDT]   ;Initialize GDTR
    mov dword [GDTR+2],eax

    mov ax,3
    int 10h
    cli
    lgdt fword [GDTR]   ;Load GDTR
    mov eax,cr0         ;Get MSW
    or  al,1            ;Enable PE bit
    mov cr0,eax         ;Switch to protected mode
    jmp Code32Selector:StartPM32    ;Load CS with a PM32 selector
use32
StartPM32:          ;Start executing 32-Bit protected mode
    mov ax,LinearSelector   ;FS=ES=physical base address 0
    mov es,ax
    mov fs,ax
    mov ax,Data32Selector   ;DS=physical base address of CS
    mov ds,ax
    mov esi,offset MyStr    ;Point ESI to message
    mov edi,0B8000h         ;Point EDI to video text memory
    mov ah,7                ;Load color attribute in ah
PMPrintLoop:
    lodsb                   ;fetch character from [ESI]
    stosw                   ;store character and attribute (7)
    cmp byte [esi],0        ;Is it the end of the string?
    jnz PMPrintLoop
    jmp Code16Selector:StartPM16    ;Load CS with a PM16 selector
use16
StartPM16:                  ;Start executing in 16-bit protected mode
    mov ax,Data16Selector   ;Load data selectors with 16-Bit selectors
    mov ds,ax               ;Since this is 16-bit protected mode
    mov es,ax
    mov fs,ax
    mov eax,cr0             ;Get MSW
    and al,0FEh             ;Turn off PE bit
    mov cr0,eax             ;Turn off protected mode
    jmp dword [RMCSIP]      ;jump to real mode CS:IP (which was saved above)
StartRM16:
    mov ax,cs               ;Load all selectors with a real mode selector
    mov ds,ax               ;CS which was saved above
    mov es,ax
    mov fs,ax
    sti                     ;Enable maskable
    mov ax,4C00h            ;Exit to DOS
    int 21h
MyStr   db  "Hello world from protected mode",0
RMCSIP  dd  0

GDT:
            dw  0   ;Null descriptor
            dw  0
            dw  0
            dw  0
LinearSel   dw  -1  ;Limit 15:0
            dw  0   ;Base 15:0
            db  0   ;Base 23:16
            db  92h ;Present,Data,readable
            db  0CFh ;32-Bit granularity,Limit 19:16=0xF
            db  0   ;Base 31:24
Code32Sel   dw  -1  ;Limit  15:0
            dw  0   ;Base   15:0
            db  0   ;Base   24:16
            db  9Ah ;Present,Code
            db  0CFh ;32-Bit,Limit 19:16=0xF
            db  0   ;Base   31:25
Data32Sel   dw  -1
            dw  0
            db  0
            db  92h ;Data
            db  0CFh ;Limit 19:16=0xF
            db  0
Code16Sel   dw  -1
            dw  0
            db  0
            db  9Ah ;Code
            db  0   ;16-Bit,Limit 19:16=0xF
            db  0
Data16Sel   dw  -1
            dw  0
            db  0
            db  92h ;Data,Limit 19:16=0xF
            db  0
            db  0
GDTR        dw  $-GDT-1
            dd  0
