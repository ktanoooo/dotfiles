#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; Comments must stay ASCII. AutoHotkey v1 reads a file without a BOM as ANSI,
; and the raw UTF-8 bytes of a non-ASCII comment swallow the line that follows
; it, silently dropping whichever hotkey sits underneath.

; https://sites.google.com/site/autohotkeyjp/reference/commands/-MaxHotkeysPerInterval
#MaxHotkeysPerInterval 400

; CapsLock is remapped to right Ctrl by the Scancode Map. `>^` matches the
; right side only, so the left Ctrl (the physical Alt key) keeps driving the
; usual application shortcuts such as copy and paste.
;
; On macOS the OS intercepts Control plus f/b/p/n and passes everything else
; through as a Control chord. Keys left unbound here behave the same way, which
; is how CapsLock + g still reaches herdr as its Ctrl+G prefix.

; The shell owns its own Ctrl bindings, so the terminal is left alone. macOS
; behaves the same: the Cocoa text bindings do not apply inside a terminal.
#IfWinNotActive ahk_exe WindowsTerminal.exe

; Cursor movement
>^f::Send {Right}
>^b::Send {Left}
>^p::Send {Up}
>^n::Send {Down}

; Line start and end
>^a::Send {Home}
>^e::Send {End}
>^w::Send {Home}

; Deletion
>^d::Send {Delete}
>^h::Send {BackSpace}

#IfWinActive
