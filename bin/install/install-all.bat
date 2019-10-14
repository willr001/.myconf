setlocal EnableDelayedExpansion

:: install chocolatey package manager
PowerShell -NoProfile -Command ^
    "Set-ExecutionPolicy Bypass -Scope Process -Force; ^
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
call %programdata%\chocolatey\bin\RefreshEnv.cmd

:: install programs
choco install -y ^
    git ^
    curl ^
    mingw ^
    msys2 ^
    llvm ^
    python3 ^
    ruby ^
    autohotkey ^
    vim ^
    notepadplusplus ^
    programmer-dvorak ^
    vscode ^
    kdiff3 ^
    visualstudio2019-workload-vctools ^
    cmake ^
	firefox
    
call RefreshEnv

:: install myconf
set myconfpath="%userprofile%\.myconf"
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

:: install vundle.vim and plugins
git clone https://github.com/VundleVim/Vundle.Vim "%userprofile%\vimfiles\bundle\Vundle.vim"
vim +PluginInstall +qall

:: compile ycm
cd %userprofile%\vimfiles\bundle\youcompleteme
python install.py --clang-completer

:: done
pause
exit /b
