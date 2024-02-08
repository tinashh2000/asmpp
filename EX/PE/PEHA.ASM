FORMAT PE64
.STACK 0x1000
.HEAP  0x1000

ECHO "First ", $

Code SEGMENT '.code' CODE EXECUTABLE READABLE

ECHO "Second ", $

Start:

ECHO "Start ", Start
	SUB	RSP,8*5
	MOV	R9,0
	MOV	R8,(_Hello)
	MOV	RDX,(_Hello3)
	MOV	RCX,0
	CALL	MessageBox
	XOR	ECX,ECX
	CALL	ExitProcess

SEGMENT ".data" DATA WRITEABLE

    _Hello DB "Hello",0 

SEGMENT ".mydata" DATA WRITEABLE

    _Hello3 DB "Hello My World",0 
    

SEGMENT '.import' IMPORT
	IMPORT "KERNEL32.DLL"
		ExitProcess,"ExitProcess"
	IMPORT "USER32.DLL"
		MessageBox,"MessageBoxA"
	END

END Start