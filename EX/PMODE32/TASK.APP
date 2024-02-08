;By Tinashe Mutandagayi tinashh2000@yahoo.com

;TASK.APP comes as an example in ASM++ v6.89 and I garantee you that this
;program will compile without any errors unless modified.

;It demonstates:
;1. How to enter protected mode
;2. Initializing a task and task switching
;3. Preemptive task switching using the 8259 timer interrupts
;4. Handling interrupts using a task gate and interrupt gate
;5. Returning to real mode from protected mode

;Works on 386 or better with color graphics card.
;Must be run under pure DOS without any protected mode or v86 program loaded.

;I was able to make this program after reading many source codes and
;understanding the basics of task switching so I do not take credit for this
;source but I give my thanks to all those who have done something for the
;open source world.

;I DO NOT TAKE RESPONSIBILITY FOR ANY DAMAGES CAUSED BY THIS PROGRAM ON ANY
;ONE'S LIFE, COMPUTER OR DATA. USE THIS PROGRAM AS LEARNING MATERIAL AT YOUR
;OWN RISK.

Linear=8
Code32=16  
Data32=24
Code16=32
Data16=40
SysTSS=48
Task1TSS=56
Task2TSS=64
TimerTSS=72
include 'tss.inc'
main:
    mov eax,cs  ;EAX=CS & 0x0000FFFF
    mov bl,ah
    shr bl,4    ;bl=EAX>>28
    shl eax,4   ;Get linear base address of code
    mov word [Code32Sel+2],ax   ;Store base 15:0 into descriptors
    mov word [Data32Sel+2],ax
    mov word [Code16Sel+2],ax
    mov word [Data16Sel+2],ax
    xchg ebx,eax
    mov byte [Code32Sel+4],al   ;Store base 23:16 into descriptors
    mov byte [Data32Sel+4],al
    mov byte [Code16Sel+4],al
    mov byte [Data16Sel+4],al
                                ;EAX=CS<<4 can ever give a number
                                ;that is > 0xFFFFF (20-Bits)
    mov ax,cs       ;(EAX=CS<<16 or ExitPM) far address used to return to
    shl eax,16      ;protected mode
    mov ax,offset ExitPM
    mov dword [RealAddr],eax    ;Save realmode return address
    lea eax,[ebx+GDT]           ;Get linear address for GDT
    mov dword [GDTR+2],eax

    lea eax,[ebx+IDT]           ;Get linear address for IDT
    mov dword [IDTR+2],eax

    lea eax,[ebx+TSS0]          ;Get linear address for TSS0
    mov word [TmrTSS+2],ax
    shr eax,16
    mov byte [TmrTSS+4],al

    lea eax,[ebx+TSS1]          ;Get linear address for TSS1
    mov word [SystemTSS+2],ax
    shr eax,16
    mov word [SystemTSS+4],al

    lea eax,[ebx+TSS2]          ;Get linear address for TSS2
    mov word [Tsk1TSS+2],ax
    shr eax,16
    mov byte [Tsk1TSS+4],al

    lea eax,[ebx+TSS3]          ;Get linear address for TSS2
    mov word [Tsk2TSS+2],ax
    shr eax,16
    mov byte [Tsk2TSS+4],al

    mov ah,1    ;Was anykey pressed?
    int 16h
    jz  NoKeyPress
    mov ah,0    ;Eat the key that was pressed
    int 16h
NoKeyPress:
    sidt fword [BackIDT]        ;Back-up realmode IDTR before changing it
    cli     ;Disable maskable interrupts.
    lgdt fword [GDTR]           ;Load GDT
    lidt fword [IDTR]           ;Load IDT
    mov eax,cr0
    or  al,1                    ;Turn PM bit on
    mov cr0,eax                 ;Start protected mode
    jmp Code32:Enter32          ;Change CS selector to a valid protected mode
                                ;selector
