OpenELF32Format:
        OR      BYTE [ExtMask],SYM_NEEDSRELOC
        RET
OpenELF64Format:
        OR      BYTE [ExtMask],SYM_NEEDSRELOC
        RET
CloseELF32File:
        RET
CloseELF64File:
        RET
