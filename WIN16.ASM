
ProcessCmd:
        xor     dx,dx
        mov     cx,dx
        mov     word [Temp1],dx
        mov     si,word [CmdLine]
        mov     ds,word [PSPSeg]
        mov     di,offset StrBuffer
        mov     bx,offset LCaseTable
ProcessLCase:
        lodsb
        test    al,al
        jz  ProcessCaseOK
        xlat    byte es:[bx]
        stosb
        jmp ProcessLCase
ProcessCaseOK:
        mov     ax,AsmData
        mov     ds,ax
        cmp     byte [StrBuffer],0
        jz      CmdEnd
        mov     si,offset StrBuffer
        mov     di,offset Temp1
    CmdGetChar:
        lodsb
        cmp     al,20h
        jz      CmdGetNext
        cmp     al,"-"
        jz      CmdSwitch
        cmp     al,"/"
        jz      CmdSwitch
        cmp     al,0Dh
        jbe     CmdEnd
        test    cx,cx
        jz      CmdGetNewParam
        inc     cx
        jmp     CmdGetChar
    CmdEnd:
        mov     ax,cx
        stosw
        ret
    CmdGetNewParam:
        mov     ax,si
        dec     ax
        stosw
        inc     cx
        inc     dx
        jmp     CmdGetChar
    CmdGetNext:
        test    cx,cx
        jz      CmdGetChar
        mov     ax,cx
        stosw
        xor     cx,cx
        jmp     CmdGetChar
    CmdSwitch:
        lodsb
        mov     ah,byte [si]
        inc     si
        cmp     ax,"+w"
        jz      CmdShowSuppWarn
        cmp     ax,'sc'
        jz      CmdCaseOn
        cmp     ax,'sj'
        jz      CmdShortJump
        cmp     ax,'nj'
        jz      CmdNearJump
        cmp     ax,'oj'
        jz      CmdOptimizeJumps
        cmp     ax,'co'
        jz      CmdOptimizeCond
        cmp     ax,'uo'
        jz      CmdOptimizeUCond
        cmp     ax,'la'
        jz      CmdLinkFile
        cmp     ax,'zm'
        jz      CmdMZEXE
        jmp     CmdSwitch2
CmdShowSuppWarn:
        or      byte [AsmFlags2][1],1
        jmp     CmdGetChar
CmdCaseOn:
        jmp     CmdGetChar
CmdShortJump:
        mov     byte [DefJmpSize],ShortJmp
        jmp     CmdGetChar
CmdNearJump:
        mov     byte [DefJmpSize],NearJmp
        jmp     CmdGetChar
CmdOptimizeCond:
        mov     byte [CJmpSettingMask],0
        mov     byte [EAMask],0FCh
        jmp     CmdGetChar
CmdOptimizeJumps:
        mov     byte [CJmpSettingMask],0
CmdOptimizeUCond:
        mov     byte [EAMask],0FCh
        mov     byte [JmpSettingMask],0
        jmp     CmdGetChar
CmdCreateListing:
CmdLinkFile:
        jmp     CmdGetChar
CmdMZEXE:
        mov     byte [OutFormat],OutMZ
        jmp     CmdGetChar

CmdPartEXE:
        lodsb
        cmp     al,'e'
        jz      CmdMZEXE
        xor     cx,cx
        ret
CmdPartOMF:
        lodsb
        cmp     al,"f"
        jnz     CmdFail
        jmp     CmdPartObj2
CmdPartELF:
        lodsb
        cmp     al,'f'
        jnz     CmdFail
        lodsw
        mov     bl,OutELF64
        cmp     ax,'64'
        jz      CmdFormatOK
        mov     bl,OutELF32
        cmp     ax,'23'
        jz      CmdFormatOK
        sub     si,2
CmdFormatOK:
        mov     byte [OutFormat],bl
        jmp     CmdGetChar
CmdPartObj:
        lodsb
        cmp     al,'j'
        jnz     CmdFail
CmdPartObj2:
        lodsw
        mov     bl,OutOMF32
        cmp     ax,'23'
        jz      CmdFormatOK
        mov     bl,OutOMF64
        cmp     ax,'46'
        jz      CmdFormatOK
        mov     bl,OutOMF16
        cmp     ax,'61'
        jz      CmdFormatOK
        sub     si,2
        jmp     CmdFormatOK
CmdSwitch2:
        cmp     ax,'xe'
        jz      CmdPartEXE
        cmp     ax,'le'
        jz      CmdPartELF
        cmp     ax,'bo'
        jz      CmdPartObj
        cmp     ax,'mo'
        jz      CmdPartOMF
        cmp     ax,'ep'
        jz      CmdPartPE
        cmp     ax,'oc'
        jz      CmdPartCOFF
