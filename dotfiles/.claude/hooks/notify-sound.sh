#!/bin/bash
# Speak notification message (cross-platform)
# Usage: notify-sound.sh [permission|complete]

SOUND_TYPE="${1:-complete}"

if [ "$SOUND_TYPE" = "permission" ]; then
  MSG_JA="確認してください"
  MSG_EN="Your attention is needed"
elif [ "$SOUND_TYPE" = "complete" ]; then
  MSG_JA="終わりました"
  MSG_EN="Task complete"
else
  exit 0
fi

case "$(uname -s)" in
  Darwin)
    say -v Kyoko "$MSG_JA"
    ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null && command -v powershell.exe &>/dev/null; then
      powershell.exe -c "Start-Sleep -Seconds 3; Add-Type -AssemblyName System.Speech; \$s = New-Object System.Speech.Synthesis.SpeechSynthesizer; \$s.SelectVoiceByHints([System.Globalization.CultureInfo]::GetCultureInfo('ja-JP')); \$s.Speak('$MSG_JA')" &
    elif command -v espeak &>/dev/null; then
      espeak "$MSG_EN" 2>/dev/null &
    elif command -v spd-say &>/dev/null; then
      spd-say "$MSG_EN" 2>/dev/null &
    fi
    ;;
  MINGW*|MSYS*|CYGWIN*)
    powershell.exe -c "Add-Type -AssemblyName System.Speech; (New-Object System.Speech.Synthesis.SpeechSynthesizer).Speak('$MSG_EN')" &
    ;;
esac
