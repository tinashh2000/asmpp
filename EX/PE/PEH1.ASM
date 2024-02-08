FORMAT PE32
.Stack 10000h, 100000h
.Heap  10000h, 100000h

Code SEGMENT CODE EXECUTABLE READABLE
Start:
    CALL    DWORD [MessageBox],0,(_Hello),(_Hello),0
    CALL    DWORD [ExitProcess],0

Hello:
    CALL    MessageBox,0,(_Hello),(_Hello),0
    RET

Hello2:
    CALL    MessageBox,0,(_Hello2),(_Hello2),0
    RET

Hello3:
    CALL    MessageBox,0,(_Hello3),(_Hello3),0
    RET

Data SEGMENT '.data' DATA READABLE WRITEABLE
_Hello  DB  "Hello World1!",0
_Hello2 DB  "Hello World2!",0
_Hello3 DB  "Hello World3!",0

IData SEGMENT '.idata' IMPORT READABLE WRITEABLE

INCLUDERC
    DD  0,0,0,RVA Kernel32,RVA KernelModules

INCLUDERC
    DD  0,0,0,RVA User32,RVA UserModules
    DD  0,0,0,0,0

Kernel32    DB  "KERNEL32.DLL",0
User32      DB  "USER32.DLL",0

    _ExitProcess    DW  0
                    DB  "ExitProcess",0
    _CreateFile     DW  0
                    DB  "CreateFileA",0

    _MessageBoxA    DW  0
                    DB  "MessageBoxA",0

KernelModules   LABEL
    ExitProcess     DD  RVA _ExitProcess
    CreateFile      DD  RVA _CreateFile
                    DD  0
UserModules     LABEL
    MessageBox      DD  RVA _MessageBoxA
                    DD  0

EData SEGMENT '.edata' EXPORT READABLE WRITEABLE

EXPORT "PEHELL.EXE"
    Hello,"HelloFunc"
    Hello2,"HelloFunc2"
    Hello3,"HelloFunc3"
END

END Start
