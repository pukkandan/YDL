SetWorkingDir, % A_ScriptDir
#SingleInstance, force
#NoEnv

; In case the script is compiled
FileInstall, LICENSE, LICENSE, 1
FileInstall, README.md, README.md, 1
FileInstall, icon.png, icon.png
FileInstall, retry.cmd, retry.cmd
FileInstall, terminal-format.cmd, terminal-format.cmd
FileInstall, youtube-dl.cmd, youtube-dl.cmd
FileInstall, update.ahk, update.ahk
FileInstall, update-run-once.ahk, update-run-once.ahk
FileInstall, Channel.conf, Channel.conf
FileInstall, Default.conf, Default.conf
FileInstall, Folder.conf, Folder.conf
FileInstall, Playlist Reverse.conf, Playlist Reverse.conf
FileInstall, Playlist.conf, Playlist.conf
;=================================

Menu, Tray, Icon, icon.png
Menu, Tray, Tip, % SCRNAME
#NoTrayIcon

EnvSet, ydl_dir, % A_ScriptDir
global SCRNAME:="Youtube-Dl Launcher"

global Path	:= getOpt("path", A_WorkingDir "\Download")
	 , Opts	:= getOpt("opts")
	 , Prof	:= getOpt("prof", "<None>")
	 , Sign	:= getOpt("sign", ">=")
	 , Res	:= getOpt("res", "720")
	 , Log	:= getOpt("log", False, "Hidden")
	 , Def	:= getOpt("opts",, "Hidden")
	 , URL	:= ""

Gui, Margin, 10, 10

Gui, Add, Text, W50 Right ym+5, URLs
Gui, Add, Edit, vURL x+m W400 yp-5 R5

Gui, Add, Text, W50 Right xm y+15, Options
Gui, Add, Edit, vOpts x+m W400 yp-5 R2, % Opts

Gui, Add, Text, W50 Right y+15 xm, Path
Gui, Add, Edit, vPath x+m W380 yp-5, % Path
Gui, Add, Button, gPathClicked yp-1 x+0 W20, ...

Gui, Add, Text, xm y+15 W50 Right, Resolution
Gui, Add, DropDownList, vSign x+m yp-5 W40 section, >=|<=
guiSet("Sign", Sign, "ChooseString")
Gui, Add, ComboBox, vRes gResChanged x+m yp W70, Audio|Smallest|144|360|480|720|1080|2160|Largest
guiSet("Res", Res)
ResChanged()

Gui, Add, Text, x+m yp+5 W50 Right, Profile
Gui, Add, ComboBox, vProf x+m yp-5 W100, % createProfList()
guiSet("Prof", Prof)

Gui, Add, Button, Default gDownload yp-1 xs+330 W70, Download

Gui, Show,, % SCRNAME
Return



GuiClose:
ExitApp




Download(){
	Gui, +OwnDialogs
	Gui, Submit, NoHide
	if !validate()
		return

	urls 	:= "-- """ RegexReplace(url,"S)\s+", """ """) """"
	getAud 	:= Res="audio"? "-x -f ba" : ""
	prof 	:= Prof="<None>"? "" : "--config-location """ Prof ".conf"""

	reverseSort := Sign==">=" || Res="smallest"
	resolution 	:= isInteger(Res)? ":" Res :""
	format 		:= "-S """ (reverseSort?"+":"") "res" resolution """"
	homePath	:= "-P ""home:" Path """"

	EnvSet, ydl_home, % Path
	cmd := "retry.cmd yt-dlp " homePath " " prof " " format " " getAud " " Def " " Opts " " urls
	if Log
		log(cmd)
	run, % cmd
}

validate(){
	if !URL{
		msgbox, % 48+4+256, % SCRNAME, No URL given. `nAre you sure you want to continue?
		IfMsgBox, No
			return False
	}

	if (isInteger(Res) && Res<=0) || (!isInteger(Res) && !inStr("audio`nsmallest`nlargest", Res))
		return showErr("Resolution", Res)

	Path:=RegExReplace(Path, "\\$")
	FileCreateDir, % Path
	if !InStr(FileExist(Path), "D")
		return showErr("Path", Path)

	if (Prof!="<None>" && !FileExist(Prof ".conf"))
		return showErr("Profile", Prof)

	saveOpt("path", Path)
	saveOpt("profile", Prof)
	saveOpt("opts", Opts)
	saveOpt("sign", Sign)
	saveOpt("res", Res)
	return true
}

PathClicked(){
	Gui, +OwnDialogs
	GuiControlGet, current,, Path
	FileSelectFolder, folder, % current, 3
	guiSet("Path", folder? folder :current)
}

ResChanged(){
	GuiControlGet, current,, Res
	if isInteger(current)
		GuiControl, Enable, Sign
	else
		GuiControl, Disable, Sign
}

createProfList() {
	ret:="<None>"
	Loop, Files, *.conf
	{
		if (A_LoopFileName!="yt-dlp.conf")
			ret.="|" subStr(A_LoopFileName, 1, -5)
	}
	return ret
}



log(cmd){
	FormatTime, timestamp,, yyyy-MM-dd HH:mm:ss
	FileAppend, % "`n[" timestamp "]`t" cmd, % A_ScriptFullPath ".log"
}

showErr(key, val) {
	msgbox, 16, % SCRNAME, "%val%" is not a valid %key%
	return false
}

saveOpt(key, val, sect:="Options") {
	IniWrite, % val, % A_ScriptFullPath ".ini", % sect, % key
}

getOpt(key, def:=" ", sect:="Options") {
	IniRead, out, % A_ScriptFullPath ".ini", % sect, % key, % def
	return out
}

guiSet(key, val, type="Text") {
	GuiControl, % type, % key, % val
}

isInteger(x) {
	if x is Integer
		return True
	return False
}