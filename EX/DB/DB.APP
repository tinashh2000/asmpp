.8086
    mov ax,cs   ;Make sure ES=CS
    mov es,ax
    mov si,80h
    lodsb
    test al,al  ;Check cmdline presence
    jnz DBCmdPresent
DBUsage3:
    jmp DBUsage
DBCmdPresent:
    xor cx,cx
    mov bx,offset InFileLen     ;Point to inputfile info space
    mov di,offset InFile
GetFileName:
    lodsb
    cmp al,0Dh
    jz  DBUsage3
    cmp al,32
    jbe GetFileName
    dec si
GetFileNameLoop:
    lodsb       ;Get command line
    cmp al,0Dh
    jz  FileNameDone
    cmp al,32
    jbe FileNameSpace
    cmp al,"-"
    jz  DBSwitch
    cmp al,"/"
    jz  DBSwitch
    stosb
    inc cx
    jmp GetFileNameLoop
FileNameDone:
    jmp FileNameDone2
FileNameSpace:
    test cx,cx          ;If nothing was input as filename
    jz  GetFileNameLoop ;go back
    cmp bx,offset OutFileLen    ; If no input file name was found save input
    jz  FileNameDone            ; filename first
    mov al,0            ; Null terminate input file name
    stosb
    mov word cs:[bx],cx ; Save length at OutFileLen
    mov bx,offset OutFileLen    ;Point to outputfile info space
    mov di,offset OutFile
    xor cx,cx   ;Clear length
    jmp GetFileNameLoop
DBSWWidth:
    lodsb               ;Get width specified by -x
    cmp al,0Dh
    jz  DBUsage3
    cmp al,32
    jb  DBSWWidth
    cmp al,"0"
    jb  DBUsage
    jz  DBSWWidth
    cmp al,"9"
    ja  DBUsage
    mov dl,byte [si]
    sub al,"0"          ; Convert first digit from text to binary
    cmp dl,"0"          ; Get second digit
    jb  DBNumOK
    cmp dl,"9"
    ja  DBNumOK
    inc si
    sub dl,"0"
    mov ah,10
    mul ah
    mov dh,0
    add ax,dx
    mov word [Width],ax
    jmp FileNameSpace
DBNumOK:
    mov ah,0
    mov word [Width],ax
    jmp FileNameSpace
DBSwitch:
    lodsb
    mov bp,ax
    and bp,0FFh
    cmp byte cs:[bp][LCaseTable],0
    jz  DBSwitch2
    mov al,byte cs:[bp][LCaseTable]
DBSwitch2:
    mov bp,offset DBWidth
    cmp al,"b"
    jz DBSWBytes
    cmp al,"w"
    jz DBSWWords
    cmp al,"d"
    jz DBSWDWords
    cmp al,"f"
    jz DBSWFWords
    cmp al,"q"
    jz DBSWQWords
    cmp al,"t"
    jz DBSWTWords
    cmp al,"x"
    jz DBSWWidth
    cmp al,"a"
    jz  DBSWAddr
DBUsage:
    mov si,offset Msg
    call PrintStr
    mov si,offset Usage
    jmp DBQuitError
DBSWAddr:
    mov byte cs:[Settings],1    ;Print address
    jmp FileNameSpace
DBSWQWords:
    mov byte cs:[bp],16         ;Save Length and type
    mov word [DBStr],'QD'
    jmp FileNameSpace
DBSWTWords:
    mov byte cs:[bp],20
    mov word [DBStr],'TD'
DBSWBytes:
    mov byte cs:[bp],2
    mov word [DBStr],'BD'
    jmp FileNameSpace
DBSWWords:
    mov byte cs:[bp],4
    mov word [DBStr],'WD'
    jmp FileNameSpace
DBSWDWords:
    mov byte cs:[bp],8
    mov word [DBStr],'DD'
    jmp FileNameSpace
DBSWFWords:
    mov byte cs:[bp],12
    mov word [DBStr],'FD'
    jmp FileNameSpace
