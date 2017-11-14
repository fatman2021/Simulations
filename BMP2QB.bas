SCREEN _NEWIMAGE(640, 480, 32)
DIM CCODE(0 TO 286) AS STRING
CLS: LOCATE 1, 1: INPUT "number of frames -> ", imageNo%
CLS: LOCATE 1, 1: INPUT "number of frames per second ->", fps%
CLS: LOCATE 1, 1: INPUT "frame width ->", Pw%
CLS: LOCATE 1, 1: INPUT "frame height ->", Ph%
IF imageNo% = 0 THEN END
CLS: LOCATE 1, 1: INPUT "enter alpha level -> ", ALPHA$
S$ = LTRIM$(RTRIM$(CHR$(34))): C$ = "   CASE ": X$ = ": xcolor& = &H"
IF VAL(ALPHA$) < 10 THEN
    ALPHA$ = LTRIM$(RTRIM$("0" + HEX$(VAL(ALPHA$))))
ELSE
    ALPHA$ = LTRIM$(RTRIM$(HEX$(VAL(ALPHA$))))
END IF
IF VAL("&H" + ALPHA$) < &H00 OR VAL("&H" + ALPHA$) > &HFF THEN END
FILE$ = LTRIM$(RTRIM$("0")) + ".bmp"
' PRINT FILE$: END
CLS: LOCATE 1, 1: INPUT "use backbuffer ->  [YES/NO]", BKB$
CLS: LOCATE 1, 1: INPUT "fullscreen mode -> [YES/NO]", FSM$
BKB$ = UCASE$(BKB$): FSM$ = UCASE$(FSM$)
HANDLE = _LOADIMAGE(FILE$)
Ps% = _PIXELSIZE(HANDLE) * 8
SCREEN _NEWIMAGE(Pw%, Ph%, Ps%)
IF Pw% < 128 THEN Ww% = 128 ELSE Ww% = Pw%
IF Ph% < 96 THEN Wh% = 96 ELSE Wh% = Ph%
OPEN "MAIN.BAS" FOR OUTPUT AS #1
PRINT #1, "REDIM _PRESERVE x AS _UNSIGNED _INTEGER64, y AS _UNSIGNED _INTEGER64, frame AS _UNSIGNED _INTEGER64, HANDLE("; LTRIM$(RTRIM$(STR$(imageNo%))); ") AS _UNSIGNED _INTEGER64"
PRINT #1, "SCREEN _NEWIMAGE("; LTRIM$(RTRIM$(STR$(Ww%))); ", "; LTRIM$(RTRIM$(STR$(Wh%))); ", 32)"
IF FSM$ = "YES" THEN PRINT #1, "_FULLSCREEN"
IF imageNo% > 1 THEN PRINT #1, "FOR frame = 0 TO"; STR$(imageNo%)
IF BKB$ = "YES" THEN
    PRINT #1, "    _DEST 0: LOCATE 1, 1: PRINT "; S$; "Buffering frame number: "; S$; "; frame"
    PRINT #1, "    HANDLE(frame) = _NEWIMAGE("; LTRIM$(RTRIM$(STR$(Pw%))); ", "; LTRIM$(RTRIM$(STR$(Ph%))); ", 32)"
    PRINT #1, "    _DEST HANDLE(frame)"
END IF
PRINT #1, "    FOR y ="; STR$(Ph%); " TO 0 STEP -1"
PRINT #1, "        FOR x = 0 TO "; STR$(Pw%)
PRINT #1, "            READ xcolor$"
PRINT #1, "            PSET(x, y), VAL("; S$; "&H"; ALPHA$; S$; " + xcolor$)"
PRINT #1, "        NEXT x"
PRINT #1, "    NEXT y"
IF imageNo% > 1 THEN PRINT #1, "NEXT frame: frame = 0"
IF BKB$ = "YES" THEN
    PRINT #1, "_DEST 0"
    IF imageNo% > 1 THEN PRINT #1, "START: "
    PRINT #1, "_PUTIMAGE(0, 0)-("; LTRIM$(RTRIM$(STR$(Ww%))); ", ";
    PRINT #1, LTRIM$(RTRIM$(STR$(Wh%))); "), HANDLE(frame), 0"
END IF
IF imageNo% > 1 THEN
    PRINT #1, LTRIM$(RTRIM$("_LIMIT ")); STR$(fps%)
    PRINT #1, "frame = frame + 1: IF frame >"; STR$(imageNo%); " THEN frame = 0"
    PRINT #1, "IF INKEY$ <> "; LTRIM$(RTRIM$(CHR$(34))); CHR$(34); " THEN "
    PRINT #1, "    FOR frame = 0 TO"; STR$(imageNo%)
    PRINT #1, "        _FREEIMAGE HANDLE(frame)"
    PRINT #1, "    NEXT frame"
    PRINT #1, "ELSE"
    IF BKB$ = "YES" THEN PRINT #1, "   GOTO START"
    PRINT #1, "END IF"
END IF
FOR FileNo% = 0 TO imageNo%
    GOSUB LoadFrame:
    FOR y% = Ph% TO 0 STEP -1
        PRINT #1, "DATA ";
        FOR x% = 0 TO Pw%
            CLR$ = LTRIM$(RTRIM$(RIGHT$(HEX$(POINT(x%, y%)), 6)))
            IF SL% = Pw% + 1 THEN
                PRINT #1, LTRIM$(RTRIM$(CLR$)): SL% = 1
            ELSE
                PRINT #1, LTRIM$(RTRIM$(CLR$));
                IF x% = Pw% THEN
                    PRINT #1, CHR$(32): SL% = 1
                ELSE
                    PRINT #1, LTRIM$(RTRIM$(","));: SL% = SL% + 1
                END IF
            END IF
        NEXT
    NEXT
    IF imageNo% = 1 THEN EXIT FOR
    CLOSE #2
NEXT
CLOSE #1: SCREEN 0: WIDTH 80, 25: PRINT LTRIM$(RTRIM$(STR$(imageNo%))); " saved.": END
LoadFrame:
FILE$ = LTRIM$(RTRIM$(STR$(FileNo%))) + ".bmp"
' PRINT FILE$
HANDLE = _LOADIMAGE(FILE$)
_PUTIMAGE (0, 0), HANDLE, 0
RETURN
