;This program was designed originally to convert all ASM++ keywords to a
;CRC-32 value. ASM++ does not store strings as they are. They are stored in
;this format.
;This program was edited to convert programs using a common CRC-32 algorithm.

format mz
;        db  100h dup (90h)
Start:
        mov     si,offset Msg
        call    PrintStr
        mov     ax,cs
        mov     es,ax
        mov     si,80h
        lodsb
        test    al,al
        jz      CrcUsage
        xor     cx,cx   ;File length
        mov     bx,offset InFileLen
        mov     di,offset CmdLine
GetFileName:
        lodsb
        cmp     al,0Dh
        jz      InitFiles
        cmp     al,32
        jz      GetFileName
        stosb
        inc     cx
GetFileNameLoop:
        lodsb
        cmp     al,0Dh
        jz      InitFiles
        cmp     al,32
        jbe     GetNextFileName
        inc     cx
        stosb
        jmp     GetFileNameLoop
CrcUsage:
        mov     si,offset Usage
        jmp     CrcExitError
GetNextFileName:
        cmp     bx,offset OutFileLen
        jz      InitFiles
        mov     bx,offset OutFileLen
        xor     ax,ax
        stosw
        mov     bp,di
        xor     cx,cx
        jmp     GetFileNameLoop
InitFiles:
        mov     ax,cs
        mov     ds,ax
        nop
        xor     ax,ax
        stosw
        mov     word [bx],cx
        cmp     word [InFileLen],0
        jz      CrcUsage        
        mov     dx,offset CMDLine
        mov     ax,3D00h
        int     21h
        jc      InFileError
        mov     word [InHandle],ax
        cmp     word [OutFileLen],0
        jnz     InitOutFile
        mov     si,offset CMDLine
        mov     di,si
        add     di,word [InFileLen]
        add     di,2
        mov     bp,di
CreateOutFile:
        lodsb
        cmp     al,"."
        jz      CreateOutFileAddExt
        test    al,al
        jz      CreateOutFileAddExt
        stosb
        jmp     CreateOutFile
CreateOutFileAddExt:
        mov     ax,"c."
        stosw
        mov     ax,"cr"
        stosw
        xor     ax,ax
        stosw
InitOutFile:
        xor     cx,cx
        mov     dx,bp
        mov     ah,3Ch
        int     21h
        jc      OutFileError
        mov     word [OutHandle],ax
        mov     si,bp
        call    PrintStr
        call    PrintLF
        jmp     CrcIt
InFileError:
        mov     si,offset InFileError
        jmp     CrcExitError
OutFileError:
        mov     si,offset OutFileError
        jmp     CrcExitError
CrcExitError:
        call    PrintStr
        mov     ax,4CFFh
        int     21h

CrcIt:        
        mov     di,offset TempBuffer
CrcReadInFile:
        push    dx
        mov     dx,offset LineBuffer
        mov     cx,2000h
        mov     bx,word [InHandle]
        mov     ah,3Fh
        int     21h
        pop     dx
        jc      InFileError
        test    ax,ax
        jz      CrcDone
        mov     bx,ax
        mov     word [bx][LineBuffer],0
        mov     si,offset LineBuffer
        cmp     di,offset TempBuffer
        ja      CrcItLoopFindLine
        xor     bp,bp
        xor     dx,dx
CrcItLoopFindLine:
        lodsb
        test    al,al
        jz      CrcReadInFile
        cmp     al,0Ah
        stosb
        jz      CrcLineFound
        cmp     di,offset TempBuffer+2046
        jae     CrcLineTooLong
        cmp     al,32
        jnz     CrcItLoopFindLine
        lea     dx,[di][-TempBuffer]
        dec     dx
        cmp     dx,bp
        ja      CrcItLoopFindLine
        inc     bp
        jmp     CrcItLoopFindLine
CrcLineTooLong:
        mov     si,offset LineTooLong
        jmp     CrcExitError
CrcLineFound:
        lea     cx,[di][-TempBuffer]
        mov     di,offset TempBuffer
        push    cx
        mov     al,34
        repnz   scasb
        pop     cx
        jnz     CrcWriteFile
        call    GetCrcData
