Attribute VB_Name = "modIndentifyBin"
Option Explicit
Global Const Unscrambled = "UNSCRAMBLED"
Global Const Scrambled = "SCRAMBLED"

Public Function IdentifyBin(strFile As String) As String
Dim abc As String, _
    num1 As String, _
    num0 As String, _
    temp As String, _
    temp2 As String, _
    bortmnt As String, _
    dreamsnes As String, _
    tetris As String, _
    punch As String, _
    netbsd As String
Dim lngFileNum  As Long
ReDim ByteArray(FileLen(strFile)) As Byte
  
    lngFileNum = FreeFile 'Returns the next file number available for use by Open
    Open strFile For Binary Access Read Lock Write As #lngFileNum 'Open the selected file (using the function will define the file)
    Get #lngFileNum, , ByteArray 'Places the whole file into an array
    Close #lngFileNum 'Close the file
    strFile = StrConv(ByteArray, vbUnicode) 'Convert the array to unicode

    'These are the variables, if one of these strings are found inside a binary, it's unscrambled!
    abc = "abcdefghijklmnopqrstuvwxyz"
    num1 = "1234567890"
    num0 = "0123456789"
    temp = "#...'...*...-.../...2...4...7...9...;...=...?...A...C...E...G...I...J...L...N...O...Q...R...T...U...W...X...Z..."
    temp2 = "0123456789abcdef....(null)..0123456789ABCDEF"
    bortmnt = "0123456789ABCDEF....Inf.NaN.0123456789abcdef....(null)..."
    dreamsnes = "ABCDEFGHIJKLMNOPQRSTUVWXYZ.0123456789-"
    tetris = "abcdefghijklEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()"
    punch = "PORTDEV INFOENBLSTATRADRTOUTDRQCFUNCEND"
    netbsd = "$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
    
    'Replace all instances of the period (.) with a null charater (Chr$(0)) in the corresponding variables
    temp = Replace(temp, ".", Chr$(0))
    temp2 = Replace(temp2, ".", Chr$(0))
    bortmnt = Replace(bortmnt, ".", Chr$(0))

    'InStr returns the position of the variable being searched for, if it's not found, the position returns 0 and the file is scrambled
    IdentifyBin = Scrambled
    
    'progress bar code
    frmMain.Label2.Visible = True
    frmMain.Label2.Width = 0
    
    If findAndUpdate(strFile, LCase$(abc & num1)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, LCase$(abc & num0)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, UCase$(abc & num1)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, UCase$(abc & num0)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, LCase$(num1 & abc)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, LCase$(num0 & abc)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, UCase$(num1 & abc)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, UCase$(num0 & abc)) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, temp) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, temp2) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, dreamsnes) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, netbsd) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, tetris) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, punch) Then IdentifyBin = Unscrambled
    If findAndUpdate(strFile, bortmnt) Then IdentifyBin = Unscrambled
    
    'progress bar %100
    frmMain.Label2.Width = 4125

End Function

Function findAndUpdate(strFile As String, strFind As String) As Boolean

    findAndUpdate = InStr(1, strFile, strFind) > 0
    'update progress bar
    frmMain.Label2.Width = frmMain.Label2.Width + 275
    
End Function
