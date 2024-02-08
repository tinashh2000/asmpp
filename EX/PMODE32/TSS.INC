;This file is used by all programs which deal with tasks.
TSSStruc    struc
    BackLnk     dd  0
    ESP0        dd  0
    SS0         dd  0
    ESP1        dd  0
    SS1         dd  0
    ESP2        dd  0
    SS2         dd  0
    CR3Reg      dd  0
    EIPReg      dd  0
    EFlags      dd  0
    EAXReg      dd  0
    ECXReg      dd  0
    EDXReg      dd  0
    EBXReg      dd  0
    ESPReg      dd  0
    EBPReg      dd  0
    ESIReg      dd  0
    EDIReg      dd  0
    ESReg       dd  0
    CSReg       dd  0
    SSReg       dd  0
    DSReg       dd  0
    FSReg       dd  0
    GSReg       dd  0
    LDTReg      dd  0
    IOMapBase   dd  0
TSSStruc    ends
