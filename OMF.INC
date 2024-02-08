OMFFormat   STRUC
    ORG MiscFmt
    omfBuffer		LABEL
			DB	4096	DUP(?)
    omfExtern		DW	?   ;Indexes of External names - OMF
    omfSeg		DW	?   ;Index of current SEGMENT - OMF
    omfGrp		DW	?   ;Indexes of GROUP definitions
    omfClass		DW	?   ;Index of current class name
    omfNames		DW	?   ;Indexes IN list of names
    omfSegName		DW	?   ;Current SEGMENT's names idx
    omfRelocPTR 	DW	?   ;Relocation pointer
    omfHeaderSize	DW	?   ;Header SIZE
    omfPublicPTR	DW	?
    omfBufferPTR	DW	?
    omfOBufferPTR	DW	?
    omfRecStartPTR	DW	?
    omfSegSize		DD	?   ;SEGMENT SIZE
    omfInitIP		DD	?
    omfInitCS		DD	?
OMFFormat   ENDS
