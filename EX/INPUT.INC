;I originally made this file as part of MTDOS's keyboard routines. These
;routines are now almost useless since they are poorly coded.
;They can however be used for making programs fast.
;Do what ever you want with it.
;It is used by KB.APP to accept input from the user.
    mov     ah,4ch
    int     21h

GetInput:   ;es:di - destination
            ;cx-data limit in bytes
    push    ax,bx,dx,bp,si,ds,di,es
    mov     bp,cx
    test    cx,cx
    jnz     GetInputOK
    jmp     GetInputDone
GetInputOK:
    push    cs  ;we first store the input in an internal buffer
    pop     es  ;if the user presses ESC, the destination buffer isn't updated
    push    cs
    pop     ds
    xor     cx,cx
    call    GetCursor
    mov     word [InitXY],dx
    call    GetVideoMode
    mov     byte [VideoPage],bh
    mov     byte [VideoMode],al
    mov     cx,1011h
    call    SetCursorShape
    xor     cx,cx  ;buffer length so far
    xor     bx,bx  ;position of cursor in buffer
    mov     byte [Insert],1
    cld
GetInputLoop:
    xor     ax,ax
    int     16h
    test    al,al
    jz      GetInputExtendedKey
    cmp     al,1bh
    jz      GetInputExit
    cmp     al,18h
    jz      GetInputCopy
    cmp     al,16h
    jz      GetInputPaste
    cmp     al,8
    jz      GetInputBackSpace
    cmp     al,0dh
    jz      GetInputFinal
    cmp     word [SelEnd],0
    jnz     GetInputRemoveSelA
    cmp     al,9
    jz      GetInputTabKey
GetInputAlpha:
    cmp     bx,cx
    jnz     GetInputInsert
    cmp     cx,bp
    jae     GetInputLoop
    lea     di,[bx+InputBuffer]
    xor     ah,ah
    stosw
    mov     ah,0eh
    int     10h
    dec     di
    inc     cx
    inc     bx
    jmp     GetInputCheckScrolling
GetInputTabKey:
    mov     al,32
    jmp     GetInputAlpha
GetInputRemoveSelA:
    push    ax
    call    DeleteSelection
    pop     ax
    jmp     GetInputAlpha
GetInputFinal:
    jmp     GetInputCopyBuffer
GetInputExit:
    jmp     GetInputDone
GetInputRightKey:
    cmp     bx,cx
    jz      GetInputLoop
    call    GetKBFlags
    test    al,3
    jnz     GetInputSelRight
    inc     bx
    cmp     word [SelEnd],0
    jnz     GetInputResetSel
    jmp     GetInputUpdateCursor
GetInputResetSel:
    mov     word [SelEnd],0
    jmp     GetInputRePrintStr
GetInputLeftKey:
    test    bx,bx
    jz      GetInputLoop
    call    GetKBFlags
    test    al,3
    jnz     GetInputSelLeft
    dec     bx
    cmp     word [SelEnd],0
    jnz     GetInputResetSel
    jmp     GetInputUpdateCursor
GetInputDeleteKey:    
    cmp     word [SelEnd],0
    jnz     GetInputDeleteSelection
    cmp     bx,cx
    jnz     GetInputDeleteKey2
    jmp     GetInputLoop
GetInputDeleteKey2:
    lea     di,[bx+InputBuffer]
    lea     si,[di+1]
    push    cx
    push    di
    sub     cx,bx
    rep     movsb
    xor     al,al
    stosb
    pop     di
    pop     cx
    dec     cx
    jmp     GetInputRePrintStr
GetInputDeleteSelection:
    call    DeleteSelection
    jmp     GetInputRePrintStr
GetInputEndKey:
    call    GetKBFlags
    test    al,3
    jnz     GetInputEndSel
    mov     bx,cx
    cmp     word [SelEnd],0
    jnz     GetInputResetSel
    jmp     GetInputUpdateCursor
GetInputEndSel:
    cmp     word [SelEnd],0
    jnz     GetInputEndUpdateSel
    mov     word [SelStart],bx
    mov     bx,cx
    mov     word [SelEnd],bx
    jmp     GetInputRePrintStr
