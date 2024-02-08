EVEN 2
InstructionsStart:


EVEN 2
aaaInstr:
	DW		NoOperand
	DB		0x37


EVEN 2
aadInstr:
	DW		aaxInstr
	DB		0x0D5


EVEN 2
aamInstr:
	DW		aaxInstr
	DB		0x0D4


EVEN 2
aasInstr:
	DW		NoOperand
	DB		0x03F


EVEN 2
adcInstr:
	DW		BasicInstr
	DB		16


EVEN 2
addInstr:
	DW		BasicInstr
	DB		0


EVEN 2
addpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x58


EVEN 2
addpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x58


EVEN 2
addsdInstr:
	DW		ExtendedSD
	DB		0x58


EVEN 2
addssInstr:
	DW		BasicSS
	DB		0x58


EVEN 2
addsubpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0xD0


EVEN 2
addsubpsInstr:
	DW		ExtendedPS
	DB		0x0D0


EVEN 2
aesdecInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDE


EVEN 2
aesdeclastInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDF


EVEN 2
aesencInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDC


EVEN 2
aesenclastInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDD


EVEN 2
aesimcInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDB


EVEN 2
aeskeygenassistInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0xDF


EVEN 2
AlignDirective:
	DW		AlignDirec
	DW		0xFAFB


EVEN 2
andInstr:
	DW		BasicInstr
	DB		32


EVEN 2
andnpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x55


EVEN 2
andnpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x55


EVEN 2
andpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x54


EVEN 2
andpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x54


EVEN 2
arplInstr:
	DW		ArplPInstr
	DB		0x63


EVEN 2
blendpdInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0D


EVEN 2
blendpsInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0C


EVEN 2
blendvpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x15


EVEN 2
blendvpsInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x14


EVEN 2
boundInstr:
	DW		boundpInstr


EVEN 2
bsfInstr:
	DW		BitScanInstr
	DB		0x0F,0x0BC


EVEN 2
bsrInstr:
	DW		BitScanInstr
	DB		0x0F,0x0BD


EVEN 2
bswapInstr:
	DW		bswappInstr


EVEN 2
btInstr:
	DW		BitInstr
	DB		0x0F,0x0A3,32


EVEN 2
btcInstr:
	DW		BitInstr
	DB		0x0F,0x0BB,56


EVEN 2
btrInstr:
	DW		BitInstr
	DB		0x0F,0x0B3,48


EVEN 2
btsInstr:
	DW		BitInstr
	DB		0x0F,0x0AB,40


EVEN 2
callInstr:
	DW		CallPInstr


EVEN 2
cbwInstr:
	DW		NoOperand
	DB		0x98


EVEN 2
cdqInstr:
	DW		NoOperand32
	DB		0x99


EVEN 2
cdqeInstr:
	DW		NoOperand64
	DB		0x98


EVEN 2
clcInstr:
	DW		NoOperand
	DB		0xF8


EVEN 2
cldInstr:
	DW		NoOperand
	DB		0xFC


EVEN 2
clflushInstr:
	DW		PrefetchPInstr
	DB		0x0AE,56


EVEN 2
cliInstr:
	DW		NoOperand
	DB		0xFA


EVEN 2
cltsInstr:
	DW		NoOpW
	DB		0x0F,0x06


EVEN 2
cmcInstr:
	DW		NoOperand
	DB		0xF5


EVEN 2
cmovaInstr:
	DW		cmovInstr
	DB		0x0F,0x47


EVEN 2
cmovaeInstr:
	DW		cmovInstr
	DB		0x0F,0x43


EVEN 2
cmovbInstr:
	DW		cmovInstr
	DB		0x0F,0x42


EVEN 2
cmovbeInstr:
	DW		cmovInstr
	DB		0x0F,0x46


EVEN 2
cmovzInstr:
	DW		cmovInstr
	DB		0x0F,0x44


EVEN 2
cmovgInstr:
	DW		cmovInstr
	DB		0x0F,0x4F


EVEN 2
cmovgeInstr:
	DW		cmovInstr
	DB		0x0F,0x4D


EVEN 2
cmovlInstr:
	DW		cmovInstr
	DB		0x0F,0x4C


EVEN 2
cmovleInstr:
	DW		cmovInstr
	DB		0x0F,0x4E


EVEN 2
cmovnzInstr:
	DW		cmovInstr
	DB		0x0F,0x45


EVEN 2
cmovnoInstr:
	DW		cmovInstr
	DB		0x0F,0x41


EVEN 2
cmovpoInstr:
	DW		cmovInstr
	DB		0x0F,0x4B


EVEN 2
cmovnsInstr:
	DW		cmovInstr
	DB		0x0F,0x49


EVEN 2
cmovoInstr:
	DW		cmovInstr
	DB		0x0F,0x40


EVEN 2
cmovpInstr:
	DW		cmovInstr
	DB		0x0F,0x4A


EVEN 2
cmovsInstr:
	DW		cmovInstr
	DB		0x0F,0x48


EVEN 2
cmpInstr:
	DW		BasicInstr
	DB		56


EVEN 2
cmpeqpdInstr:
	DW		SSEComparePD
	DB		0x00


EVEN 2
cmpeqpsInstr:
	DW		SSEComparePS
	DB		0x00


EVEN 2
cmpeqsdInstr:
	DW		SSECompareSD
	DB		0x00


EVEN 2
cmpeqssInstr:
	DW		SSECompareSS
	DB		0x00


EVEN 2
cmplepdInstr:
	DW		SSEComparePD
	DB		0x01


EVEN 2
cmplepsInstr:
	DW		SSEComparePS
	DB		0x02


EVEN 2
cmplesdInstr:
	DW		SSECompareSD
	DB		0x01


EVEN 2
cmplessInstr:
	DW		SSECompareSS
	DB		0x02


EVEN 2
cmpltpdInstr:
	DW		SSEComparePD
	DB		0x02


EVEN 2
cmpltpsInstr:
	DW		SSEComparePS
	DB		0x01


EVEN 2
cmpltsdInstr:
	DW		SSECompareSD
	DB		0x02


EVEN 2
cmpltssInstr:
	DW		SSECompareSS
	DB		0x01


EVEN 2
cmpneqpdInstr:
	DW		SSEComparePD
	DB		4


EVEN 2
cmpneqpsInstr:
	DW		SSEComparePS
	DB		0x04


EVEN 2
cmpneqsdInstr:
	DW		SSECompareSD
	DB		4


EVEN 2
cmpneqssInstr:
	DW		SSECompareSS
	DB		0x04


EVEN 2
cmpnlepdInstr:
	DW		SSEComparePD
	DB		6


EVEN 2
cmpnlepsInstr:
	DW		SSEComparePS
	DB		0x06


EVEN 2
cmpnlesdInstr:
	DW		SSECompareSD
	DB		6


EVEN 2
cmpnlessInstr:
	DW		SSECompareSS
	DB		0x06


EVEN 2
cmpnltpdInstr:
	DW		SSEComparePD
	DB		5


EVEN 2
cmpnltpsInstr:
	DW		SSEComparePS
	DB		0x05


EVEN 2
cmpnltsdInstr:
	DW		SSECompareSD
	DB		5


EVEN 2
cmpnltssInstr:
	DW		SSECompareSS
	DB		0x05


EVEN 2
cmpordpdInstr:
	DW		SSEComparePD
	DB		7


EVEN 2
cmpordpsInstr:
	DW		SSEComparePS
	DB		0x07


EVEN 2
cmpordsdInstr:
	DW		SSECompareSD
	DB		7


EVEN 2
cmpordssInstr:
	DW		SSECompareSS
	DB		0x07


EVEN 2
cmppdInstr:
	DW		CMPSSPInstr
	DB		0x0F,0x0C2,0x66,_OWORD


EVEN 2
cmppsInstr:
	DW		CMPPSPInstr
	DB		0x0F,0x0C2,_OWORD


EVEN 2
cmpsInstr:
	DW		CmpSPInstr


EVEN 2
cmpsbInstr:
	DW		NoOperand
	DB		0xA6


EVEN 2
cmpsdInstr:
	DW		CmpSDPInstr
	DB		0x0A7,0x0F,0x0C2,0x0F2,_DWORD


EVEN 2
cmpsqInstr:
	DW		NoOperand64
	DB		0x0A7


EVEN 2
cmpssInstr:
	DW		CMPSSPInstr
	DB		0x0F,0x0C2,0x0F3,_DWORD


EVEN 2
cmpswInstr:
	DW		NoOperand16
	DB		0x0A7


EVEN 2
cmpunordpdInstr:
	DW		SSEComparePD
	DB		3


EVEN 2
cmpunordpsInstr:
	DW		SSEComparePS
	DB		3


EVEN 2
cmpunordsdInstr:
	DW		SSECompareSD
	DB		3


EVEN 2
cmpunordssInstr:
	DW		SSECompareSS
	DB		3


EVEN 2
cmpxchgInstr:
	DW		CmpXchgPInstr
	DB		0x0F,0x0B1
	DB		0x0F,0x0B0


EVEN 2
CmpXChg16BInstr:
	DW		CmpXChg16BPInstr


EVEN 2
cmpxchg8bInstr:
	DW		CmpXChg8BPInstr


EVEN 2
comisdInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x02,0x0F,0x2F


EVEN 2
comissInstr:
	DW		BasicSS
	DB		0x2F


EVEN 2
CommentDirective:
	DW		CommentDirec
	DW		0xFAFB


EVEN 2
cpuidInstr:
	DW		NoOpW
	DB		0x0F,0x0A2


EVEN 2
cqoInstr:
	DW		NoOperand64
	DB		0x99


EVEN 2
cvtdq2pdInstr:
	DW		ExtendedSD
	DB		0x0E6


EVEN 2
cvtdq2psInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x5B


EVEN 2
cvtpd2dqInstr:
	DW		ExtendedPS
	DB		0x0E6


EVEN 2
cvtpd2piInstr:
	DW		SSE_R64_RM_Instr
	DB		0x03,0x66,0x0F,0x2D


EVEN 2
cvtpd2psInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x5A


EVEN 2
cvtpi2pdInstr:
	DW		SSE_R_RM64_Instr_Double
	DB		0x02,0x0F,0x2A


EVEN 2
cvtpi2psInstr:
	DW		SSE_R_RM64_Instr_Single
	DB		0x02,0x0F,0x2A


EVEN 2
cvtps2dqInstr:
	DW		BasicSD


EVEN 2
cvtps2pdInstr:
	DW		NotCoded
	DB		0x5A


EVEN 2
cvtps2piInstr:
	DW		SSE_R64_R128M64_Instr_Single
	DB		0x02,0x0F,0x2D


EVEN 2
cvtsd2siInstr:
	DW		NotCoded


EVEN 2
cvtsd2ssInstr:
	DW		ExtendedSD
	DB		0x5A


EVEN 2
cvtsi2sdInstr:
	DW		NotCoded


EVEN 2
cvtsi2ssInstr:
	DW		NotCoded
	DB		0x0F3,0x2A


EVEN 2
cvtss2sdInstr:
	DW		ExtendedSS
	DB		0x5A


EVEN 2
cvtss2siInstr:
	DW		NotCoded
	DB		0x0F3,0x2D


EVEN 2
cvttpd2dqInstr:
	DW		NotCoded


EVEN 2
cvttpd2piInstr:
	DW		SSE_R64_RM_Instr
	DB		0x03,0x66,0x0F,0x2C


EVEN 2
cvttps2dqInstr:
	DW		NotCoded


EVEN 2
cvttps2piInstr:
	DW		SSE_R64_R128M64_Instr_Single
	DB		0x02,0x0F,0x2C


EVEN 2
cvttsd2siInstr:
	DW		NotCoded


EVEN 2
cvttss2siInstr:
	DW		NotCoded
	DB		0x0F3,0x2C


EVEN 2
cwdInstr:
	DW		NoOperand16
	DB		0x99


EVEN 2
cwdeInstr:
	DW		NoOperand32
	DB		0x98


EVEN 2
daaInstr:
	DW		NoOperand
	DB		0x27


EVEN 2
dasInstr:
	DW		NoOperand
	DB		0x2F


EVEN 2
DBDirective:
	DW		DBDirec
	DW		(DxDirecID)
	DB		ByteID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
DDDirective:
	DW		DDDirec
	DW		(DxDirecID)
	DB		DWordID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
decInstr:
	DW		IncDecInstr
	DB		8


EVEN 2
DFDirective:
	DW		DFDirec
	DW		(DxDirecID)
	DB		FWordID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
divInstr:
	DW		SingleOp
	DB		48


EVEN 2
divpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x5E


EVEN 2
divpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x5E


EVEN 2
divsdInstr:
	DW		ExtendedSD
	DB		0x5E


