!macro ReplaceBetween This AndThis With In
Push "${This}"
Push "${AndThis}"
Push "${With}"
Push "${In}"
 Call ReplaceBetween
!macroend
!define ReplaceBetween "!insertmacro ReplaceBetween"
 
Function ReplaceBetween
 Exch $R0 ; file
 Exch
 Exch $R1 ; replace with
 Exch 2
 Exch $R2 ; before this (marker 2)
 Exch 2
 Exch 3
 Exch $R3 ; after this  (marker 1)
 Exch 3
 Push $R4 ; marker 1 len
 Push $R5 ; marker pos
 Push $R6 ; file handle
 Push $R7 ; temp file handle
 Push $R8 ; temp file name
 Push $R9 ; current line string
 Push $0 ; current chop
 Push $1 ; marker 1 + text
 Push $2 ; marker 2 + text
 Push $3 ; marker 2 len
 
 GetTempFileName $R8
 FileOpen $R7 $R8 w
 FileOpen $R6 $R0 r
 
 StrLen $3 $R3
 StrLen $R4 $R2
 
 Read1:
  ClearErrors
  FileRead $R6 $R9
  IfErrors Done
  StrCpy $R5 -1
 
 FindMarker1:
  IntOp $R5 $R5 + 1
  StrCpy $0 $R9 $3 $R5
  StrCmp $0 "" Write
  StrCmp $0 $R3 0 FindMarker1
   IntOp $R5 $R5 + $3
   StrCpy $1 $R9 $R5
 
  StrCpy $R9 $R9 "" $R5
  StrCpy $R5 0
  Goto FindMarker2
 
 Read2:
  ClearErrors
  FileRead $R6 $R9
  IfErrors Done
  StrCpy $R5 0
 
 FindMarker2:
  IntOp $R5 $R5 - 1
  StrCpy $0 $R9 $R4 $R5
  StrCmp $0 "" Read2
  StrCmp $0 $R2 0 FindMarker2
   StrCpy $2 $R9 "" $R5
 
   FileWrite $R7 $1$R1$2
   Goto Read1
 
 Write:
  FileWrite $R7 $R9
  Goto Read1
 
 Done:
  FileClose $R6
  FileClose $R7
 
  SetDetailsPrint none
  Delete $R0
  Rename $R8 $R0
  SetDetailsPrint both
 
 Pop $3
 Pop $2
 Pop $1
 Pop $0
 Pop $R9
 Pop $R8
 Pop $R7
 Pop $R6
 Pop $R5
 Pop $R4
 Pop $R1
 Pop $R0
 Pop $R2
 Pop $R3
FunctionEnd