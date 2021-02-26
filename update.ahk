;============== CONFIG

global SCRNAME:="YDL Updater"
global EXE:=A_ScriptDir "\ydl.ahk"
global TEMP:=A_ScriptDir "\temp"

Options:=[	 {	 url: "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"
				,file: "yt-dlp.exe", name: "yt-dlp" 											}
			,{	 url: "https://codeload.github.com/pukkandan/YDL/zip/master"
				,file: TEMP "\update.zip", name: "YDL", unzip: TEMP, overwrite: True
				,run: TEMP "\YDL-master\update-run-once.ahk"										}	]






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
for _,item in Options {
	if !item.overwrite and fileExist(item.file)
		continue
	splash("Downloading " item.name)
	URLDownloadToFile, % item.url, % item.file
	if ErrorLevel {
		showErr("Downloading", item.url)
		return
	}
	splash("Downloaded " item.name)

	path:= item.temp? TEMP : A_WorkingDir
	if item.unzip {
		splash("Extracting " item.name)
		unzip(item.file, item.unzip)
		splash("Extracted " item.name)
	}

	FileDelete, % item.file
	if item.run {
		sleep 100
		splash("Postprocessing " item.name)
		run, % item.run,, UseErrorLevel
	}
}
sleep 1000
splash("Starting app")
run, % EXE


showErr(action, val) {
	msgbox, 16, % SCRNAME, Error in %action% "%val%"
	return false
}

splash(text:=""){
	SplashTextOn,,, % text
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