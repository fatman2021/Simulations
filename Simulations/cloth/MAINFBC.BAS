DIM AS UNSIGNED LONG xcolor 
DIM AS UNSIGNED INTEGER x
DIM AS INTEGER y
DIM AS UNSIGNED INTEGER frame
SCREENRES 640, 480, 32, , &H1: CLS
DIM AS ANY PTR IMG = IMAGECREATE(640, 480)
DO UNTIL INKEY$ <> ""
    FOR frame = 0 TO 150
        FOR y = 479 TO 1 STEP -1
            FOR x = 0 TO 639
                READ xcolor: PSET IMG, (x, y), xcolor
            NEXT x
        NEXT y
        PUT(0, 0), IMG, PSET
    NEXT frame
RESTORE: LOOP
SYSTEM
