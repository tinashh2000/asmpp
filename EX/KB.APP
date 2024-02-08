;I originally created this file to compose some monophonic tones that I
;could use to compose some songs or just play it for fun.
;Any note plays a tune. Initially 'Q' plays C and 'T' plays G,'7' plays
;A#. You can modify it in any way you like.
;It can record (F1),replay(F3),save(F4) and restore(F5) some music.

;format mz
;    org 100h
        jmp     start        
        oldint8     dd      0
        ticks       dd      0
        keys        db      "q2w3er5t6y7ui9o0p[=]",8
                    db      "zsxcfvgbnjmk,l./'"
        sounds      dw      131,140,146,156,165,175,185,196,207,220,235,245,0
;        sounds      dw        66, 70, 73, 78, 82, 87, 92, 98,103,110,117,122,0
        ;                   c   c    d   d  e   f   f   g   g   a   a   b
        mmm         dw      131,146
        trans       db      "Transpose     ",0
        octav       db      "Octave        ",0
        note        db      "Note          ",0
        stat        db      "Status        ",0
        state       db      0
        msgs        db      "********************************",13,10
                    db      "UP/DOWN       Transpose",13,10
                    db      "F1            Record",13,10
                    db      "F2            Play Only",13,10
                    db      "F3            Replay",13,10

        replaystr   db      "Replaying",13,10,0
        recordstr   db      "Recording",13,10,0
        playstr     db      "Playing  ",13,10,0
        transpose   dw      24
        octave      dw      0
        minfreq     dw      0
        sndlen      dw      0
        notes       db      "C C#D D# E F F#G G#A A#B "
        include     prt16.inc
        include     input.inc
start:
        mov     ax,305h
        xor     bx,bx
        int     16h
        mov     ax,cs
        mov     ds,ax
        mov     es,ax
        mov     ax,3
        int     10h
        call    init_speaker
        call    install_new_timer
        call    upd_scr
mainprog_init:
        mov     byte [state],0
        call    upd_scr
        call    stop_sound
mainprog:
        call    waitkey
        test    al,al
        jz      mainprog_ext
        cmp     al,1bh
        jz      snd_quit
        call    play_key
        jmp     mainprog
play_key:
        mov     cx,(sounds-keys)
        mov     di,offset keys
        repnz   scasb
        jnz     play_key_quit
        sub     di,offset keys
        dec     di
        add     di,word ptr [transpose]
        mov     ax,word ptr [Octave]
        mov     bx,12
        mul     bx
        add     di,ax
        mov     ax,di
        xor     dx,dx
        cmp     di,12
        jb      find_interpret_key
        mov     di,12
        div     di
        xchg    ax,dx
find_interpret_key:
        mov     di,ax
        shl     di,1
        mov     ax,word ptr [di+sounds]
        mov     cl,dl
        shr     ax,1
        shl     ax,cl
        push    ax
        call    stop_sound
        pop     ax
        call    play_sound
        call    upd_scr
play_key_quit:
        ret
mainprog_ext:
        cmp     ah,48h
        jz      transpose_up
        cmp     ah,50h
        jz      transpose_down
        cmp     ah,4Dh
        jz      OctaveUp
        cmp     ah,4Bh
        jz      OctaveDown
        cmp     ah,3bh
        jz      record_sound
        cmp     ah,3dh
        jz      replay_sound
        cmp     ah,3ch
        jz      mainprog
        cmp     ah,3eh
        jz      writesound_file
        cmp     ah,3fh
        jz      getsound_file
        call    stop_sound
        cmp     byte [state],1
        jz      record_nosound
_return:
        cmp     byte [state],0
        jz      mainprog
        cmp     byte [state],1
        jz      record_loop
        jmp     replay_sound_loop
OctaveUp:
        cmp     byte [Octave],8
        jae     _return
        inc     byte [Octave]
        call    upd_scr
        cmp     byte ptr [state],1
        jz      record_octave_up
        jmp     _return
OctaveDown:
        cmp     byte [Octave],0
        jz      _return
        dec     byte [Octave]
        call    upd_scr
        cmp     byte ptr [state],1
        jz      record_octave_down
        jmp     _return