use32
Enter32:                        ;Start protected mode execution
    mov ax,Data32               ;Initialie data selectors with protected mode
    mov ss,ax                   ;values
    mov ds,ax
    mov es,ax
    mov esp,TOS                 ;Initialize stack to 2048
    mov ebp,esp
    mov ax,SysTSS
    ltr ax                      ;Initialize task register
    mov eax,offset TimerProcTaskSwitch
    mov ebx,offset TSS0
    call InitTSS                ;Initialize TimerProc (is used to taskswitch)
    mov eax,offset Task2Code
    mov ebx,offset TSS2
    call InitTSS                ;Initialize Task2's TSS
    mov eax,offset Task3Code
    mov ebx,offset TSS3
    call InitTSS                ;Initialize Task3's TSS
    mov al,0FCh                 ;Disable all interrupts except keyboard
    out 21h,al                  ;and timer
    mov al,0FFh
    out 0A1h,al
    mov ax,Linear
    mov fs,ax    
    mov byte fs:[0B809Eh],0
    sti         ;Enable maskable interrupts
    jmp TimerTSS:0    ;TaskSwitch to timer

InitTSS:
    mov dword [ebx].EIPReg,eax
    mov dword [ebx].ESPReg,ebp
    mov dword [ebx].CSReg,Code32
    mov dword [ebx].SSReg,Data32
    mov dword [ebx].DSReg,Data32
    mov dword [ebx].ESReg,Data32
    ret

Task2Code:
    sti         ;Enable interrupts
    mov edi,0B8020h
    call PrintESP
    mov ax,Linear
    mov ds,ax
Task2Init2:
    mov edi,0B8080h ;Point edi to text video address
    mov dword [edi],07300730h   ;store initial 0's
    add edi,2
Task2Loop:
    mov al,byte [edi]
    inc al
    cmp al,57
    ja  Task2Incr
    mov byte [edi],al
    jmp Task2Loop
Task2Incr:
    mov al,byte [edi-2]
    inc al
    cmp al,57
    ja  Task2Init2
    mov byte [edi],48
    mov byte [edi-2],al
    jmp Task2Loop

Task3Code:
    sti
    mov edi,0B8000h
    call PrintESP
    mov ax,Linear
    mov ds,ax
Task3Init2:
    mov edi,0B8070h
    mov dword [edi],07300730h
    add edi,2
Task3Loop:
    mov al,byte [edi]
    inc al
    cmp al,57
    ja  Task3Incr
    mov byte [edi],al
    jmp Task3Loop
Task3Incr:
    mov ah,0
    mov al,byte [edi-2]
    inc al
    cmp al,57
    ja  Task3Init2
    mov byte [edi],48
    mov byte [edi-2],al
    jmp Task3Loop
TimerProcDone:
    clts
    jmp Code16:Enter16
TimerProcTaskSwitch:
    cmp byte [KeyFlag],2
    ja  TimerProcDone    
    mov esi,offset SysCounter
    inc byte [esi]
    movzx eax,word [TaskIndex]      ;load the task index
    add word [TaskIndex],2          ;advance to the next task
    mov ax,word [eax+TaskList]      ;get the selector indexed by TaskList
    test eax,eax                    ;If selector=zero,its end of the list
    jz  TimerProcEndOfList
    mov word [TaskAddr+4],ax        ;Store selector in the TaskAddr.
    cmp byte [esi],10
    jbe TimerProcTaskSwitchOK
    mov byte [esi],0
    mov ax,Linear
    mov fs,ax    
    xor byte fs:[0B809Eh],"*"
TimerProcTaskSwitchOK:              ;The offset is always zero
    mov byte [Tsk1TSS+5],89h        ;Reset busy bit for task 1
    mov byte [Tsk2TSS+5],89h        ;Reset bust bit for task 2
    jmp fword [TaskAddr]            ;Task switch using a jump
TimerProc:                          ;The interrupt enters through here
    mov al,20h                      ;Acknowledge the interrupt
    out 20h,al
    jmp TimerProcTaskSwitch
TimerProcEndOfList:
    mov word [TaskIndex],2          ;Reset the task index
    mov ax,word [TaskList]          ;Load first task
    mov word [TaskAddr+4],ax
    jmp fword [TaskAddr]
    jmp TimerProc

KeyHandler:
    push eax,ds
    mov ax,Data32
    mov ds,ax
    inc byte [KeyFlag]
    in  al,60h
    mov al,20h
    out 20h,al
    pop ds,eax
    iret

