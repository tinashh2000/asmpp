GetCmdLine Proc Near
        mov si,80h
        lodsb
        or al,al
        jz ErrorCmd
        mov di,offset CmdLine
RemoveBlank:
        inc si
        cmp byte [si],13
        jz ErrorCmd
        cmp byte [si],32
        jz RemoveBlank
        cmp byte [si],9
        jz RemoveBlank
GetCmd:
        lodsb
        cmp al,13
        jz CmdDone
        stosb
        jmp short GetCmd
ErrorCmd:
        mov si,offset CmdError
        call PrintStr
        call Input
        mov si,offset InputBuffer
        mov di,offset CmdLine
        call AssignStr
CmdDone:
        ret
GetCmdLine EndP
RTrim Proc Near
        PUSH    ax cx si di
        call GetLen
        push si
        push cx
        mov cx,2048
        mov si,offset Buffer
        call MakeNull
        pop cx
        pop si        
        mov di,offset Buffer
        rep
        movsb
        mov cx,2048
        mov si,offset Buffer
        add si,cx
FromRight:
        lodsb
        sub si,2
        cmp al,9
        jz FromRight
        cmp al,32
        jz FromRight
        cmp al,0
        jz FromRight
        add si,2
        mov di,si
TrimRt:
        xor al,al
        rep
        stosb
        pop di si cx ax
        ret
RTrim EndP
LTrim Proc
        push  si di ax cx dx
        call GetLen
        push si
        push cx
        mov cx,2048
        mov si,offset Buffer
        call MakeNull
        pop cx
        pop si
        add cx,si
        add cx,2
        xor dx,dx
FromLeft:
        lodsb
        inc dx
        cmp al,9
        jz FromLeft
        cmp al,32
        jz FromLeft
        dec si
        dec dx
        mov di,offset Buffer
        sub cx,dx
TrimLt:
        lodsb
        stosb
        cmp si,cx
        jb TrimLt
        xor ax,ax
        mov cx,dx
        rep
        stosb
        stosb
        xor al,al
        stosb
        pop dx cx ax di si
        ret
LTrim EndP
ExchangeStr Proc
        push ax bx dx si di
        mov dx,1111h
XchangeReg:
        mov al,[si]
        mov bl,[di]
        mov [si],bl
        mov [di],al
        inc si
        inc di
        cmp al,0
        jz XorDL
R1:
        cmp bl,0
        jz XorDH
        jmp XchangeReg
XorDL:
        cmp dh,0
        jz DoneExch
        xor dl,dl
        jmp R1
XorDH:
        cmp dl,0
        jz DoneExch
        xor dh,dh
        jmp XchangeReg
DoneExch:
        pop di si dx bx ax
        ret
ExchangeStr EndP
AssignStr Proc Near uses bx cx si di
        call GetLen
        mov bx,cx
        push si
        mov si,di
        call GetLen
        pop si
        cmp bx,cx
        jb UseShort
ResumeAS:
        rep
        movsb
        ret
UseShort:
        xchg bx,cx
        sub bx,cx
        rep
        movsb        
        mov cx,bx
        xor al,al
        rep
        stosb
        jmp short ResumeAS
AssignStr EndP
PrintStr Proc Near uses si ax
        mov ah,0Eh
DoIt:
        lodsb
        cmp al,0
        jz DonePrtS
        int 10h
        jmp short DoIt
DonePrtS:
        cmp byte [LineFeedF],1
        jz FeedIt
        ret
FeedIt:
        call PLineFeed
        ret
PrintStr EndP
MakeNull Proc Near uses di ax cx
        call GetLen
        xor ax,ax
        mov di,si
        rep
        stosb
        ret
MakeNull EndP
GetLen Proc Near uses ax si
        xor cx,cx
GetIt:
        inc cx
        mov ax,[si]
        inc si
        cmp ax,9000h
        jnz GetIt
        dec cx
        ret
GetLen EndP
Trim Proc Near uses si di
        call LTrim
        mov si,offset Buffer
        mov di,offset Buffer2
        call AssignStr
        mov si,offset Buffer2
        call RTrim
        ret
