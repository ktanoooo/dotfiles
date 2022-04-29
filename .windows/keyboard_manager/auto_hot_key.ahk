#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; 連打エラーを防ぐ
; https://sites.google.com/site/autohotkeyjp/reference/commands/-MaxHotkeysPerInterval
#MaxHotkeysPerInterval 1000

; CapsLockとAppsKey入れ替え
; powertoysに置き換え
; vkF0::F13
; F13::vkF0

; mac風に入れ替え
; powertoysに置き換え
; LCtrl::LWin
; LWin::LAlt
; LAlt::LCtrl

; Ecmas風矢印設定
; 次の改行大事

F13 & f::Right
F13 & b::Left
F13 & p::Up
F13 & n::Down

F13 & e::End
F13 & w::Home
