;This program enables the CMOS RTC clock interrupt. The interrupt vector
;is redirected to 70h by the BIOS and we don't change it.
;This program maybe harmful to your computer but I tested it thoroughly on
;mine and it worked quite fine.
;This program was tested on a 386 and worked quite fine. It works in
;real-mode.

cli         ;Disable ALL maskable interrupts
mov al,0FFh ;Mask all Maskable interrupts master and slave
out 021h,al ;Master
out 0A1h,al ;Slave

mov al,0Bh  ;CMOS Register B
out 70h,al  ;Tell CMOS we want to access it
in al,71h   ;Read Register B
or al,01000000b ;Set Bit 6=Periodic interrupt

mov ah,al   ;Save it in ah
mov al,0Bh  ;CMOS Register B
out 70h,al  ;Tell CMOS we want to access it
mov al,ah
out 71h,al  ;Write It!

mov al,0Ch  ;CMOS Register C
out 70h,al  ;Tell CMOS we want to access it
in al,71h   ;Read Register C
or al,01000000b ;Set Bit 7=Interrupt request

mov ah,al   ;Save it in ah
mov al,0Ch  ;CMOS Register C
out 70h,al  ;Tell CMOS we want to access it
mov al,ah
out 71h,al  ;Write It!

;mov al,0Ah ;CMOS Register A
;out 70h,al ;Tell CMOS we want to access it
;mov al,26h ;Change the interrupt intervals.
;out 71h,al ;Write value to CMOS register

    mov ax,0B800h
    mov es,ax                   ;Store initial zero in screen's first page
    mov word [es:0002h],700h    ;on the top left corner

push 0
pop es  ;ES=0
mov es:[70h*4],offset INT70h    ;Direct IVT offset modification
mov es:[70h*4+2],cs             ;Direct IVT segment modification
mov ax,cs
mov es,ax   ;ES=AX=CS
mov al,0    ;Unmask all interrupts
out 21h,al  ;Enable all interrupts in the master interrupt controller
mov al,0FEh ;Mask all interrupts except for te RTC clock interrupt
out 0A1h,al ;Enable RTC clock interrupt only in the slave interrupt contoller
sti         ;Enable ALL maskable interrupts
mov dx,(ProgEnd) ;This TSR's size
int 27h     ;Make TSR resident and quit

INT70h:
    push es,ax  ;Save ES,AX as they will change
    cli     ;Disable ALL maskable interrupts
    mov ax,0B800h   ;Text video segment
    mov es,ax   ;ES=AX=Text video
    and byte [es:0002h],0Fh ;Make sure it does not exceed char(15)
    inc byte [es:0002h]
    
    mov al,0Ch  ;Select CMOS Register C
    out 70h,al  ;Tell CMOS we want to access it
    in al,71h   ;Read it

    mov al,0x20h    ;Acknowledge interrupt command
    out 0x20h,al    ;Acknowledge master interrupt
    out 0xA0h,al    ;Acknowledge slave interrupt

    ;On my computer it did not work until I acknowledged the master (0x20)
    ;and slave (0xA0) controllers
    ;It also did not work without reading the CMOS Register C each time an
    ;interrupt is generated.

    pop ax,es       ;Restore AX and ES
    cli             ;Enable ALL maskable interrupts
    iret            ;Return to interrupted procedure
ProgEnd:    ;Program end. Determines how many bytes to keep resident in
            ;memory
