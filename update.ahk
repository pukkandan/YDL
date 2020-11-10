;============== CONFIG

global SCRNAME:="YDL Updater"
global EXE:="ydl.ahk"
global TEMP:=A_ScriptDir "\temp"

Options:=[	 {	 "url": "https://codeload.github.com/pukkandan/YDL/zip/master"
				,"temp": True, unzip:True
				,"run": "YDL-master\update-run-once.ahk"										}
			,{	 "url": "https://codeload.github.com/pukkandan/yt-dlc/zip/master", unzip:True 	}	]






;=================== CODE
FileInstall, icon.png, icon.png
SetWorkingDir, % A_ScriptDir
#SingleInstance, force
#NoEnv

if FileExist("icon.png")
	Menu, Tray, Icon, icon.png
Menu, Tray, Tip, % SCRNAME
;#NoTrayIcon


FileCreateDir, % TEMP
zipfile:=TEMP "\update.zip"
for _,item in Options {
	URLDownloadToFile, % item.url, % zipfile
	if ErrorLevel {
		showErr("Downloading", item.url)
		return
	}
	;msgbox % "downloaded " item.url
	
	path:= item.temp? TEMP : A_WorkingDir
	if item.unzip
		unzip(zipfile, path)
	;msgbox % "unzipped " zipfile

	FileDelete, % zipfile
	if item.hasKey("run") {
		sleep 100
		run, % path "\" item.run,, UseErrorLevel
	}
}
sleep 100
run, % EXE


showErr(action, val) {
	msgbox, 16, % SCRNAME, Error in %action% "%val%"
	return false
}






;================= LIB

; https://github.com/shajul/Autohotkey/blob/master/COM/Zip Unzip Natively.ahk
unzip(zipFullPath, folderFullPath) {
	folderFullPath:=RegExReplace(folderFullPath, "\\$")
	FileCreateDir, % folderFullPath

	SA:=ComObjCreate("Shell.Application")
	pzip:=SA.Namespace(zipFullPath)
	pfol:=SA.Namespace(folderFullPath)
	zippedItems:=pzip.items().count
	pfol.CopyHere(pzip.items(), 4|16 )

	while (pfol.items().count<zippedItems) { ; Wait for completion
		;tooltip, pfol.items().count
		sleep 100
	}
	return zippedItems
}