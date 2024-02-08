;This program is a TSR (Terminate and Stay Resident). It stays in memory
;but when the General protection or Invalid OpCode exceptions occur, this
;program prints the error message and returns to DOS.
;Returning to DOS may fail for many reasons but this program performs its
;task quite fine but because your errors may cover a lot of areas including
;overwritting code with wrong data, assigning a wrong ESP,memory misuse or
;use of system memory.

mov ax,0    ;Reset AX could use xor ax,ax
mov ds,ax   ;DS=AX=0
cli         ;Disable interrupts, we are about to alter the IVT and
            ;No interrupt must execute in the process, the data maybe half
            ;ready causing a very good system crash
mov di,6*4 ;Calculate the position of vector for int 06 (Invalid Opcode)
mov word [di],offset myint06  ;Program the InvalidOpcode to vector to CS:MyInt
mov word [di][0002],cs

mov di,13*4 ;Calculate the position of vector for int 13 (General Protection)
mov word [di],offset myint13  ;Program the GP vector handler to CS:MyInt
mov word [di][0002],cs
sti         ;Reenable interrupts
mov dx,(ProgEnd+100h)    ;Number of bytes to allocate for this TSR
int 27h     ;TSR it!
MyInt06:
    mov word cs:[STDS],ds   ;Save program's DS
    push cs ;DS=CS
    pop  ds
    mov word [STDX],DX
    mov dx,offset InvalidOp
    jmp MyIntCommon
MyInt13:    ;GP Fault handler
    mov word cs:[STDS],ds   ;Save program's DS
    push cs ;DS=CS
    pop  ds
    mov word [STDX],DX
    mov dx,offset GPFault   ;Point to GPFault error message
MyIntCommon:

    mov word [STAX],AX  ;Save registers, we want to print them later
    mov word [STCX],CX
    mov word [STBX],BX
    mov word [STBP],BP
    mov word [STSI],SI
    mov word [STDI],DI
    mov word [STSS],SS
    mov word [STES],ES

    mov ah,9    ;Select function 9 print
    int 21h     ;MS-DOS print '$' terminated string
    cli         ;Disable interrupts
    pop word [STIP] ;Get the interrupted program's IP
    pop word [STCS] ;and CS
    pop word [STFlags] ;and FLAGS
    mov word [STSP],SP

    mov ax,[STCS]
    mov es,ax
    call PrintHex   ;Print CS
    mov ax,0Eh shl 8 or ":"
    int 10h
    mov ax,[STIP]   ;Print IP
    mov si,ax
    call PrintHex
    mov ax,0E20h
    int 10h
    call PrintLF    ;print new line
    mov dx,offset DumpAt
    mov ah,9
    int 21h
    mov cl,6    ;Number of instruction bytes to print
PrintBytesLoop:   
    seges       ;ES is the segment for the interrupted program
    lodsb       ;SI is pointing at IP
    push cx
    call PrintHexB  ;Print byte
    pop cx
    mov ax,0E20h    ;print space
    int 10h
    dec cl          ;decrease counter
    jnz PrintBytesLoop ;if it is not yet zero do loop
    call PrintLF    
    mov si,offset PrtTable  ;SI=PrtTable
PrintValues:
    lodsw   ;Get string (of register) address from table
    test ax,ax  ;Is it zero (end of table)?
    jz PrintEnd ;End if it is zero
    push si     ;Preserve SI
    mov si,ax   ;SI=AX=string of register
    call PrintStr   ;Print. PrintStr leaves SI pointing at the end of string
    lodsw       ;Get value for register
    call PrintHex   ;Print it
    pop si      ;Restore SI to next entry in table
    lodsw
    test ax,ax
    jz PrintEnd
    push si
    mov si,ax
    mov ax,0E20h    ;Print 4 spaces
    int 10h
    int 10h
    int 10h
    int 10h
    call PrintStr   ;Print the register string
    lodsw           ;Get value
    call PrintHex   ;Print it
    pop si
    call PrintLF    ;Print new line
    jmp PrintValues
PrintEnd:
    sti             ;reenable interrupts
    mov ax,4CFFh    ;Dos exit code
    int 21h         ;return to dos.

PrintLF:
    mov ax,0E0Dh
    int 10h
    mov al,0Ah
    int 10h
    ret

PrintStr:
    mov ah,0Eh
PrintStrLoop:
    lodsb
    test al,al
    jz PrintStrLoopDone
    int 10h
    jmp PrintStrLoop
PrintStrLoopDone:
    ret

PrintHexB:
    mov cx,0204h
    mov ah,al
    jmp PrintHex2
PrintHex:
    mov cx,0404h
PrintHex2:
    mov dx,ax
    push bx
    mov bx,offset HexTable
PrintHexLoop:
    rol dx,cl
    mov al,dl
    and al,0Fh
    xlat
    mov ah,0Eh
    int 10h
    dec ch
    jnz PrintHexLoop
    pop bx
    ret
InvalidOp   db  "Invalid Opcode/Instruction at :$"
GPFault db  "General protection fault at :$"
DumpAt  db  "Instruction bytes :$"
HexTable    db  "0123456789ABCDEF"
RegStr  db  "Registers:"
RegAX   db  "AX   :",0
    STAX    dw  0
RegCX   db  "CX   :",0
    STCX    dw  0
RegDX   db  "DX   :",0
    STDX    dw  0
RegBX   db  "BX   :",0
    STBX    dw  0
RegSP   db  "SP   :",0
     STSP    dw  0
RegBP   db  "BP   :",0
     STBP    dw  0
RegSI   db  "SI   :",0
     STSI    dw  0
RegDI   db  "DI   :",0
     STDI    dw  0
RegCS   db  "CS   :",0
     STCS    dw  0
RegDS   db  "DS   :",0
     STDS    dw  0
RegSS   db  "SS   :",0
     STSS    dw  0
RegES   db  "ES   :",0
     STES    dw  0
RegIP   db  "IP   :",0
     STIP    dw  0
RegFlags db "Flags:",0
    STFlags  dw  0
PrtTable    dw  RegAX,RegCX,RegDX,RegBX,RegSP,RegBP,RegSI,RegDI
            DW  RegCS,RegDS,RegES,RegSS,RegIP,RegFlags,0,0,0,0
ProgEnd:
