;This program is used by TASK2.APP to handle exceptions. Special handling
;of single step in V86 and GP is given
Unhandled0:
    mov bx,"00"
    jmp Unhandled
Unhandled1:
    test byte [esp+10],2
    jnz V86SingleStep
    mov bx,"01"
    jmp Unhandled

V86SingleStep:
    push ebp
    mov ebp,esp
    push eax,edi,ds
    mov edi,0B8000h
    mov ax,Linear
    mov ds,ax
    mov eax,dword [ebp+8]
    shl eax,4
    add eax,dword [ebp+4]
    mov eax,dword [eax]
    call PrintEAX
    mov eax,500000h ;adjust this to suite your machine
V86Delay:
    dec eax
    jnz V86Delay
    pop ds,edi,eax
    pop ebp
    iret

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
UnhandledE:
    mov bx,"0E"
    jmp Unhandled
UnhandledF:
    mov bx,"0F"
Unhandled:
    mov esi,offset UnHndMsg
    mov edi,0B8000h
    mov ax,Data32
    mov ds,ax
    mov ax,Linear
    mov es,ax
    call PrintStr

    mov al,bh
    stosw
    mov al,bl
    stosw
    mov al,20h
    stosw

    mov eax,dword [esp+4]
    mov  ecx,eax
    call PrintEAX

    mov byte es:[edi][-2],":"

    mov eax,dword [esp]
    shl ecx,4
    add ecx,eax
    call PrintEAX

    mov eax,dword es:[ecx]
    call PrintEAX

    clts
    jmp Code16:Enter16


GPFaultHnd:
    cli
    add esp,4   ;Ignore error code
    test byte [esp+10],2
    jnz GPFaultV86
GPFault2:    
    mov cx,Data32
    mov ds,cx
    mov esi,offset GPFault
    mov edi,0B8000h
    call PrintStr

    mov ax,Linear
    mov es,ax

    mov eax,dword [esp+4]
    mov ecx,eax
    call PrintEAX

    mov byte es:[edi][-2],":"

    mov eax,dword [esp]
    shl ecx,4
    add ecx,eax
    call PrintEAX

    mov esi,offset DumpBytes
    call PrintStr

    mov eax,dword es:[ecx]
    call PrintEAX

    jmp Code16:Enter16

GPFaultV86:
    push ebp
    mov ebp,esp
    push ds,eax,edi
    mov ax,Linear
    mov ds,ax
    mov eax,dword ss:[ebp+8]
    shl eax,4
    add eax,dword ss:[ebp+4]
    mov eax,dword [eax]
    cmp al,0CDh
    jz  V86Interrupt
    cmp al,0CCh
    jz  V86Int3
    pop edi,eax,ds
    pop ebp
    jmp GPFault2
V86Int3:
    mov ah,3
    dec word [ebp+4]
V86Interrupt:
    push eax
    mov edi,dword [ebp+20]
    shl edi,4
    add edi,dword [ebp+16]
    sub dword [ebp+16],6
    sub edi,6

    mov ax,word [ebp+8]
    shl eax,16    
    mov ax,word [ebp+4]
    add ax,2

    mov dword [edi],eax
    mov eax,[ebp+12]
    mov word [edi+4],ax
    pop eax
    movzx eax,ah
    shl eax,2
    movzx edi,word [eax]
    mov dword [ebp+4],edi
    mov ax,word [eax+2]
    mov word [ebp+8],ax
    pop edi,eax,ds
    pop ebp
    iret
