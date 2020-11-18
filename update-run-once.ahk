SetWorkingDir, % A_ScriptDir
#SingleInstance, Ignore
#NoEnv

#NoTrayIcon

baseDir:= A_WorkingDir "\..\..\"

FileMove, *, % baseDir, True
FileRemoveDir, % A_WorkingDir, False


;Remove folders created by older versions
FileRemoveDir, % baseDir "youtube-dl-my-tweaks", True
FileRemoveDir, % baseDir "youtube-dl-master", True
FileRemoveDir, % baseDir "yt-dlc-master", True