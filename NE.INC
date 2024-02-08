NEFormat    STRUC
    ORG MiscFmt
    neSegTableBuffer	LABEL
			DB  2400    DUP(?)
    neEntry		DW  ?
    neEntrySize 	DW  ?
    neFlags		DW  ?
    neAutoSeg		DW  ?
    neHeapSize		DW  ?
    neStackSize 	DW  ?
    neInitIP		DW  ?
    neInitCS		DW  ?
    neInitSP		DW  ?
    neInitSS		DW  ?
    neSegEntries	DW  ?
    neModRefEntries	DW  ?
    neNonResSize	DW  ?
    neSegTable		DW  ?
    neResource		DW  ?
    neModRef		DW  ?
    neImports		DW  ?
    neNonRes		DD  ?
    neMovable		DW  ?
    neShift		DW  ?
    neResourceSegs	DW  ?
    neTargetOS		DW  ?
    neFastLoad		DW  ?
    neFastLoadSize	DW  ?
    neReserved		DW  ?
    neWinVersion	DW  ?
    neHeaderSize	DW  ?
    neStubSize		DW  ?
    neSeg		DW  ?
    neSegAttr		DW  ?
    neSegStart		DD  ?
    neRelocPTR		DW  ?	 
    neRelocSeg		DW  ?
    neNumReloc		DW  ?
    neRes		DW  ?
    neResSize		DW  ?
    neResourceSize	DW  ?
    neImportsSize	DW  ?
    neResourceAlign	DW  ?
    neRsrcIDType	DB  ?
    neRsrcIDLen 	DB  ?
    neRsrcCurSegBak	DW  ?
    neRsrcStart 	DD  ?
    neExportsStart	DD  ?
    neRsrcCrc		LABEL
    neRsrcPos		LABEL
			DD  ?
NEFormat    ENDS