Trim EndP
CmpStr Proc Near uses bx si di  ;the length must be the same
Compare:
        mov al,[si]
        mov bl,[di]
        cmp al,bl
        jnz NotTheSame
        cmp al,0
        jz TheSame
        inc si
        inc di
        jmp short Compare
TheSame:
        mov ax,1
        ret
NotTheSame:
        mov ax,0
        ret
CmpStr EndP
CmpDiffStr Proc Near uses cx bx si di      ;Use this one to compare strings
        xor cx,cx
Compare1:                               ;with different lengths
        mov al,[si]
        mov bl,[di]
        cmp dh,1
        jz TestLen
ResumeCmp:
        cmp al,0
        jz TheSame1
        cmp al,bl
        jnz NotTheSame1
        inc si
        inc di
        jmp short Compare1
TestLen:
        inc cx
        cmp al,bl
        jnz NotTheSame1
        cmp cl,dl
        jnz ResumeCmp
TheSame1:
        mov al,1
        ret
NotTheSame1:
        mov al,0
        ret
CmpDiffStr EndP
ConcStr Proc Near uses ax cx si di
        push di
        call GetLen
        mov di,offset Buffer
        rep
        movsb
        pop si
        call GetLen
        rep
        movsb
        ret
ConcStr EndP
LCase Proc Near uses ax cx si di
        mov di,offset Buffer
LCaseCheck:
        lodsb
        cmp al,0
        jz LCDone
        cmp al,64
        ja MightBeCaps
        jmp short StoreIt
MightBeCaps:
        cmp al,90
        ja StoreIt
        add al,32
StoreIt:
        stosb
        jmp short LCaseCheck
LCDone:
        ret
LCase EndP

UCase Proc Near uses ax cx si di
        mov di,offset Buffer
UCaseCheck:
        lodsb
        cmp al,0
        jz UCDone
        cmp al,90
        ja MightBeSmall
        jmp short Store
MightBeSmall:
        cmp al,122
        ja Store
        sub al,32
Store:
        stosb
        jmp short UCaseCheck
UCDone:
        ret
UCase EndP
Instr Proc Near uses bx cx si di
        mov bl,al
        mov cx,si
        xor ax,ax
FindIt:
        lodsb
        cmp al,bl
        jz CalcPos
        cmp al,0
        jz NotFound
        jmp short FindIt
CalcPos:
        sub si,cx
        mov ax,si
NotFound:
        xor ax,ax
        ret
Instr EndP
PrintInt Proc Near uses ax bx
        xor ah,ah
        mov bl,10
        div bl
        mov bh,ah
        xor ah,ah
        div bl
        mov bl,ah
        add al,48
        add bl,48
        add bh,48
        mov ah,0Eh
        int 10h
        mov al,bl
        int 10h
        mov al,bh
        int 10h
        cmp byte [LineFeedF],1
        jz FeedeLine
        ret
FeedeLine:
        call PLineFeed
        ret
PrintInt EndP
SetCursor Proc Near uses ax bx
        mov bh,[ActivePage]
        mov bl,[Color]
        mov ax,0200h
        int 10h
        ret
SetCursor EndP
GetCursor Proc Near uses ax bx
        mov bh,[ActivePage]
        mov bl,[Color]
        mov ax,0300h
        int 10h
        ret
GetCursor EndP
PrintChar Proc Near uses ax
        mov ah,0Eh
        int 10h
        ret
PrintChar EndP
PrintColChar Proc Near uses ax cx bx
        mov ah,09h
        mov cx,1
        mov bh,[ActivePage]
        mov bl,[Color]
        int 10h
        ret
PrintColChar EndP
PLineFeed Proc Near uses ax
        mov ax,0E0Dh
        int 10h
        mov al,0Ah
        int 10h
        ret
PLineFeed EndP
Input Proc Near
        mov byte [Color],7
        mov cx,offset InputBuffer
        mov di,offset InputBuffer
        add cx,128
        call GetCursor
        mov bx,dx
