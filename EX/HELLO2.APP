;This program demonstates how to work with data when you don't know what
;the base address of the program is.
;It prints a 'Hello World!' message on screen

    org 0   ;We assume base is zero, but we will calculate it
call StartAddr  ;This call pushes the IP on stack
StartAddr:
    pop si      ;Pop SI to get the address of startaddr
    mov ax,cs   ;make sure DS=CS. Thats were our data is
    mov ds,ax
    add si,offset HelloMsg-3    ;-3 because the call above occupies 3-bytes
    cmp byte [si],0
    jz PrintDone
    mov ah,0Eh
PrintLoop:
    lodsb
    int 10h
    cmp byte [si],0
    jnz PrintLoop
PrintDone:
    mov ax,4C00h
    int 21h
HelloMsg    db  "Hello World!",0