DBInFileError:
    mov si,offset InFileError
    jmp DBQuitError
DBDone:
    jmp DBDone3
DBUsage2:
    jmp DBUsage

FileNameDone2:
    mov ax,cs           ;Make sure DS=CS
    mov ds,ax
    mov word [bx],cx    ;Save file length. Either input or output file.
    cmp word [InFileLen],0
    jz  DBUsage2
    mov al,0    ;Null terminate file name
    stosb

    mov si,offset Msg
    call PrintStr

    xor bp,bp
    mov dx,offset InFile
    mov al,0
    call FOpen
    jc DBInFileError
    mov word [InHandle],ax
FileNameReadBytes:
;    int 3
;;        pushad
;        mov ax,word ptr [linenumber]
;        mov dx,word ptr [linenumber+2]
;        call PrintInt
;        call PrintLF
;        popad
    mov bx,word [InHandle]
    mov dx,offset FileBuffer
    mov cx,16726
    call FRead
    jc DBInFileError
    test ax,ax
    jz DBDone
    mov cx,ax
    mov si,offset FileBuffer
DBFile:
    test cx,cx
    jz  FileNameReadBytes
    mov di,word [OutBufferPtr]
    mov bx,offset HexTable
DBBytes:    
    test bp,bp
    jz  DBWriteFirst
    cmp bp,word [Width]
    jbe DBBytesWidthOK
    test    byte [Settings],1
    jz  DBSettingOK     ;Print address
    mov ax,"; "
    stosw
    mov al,[CurAddr][0001]
    call    HexChar
    stosw

    mov al,[CurAddr]
    call    HexChar
    stosw

    mov al,[DBWidth]
    mov ah,0
    add [CurAddr],ax
DBSettingOK:
    inc dword [LineNumber]
    mov ax,0A0Dh
    stosw
DBWriteFirst:
    mov ax,word [DBStr]
    stosw
    mov ax,2020h
    stosw
    mov al,"0"
    stosb
    mov bp,5
    jmp DBBytes2
DBBytesWidthOK:
    cmp byte [DBWidth],2
    jnz DBBytes2
    mov ax,"0" shl 8 or ","
    stosw
DBBytes2:
    lodsb
    call    HexChar
    cmp byte [DBWidth],2
    jnz  DBWidthWords
DBWidthOK:
    stosw
    mov al,"h"
    stosb
    add bp,5
DBWidth3:
    cmp di,(OutBuffer+15000)
    ja  DBFlush
DBWidth4:
    dec cx
    jnz DBBytes
    mov word [OutBufferPtr],di
    jmp FileNameReadBytes

DBWidthWords:
    xchg bx,word [LenPtr]
    mov word [bx][CharBuffer],ax
    add bx,2
    cmp bl,byte [DBWidth]
    xchg bx,word [LenPtr]
    jb  DBWidth4
    mov bx,word [LenPtr]
    cmp bp,5
    jz  DBDumpWords
    mov ax,"0" shl 8 or ","
    stosw
DBDumpWords:
    xor ax,ax
    xchg ax,word [bx][CharBuffer][-2]
    stosw
    sub bx,2
    ja  DBDumpWords
    mov word [LenPtr],0
    mov bx,offset HexTable
    mov al,"h"
    stosb
    add bp,word [DBWidth]
    add bp,3
    jmp DBWidth3

DBFlush:
    push bx,cx,dx,si,di
    mov bx,word [OutHandle]
    test bx,bx
    jz  DBCreateOutFile
DBOutFileOK:
    lea cx,[di][-OutBuffer]
    mov dx,offset OutBuffer
    MOV dword [OutBuffer],"LEH;"
    call FWrite
    jc  DBOutFileError
    mov di,offset OutBuffer
    mov word [OutBufferPtr],di
    pop di,si,dx,cx,bx
    cmp word [InHandle],0
    jz  DBDone2
    jmp DBFile