GetInp:
        xor ax,ax
        int 16h
        cmp al,13
        jz InpDone
        cmp al,8
        jz BackSpace
        cmp al,27
        jz StartAgain
        cmp di,cx
        jz GetInp
PrintIt:
        stosb
        mov ah,0Eh
        int 10h        
        jmp short GetInp
BackSpace:
        call GetCursor
        cmp bh,dh
        jnz LineFed
RemoveByte:
        cmp di,offset InputBuffer
        jz GetInp
        cmp dl,0
        jz GetInp
        dec dx
        call SetCursor
        xor al,al
        call PrintColChar
        dec di
        stosb
        dec di
        jmp short GetInp
LineFed:
        cmp dl,0
        jz GetInp
        jmp short RemoveByte
StartAgain:
        call PLineFeed
        mov si,offset InputBuffer
        call MakeNull
        mov di,si
        jmp short GetInp
InpDone:
        xor al,al
        stosb
        cmp byte [LineFeedF],1
        jnz DontFeedPlease
        call PLineFeed
DontFeedPlease:
        ret
Input EndP
SeperateStr Proc Near uses ax cx dx bx si di
        push si
        xor dx,dx
        xor ax,ax
        mov di,offset Operand1
        mov byte [Result],0
EmptyIt:
        mov cx,50
        rep
        stosb
        inc di
        inc di
        inc dx
        cmp dx,6
        jb EmptyIt
        mov di,offset DefBuffer
        mov cx,256
        rep
        stosb
        pop si
StartNow:
        mov di,offset Operand1
        xor cx,cx
        xor bx,bx
        xor dx,dx
TerminateSpace:
        lodsb
        cmp al,9
        jz TerminateSpace
        cmp al,32
        jz TerminateSpace
        cmp al,13
        jz EndOfString
        cmp al,0
        jz EndOfString
        dec si
        inc dx
SeperateIt:
        lodsb
        cmp al,32
        jz SpaceFound
        cmp al,9
        jz SpaceFound
        cmp al,0
        jz EndOfString
        cmp al,13
        jz EndOfString
        cmp al,44
        jz TestInQuote1
        cmp al,34
        jz Quote
        cmp al,39
        jz Quote
        cmp al,";"
        jz TestInQuote
Continue:
        cmp al,97
        jae MayBeSmall
Resume:
        cmp byte [Result],0
        jnz ResumeSpecial
        stosb
        inc cx
        cmp cx,50
        jz SpaceFound
        jmp short SeperateIt
ResumeSpecial:
        stosb
        inc cx
        cmp cx,256
        jz EndOfString
        jmp short seperateIt
SpaceFound:
        cmp byte [Result],0
        jnz ResumeSpecial
        cmp bx,1
        jz Resume
        xor al,al
        stosb
        cmp dx,6
        ja EndOfString
        cmp dx,2
        ja NoNeed
        call CheckDef
        cmp byte [Result],0
        jz SeperateIt
NoNeed:
        add di,51
        sub di,cx
        xor cx,cx
        jmp short TerminateSpace
EndOfString:
        xor al,al
        stosb
        ret
Quote:
        cmp bx,1
        jz MakeBXZero
        mov bx,1
        jmp short Resume
MakeBXZEro:
        xor bx,bx
        jmp short Resume
TestInQuote:
        cmp bx,1
        jz Resume
        jmp short EndOfString
TestInQuote1:
        cmp bx,1
        jz Resume
        jmp short SpaceFound
MayBeSmall:
        cmp bx,1
        jz Resume
        cmp al,123
        jb IsSmall
        jmp short Resume
IsSmall:
        sub al,32
        jmp short Resume
        .noret
SeperateStr EndP

CheckDef Proc near uses cx dx si
        cmp dx,1
        jz Cm1
        cmp dx,2
        jz Cm2
        ret
Cm2:
        mov cx,2
        mov si,offset Operand2
        jmp CheckForDef
Cm1:
        mov cx,1
        mov si,offset Operand1
