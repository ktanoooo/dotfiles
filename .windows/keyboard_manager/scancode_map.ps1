$hexified = "00,00,00,00,00,00,00,00,07,00,00,00,64,00,3a,00,5b,e0,1d,00,38,00,5b,e0,1d,00,38,00,29,00,7b,00,29,00,79,00,00,00,00,00".Split(',') | % { "0x$_"};
$kbLayout = 'HKLM:\System\CurrentControlSet\Control\Keyboard Layout';
New-ItemProperty -Path $kbLayout -Name "Scancode Map" -PropertyType Binary -Value ([byte[]]$hexified);

# https://learn.microsoft.com/ja-jp/windows-hardware/drivers/hid/keyboard-and-mouse-class-drivers
# scancode
# https://learn.microsoft.com/ja-jp/windows/win32/inputdev/about-keyboard-input
#
# 00,00,00,00  // ヘッダー: バージョン。 すべてのゼロに設定。
# 00,00,00,00  // ヘッダー: フラグ。 すべてのゼロに設定。
# 07,00,00,00  // マップ内の 7 つのエントリ (null エントリを含む)。
# 64,00,3a,00  // CAPS LOCK -> F13
# 5b,e0,1d,00  // LeftCtrl -> LeftGUI(win)
# 38,00,5b,e0  // LeftGUI(win) -> LeftAlt
# 1d,00,38,00  // LeftAlt -> LeftCtrl
# 29,00,7b,00  // キーボード インターナショナル 5(無変換) -> キーボード グレーブ アクセントとチルダ(全角/半角)
# 29,00,79,00  // キーボード インターナショナル 4(変換) -> キーボード グレーブ アクセントとチルダ(全角/半角)
# 00,00,00,00  // Null 終端記号
