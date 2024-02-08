FORMAT PE32

Code SEGMENT CODE EXECUTABLE READABLE
Start:
    CALL    DWORD [MessageBox],0,(_Hello),(_Hello),0
    CALL    DWORD [ExitProcess],0


Data SEGMENT '.data' DATA READABLE WRITEABLE
_Hello  DB  "Ndeip mfana!",0
Tom     DD  ?
IData SEGMENT '.idata' IMPORT READABLE WRITEABLE

    DD  0,0,0,RVA Kernel32,RVA KernelModules
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

END Start
