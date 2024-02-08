;By Tinashe Mutandagayi tinashh2000@yahoo.com

;PAGE.APP demonstates basic paging in protected mode.
;This program maps the addresses from B8000h to a logical address of
;10000000h. This code can show page fault errors. You can alter the code
;as desired and use it as you want but if you intend to use this code for
;anything else, I would be happy if you e-mailed me.

;This code demonstates:
;1. Switching to protected mode and turning paging on simulteneously
;2. Interrupt handling. Printing messages and numbers on the screen
;3. Paging

;This code requires a color graphic card or any card with memory addressable
;at 000B8000.
;A 386+ 32-Bit compatible processor and some RAM for this program to run.
;This program must be run under pure DOS without any protected mode or v86
;program loaded.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.


format mz
DescTable   struc
    Limit   dw  ?
    BaseL   dw  ?
    BaseH   db  ?
    DescType    db  ?
    DescSize    db  ?
    BaseHH  db  ?
DescTable   ends

Linear  =   08
Code32  =   16
Data32  =   24
Code16  =   32
Data16  =   40

    mov eax,cs
    mov ds,ax
    mov es,ax
    mov cs:[RealAddr][0002],ax
    mov word cs:[RealAddr],offset ExecuteRM
    shl eax,4
    mov [Code32Sel]BaseL,ax ;Initialize descriptors
    mov [Data32Sel]BaseL,ax
    mov [Code16Sel]BaseL,ax
    mov [Data16Sel]BaseL,ax
    mov ebx,eax
    shr eax,16
    mov [Code32Sel]BaseH,al
    mov [Data32Sel]BaseH,al
    mov [Code16Sel]BaseH,al
    mov [Data16Sel]BaseH,al

    lea eax,[ebx+GDT]
    mov [GDTR][0002],eax

    lea eax,[ebx+IDT]
    mov [IDTR][0002],eax

    lea eax,[ebx+PageDir] ;Calculate the offset of the pagedir
    movzx ebx,ax
    and bx,0FFFh    ;Remain with the remainder after division by 4096
    sub bx,1000h     ;Calculate the displacement to a 4096 aligned place.
    neg bx
    add eax,ebx
    mov cr3,eax     ;Initialize the page directory base register (PDBR)
    mov [PDEs],eax  ;Page directory entries
    add eax,1024*4
    mov [PTEs],eax  ;Page table entries
InitPage:
    mov cx,1024
    or  al,7
InitPageDir:
    lea edi,[ebx+PageDir] ;BX is the displacement to a 4096 byte aligned place
    push    eax
    mov ecx,(DataEnd-PageDir)/4
    xor eax,eax ;Invalidate all page entries. As long as bit 0 (Present is off)
    rep stosd   ;A page fault will occur
    pop eax
    lea edi,[ebx+PageDir]
    mov [edi],eax
    add eax,4096
    mov [edi+4],eax
    add eax,4096
    mov [edi+(40h*4)],eax
    lea edi,[ebx+PageTables]
    mov ecx,1024*2
    xor eax,eax
    or  al,7
InitPageTables:
    stosd
    add eax,4096
    dec cx
    jnz InitPageTables
    mov ecx,1024
    mov eax,0B8000h or 7
InitVideoPage:
    stosd
    add eax,4096
    dec cx
    jnz InitVideoPage
InitPM:
    sidt    cs:[RealIDT]
    cli
    lidt    cs:[IDTR]
    lgdt    cs:[GDTR]
    mov eax,cr0
    or  eax,8000_0001h
    mov cr0,eax
    jmp Code32:StartPM
use32
StartPM:
    mov ax,Linear
    mov fs,ax
    mov word fs:[0B80A0h],0730h
    mov word fs:[1000_00A2h],0731h
    jmp Code16:EnterRM
PageFault:
    mov esi,offset PageFaultStr
    call    PrintStr
    mov eax,cr2
    call    PrintHex
    jmp Code16:EnterRM
Unhandled:
    mov esi,offset UnhandledStr
    call    PrintStr
    jmp Code16:EnterRM
PrintHex:
    mov ebx,eax
    mov ah,7
    mov cx,8
PrintHexLoop:
    rol ebx,4
    mov al,bl
    and al,0Fh
    mov dl,0FFh
    cmp al,10   ;Is al<9...if below carry flag = 1
    adc dl,0    ;if al<9 then dl=dl+1 which makes it zero
    and dl,7    ;if dl was 0FFh then it becomes 7. dl is ff if al > 9
    add al,dl   ;This is done so that if the hex digit > 9, "A"+ will be printed
    add al,48   ;this code prevents a conditional jump
    stosw
    dec cx
    jnz PrintHexLoop
    ret

PrintStr:
    mov ax,Data32
    mov ds,ax
    mov ax,Linear
    mov es,ax
    mov edi,0B80A0h
    mov ah,7
PrtLoop:
    lodsb
    stosw
    cmp byte [esi],0
    jnz PrtLoop
    ret
use16
EnterRM:
    mov eax,cr0
    and eax,not 8000_0001h
    mov cr0,eax
    jmp dword cs:[RealAddr]
ExecuteRM:
    mov ax,cs
    mov es,ax
    mov ds,ax
    lidt    [RealIDT]
    sti
    mov ah,4Ch
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

IDT         dw  Unhandled   ;00
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;01
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;02
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;03
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;04
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;05
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;06
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;07
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;08
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;09
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;0A
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;0B
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;0C
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;0D
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  PageFault   ;0E
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;0F
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;10
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;11
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;12
            dw  Code32
            db  0
            db  8Eh
            dw  0
            dw  Unhandled   ;13
            dw  Code32
            db  0
            db  8Eh
            dw  0
IDTR        dw  $-IDT-1
            dd  0

PageFaultStr    db  "Page fault at address ",0
UnhandledStr    db  "Unhandled interrupt ",0

RealIDT     df  ?            
RealAddr    dd  ?

PDEs        dd  ?   ;Linear address of page directory entries
PTEs        dd  ?   ;Linear address of page table entries
PageDir     dd  1024    dup(?)
PageTables  dd  1024*3  dup(?)  ;The third page is used to map to 0B8000h
DataEnd:
Padd        dd  1024    dup(?)  ;This is done so that if a program was not
                                ;Aligned to 4096 bytes, any adjustments will
                                ;eat up this space rather than get out of
                                ;boundary. For .COMs it is not important
