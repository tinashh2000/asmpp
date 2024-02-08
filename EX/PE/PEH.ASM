FORMAT PE64 GUI
.STACK 8192
PUBLIC ON

Code SEGMENT CODE EXECUTABLE READABLE
Start:
	SUB	RSP,100
	
	MOV	R9,0
	MOV	R8,(_Hello)
	MOV	RDX,(_Hello)
	MOV	RCX,0
	CALL	MessageBox
	CALL	ExitProcess
	ADD	RSP,100

DataSection	SEGMENT ".data" DATA READABLE WRITEABLE
	_Hello	DB	"Hello World",0


Imp SEGMENT '.idata' IMPORT READABLE WRITEABLE

	IMPORT "KERNEL32.DLL"
		CreateFile,"CreateFileA"		
		ExitProcess,"ExitProcess"
	IMPORT "USER32.DLL"
		MessageBox,"MessageBoxA"
	END


END Start
