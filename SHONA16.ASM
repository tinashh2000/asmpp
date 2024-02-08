CorpInfo            DB      "ASM++ (African Assember). Version 14.01 (",??DATE," ", ??TIME,")",13,10
                    DB      "(C)opyright 2006 Tinashe Mutandagayi (tinashh2000@yahoo.com)",13,10
                    DB      "      €€±∞      €€€€€€±∞   €€±∞    €€±∞",13,10
                    DB      "    €€± €€±∞    €€±∞       €€€€±∞€€€€±∞    €€±∞       €€±∞",13,10
                    DB      "  €€±∞    €€±∞  €€€€€€±∞   €€±∞€€±∞€€±∞  €€€€€€±∞   €€€€€€±∞",13,10
                    DB      "  €€€€€€€€€€±∞      €€±∞   €€±∞    €€±∞    €€±∞       €€±∞",13,10
                    DB      "  €€±∞    €€±∞  €€€€€€±∞   €€±∞    €€±∞",13,10,0
Usage               DB      "Mashandiro   AP [MaOptions] file rekushanda [file richabuda]",13,10
                    DB      "MaOptions:",13,10
                    DB      "/ELF**  Gadzira Executable and Linkable Format",13,10
                    DB      "/OBJ*   Gadzira OMF object",13,10
                    DB      "/EXE    Gadzira DOS MZ",13,10
;                    DB      "/PE*    Gadzira Portable Executable",13,10
;                    DB      "/COFF** Gadzira Common Object File Format",13,10
;                    DB      "/cs     Siyanisa mavara makuru ne madiki",13,10
                    DB      "/js/jn  MaConditional jumps ese maShort(js)/Near(jn)",13,10
                    DB      "/jo     Ita maShort jumps pese panokwanisika.",13,10
                    DB      "/oc/ou  Ita maShort jumps pese panokwanisika pamaConditional (oc) kana",13,10
                    DB      "        Unconditional jumps (ou)",13,10
                    DB      "/w+     Ratidza yambiro dzese. Number ye'Yambiro dzapihwa' inosanganisa",13,10
                    DB      "        dzimwe dzisingaratidzwe. W+ anoita kuti dziratidzwe",13,10
                    DB      "Pana * panoiswa 16,32 or 64(Bits) uye pana ** panoiswa 32/64",13,10
                    DB      "Assembler ino iyi ndeye mahara. Unogona kuipa kuvanhu vaunoda asi",13,10
                    DB      "haifanirwe kushandiswa kutsvaga mari kana kushandiswa mumaCompany.",13,10
                    DB      "Kurongonora assembler iyi kana kuishandurudza handizvibvumidze",13,10,0
Msg0                DB      "File riri kushandwa:  ",0
Msg1                DB      "File richabuda:       ",0
Msg2                DB      "Zvakanganiswa:        ",0
Msg3                DB      "Yambiro dzapihwa:     ",0
Msg4                DB      "Mabytes anyorwa:      ",0
Msg5                DB      "Ongororo dzaitwa:     ",0
Msg6                DB      "Masymbols ashandiswa: ",0
Msg7                DB      "Mitsara yaverengwa:   ",0
Msg8                DB      "Hapana",13,10,0

