MZFormat    STRUC
    ORG MiscFmt
    mzHeaderBuffer  LABEL
		    DB	28	DUP(?)
    mzRelocBuffer   LABEL
		    DB	4096	DUP(?)
    mzRelocPTR	    DW	?
    mzNumReloc	    DW	?
    mzNewFileSize   DW	?
    mzHeaderSize    DW	?
    mzInitIP	    DW	?
    mzInitCS	    DW	?
    mzInitSP	    DW	?
    mzInitSS	    DW	?
    mzHeapSize	    DW	?
    mzStackSize     DW	?
    mzMinMemory     DW	?
    mzSeg	    DW	?
MZFormat    ENDS

