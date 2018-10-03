Attribute VB_Name = "modShellWait"
Option Explicit
Private Const STARTF_USESHOWWINDOW        As Long = &H1
Private Const NORMAL_PRIORITY_CLASS       As Long = &H20
Private Const INFINITE                    As Long = -1
Private Type STARTUPINFO
    cb                                      As Long
    lpReserved                              As String
    lpDesktop                               As String
    lpTitle                                 As String
    dwX                                     As Long
    dwY                                     As Long
    dwXSize                                 As Long
    dwYSize                                 As Long
    dwXCountChars                           As Long
    dwYCountChars                           As Long
    dwFillAttribute                         As Long
    dwFlags                                 As Long
    wShowWindow                             As Integer
    cbReserved2                             As Integer
    lpReserved2                             As Long
    hStdInput                               As Long
    hStdOutput                              As Long
    hStdError                               As Long
End Type
Private Type PROCESS_INFORMATION
    hProcess                                As Long
    hThread                                 As Long
    dwProcessID                             As Long
    dwThreadID                              As Long
End Type
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, _
                                                             ByVal dwMilliseconds As Long) As Long
Private Declare Function CreateProcessA Lib "kernel32" (ByVal lpApplicationName As Long, _
                                                        ByVal lpCommandLine As String, _
                                                        ByVal lpProcessAttributes As Long, _
                                                        ByVal lpThreadAttributes As Long, _
                                                        ByVal bInheritHandles As Long, _
                                                        ByVal dwCreationFlags As Long, _
                                                        ByVal lpEnvironment As Long, _
                                                        ByVal lpCurrentDirectory As Long, _
                                                        lpStartupInfo As STARTUPINFO, _
                                                        lpProcessInformation As PROCESS_INFORMATION) As Long
Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Public Sub ShellWait(Pathname As String, _
                     Optional ByVal WindowStyle As Long)

  
  Dim proc  As PROCESS_INFORMATION
  Dim start As STARTUPINFO
  Dim ret   As Long

    With start
        .cb = Len(start)
        If Not IsMissing(WindowStyle) Then
            .dwFlags = STARTF_USESHOWWINDOW
            .wShowWindow = WindowStyle
        End If
    End With
    ret = CreateProcessA(0&, Pathname, 0&, 0&, 1&, NORMAL_PRIORITY_CLASS, 0&, 0&, start, proc)
    ret = WaitForSingleObject(proc.hProcess, INFINITE)
    ret = CloseHandle(proc.hProcess)

End Sub
