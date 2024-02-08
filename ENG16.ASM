CorpInfo                DB  "ASM++ (African Assember). Version 24.02", 13,10 ; (",??DATE, " ", ??TIME,")",13,10
                        DB  "(C)opyright 2006 - 2024 Tinashe Mutandagayi (tinashh2000@gmail.com)",13,10,13,10,0
Usage                   DB  "Usage   AP [Options] input file [output file]",13,10
                        DB  "MaOptions:",13,10
                        DB  "/ELF**  Produce an Executable and Linkable file Format(Linux)",13,10
                        DB  "/OBJ*   Produce an OMF DOS object",13,10
                        DB  "/EXE    Produce a DOS MZ kana Portable EXEcutable",13,10
;                        DB  "/PE*    Produce a Portable Executable (reWindows)",13,10
;                        DB  "/COFF** Produce a Common Object File Format",13,10
;                        DB  "/cs     Turn case sensitivity on",13,10
                        DB  "/js/jn  Make all jumps Short(js) or Near(jn)",13,10
                        DB  "/jo     Optimize for short jumps where possible",13,10
                        DB  "/oc/ou  Optimize for short unconditional (ou) jumps or ",13,10
                        DB  "        conditional (oc) jumps where possible",13,10
                        DB  "/w+     Show all warnings. The 'Number of warnings' count includes some",13,10
                        DB  "        which were not shown. This option puts them on screen",13,10
                        DB  "Replace * with 16,32 or 64(Bits) and ** with 32 or 64",13,10
                        DB  "This assembler is free and must be distributed freely but it must",13,10
                        DB  "be used for personal benefit, not organizations or any commercial",13,10
                        DB  "purpose. Disassembly or modification of this assembler is not allowed",13,10,0
Msg0                    DB  "Input file:",0
Msg1                    DB  "Output file:",0
Msg2                    DB  "#Errors:",0
Msg3                    DB  "#Warnings:",0
Msg4                    DB  "Bytes Written:",0
Msg5                    DB  "Passes:",0
Msg6                    DB  "Symbols used:",0
Msg7                    DB  "Lines Processed:",0
Msg8                    DB  "None",13,10,0
ErrorTxt                DB  "*Error** ",0
FatalTxt                DB  "*Fatal** ",0
WarningTxt              DB  "*Warning** ",0
_MResizeError           DB  "Memory resizing error : ",0
_MAllocError            DB  "Memory allocation error",0
_NotEnoughMem           DB  "Not enough memory. At least 128KB is needed",13,10,0
_FileNotFound           DB  "File not found: ",0
_PathNotFound           DB  "Path not found: ",0
_AccessDenied           DB  "Access Denied: ",0
_InvalidDrive           DB  "Invalid drive: ",0
_TooManyFiles           DB  "Too many files: ",0
_DiskError              DB  "Disk error code : ",0
_ExpectedInstr          DB  "Instruction/definition expected",13,10,0
_ManyOperands           DB  "Extra characters on line",13,10,0
_FewOperands            DB  "More operands are expected ",13,10,0
_NumTooBig              DB  "Number too large",13,10,0
_NumExpected            DB  "Number expected",13,10,0
_MissingEndQuote        DB  "Missing close quote (",0
_IDTooLong              DB  "Quote/Symbol name too long",13,10,0
_InvalidAddrMode        DB  "Invalid Instruction/Operand for address mode",13,10,0
_StrInstrExpected       DB  "String instruction expected",13,10,0
_MisplacedComma         DB  "Misplaced comma",13,10,0
_SpecAlreadyUsed        DB  "Keyword already encountered",13,10,0
_DXImmExpected          DB  "DX (or number expected)",13,10,0
_AccumExpected          DB  "AL/(E)AX expected",13,10,0
_MissingComma           DB  "Missing comma",13,10,0
_CSDest                 DB  "CS can't be data destinatino",13,10,0
_OperandSizeMismatch    DB  "Operand sizes or types mismatch",13,10,0
_CombinationNotAllowed  DB  "Combination not allowed",13,10,0
_InvalidOperandSize     DB  "Invalid operand size",13,10,0
_InvalidEAReg           DB  "Invalid register in address",13,10,0
_MultiR16Base           DB  "Only one base register (BX,BP) is allowed",13,10,0
_MultiR16Idx            DB  "Only one index register (SI,DI) is allowed",13,10,0
_EARegMismatch          DB  "Registers mismatch in Address",13,10,0
_InvalidEAEntry         DB  "Invalid entry in Expression/Address",13,10,0
_DispTooBig             DB  "Number too large",13,10,0
_OperandSizeRequired    DB  "Operand size required",13,10,0
_FormatRequired         DB  "File format (ELF,MZ,COFF,PE) expected",13,10,0
_OutOfMacroSpace        DB  "Out of macro space",13,10,0
_InvalidNum             DB  "Invalid number",13,10,0
_InvalidRegister        DB  "Invalid register use",13,10,0
_ByteOperandExpected    DB  "Byte sized memory operand expected",13,10,0
_InvalidOperand         DB  "Invalid operand/combination",13,10,0
_InvalidOperand1        DB  "Invalid first operand",13,10,0
_InvalidOperand2        DB  "Invalid second operand",13,10,0
_InvalidOperand3        DB  "Invalid third operand",13,10,0
_MemOpExpected          DB  "Memory operand expected",13,10,0
_ProgIPOverflow         DB  "Program or last segment too large",13,10,0
_JumpAboveRange         DB  "Jump above range by ",0
_JumpBelowRange         DB  "Jump below range by ",0
_NoRValue               DB  "Right value expected",13,10,0
_NoLValue               DB  "Left value expected",13,10,0
_CommentNoTerminator    DB  "A character must indicate the start and end of comment",13,10,0
_CommentNotClosed       DB  "End of file, comment removed",13,10,0
_BadRadix               DB  "Invalid radix use  2,8,10 or 16",13,10,0
_MissingOperator        DB  "Missing operator between values",13,10,0
_InvalidOperators       DB  "Invalid use of operator(s)",13,10,0
_DupDef                 DB  "Identifier already defined ",13,10,0
_UnmatchedEnd           DB  "Block end mismatch: ",0
_AlreadyInBlock         DB  "Open block needs to be closed first",13,10,0
_IDNotFound             DB  "Identifier not found : ",0
_RefMismatch            DB  "Symbol type prediction failed",13,10,0
_NewPass                DB  "New pass",13,10,0
_SymSpaceOut            DB  "Out of symbol space",13,10,0
_MissingLabel           DB  "Identifier required before keyword",13,10,0
_MissingOpenSq          DB  "'[' needed before ']'",13,10,0
_MissingOpenBr          DB  "'(' needed before ')'",13,10,0
_MissingCloseSq         DB  "Bracket not closed with ']'",13,10,0
_MissingCloseBr         DB  "Bracket not closed with ')'",13,10,0
_TooManyRegs            DB  "Too many registers in address",13,10,0
_ImmCLExpected          DB  "Number/CL expected",13,10,0
_EAESPError             DB  "ESP can't be used with scale in Address",13,10,0
_NotCoded               DB  "I have not yet coded this: ",0
_FileNameExpected       DB  "Existing filename expected",13,10,0
_FilesTooNested         DB  "Files too nested",13,10,0
_RefEQU                 DB  "Constant used before definition.",13,10,0
_InvalidKeyword         DB  "Invalid keyword use:",0
_InvalidScale           DB  "Invalid scale use 1,2,4 kana 8",13,10,0
_LabelExpected          DB  "Parikudiwa Label/number",13,10,0
_JumpTooBig             DB  "Jump too large but it was truncated",13,10,0
_SelOfsExpected         DB  "Selector:Offset of far address expected",13,10,0
_TempFileError          DB  "Error while creating temporary file",0
_NoCodeSeg              DB  "Instruction outside a code segment: ",0
_NoDataSeg              DB  "Instruction outsize a code segment: ",0
_UninitSeg              DB  "Define a segment before putting data or code",13,10,0
_HeaderLarge            DB  "Output file header too large",13,10,0
_CantESOverride         DB  "Can't override ES",13,10,0
_InvalidFmt             DB  "Invalid file format (or file too big)",13,10,0
_BadReloc               DB  "Fixup does not match this file format",13,10,0
_Start                  DB  "Start",0
_Stop                   DB  "Stop",0
_Ignored                DB  "Keyword Ignored"
_lf                     DB   13,10,0
_Done                   DB  "The African Assembler Is Done!",13,10,0
_ArgStr                 DB  "Arg:",0
CorpInfo2               DB  "ASM++ (African Assember). Version 7.3 March 2007",0
_AlreadyRunning         DB  "Another instance of this program is already running",0
_RCLabelExpected        DB  "Resource Label Expected",13,10,0
_StubSizeError			DB	"Error with stub file or its size",13,10,0
_DUForUnicode           DB  "Use DB instead of DU. DU is reserved for unicode character definition only",13,10,0
_ExpDataType            DB  "Data Type Expected",13,10,0
_IDExpected             DB  "Expected identifier is missing or misplaced",13,10,0

_StringTableOverflow	DB	"String Table overflow.",13,10,0
_SymbolTableOverflow	DB	"Symbol Table overflow.",13,10,0
_RelocOverflow          DB  "Relocation Table overflow.",13,10,0
Err                     DB  "File error code:",0

_CommaError DB "Ambiguous usage of commas", 13,10,0
_RoundingAlreadySpecified   DB "Round has already been specified", 13,10,0
_ErrorHandlingAlreadySpecified DB "Error handling method has already been specified", 13, 10, 0
_BroadcastSizeAlreadySpecified DB "Broadcast size has already been specified", 13, 10, 0
_InvalidBroadcastSpecifier  DB "Invalid broadcast specifier", 13, 10, 0

_UninitDataFound DB "Uninitialized data found after instruction", 13, 10, 0