EVEN 2
divssInstr:
	DW		ExtendedSS
	DB		0x5E


EVEN 2
DODirective:
	DW		DODirec
	DW		(DxDirecID)
	DB		OWordID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
dppdInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x41


EVEN 2
dppsInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x40


EVEN 2
DQDirective:
	DW		DQDirec
	DW		(DxDirecID)
	DB		QWordID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
DTDirective:
	DW		DTDirec
	DW		(DxDirecID)
	DB		TWordID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
DUDirective:
	DW		DUDirec
	DW		(DxDirecID)
	DB		ByteID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
DUPDirective:
	DW		DUPDirec
	DW		0


EVEN 2
DWDirective:
	DW		DWDirec
	DW		(DxDirecID)
	DB		WordID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
EchoMacro:
	DW		EchoMac
	DW		0xFAFB


EVEN 2
ElseDirective:
	DW		ElseDirec
	DW		0xFAFB


EVEN 2
ElseIfDirective:
	DW		ElseDirec
	DW		0xFAFB


EVEN 2
emmsInstr:
	DW		NoOpW
	DB		0x0F,0x77


EVEN 2
ENDDirective:
	DW		ENDDirec
	DW		0xFAFB


EVEN 2
EndIfDirective:
	DW		EndIfDirec
	DW		0xFAFB


EVEN 2
EndMDirective:
	DW		EndMDirec
	DW		0xFAFD
	DB		00h,00h,0Fh,0Ah,0Dh,0Eh


EVEN 2
EndPDirective:
	DW		EndPDirec
	DW		0xFAFD
	DB		00h,00h,0Fh,0Ah,0Dh,0Eh


EVEN 2
EndSDirective:
	DW		EndSDirec
	DW		0xFAFD
	DB		00h,00h,0Fh,0Ah,0Dh,0Eh


EVEN 2
enterInstr:
	DW		enterpInstr


EVEN 2
enterdInstr:
	DW		enterpInstr
	DB		0x66,0x00


