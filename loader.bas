' NewImage = ImageScale(SourceImage,width,height)

' mode = ScreenList(32)
' While (mode <> 0)
'    w = HiWord(mode)
'    h = LoWord(mode)
'    mode = ScreenList()
' Wend
' ScreenRes 640, 480, 32, , &H01 : Cls ' And &H40 And &H80 : Cls
' ImageCreate only works, if graphic's screen is defined first!!!
' Dim As Any Ptr img1 = ImageCreate(640, 480)
' Dim As Any Ptr img2 = ImageCreate(640, 480)

' Bload "Podloga.bmp", img1  : Put (0,0), Img1, Pset
' Bload "snowman.bmp", img2 : Put Img1, (0, 0), Img2, Alpha 
' Put (0,0), Img2, Alpha
'
' Put (0, 0), img1, Pset
' Print w;"x"; Ltrim$(Str$(h)); " 32-bit(RGBA)"
' While Inkey = ""
'    Sleep 10, 1  ' prevent CPU *hogging*
' Wend
ScreenRes 640, 480, 32 : Cls ' , , &H1: Cls
Dim As Integer Index
For Index = 1 to 60
  Bload "FRAMES\" + Ltrim$(Str$(Index)) + ".bmp", 0 
 ' Print "FRAMES\" + Ltrim$(Str$(Index)) + ".bmp"
 Sleep 10, 1
Next Index
' While Inkey = ""
'    Sleep 10, 1  ' prevent CPU *hogging*
' Wend
' End
