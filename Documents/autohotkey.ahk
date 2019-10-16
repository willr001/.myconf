#UseHook        ; force keyboard hook
#SingleInstance ; don't allow multiple instances
#NoEnv          ; don't try to expand unknown vars as env vars
#Warn           ; Enable warnings to assist with detecting common errors.
;#NoTrayIcon     ; don't show tray
SendMode Input  ; Recommended for new scripts due to its speed and reliability.

; Kill microsoft narrator
; -----------------------

#u:: Send ^+!#u


; Enter - Apps key for shitty keyboards
; -------------------------------------

#Enter:: Send {AppsKey}

; #NumpadX - Extended Media Keys
; ------------------------------

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

; alternate for inverted 10 key
#Numpad1::     Send {Browser_Back}
#Numpad2::    Send {Browser_Refresh}
#!Numpad2::    Send {Browser_Stop}
#Numpad3::     Send {Browser_Forward}
#Numpad7::     Send {Media_Prev}
#Numpad8::     Send {Media_Play_Pause}
#Numpad9::     Send {Media_Next}
; +NumpadX - Shifted numpad characters, handled by programmer Dvorak
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
+Numpad7::     Send {x}
+Numpad8::     Send {=}
+Numpad9::     Send {:}

/*
; alternate for standard 10 key
#Numpad1::     Send {Media_Prev}
#Numpad2::     Send {Media_Play_Pause}
#Numpad3::     Send {Media_Next}
#Numpad7::     Send {Browser_Back}
#Numpad8::    Send {Browser_Refresh}
#!Numpad8::    Send {Browser_Stop}
#Numpad9::     Send {Browser_Forward}
*/

;Open cmd prompt
#^d::  Run, cmd.exe, %userprofile%
#^+d:: Run *RunAs cmd.exe