EVEN 2
EQUDirective:
	DW		DirectiveMissingLabel
	DW		(EQUDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
EscInstr:
	DW		NotCoded


EVEN 2
ExitMDirective:
	DW		ExitMDirec
	DW		0xFAFB


EVEN 2
ExportDirective:
	DW		ExportDirec
	DW		0xFAFB


EVEN 2
ExternDirective:
	DW		ExternDirec
	DW		0xFAFB


EVEN 2
extractpsInstr:
	DW		SSE_REG32M32_R_IMM8
	DB		0x03,0x0F,0x3A,0x17


EVEN 2
extrqInstr:
	DW		(NotCoded)


EVEN 2
f2xm1Instr:
	DW		NoOpW
	DB		0x0D9,0x0F0


EVEN 2
fabsInstr:
	DW		NoOpW
	DB		0x0D9,0x0E1


EVEN 2
faddInstr:
	DW		BasicFPU
	DB		0x0D8,0,0x0DC,0,0,0,0x0D8,0x0C0,0x0DC,0x0C0


EVEN 2
faddpInstr:
	DW		BasicFPU2
	DB		0x0DE,0x0C0


EVEN 2
fbldInstr:
	DW		MemOp2
	DB		0xDF,32,_TWORD


EVEN 2
fbstpInstr:
	DW		MemOp2
	DB		0xDF,48,_TWORD


EVEN 2
fchsInstr:
	DW		NoOpW
	DB		0x0D9,0x0E0


EVEN 2
fclexInstr:
	DW		noopf
	DB		0x09B,0x0DB,0x0E2


EVEN 2
fcmovbInstr:
	DW		FComx
	DB		0x0DA,0x0C0


EVEN 2
fcmovbeInstr:
	DW		FComx
	DB		0x0DA,0x0D0


EVEN 2
fcmoveInstr:
	DW		FComx
	DB		0x0DA,0x0C8


EVEN 2
fcmovnbInstr:
	DW		FComx
	DB		0x0DB,0x0C0


EVEN 2
fcmovnbeInstr:
	DW		FComx
	DB		0x0DB,0x0D0


EVEN 2
fcmovneInstr:
	DW		FComx
	DB		0x0DB,0x0C8


EVEN 2
fcmovnuInstr:
	DW		FComx
	DB		0x0DB,0x0D8


EVEN 2
fcmovuInstr:
	DW		FComx
	DB		0x0DA,0x0D8


EVEN 2
fcomInstr:
	DW		FComPInstrx
	DB		0x0D8,16,0x0DC,16,0,0,0x0D8,0x0D0


EVEN 2
fcomiInstr:
	DW		FComx
	DB		0x0DB,0x0F0


EVEN 2
fcomipInstr:
	DW		FComx
	DB		0x0DF,0x0F0


EVEN 2
fcompInstr:
	DW		FCompPInstrx
	DB		0x0D8,24,0x0DC,24,0,0,0x0D8,0x0D8


EVEN 2
fcomppInstr:
	DW		NoOpW
	DB		0x0DE,0x0D9


EVEN 2
fcosInstr:
	DW		NoOpW
	DB		0x0D9,0x0FF


EVEN 2
fdecstpInstr:
	DW		NoOpW
	DB		0x0D9,0x0F6


EVEN 2
fdisiInstr:
	DW		NoOpF
	DB		0x9B,0x0DB,0x0E1


EVEN 2
fdivInstr:
	DW		BasicFPU
	DB		0x0D8,48,0x0DC,48,0,0,0x0D8,0x0F0,0x0DC,0x0F8


EVEN 2
fdivpInstr:
	DW		BasicFPU2
	DB		0x0DE,0x0F8


EVEN 2
fdivrInstr:
	DW		BasicFPU
	DB		0x0D8,56,0x0DC,56,0,0,0x0D8,0x0F8,0x0DC,0x0F0


EVEN 2
fdivrpInstr:
	DW		BasicFPU2
	DB		0x0DE,0x0F0


EVEN 2
femmsInstr:
	DW		NoOpW
	DB		0x0F,0x0E


EVEN 2
feniInstr:
	DW		noopf
	DB		0x09B,0x0DB,0x0E0


EVEN 2
ffreeInstr:
	DW		FFreePInstrx


EVEN 2
ffreepInstr:
	DW		NotCoded


EVEN 2
fiaddInstr:
	DW		IntegerFPU
	DB		0x0DE,0,0x0DA,0,0


EVEN 2
ficomInstr:
	DW		IntegerFPU
	DB		0x0DE,16,0x0DA,16,0


EVEN 2
ficompInstr:
	DW		IntegerFPU
	DB		0x0DE,24,0x0DA,24,0


EVEN 2
fidivInstr:
	DW		IntegerFPU
	DB		0x0DE,48,0x0DA,48,0


EVEN 2
fidivrInstr:
	DW		IntegerFPU
	DB		0x0DE,56,0x0DA,56,0


EVEN 2
fildInstr:
	DW		IntegerFPU
	DB		0x0DF,0,0x0DB,0,0x0DF,40


EVEN 2
fimulInstr:
	DW		IntegerFPU
	DB		0x0DE,8,0x0DA,8,0


EVEN 2
fincstpInstr:
	DW		NoOpW
	DB		0x0D9,0x0F7


EVEN 2
finitInstr:
	DW		NoOpF
	DB		0x09B,0x0DB,0x0E3


EVEN 2
fistInstr:
	DW		IntegerFPU
	DB		0x0DF,16,0x0DB,16,0


EVEN 2
fistpInstr:
	DW		IntegerFPU
	DB		0x0DF,24,0x0DB,24,0x0DF,56


EVEN 2
fisttpInstr:
	DW		IntegerFPU
	DB		0x0DF,8,0x0DB,8,0x0DD,8


EVEN 2
fisubInstr:
	DW		IntegerFPU
	DB		0x0DE,32,0x0DA,32,0


EVEN 2
fisubrInstr:
	DW		IntegerFPU
	DB		0x0DE,40,0x0DA,40,0


EVEN 2
fldInstr:
	DW		FldPInstr
	DB		0x0D9,0,0x0DD,0,0x0DB,40,0x0D9,0x0C0


EVEN 2
fld1Instr:
	DW		NoOpW
	DB		0x0D9,0x0E8


EVEN 2
fldcwInstr:
	DW		MemOp2
	DB		0xD9,40,_WORD


EVEN 2
fldenvInstr:
	DW		MemOp2
	DB		0xD9,32,0


EVEN 2
fldenvdInstr:
	DW		NotCoded


EVEN 2
fldenvwInstr:
	DW		NotCoded


EVEN 2
fldl2eInstr:
	DW		NoOpW
	DB		0x0D9,0x0EA


EVEN 2
fldl2tInstr:
	DW		NoOpW
	DB		0x0D9,0x0E9


EVEN 2
fldlg2Instr:
	DW		NoOpW
	DB		0x0D9,0x0EC


EVEN 2
fldln2Instr:
	DW		NoOpW
	DB		0x0D9,0x0ED


EVEN 2
fldpiInstr:
	DW		NoOpW
	DB		0x0D9,0x0EB


EVEN 2
fldzInstr:
	DW		NoOpW
	DB		0x0D9,0x0EE


EVEN 2
fmulInstr:
	DW		BasicFPU
	DB		0x0D8,8,0x0DC,8,0,0,0x0D8,0x0C8,0x0DC,0x0C8


EVEN 2
fmulpInstr:
	DW		BasicFPU2
	DB		0x0DE,0x0C8


EVEN 2
fnclexInstr:
	DW		NoOpW
	DB		0x0DB,0x0E2


EVEN 2
fndisiInstr:
	DW		NoOpW
	DB		0x0DB,0x0E1


EVEN 2
fneniInstr:
	DW		NoOpW
	DB		0x0DB,0x0E0


EVEN 2
fninitInstr:
	DW		NoOpW
	DB		0x0DB,0x0E3


EVEN 2
fnldenvInstr:
	DW		NotCoded


EVEN 2
fnopInstr:
	DW		NoOpW
	DB		0x0D9,0x0D0


EVEN 2
fnrstorInstr:
	DW		NotCoded


EVEN 2
fnsaveInstr:
	DW		MemOp2
	DB		0xDD,48,0


EVEN 2
fnsavedInstr:
	DW		NotCoded


EVEN 2
fnsavewInstr:
	DW		NotCoded


EVEN 2
fnstcwInstr:
	DW		MemOp2
	DB		0xD9,56,_WORD


EVEN 2
fnstenvInstr:
	DW		MemOp2
	DB		0xD9,48,0


EVEN 2
fnstenvdInstr:
	DW		(NotCoded)


EVEN 2
fnstenvwInstr:
	DW		NotCoded


EVEN 2
fnstswInstr:
	DW		FstswPInstr


EVEN 2
ForDirective:
	DW		ForDirec
	DW		0xFAFB


EVEN 2
FormatDirective:
	DW		FormatDirec
	DW		0xFAFB


EVEN 2
fpatanInstr:
	DW		NoOpW
	DB		0x0D9,0x0F3


EVEN 2
fpremInstr:
	DW		NoOpW
	DB		0x0D9,0x0F8


EVEN 2
fprem1Instr:
	DW		NoOpW
	DB		0x0D9,0x0F5


EVEN 2
fptanInstr:
	DW		NoOpW
	DB		0x0D9,0x0F2


EVEN 2
frndintInstr:
	DW		NoOpW
	DB		0x0D9,0x0FC


EVEN 2
frstorInstr:
	DW		MemOp2
	DB		0xDD,32,0


EVEN 2
frstordInstr:
	DW		NotCoded


EVEN 2
frstorwInstr:
	DW		NotCoded


EVEN 2
fsaveInstr:
	DW		MemOp
	DB		0x9B,0x0DD,48,0


EVEN 2
fsavedInstr:
	DW		NotCoded


EVEN 2
fsavewInstr:
	DW		NotCoded


EVEN 2
fscaleInstr:
	DW		NoOpW
	DB		0x0D9,0x0FD


EVEN 2
fsetpmInstr:
	DW		NoOpW
	DB		0x0DB,0x0E4


EVEN 2
fsinInstr:
	DW		NoOpW
	DB		0x0D9,0x0FE


EVEN 2
fsincosInstr:
	DW		NoOpW
	DB		0x0D9,0x0FB


EVEN 2
fsqrtInstr:
	DW		NoOpW
	DB		0x0D9,0x0FA


EVEN 2
fstInstr:
	DW		FstPInstrx
	DB		0x0D9,16,0x0DD,16,0,0,0x0D0


EVEN 2
fstcwInstr:
	DW		MemOp
	DB		0x9B,0x0D9,56,_WORD


EVEN 2
fstenvInstr:
	DW		MemOp
	DB		0x9B,0x0D9,48,0


EVEN 2
fstenvdInstr:
	DW		NotCoded


EVEN 2
fstenvwInstr:
	DW		(NotCoded)


EVEN 2
fstpInstr:
	DW		FstPInstrx
	DB		0x0D9,24,0x0DD,24,0x0DB,56,0x0D8


EVEN 2
fstswInstr:
	DW		FstSwPInstr


EVEN 2
fsubInstr:
	DW		BasicFPU
	DB		0x0D8,32,0x0DC,32,0,0,0x0D8,0x0E0,0x0DC,0x0E8


EVEN 2
fsubpInstr:
	DW		BasicFPU2
	DB		0x0DE,0x0E8


EVEN 2
fsubrInstr:
	DW		BasicFPU
	DB		0x0D8,40,0x0DC,40,0,0,0x0D8,0x0E8,0x0DC,0x0E0


EVEN 2
fsubrpInstr:
	DW		BasicFPU2
	DB		0x0DE,0x0E0


EVEN 2
ftstInstr:
	DW		NoOpW
	DB		0x0D9,0x0E4


EVEN 2
fucomInstr:
	DW		FComx
	DB		0x0DD,0x0E0


EVEN 2
fucomiInstr:
	DW		FComx
	DB		0x0DB,0x0E8


EVEN 2
fucomipInstr:
	DW		FComx
	DB		0x0DF,0x0E8


EVEN 2
fucompInstr:
	DW		FComx
	DB		0x0DD,0x0E8


EVEN 2
fucomppInstr:
	DW		NoOpW
	DB		0x0DA,0x0E9


EVEN 2
FunctionDirective:
	DW		FunctionDirec
	DW		0xFAFB


EVEN 2
waitInstr:
	DW		NoOperand
	DB		0x9B


EVEN 2
fxamInstr:
	DW		NoOpW
	DB		0x0D9,0x0E5


EVEN 2
fxchInstr:
	DW		FComx
	DB		0x0D9,0x0C8


EVEN 2
fxrstorInstr:
	DW		MemOp
	DB		0x0F,0x0AE,8,0


EVEN 2
fxsaveInstr:
	DW		MemOp
	DB		0x0F,0x0AE,0,0


EVEN 2
fxtractInstr:
	DW		NoOpW
	DB		0x0D9,0x0F4


EVEN 2
fyl2xInstr:
	DW		NoOpW
	DB		0x0D9,0x0F1


EVEN 2
fyl2xp1Instr:
	DW		NoOpW
	DB		0x0D9,0x0F9


EVEN 2
GlobalDirective:
	DW		GlobalDirec
	DW		0xFAFB


EVEN 2
GroupDirective:
	DW		DirectiveMissingLabel
	DW		(GroupDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
haddpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x7C


EVEN 2
haddpsInstr:
	DW		ExtendedPS
	DB		0x7C


EVEN 2
HaltMacro:
	DW		HaltMac
	DW		0xFAFB


EVEN 2
hltInstr:
	DW		NoOperand
	DB		0xF4


EVEN 2
hsubpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x7D


EVEN 2
hsubpsInstr:
	DW		ExtendedPS
	DB		0x7D


EVEN 2
ibtsInstr:
	DW		NotCoded


EVEN 2
idivInstr:
	DW		SingleOp
	DB		56


EVEN 2
IfDirective:
	DW		IfDirec
	DW		0xFAFB


EVEN 2
IfDefDirective:
	DW		IfDefDirec
	DW		0xFAFB


EVEN 2
IfNDefDirective:
	DW		IfNDefDirec
	DW		0xFAFB


EVEN 2
ImportDirective:
	DW		ImportDirec
	DW		0xFAFB


EVEN 2
imulInstr:
	DW		ImulpInstr
	DB		0x0F,0x0AF


EVEN 2
inInstr:
	DW		InpInstr


EVEN 2
incInstr:
	DW		IncDecInstr
	DB		0


EVEN 2
IncludeDirective:
	DW		IncludeDirec
	DW		0xFAFB


EVEN 2
IncludeBinDirective:
	DW		IncludeBinDirec
	DW		0


EVEN 2
IncludeLibDirective:
	DW		IncludeLibDirec
	DW		0xFAFB


EVEN 2
IncludeRCDirective:
	DW		IncludeRCDirec
	DW		0xFAFB


EVEN 2
insInstr:
	DW		InSPInstr


EVEN 2
insbInstr:
	DW		NoOperand
	DB		0x6C


EVEN 2
insdInstr:
	DW		NoOperand32
	DB		0x6D


EVEN 2
insertpsInstr:
	DW		SSE_R_R128M32_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x21


EVEN 2
insertqInstr:
	DW		(NotCoded)


EVEN 2
inswInstr:
	DW		NoOperand16
	DB		0x06D


EVEN 2
intInstr:
	DW		Imm8op
	DB		0x0CD


EVEN 2
intoInstr:
	DW		NoOperand
	DB		0xCE,0x00


EVEN 2
invdInstr:
	DW		NoOpW
	DB		0x0F,0x08


EVEN 2
invlpgInstr:
	DW		MemOp
	DB		0x0F,01,56,0


EVEN 2
InvokeDirective:
	DW		InvokeDirec
	DW		0


EVEN 2
iretInstr:
	DW		IretXInstr
	DB		0x0CF


EVEN 2
iretdInstr:
	DW		NoOperand32
	DB		0x0CF


EVEN 2
iretqInstr:
	DW		NoOperand64
	DB		0x0CF


EVEN 2
iretwInstr:
	DW		NoOperand16
	DB		0x0CF


EVEN 2
IRPDirective:
	DW		IRPDirec
	DW		0xFAFB


EVEN 2
IRPSMacro:
	DW		IRPSMac
	DW		0xFAFB


EVEN 2
jaInstr:
	DW		CondJump
	DB		0x77


EVEN 2
jaeInstr:
	DW		CondJump
	DB		0x73


EVEN 2
jbInstr:
	DW		CondJump
	DB		0x72


EVEN 2
jbeInstr:
	DW		CondJump
	DB		0x76


EVEN 2
jcxzInstr:
	DW		Loop16Instr
	DB		0x0E3


EVEN 2
jzInstr:
	DW		CondJump
	DB		0x74


EVEN 2
jecxzInstr:
	DW		Loop32Instr
	DB		0x0E3


EVEN 2
jgInstr:
	DW		CondJump
	DB		0x7F


EVEN 2
jgeInstr:
	DW		CondJump
	DB		0x7D


EVEN 2
jlInstr:
	DW		CondJump
	DB		0x7C


EVEN 2
jleInstr:
	DW		CondJump
	DB		0x7E


EVEN 2
jmpInstr:
	DW		JumpInstr


EVEN 2
jncInstr:
	DW		CondJump
	DB		0x73


EVEN 2
jnzInstr:
	DW		CondJump
	DB		0x75


EVEN 2
jnoInstr:
	DW		CondJump
	DB		0x71


EVEN 2
jpoInstr:
	DW		CondJump
	DB		0x7B


EVEN 2
jnsInstr:
	DW		CondJump
	DB		0x79


EVEN 2
joInstr:
	DW		CondJump
	DB		0x70


EVEN 2
jpInstr:
	DW		CondJump
	DB		0x7A


EVEN 2
jsInstr:
	DW		CondJump
	DB		0x78


EVEN 2
LabelDirective:
	DW		DirectiveMissingLabel
	DW		(LabelDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
lahfInstr:
	DW		NoOperand
	DB		0x9F


EVEN 2
larInstr:
	DW		PMInstr3
	DB		0x0F,0x02


EVEN 2
lddquInstr:
	DW		SSE_R_M_Instr
	DB		0x03,0xF2,0x0F,0xF0


EVEN 2
ldmxcsrInstr:
	DW		MemOp
	DB		0x0F,0x0AE,16,_DWORD


EVEN 2
ldsInstr:
	DW		LxS1Instr
	DB		0x0C5


EVEN 2
leaInstr:
	DW		LEAPInstr
	DB		0x08D


EVEN 2
leaveInstr:
	DW		NoOperand
	DB		0xC9


EVEN 2
leavedInstr:
	DW		NoOperand32
	DB		0x0C9


EVEN 2
lesInstr:
	DW		LxS1Instr
	DB		0x0C4


EVEN 2
lfenceInstr:
	DW		NoOpF
	DB		0x0F,0x0AE,0x0E8


EVEN 2
lfsInstr:
	DW		LxS2Instr
	DB		0x0F,0x0B4


EVEN 2
lgdtInstr:
	DW		PMDescInstr
	DB		16


EVEN 2
lgsInstr:
	DW		Lxs2Instr
	DB		0x0F,0x0B5


EVEN 2
lidtInstr:
	DW		PMDescInstr
	DB		24


EVEN 2
lldtInstr:
	DW		PMInstr1
	DB		0x0F,00,16


EVEN 2
lmswInstr:
	DW		PMInstr1
	DB		0x0F,01,48


EVEN 2
loadallInstr:
	DW		NoOpW
	DB		0x0F,0x07


EVEN 2
LocalDirective:
	DW		LocalDirec
	DW		0


EVEN 2
lockInstr:
	DW		NoOperand
	DB		0xF0


EVEN 2
lodsInstr:
	DW		LodSPInstr


EVEN 2
lodsbInstr:
	DW		NoOperand
	DB		0xAC


EVEN 2
lodsdInstr:
	DW		NoOperand32
	DB		0x0AD


EVEN 2
lodsqInstr:
	DW		NoOperand64
	DB		0x0AD


EVEN 2
lodswInstr:
	DW		NoOperand16
	DB		0x0AD


EVEN 2
loopInstr:
	DW		Loop16Instr
	DB		0x0E2


EVEN 2
loopdInstr:
	DW		Loop32Instr
	DB		0x0E2


EVEN 2
loopdzInstr:
	DW		loop32Instr
	DB		0x0E1


EVEN 2
loopdnzInstr:
	DW		loop32Instr
	DB		0x0E0


EVEN 2
loopzInstr:
	DW		loop16Instr
	DB		0x0E1


EVEN 2
loopnzInstr:
	DW		loop16Instr
	DB		0x0E0


EVEN 2
lslInstr:
	DW		PMInstr3
	DB		0x0F,0x03


EVEN 2
lssInstr:
	DW		Lxs2Instr
	DB		0x0F,0x0B2


EVEN 2
ltrInstr:
	DW		PMInstr2
	DB		0x0F,00,24


EVEN 2
MacroDirective:
	DW		DirectiveMissingLabel
	DW		(MacroDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
maskmovdquInstr:
	DW		NotCoded


EVEN 2
maskmovqInstr:
	DW		MMX_R_R
	DB		0x02,0x0F,0x0F7


EVEN 2
maxpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x5F


EVEN 2
maxpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x5F


EVEN 2
maxsdInstr:
	DW		ExtendedSD
	DB		0x5F


EVEN 2
maxssInstr:
	DW		ExtendedSS
	DB		0x5F


EVEN 2
mfenceInstr:
	DW		NoOpF
	DB		0x0F,0x0AE,0x0F0


EVEN 2
minpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x5D


EVEN 2
minpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x5D


EVEN 2
minsdInstr:
	DW		ExtendedSD
	DB		0x5D


EVEN 2
minssInstr:
	DW		ExtendedSS
	DB		0x5D


EVEN 2
monitorInstr:
	DW		MonitorPInstr


EVEN 2
movInstr:
	DW		moveInstr


EVEN 2
movapdInstr:
	DW		SSEDouble
	DB		0x28,0x29


EVEN 2
movapsInstr:
	DW		SSESingle
	DB		0x28,0x29


EVEN 2
movdInstr:
	DW		movdpInstr
	DB		0x06E


EVEN 2
movddupInstr:
	DW		ExtendedSD
	DB		0x12


EVEN 2
movdq2qInstr:
	DW		MMX_R_R128
	DB		0x02,0xF2,0xD6


EVEN 2
movdqaInstr:
	DW		SSEDouble
	DB		0x6F,0x7F


EVEN 2
movdquInstr:
	DW		SSEUnaligned
	DB		0x6F,0x7F


EVEN 2
movhlpsInstr:
	DW		SSE_R_R_Instr_Single
	DB		0x02,0x0F,0x12


EVEN 2
movhpdInstr:
	DW		MOVxPD
	DB		0x16,0x17


EVEN 2
movhpsInstr:
	DW		MOVxPS
	DB		0x16,0x17


EVEN 2
movlhpsInstr:
	DW		NotCoded
	DB		0x16


EVEN 2
movlpdInstr:
	DW		MOVxPD
	DB		0x12,0x13


EVEN 2
movlpsInstr:
	DW		MOVxPS
	DB		0x12,0x13


EVEN 2
movmskpdInstr:
	DW		SSE_REG32REG64_R
	DB		0x02,0x0F,0x50


EVEN 2
movmskpsInstr:
	DW		NotCoded
	DB		0x50


EVEN 2
movntdqInstr:
	DW		NotCoded


EVEN 2
movntdqaInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x2A


EVEN 2
movntiInstr:
	DW		NotCoded


EVEN 2
movntpdInstr:
	DW		SSE_M_R_Instr_Double
	DB		0x02,0x0F,0x2B


EVEN 2
movntpsInstr:
	DW		SSE_M_R_Instr_Single
	DB		0x02,0x0F,0x2B


EVEN 2
movntqInstr:
	DW		MMX_M_R
	DB		0x02,0x0F,0x0E7


EVEN 2
movntsdInstr:
	DW		SSE_M64_R
	DB		0x03,0xF2,0x0F,0x2B


EVEN 2
movntssInstr:
	DW		SSE_M32_R
	DB		0x03,0xF3,0x0F,0x2B


EVEN 2
movqInstr:
	DW		MMX_SSE_R_RxM64__RxM64_R_Instr_DiffSet
	DB		0x02,0x0F,0x6F,0x02,0x0F,0x7F,0x03,0xF3,0x0F,0x07E,0x03,0x66,0x0F,0xD6


EVEN 2
movq2dqInstr:
	DW		SSE_R_R64
	DB		0x03,0xF3,0x0F,0xD6


EVEN 2
movsInstr:
	DW		MovSPInstr


EVEN 2
movsbInstr:
	DW		NoOperand
	DB		0xA4


EVEN 2
movsdInstr:
	DW		CmpSDPInstr
	DB		0x0A5,0x10,0x11


EVEN 2
movshdupInstr:
	DW		NotCoded


EVEN 2
movsldupInstr:
	DW		NotCoded


EVEN 2
movsqInstr:
	DW		NoOperand64
	DB		0x0A5


EVEN 2
movssInstr:
	DW		SSESS
	DB		0x10,0x11


EVEN 2
movswInstr:
	DW		NoOperand16
	DB		0x0A5


EVEN 2
movsxInstr:
	DW		movxxInstr
	DB		0x0F,0xBE


EVEN 2
movsxdInstr:
	DW		movsxdpInstr


EVEN 2
movupdInstr:
	DW		SSEDouble
	DB		0x10,0x11


EVEN 2
movupsInstr:
	DW		SSESingle
	DB		0x10,0x11


EVEN 2
movzxInstr:
	DW		movxxInstr
	DB		0x0F,0xB6


EVEN 2
mpsadbwInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x42


EVEN 2
mulInstr:
	DW		SingleOp
	DB		32


EVEN 2
mulpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x59


EVEN 2
mulpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x59


EVEN 2
mulsdInstr:
	DW		ExtendedSD
	DB		0x59


EVEN 2
mulssInstr:
	DW		ExtendedSS


EVEN 2
mwaitInstr:
	DW		MWaitPInstr


EVEN 2
negInstr:
	DW		SingleOp
	DB		24


EVEN 2
nopInstr:
	DW		NoOperand
	DB		0x90


EVEN 2
notInstr:
	DW		SingleOp
	DB		16


EVEN 2
OptionDirective:
	DW		OptionDirec
	DW		0xFAFB


EVEN 2
orInstr:
	DW		BasicInstr
	DB		8


EVEN 2
OrgDirective:
	DW		OrgDirec
	DW		0xFAFB


EVEN 2
orpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x56


EVEN 2
orpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x56


EVEN 2
outInstr:
	DW		outpInstr


EVEN 2
outsInstr:
	DW		OutSPInstr


EVEN 2
outsbInstr:
	DW		NoOperand
	DB		0x06E


EVEN 2
outsdInstr:
	DW		NoOperand32
	DB		0x06F


EVEN 2
outswInstr:
	DW		NoOperand16
	DB		0x06F


EVEN 2
pabsbInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x1C


EVEN 2
pabsdInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x1E


EVEN 2
pabswInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x1D


EVEN 2
packssdwInstr:
	DW		MMX_SSE_R_RM
	DB		0x6B


EVEN 2
packsswbInstr:
	DW		MMX_SSE_R_RM
	DB		0x63


EVEN 2
packusdwInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x2B


EVEN 2
packuswbInstr:
	DW		BasicMMX
	DB		0x67


EVEN 2
paddbInstr:
	DW		BasicMMX
	DB		0x0FC


EVEN 2
padddInstr:
	DW		BasicMMX
	DB		0x0FE


EVEN 2
paddqInstr:
	DW		BasicMMX
	DB		0x0D4


EVEN 2
paddsbInstr:
	DW		BasicMMX
	DB		0x0EC


EVEN 2
paddsiwInstr:
	DW		NotCoded
	DB		0x51


EVEN 2
paddswInstr:
	DW		BasicMMX
	DB		0x0ED


EVEN 2
paddusbInstr:
	DW		BasicMMX
	DB		0x0DC


EVEN 2
padduswInstr:
	DW		BasicMMX
	DB		0x0DD


EVEN 2
paddwInstr:
	DW		BasicMMX
	DB		0x0FD


EVEN 2
palignrInstr:
	DW		MMX_SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0F


EVEN 2
pandInstr:
	DW		BasicMMX
	DB		0x0DB


EVEN 2
pandnInstr:
	DW		BasicMMX
	DB		0x0DF


EVEN 2
pauseInstr:
	DW		NoOpW
	DB		0x0F3,0x90


EVEN 2
pavebInstr:
	DW		NotCoded
	DB		0x50


EVEN 2
pavgbInstr:
	DW		BasicMMX
	DB		0x0E0


EVEN 2
pavgusbInstr:
	DW		NotCoded
	DB		0x0F,0x0F,0x0BF,_OWORD


EVEN 2
pavgwInstr:
	DW		BasicMMX
	DB		0x0E3


EVEN 2
pblendvbInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x10


EVEN 2
pblendwInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0E


EVEN 2
pclmulqdqInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x44


EVEN 2
pcmpeqbInstr:
	DW		BasicMMX
	DB		0x74


EVEN 2
pcmpeqdInstr:
	DW		BasicMMX
	DB		0x76


EVEN 2
pcmpeqqInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x29


EVEN 2
pcmpeqwInstr:
	DW		BasicMMX
	DB		0x75


EVEN 2
pcmpestriInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x61


EVEN 2
pcmpestrmInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x60


EVEN 2
pcmpgtbInstr:
	DW		BasicMMX
	DB		0x64


EVEN 2
pcmpgtdInstr:
	DW		BasicMMX
	DB		0x66


EVEN 2
pcmpgtqInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x37


EVEN 2
pcmpgtwInstr:
	DW		BasicMMX
	DB		0x65


EVEN 2
pcmpistriInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x63


EVEN 2
pcmpistrmInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x62


EVEN 2
pdistibInstr:
	DW		NotCoded
	DB		0x54


EVEN 2
pextrbInstr:
	DW		SSE_REG32REG64M8_R_Imm8
	DB		0x04,0x0F,0x3A,0x14


EVEN 2
pextrdInstr:
	DW		SSE_R32M32_R_Imm8_Double
	DB		0x03,0x0F,0x3A,0x16


EVEN 2
pextrqInstr:
	DW		SSE_R64M64_R_Imm8_Double
	DB		0x03,0x0F,0x3A,0x16


EVEN 2
pextrwInstr:
	DW		MMX_R32_R64_IMM8_Instr
	DB		0x02,0x0F,0x0C5


EVEN 2
pf2idInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x1D


EVEN 2
pf2iwInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x1C


EVEN 2
pfaccInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xAE


EVEN 2
pfaddInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x9E


EVEN 2
pfcmpeqInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xB0


EVEN 2
pfcmpgeInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x90


EVEN 2
pfcmpgtInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xA0


EVEN 2
pfmaxInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xA4


EVEN 2
pfminInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x94


EVEN 2
pfmulInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xB4


EVEN 2
pfnaccInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x8A


EVEN 2
pfpnaccInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x8E


EVEN 2
pfrcpInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x96


EVEN 2
pfrcpit1Instr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xA6


EVEN 2
pfrcpit2Instr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xB6


EVEN 2
pfrsqit1Instr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xA7


EVEN 2
pfrsqrtInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x97


EVEN 2
pfsubInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x9A


EVEN 2
pfsubrInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0xAA


EVEN 2
phadddInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x02


EVEN 2
phaddswInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x03


EVEN 2
phaddwInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x01


EVEN 2
phminposuwInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x41


EVEN 2
phsubdInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x06


EVEN 2
phsubswInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x07


EVEN 2
phsubwInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x05


EVEN 2
pi2fdInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x0D


EVEN 2
pi2fwInstr:
	DW		MMX_R_RM__With_Extra
	DB		0x02,0x0F,0x0F,0x0C


EVEN 2
pinsrbInstr:
	DW		SSE_R_REG32M8_Imm8_Instr
	DB		0x03,0x0F,0x3A,0x20


EVEN 2
pinsrdInstr:
	DW		SSE_R_REG32M32_Imm8_Instr
	DB		0x03,0x0F,0x3A,0x20


EVEN 2
pinsrqInstr:
	DW		SSE_R_REGM64_Imm8_Instr
	DB		0x03,0x0F,0x3A,0x22


EVEN 2
pinsrwInstr:
	DW		MMX_SSE_R_REG32M16_Imm8_Instr
	DB		0x02,0x0F,0xC4


EVEN 2
pmachriwInstr:
	DW		NotCoded
	DB		0x5E


EVEN 2
pmaddubswInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x04


EVEN 2
pmaddwdInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x02,0x0F,0xF5


EVEN 2
pmagwInstr:
	DW		NotCoded
	DB		0x52


EVEN 2
pmaxsbInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x3C


EVEN 2
pmaxsdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x3D


EVEN 2
pmaxswInstr:
	DW		BasicMMX
	DB		0x0EE


EVEN 2
pmaxubInstr:
	DW		BasicMMX
	DB		0x0DE


EVEN 2
pmaxudInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x3F


EVEN 2
pmaxuwInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x3E


EVEN 2
pminsbInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x38


EVEN 2
pminsdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x39


EVEN 2
pminswInstr:
	DW		BasicMMX
	DB		0x0EA


EVEN 2
pminubInstr:
	DW		BasicMMX
	DB		0x0DA


EVEN 2
pminudInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x3B


EVEN 2
pminuwInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x3A


EVEN 2
pmovmskbInstr:
	DW		NotCoded
	DB		0x0EE


EVEN 2
pmovsxbdInstr:
	DW		SSE_R_R128M32_Instr_Double
	DB		0x03,0x0F,0x38,0x21


EVEN 2
pmovsxbqInstr:
	DW		SSE_R_R128M16_Instr_Double
	DB		0x03,0x0F,0x38,0x22


EVEN 2
pmovsxbwInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x03,0x0F,0x38,0x20


EVEN 2
pmovsxdqInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x03,0x0F,0x38,0x25


EVEN 2
pmovsxwdInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x03,0x0F,0x38,0x23


EVEN 2
pmovsxwqInstr:
	DW		SSE_R_R128M32_Instr_Double
	DB		0x03,0x0F,0x38,0x24


EVEN 2
pmovzxbdInstr:
	DW		SSE_R_R128M32_Instr_Double
	DB		0x03,0x0F,0x38,0x31


EVEN 2
pmovzxbqInstr:
	DW		SSE_R_R128M16_Instr_Double
	DB		0x03,0x0F,0x38,0x32


EVEN 2
pmovzxbwInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x03,0x0F,0x38,0x30


EVEN 2
pmovzxdqInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x03,0x0F,0x38,0x35


EVEN 2
pmovzxwdInstr:
	DW		SSE_R_R128M64_Instr_Double
	DB		0x03,0x0F,0x38,0x33


EVEN 2
pmovzxwqInstr:
	DW		SSE_R_R128M32_Instr_Double
	DB		0x03,0x0F,0x38,0x34


EVEN 2
pmuldqInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x28


EVEN 2
pmulhriwInstr:
	DW		NotCoded
	DB		0x5D


EVEN 2
pmulhrswInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x0B


EVEN 2
pmulhrwInstr:
	DW		NotCoded
	DB		0x0B7


EVEN 2
pmulhuwInstr:
	DW		BasicMMX
	DB		0x0E4


EVEN 2
pmulhwInstr:
	DW		BasicMMX
	DB		0x0E5


EVEN 2
pmulldInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x40


EVEN 2
pmullwInstr:
	DW		BasicMMX
	DB		0x0D5


EVEN 2
pmuludqInstr:
	DW		BasicMMX
	DB		0x0F4


EVEN 2
pmvgezbInstr:
	DW		NotCoded
	DB		0x05C


EVEN 2
pmvlzbInstr:
	DW		NotCoded
	DB		0x05B


EVEN 2
pmvnzbInstr:
	DW		NotCoded
	DB		0x05A


EVEN 2
pmvzbInstr:
	DW		NotCoded
	DB		0x058


EVEN 2
popInstr:
	DW		poppInstr


EVEN 2
popaInstr:
	DW		NoOperand
	DB		0x61


EVEN 2
popadInstr:
	DW		NoOperand32
	DB		0x61


EVEN 2
popfInstr:
	DW		NoOperand
	DB		0x9D


EVEN 2
popfdInstr:
	DW		NoOperand32
	DB		0x9D


EVEN 2
PopFQInstr:
	DW		NoOperand64
	DB		0x9D


EVEN 2
PopFWInstr:
	DW		NoOperand16
	DB		0x9D


EVEN 2
porInstr:
	DW		BasicMMX
	DB		0x0EB


EVEN 2
prefetchInstr:
	DW		PrefetchPInstr
	DB		0x0D,0


EVEN 2
prefetchntaInstr:
	DW		PrefetchPInstr
	DB		0x18,0


EVEN 2
prefetcht0Instr:
	DW		PrefetchPInstr
	DB		0x18,8


EVEN 2
prefetcht1Instr:
	DW		PrefetchPInstr
	DB		0x18,16


EVEN 2
prefetcht2Instr:
	DW		PrefetchPInstr
	DB		0x18,24


EVEN 2
prefetchwInstr:
	DW		PrefetchPInstr
	DB		0x0D,16


EVEN 2
ProcDirective:
	DW		DirectiveMissingLabel
	DW		(ProcDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
psadbwInstr:
	DW		NotCoded
	DB		0x0F6


EVEN 2
pshufbInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x00


EVEN 2
pshufdInstr:
	DW		CMPSSPInstr
	DB		0x0F,0x70,0x66,_OWORD


EVEN 2
pshufhwInstr:
	DW		CMPSSPInstr
	DB		0x0F,0x70,0x0F3,_OWORD


EVEN 2
pshuflwInstr:
	DW		CMPSSPInstr
	DB		0x0F,0x70,0x0F2,_OWORD


EVEN 2
pshufwInstr:
	DW		NotCoded


EVEN 2
psignbInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x08


EVEN 2
psigndInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x0A


EVEN 2
psignwInstr:
	DW		MMX_SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0x09


EVEN 2
pslldInstr:
	DW		SSEShift
	DB		0x0F2,48


EVEN 2
pslldqInstr:
	DW		NotCoded


EVEN 2
psllqInstr:
	DW		SSEShift
	DB		0x0F3,48


EVEN 2
psllwInstr:
	DW		SSEShift
	DB		0x0F1,48


EVEN 2
psradInstr:
	DW		SSEShift
	DB		0x0E2,32


EVEN 2
psrawInstr:
	DW		SSEShift
	DB		0x0E1,32


EVEN 2
psrldInstr:
	DW		SSEShift
	DB		0x0D2,16


EVEN 2
psrldqInstr:
	DW		NotCoded


EVEN 2
psrlqInstr:
	DW		SSEShift
	DB		0x0D3,16


EVEN 2
psrlwInstr:
	DW		SSEShift
	DB		0x0D1,16


EVEN 2
psubbInstr:
	DW		BasicMMX
	DB		0x0F8


EVEN 2
psubdInstr:
	DW		BasicMMX
	DB		0x0FA


EVEN 2
psubqInstr:
	DW		BasicMMX
	DB		0x0FB


EVEN 2
psubsbInstr:
	DW		BasicMMX
	DB		0x0E8


EVEN 2
psubsiwInstr:
	DW		NotCoded
	DB		0x055


EVEN 2
psubswInstr:
	DW		BasicMMX
	DB		0x0E9


EVEN 2
psubusbInstr:
	DW		BasicMMX
	DB		0x0D8


EVEN 2
psubuswInstr:
	DW		BasicMMX
	DB		0x0D9


EVEN 2
psubwInstr:
	DW		BasicMMX
	DB		0x0F9


EVEN 2
pswapdInstr:
	DW		NotCoded
	DB		0x0BB


EVEN 2
ptestInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0x17


EVEN 2
PublicDirective:
	DW		PublicDirec
	DW		0xFAFB


EVEN 2
punpckhbwInstr:
	DW		BasicMMX
	DB		0x068


EVEN 2
punpckhdqInstr:
	DW		BasicMMX
	DB		0x06A


EVEN 2
punpckhqdqInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x6D


EVEN 2
punpckhwdInstr:
	DW		BasicMMX
	DB		0x069


EVEN 2
punpcklbwInstr:
	DW		BasicMMX
	DB		0x060


EVEN 2
punpckldqInstr:
	DW		BasicMMX
	DB		0x062


EVEN 2
punpcklqdqInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x6C


EVEN 2
punpcklwdInstr:
	DW		BasicMMX
	DB		0x061


EVEN 2
pushInstr:
	DW		pushpInstr


EVEN 2
pushaInstr:
	DW		NoOperand
	DB		0x60


EVEN 2
pushadInstr:
	DW		NoOperand32
	DB		0x60


EVEN 2
pushdInstr:
	DW		Imm32op
	DB		0x68


EVEN 2
pushfInstr:
	DW		NoOperand
	DB		0x9C


EVEN 2
pushfdInstr:
	DW		NoOperand32
	DB		0x9C


EVEN 2
pushfqInstr:
	DW		NoOperand64
	DB		0x9C


EVEN 2
pushfwInstr:
	DW		NoOperand16
	DB		0x9C


EVEN 2
pxorInstr:
	DW		BasicMMX
	DB		0x0EF


EVEN 2
RadixDirective:
	DW		RadixDirec
	DW		0xFAFB


EVEN 2
rclInstr:
	DW		shiftInstr
	DB		16


EVEN 2
rcppsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x53


EVEN 2
rcpssInstr:
	DW		ExtendedSS
	DB		0x0F3,0x53


EVEN 2
rcrInstr:
	DW		shiftInstr
	DB		24


EVEN 2
rdmsrInstr:
	DW		NoOpW
	DB		0x0F,0x32


EVEN 2
rdpmcInstr:
	DW		NoOpW
	DB		0x0F,0x33


EVEN 2
rdtscInstr:
	DW		NoOpW
	DB		0x0F,0x31


EVEN 2
repInstr:
	DW		Repprefix
	DB		0x0F3


EVEN 2
repeInstr:
	DW		Repprefix
	DB		0x0F3


EVEN 2
RepeatDirective:
	DW		RepeatDirec
	DW		0xFAFB


EVEN 2
repneInstr:
	DW		Repprefix
	DB		0x0F2


EVEN 2
repnzInstr:
	DW		Repprefix
	DB		0x0F2


EVEN 2
repzInstr:
	DW		Repprefix
	DB		0x0F3


EVEN 2
ResourceDirective:
	DW		ResourceDirec
	DW		(RCDefine)
	DB		ByteID,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
retInstr:
	DW		RetPInstr
	DB		0x0C3


EVEN 2
retdInstr:
	DW		Ret32Instr
	DB		0x0C3


EVEN 2
retfInstr:
	DW		RetfPInstr
	DB		0x0CB


EVEN 2
retfdInstr:
	DW		RetfP32Instr
	DB		0x0CB


EVEN 2
retfqInstr:
	DW		RetfP64Instr
	DB		0x0CB


EVEN 2
retfwInstr:
	DW		Ret16Instr
	DB		0x0CB


EVEN 2
retnInstr:
	DW		RetPInstr
	DB		0x0C3


EVEN 2
retqInstr:
	DW		Ret64Instr
	DB		0x0C3


EVEN 2
retwInstr:
	DW		Ret16Instr
	DB		0x0C3


EVEN 2
rolInstr:
	DW		shiftInstr
	DB		0


EVEN 2
rorInstr:
	DW		shiftInstr
	DB		8


EVEN 2
roundpdInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x09


EVEN 2
roundpsInstr:
	DW		SSE_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x08


EVEN 2
roundsdInstr:
	DW		SSE_R_R128M64_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0B


EVEN 2
roundssInstr:
	DW		SSE_R_R128M32_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0A


EVEN 2
rsmInstr:
	DW		NoOpW
	DB		0x0F,0x0AA


EVEN 2
rsqrtpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x52


EVEN 2
rsqrtssInstr:
	DW		ExtendedSS
	DB		0x52


EVEN 2
sahfInstr:
	DW		NoOperand
	DB		0x9E


EVEN 2
salInstr:
	DW		shiftInstr
	DB		32


EVEN 2
sarInstr:
	DW		shiftInstr
	DB		56


EVEN 2
sbbInstr:
	DW		BasicInstr
	DB		24


EVEN 2
scasInstr:
	DW		ScaSPInstr


EVEN 2
scasbInstr:
	DW		NoOperand
	DB		0xAE


EVEN 2
scasdInstr:
	DW		NoOperand32
	DB		0x0AF


EVEN 2
scasqInstr:
	DW		NoOperand64
	DB		0x0AF


EVEN 2
scaswInstr:
	DW		NoOperand16
	DB		0x0AF


EVEN 2
SegmentDirective:
	DW		SegmentDirecNoLabel
	DW		(SegmentDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
segcsInstr:
	DW		NoOperand
	DB		0x2E


EVEN 2
segdsInstr:
	DW		NoOperand
	DB		0x3E


EVEN 2
segesInstr:
	DW		NoOperand
	DB		0x26


EVEN 2
segfsInstr:
	DW		NoOperand
	DB		0x64


EVEN 2
seggsInstr:
	DW		NoOperand
	DB		0x65


EVEN 2
segssInstr:
	DW		NoOperand
	DB		0x36


EVEN 2
setaInstr:
	DW		setInstr
	DB		0x0F,0x97


EVEN 2
setaeInstr:
	DW		setInstr
	DB		0x0F,0x93


EVEN 2
setalcInstr:
	DW		NoOperand
	DB		0x0D6


EVEN 2
setbInstr:
	DW		setInstr
	DB		0x0F,0x92


EVEN 2
setbeInstr:
	DW		setInstr
	DB		0x0F,0x96


EVEN 2
setcInstr:
	DW		setInstr
	DB		0x0F,0x92


EVEN 2
seteInstr:
	DW		setInstr
	DB		0x0F,0x94


EVEN 2
setgInstr:
	DW		setInstr
	DB		0x0F,0x9F


EVEN 2
setgeInstr:
	DW		setInstr
	DB		0x0F,0x9D


EVEN 2
setlInstr:
	DW		setInstr
	DB		0x0F,0x9C


EVEN 2
setleInstr:
	DW		setInstr
	DB		0x0F,0x9E


EVEN 2
setnaInstr:
	DW		setInstr
	DB		0x0F,0x96


EVEN 2
setnaeInstr:
	DW		setInstr
	DB		0x0F,0x92


EVEN 2
setnbInstr:
	DW		setInstr
	DB		0x0F,0x93


EVEN 2
setnbeInstr:
	DW		setInstr
	DB		0x0F,0x97


EVEN 2
setncInstr:
	DW		setInstr
	DB		0x0F,0x93


EVEN 2
setneInstr:
	DW		setInstr
	DB		0x0F,0x95


EVEN 2
setngInstr:
	DW		setInstr
	DB		0x0F,0x9E


EVEN 2
setngeInstr:
	DW		setInstr
	DB		0x0F,0x9C


EVEN 2
setnlInstr:
	DW		setInstr
	DB		0x0F,0x9D


EVEN 2
setnleInstr:
	DW		setInstr
	DB		0x0F,0x9F


EVEN 2
setnoInstr:
	DW		setInstr
	DB		0x0F,0x91


EVEN 2
setnpInstr:
	DW		setInstr
	DB		0x0F,0x9B


EVEN 2
setnsInstr:
	DW		setInstr
	DB		0x0F,0x99


EVEN 2
setnzInstr:
	DW		setInstr
	DB		0x0F,0x95


EVEN 2
setoInstr:
	DW		setInstr
	DB		0x0F,0x90


EVEN 2
setpInstr:
	DW		setInstr
	DB		0x0F,0x9A


EVEN 2
setpeInstr:
	DW		setInstr
	DB		0x0F,0x9A


EVEN 2
setpoInstr:
	DW		setInstr
	DB		0x0F,0x9B


EVEN 2
setsInstr:
	DW		setInstr
	DB		0x0F,0x98


EVEN 2
setzInstr:
	DW		setInstr
	DB		0x0F,0x94


EVEN 2
sfenceInstr:
	DW		noopf
	DB		0x0F,0x0AE,0x0F8


EVEN 2
sgdtInstr:
	DW		PMDescInstr
	DB		0


EVEN 2
sha1msg1Instr:
	DW		SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0xC9


EVEN 2
sha1msg2Instr:
	DW		SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0xCA


EVEN 2
sha1nexteInstr:
	DW		SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0xC8


EVEN 2
sha1rnds4Instr:
	DW		SSE_R_RM_Imm8_Instr
	DB		0x03,0x0F,0x3A,0xCC


EVEN 2
sha256msg1Instr:
	DW		SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0xCC


EVEN 2
sha256msg2Instr:
	DW		SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0xCD


EVEN 2
sha256rnds2Instr:
	DW		SSE_R_RM_Instr
	DB		0x03,0x0F,0x38,0xCB


EVEN 2
shlInstr:
	DW		shiftInstr
	DB		32


EVEN 2
shldInstr:
	DW		shxdInstr
	DB		0x0F,0x0A5


EVEN 2
shrInstr:
	DW		shiftInstr
	DB		40


EVEN 2
shrdInstr:
	DW		shxdInstr
	DB		0x0F,0x0AD


EVEN 2
shufpdInstr:
	DW		CMPSSPInstr
	DB		0x0F,0x0C6,0x66,_OWORD


EVEN 2
shufpsInstr:
	DW		CMPPSPInstr
	DB		0x0F,0x0C6,_OWORD


EVEN 2
sidtInstr:
	DW		PMDescInstr
	DB		8


EVEN 2
sldtInstr:
	DW		PMInstr2
	DB		0x0F,00,00


EVEN 2
smiInstr:
	DW		NoOperand
	DB		0x0F1


EVEN 2
smswInstr:
	DW		PMInstr2
	DB		0x0F,01,32


EVEN 2
sqrtpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x51


EVEN 2
sqrtpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x51


EVEN 2
sqrtsdInstr:
	DW		ExtendedSD
	DB		0x51


EVEN 2
sqrtssInstr:
	DW		ExtendedSS
	DB		0x51


EVEN 2
StackDirective:
	DW		StackDirec


EVEN 2
stcInstr:
	DW		NoOperand
	DB		0x0F9


EVEN 2
stdInstr:
	DW		NoOperand
	DB		0x0FD


EVEN 2
stiInstr:
	DW		NoOperand
	DB		0x0FB


EVEN 2
stmxcsrInstr:
	DW		MemOp
	DB		0x0F,0x0AE,24,_DWORD


EVEN 2
stosInstr:
	DW		StoSPInstr


EVEN 2
stosbInstr:
	DW		NoOperand
	DB		0x0AA


EVEN 2
stosdInstr:
	DW		NoOperand32
	DB		0x0AB


EVEN 2
stosqInstr:
	DW		NoOperand64
	DB		0x0AB


EVEN 2
stoswInstr:
	DW		NoOperand16
	DB		0x0AB


EVEN 2
strInstr:
	DW		PMInstr2
	DB		0x0F,0,8


EVEN 2
StrucDirective:
	DW		DirectiveMissingLabel
	DW		(StrucDirec)
	DB		00h,00h,0Fh,0Ah,0Ch,0Eh


EVEN 2
subInstr:
	DW		BasicInstr
	DB		40


EVEN 2
subpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x5C


EVEN 2
subpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x5C


EVEN 2
subsdInstr:
	DW		ExtendedSD
	DB		0x5C


EVEN 2
subssInstr:
	DW		ExtendedSS
	DB		0x5C


EVEN 2
SwapGSInstr:
	DW		SwapGSPInstr


EVEN 2
syscallInstr:
	DW		NoOpW
	DB		0x0F,0x05


EVEN 2
sysenterInstr:
	DW		NoOpW
	DB		0x0F,0x34


EVEN 2
sysexitInstr:
	DW		NoOpW
	DB		0x0F,0x35


EVEN 2
sysretInstr:
	DW		NoOpW
	DB		0x0F,0x07


EVEN 2
testInstr:
	DW		testpInstr


EVEN 2
typedefDirective:
	DW		TypeDefDirec
	DW		(TypeDefDirec)


EVEN 2
ucomisdInstr:
	DW		BasicSD
	DB		0x2E


EVEN 2
ucomissInstr:
	DW		BasicSS
	DB		0x2E


EVEN 2
udInstr:
	DW		NoOpW
	DB		0x0F,0x0FF


EVEN 2
ud2Instr:
	DW		NoOpW
	DB		0x0F,0x0B


EVEN 2
umovInstr:
	DW		umovInstr


EVEN 2
unpckhpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x15


EVEN 2
unpckhpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x15


EVEN 2
unpcklpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x14


EVEN 2
unpcklpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x14


EVEN 2
Use16Directive:
	DW		Use16Direc


EVEN 2
Use32Directive:
	DW		Use32Direc


EVEN 2
Use64Directive:
	DW		Use64Direc


EVEN 2
vaddpdInstr:
	DW		SSE_R_RM_AVX5_R_R_RM_Instr
	DB		0x58


EVEN 2
vaddpsInstr:
	DW		SSE_AVX5_R_R_RxMxM32_WriteMask_Z
	DB		0x02,0x0F,0x58


EVEN 2
vaddsdInstr:
	DW		SSE_AVX5_R_R_RxM64_WriteMask_Z
	DB		0x03,0xF2,0x0F,0x58


EVEN 2
vaddssInstr:
	DW		SSE_AVX5_R_R_RxM32_WriteMask_Z
	DB		0x03,0xF3,0x0F,0x58


EVEN 2
vaddsubpdInstr:
	DW		SSE_AVX_R_R_RM_Instr
	DB		0x02,0x0F,0xD0


EVEN 2
vaddsubpsInstr:
	DW		SSE_AVX_R_R_RM_Instr
	DB		0x03,0xF2,0x0F,0xD0


EVEN 2
vaesdecInstr:
	DW		SSE_AVX5_R_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDE


EVEN 2
vaesdeclastInstr:
	DW		SSE_AVX5_R_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDF


EVEN 2
vaesencInstr:
	DW		SSE_AVX5_R_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDC


EVEN 2
vaesenclastInstr:
	DW		SSE_AVX5_R_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDD


EVEN 2
vaesimcInstr:
	DW		SSE_AVX_R_RM_Instr_Double
	DB		0x03,0x0F,0x38,0xDB


EVEN 2
vaeskeygenassistInstr:
	DW		SSE_AVX_R128_R128M128_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0xDF


EVEN 2
vandnpdInstr:
	DW		SSE_AVX5_R_R_RxM64_WriteMask_Z
	DB		0x03,0xF2,0x0F,0x55


EVEN 2
vandnpsInstr:
	DW		SSE_AVX5_R_R_RxMxM32_WriteMask_Z
	DB		0x02,0x0F,0x55


EVEN 2
vandpdInstr:
	DW		SSE_AVX5_R_R_RxM64_WriteMask_Z
	DB		0x03,0xF2,0x0F,0x54


EVEN 2
vandpsInstr:
	DW		SSE_AVX5_R_R_RxMxM32_WriteMask_Z
	DB		0x02,0x0F,0x54


EVEN 2
vblendpdInstr:
	DW		SSE_AVX_R_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0D


EVEN 2
vblendpsInstr:
	DW		SSE_AVX_R_R_RM_Imm8_Instr_Double
	DB		0x03,0x0F,0x3A,0x0C


EVEN 2
vblendvpdInstr:
	DW		(NotCoded)


EVEN 2
vblendvpsInstr:
	DW		(NotCoded)


EVEN 2
vbroadcastf128Instr:
	DW		(NotCoded)


EVEN 2
vbroadcasti128Instr:
	DW		(NotCoded)


EVEN 2
vbroadcastsdInstr:
	DW		(NotCoded)


EVEN 2
vbroadcastssInstr:
	DW		(NotCoded)


EVEN 2
vcmppdInstr:
	DW		AVX_R_R_RM_Imm8_AVX5_km_R_RxMxM64_Imm8_Instr_Double
	DB		0x02,0x0F,0xC2


EVEN 2
vcmppsInstr:
	DW		AVX_R_R_RM_Imm8_AVX5_km_R_RxMxM32_Imm8_Instr
	DB		0x02,0x0F,0xC2


EVEN 2
vcmpsdInstr:
	DW		AVX_R128_R128_R128M64_Imm8_AVX5_km_R128_R128M64_Imm8_Instr
	DB		0x03,0xF2,0x0F,0xC2


EVEN 2
vcmpssInstr:
	DW		AVX_R128_R128_R128M32_Imm8_AVX5_km_R128_R128M32_Imm8_Instr
	DB		0x03,0xF3,0x0F,0xC2


EVEN 2
vcomisdInstr:
	DW		AVX_R128_R128M64_Instr_Double
	DB		0x02,0x0F,0x2F


EVEN 2
vcomissInstr:
	DW		AVX_R128_R128M32_Instr
	DB		0x02,0x0F,0x2F


EVEN 2
vcvtdq2pdInstr:
	DW		(NotCoded)


EVEN 2
vcvtdq2psInstr:
	DW		(NotCoded)


EVEN 2
vcvtpd2dqInstr:
	DW		(NotCoded)


EVEN 2
vcvtpd2psInstr:
	DW		(NotCoded)


EVEN 2
vcvtph2psInstr:
	DW		(NotCoded)


EVEN 2
vcvtps2dqInstr:
	DW		(NotCoded)


EVEN 2
vcvtps2pdInstr:
	DW		(NotCoded)


EVEN 2
vcvtps2phInstr:
	DW		(NotCoded)


EVEN 2
vcvtsd2siInstr:
	DW		(NotCoded)


EVEN 2
vcvtsd2ssInstr:
	DW		(NotCoded)


EVEN 2
vcvtsi2sdInstr:
	DW		(NotCoded)


EVEN 2
vcvtsi2ssInstr:
	DW		(NotCoded)


EVEN 2
vcvtss2sdInstr:
	DW		(NotCoded)


EVEN 2
vcvtss2siInstr:
	DW		(NotCoded)


EVEN 2
vcvttpd2dqInstr:
	DW		(NotCoded)


EVEN 2
vcvttps2dqInstr:
	DW		(NotCoded)


EVEN 2
vcvttsd2siInstr:
	DW		(NotCoded)


EVEN 2
vcvttss2siInstr:
	DW		(NotCoded)


EVEN 2
vdivpdInstr:
	DW		(NotCoded)


EVEN 2
vdivpsInstr:
	DW		(NotCoded)


EVEN 2
vdivsdInstr:
	DW		(NotCoded)


EVEN 2
vdivssInstr:
	DW		(NotCoded)


EVEN 2
vdppdInstr:
	DW		(NotCoded)


EVEN 2
vdppsInstr:
	DW		(NotCoded)


EVEN 2
verrInstr:
	DW		PMInstr2
	DB		0x0F,0,32


EVEN 2
verwInstr:
	DW		PMInstr2
	DB		0x0F,0,40


EVEN 2
vextractf128Instr:
	DW		(NotCoded)


EVEN 2
vextracti128Instr:
	DW		(NotCoded)


EVEN 2
vextractpsInstr:
	DW		(NotCoded)


EVEN 2
vfmadd132pdInstr:
	DW		(NotCoded)


EVEN 2
vfmadd132psInstr:
	DW		(NotCoded)


EVEN 2
vfmadd132sdInstr:
	DW		(NotCoded)


EVEN 2
vfmadd132ssInstr:
	DW		(NotCoded)


EVEN 2
vfmadd213pdInstr:
	DW		(NotCoded)


EVEN 2
vfmadd213psInstr:
	DW		(NotCoded)


EVEN 2
vfmadd213sdInstr:
	DW		(NotCoded)


EVEN 2
vfmadd213ssInstr:
	DW		(NotCoded)


EVEN 2
vfmadd231pdInstr:
	DW		(NotCoded)


EVEN 2
vfmadd231psInstr:
	DW		(NotCoded)


EVEN 2
vfmadd231sdInstr:
	DW		(NotCoded)


EVEN 2
vfmadd231ssInstr:
	DW		(NotCoded)


EVEN 2
vfmaddpdInstr:
	DW		(NotCoded)


EVEN 2
vfmaddpsInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsdInstr:
	DW		(NotCoded)


EVEN 2
vfmaddssInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsub132pdInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsub132psInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsub213pdInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsub213psInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsub231pdInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsub231psInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsubpdInstr:
	DW		(NotCoded)


EVEN 2
vfmaddsubpsInstr:
	DW		(NotCoded)


EVEN 2
vfmsub132pdInstr:
	DW		(NotCoded)


EVEN 2
vfmsub132psInstr:
	DW		(NotCoded)


EVEN 2
vfmsub132sdInstr:
	DW		(NotCoded)


EVEN 2
vfmsub132ssInstr:
	DW		(NotCoded)


EVEN 2
vfmsub213pdInstr:
	DW		(NotCoded)


EVEN 2
vfmsub213psInstr:
	DW		(NotCoded)


EVEN 2
vfmsub213sdInstr:
	DW		(NotCoded)


EVEN 2
vfmsub213ssInstr:
	DW		(NotCoded)


EVEN 2
vfmsub231pdInstr:
	DW		(NotCoded)


EVEN 2
vfmsub231psInstr:
	DW		(NotCoded)


EVEN 2
vfmsub231sdInstr:
	DW		(NotCoded)


EVEN 2
vfmsub231ssInstr:
	DW		(NotCoded)


EVEN 2
vfmsubadd132pdInstr:
	DW		(NotCoded)


EVEN 2
vfmsubadd132psInstr:
	DW		(NotCoded)


EVEN 2
vfmsubadd213pdInstr:
	DW		(NotCoded)


EVEN 2
vfmsubadd213psInstr:
	DW		(NotCoded)


EVEN 2
vfmsubadd231pdInstr:
	DW		(NotCoded)


EVEN 2
vfmsubadd231psInstr:
	DW		(NotCoded)


EVEN 2
vfmsubaddpdInstr:
	DW		(NotCoded)


EVEN 2
vfmsubaddpsInstr:
	DW		(NotCoded)


EVEN 2
vfmsubpdInstr:
	DW		(NotCoded)


EVEN 2
vfmsubpsInstr:
	DW		(NotCoded)


EVEN 2
vfmsubsdInstr:
	DW		(NotCoded)


EVEN 2
vfmsubssInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd132pdInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd132psInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd132sdInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd132ssInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd213pdInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd213psInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd213sdInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd213ssInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd231pdInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd231psInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd231sdInstr:
	DW		(NotCoded)


EVEN 2
vfnmadd231ssInstr:
	DW		(NotCoded)


EVEN 2
vfnmaddpdInstr:
	DW		(NotCoded)


EVEN 2
vfnmaddpsInstr:
	DW		(NotCoded)


EVEN 2
vfnmaddsdInstr:
	DW		(NotCoded)


EVEN 2
vfnmaddssInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub132pdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub132psInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub132sdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub132ssInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub213pdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub213psInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub213sdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub213ssInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub231pdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub231psInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub231sdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsub231ssInstr:
	DW		(NotCoded)


EVEN 2
vfnmsubpdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsubpsInstr:
	DW		(NotCoded)


EVEN 2
vfnmsubsdInstr:
	DW		(NotCoded)


EVEN 2
vfnmsubssInstr:
	DW		(NotCoded)


EVEN 2
vfrczpdInstr:
	DW		(NotCoded)


EVEN 2
vfrczpsInstr:
	DW		(NotCoded)


EVEN 2
vfrczsdInstr:
	DW		(NotCoded)


EVEN 2
vfrczssInstr:
	DW		(NotCoded)


EVEN 2
vgatherdpdInstr:
	DW		(NotCoded)


EVEN 2
vgatherdpsInstr:
	DW		(NotCoded)


EVEN 2
vgatherqpdInstr:
	DW		(NotCoded)


EVEN 2
vgatherqpsInstr:
	DW		(NotCoded)


EVEN 2
vhaddpdInstr:
	DW		(NotCoded)


EVEN 2
vhaddpsInstr:
	DW		(NotCoded)


EVEN 2
vhsubpdInstr:
	DW		(NotCoded)


EVEN 2
vhsubpsInstr:
	DW		(NotCoded)


EVEN 2
vinsertf128Instr:
	DW		(NotCoded)


EVEN 2
vinserti128Instr:
	DW		(NotCoded)


EVEN 2
vinsertpsInstr:
	DW		(NotCoded)


EVEN 2
vlddquInstr:
	DW		(NotCoded)


EVEN 2
vldmxcsrInstr:
	DW		(NotCoded)


EVEN 2
vmaskmovdquInstr:
	DW		(NotCoded)


EVEN 2
vmaskmovpdInstr:
	DW		(NotCoded)


EVEN 2
vmaskmovpsInstr:
	DW		(NotCoded)


EVEN 2
vmaxpdInstr:
	DW		(NotCoded)


EVEN 2
vmaxpsInstr:
	DW		(NotCoded)


EVEN 2
vmaxsdInstr:
	DW		(NotCoded)


EVEN 2
vmaxssInstr:
	DW		(NotCoded)


EVEN 2
vminpdInstr:
	DW		(NotCoded)


EVEN 2
vminpsInstr:
	DW		(NotCoded)


EVEN 2
vminsdInstr:
	DW		(NotCoded)


EVEN 2
vminssInstr:
	DW		(NotCoded)


EVEN 2
vmovapdInstr:
	DW		(NotCoded)


EVEN 2
vmovapsInstr:
	DW		(NotCoded)


EVEN 2
vmovdInstr:
	DW		(NotCoded)


EVEN 2
vmovddupInstr:
	DW		(NotCoded)


EVEN 2
vmovdqaInstr:
	DW		(NotCoded)


EVEN 2
vmovdquInstr:
	DW		(NotCoded)


EVEN 2
vmovhlpsInstr:
	DW		(NotCoded)


EVEN 2
vmovhpdInstr:
	DW		(NotCoded)


EVEN 2
vmovhpsInstr:
	DW		(NotCoded)


EVEN 2
vmovlhpsInstr:
	DW		(NotCoded)


EVEN 2
vmovlpdInstr:
	DW		(NotCoded)


EVEN 2
vmovlpsInstr:
	DW		(NotCoded)


EVEN 2
vmovmskpdInstr:
	DW		(NotCoded)


EVEN 2
vmovmskpsInstr:
	DW		(NotCoded)


EVEN 2
vmovntdqInstr:
	DW		(NotCoded)


EVEN 2
vmovntdqaInstr:
	DW		(NotCoded)


EVEN 2
vmovntpdInstr:
	DW		(NotCoded)


EVEN 2
vmovntpsInstr:
	DW		(NotCoded)


EVEN 2
vmovqInstr:
	DW		(NotCoded)


EVEN 2
vmovsdInstr:
	DW		(NotCoded)


EVEN 2
vmovshdupInstr:
	DW		(NotCoded)


EVEN 2
vmovsldupInstr:
	DW		(NotCoded)


EVEN 2
vmovssInstr:
	DW		(NotCoded)


EVEN 2
vmovupdInstr:
	DW		(NotCoded)


EVEN 2
vmovupsInstr:
	DW		(NotCoded)


EVEN 2
vmpsadbwInstr:
	DW		(NotCoded)


EVEN 2
vmulpdInstr:
	DW		(NotCoded)


EVEN 2
vmulpsInstr:
	DW		(NotCoded)


EVEN 2
vmulsdInstr:
	DW		(NotCoded)


EVEN 2
vmulssInstr:
	DW		(NotCoded)


EVEN 2
vorpdInstr:
	DW		(NotCoded)


EVEN 2
vorpsInstr:
	DW		(NotCoded)


EVEN 2
vpabsbInstr:
	DW		(NotCoded)


EVEN 2
vpabsdInstr:
	DW		(NotCoded)


EVEN 2
vpabswInstr:
	DW		(NotCoded)


EVEN 2
vpackssdwInstr:
	DW		(NotCoded)


EVEN 2
vpacksswbInstr:
	DW		(NotCoded)


EVEN 2
vpackusdwInstr:
	DW		(NotCoded)


EVEN 2
vpackuswbInstr:
	DW		(NotCoded)


EVEN 2
vpaddbInstr:
	DW		(NotCoded)


EVEN 2
vpadddInstr:
	DW		(NotCoded)


EVEN 2
vpaddqInstr:
	DW		(NotCoded)


EVEN 2
vpaddsbInstr:
	DW		(NotCoded)


EVEN 2
vpaddswInstr:
	DW		(NotCoded)


EVEN 2
vpaddusbInstr:
	DW		(NotCoded)


EVEN 2
vpadduswInstr:
	DW		(NotCoded)


EVEN 2
vpaddwInstr:
	DW		(NotCoded)


EVEN 2
vpalignrInstr:
	DW		(NotCoded)


EVEN 2
vpandInstr:
	DW		(NotCoded)


EVEN 2
vpandnInstr:
	DW		(NotCoded)


EVEN 2
vpavgbInstr:
	DW		(NotCoded)


EVEN 2
vpavgwInstr:
	DW		(NotCoded)


EVEN 2
vpblenddInstr:
	DW		(NotCoded)


EVEN 2
vpblendvbInstr:
	DW		(NotCoded)


EVEN 2
vpblendwInstr:
	DW		(NotCoded)


EVEN 2
vpbroadcastbInstr:
	DW		(NotCoded)


EVEN 2
vpbroadcastdInstr:
	DW		(NotCoded)


EVEN 2
vpbroadcastqInstr:
	DW		(NotCoded)


EVEN 2
vpbroadcastwInstr:
	DW		(NotCoded)


EVEN 2
vpclmulqdqInstr:
	DW		(NotCoded)


EVEN 2
vpcmovInstr:
	DW		(NotCoded)


EVEN 2
vpcmpeqbInstr:
	DW		(NotCoded)


EVEN 2
vpcmpeqdInstr:
	DW		(NotCoded)


EVEN 2
vpcmpeqqInstr:
	DW		(NotCoded)


EVEN 2
vpcmpeqwInstr:
	DW		(NotCoded)


EVEN 2
vpcmpestriInstr:
	DW		(NotCoded)


EVEN 2
vpcmpestrmInstr:
	DW		(NotCoded)


EVEN 2
vpcmpgtbInstr:
	DW		(NotCoded)


EVEN 2
vpcmpgtdInstr:
	DW		(NotCoded)


EVEN 2
vpcmpgtqInstr:
	DW		(NotCoded)


EVEN 2
vpcmpgtwInstr:
	DW		(NotCoded)


EVEN 2
vpcmpistriInstr:
	DW		(NotCoded)


EVEN 2
vpcmpistrmInstr:
	DW		(NotCoded)


EVEN 2
vpcombInstr:
	DW		(NotCoded)


EVEN 2
vpcomdInstr:
	DW		(NotCoded)


EVEN 2
vpcomqInstr:
	DW		(NotCoded)


EVEN 2
vpcomubInstr:
	DW		(NotCoded)


EVEN 2
vpcomudInstr:
	DW		(NotCoded)


EVEN 2
vpcomuqInstr:
	DW		(NotCoded)


EVEN 2
vpcomuwInstr:
	DW		(NotCoded)


EVEN 2
vpcomwInstr:
	DW		(NotCoded)


EVEN 2
vperm2f128Instr:
	DW		(NotCoded)


EVEN 2
vperm2i128Instr:
	DW		(NotCoded)


EVEN 2
vpermdInstr:
	DW		(NotCoded)


EVEN 2
vpermil2pdInstr:
	DW		(NotCoded)


EVEN 2
vpermil2psInstr:
	DW		(NotCoded)


EVEN 2
vpermilpdInstr:
	DW		(NotCoded)


EVEN 2
vpermilpsInstr:
	DW		(NotCoded)


EVEN 2
vpermpdInstr:
	DW		(NotCoded)


EVEN 2
vpermpsInstr:
	DW		(NotCoded)


EVEN 2
vpermqInstr:
	DW		(NotCoded)


EVEN 2
vpextrbInstr:
	DW		(NotCoded)


EVEN 2
vpextrdInstr:
	DW		(NotCoded)


EVEN 2
vpextrqInstr:
	DW		(NotCoded)


EVEN 2
vpextrwInstr:
	DW		(NotCoded)


EVEN 2
vpgatherddInstr:
	DW		(NotCoded)


EVEN 2
vpgatherdqInstr:
	DW		(NotCoded)


EVEN 2
vpgatherqdInstr:
	DW		(NotCoded)


EVEN 2
vpgatherqqInstr:
	DW		(NotCoded)


EVEN 2
vphaddbdInstr:
	DW		(NotCoded)


EVEN 2
vphaddbqInstr:
	DW		(NotCoded)


EVEN 2
vphaddbwInstr:
	DW		(NotCoded)


EVEN 2
vphadddInstr:
	DW		(NotCoded)


EVEN 2
vphadddqInstr:
	DW		(NotCoded)


EVEN 2
vphaddswInstr:
	DW		(NotCoded)


EVEN 2
vphaddubdInstr:
	DW		(NotCoded)


EVEN 2
vphaddubqInstr:
	DW		(NotCoded)


EVEN 2
vphaddubwInstr:
	DW		(NotCoded)


EVEN 2
vphaddudqInstr:
	DW		(NotCoded)


EVEN 2
vphadduwdInstr:
	DW		(NotCoded)


EVEN 2
vphadduwqInstr:
	DW		(NotCoded)


EVEN 2
vphaddwInstr:
	DW		(NotCoded)


EVEN 2
vphaddwdInstr:
	DW		(NotCoded)


EVEN 2
vphaddwqInstr:
	DW		(NotCoded)


EVEN 2
vphminposuwInstr:
	DW		(NotCoded)


EVEN 2
vphsubbwInstr:
	DW		(NotCoded)


EVEN 2
vphsubdInstr:
	DW		(NotCoded)


EVEN 2
vphsubdqInstr:
	DW		(NotCoded)


EVEN 2
vphsubswInstr:
	DW		(NotCoded)


EVEN 2
vphsubwInstr:
	DW		(NotCoded)


EVEN 2
vphsubwdInstr:
	DW		(NotCoded)


EVEN 2
vpinsrbInstr:
	DW		(NotCoded)


EVEN 2
vpinsrdInstr:
	DW		(NotCoded)


EVEN 2
vpinsrqInstr:
	DW		(NotCoded)


EVEN 2
vpinsrwInstr:
	DW		(NotCoded)


EVEN 2
vpmacsddInstr:
	DW		(NotCoded)


EVEN 2
vpmacsdqhInstr:
	DW		(NotCoded)


EVEN 2
vpmacsdqlInstr:
	DW		(NotCoded)


EVEN 2
vpmacssddInstr:
	DW		(NotCoded)


EVEN 2
vpmacssdqhInstr:
	DW		(NotCoded)


EVEN 2
vpmacssdqlInstr:
	DW		(NotCoded)


EVEN 2
vpmacsswdInstr:
	DW		(NotCoded)


EVEN 2
vpmacsswwInstr:
	DW		(NotCoded)


EVEN 2
vpmacswdInstr:
	DW		(NotCoded)


EVEN 2
vpmacswwInstr:
	DW		(NotCoded)


EVEN 2
vpmadcsswdInstr:
	DW		(NotCoded)


EVEN 2
vpmadcswdInstr:
	DW		(NotCoded)


EVEN 2
vpmaddubswInstr:
	DW		(NotCoded)


EVEN 2
vpmaddwdInstr:
	DW		(NotCoded)


EVEN 2
vpmaskmovdInstr:
	DW		(NotCoded)


EVEN 2
vpmaskmovqInstr:
	DW		(NotCoded)


EVEN 2
vpmaxsbInstr:
	DW		(NotCoded)


EVEN 2
vpmaxsdInstr:
	DW		(NotCoded)


EVEN 2
vpmaxswInstr:
	DW		(NotCoded)


EVEN 2
vpmaxubInstr:
	DW		(NotCoded)


EVEN 2
vpmaxudInstr:
	DW		(NotCoded)


EVEN 2
vpmaxuwInstr:
	DW		(NotCoded)


EVEN 2
vpminsbInstr:
	DW		(NotCoded)


EVEN 2
vpminsdInstr:
	DW		(NotCoded)


EVEN 2
vpminswInstr:
	DW		(NotCoded)


EVEN 2
vpminubInstr:
	DW		(NotCoded)


EVEN 2
vpminudInstr:
	DW		(NotCoded)


EVEN 2
vpminuwInstr:
	DW		(NotCoded)


EVEN 2
vpmovmskbInstr:
	DW		(NotCoded)


EVEN 2
vpmovsxbdInstr:
	DW		(NotCoded)


EVEN 2
vpmovsxbqInstr:
	DW		(NotCoded)


EVEN 2
vpmovsxbwInstr:
	DW		(NotCoded)


EVEN 2
vpmovsxdqInstr:
	DW		(NotCoded)


EVEN 2
vpmovsxwdInstr:
	DW		(NotCoded)


EVEN 2
vpmovsxwqInstr:
	DW		(NotCoded)


EVEN 2
vpmovzxbdInstr:
	DW		(NotCoded)


EVEN 2
vpmovzxbqInstr:
	DW		(NotCoded)


EVEN 2
vpmovzxbwInstr:
	DW		(NotCoded)


EVEN 2
vpmovzxdqInstr:
	DW		(NotCoded)


EVEN 2
vpmovzxwdInstr:
	DW		(NotCoded)


EVEN 2
vpmovzxwqInstr:
	DW		(NotCoded)


EVEN 2
vpmuldqInstr:
	DW		(NotCoded)


EVEN 2
vpmulhrswInstr:
	DW		(NotCoded)


EVEN 2
vpmulhuwInstr:
	DW		(NotCoded)


EVEN 2
vpmulhwInstr:
	DW		(NotCoded)


EVEN 2
vpmulldInstr:
	DW		(NotCoded)


EVEN 2
vpmullwInstr:
	DW		(NotCoded)


EVEN 2
vpmuludqInstr:
	DW		(NotCoded)


EVEN 2
vporInstr:
	DW		(NotCoded)


EVEN 2
vppermInstr:
	DW		(NotCoded)


EVEN 2
vprotbInstr:
	DW		(NotCoded)


EVEN 2
vprotdInstr:
	DW		(NotCoded)


EVEN 2
vprotqInstr:
	DW		(NotCoded)


EVEN 2
vprotwInstr:
	DW		(NotCoded)


EVEN 2
vpsadbwInstr:
	DW		(NotCoded)


EVEN 2
vpshabInstr:
	DW		(NotCoded)


EVEN 2
vpshadInstr:
	DW		(NotCoded)


EVEN 2
vpshaqInstr:
	DW		(NotCoded)


EVEN 2
vpshawInstr:
	DW		(NotCoded)


EVEN 2
vpshlbInstr:
	DW		(NotCoded)


EVEN 2
vpshldInstr:
	DW		(NotCoded)


EVEN 2
vpshlqInstr:
	DW		(NotCoded)


EVEN 2
vpshlwInstr:
	DW		(NotCoded)


EVEN 2
vpshufbInstr:
	DW		(NotCoded)


EVEN 2
vpshufdInstr:
	DW		(NotCoded)


EVEN 2
vpshufhwInstr:
	DW		(NotCoded)


EVEN 2
vpshuflwInstr:
	DW		(NotCoded)


EVEN 2
vpsignbInstr:
	DW		(NotCoded)


EVEN 2
vpsigndInstr:
	DW		(NotCoded)


EVEN 2
vpsignwInstr:
	DW		(NotCoded)


EVEN 2
vpslldInstr:
	DW		(NotCoded)


EVEN 2
vpslldqInstr:
	DW		(NotCoded)


EVEN 2
vpsllqInstr:
	DW		(NotCoded)


EVEN 2
vpsllvdInstr:
	DW		(NotCoded)


EVEN 2
vpsllvqInstr:
	DW		(NotCoded)


EVEN 2
vpsllwInstr:
	DW		(NotCoded)


EVEN 2
vpsradInstr:
	DW		(NotCoded)


EVEN 2
vpsravdInstr:
	DW		(NotCoded)


EVEN 2
vpsrawInstr:
	DW		(NotCoded)


EVEN 2
vpsrldInstr:
	DW		(NotCoded)


EVEN 2
vpsrldqInstr:
	DW		(NotCoded)


EVEN 2
vpsrlqInstr:
	DW		(NotCoded)


EVEN 2
vpsrlvdInstr:
	DW		(NotCoded)


EVEN 2
vpsrlvqInstr:
	DW		(NotCoded)


EVEN 2
vpsrlwInstr:
	DW		(NotCoded)


EVEN 2
vpsubbInstr:
	DW		(NotCoded)


EVEN 2
vpsubdInstr:
	DW		(NotCoded)


EVEN 2
vpsubqInstr:
	DW		(NotCoded)


EVEN 2
vpsubsbInstr:
	DW		(NotCoded)


EVEN 2
vpsubswInstr:
	DW		(NotCoded)


EVEN 2
vpsubusbInstr:
	DW		(NotCoded)


EVEN 2
vpsubuswInstr:
	DW		(NotCoded)


EVEN 2
vpsubwInstr:
	DW		(NotCoded)


EVEN 2
vptestInstr:
	DW		(NotCoded)


EVEN 2
vpunpckhbwInstr:
	DW		(NotCoded)


EVEN 2
vpunpckhdqInstr:
	DW		(NotCoded)


EVEN 2
vpunpckhqdqInstr:
	DW		(NotCoded)


EVEN 2
vpunpckhwdInstr:
	DW		(NotCoded)


EVEN 2
vpunpcklbwInstr:
	DW		(NotCoded)


EVEN 2
vpunpckldqInstr:
	DW		(NotCoded)


EVEN 2
vpunpcklqdqInstr:
	DW		(NotCoded)


EVEN 2
vpunpcklwdInstr:
	DW		(NotCoded)


EVEN 2
vpxorInstr:
	DW		(NotCoded)


EVEN 2
vrcppsInstr:
	DW		(NotCoded)


EVEN 2
vrcpssInstr:
	DW		(NotCoded)


EVEN 2
vroundpdInstr:
	DW		(NotCoded)


EVEN 2
vroundpsInstr:
	DW		(NotCoded)


EVEN 2
vroundsdInstr:
	DW		(NotCoded)


EVEN 2
vroundssInstr:
	DW		(NotCoded)


EVEN 2
vrsqrtpsInstr:
	DW		(NotCoded)


EVEN 2
vrsqrtssInstr:
	DW		(NotCoded)


EVEN 2
vshufpdInstr:
	DW		(NotCoded)


EVEN 2
vshufpsInstr:
	DW		(NotCoded)


EVEN 2
vsqrtpdInstr:
	DW		(NotCoded)


EVEN 2
vsqrtpsInstr:
	DW		(NotCoded)


EVEN 2
vsqrtsdInstr:
	DW		(NotCoded)


EVEN 2
vsqrtssInstr:
	DW		(NotCoded)


EVEN 2
vstmxcsrInstr:
	DW		(NotCoded)


EVEN 2
vsubpdInstr:
	DW		(NotCoded)


EVEN 2
vsubpsInstr:
	DW		(NotCoded)


EVEN 2
vsubsdInstr:
	DW		(NotCoded)


EVEN 2
vsubssInstr:
	DW		(NotCoded)


EVEN 2
vtestpdInstr:
	DW		(NotCoded)


EVEN 2
vtestpsInstr:
	DW		(NotCoded)


EVEN 2
vucomisdInstr:
	DW		(NotCoded)


EVEN 2
vucomissInstr:
	DW		(NotCoded)


EVEN 2
vunpckhpdInstr:
	DW		(NotCoded)


EVEN 2
vunpckhpsInstr:
	DW		(NotCoded)


EVEN 2
vunpcklpdInstr:
	DW		(NotCoded)


EVEN 2
vunpcklpsInstr:
	DW		(NotCoded)


EVEN 2
vxorpdInstr:
	DW		(NotCoded)


EVEN 2
vxorpsInstr:
	DW		(NotCoded)


EVEN 2
vzeroallInstr:
	DW		(NotCoded)


EVEN 2
vzeroupperInstr:
	DW		(NotCoded)


EVEN 2
wbinvdInstr:
	DW		NoOpW
	DB		0x0F,0x09


EVEN 2
wrmsrInstr:
	DW		NoOpW
	DB		0x0F,0x30


EVEN 2
xaddInstr:
	DW		XAddPInstr
	DB		0x0F,0x0C1
	DB		0x0F,0x0C0


EVEN 2
xbtsInstr:
	DW		NotCoded


EVEN 2
xchgInstr:
	DW		xchgpInstr


EVEN 2
xgetbvInstr:
	DW		(NotCoded)


EVEN 2
xlatInstr:
	DW		xlatpinstr
	DB		0x0D7


EVEN 2
xorInstr:
	DW		BasicInstr
	DB		48


EVEN 2
xorpdInstr:
	DW		SSE_R_RM_Instr_Double
	DB		0x02,0x0F,0x57


EVEN 2
xorpsInstr:
	DW		SSE_R_RM_Instr_Single
	DB		0x02,0x0F,0x57


EVEN 2
xrstorInstr:
	DW		(NotCoded)


EVEN 2
xrstorsInstr:
	DW		(NotCoded)


EVEN 2
xsaveInstr:
	DW		(NotCoded)


EVEN 2
xsavecInstr:
	DW		(NotCoded)


EVEN 2
xsaveoptInstr:
	DW		(NotCoded)


EVEN 2
xsavesInstr:
	DW		(NotCoded)


EVEN 2
xsetbvInstr:
	DW		(NotCoded)


InstructionsEnd:
