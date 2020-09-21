SetWorkingDir, % A_ScriptDir
#SingleInstance, Ignore
#NoEnv

#NoTrayIcon

baseDir:= A_WorkingDir "\..\..\"

FileMove, *, % baseDir, True
FileRemoveDir, % A_WorkingDir, False

;Remove old fork of youtube-dl
FileRemoveDir, % baseDir "youtube-dl-my-tweaks", True