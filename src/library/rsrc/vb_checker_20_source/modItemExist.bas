Attribute VB_Name = "modItemExist"
Option Explicit

' ***************************************************************************
' Project:
'
' Module:        basItemExist
'
' Description:   Test to see if a drive, path, or file exists.  One
'                drawback is this routine assumes that all filenames have
'                an extension.
'
' ===========================================================================
'    DATE      NAME             DESCRIPTION
' -----------  ---------------  ---------------------------------------------
' 02-DEC-1999  Kenneth Ives     Module created by kenaso@home.com
' ***************************************************************************
  
' ------------------------------------------------------------
' Drive types
' ------------------------------------------------------------
  Private Const DRV_FIXED1 = 1        ' Local hard drive (Primary partition)
  Private Const DRV_REMOVABLE = 2     ' Floppy or Jaz drive
  Private Const DRV_FIXED2 = 3        ' Local hard drive (Secondary partition)
  Private Const DRV_NETWORK = 4       ' Shared Network drive
  Private Const DRV_CDROM = 5         ' CD-Rom drive
  Private Const DRV_RAMDISK = 6       ' Virtual memory disk
  
  Private Declare Function GetDriveType Lib "kernel32" _
            Alias "GetDriveTypeA" (ByVal nDrive As String) As Long
  
' ------------------------------------------------------------
' Declares needed for file/directory information
' ------------------------------------------------------------
  Private Type FILETIME
     dwLowDateTime As Long
     dwHighDateTime As Long
  End Type

  Private Type WIN32_FIND_DATA
        dwFileAttributes As Long
        ftCreationTime As FILETIME
        ftLastAccessTime As FILETIME
        ftLastWriteTime As FILETIME
        nFileSizeHigh As Long
        nFileSizeLow As Long
        dwReserved0 As Long
        dwReserved1 As Long
        cFileName As String * 260
        cAlternate As String * 14
  End Type

  Private Declare Function FindFirstFile Lib "kernel32" _
            Alias "FindFirstFileA" (ByVal lpFileName As String, _
            lpFindFileData As WIN32_FIND_DATA) As Long
            
  Private Declare Function FindClose Lib "kernel32" _
            (ByVal hFindFile As Long) As Long
            
' ------------------------------------------------------------
' Needed for a list of all available drive letters
' ------------------------------------------------------------
  Private Declare Function GetLogicalDriveStrings Lib "kernel32" _
            Alias "GetLogicalDriveStringsA" (ByVal nBufferLength As Long, _
            ByVal lpBuffer As String) As Long

Sub TEST()

' ***************************************************************************
' Routine:       TEST
'
' Description:   This is aroutine to test this module.  Load it into VB by
'                itself.  Rename to "Main" and press F5 to execute.
'                Uncomment the input line you want to test.
'
' Parameters:
'
' Return Values:
'
' Special Logic:
'
' ===========================================================================
'    DATE      NAME             DESCRIPTION
' -----------  ---------------  ---------------------------------------------
' 02-DEC-1999  Kenneth Ives     Routine created by kenaso@home.com
' ***************************************************************************

' ------------------------------------------------------------
' Define local variables
' ------------------------------------------------------------
  Dim sInput As String

' ------------------------------------------------------------
' Uncomment the one you want to test
' ------------------------------------------------------------
  sInput = "c:\autoexec.bat"     ' Test for file (good)
  'sInput = "C:\sutoexec.bat"     ' test for file (bad)
  'sInput = "C:\nul"              ' test root level (good)
  'sInput = "C:"                  ' drive test (good)
  'sInput = "K:\autoexec.bat"     ' drive test (bad)
  'sInput = "K:"                  ' drive test (bad)
  'sInput = "c:\program files\"   ' test for folder (good)
  'sInput = "C:\program file\"    ' test for folder (bad)
  