CrcWriteFile:
        mov     di,offset TempBuffer
        mov     dx,di
        mov     ah,40h
        mov     bx,word [OutHandle]
        int     21h
        jc      OutFileError
        xor     dx,dx
        xor     bp,bp
        jmp     CrcItLoopFindLine
CrcDone:
        mov     ax,4C00h
        int     21h
Crc32:
        mov     cx,-1
        mov     dx,cx
        mov     ah,0
Crc32Loop:
        lodsb
        mov     bl,al
        mov     bh,0
        xor     bl,cl
        and     bl,0ffh
        add     bx,bx
        add     bx,bx
        mov     cl,ch
        mov     ch,dl
        mov     dl,dh
        mov     dh,ah
        xor     cx,word [bx][Crc32Buffer]
        xor     dx,word [bx][Crc32Buffer][0002]
        cmp     byte [si],34
        jz      Crc32Done
        cmp     byte [si],0Dh
        jnz     Crc32Loop
Crc32Done:
        ret

StoreHexWord:
        mov     ah,4
StoreHexWordLoop:
        rol     bx,4
        mov     al,bl
        and     al,0Fh
        cmp     al,9
        ja      StoreHexAlpha
        add     al,48
        stosb
        dec     ah
        jnz     StoreHexWordLoop
        ret
StoreHexAlpha:
        add     al,55
        stosb
        dec     ah
        jnz     StoreHexWordLoop
        ret


PrintStr:
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     ah,0Eh
PrintStrLoop:
        lodsb
        test    al,al
        jz      PrintStrDone
        int     10h
        jmp     PrintStrLoop
PrintLF:
        mov     ax,0E0Dh
        int     10h
        mov     al,0Ah
        int     10h
        ret
PrintStrDone:
        pop     ds
        ret
GetCrcData:
        push    si
        push    bp
        mov     si,di
        call    Crc32
        mov     bx,si
        sub     bx,di
        pop     bp
        pop     si
        push    bx
        push    di
        mov     di,offset TempBuffer
        mov     bx,cx
        mov     cx,bp
        mov     al,32
        rep     stosb

        mov     bp,si
        pop     si
        pop     cx
        push    di
        add     di,27
        rep     movsb
        mov     ax,0A0Dh
        stosw
        mov     si,bp
        mov     cx,di
        pop     di
        push    cx
        mov     ax,"DD"
        stosw
        mov     al,20h
        mov     cx,13
        rep     stosb
        mov     al,"0"
        stosb
        xchg    bx,dx        
        call    StoreHexWord
        mov     bx,dx
        call    StoreHexWord
        mov     ax," h"
        stosw
        mov     al,";"
        stosb
        pop     di
        lea     cx,[di][-TempBuffer]
        ret
Msg         db      "Crc32 converting tool",13,10
            db      "Developed for ASM++ by Tinashe Mutandagayi",13,10,13,10,0
Usage       db      "CRC <inputfile> [output file]",13,10
            db      "Output file is optional (a .crc file is created instead)",13,10,0
LineTooLong db  "Line too long",13,10,0
Working     db      "Working",0
FileError   db  "Disk/File Error",13,10,0
CmdLine     db      128 dup(0)
InFileLen   dw  0
OutFileLen  dw  0
InHandle    dw  0
OutHandle   dw  0

