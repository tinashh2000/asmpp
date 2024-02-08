FORMAT PE32 STUB "AAX.EXE"
.STACK 0x10000,0x10000
.HEAP 0x10000,0x10000
.LANG STDCALL

Code Segment '.icode' CODE
Start:    
    CALL    MessageBox,0,_Hello,_Hello,1
    CALL    ExitProcess,0


Data Segment '.idata' DATA
    _Hello  DB  "Hello World!",0
            DB  "The quick brown"

SEGMENT '.import' IMPORT
	IMPORT "KERNEL32.DLL"
		ExitProcess,"ExitProcess"
	IMPORT "USER32.DLL"
		MessageBox,"MessageBoxA"
	END

Segment DATA
            DB  "The quick brown"

Segment DATA
            DB  "The quick brown"
Segment DATA
            DB  "The quick brown"
Segment DATA
            DB  "The quick brown"
Segment DATA
            DB  "The quick brown"
Segment DATA
            DB  "The quick brown"

End Start