GetInputEndUpdateSel:
    cmp     word [SelEnd],bx
    jz      GetInputEndUpdateSel2
    mov     ax,word [SelEnd]
    mov     word [SelStart],ax
    mov     word [SelEnd],cx
    mov     bx,cx
    jmp     GetInputRePrintStr
GetInputEndUpdateSel2:
    mov     bx,cx
    mov     word [SelEnd],cx
    jmp     GetInputRePrintStr
GetInputBackSpace:
    test    bx,bx
    jnz     GetInputBackSpace2
    jmp     GetInputLoop
GetInputBackSpace2:
    mov     si,word [SelEnd]
    xor     ax,ax
    mov     word [SelEnd],ax
    dec     cx
    dec     bx
    lea     di,[bx+InputBuffer]
    cmp     bx,cx
    jnz     GetInputBackSpace3
    stosb
    test    si,si
    jnz     GetInputBackSpace4
    mov     ah,0eh
    int     10h
    mov     al,20h
    int     10h
    jmp     GetInputUpdateCursor
GetInputBackSpace3:
    lea     si,[di+1]
    push    cx
    sub     cx,bx
    rep     movsb
    stosb
    pop     cx
GetInputBackSpace4:
    jmp     GetInputRePrintStr
GetInputUpdateCursor:
    push    bx
    add     bl,byte [InitXY]
    adc     bh,0
    test    bh,bh
    jnz     GetInputTranslateXY
    cmp     bl,byte [MaxX]
    ja      GetInputTranslateXY
    mov     dl,bl
    mov     dh,byte [InitXY+1]
    call    SetCursor
    pop     bx
    jmp     GetInputLoop
GetInputTranslateXY:
    mov     ax,bx
    mov     bl,byte [MaxX]
    xor     bh,bh
    xor     dx,dx
    div     bx
    mov     dh,al
    add     dh,byte [InitXY+1]
    call    SetCursor
    pop     bx
    jmp     GetInputLoop
GetInputCopy:
    cmp     word [SelEnd],0
    jnz     GetInputCopy2
    jmp     GetInputLoop
GetInputCopy2:
    mov     di,offset ClipBoard
    push    cx
    mov     cx,word [SelEnd]
    sub     cx,word [SelStart]
    mov     word [ClipBoardLen],cx
    mov     si,word [SelStart]
    add     si,offset InputBuffer
    rep     movsb
    pop     cx
    jmp     GetInputLoop
GetInputPaste:    
    cmp     word [ClipBoardLen],0
    jnz     GetInputPaste2
    jmp     GetInputLoop
GetInputPaste2:
    mov     di,offset InputBuffer
    add     di,cx
    mov     si,word [ClipBoardLen]
    push    si
    add     si,cx
    cmp     si,bp
    pop     si
    jbe     GetInputPaste3
    jmp     GetInputLoop
GetInputPaste3:
    mov     dx,si
    mov     si,di
    push    cx
    test    cx,cx
    jz      GetInputPasteStr
    add     di,dx
    add     cx,dx
    sub     cx,bx
    std
    rep     movsb
    cld
GetInputPasteStr:
    lea     di,[bx+InputBuffer]
    mov     si,offset ClipBoard
    mov     cx,dx
    rep     movsb
    pop     cx
    add     cx,dx
    jmp     GetInputRePrintStr
GetInputHomeKey:
    call    GetKBFlags
    test    al,3
    jnz     GetInputHomeSel
    xor     bx,bx
    mov     di,offset InputBuffer
    cmp     word [SelEnd],0
    jnz     GetInputResetSel
    jmp     GetInputUpdateCursor
GetInputHomeSel:
    cmp     word [SelEnd],0
    jnz     GetInputHomeUpdateSel
    mov     word [SelEnd],bx
    xor     bx,bx
    mov     word [SelStart],bx
    jmp     GetInputRePrintStr
GetInputHomeUpdateSel:
    cmp     word [SelEnd],bx
    jz      GetInputUpdateCursor2
    xor     bx,bx
    mov     word [SelStart],bx
    jmp     GetInputRePrintStr
GetInputUpdateCursor2:
    mov     ax,word [SelStart]
    mov     word [SelEnd],ax
    xor     bx,bx
    mov     word [SelStart],bx
    jmp     GetInputRePrintStr
GetInputInsertKey:
    not     byte [Insert]
    push    cx
    test    byte [Insert],1
    jz      GetInputInsertOff
    mov     cx,1011h
    call    SetCursorShape
    pop     cx
    jmp     GetInputLoop
GetInputInsertOff:
    mov     cx,31   ;Overtype
    call    SetCursorShape
    pop     cx
    jmp     GetInputLoop
GetInputExtendedKey:
    cmp     ah,4bh
    jz      GetInputLeftKey
    cmp     ah,4dh
    jz      GetInputRightKey
    cmp     ah,52h
    jz      GetInputInsertKey
    cmp     ah,47h
    jz      GetInputHomeKey
    cmp     ah,53h
    jz      GetInputDeleteKey
    cmp     ah,4fh
    jz      GetInputEndKey
    jmp     GetInputLoop
GetInputInsert:    
    lea     si,[bx+InputBuffer-1]
    push    si
    test    byte [Insert],1
    jz      GetInputInsertWrite
    cmp     cx,bp
    jae     GetInputLoop
    push    cx
    sub     cx,bx
    add     si,cx
    lea     di,[si+1]
    std
    rep     movsb
    cld
    pop     cx
    inc     cx
GetInputInsertWrite:
    inc     bx
    pop     di
    inc     di    
    stosb
GetInputRePrintStr:
    call    CursorOff
    mov     dx,word [InitXY]
    call    SetCursor
    mov     si,offset InputBuffer
    cmp     word [SelEnd],0
    jnz     GetInputRePrintStrSel
    push    bx,cx
    mov     bl,byte [TextColor]
    call    PrintStrColor
    mov     ax,0920h
    mov     bl,7
    mov     bh,byte [VideoPage]
    mov     cx,word [BlankExtra]
    int     10h
    pop     cx,bx
    call    CursorOn
    jmp     GetInputCheckScrolling
GetInputRePrintStrSel:    
    push    cx,bx
    push    cx
    mov     cx,word [SelStart]
    mov     bl,byte [TextColor]
    call    PrintStrFixedColor
    add     si,cx
    mov     cx,word [SelEnd]
    sub     cx,word [SelStart]
    mov     bl,byte [SelColor]
    call    PrintStrFixedColor
    add     si,cx
    pop     cx
    sub     cx,word [SelEnd]
    mov     bl,byte [TextColor]
    call    PrintStrFixedColor
    pop     bx,cx
    call    CursorOn
GetInputCheckScrolling:
    mov     al,byte [InitXY]
    xor     ah,ah
    add     ax,cx               ;add the length
    push    cx
    call    GetCursor
    mov     cl,dh               ;save cursor y
    xor     dx,dx
    div     word [MaxX]         ;Divide by MaxX to get ax=cury-inity and dx=x
    add     al,byte [InitXY+1]
    cmp     cl,al
    jnz     GetInputHasScrolled
    pop     cx
    jmp     GetInputUpdateCursor
GetInputHasScrolled:    
    cmp     al,cl
    jbe     GetInputHasScrolled2
    cmp     byte [InitXY+1],0
    jz      GetInputHasScrolled2
    sub     al,cl
    sub     byte [InitXY+1],al
GetInputHasScrolled2:
    pop     cx
    jmp     GetInputUpdateCursor
GetInputSelLeft:
    cmp     word [SelEnd],0
    jz      GetInputNewLeftSel
    cmp     bx,word [SelStart]
    jnz     GetInputDecSelEnd
    dec     bx
    dec     word [SelStart]
    jmp     GetInputRePrintStr
GetInputDecSelEnd:
    dec     bx
    dec     word [SelEnd]
    jmp     GetInputRePrintStr
GetInputNewLeftSel:
    mov     word [SelEnd],bx
    dec     bx
    mov     word [SelStart],bx
    jmp     GetInputRePrintStr
GetInputSelRight:
    cmp     word [SelEnd],0
    jz      GetInputNewRightSel
    cmp     bx,word [SelEnd]
    jnz     GetInputIncSelStart
    inc     word [SelEnd]
    inc     bx
    jmp     GetInputRePrintStr
GetInputIncSelStart:
    inc     word [SelStart]
    inc     bx
    jmp     GetInputRePrintStr
