setlocal EnableDelayedExpansion
setlocal EnableExtensions

:: install chocolatey package manager
PowerShell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
call "%programdata%\chocolatey\bin\RefreshEnv.cmd"

:: install programs
choco upgrade -y 7zip
choco upgrade -y activeperl
choco upgrade -y activetcl
choco upgrade -y astyle
choco upgrade -y autohotkey
choco upgrade -y cccp
choco upgrade -y CMake
choco upgrade -y ConEmu
choco upgrade -y cppcheck
choco upgrade -y curl
choco upgrade -y cutepdf
choco upgrade -y deluge
choco upgrade -y doxygen.install
choco upgrade -y dropbox
choco upgrade -y Everything
choco upgrade -y Firefox
choco upgrade -y freecommander
choco upgrade -y Ghostscript.app
choco upgrade -y git
choco upgrade -y GoogleChrome
choco upgrade -y googledrive
choco upgrade -y HexEdit
choco upgrade -y irfanview
choco upgrade -y kdiff3
choco upgrade -y libreoffice
choco upgrade -y lua
choco upgrade -y mc
choco upgrade -y mingw
choco upgrade -y msys2
choco upgrade -y openvpn
choco upgrade -y paint.net
choco upgrade -y PDFXchangeEditor
choco upgrade -y PDFXChangeViewer
choco upgrade -y picasa
choco upgrade -y programmer-dvorak
choco upgrade -y putty
choco upgrade -y python2
choco upgrade -y python3
choco upgrade -y racket
choco upgrade -y reshack
choco upgrade -y ruby
choco upgrade -y steam
choco upgrade -y thunderbird
choco upgrade -y tor-browser
choco upgrade -y tortoisehg
choco upgrade -y vim
choco upgrade -y virtualbox
choco upgrade -y visualstudio2019-workload-vctools
choco upgrade -y vlc
choco upgrade -y wget
choco upgrade -y windirstat
choco upgrade -y XmlNotepad
    
call RefreshEnv

:: set numlock on with windows boot
REG ADD "HKCU\.DEFAULT\Control Panel\Keyboard"^
 /v "InitialKeyboardIndicators" /t REG_SZ /d 2 /f
:: remove all pinned items from taskbar
DEL /F /S /Q /A "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"
REG DELETE HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband /F
:: removes the onedrive icon from the nav pane
REG ADD "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"^
 /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 00000000 /f
:: removes dropbox icon from nav pane
REG ADD "HKEY_CLASSES_ROOT\CLSID\{E31EA727-12ED-4702-820C-4B6445F28E1A}"^
 /v "System.IsPinnedToNamespaceTree" /t REG_DWORD /d 00000000 /f
:: disables hibernate to save RAM_SIZE on C:
POWERCFG /h off

:: put user/bin in path
mkdir "%userprofile%\bin"
set "pathToInsert=%userprofile%\bin"
if "!path:%pathToInsert%=!" equ "%path%" (
   setx PATH "%PATH%;%pathToInsert%"
)

call refreshenv

echo "%programdata%\chocolatey\tools\shimgen.exe" -o "%%~dp0%%~n1.exe" -p "%%~f1" %%2 >"%userprofile%\bin\shim.cmd"
call shim "%programfiles%\CMake\bin\cmake.exe"
call shim "%programdata%\chocolatey\tools\7z.exe"

:: install myconf
set "myconf=.myconf"
rmdir /s /q "%userprofile%\%myconf%"
git clone --bare https://github.com/willr001/%myconf% "%userprofile%\%myconf%"
ECHO git --git-dir="%userprofile%\%myconf%" --work-tree="%userprofile%" %%* >"%userprofile%\bin\myconf.cmd"
call myconf reset --hard
call myconf config --local status.showUntrackedFiles no
mklink /J "%userprofile%\vimfiles" "%userprofile%\.vim"
mklink "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\AutoHotKey.exe" "%programfiles%\AutoHotkey\AutoHotkey.exe"

:: install ceedling
SET "olddir=%cd%"
CD "%~dp0"
WGET https://curl.haxx.se/ca/cacert.pem
MKDIR "%userprofile%\.gem"
MOVE cacert.pem "%userprofile%\.gem"
SETX SSL_CERT_FILE "%userprofile%\.gem\cacert.pem"
CD "%olddir%"
CALL refreshenv
CALL gem update --system
CALL gem install rake
CALL gem install ceedling
CALL gem update

:: install fancy terminal fonts
SET "olddir=%cd%"
CD "%~dp0"
WGET https://github.com/madmalik/mononoki/raw/master/export/mononoki.zip
WGET https://github.com/nicolalamacchia/powerline-consolas/raw/master/consola.ttf
CD "%olddir%"
ECHO EXTRACTING FONTS....
7Z e -o"%~dp0" "%~dp0mononoki.zip"
ECHO PARSING FONTS....
FOR /F %%f in ('dir /b "%~dp0*.*tf"') DO (CALL :font "%~dp0%%f")
ECHO CLEANING UP FONTS....
DEL "%~dp0mononoki*"
DEL "%~dp0consola*"

:: compile ycm
rmdir /s /q "%userprofile%\vimfiles\bundle\YouCompleteMe"
git clone --recurse-submodules https://github.com/Valloric/YouCompleteMe "%userprofile%\vimfiles\bundle\YouCompleteMe"
cd "%userprofile%\vimfiles\bundle\youcompleteme"
python install.py --clang-completer

:: install vundle.vim and plugins
mkdir "%userprofile%\vimfiles\undo"
mkdir "%userprofile%\vimfiles\backup"
mkdir "%userprofile%\vimfiles\swap"
rmdir /s /q "%userprofile%\vimfiles\bundle\Vundle.vim"
git clone https://github.com/VundleVim/Vundle.Vim "%userprofile%\vimfiles\bundle\Vundle.vim"
vim +new +PluginInstall +qall!

shutdown /r /t 30
echo "*** RESETTING COMPUTER ***"
echo "Press any key to cancel"
pause
shutdown /a

exit /b

:: sub to install a font
:font
IF "%~x1"==".otf" SET FTYPE=(OpenType)
IF "%~x1"==".ttf" SET FTYPE=(TrueType)
COPY /Y "%~f1" "%SystemRoot%\Fonts\"
REG add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"^
 /v "%~n1 %FTYPE%" /t REG_SZ /d "%~nx1" /f
EXIT /B
