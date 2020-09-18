;============== CONFIG

global SCRNAME:="YDL Updater"
global EXE:="ydl.ahk"
global TEMP:=A_ScriptDir "\temp"

Options:=[	 {	 "url": "https://codeload.github.com/pukkandan/youtube-dl/zip/my-tweaks" 		}
			,{	 "url": "https://codeload.github.com/pukkandan/YDL/zip/master"
				,"temp": True
				,"run": "YDL-master\update-run-once.ahk"									}	]






;=================== CODE
SetWorkingDir, % A_ScriptDir
#SingleInstance, force
#NoEnv
#NoTrayIcon


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
	unzip(zipfile, path)
	;msgbox % "unzipped " zipfile
	FileDelete, % zipfile
	if item.hasKey("run")
		run, % path "\" item.run,, UseErrorLevel
}

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