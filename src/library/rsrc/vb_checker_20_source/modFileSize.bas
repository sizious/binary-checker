Attribute VB_Name = "modFileSize"
Public Function FileSize(sFile As String) As String
Dim sSize As Single

On Error GoTo Error_Handler

    If Len(Dir$(sFile$)) Then
        Open sFile$ For Binary As #1
        sSize = LOF(1)
        Close #1

        Select Case sSize
            Case 0 To 1023
            FileSize = sSize & " Bytes"
            Case 1024 To 1048575
            FileSize = Format(sSize / 1024#, "###0.00") & " KB"
            Case 1024# ^ 2 To 1043741824
            FileSize = Format(sSize / 1024# ^ 2, "###0.00") & " MB"
            Case Is > 1043741824
            FileSize = Format(sSize / 1024# ^ 3, "###0.00") & " GB"
        End Select

    End If
    
    Exit Function

Error_Handler:
    MsgBox "Unknown error: " & Err.Number & vbCrLf & Err.Description & vbCrLf & "In: FileSize(sFile as String)", vbExclamation, "Unknown"
    
End Function
