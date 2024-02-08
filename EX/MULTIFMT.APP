;This code demostrates the use of the FORMAT directive to create many
;output files in the same source file.
;After each FORMAT directive, the symbol table and many settings are erased.
;Read the manual to find out about how you can use multiple FORMAT directives
;without clearing settings or selectively clearing settings.

option insane 0011h ;Turn on bit 0 and 5 of the options. Enable
                    ;extended options & enable multiple formats in a single
                    ;file

format mz
option out 'outfile1.exe'
stack 64
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov si,offset HelloMsg
    mov ah,0Eh
    cmp byte [si],0
    jz  PrintDone
PrintLoop:
    lodsb
    int 10h
    cmp byte [si],0
    jnz PrintLoop
PrintDone:
    mov ah,4Ch
    int 21h
HelloMsg    db  "Hello World output 1",13,10,0

format mz
option out 'outfile2.exe'
stack 64
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov si,offset HelloMsg
    mov ah,0Eh
    cmp byte [si],0
    jz  PrintDone
PrintLoop:
    lodsb
    int 10h
    cmp byte [si],0
    jnz PrintLoop
PrintDone:
    mov ah,0
    int 16h
    mov ah,4Ch
    int 21h
HelloMsg    db  "Hello world output 2",13,10
            db  "Press a key to quit",13,10,0