even 4
Crc32Buffer:        dd      077073096h
                    dd      0EE0E612Ch
                    dd      0990951BAh
                    dd      0076DC419h
                    dd      0706AF48Fh
                    dd      0E963A535h
                    dd      09E6495A3h
                    dd      00EDB8832h
                    dd      079DCB8A4h
                    dd      0E0D5E91Eh
                    dd      097D2D988h
                    dd      009B64C2Bh
                    dd      07EB17CBDh
                    dd      0E7B82D07h
                    dd      090BF1D91h
                    dd      01DB71064h
                    dd      06AB020F2h
                    dd      0F3B97148h
                    dd      084BE41DEh
                    dd      01ADAD47Dh
                    dd      06DDDE4EBh
                    dd      0F4D4B551h
                    dd      083D385C7h
                    dd      0136C9856h
                    dd      0646BA8C0h
                    dd      0FD62F97Ah
                    dd      08A65C9ECh
                    dd      014015C4Fh
                    dd      063066CD9h
                    dd      0FA0F3D63h
                    dd      08D080DF5h
                    dd      03B6E20C8h
                    dd      04C69105Eh
                    dd      0D56041E4h
                    dd      0A2677172h
                    dd      03C03E4D1h
                    dd      04B04D447h
                    dd      0D20D85FDh
                    dd      0A50AB56Bh
                    dd      035B5A8FAh
                    dd      042B2986Ch
                    dd      0DBBBC9D6h
                    dd      0ACBCF940h
                    dd      032D86CE3h
                    dd      045DF5C75h
                    dd      0DCD60DCFh
                    dd      0ABD13D59h
                    dd      026D930ACh
                    dd      051DE003Ah
                    dd      0C8D75180h
                    dd      0BFD06116h
                    dd      021B4F4B5h
                    dd      056B3C423h
                    dd      0CFBA9599h
                    dd      0B8BDA50Fh
                    dd      02802B89Eh
                    dd      05F058808h
                    dd      0C60CD9B2h
                    dd      0B10BE924h
                    dd      02F6F7C87h
                    dd      058684C11h
                    dd      0C1611DABh
                    dd      0B6662D3Dh
                    dd      076DC4190h
                    dd      001DB7106h
                    dd      098D220BCh
                    dd      0EFD5102Ah
                    dd      071B18589h
                    dd      006B6B51Fh
                    dd      09FBFE4A5h
                    dd      0E8B8D433h
                    dd      07807C9A2h
                    dd      00F00F934h
                    dd      09609A88Eh
                    dd      0E10E9818h
                    dd      07F6A0DBBh
                    dd      0086D3D2Dh
                    dd      091646C97h
                    dd      0E6635C01h
                    dd      06B6B51F4h
                    dd      01C6C6162h
                    dd      0856530D8h
                    dd      0F262004Eh
                    dd      06C0695EDh
                    dd      01B01A57Bh
                    dd      08208F4C1h
                    dd      0F50FC457h
                    dd      065B0D9C6h
                    dd      012B7E950h
                    dd      08BBEB8EAh
                    dd      0FCB9887Ch
                    dd      062DD1DDFh
                    dd      015DA2D49h
                    dd      08CD37CF3h
                    dd      0FBD44C65h
                    dd      04DB26158h
                    dd      03AB551CEh
                    dd      0A3BC0074h
                    dd      0D4BB30E2h
                    dd      04ADFA541h
                    dd      03DD895D7h
                    dd      0A4D1C46Dh
                    dd      0D3D6F4FBh
                    dd      04369E96Ah
                    dd      0346ED9FCh
                    dd      0AD678846h
                    dd      0DA60B8D0h
                    dd      044042D73h
                    dd      033031DE5h
                    dd      0AA0A4C5Fh
                    dd      0DD0D7CC9h
                    dd      05005713Ch
                    dd      0270241AAh
                    dd      0BE0B1010h
                    dd      0C90C2086h
                    dd      05768B525h
                    dd      0206F85B3h
                    dd      0B966D409h
                    dd      0CE61E49Fh
                    dd      05EDEF90Eh
                    dd      029D9C998h
                    dd      0B0D09822h
                    dd      0C7D7A8B4h
                    dd      059B33D17h
                    dd      02EB40D81h
                    dd      0B7BD5C3Bh
                    dd      0C0BA6CADh
                    dd      0EDB88320h
                    dd      09ABFB3B6h
                    dd      003B6E20Ch
                    dd      074B1D29Ah
                    dd      0EAD54739h
                    dd      09DD277AFh
                    dd      004DB2615h
                    dd      073DC1683h
                    dd      0E3630B12h
                    dd      094643B84h
                    dd      00D6D6A3Eh
                    dd      07A6A5AA8h
                    dd      0E40ECF0Bh
                    dd      09309FF9Dh
                    dd      00A00AE27h
                    dd      07D079EB1h
                    dd      0F00F9344h
                    dd      08708A3D2h
                    dd      01E01F268h
                    dd      06906C2FEh
                    dd      0F762575Dh
                    dd      0806567CBh
                    dd      0196C3671h
                    dd      06E6B06E7h
                    dd      0FED41B76h
                    dd      089D32BE0h
                    dd      010DA7A5Ah
                    dd      067DD4ACCh
                    dd      0F9B9DF6Fh
                    dd      08EBEEFF9h
                    dd      017B7BE43h
                    dd      060B08ED5h
                    dd      0D6D6A3E8h
                    dd      0A1D1937Eh
                    dd      038D8C2C4h
                    dd      04FDFF252h
                    dd      0D1BB67F1h
                    dd      0A6BC5767h
                    dd      03FB506DDh
                    dd      048B2364Bh
                    dd      0D80D2BDAh
                    dd      0AF0A1B4Ch
                    dd      036034AF6h
                    dd      041047A60h
                    dd      0DF60EFC3h
                    dd      0A867DF55h
                    dd      0316E8EEFh
                    dd      04669BE79h
                    dd      0CB61B38Ch
                    dd      0BC66831Ah
                    dd      0256FD2A0h
                    dd      05268E236h
                    dd      0CC0C7795h
                    dd      0BB0B4703h
                    dd      0220216B9h
                    dd      05505262Fh
                    dd      0C5BA3BBEh
                    dd      0B2BD0B28h
                    dd      02BB45A92h
                    dd      05CB36A04h
                    dd      0C2D7FFA7h
                    dd      0B5D0CF31h
                    dd      02CD99E8Bh
                    dd      05BDEAE1Dh
                    dd      09B64C2B0h
                    dd      0EC63F226h
                    dd      0756AA39Ch
                    dd      0026D930Ah
                    dd      09C0906A9h
                    dd      0EB0E363Fh
                    dd      072076785h
                    dd      005005713h
                    dd      095BF4A82h
                    dd      0E2B87A14h
                    dd      07BB12BAEh
                    dd      00CB61B38h
                    dd      092D28E9Bh
                    dd      0E5D5BE0Dh
                    dd      07CDCEFB7h
                    dd      00BDBDF21h
                    dd      086D3D2D4h
                    dd      0F1D4E242h
                    dd      068DDB3F8h
                    dd      01FDA836Eh
                    dd      081BE16CDh
                    dd      0F6B9265Bh
                    dd      06FB077E1h
                    dd      018B74777h
                    dd      088085AE6h
                    dd      0FF0F6A70h
                    dd      066063BCAh
                    dd      011010B5Ch
                    dd      08F659EFFh
                    dd      0F862AE69h
                    dd      0616BFFD3h
                    dd      0166CCF45h
                    dd      0A00AE278h
                    dd      0D70DD2EEh
                    dd      04E048354h
                    dd      03903B3C2h
                    dd      0A7672661h
                    dd      0D06016F7h
                    dd      04969474Dh
                    dd      03E6E77DBh
                    dd      0AED16A4Ah
                    dd      0D9D65ADCh
                    dd      040DF0B66h
                    dd      037D83BF0h
                    dd      0A9BCAE53h
                    dd      0DEBB9EC5h
                    dd      047B2CF7Fh
                    dd      030B5FFE9h
                    dd      0BDBDF21Ch
                    dd      0CABAC28Ah
                    dd      053B39330h
                    dd      024B4A3A6h
                    dd      0BAD03605h
                    dd      0CDD70693h
                    dd      054DE5729h
                    dd      023D967BFh
                    dd      0B3667A2Eh
                    dd      0C4614AB8h
                    dd      05D681B02h
                    dd      02A6F2B94h
                    dd      0B40BBE37h
                    dd      0C30C8EA1h
                    dd      05A05DF1Bh
                    dd      02D02EF8Dh
                    dd      000000001h
TempBuffer:
    org ($+4096)
LineBuffer:
end Start