CheckForDef:
        push di
        mov dx,0102h
        mov di,offset Def1
        call CmpDiffStr
        cmp ax,1
        jz  FoundDef
        mov di,offset Def2
        call CmpDiffStr
        cmp ax,1
        jz FoundDef
        mov di,offset Def3
        call CmpDiffStr
        cmp ax,1
        jz FoundDef
        mov dx,0104h
        mov di,offset Def4
        call CmpDiffStr
        cmp ax,1
        jz FoundDef
        mov di,offset Def5
        call CmpDiffStr
        cmp ax,1
        jz FoundDef
        pop di
        ret
FoundDef:
        pop di
        mov di,offset DefBuffer
        cmp cx,1
        jz ItsOp1
        jmp ItsOp2
ItsOp1:
        mov byte [Result],11h
        jmp CheckDone
ItsOp2:
        mov byte [Result],22h
CheckDone:
        ret
CheckDef EndP
OpenFile Proc Near uses ax,cx
        mov ax,3D01h
        cmp cx,203
        jz WriteAlso
        mov ax,3D00h
WriteAlso:
        mov dx,offset FileName
        int 21h
        jc ErrorOpen
        mov hnd,ax
        mov bx,ax
        ret
ErrorOpen:
        mov si,offset OpenError
        Call PrintStr
        pop cx
        pop ax
        int 20h
OpenFile EndP
CreateFile Proc Near uses ax cx dx
        mov ah,5Bh
        mov cx,32
        mov dx,offset FileName
        int 21h
        jc ErrorCreate
        mov [hnd],ax
        mov bx,ax
        ret
ErrorCreate:
        mov cx,203
        cmp al,80
        jz FileExist
        mov cx,0
        mov si,offset CreateError
        Call PrintStr
        pop dx
        pop cx
        pop ax
        int 20h
FileExist:
        call OpenFile
        ret
CreateFile EndP
DeleteFile Proc Near
        mov ah,41h
        mov dx,offset FileName
        int 21h
        ret
DeleteFile EndP
WriteFile Proc Near uses ax bx cx dx
        mov ah,40h
        mov bx,Hnd
        mov cx,60000
        mov dx,offset FBuffer
        int 21h
        jc ErrorWrite
        ret
Errorwrite:
        mov si,offset WriteError
        Call PrintStr
        pop dx
        pop cx
        pop bx
        pop ax
        int 20h
WriteFile EndP
ReadFile Proc Near uses ax cx dx
        mov ah,3Fh
        mov bx,Hnd
        mov cx,54000
        mov dx,offset FBuffer
        int 21h
        jc ErrorRead
        mov [SizeRead],ax
        cmp ax,54000
        jb IsEof
        mov byte [Eof],0
        ret
IsEof:
        mov byte [Eof],1
        ret
ErrorRead:
        mov si,offset ReadError
        Call PrintStr
        pop dx
        pop cx
        pop ax
        int 20h
ReadFile EndP
CloseFile Proc Near
        mov ah,3Eh
        mov bx,Hnd
        int 21h
        ret
CloseFile EndP
WriteFileByte Proc Near uses ax bx cx dx
        mov ah,40h
        mov bx,Hnd
        mov cx,1
        mov dx,offset FCharBuffer
        int 21h
        jc ErrorWrite1
        ret
ErrorWrite1:
        mov si,offset WriteError
        Call PrintStr
        pop dx
        pop cx
        pop bx
        pop ax
        int 20h
WriteFileByte EndP
ReadFileByte Proc Near uses ax bx cx dx
        mov ah,3Fh
        mov bx,Hnd
        mov cx,1
        mov dx,offset FCharBuffer
        int 21h
        jc ErrorRead1
        ret
ErrorRead1:
        mov si,offset ReadError
        Call PrintStr
        pop dx
        pop cx
        pop bx
        pop ax
        int 20h
ReadFileByte EndP

FormatStr Proc near uses ax cx dx si di
        xor cx,cx
        inc cx
        mov si,offset Operand1
FindFileName:
        lodsb
        cmp al,"/"
        jz NotAFile
        cmp al,"-"
        jz NotAFile
        dec si

        mov di,offset Operand1
        call ExchangeStr
        mov si,offset Operand1
        mov di,offset FileName
        call AssignStr
        jmp RegOptions
