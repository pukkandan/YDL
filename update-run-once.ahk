SetWorkingDir, % A_ScriptDir
#SingleInstance, Ignore
#NoEnv
#NoTrayIcon

FileMove, *, %A_WorkingDir%\..\..\, True
FileRemoveDir, % A_WorkingDir, False