DBCreateOutFile:
    cmp word [OutFileLen],0
    jnz DBCreateIt
    push si,di
    mov si,offset InFile
    mov di,offset OutFile
    mov cx,word [InFileLen]
DBGetFileStr:
    lodsb
    cmp al,"."
    jz DBAddFileExt
    test al,al
    jz DBAddFileExt
    stosb
    dec cx
    jnz DBGetFileStr
DBAddFileExt:
    mov ax,"h."
    stosw
    mov ax,"xe"
    stosw
    mov al,0
    stosb
    pop di,si
DBCreateIt:
    mov dx,offset OutFile
    xor cx,cx
    call FCreate
    jc  DBOutFileError
    mov word [OutHandle],ax
    mov bx,ax
    jmp DBOutFileOK
DBDone2:
    mov si,offset OutFile
    call PrintStr    
    mov ax,4C00h
    int 21h
DBOutFileError:
    mov si,offset OutFileError
DBQuitError:
    call PrintStr
    mov ax,4CFFh
    int 21h

DBDone3:    
    mov di,word [OutBufferPtr]
    cmp byte [LenPtr],0
    jz DBDone4
    mov bx,word [LenPtr]
    cmp bp,5
    jz DBWordsFinal
    mov ax,"0" shl 8 or ","
    stosw
DBWordsFinal:
    mov cx,word [DBWidth]
    sub cx,bx
    mov al,"0"
    rep stosb
DBWordsFinal2:
    mov ax,word [bx][CharBuffer][-2]
    stosw
    sub bx,2
    jnz DBWordsFinal2
    mov al,"h"
    stosb
DBDone4:
    test    byte [Settings],1
    jz  DBDoneOK
    mov bx,offset HexTable
    mov ax,"; "
    stosw
    mov al,[CurAddr][0001]
    call    HexChar
    stosw
    mov al,[CurAddr]
    call    HexChar
    stosw
DBDoneOK:
    mov word [InHandle],0
    jmp DBFlush


HexChar:
    mov ah,al
    rol ah,4
    and ax,0F0Fh
    xlat
    xchg al,ah
    xlat
    ret


include file16.inc
include prt16.inc

InFile  db  128 dup (0)
OutFile db 128 dup (0)
InFileLen dw 0
OutFileLen dw 0
CharBuffer  db  12 dup (0)
CurAddr dw  0
Width   dw  11
DBWidth dw  2
LenPtr  dw  0
OutBufferPtr    dw  OutBuffer
InHandle    dw  0
OutHandle   dw  0
Settings    dw  0
HexTable    db  "0123456789ABCDEF"
DBStr       db  "DB"
OutFileError    db  "Output file error",13,10,0
InFileError     db  "Input file error",13,10,0

LineNumber      DD 0

Msg     db  "DB binary to HEX converter.",13,10
        db  "Developed for ASM++ by Tinashe Mutandagayi (19 Dec 2006)",13,10
        db  "You can contact me at tinashh2000@yahoo.com",13,10,13,10,0
Usage   db  "DB dumps bytes,words,dwords,qwords or tbytes of a binary file",13,10
        db  "into another file as HEX numbers of the respective size.",13,10
        db  "Usage:",13,10
        db  "   DB <InputFile> [OutputFile] [Options]",13,10
        db  "Options:",13,10
        db  "-b     Dump bytes",13,10
        db  "-w     Dump words",13,10
        db  "-d     Dump dwords",13,10
        db  "-f     Dump fwords",13,10
        db  "-q     Dump qwords",13,10
        db  "-t     Dump TBytes",13,10
        db  "-a     Show address in hex format",13,10
        db  "-x??   Use width ?? for output file",13,10,13,10
        db  "You can use this program as you wish and I take no responsibility",13,10
        db  "for any damages to anyone or anything resulting from use of this program",13,10,0
LCaseTable:
                    db      65  dup(0)
                    db      "abcdefghijklmnopqrstuvwxyz"
                    db      164 dup(0)
        DB 1000 DUP(?)
FileBuffer:
        db 16000 dup(?)
OutBuffer:
