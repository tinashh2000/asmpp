
COFFFormat  STRUC
    ORG MiscFmt
    cfMachine		DW  ?
    cfNumSections	DW  ?
    cfTimeStamp 	DD  ?
    cfSymbolsPTR	DD  ?
    cfNumSymbols	DD  ?
    cfSizeOptional	DW  ?
    cfCharacter		DW  ?	;No optional header

    cfSections		DB  4000    DUP(?)
    cfRelocRVA		DD  ?
    cfRelocStart	DW  ?
    cfSeg		DW  ?
    cfSegAttr		DD  ?
    cfStubSize		DW  ?
    cfRelocPTR		DW  ?
    cfRelocSeg		DW  ?
    cfFlags		DW  ?
    
COFFFormat  ENDS

