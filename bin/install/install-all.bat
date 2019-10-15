setlocal EnableDelayedExpansion

:: install chocolatey package manager
PowerShell -NoProfile -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
call %programdata%\chocolatey\bin\RefreshEnv.cmd

:: install programs
choco install -y                        ^
    git                                 ^
    curl                                ^
    mingw                               ^
    python3                             ^
    ruby                                ^
    autohotkey                          ^
    gnuwin32-coreutils.portable         ^
    vim                                 ^
    notepadplusplus                     ^
    programmer-dvorak                   ^
    vscode                              ^
    kdiff3                              ^
    visualstudio2019-workload-vctools   ^
    cmake                               ^
	firefox                             ^
    vlc
    
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

:: put user/bin in path
set "pathToInsert=%userprofile%\bin"
if "!path:%pathToInsert%=!" equ "%path%" (
   setx PATH "%PATH%;%pathToInsert%"
)
:: put cmake/bin in path
set "pathToInsert=%programfiles%\CMake\bin"
if "!path:%pathToInsert%=!" equ "%path%" (
   setx PATH "%PATH%;%pathToInsert%"
)

:: install fancy terminal fonts
if not exist "%appdata%\my-conf\powerline-fonts" (
    git clone https://github.com/powerline/fonts powerline-fonts
    PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& '.\powerline-fonts\install.ps1'"
    mkdir "%appdata%\my-conf\powerline-fonts"
    rmdir /s /q powerline-fonts
)

:: compile ycm
git clone https://github.com/Valloric/YouCompleteMe "%userprofile%\vimfiles\bundle\YouCompleteMe"
cd "%userprofile%\vimfiles\bundle\youcompleteme"
python install.py --clang-completer

:: install vundle.vim and plugins
mkdir "%userprofile%\vimfiles\undo"
mkdir "%userprofile%\vimfiles\backup"
mkdir "%userprofile%\vimfiles\swap"
git clone https://github.com/VundleVim/Vundle.Vim "%userprofile%\vimfiles\bundle\Vundle.vim"
vim +PluginInstall +qall

