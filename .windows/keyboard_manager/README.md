# 概要

Windows で Mac のキーボードを模した操作性を実現する。

# PowerToys

PowerToys では`CapsLock/英数`キーを除くキー配置の変更を行う。
`CapsLock/英数`キーは後述する`ChangeKey`を使ってレジストリの変更を行うことで実現する

# AutoHotKey

`CapsLock/英数 + f, b, p, n, e, w`でカーソル移動を行うためのショートカットを登録する。

## symbolc link for startup

```
filename=move_cursor_like_ecmas.ahk
targetPath="$(ghq root)/github.com/ktanoooo/dotfiles/.windows/keyboard_manager/$filename"

startupPath='/mnt/c/Users/ktanoooo/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'
cd $startupPath
ln -sfnv $targetPath $filename
```

# ChangeKey

`CapsLock/英数 + f, b, p, n, e, w`を割り当てるために、ChangeKey を使って`CapsLock/英数`を`F13`に割り当てて AutoHotKey でショートカット登録することで実現する。
(PowerToys + AutoHotKey の組み合わせや AutoHotKey のみの環境では、場合によっては`CapsLock/英数`キーが押しっぱなしになったりして実現できないケースがある。)

## Download ChangeKey v1.5.0

https://forest.watch.impress.co.jp/library/software/changekey/download_10668.html

ダウンロード + 解凍したら管理者として実行して `CapsLock`をクリック次の画面で左上の`Scan Code`を選択して`0x0064`(F13 に該当)を入力。
完了したら`登録タブ`から`現在の設定内容で登録します(R)`をクリックして再起動で終了。

# キーボードの入力速度設定

1 打目から 2 打目の間隔を短くする

コントロールパネル -> キーボード -> 表示までの待ち時間

```

```
