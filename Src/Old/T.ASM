format coff32

public	start1,_start2:LABEL,start7:LABEL
extern mydoc1,mydoc2,mydoc3

COUNT = COUNT + 1

code segment
start1:
	mov	eax,start1
	mov	eax,start2
	mov	eax,start3
	mov	eax,start4
	mov	eax,start1

	db 100 dup(90h)
code ends

data segment
start2:
	mov	eax,100
data ends

xdata segment
start3:
	mov eax,100
	mov	eax,start4
xdata ends

xxdata segment
start4:	
	dd 0
xxdata ends

extern	mylibx
