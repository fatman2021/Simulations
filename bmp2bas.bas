SCREEN _NEWIMAGE(640, 480, 32)
CLS: LOCATE 1, 1: INPUT "number of frames -> ", imageNo%
CLS: LOCATE 1, 1: INPUT "number of frames per second ->", fps%
CLS: LOCATE 1, 1: INPUT "frame width ->", fwidth%
CLS: LOCATE 1, 1: INPUT "frame height ->", fhight%
IF imageNo% = 0 THEN END ELSE BMP$ = "1"
IF imageNo% = 1 THEN BMP$ = LTRIM$(RTRIM$(STR$(imageNo%)))
CLS: LOCATE 1, 1: INPUT "enter alpha level -> ", ALPHA$
ALPHA$ = LTRIM$(RTRIM$("&H" + HEX$(VAL(ALPHA$))))
IF VAL(ALPHA$) < &H00 OR VAL(ALPHA$) > &HFF THEN END
FILE$ = BMP$ + ".bmp"
HANDLE = _LOADIMAGE(FILE$)
Pw% = fwidth%: Ph% = fhight%
Ps% = _PIXELSIZE(HANDLE) * 8
SCREEN _NEWIMAGE(Pw%, Ph%, Ps%)
IF Pw% < 320 THEN Ww% = 320 ELSE Ww% = Pw%
IF Ph% < 200 THEN Wh% = 200 ELSE Wh% = Ph%
OPEN "MAIN.BAS" FOR OUTPUT AS #1
FOR FileNo% = 1 TO imageNo%
    OPEN LTRIM$(RTRIM$((STR$(FileNo%)))) + ".BAS" FOR OUTPUT AS #2
    PRINT #1, LTRIM$(RTRIM$("'$INCLUDE:'")) + LTRIM$(RTRIM$((STR$(FileNo%)))) + LTRIM$(RTRIM$(".BAS" + "'"))
    BMP$ = LTRIM$(RTRIM$(STR$(FileNo%)))
    IF imageNo% = 1 THEN BMP$ = LTRIM$(RTRIM$(STR$(imageNo%)))
    FILE$ = UCASE$(BMP$) + ".bmp"
    HANDLE = _LOADIMAGE(FILE$)
    _PUTIMAGE (0, 0), HANDLE, 0
    FOR y% = Ph% TO 0 STEP -1
        PRINT #2, "DATA ";
        FOR x% = 0 TO Pw%
            CLR$ = LTRIM$(RTRIM$(ALPHA$ + RIGHT$(HEX$(POINT(x%, y%)), 6)))
            IF CLR$ = "&H" THEN CLR$ = "&H00000000"
            IF CLR$ = "&HFF000000" THEN CLR$ = "&H00000000"
            IF SL% = 45 THEN
                PRINT #2, CLR$
                SL% = 1: PRINT #2, "DATA ";
            ELSE
                PRINT #2, CLR$;
                IF x% = Pw% THEN
                    PRINT #2, CHR$(32)
                    SL% = 1
                ELSE
                    PRINT #2, ", ";
                    SL% = SL% + 1
                END IF
            END IF
        NEXT
    NEXT
    IF imageNo% = 1 THEN EXIT FOR
    CLOSE #2
NEXT
PRINT #1, "DIM xcolor AS _UNSIGNED LONG, x AS _UNSIGNED _INTEGER64"
PRINT #1, "DIM y AS _UNSIGNED _INTEGER64"
PRINT #1, "SCREEN _NEWIMAGE("; LTRIM$(RTRIM$(STR$(Ww%))); ", ";
PRINT #1, LTRIM$(RTRIM$(STR$(Wh%))); ", 32)"
IF imageNo% > 1 THEN
    PRINT #1, "DO UNTIL INKEY$ <> ";
    PRINT #1, LTRIM$(RTRIM$(CHR$(34))); CHR$(34)
    PRINT #1, "FOR frame% = 1 TO"; STR$(imageNo%)
END IF
PRINT #1, "HANDLE = _NEWIMAGE("; LTRIM$(RTRIM$(STR$(Pw%))); ", ";
PRINT #1, LTRIM$(RTRIM$(STR$(Ph%))); ", 32)"
PRINT #1, "_DEST HANDLE"
PRINT #1, " FOR y ="; STR$(Ph%); " TO 0 STEP -1"
PRINT #1, "  FOR x = 0 TO"; STR$(Pw%)
PRINT #1, "   READ xcolor: PSET(x, y), xcolor"
PRINT #1, "  NEXT x"
PRINT #1, " NEXT y"
PRINT #1, "_DEST 0"
PRINT #1, "_PUTIMAGE(0, 0)-("; LTRIM$(RTRIM$(STR$(Ww%))); ", ";
PRINT #1, LTRIM$(RTRIM$(STR$(Wh%))); "), HANDLE, 0"
PRINT #1, "_FREEIMAGE HANDLE"
IF imageNo% > 1 THEN
    PRINT #1, LTRIM$(RTRIM$("_LIMIT ")); STR$(fps%)
    PRINT #1, "NEXT frame%"
    PRINT #1, "RESTORE: LOOP"
END IF
PRINT #1, "SYSTEM"
CLOSE #1
SCREEN 0: WIDTH 80, 25
PRINT UCASE$(BAS$); " saved."