' ------------------------------------------------------------
' display true or false message
' ------------------------------------------------------------
  If ItemExist(sInput) Then
      MsgBox StrConv(sInput, vbUpperCase) & vbLf & vbLf & "does exist.", _
             vbOKOnly, "Test Existance"
  Else
      MsgBox StrConv(sInput, vbUpperCase) & vbLf & vbLf & "was not found!", vbOKOnly, "Test Existance"
  End If
  
  End

End Sub

Private Function TypeOfDrive(sDriveLtr As String) As Long

' ***************************************************************************
' Routine:       TypeOfDrive
'
' Description:   Determine the type of drive we are querying
'
' Parameters:    sDriveLtr - drive to be queried (ex:  C:)
'
' Return Values:
'
' Special Logic:
'
' ===========================================================================
'    DATE      NAME             DESCRIPTION
' -----------  ---------------  ---------------------------------------------
' 02-DEC-1999  Kenneth Ives     Routine created by kenaso@home.com
' ***************************************************************************

' ------------------------------------------------------------
' Define local variables
' ------------------------------------------------------------
  Dim lRetVal As Long
  Dim lType As Long
  
' ------------------------------------------------------------
' Verify data was passed
' ------------------------------------------------------------
  If Len(Trim(sDriveLtr)) = 0 Then
      TypeOfDrive = 0
      Exit Function
  End If
  
' ------------------------------------------------------------
' Verify drive letter that was passed is in the right format
' ------------------------------------------------------------
  sDriveLtr = StrConv(Left(sDriveLtr, 1), vbUpperCase)
  
' ------------------------------------------------------------
' Append a colon to the drive letter
' ------------------------------------------------------------
  sDriveLtr = sDriveLtr & ":"
    
' ------------------------------------------------------------
' Drive type:
'    DRV_FIXED1    = 1  Local hard drive (Primary partition)
'    DRV_REMOVABLE = 2  Floppy or other removeable drive
'    DRV_FIXED2    = 3  Local hard drive (Secondary partition)
'    DRV_NETWORK   = 4  Shared Network drive
'    DRV_CDROM     = 5  CD-Rom device
'    DRV_RAMDISK   = 6  Virtual memory disk
'
' Get the drive number constant
' ------------------------------------------------------------
  lType = GetDriveType(sDriveLtr)
  Select Case lType
         Case 1: TypeOfDrive = 1
         Case 2: TypeOfDrive = 2
         Case 3: TypeOfDrive = 3
         Case 4: TypeOfDrive = 4
         Case 5: TypeOfDrive = 5
         Case 6: TypeOfDrive = 6
         Case Else: TypeOfDrive = 0  ' unknown type
  End Select
                       
End Function

Public Function ItemExist(sSearchItem As String) As Boolean

' ***************************************************************************
' Routine:       ItemExist
'
' Description:   Test to see if a drive, path, or file exists.  One
'                drawback is this routine assumes that all filenames have
'                an extension.
'
'                     Syntax:   ItemExist("C:\Program Files\Desktop.ini")
'
'                To test for the existence of a subdirectory instead of a
'                file, enter the path (with or without a backslash)
'
'                     Syntax:   ItemExist("C:\Program Files")
'
'                If checking for the root level of a directory, other than
'                a RAM drive, use an old DOS trick like this:
'
'                     Syntax:   ItemExist("C:\nul")
'
'                To test for a valid drive letter, use:
'
'                     Syntax:   ItemExist("C:") or ItemExist("C:\")
'
'
' Parameters:    sSearchItem - Path\filename to be queried.  See decription.

'
' Return Values: True or False
'
' Special Logic:
'
' ===========================================================================
'    DATE      NAME             DESCRIPTION
' -----------  ---------------  ---------------------------------------------
' 02-DEC-1999  Kenneth Ives     Routine created by kenaso@home.com
' ***************************************************************************

' ------------------------------------------------------------
' define variables
' ------------------------------------------------------------
  Dim WFD As WIN32_FIND_DATA
  Dim lHandle As Long
  Dim lType As Long
  Dim sTmpSource As String
  Dim sDrvLtr As String
  Dim sTmpDrvLtrs As String
  
