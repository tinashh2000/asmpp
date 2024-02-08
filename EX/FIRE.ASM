; fire.asm     Com file VERY REALISTIC
; Fire simulation, good for demos  - by Tenie Remmel   6/7/2002
;
; Modifications by Andrew Kennedy
;
;    Machine Independent Delay added
;    Tested on :  AMD K6-2 475 Mhz  AMD Athlon(tm) Processor  849.9 MHz

.Model Tiny

.code

Org 100h

begin:
        jmp   start

;************* Custom palette        240
Pal         db 0,0,0,0,0,2,0,0,4,0,0,6,0,0,8,0,0,10,0,0,12,0,0,14

            db 0,0,16,2,0,14,4,0,12,6,0,10,8,0,8,10,0,6,12,0,4,14

            db 0,2,16,0,0,19,0,0,22,0,0,25,0,0,28,0,0,31,0,0,34,0,0

            db 37,0,0,39,0,0,42,0,0,45,0,0,48,0,0,51,0,0,54,0,0,57
            db 0,0,60,0,0,63,0,0,63,2,0,63,5,0,63,7,0,63,10,0,63,13
            db 0,63,15,0,63,18,0,63,21,0,63,23,0,63,26,0,63,28,0,63
            db 31,0,63,34,0,63,36,0,63,39,0,63,42,0,63,44,0,63,47,0
            db 63,49,0,63,52,0,63,55,0,63,57,0,63,60,0,63,63,0,63
            db 63,2,63,63,5,63,63,7,63,63,10,63,63,13,63,63,15,63
            db 63,18,63,63,21,63,63,23,63,63,26,63,63,28,63,63,31
            db 63,63,34,63,63,36,63,63,39,63,63,42,63,63,44,63,63
            db 47,63,63,49,63,63,52,63,63,55,63,63,57,63,63,60

PalDB       db 528 dup(?)           ;Last part of palette
RandNum     dd 0                    ;Random number

start:

            mov ax,13h              ;Set video mode 13h
            int 10h
            mov dx,03D4h            ;Set bigger pixels
            mov ax,4209h
            out dx,ax

            mov di,offset PalDB     ;Set last part of palette
            mov al,03Fh
            mov cx,528
            rep stosb

            mov dx,3c8h             ;Set custom palette
            xor al,al
            out dx,al
            inc dx
            mov cx,768
            mov si,offset Pal
            rep outsb

            mov ax,cs               ;Get extra segments
            add ax,1000h
            mov fs,ax
            add ax,1000h
            mov gs,ax

            push fs                 ;Clear frame 1
            pop es
            xor di,di
            xor eax,eax
            mov cx,8000
            rep stosd
    
            push gs                 ;Clear frame 2
            pop es
            xor di,di
            mov cx,8000
            rep stosd

MainLoop:   push fs gs              ;DS = frame 1
            pop es ds               ;ES = frame 2
            mov si,321              ;SI = (1, 1), DI = (1, 0)
            mov di,1                ;this makes it move up
            mov cx,31678            ;CX = count
            
CalcLoop:   mov al,[si-1]           ;AX = average of the four
            xor ah,ah               ;surrounding pixels
            add al,[si+1]
            adc ah,0
            add al,[si]
            adc ah,0
            add al,[si+320]
            adc ah,0
            shr ax,2

            cmp ax,1                ;Decrement if it isn't zero
            adc ax,-1

            stosb                   ;Write pixel
            inc si                  ;Advance pointer
            dec cx                  ;Loop back
            jnz CalcLoop

            mov di,31360            ;DI = 3rd-to-last row
            mov cx,320              ;320 pixels
            mov cs:eax,[RandNum]    ;EAX = random number
                
RandLoop1:  imul eax,69069          ;Set top row random pixel
            inc eax
            mov bl,ah
            and bl,31
            add bl,50
            mov es:[di-320],bl

            imul eax,69069          ;Set middle row random pixel
            inc eax
            mov bl,ah
            and bl,31
            add bl,70
            mov es:[di],bl

            imul eax,69069          ;Set bottom row random pixel
            inc eax
            mov bl,ah
            and bl,31
            add bl,100
            mov es:[di+320],bl

            inc di                  ;Next pixel
            loop RandLoop1          ;Loop back

            imul eax,69069          ;CL = random value
            inc eax
            mov cl,al
            and cx,15
            mov si,31360            ;SI = 3rd-to-last row
    
RandLoop2:  imul eax,69069          ;Get random number
            inc eax
            push ax                 ;DI = random position
            xor dx,dx               ;from 0 to 320
            mov bx,320
            div bx
            mov di,dx
            pop ax
            add di,si
            xor bl,bl               ;BL = 0FFh
            dec bl
            mov es:[di-319],bl      ;Draw a 3x3 square
            mov es:[di-320],bl
            mov es:[di-321],bl
            mov es:[di-1],bl
            mov es:[di],bl
            mov es:[di+1],bl
            mov es:[di+319],bl
            mov es:[di+320],bl
            mov es:[di+321],bl
            loop RandLoop2          ;Loop back

            mov cs:[RandNum],eax    ;Save random number
    
            push 0A000h,gs          ;ES = 0A000h
            pop ds,es               ;DS = frame 2
            xor si,si               ;Set up for blit
            mov di,10880
            mov cx,8000             ;100 lines
            rep movsd

            push fs,gs              ;Swap frames
            pop  fs,gs

            mov          ah,0   ; function no. for read
            int          1ah    ; get the time of day count
            add          dx,1   ; add .05 seconds (one eighteenth of a second
                                ; delay)

            mov          bx,dx  ; to low word and then store end of delay
                                ; value in bx
xrepeat:                            
            int          1ah      ; read time again 
            cmp          dx,bx
            jne          xrepeat

            mov ah,1                ;Check for a key
            int 16h

            jz MainLoop             ;Loop back
    
            xor ah,ah               ;Eat the key
            int 16h
            mov ax,3                ;Restore video mode
            int 10h
            mov  ax,4c00h
            int  21h
     
End  begin