NotAFile:
        add si,51
        cmp cl,[MaxParam]
        jz NoFileInCmd
        inc cx
        jmp FindFileName
NoFileInCmd:
        mov si,offset NoFile
        call PrintStr
        ret
        pop di  ;Clean up before leaving
        pop si
        pop cx
        pop ax
        int 20h
RegisterOut:
        mov si,di
        add si,3
        mov di,offset OutFile
GetOutFile:
        movsb
        cmp byte [si],0
        jnz GetOutFile
        jmp General
RegisterTiny:
        mov byte [TinyModel],1
        jmp General
RegisterStack:
        mov byte [Stack],1
        mov si,di
        add si,6
CopyStackValue:
        mov di,offset StackVal
        movsb
        cmp byte [si],0
        jnz CopyStackValue
        jmp General
RegisterSkip:
        mov byte [SkipErr],1
General:        
        inc ch
        cmp ch,[MaxParam]
        jae RegDone
        cmp ch,1
        jz Reg1
        cmp ch,2
        jz Reg2
        cmp ch,3
        jz Reg3
        cmp ch,4
        jz Reg4
        cmp ch,5
        jz Reg5
RegOptions:
        xor cx,cx
        mov si,offset Operand2
        jmp General
Reg1:
        lodsb
        cmp al,"/"
        jnz TryHyphen
ItsOK:
        mov dx,0104h
        mov di,offset SpecOutFile
        call CmpDiffStr
        cmp al,1
        jz RegisterOut
        xor dx,dx

        mov di,offset TinyMode
        call CmpDiffStr
        cmp al,1
        jz RegisterTiny

        mov dx,0106h
        mov di,offset StackSize
        call CmpDiffStr
        cmp al,1
        jz RegisterStack
        xor dx,dx

        mov di,offset Skip
        call CmpDiffStr
        cmp al,1
        jz RegisterSkip

        jmp PrtParamErr
Reg2:
        mov si,offset Operand3
        jmp Reg1
Reg3:
        mov si,offset Operand4
        jmp Reg1
Reg4:
        mov si,offset Operand5
        jmp Reg1
Reg5:
        mov si,offset Operand6
        jmp Reg1        
RegDone:
        ret
TryHyphen:
        cmp al,"-"
        jz ItsOK
PrtParamErr:
        mov si,offset CmdParam
        call PrintStr
        ret
        int 20h
FormatStr EndP
GetNullLen Proc Near uses ax si
        xor cx,cx
GetIt1:
        inc cx
        mov al,[si]
        inc si
        cmp al,00h
        jnz GetIt1
        dec cx
        ret
GetNullLen EndP
ConvReg Proc Near uses ax bx
        push ax
        xchg ah,al
        xor dx,dx
        jmp StartConv
ConvAgain:
        mov cl,bl
        mov ch,bh
        mov dx,1
        pop ax
StartConv:
        xor ah,ah
        mov bl,16
        div bl
        mov bh,ah
        xor ah,ah
        div bl
        mov bl,ah
        cmp dx,1
        jnz ConvAgain
        mov dl,bl
        mov dh,bh
        ret
ConvReg EndP

CmdError        db "Required Parameters missing",13,10      ;Files
                db "Please enter the name of the file you want to assemble",13,10,10,0
OpenError       db "Error while opening file",13,10,0
ReadError       db "Error while reading file",13,10,0
WriteError      db "Error while writing file",13,10,0
CreateError     db "Error while creating file",13,10,0
NoFile          db "No file specified in command-line",13,10,0
CmdParam        db "Invalid Parameters in command-line",13,10
                db "You can only use the options below in command-line:",13,10
                db "JRASM <filename.ext> [/OUT:<filename.[ext]>] [/T] [/STACK:Stack] [/SKIP]",13,10
                db "filename.ext        - a compulsory file that contains mnemonics to be assembled",13,10
                db "/OUT:<filename.ext> - an optional parameter that specified the output file",13,10
                db "/T                  - indicates that a the output will be .COM instead of .EXE",13,10
                db "/STACK:<Size>       - if you don't specify stack in source, you can do it here",13,10
                db "/SKIP               - all errors are skipped. They will not be in the output file",13,10
                db 13,10
                db "NB: Please do not leave spaces unless you want to pass another option",13,10
                db "Use JRHLP for further help and JROPT for other options",13,10,0
