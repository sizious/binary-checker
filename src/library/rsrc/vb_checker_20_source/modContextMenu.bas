Attribute VB_Name = "modContextMenu"
Option Explicit

Public Sub ContextMenu(ByVal EXT As String, ByVal Command As String)
Dim b As Object

On Error Resume Next
    
    Set b = CreateObject("wscript.shell")
    With b
        .regwrite "HKEY_CLASSES_ROOT\." & EXT & "\shell\" & Command, Command
        .regwrite "HKEY_CLASSES_ROOT\." & EXT & "\shell\" & Command & "\command\", App.Path & "\" & App.EXEName & ".exe %1"
    End With

On Error GoTo 0

End Sub


