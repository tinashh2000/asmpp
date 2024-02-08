;This code generates code that prints a 'Hello world!' message but the output
;is split into two files that are related.
;This example demonstrates the generation of many output files using one
;source file.
;This code only shows how more than one output files can be specified but
;it does not show the REAL importance in this source file but it is a good
;way of splitting files.
;You can join the files directly with the DOS command:
; COPY outfile1.com+outfile2.com outfile.com
;the output file will be outfile.com.
;MULTIFMT.APP will demonstate very good use of the OUT option.

BIOSTTY equ 0Eh
BIOSINT equ 10h
DOSExit equ 4Ch
DOSInt  equ 21h
option out 'outfile1.com'   ;Change output file name
    mov si,offset HelloMessage
    mov ah,BIOSTTY
    cmp byte [si],0
    jz  PrintDone
PrintLoop:
    lodsb
    int BIOSInt
    cmp byte [si],0
option out 'outfile2.com'   ;Change output file name
    echo $
    jnz PrintLoop
PrintDone:
    mov ah,DOSExit
    int DOSInt
HelloMessage    db  "Hello world!",13,10,0