Asmbl           db "Assembling File : ",0
Ext             db ".ASM"
LFStr           db 13,10,0
LTLong          db "In JRASM then maximum line length is 512 bytes. This line is too long",13,10
                db "If you are defining bytes of a string use a multi-line definition like this",13,10
                db "[IDENTIFIER         DB      ",34,"The quick brown fox jumps over the",34,13,10
                db "                    DB      ",34,"lazy dog in the streets of Africa",34,",13,10,0",13,10
                db "Line Number         :       ",0
CorpInfo        db "Jesus Rules Technology            2003-2004 (C)opyright",13,10
                db "JRASM     Version 1.0 First Edition Free Version",13,10
                db "Spectacular! Solutions 2004",13,10,0
BigFile         db "The file is greater than 56000 bytes. and is not supported",13,10
                db "Check updates on www.JesusRules.com/Development/Assembly/JRASM",13,10,0
SpecOutFile     db "OUT:",0
TinyMode        db "T",0
StackSize       db "STACK:",0
Skip            db "SKIP",0
Def1            db "DB",0
Def2            db "DW",0
Def3            db "DD",0
Def4            db "PROC",0
Def5            db "ENDP",0
Buffer          dup 2049,0
                db 144                      ;Buffers

Buffer2         dup 2049,0
                db  144
InputBuffer     dup 0129,0
                db  144
CmdLine         dup 0129,0
                db  144
FileName        dup 0129,0
                db  144
OutFile         dup 0129,0
                db  144
Operand1        dup 51,0
                db  114
Operand2        dup 51,0
                db  144
Operand3        dup 51,0
                db  144
Operand4        dup 51,0
                db  144
Operand5        dup 51,0
                db  144
Operand6        dup 51,0
                db  144
DefBuffer       dup 257,0
                db 144
LnBuffer        dup 512,0
BuffPos         dw 0
LineNum         dw 0
ErFlag          db 0

Hnd             db 0
FCharBuffer     dup 10,0
Optimize        db 0    ;Option Flags and buffers
StartAdd        dw 0
TinyModel       db 0
CorrectMinor    db 0
Stack           db 0
DefFlag         db 0
StackVal        dup 8,0
SkipErr         db 0
Color           db 7                            
ActivePage      db 0
LineFeedF       db 1
MaxParam        db 0
Counter         dw 0
LShift          db 0                            ;Extended Keys
RShift          db 0
Alt             db 0
Ctrl            db 0
ScrollLock      db 0
NumLock         db 0
CapsLock        db 0
Insert          db 0
Eof             db 0
Result          db 0
SizeRead        dw 0
LineLen         dw 0
CurAddress      dw 0
REAX            equ 0                           ;Registers
RECX            equ 1
REDX            equ 2
REBX            equ 3
RESP            equ 4
REBP            equ 5
RESI            equ 6
REDI            equ 7

RxAX             equ 0
RxCX             equ 1
RxDX             equ 2
RxBX             equ 3
RxSP             equ 4
RxBP             equ 5
RxSI             equ 6
RxDI             equ 7

RAL             equ 0
RCL             equ 1
RDL             equ 2
RBL             equ 3
RAH             equ 4
RCH             equ 5
RDH             equ 6
RBH             equ 7

_8BitR           db "AH BH CH DH AL BL CL DL",0,144
_16BitR          db "AX BX CX DX SP BP SI DI",0,144
_32BitR          db "EAX EBX ECX EDX ESP EBP ESI EDI",0,144
IndexReg        db "SI DI BP SI",0,144
Seg             db "ES CS SS DS",0,144
IdxAdd          db "[SI] [BX] [BP] [DI]",0,144
BStr            db "BYTE [",0
WStr            db "WORD [",0
DStr            db "DWORD [",0
QStr            db "QWORD [",0
FBuffer         db 54000 dup(?)
.end
