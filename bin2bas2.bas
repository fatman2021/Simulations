''
'' bin2bas -- converts a binary file to an initialized array
''

declare function hStripExt( byval filename as string ) as string

   dim as string filename
   dim as integer filelen
   
   filename = command$(1)
   
   ''
   ''
   ''
   if( open( filename, for binary, access read, as #1 ) <> 0 ) then
      print "Error: Binary file not found"
      end 1
   end if
   
   filename = hStripExt( filename )
   filelen = lof( 1 )
   
   if( filelen = 0 ) then
      print "Error: Empty file"
      end 1
   end if
   
   ''
   ''
   ''
   if( open( filename + ".bi", for output, as #2 ) <> 0 ) then
      print "Error: Cannot create the inc file"
      end 1
   end if
   
   print #2, "extern " + filename + "_data(0 to " + str$( filelen ) + "-1) as ubyte"
   
   close #2
   
   ''
   ''
   ''
   if( open( filename + ".bas", for output, as #2 ) <> 0 ) then
      print "Error: Cannot create the bas file"
      end 1
   end if
   
   print #2, "#include once """ + filename + ".bi"""
   print #2, ""
   print #2, "dim shared " + filename + "_data(0 to " + str$( filelen ) + "-1) as ubyte = { _"
   
   ''
   ''
   ''
   dim as ubyte ub
   dim as integer bytes, cnt = 0
   
   bytes = 0
   cnt = 0
   do while( not eof( 1 ) )
      
      get #1, , ub
      bytes += 1
      
      if( cnt > 30 ) then
         cnt = 0
         print #2, " _"
      end if
      
      print #2, "&h" + hex( ub );      
      cnt += 1
      
      if( bytes < filelen ) then
         print #2, ",";
      end if
   loop
   
   print #2, " }"
   
   close #2
   
   close #1
   
   
'':::::
function hStripExt( byval filename as string ) as string static
    dim p as integer, lp as integer

   lp = 0
   do
      p = instr( lp+1, filename, "." )
       if( p = 0 ) then
          exit do
       end if
       lp = p
   loop

   if( lp > 0 ) then
      function = left$( filename, lp-1 )
   else
      function = filename
   end if

end function