Unhandled0:
    mov bx,"00"
    jmp Unhandled
Unhandled1:
    mov bx,"01"
    jmp Unhandled
Unhandled2:
    mov bx,"02"
    jmp Unhandled
Unhandled3:
    mov bx,"03"
    jmp Unhandled
Unhandled4:
    mov bx,"04"
    jmp Unhandled
Unhandled5:
    mov bx,"05"
    jmp Unhandled
Unhandled6:
    mov bx,"06"
    jmp Unhandled
Unhandled7:
    mov bx,"07"
    jmp Unhandled
Unhandled8:
    mov bx,"08"
    jmp Unhandled
Unhandled9:
    mov bx,"09"
    jmp Unhandled
UnhandledA:
    mov bx,"0A"
    jmp Unhandled
UnhandledB:
    mov bx,"0B"
    jmp Unhandled
UnhandledC:
    mov bx,"0C"
    jmp Unhandled
UnhandledD:
    mov bx,"0D"
    jmp Unhandled
UnhandledE:
    mov bx,"0E"
    jmp Unhandled
UnhandledF:
    mov bx,"0F"
Unhandled:
    mov esi,offset UnHndMsg
    mov ax,Data32
    mov ds,ax
    mov ax,Linear
    mov es,ax
    mov edi,0B8000h
    mov ah,07
UnHndPrtLoop:
    lodsb
    stosw
    cmp byte [esi],0
    jnz UnHndPrtLoop
    mov al,bh
    stosw
    mov al,bl
    stosw
    jmp $

PrintESP:    
    mov eax,esp
    push es,ebx,ecx
    mov ebx,eax
    mov ax,Linear
    mov es,ax
    mov ah,7
    mov cl,8
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
    pop ecx,ebx,es
    ret
PrintESPAlpha:
    add al,7
    stosw
    dec cl
    jnz PrintESPLoop
    pop ecx,ebx,es
    ret
use16
Enter16:
    cli
    mov ax,Data16
    mov ds,ax
    mov ss,ax
    mov es,ax
    mov eax,cr0
    and al,0FEh
    mov cr0,eax
    jmp dword [RealAddr]
ExitPM:
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    lidt fword [BackIDT]
    mov al,0
    out 21h,al  ;Enable all maskable interrupts
    out 0A1h,al
    sti
    mov ah,4Ch
    int 21h
KeyFlag     db  0
SysCounter  dd  0
TaskIndex   dw  0
TaskList    dw  Task1TSS,Task2TSS,0
            dw  100 dup (0) ;100 more tasks
TaskAddr    dd  0   ;Address (must always be zero)
            dw  0   ;Selector

RealAddr    dd  0
BackIDT     df  0
UnHndMsg    db  "Unhandled interrupt ",0
UnHndMsgEnd:
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

SystemTSS   dw  103
            dw  0
            db  0
            db  89h
            db  0
            db  0

Tsk1TSS     dw  103
            dw  0
            db  0
            db  89h
            db  0
            db  0

Tsk2TSS     dw  103
            dw  0
            db  0
            db  89h
            db  0
            db  0
TmrTSS      dw  103
            dw  0
            db  0
            db  89h
            db  0
            db  0
GDTR        dw  $-GDT-1
            dd  0

IDT         dw  Unhandled0  ;int 0
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled1  ;int 1
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled2  ;int 2
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled3  ;int 3
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled4  ;int 4
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled5  ;int 5
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled6  ;int 6
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  Unhandled7  ;int 7
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  0           ;int 8
            dw  TimerTSS
            db  0
            db  85h
            dw  0

            dw  KeyHandler  ;int 9
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  UnhandledA  ;int 0A
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  UnhandledB  ;int 0A
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  UnhandledC  ;int 0A
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  UnhandledD  ;int 0A
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  UnhandledE  ;int 0A
            dw  Code32
            db  0
            db  8Eh
            dw  0

            dw  UnhandledF  ;int 0A
            dw  Code32
            db  0
            db  8Eh
            dw  0

IDTR        dw  $-IDT-1
            dd  0

TSS0    TSSStruc
TSS1    TSSStruc
TSS2    TSSStruc
TSS3    TSSStruc
            db  2048    dup (0)
TOS:
