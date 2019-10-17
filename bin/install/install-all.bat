setlocal EnableDelayedExpansion

:: install chocolatey package manager
PowerShell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
call "%programdata%\chocolatey\bin\RefreshEnv.cmd"

:: install programs
choco upgrade -y ^
    7zip ^
    activeperl ^
    activetcl ^
    astyle ^
    autohotkey ^
    cccp ^
    CMake ^
    ConEmu ^
    cppcheck ^
    curl ^
    cutepdf ^
    deluge ^
    doxygen ^
    dropbox ^
    Everything ^
    Firefox ^
    freecommander ^
    Ghostscript.app ^
    git ^
    GoogleChrome ^
    googledrive ^
    HexEdit ^
    irfanview ^
    kdiff3 ^
    libreoffice ^
    lua ^
    mc ^
    mingw ^
    openvpn ^
    paint.net ^
    PDFXchangeEditor ^
    PDFXChangeViewer ^
    picasa ^
    programmer-dvorak ^
    putty ^
    python2 ^
    python3 ^
    racket ^
    reshack ^
    ruby ^
    steam ^
    thunderbird ^
    tor-browser ^
    tortoisehg ^
    vim ^
    virtualbox ^
    visualstudio2019-workload-vctools ^
    vlc ^
    wget ^
    windirstat ^
    XmlNotepad
    
call RefreshEnv

:: install myconf
set myconfpath="%userprofile%\.myconf"
rmdir /s /q temp-myconf
rmdir /s /q %myconfpath%
git clone https://github.com/willr001/.myconf temp-myconf
xcopy temp-myconf\.git %myconfpath% /E /H /I /K
rmdir /s /q temp-myconf
git --git-dir=%myconfpath% --work-tree="%userprofile%" reset --hard
mklink /J "%userprofile%\vimfiles" "%userprofile%\.vim"
mklink "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\AutoHotKey.exe" "%programfiles%\AutoHotkey\AutoHotkey.exe"

:: put user/bin in path
set "pathToInsert=%userprofile%\bin"
if "!path:%pathToInsert%=!" equ "%path%" (
   setx PATH "%PATH%;%pathToInsert%"
)

:: put chocolatey tools in path
set "pathToInsert=%programdata%\chocolatey\tools"
if "!path:%pathToInsert%=!" equ "%path%" (
   setx PATH "%PATH%;%pathToInsert%"
)

call refreshenv

SHIMGEN -o "%userprofile%\bin\reshack.exe" -p "%programfiles(x86)%\Resource Hacker\ResourceHacker.exe" --gui
SHIMGEN -o "%userprofile%\bin\cmake.exe"   -p "%programfiles%\CMake\bin\cmake.exe"

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
git clone https://github.com/Valloric/YouCompleteMe "%userprofile%\vimfiles\bundle\YouCompleteMe"
cd "%userprofile%\vimfiles\bundle\youcompleteme"
python install.py --clang-completer

:: install vundle.vim and plugins
mkdir "%userprofile%\vimfiles\undo"
mkdir "%userprofile%\vimfiles\backup"
mkdir "%userprofile%\vimfiles\swap"
rmdir /s /q "%userprofile%\vimfiles\bundle\Vundle.vim"
git clone https://github.com/VundleVim/Vundle.Vim "%userprofile%\vimfiles\bundle\Vundle.vim"
vim +PluginInstall +qall
exit /b

:: sub to install a font
:font
IF "%~x1"==".otf" SET FTYPE=(OpenType)
IF "%~x1"==".ttf" SET FTYPE=(TrueType)
COPY /Y "%~f1" "%SystemRoot%\Fonts\"
REG add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"^
 /v "%~n1 %FTYPE%" /t REG_SZ /d "%~nx1" /f
EXIT /B