' ------------------------------------------------------------
' Initialize variables
' ------------------------------------------------------------
  sTmpSource = Trim(sSearchItem)
  
' ------------------------------------------------------------
' Remove trailing backslash if it exist
' ------------------------------------------------------------
  If Right(sTmpSource, 1) = "\" Then
      sTmpSource = Left(sTmpSource, Len(sTmpSource) - 1)
  End If
  
' ------------------------------------------------------------
' Check to see if this is a valid drive letter.  Convert all
' to lowercase.
' ------------------------------------------------------------
  sDrvLtr = StrConv(Left(sTmpSource, 1), vbLowerCase) ' save just the letter
  sTmpDrvLtrs = StrConv(GetDriveString, vbLowerCase)  ' get all drive letters
  
  If InStr(1, sTmpDrvLtrs, sDrvLtr) = 0 Then          ' is this a valid drive?
      ItemExist = False                               ' no, it is not
      Exit Function                                   ' leave here
  End If
  
' ------------------------------------------------------------
' Drive type:
'    DRV_FIXED1    = 1  Local hard drive (Primary partition)
'    DRV_REMOVABLE = 2  Floppy or other removeable drive
'    DRV_FIXED2    = 3  Local hard drive (Secondary partition)
'    DRV_NETWORK   = 4  Shared Network drive
'    DRV_CDROM     = 5  CD-Rom device
'    DRV_RAMDISK   = 6  Virtual memory disk
' ------------------------------------------------------------
  lType = TypeOfDrive(sDrvLtr)
  
' ------------------------------------------------------------
' if an unknown device code of zero is returned then leave
' ------------------------------------------------------------
  If lType = 0 Then
      ItemExist = False
      Exit Function
  End If
  
' ------------------------------------------------------------
' if we are just checking the drive then see if this is the
' root directory (ex. "C:" or "C:\") of a valid storage
' device.
' ------------------------------------------------------------
  If Len(sTmpSource) < 4 Then    ' if "C:\" or similar then test
      If (lType < 7) And (Len(sTmpSource) = 2) Then
          ItemExist = True
          Exit Function
      End If
  End If
    
' ------------------------------------------------------------
' Make the API call to see if the folder or file exist
' ------------------------------------------------------------
  lHandle = FindFirstFile(sTmpSource, WFD)
  
' ------------------------------------------------------------
' Return either TRUE or FALSE
' ------------------------------------------------------------
  If lHandle < 1 Then
      ItemExist = False
  Else
      ItemExist = True
  End If
  
' ------------------------------------------------------------
' Always close the file handle
' ------------------------------------------------------------
  Call FindClose(lHandle)
   
End Function
Private Function GetDriveString() As String

' ***************************************************************************
' Routine:       GetDriveString
'
' Description:   Get the list of available drive letters, each separated by
'                a null character.  (i.e.  a:\ c:\ d:\)
'
' Parameters:
'
' Return Values: String of available drive letters
'
' Special Logic:
'
' ===========================================================================
'    DATE      NAME             DESCRIPTION
' -----------  ---------------  ---------------------------------------------
' 02-DEC-1999  Kenneth Ives     Routine created by kenaso@home.com
' ***************************************************************************

' ------------------------------------------------------------
' Define local variables
' ------------------------------------------------------------
  Dim lRetVal As Long
  Dim sDrvLtrs As String
  
' ------------------------------------------------------------
' Preload the buffer area with maximum amount of space.
'
'   26   letters of the alphabet
'  x 4   1 letter, 1 colon, 1 backslash, 1 null char
' -----
'  104
' ------------------------------------------------------------
  sDrvLtrs = Space(104)
  
' ------------------------------------------------------------
' capture all the available drives in one long string
' ------------------------------------------------------------
  lRetVal = GetLogicalDriveStrings(Len(sDrvLtrs), sDrvLtrs)
  
' ------------------------------------------------------------
' remove all leading and trailing blanks before exiting
' ------------------------------------------------------------
  sDrvLtrs = Trim(sDrvLtrs)
  GetDriveString = sDrvLtrs

End Function

