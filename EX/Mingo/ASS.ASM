.model tiny
;.code
        mov si,offset CorpInfo
        call PrintStr
        call GetCmdLine
        mov si,offset CmdLine
        call SeperateStr
        call FormatStr
        call FormatFName
        call Assemble
        int 20h
FormatFName Proc Near
        push ax,si
        mov si,offset FileName
HasExt?:        
        lodsb
        cmp al,"."
        jz HasExt
        cmp al,0
        jz AddExt
        jmp HasExt?
AddExt:
        mov si,offset FileName
        mov di,offset FileName
        call GetNullLen
        add di,cx
        mov si,offset Ext
        mov cx,4
        rep
        movsb
HasExt:
        pop si,ax
        ret
FormatFname EndP

Inside Proc Near
        push    bx,cx,si,di
        mov bx,di
SearchStr:
        mov cl,[di]
        cmp [si],cl
        jnz IncDI
        cmp byte [si],0
        jz StrNotFound
        call CmpDiffStr
        cmp ax,1
        jz StrFound
IncDI:
        inc di
        jmp SearchStr
StrNotFound:
        mov ax,0
        ret
StrFound:
        mov ax,di
        sub ax,bx
        pop di,si,cx,bx
        ret
Inside EndP

Assemble Proc near
        push    ax,cx,dx,bx,si,di
        mov byte [LineFeedF],0
        mov si,offset Asmbl
        call PrintStr
        mov si,offset FileName
        mov byte [LineFeedF],1
        call PrintStr
        call OpenFile
        call ReadFile
        call CloseFile
        cmp byte [Eof],1
        jnz NotSupported
        mov di,offset FBuffer
        add di,[SizeRead]
        xor ax,ax
        stosw
        mov si,offset FBuffer
        mov BuffPos,si
AssLoop:
        call ReadOneLine       
        call MakeMeaningFul
        mov cx,SizeRead
        add cx,offset FBuffer
        cmp BuffPos,cx
        jb AssLoop
        pop     di,si,bx,dx,cx,ax
        ret
NotSupported:
        mov si,offset BigFile
        call PrintStr
        pop di
        pop si
        pop bx
        pop dx
        pop cx
        pop ax
        int 20h
        .noret
        pop     di,si,bx,dx,cx,ax
Assemble EndP
ReadOneLine Proc Near
        push    ax,bx,cx,di
        mov di,offset LnBuffer
        mov si,BuffPos
        mov bx,0A0Dh
        xor cx,cx
        mov word [LineLen],0
FindEOL:
        lodsw
        dec si
        inc cx
        inc word [BuffPos]
        inc word [LineLen]
        cmp cx,513
        jae LineLong
        cmp ax,bx
        jnz FindEOL
        inc word [BuffPos]
        dec word [LineLen]
        sub si,cx
        rep
        movsb
        xor al,al
        stosb
        inc word [LineNum]
        mov si,BuffPos
        pop di,cx,bx,ax
        ret
NotTooLong:
        inc word [LineNum]
        mov BuffPos,ax
        pop di,cx,bx,ax
        ret
LineLong:
        mov ax,SizeRead
        cmp [BuffPos],ax
        jae NotTooLong
        inc word [LineNum]
        mov byte [LineFeedF],0
        mov byte [ErFlag],1
        mov si,offset LTLong
        call PrintStr
        mov ax,[LineNum]
        call PrintInt
        pop di
        pop cx
        pop bx
        pop ax
        int 20h
ReadOneLine EndP

MakeMeaningFul Proc Near
        mov byte [LineFeedF],0
        mov si,offset LnBuffer
        mov cx,[LineLen]
        call SeperateStr
        call GetOperandType
        ret
MakeMeaningFul EndP

GetOperandType Proc near
        push    ax,bx,cx,dx,si,di
        pop di,si
        mov si,offset Operand1
        xor cx,cx
CheckIfRegister:
        jmp TestDefs
Test8Bits:
        mov di,offset _8BitR
        call Inside
        cmp ax,0
        jz Is8Bit
        jmp CheckRegs
Is8Bit:
        
Test16Bits:
        mov di,offset 16BitR
        call Inside
Test32Bits:
        mov di,offset 32BitR
        call Inside
TestSegment:
        mov di,offset Seg
        call Inside
TestBYTE:
        mov di,offset BStr
        call Inside
TestWORD:
        mov di,offset WStr
        call Inside
TestDWORD:
        mov di,offset DStr
        call inside
TestIndex:
         call ChkIdxAddressing
TestDefs:
        cmp byte [Result],11h
        jz Op1Def
        cmp byte [Result],22h
        jz Op2Def
        jmp Test8Bits
Op1Def:
        mov ax,Operand1
TestDef:
        cmp ax,"BD"
        jz DefByte
        cmp ax,"WD"
        jz DefWord
        mov byte [TypeOp1],15
        jmp ExecuteMnemonic
DefByte:
        mov byte [TypeOp1],13
        jmp ExecuteMnemonic
DefWord:
        mov byte [TypeOp1],14
        jmp ExecuteMnemonic
Op2Def:
        mov ax,Operand2
        jmp TestDef
ExitDef:
        pop     di,si,dx,cx,bx,ax
        ret
GetOperandType EndP

TypeOp1 db 0
TypeOp2 db 0
TypeOp3 db 0
TypeOp4 db 0
TypeOp5 db 0
TypeOp6 db 0
include jrasm.asm
.end