CmdFail:
        xor     cx,cx
        ret
CmdPartCOFF:
        lodsw
        cmp     ax,'ff'
        jnz     CmdFail
        lodsw
        mov     bl,OutCOFF16
        cmp     ax,'61'
        jz      CmdFormatOK
        mov     bl,OutCOFF64
        cmp     ax,'64'
        jz      CmdFormatOK
        mov     bl,OutCOFF32
        cmp     ax,'23'
        jz      CmdFormatOK
        sub     si,2
        jmp     CmdFormatOK
CmdPartPE:
        lodsw
        mov     bl,OutNE16
        cmp     ax,'61'
        jz      CmdFormatOK
        mov     bl,OutPE64
        cmp     ax,'64'
        jz      CmdFormatOK
        mov     bl,OutPE32
        cmp     ax,'23'
        jz      CmdFormatOK
        sub     si,2
        jmp     CmdFormatOK        

ExitProg:
        mov     ah,4ch
        mov     al,[Error]
        int     21h

GetFreeMem:
        call    GlobalAlloc,LMEM_MOVEABLE+LMEM_ZEROINIT,0FFFFh,0FFFFh
        mov cl,4
        shr bx,cl
        inc bx
        ret

AllocateMem:
        mov cl,4
        shl bx,cl
        dec bx
        call    GlobalAlloc,LMEM_MOVEABLE+LMEM_ZEROINIT,0,bx
        cmp ax,1
        ret

FreeMem:
        call    GlobalFree,ax
        ret

PrintChar:
        push    es,di
        push    ds
        pop     es
        mov     di,word [PrintPtr]
        cmp     al,0Dh
        jz      PrintCharFlush
        cmp     al,0Ah
        jz      PrintCharDone
        stosb
        cmp     di,offset PrintBuffer+256
        ja      PrintCharFlush
        inc     word [PrintPtr]
PrintCharDone:
        pop     di,es
        ret
PrintCharFlush:
        call    PrintFlush
        mov     word [PrintPTR],di
        pop     di,es
        ret

ClearScreen:
        push    es
        call    SendMessage,[hOutput],LB_RESETCONTENT,0,0,0
        pop     es
        ret

DosPathNotFound:
        mov     si,offset _PathNotFound
        jmp     DosPrintError
DosTooManyFiles:
        mov     si,offset _TooManyFiles
        jmp     DosPrintError
DosAccessDenied:
        mov     si,offset _AccessDenied
        jmp     DosPrintError
DosInvalidDrive:
        mov     si,offset _InvalidDrive
        jmp     DosPrintError
DosFileNotFound:
        mov     si,offset _FileNotFound
DosPrintError:
        push    bx
        cmp     word [AsmStack],0
        jnz     DosPrintError2
        call    PrintStr
        jmp     DosPrintError3
DosPrintError2:
        call    PrintError
DosPrintError3:
        pop     si
        call    PrintStr
DosPrintErrorLF:
        call    PrintLF
        ret

PrintFileError:
        mov     bx,AsmData
        mov     ds,bx
        mov     byte [Error],QuitError
        mov     bx,dx
        cmp     word [AsmStack],0
        jnz     PrintFileError2
        push    ax,bx
        mov     si,offset FatalTxt
        call    PrintStr
        pop     bx,ax
        inc     word [NumErrors]
PrintFileError2:
        cmp     al,2
        jz      DosFileNotFound
        cmp     al,3
        jz      DosPathNotFound
        cmp     al,4
        jz      DosTooManyFiles
        cmp     al,6
        jz      DosAccessDenied
        cmp     al,15
        jz      DosInvalidDrive
        inc     word [NumErrors]
        push    ax
        mov     si,offset Err
        call    PrintStr
        pop     ax
        xor     dx,dx
        call    PrintInt
        call    PrintLF
        ret

GetSysTime:
        mov     ah,2Ch
        int     21h
        ret

GetSysDate:
        mov     ah,2Ah
        int     21h
        ret

DoEvents:        
        call    PeekMessage,AsmData,offset msgw,0,0,0,PM_REMOVE
        test    ax,ax
        jz      DoEventsOK
        call    TranslateMessage,AsmData,offset msgw
        call    DispatchMessage,AsmData,offset msgw
        jmp DoEvents
        ret
DoEventsOK:
        ret

InitFont:
    call    GetStockObject,SYSTEM_FONT
    call    GetObject,ax,(SIZE LOGFONT),ds,offset lf
    mov word lf.lfWeight,FW_THIN
    mov word lf.lfHeight,12
    mov di,offset lf.lfFaceName
    mov si,offset _SanSerif
    push    ds
    pop es
    mov cx,7
    rep movsw
    call    CreateFontIndirect,ds,offset lf
    mov hFont,ax
    ret