GetInputNewRightSel:
    mov     word [SelStart],bx
    inc     bx
    mov     word [SelEnd],bx
    jmp     GetInputRePrintStr
GetInputCopyBuffer:
    pop     es,di
    push    di,es
    mov     si,offset InputBuffer
    push    cx
    rep     movsb
    pop     cx
    xor     al,al
    stosb
GetInputDone:
    pop     es,di,ds,si,bp,dx,bx,ax
    ret

DeleteSelection:
    mov     si,offset InputBuffer
    mov     di,si
    add     si,word [SelEnd]
    add     di,word [SelStart]
    push    cx
    mov     bx,word [SelStart]    
    mov     dx,word [SelEnd]
    sub     dx,bx
    mov     word [BlankExtra],dx
    sub     cx,word [SelStart]
    rep     movsb
    xor     al,al
    stosb
    mov     word [SelEnd],cx    ;Invalidate selection by zeroing SelEnd
    pop     cx
    sub     cx,dx
    ret

GetVideoMode:
    mov     ah,0fh
    int     10h
    ret

GetCursor:
    push    ax
    push    bx
    mov     ah,03h
    mov     bh,byte cs:[VideoPage]
    int     10h
    pop     bx
    pop     ax
    ret

SetCursor:
    push    ax
    push    bx
    mov     ah,02h
    mov     bh,byte cs:[VideoPage]
    int     10h
    pop     bx
    pop     ax
    ret

SetCursorShape:
    push    ax
    mov     ah,1
    int     10h
    pop     ax
    ret
CursorOff:
    push    cx
    call    GetCursor
    mov     word [CursorShape],cx
    mov     ch,00100000b
    call    SetCursorShape
    pop     cx
    ret

CursorOn:
    push    cx
    mov     cx,word [CursorShape]
    call    SetCursorShape
    pop     cx
    ret

KBInput:
    ret    


PrintStrColor:
    push    si,ax,cx
    mov     cx,1
    mov     bh,byte [VideoPage]
PrintStrColorLoop:
    lodsb
    test    al,al
    jz      PrintStrColorExit
    mov     ah,09h
    int     10h
    mov     ah,0eh
    int     10h
    jmp     PrintStrColorLoop
PrintStrColorExit:
    pop     cx,ax,si
    ret



PrintStrFixedColor:
    push    si,cx,dx,ax
    test    cx,cx
    jz      PrintStrFixedColorExit
    mov     dx,cx
    mov     bh,byte [VideoPage]
    mov     cx,1
PrintStrFixedColorLoop:
    mov     ah,09h
    lodsb
    int     10h
    mov     ah,0eh
    int     10h
    dec     dx
    jnz     PrintStrFixedColorLoop
PrintStrFixedColorExit:
    pop     ax,dx,cx,si
    ret


PrintRedirChar:
    ret    

PrintRedirStr:
    ret


GetKBFlags:
    mov     ah,2
    int     16h
    ret

PrintCharColor:
    push    bx
    mov     bh,byte cs:[VideoPage]
    mov     bl,byte cs:[VideoColor]
    mov     ah,09h
    int     10h
    pop     bx
    ret

Beep:
    push    ax
    mov     ax,0e07h
    int     10h
    pop     ax
    ret

VideoMode   db      0   ;global video mode
VideoPage   db      0   ;global video page
VideoColor  db      7   ;global video color
Redir       db      0   ;global redirection flag
NumCols     db      80  ;text screen columns
NumRows     db      24  ;text screen rows
CursorX     db      0   ;current screen cursorx
CursorY     db      0   ;current screen cursory
XPos        dw      0   ;global xpos
YPos        dw      0   ;global ypos
CursorSize  dw      0   ;global cursor size
;NumBuffer   db      13  dup (0)


CurX            dw  0
CurY            dw  0
SelStart        dw  0
SelEnd          dw  0

SelColor        dw  4*16
TextColor       dw  7
CursorShape     dw  1011h
Insert          db  0
BlankExtra      dw  1   ;Number of spaces to write after reprinting
ClipBoard       db  128 dup (0)
ClipBoardLen    dw  0   ;Length of string in clipboard
InputBuffer     db  128 dup (0)
MaxX            db  80
MaxY            db  0
InitXY          db  0
