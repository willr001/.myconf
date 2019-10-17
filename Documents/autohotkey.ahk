#UseHook        ; force keyboard hook
#SingleInstance ; don't allow multiple instances
#NoEnv          ; don't try to expand unknown vars as env vars
#Warn           ; Enable warnings to assist with detecting common errors.
;#NoTrayIcon     ; don't show tray
SendMode Input  ; Recommended for new scripts due to its speed and reliability.

VarSetCapacity(env_home, 500)
EnvGet, env_home, userprofile

; Kill microsoft narrator
#u:: Send ^+!#u
; #Enter - Apps key for shitty keyboards
#Enter:: Send {AppsKey}
; #^[+]d - Open cmd prompts
#^d::  Run, cmd.exe, %env_home%
#^+d:: Run *RunAs cmd.exe
; #^[+]d - Open mc
#^e:: Run, mc, %env_home%
#^+e:: Run *RunAs mc
; #Numpad - Extended Media Keys
#NumpadDiv::   Send {Browser_Search}
#NumpadMult::  Send {Browser_Favorites}
#NumpadAdd::   Send {Volume_Up}
#NumpadSub::   Send {Volume_Down}
#NumpadEnter:: Send {Volume_Mute}
#NumpadDot::   Send {Volume_Mute}
#Numpad0::     Send {Media_Play_Pause}
#Numpad4::     Send {Launch_Mail}
#Numpad5::     Run calc
#Numpad6::     Send {Launch_Media}
/*
; STANDARD TEN_KEY
#Numpad1::     Send {Media_Prev}
#Numpad2::     Send {Media_Play_Pause}
#Numpad3::     Send {Media_Next}
#Numpad7::     Send {Browser_Back}
#Numpad8::    Send {Browser_Refresh}
#!Numpad8::    Send {Browser_Stop}
#Numpad9::     Send {Browser_Forward}
*/
; INVERTED TEN-KEY
#Numpad1::     Send {Browser_Back}
#Numpad2::    Send {Browser_Refresh}
#!Numpad2::    Send {Browser_Stop}
#Numpad3::     Send {Browser_Forward}
#Numpad7::     Send {Media_Prev}
#Numpad8::     Send {Media_Play_Pause}
#Numpad9::     Send {Media_Next}
; +Numpad - Shifted numpad characters, handled by programmer Dvorak
+NumpadDiv::   Send {(}
+NumpadMult::  Send {)}
+NumpadAdd::   Send {,}
+NumpadSub::   Send {$}
+NumpadDot::   Send {;}
+Numpad0::     Send {\}
+Numpad1::     Send {a}
+Numpad2::     Send {b}
+Numpad3::     Send {c}
+Numpad4::     Send {d}
+Numpad5::     Send {e}
+Numpad6::     Send {f}
+Numpad7::     Send {=}
+Numpad8::     Send {x}
+Numpad9::     Send {:}
; ^Numpad - Numlock Off without Numlock Off
^Numpad1::   Send {vk24} ;home
^Numpad2::   Send {vk26} ;up
^Numpad3::   Send {vk21} ;pgup
^Numpad4::   Send {vk25} ;left
^Numpad6::   Send {vk27} ;right
^Numpad7::   Send {vk23} ;end
^Numpad8::   Send {vk28} ;down
^Numpad9::   Send {vk22} ;pgdn
^Numpad0::   Send {vk2d} ;insert
^NumpadDot:: Send {vk2e} ;delete
; Trying to fix the lack of numlock in programmer dvorak in windows
Numpad1::   FixTk("Numpad1",   "vk24") ;home
Numpad2::   FixTk("Numpad2",   "vk26") ;up
Numpad3::   FixTk("Numpad3",   "vk21") ;pgup
Numpad4::   FixTk("Numpad4",   "vk25") ;left
Numpad6::   FixTk("Numpad6",   "vk27") ;right
Numpad7::   FixTk("Numpad7",   "vk23") ;end
Numpad8::   FixTk("Numpad8",   "vk28") ;down
Numpad9::   FixTk("Numpad9",   "vk22") ;pgdn
Numpad0::   FixTk("Numpad0",   "vk2d") ;insert
NumpadDot:: FixTk("NumpadDot", "vk2e") ;delete
FixTk(keypress, keycode)
{
    If GetKeyState("NumLock","T") {
        Send {%keypress%}
    } else {
        Send {%keycode%}
    }
}
