VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "1st_read.bin file checker 2.0"
   ClientHeight    =   2820
   ClientLeft      =   45
   ClientTop       =   615
   ClientWidth     =   4680
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   2820
   ScaleWidth      =   4680
   StartUpPosition =   2  'CenterScreen
   Begin VB.TextBox txtFilename 
      Height          =   285
      Left            =   240
      Locked          =   -1  'True
      TabIndex        =   7
      Text            =   "Please select a bin to scan..."
      Top             =   360
      Width           =   2775
   End
   Begin VB.TextBox txtFilesize 
      Enabled         =   0   'False
      Height          =   285
      Left            =   240
      TabIndex        =   5
      Text            =   "Please select a bin to scan..."
      Top             =   1800
      Width           =   2775
   End
   Begin VB.TextBox txtIdentify 
      Enabled         =   0   'False
      Height          =   285
      Left            =   240
      TabIndex        =   2
      Text            =   "Please select a bin to scan..."
      Top             =   1080
      Width           =   2775
   End
   Begin VB.CommandButton cmdConvert 
      Caption         =   "&Convert"
      Height          =   375
      Left            =   3360
      TabIndex        =   1
      Top             =   1080
      Width           =   1095
   End
   Begin VB.CommandButton cmdBrowse 
      Caption         =   "&Browse"
      Height          =   375
      Left            =   3360
      TabIndex        =   0
      Top             =   360
      Width           =   1095
   End
   Begin VB.Label Label2 
      BackColor       =   &H80000001&
      Height          =   255
      Left            =   280
      TabIndex        =   9
      Top             =   2340
      Width           =   4125
   End
   Begin VB.Label Label1 
      BorderStyle     =   1  'Fixed Single
      Height          =   375
      Left            =   240
      TabIndex        =   8
      Top             =   2280
      Width           =   4215
   End
   Begin VB.Label lblFilename 
      Caption         =   "File name"
      Height          =   255
      Left            =   240
      TabIndex        =   6
      Top             =   120
      Width           =   1815
   End
   Begin VB.Label lblFileszie 
      Caption         =   "File size"
      Height          =   255
      Left            =   240
      TabIndex        =   4
      Top             =   1560
      Width           =   1575
   End
   Begin VB.Label lblIdentify 
      Caption         =   "Type of bin"
      Height          =   255
      Left            =   240
      TabIndex        =   3
      Top             =   840
      Width           =   1815
   End
   Begin VB.Menu mnuFile 
      Caption         =   "&File"
      Begin VB.Menu mnuFileOpen 
         Caption         =   "&Open"
         Shortcut        =   ^O
      End
      Begin VB.Menu mnuFileExit 
         Caption         =   "E&xit"
      End
   End
   Begin VB.Menu mnuOptions 
      Caption         =   "&Options"
      Begin VB.Menu mnuOptionsRightClick 
         Caption         =   "&Integrate into right-click menu"
      End
   End
   Begin VB.Menu mnuHelp 
      Caption         =   "&Help"
      Begin VB.Menu mnuHelpAbout 
         Caption         =   "&About"
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long
Private Type OPENFILENAME
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    lpstrFilter As String
    lpstrCustomFilter As String
    nMaxCustFilter As Long
    nFilterIndex As Long
    lpstrFile As String
    nMaxFile As Long
    lpstrFileTitle As String
    nMaxFileTitle As Long
    lpstrInitialDir As String
    lpstrTitle As String
    flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    lpstrDefExt As String
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type

Public Parameters As Boolean

Private Sub Form_Load()

On Error GoTo Error_Handler

    If ItemExist(App.Path & "\tools\dcscram.exe") = False Or _
       ItemExist(App.Path & "\tools\sh-elf-objcopy.exe") = False Or _
       ItemExist(App.Path & "\tools\cygwin1.dll") = False Then
        cmdConvert.Enabled = False
    End If
    
    If Command$ <> "" Then
        Parameters = True
        Identify_Code
        If txtIdentify.Text = "ELF file, please convert." Then
            Convert
            End
        End If
    Else
        Parameters = False
        Label2.Visible = False
    End If
    
    Exit Sub
    
Error_Handler:
    MsgBox "Unknown error: " & Err.Number & vbCrLf & Err.Description & vbCrLf & "In: Form_Load()", vbExclamation, "Unknown"

End Sub

Private Sub cmdBrowse_Click()

    Identify_Code

End Sub

Private Sub mnuFileOpen_Click()

    Identify_Code

End Sub

Private Sub cmdConvert_Click()

    Convert
    
End Sub

Private Sub mnuOptionsRightClick_Click()

On Error GoTo Error_Handler

    If MsgBox("Are you sure you want to do right-click integration?", vbYesNo, "Continue?") = vbYes Then
        ContextMenu "bin", "Scan Dreamcast binary"
        ContextMenu "elf", "Convert to Dreamcast binary"
        MsgBox "Right-click menus were successfully added to the registry.", vbInformation, "Complete"
    End If
    
    Exit Sub
    
Error_Handler:
    MsgBox "Unknown error: " & Err.Number & vbCrLf & Err.Description & vbCrLf & "In: mnuOptionsRightClick_Click()", vbExclamation, "Unknown"

End Sub

Private Sub mnuHelpAbout_Click()

    MsgBox "1st_read.bin file checker is capable of identifying" & vbNewLine & _
           "if a binary is scrambled or unscrambled. Extra features" & vbNewLine & _
           "include scrambling / unscrambling the loaded BIN," & vbNewLine & _
           "converting ELF files into BIN files, and right-click" & vbNewLine & _
           "shell integration." & vbNewLine & vbNewLine & _
           "Created by LyingWake." & vbNewLine & _
           "LyingWake@gmail.com" & vbNewLine & _
           "www.consolevision.com/members/fackue/" & vbNewLine & vbNewLine & _
           "Thanks for downloading. I hope you find it useful.", , "About"

End Sub

Private Sub mnuFileExit_Click()

    Unload Me

End Sub

'***************************************************
'*                                                 *
'*                USED FUNCTIONS                   *
'*                                                 *
'***************************************************

Sub Identify_Code()
Dim OFName As OPENFILENAME
Dim sFile As String

On Error GoTo Error_Handler
    
    If Parameters = False Then
    'a file wasn't loaded when program opened
        'open file dialog
        OFName.lStructSize = Len(OFName)
        OFName.hwndOwner = Me.hWnd
        OFName.hInstance = App.hInstance
        OFName.lpstrFilter = "Main Dreamcast binary (*.bin; *.elf)" + Chr$(0) + "*.bin; *.elf" + Chr$(0) + "All Files (*.*)" + Chr$(0) + "*.*" + Chr$(0)
        OFName.lpstrFile = Space$(254)
        OFName.nMaxFile = 255
        OFName.lpstrFileTitle = Space$(254)
        OFName.nMaxFileTitle = 255
        OFName.lpstrTitle = "Open a binary file..."
        OFName.flags = 0
    
        'put selected file in a textbox
        If GetOpenFileName(OFName) Then
            txtFilename.Text = Trim$(OFName.lpstrFile)
        Else
            Exit Sub
        End If
    Else
    'a file was loaded when program opened
        'place loaded filename in a textbox
        txtFilename.Text = Command$
    End If
    
    'if it's a elf file
    If UCase$(Right(txtFilename.Text, 4)) = ".ELF" Then
        txtIdentify.Text = "ELF file, please convert."
        txtFilesize.Text = FileSize(txtFilename.Text)
        Label2.Visible = True
        Label2.Width = 4125
        Exit Sub
    End If
    
    'if it's a bin file
    If IdentifyBin(txtFilename.Text) = Unscrambled Then
        txtIdentify.Text = "UNSCRAMBLED"
        txtFilesize.Text = FileSize(txtFilename.Text)
    Else
        txtIdentify.Text = "SCRAMBLED"
        txtFilesize.Text = FileSize(txtFilename.Text)
    End If
    
    Parameters = False
    
    Exit Sub
    
Error_Handler:
    MsgBox "Unknown error: " & Err.Number & vbCrLf & Err.Description & vbCrLf & "In: Identify_Code()", vbExclamation, "Unknown"
    
End Sub

Sub Convert()

On Error GoTo Error_Handler

    Select Case txtIdentify.Text
        'no file is selected
        Case "Please select a bin to scan..."
            MsgBox "Please select a bin to scan before trying to convert.", vbCritical, "No file opened"
        
        'convert to scrambled
        Case "UNSCRAMBLED"
            ShellWait ("tools\dcscram.exe """ & txtFilename.Text & """ """ & JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & "_scrambled.bin""")
            MsgBox NoExt(txtFilename.Text) & "_scrambled.bin was successfully created.", vbInformation, "Complete"
            
        'convert to unscrambled
        Case "SCRAMBLED"
            ShellWait ("tools\dcscram.exe -d """ & txtFilename.Text & """ """ & JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & "_unscrambled.bin""")
            MsgBox NoExt(txtFilename.Text) & "_unscrambled.bin was successfully created.", vbInformation, "Complete"
        
        'convert from an elf
        Case "ELF file, please convert."
            Select Case MsgBox("Do you want a scrambled BIN? By default, ELF files" & vbCrLf & "are converted to unscrambled BINs.", vbQuestion + vbYesNoCancel, "Question")
                Case vbYes
                'convert elf to scrambled bin
                    ShellWait ("tools\sh-elf-objcopy.exe -O binary -R .stack """ & txtFilename.Text & """ """ & JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & ".bin""")
                    ShellWait ("tools\dcscram.exe """ & JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & ".bin"" """ & JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & "_scrambled.bin""")
                    Kill JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & ".bin"
                    MsgBox NoExt(txtFilename.Text) & "_scrambled.bin was successfully created.", vbInformation, "Complete"
                Case vbNo
                'convert elf to unscrambled bin
                    ShellWait ("tools\sh-elf-objcopy.exe -O binary -R .stack """ & txtFilename.Text & """ """ & JustPath(txtFilename.Text) & "\" & NoExt(txtFilename.Text) & "_unscrambled.bin""")
                    MsgBox NoExt(txtFilename.Text) & "_unscrambled.bin was successfully created.", vbInformation, "Complete"
                Case vbCancel
                    Exit Sub
            End Select
    End Select
    
    Exit Sub
    
Error_Handler:
    MsgBox "Unknown error: " & Err.Number & vbCrLf & Err.Description & vbCrLf & "In: Convert()", vbExclamation, "Unknown"

End Sub

Private Function NoExt(sFile As String) As String

    NoExt = Split(Mid(sFile, InStrRev(sFile, "\") + 1, Len(sFile)), ".")(0)
    
End Function

Private Function JustPath(ByVal filepath As String) As String

    JustPath = Mid$(filepath, 1, InStrRev(filepath, "\", , vbTextCompare))

End Function