ErrorTxt            DB  "*Gadziriso** ",0
FatalTxt            DB  "*Tsaona** ",0
WarningTxt          DB  "*Yambiro** ",0
_MResizeError       DB  "Paita dambudziko pakudzora kukura kweMemory : ",0
_MAllocError        DB  "Paita dambudziko pakugoverwa kweMemory : ",0
_NotEnoughMem       DB  "Memory iripo ishoma pane iri kudiwa (128KB)",13,10,0
_FileNotFound       DB  "File rashaikwa: ",0
_PathNotFound       DB  "Nzvimbo ineFile yashaikwa: ",0
_AccessDenied       DB  "Kushandisa disk/file kwarambidzwa: ",0
_InvalidDrive       DB  "Drive rashayikwa: ",0
_TooManyFiles       DB  "MaFiles awandisa: ",0
_DiskError          DB  "Paita dambudziko neDisk, code : ",0
_ExpectedInstr      DB  "Panodiwa instruction/definition chete",13,10,0
_ManyOperands       DB  "MaOperands akawandisa",13,10,0
_FewOperands        DB  "Panodiwa mamwe maOperands ",13,10,0
_NumTooBig          DB  "Number yakakurisa",13,10,0
_NumExpected        DB  "Parikudiwa number",13,10,0
_MissingEndQuote    DB  "Parikudiwa quote yekuvhara (",0
_IDTooLong          DB  "Izwi riri mumutsara uno rakarebesa",13,10,0
_InvalidAddrMode    DB  "Instruction/maOperands hazvidiwe muaddress mode ino",13,10,0
_StrInstrExpected   DB  "Panongodiwa string instruction ",13,10,0
;_MisplacedComma     DB  "Patsanuro (,) yaitwa haibvumidzwe",13,10,0
_SpecAlreadyUsed    DB  "Keyword raonekwa kare",13,10,0
_DXImmExpected      DB  "DX/Number iri kudiwa",13,10,0
_AccumExpected      DB  "AL/(E)AX arikudiwa",13,10,0
_MissingComma       DB  "Patsanuro(,) iri kudiwa pamaOperands",13,10,0
_CSDest             DB  "CS haikwanise kugamuchira mazwi",13,10,0
_OperandSizeMismatch   DB  "Maoperands akasiyana pamarudzi/pakukura",13,10,0
_CombinationNotAllowed DB  "Sarudzo yemaOperands haibvumidzwe",13,10,0
_InvalidOperandSize    DB  "Kukura kweOperand/maOperands hakubvumidzwe ",13,10,0
_InvalidEAReg          DB  "Register haiidiwe muAddress ",13,10,0
_MultiR16Base       DB  "Panodiwa base register (BX,BP) rimwe",13,10,0
_MultiR16Idx        DB  "Panodiwa index register (SI,DI) rimwe",13,10,0
_EARegMismatch      DB  "MaRegister akasiyana muAddress",13,10,0
_InvalidEAEntry     DB  "Pane zvisingadiwe muExpression/muAddress",13,10,0
_InvalidOperator    DB  "MaOperators ashandiswa zvisirizvo",13,10,0
_DispTooBig         DB  "Number iyi yakakurisa",13,10,0
_OperandSizeRequired   DB  "Hukuru hweOperand huri kudiwa",13,10,0
_FormatRequired     DB  "Parikudiwa rudzi rweFile (ELF,MZ,COFF,PE)",13,10,0
_OutOfMacroSpace    DB  "Hapasisina nzvimbo yemaMacros",13,10,0
_InvalidNum             DB  "Number yanyorwa zvisirizvo",13,10,0
_InvalidRegister        DB  "Register yashandiswa zvisirizvo",13,10,0
_ByteOperandExpected    DB  "Byte Operand iri kudiwa",13,10,0
_InvalidOperand         DB  "Operand haibvumidzwe",13,10,0
_InvalidOperand1        DB  "Operand yekutanga haidiwe",13,10,0
_InvalidOperand2        DB  "Operand yepiri haidiwe",13,10,0
_InvalidOperand3        DB  "Operand yetatu haidiwe",13,10,0
_MemOpExpected          DB  "Parikudiwa Memory operand",13,10,0
_ProgIPOverflow         DB  "Program/segment ichangopera yakakurisa",13,10,0
_JumpAboveRange         DB  "Jump yakurisa nemaBytes ",0
_JumpBelowRange         DB  "Jump yaita diki nemaBytes ",0
_NoRValue               DB  "Number yekurudyi iri kudiwa",13,10,0
_NoLValue               DB  "Number yekuruboshwe iri kudiwa",13,10,0
_CommentNoTerminator    DB  "Panodiwa vara rimwe chete, pakutanga nekupera kwecomment",13,10,0
_CommentNotClosed       DB  "File raguma, comment yabviswa",13,10,0
_BadRadix               DB  "Radix yako haidiwe, shandisa 2,8,10,16",13,10,0
_MissingOperator        DB  "Panodiwa operator pakati pemaOperands",13,10,0
_InvalidOperators       DB  "MaOperators ashandiswa zvisirizvo",13,10,0
_DupDef                 DB  "Identifier yanyorwa kare",13,10,0
_UnmatchedEnd           DB  "Kutanga nekupera kweBlock kwakasiyana: ",0
_AlreadyInBlock         DB  "Pane block rinofanirwa kuvharwa",13,10,0
_IDNotFound             DB  "Identifier iyi yashaikwa : ",0
_RefMismatch            DB  "Rudzi rweSymbol rwasiyana nerwafungidzirwa",13,10,0
_NewPass                DB  "Pass imwe",13,10,0
_SymSpaceOut            DB  "Hapasisina nzvimbo yemaSymbols",13,10,0
_MissingLabel           DB  "Panodiwa identifier kumashure kweKeyword iri",13,10,0
_MissingOpenSq          DB  "'[' anodiwa pasati pauya ']'",13,10,0
_MissingCloseSq         DB  "Bracket harina kuvharwa na ']'",13,10,0
_MissingOpenBr          DB  "'(' anonodiwa pasati pauya ')'",13,10,0
_MissingCloseBr         DB  "Bracket harina kuvharwa na ')'",13,10,0
_TooManyRegs            DB  "MaRegister akawandisa muAddress",13,10,0
_ImmCLExpected          DB  "Number/CL ndiye arikudiwa",13,10,0
_EAESPError             DB  "ESP/RSP/R12 haashande neScale kana seIndex muAddress",13,10,0
_NotCoded               DB  "Handisati ndapagadzira apa: ",0
_FileNameExpected       DB  "Zita reFile ririkudiwa",13,10,0
_FilesTooNested         DB  "MaFiles anyanya kuturikidzana",13,10,0
_RefEQU                 DB  "Constant yashandiswa isati yanyorwa.",13,10,0
_InvalidKeyword         DB  "Keyword yashandiswa zvisirizvo: ",0
_InvalidScale           DB  "Scale yaiswa haiidiwe, panodiwa 1,2,4,8",13,10,0
_LabelExpected          DB  "Parikudiwa Label/number",13,10,0
_JumpTooBig             DB  "Jump yakurisa asi yadimbudzirwa",13,10,0
_SelOfsExpected         DB  "Parikudiwa Selector:Offset zveFar address",13,10,0
_TempFileError          DB  "Paita dambudziko pakugadzira temporary file",0
_NoCodeSeg              DB  "Instruction yaiswa pasina Code segment: ",0
_NoDataSeg              DB  "Directive yaiswa pasina kweData segment: ",0
_UninitSeg              DB  "Tanga waisa segment itsva",13,10,0
_HeaderLarge            DB  "Header reOutput file rakurisa",13,10,0
_CantESOverride         DB  "Hazviite kuita override yaES",13,10,0
_InvalidFmt             DB  "File rine format isiriyo/rakakurisa",13,10,0
_BadReloc               DB  "Fixup iyi ine maBits asiri eFormat ino.",13,10,0
_Start                  DB  "&Tanga",0
_Stop                   DB  "&Mira",0
_Ignored                DB  "Keyword Ignored"
_lf                     DB  13,10,0
_Done                   DB  "African Assembler Yapedza Zvayo!",13,10,0
_ArgStr                 DB  "Arg:",0
CorpInfo2               DB  "ASM++ (African Assember). Version 7.3 March 2007",0
_AlreadyRunning         DB  "Another instance of this program is already running",0
_RCLabelExpected        DB  "Label yeResource ndiyo iri kudiwa",13,10,0
_StubSizeError			DB	"Pane dambudziko pakuverengwa kwe Stub File",13,10,0
_DUForUnicode           DB  "Shandisa DB kunze kwe DU. DU yakamirira maUnicode characters chete",13,10,0
_ExpDataType            DB  "Parikudiwa Data Type",13,10,0
_IDExpected             DB  "Identifier irikutarisirwa yashaikwa kana kuti yaiswa pasiripo",13,10,0

_StringTableOverflow	DB	"String Table overflow.",13,10,0
_SymbolTableOverflow	DB	"Symbol Table overflow.",13,10,0

Err                     DB  "File error code:",0
