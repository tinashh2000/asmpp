TaskStateStruc  struc
        SaveAX      dw  0
        SaveBX      dw  0
        SaveCX      dw  0
        SaveDX      dw  0
        SaveSP      dw  0
        SaveBP      dw  0
        SaveSI      dw  0
        SaveDI      dw  0
        SaveES      dw  0
        SaveDS      dw  0
        SaveSS      dw  0
        SaveIP      dw  0
        SaveCS      dw  0
        SaveFlags   dw  0
TaskStateSize   equ $
TaskStateStruc ends
        cli
        mov     ax,cs
        mov     es,ax
        xor     ax,ax
        mov     ds,ax
        mov     si,8*4
        push    si
        mov     di,offset OldInt8
        movsw
        movsw
        mov     es,ax
        pop     di
        mov     ax,offset TimerProc
        stosw
        mov     ax,cs
        stosw
        mov     ds,ax
        mov     es,ax
        mov     cx,-2
        sti
        mov     bx,offset Task1
        call    InstallNewTask
        mov     bx,offset Task2
        call    InstallNewTask
        mov     bx,offset Task3
        call    InstallNewTask
        jmp     Task1
        
TimerProc:
        push    ax
        xor     ax,ax
        add     word cs:[SystemCounter],1
        adc     word cs:[SystemCounter][0002],ax
        inc     word cs:[TaskCounter]
;        cmp     word cs:[TaskCounter],1
;        jbe     TimerExit
        cmp     word cs:[NumTasks],1
        jz      TimerExit
        mov     word cs:[TaskCounter],ax
        jmp     TaskSwitch
TimerExit:
        mov     al,20h
        out     20h,al
        pop     ax
        iret
TaskSwitch:
        mov     al,20h  ;Acknowledge the interrupt
        out     20h,al
        cli
        push    dx
        mov     dx,TaskStateSize
        mov     ax,word cs:[TaskNumber]
        mul     dx
        pop     dx
        xchg    ax,bx
        add     bx,offset TaskStateBuffer
        mov     word cs:[bx][SaveDS],ds        
        mov     word cs:[bx][SaveBX],ax
        mov     ax,cs
        mov     ds,ax
        pop     ax
        mov     word [bx][SaveAX],ax
        mov     word [bx][SaveCX],cx
        mov     word [bx][SaveDX],dx
        mov     word [bx][SaveBP],bp
        mov     word [bx][SaveSI],si
        mov     word [bx][SaveDI],di
        mov     word [bx][SaveES],es
        mov     word [bx][SaveSS],ss
        pop     word [bx][SaveIP]
        pop     word [bx][SaveCS]
        pop     word [bx][SaveFlags]
        mov     word [bx][SaveSP],sp
        mov     ax,word [TaskNumber]
        inc     ax
        cmp     ax,word [NumTasks]
        jb      TaskNumberOK
        xor     ax,ax

TaskNumberOK:
        mov     word [TaskNumber],ax
        mov     dx,TaskStateSize
        mul     dx
        mov     bx,ax
        add     bx,offset TaskStateBuffer
        mov     ax,word [bx][SaveAX]
        mov     cx,word [bx][SaveCX]
        mov     dx,word [bx][SaveDX]
        mov     sp,word [bx][SaveSP]
        mov     bp,word [bx][SaveBP]
        mov     si,word [bx][SaveSI]
        mov     di,word [bx][SaveDI]
        mov     es,word [bx][SaveES]
        mov     ss,word [bx][SaveSS]
        push    word [bx][SaveFlags]
        push    word [bx][SaveCS]
        push    word [bx][SaveIP]
        mov     ds,word [bx][SaveDS]
        mov     bx,word cs:[bx][SaveBX]
        push    ax
        mov     al,20h
        out     20h,al
        pop     ax
        sti
        iret

Task1:
        mov     ax,0B800h
        mov     es,ax
        mov     ah,08h
        mov     al,48
        mov     byte cs:[SystemCounter],0
        sti
        xor     cx,cx
Task1Loop:
        mov     word es:[0000],ax
        inc     al
        cmp     al,58
        jb      Task1Loop
        jmp     Task1

Task2:        
        mov     ax,0B800h
        mov     es,ax
        mov     ah,0fh
        mov     al,48
        mov     byte cs:[SystemCounter],0
        sti
        xor     cx,cx
Task2Loop:
        mov     word es:[0002],ax
        inc     al
        cmp     al,58
        jb      Task2Loop
        jmp     Task2

Task3:
        mov     ax,0B800h
        mov     es,ax
        mov     ah,07
        mov     al,48
        mov     byte cs:[SystemCounter],0
        sti
        xor     cx,cx
Task3Loop:
        mov     word es:[0004],ax
        inc     al
        cmp     al,58
        jb      Task3Loop
        jmp     Task3

TaskStateBuffer     db      TaskStateSize*5 dup(0)

SystemCounter       dd      0
TaskCounter         dd      0
TaskNumber          dw      0
NumTasks            dw      0
OldInt8             dd      0

InstallNewTask:
        mov     ax,word [NumTasks]
        mov     dx,TaskStateSize
        mul     dx
        mov     si,ax
        mov     word [si][TaskStateBuffer][SaveCS],ds
        mov     word [si][TaskStateBuffer][SaveDS],ds
        mov     word [si][TaskStateBuffer][SaveES],es
        mov     word [si][TaskStateBuffer][SaveSS],ss
        mov     word [si][TaskStateBuffer][SaveSP],cx
        mov     word [si][TaskStateBuffer][SaveIP],bx
        pushf
        pop     ax
        mov     word [si][TaskStateBuffer][SaveFlags],ax
        inc     word [NumTasks]
        ret
