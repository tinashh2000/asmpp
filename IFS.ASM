X86 = 1

IFDEF X86
echo "X86"
ELSE
echo "NO X86"
ENDIF

IFDEF X64
echo "X64"
ELSE
echo "NO X64"
ENDIF

X64 = 1
X87 = 2
IF ((X87 EQ 1)  AND (X64 EQ 1))
echo "X87 and X64"
ENDIF