record_octave_up:
        cmp     di,offset mybuf+2
        mov     ax,04feh
        stosw
        jbe     record_loop
        mov     al,[di-5]
        push    di
        call    play_key
        pop     di
        jmp     record_loop        
record_octave_down:
        cmp     di,offset mybuf+2
        mov     ax,05feh
        stosw
        jbe     record_loop
        mov     al,[di-5]
        push    di
        call    play_key
        pop     di
        jmp     record_loop
record_nosound:
        mov     ax,03FEh
        stosw
        jmp     record_loop
writesound_file:
        call    WriteSndFile
        jmp     mainprog_init
getsound_file:
        call    ReadSndFile
        jmp     mainprog_init
record_sound:
        mov     byte [state],1
        call    upd_scr
        mov     di,offset mybuf
record_loop:
        mov     word cs:[ticks],0
        call    waitkey
        mov     cx,word cs:[ticks]
        mov     word [di],cx
        add     di,2
        test    al,al
        jz      mainprog_ext
        cmp     al,1bh
        jz      recordloop_done
        stosb
        push    di
        call    play_key
        pop     di
        jmp     record_loop        
recordloop_done:
        mov     al,0ffh
        stosb
        lea     cx,[di-mybuf]
        mov     word [SndLen],cx
        jmp     mainprog_init
replay_sound:
        mov     byte [state],2  ;replaying
        call    upd_scr
        mov     si,offset mybuf
replay_sound_loop:
        mov     ah,1
        int     16h
        jnz     replay_sound_int
        lodsw
        mov     word [ticks],0
        mov     bx,ax
replay_delay:
replay_delay2:
        cmp     bx,word [ticks]
        jae     replay_delay
        lodsb
replay_getkey:
        test    al,al
        jz      mainprog_ext
        cmp     al,0ffh
        jz      mainprog_init
        cmp     al,0feh
        jz      replay_effect
        cmp     al,1bh
        jz      mainprog_init
        push    si
        call    play_key
        pop     si
        jmp     replay_sound_loop
replay_sound_int:
        xor     ax,ax
        int     16h
        jmp     replay_getkey
replay_effect:
        lodsb
        cmp     al,1
        jz      transpose_up
        cmp     al,2
        jz      transpose_down
        cmp     al,4
        jz      OctaveUp
        cmp     al,5
        jz      OctaveDown
        call    stop_sound
        jmp     replay_sound_loop
transpose_up:
        cmp     word ptr [transpose],40
        jae     mainprog
        inc     word ptr [transpose]
        call    upd_scr
        cmp     byte ptr [state],1
        jz      record_transpose_up
        jmp     _return
record_transpose_up:
        cmp     di,offset mybuf+2
        mov     ax,01feh
        stosw
        jbe     record_loop
        mov     al,[di-5]
        push    di
        call    play_key
        pop     di
        jmp     record_loop
transpose_down:
        cmp     word ptr [transpose],0
        jz      _return
        dec     word ptr [transpose]
        call    upd_scr
        cmp     byte [state],1
        jz      record_transpose_down
        jmp     _return
record_transpose_down:
        cmp     di,offset mybuf+2
        mov     ax,02feh
        stosb
        jbe     record_loop
        mov     al,[di-5]
        push    di
        call    play_key
        pop     di
        jmp     record_loop
snd_quit:
        call    stop_sound
        call    restore_timer
        mov     ax,4c00h
        int     21h

install_new_timer:
    push    es
    push    ds
    xor     ax,ax
    mov     ds,ax
    mov     es,ax
    mov     si,(8*4)
    mov     di,si
    cli
    lodsw
    mov     word ptr cs:[oldint8],ax
    lodsw
    mov     word ptr cs:[oldint8+2],ax
    mov     ax,offset timer_proc
    stosw
    mov     ax,cs
    stosw
    sti
    pop     ds
    pop     es

        mov     ax,011000
        push    ax
        mov     al,36h
        out     43h,al
        pop     ax
        out     40h,al
        xchg    al,ah
        out     40h,al

        push    cs
        push    cs
        pop     es
        pop     ds
        ret

restore_timer:
        cli
        push    es
        xor     ax,ax
        mov     es,ax
        mov     di,(8*4)
        mov     si,offset oldint8
        movsw
        movsw
        pop     es
        sti
        ret

timer_proc:
        inc     word cs:[ticks]
        jmp     dword ptr cs:[oldint8]

init_speaker:
        in      al,61h
        or      al,3
        out     61h,al
        mov     al,0b6h
        out     43h,al
        ret
play_sound:
        test    ax,ax
        jz      play_sound_done
        push    ax
        in      al,61h
        or      al,3
        out     61h,al
        pop     bx
play_sound2:
        mov     ax,34ddh
        mov     dx,12h
        div     bx        
        out     42h,al
        xchg    ah,al
        out     42h,al
play_sound_done:
        ret
no_sound:
        xor     ax,ax
        call    play_sound
        ret
stop_sound:
        in      al,61h
        and     al,0fch
        out     61h,al        
        ret
waitkey:
        mov     ah,1
        int     16h
        jz      waitkey
        xor     ax,ax
        int     16h
        ret
upd_scr:
        xor     dx,dx
        mov     ah,2
        xor     bh,bh
        int     10h
        mov     si,offset Trans
        call    printstr

        mov     ax,word [Transpose]
        xor     dx,dx
        call    printint
        call    printlf

        mov     si,offset Octav
        call    printstr
        mov     ax,word [Octave]
        xor     dx,dx
        call    printint
        call    printlf

        mov     si,offset Stat
        call    printstr
        cmp     byte [state],1
        jb      play_state
        jz      record_state
        mov     si,offset ReplayStr
        jmp     printstate
record_state:
        mov     si,offset RecordStr
        jmp    printstate
play_state:
        mov     si,offset PlayStr
printstate:
        call    printstr
        ret
printerror:
        call    printstr
        ret

ReadSndFile:
        mov     si,offset EnterInStr
        call    PrintStr
        mov     cx,128
        mov     di,offset MyFileName
        call    GetInput
        test    cx,cx
        jz      ReadSndDone2
        mov     ax,3D00h
        mov     dx,offset MyFileName
        int     21h
        jc      WriteSndFileError
        mov     bx,ax
        mov     ah,3fh
        mov     dx,offset MyBuf
        mov     cx,(64000-MyBuf)
        int     21h
        jc      WriteSndFileError
        mov     ah,3eh
        int     21h
        mov     word [SndLen],ax
        mov     si,offset FileLoadSuccess
        jmp     WriteSndFileDone
ReadSndDone2:
        mov     ax,3
        int     10h
        ret

WriteSndFile:
        mov     si,offset EnterOutStr
        call    PrintStr
        mov     cx,128
        mov     di,offset MyFileName
        call    GetInput
        test    cx,cx
        jz      WriteSndDone2
        mov     dx,offset MyFileName
        xor     cx,cx
        mov     ah,3ch
        int     21h
        jc      WriteSndFileError
        mov     bx,ax
        mov     dx,offset MyBuf
        mov     cx,word [SndLen]
        mov     ah,40h
        int     21h
        jc      WriteSndFileError
        mov     ah,3eh
        int     21h
        mov     si,offset FileWriteSuccess
        jmp     WriteSndFileDone
WriteSndFileError:
        mov     si,offset FileError
WriteSndFileDone:
        call    PrintStr
        xor     ax,ax
        int     16h
WriteSndDone2:
        mov     ax,3
        int     10h
        ret

MyFileName      db  128 dup (0)
EnterInStr      db  13,10,"Enter input file :",0
EnterOutStr     db  13,10,"Enter output file :",0
FileError       db  13,10,"File error press a key to continue",0
FileLoadSuccess db  13,10,"File loaded successfully. Press F3 to play, any key to continue",0
FileWriteSuccess db 13,10,"File written successfully. Press any key to continue",0
mybuf:
        dw      0
        db      100 dup (0xff)
