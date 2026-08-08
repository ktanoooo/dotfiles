# 概要

Windows で Mac のキーボードを模した操作性を実現する。

キー配置の変更は **Scancode Map**（レジストリ）、修飾キーを伴う組み合わせは **AutoHotkey** が担当する。

# 仕組み

キー入力は下図の順に処理される。Scancode Map はカーネル層で働くため、AutoHotkey には**変換後のキーが届く**。

```mermaid
flowchart TD
    A[物理キー押下] --> B[キーボードクラスドライバ]
    B --> C[Raw Input / メッセージキュー]
    C --> D[低レベルキーボードフック]
    D --> E[アプリケーション]

    B -. "Scancode Map<br/>HKLM のレジストリ" .-> B
    D -. "AutoHotkey" .-> D
```

この層の違いが、そのまま役割分担になっている。

| | Scancode Map | AutoHotkey |
|---|---|---|
| 層 | カーネル（ドライバ） | ユーザーモード（フック） |
| 適用範囲 | ログイン画面・UAC・管理者権限アプリを含む全て | ログイン後の自分のセッションのみ |
| 反映 | 再起動が必要 | 即時 |
| できること | 1:1 のキー置換のみ | 修飾キー付きの組み合わせ |

# Scancode Map

`scancode_map.ps1` を管理者権限で実行し、**再起動**すると反映される。`setup.ps1` から呼ばれる。

| 元のキー | 変更後 | 目的 |
|---|---|---|
| CapsLock | F13 | AutoHotkey のトリガー用 |
| 左 Ctrl | 左 Win | 左下 3 キーを Mac の並びへ |
| 左 Win | 左 Alt | 同上 |
| 左 Alt | 左 Ctrl | 同上 |
| 無変換 | 半角/全角 | |
| 変換 | 半角/全角 | |

# AutoHotkey

`move_cursor_like_ecmas.ahk` が Emacs 風のカーソル移動を提供する。

| 打鍵（物理キー） | スクリプトの記述 | 動作 |
|---|---|---|
| CapsLock + f / b | `F13 & f` / `F13 & b` | → / ← |
| CapsLock + p / n | `F13 & p` / `F13 & n` | ↑ / ↓ |
| CapsLock + e / w | `F13 & e` / `F13 & w` | End / Home |

キーに刻印された名前とキーコードが食い違う点に注意する。Scancode Map によって、
物理キー `CapsLock` が押されるとシステムには F13 が届く。ユーザーモードに CapsLock は
到達しないため、`CapsLock & f` と書いても動かない。

F13 を選んだのは、物理キーボードに存在せず既定の動作を持たないためである。
AutoHotkey の `F13 & f` という記法は左側のキーを修飾キー扱いにし、そのキー本来の
機能を抑制する。何もしないキーに変換してから修飾キーとして使うことで、CapsLock
本来のロック機能との競合を避けている。

## スタートアップへの登録

`setup.ps1` はスクリプトをスタートアップへコピーするが、リポジトリの編集を直接反映させたい場合は symlink にする。

```
filename=move_cursor_like_ecmas.ahk
targetPath="$(ghq root)/github.com/ktanoooo/dotfiles/.windows/keyboard_manager/$filename"

startupPath='/mnt/c/Users/ktanoooo/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup'
cd $startupPath
ln -sfnv $targetPath $filename
```

# 経緯

当初は PowerToys Keyboard Manager と ChangeKey を併用していたが、Scancode Map に一本化した。

PowerToys と AutoHotkey はどちらも低レベルキーボードフックを使うため同じ層に同居する。フックチェーンの順序が不定なうえ、片方がキーを飲み込むともう片方がキーを離したイベントを受け取れず、`CapsLock` が押しっぱなしになることがあった。キー置換をカーネル層へ移したことで、この競合は原理的に起きなくなった。

Scancode Map は ChangeKey が行うレジストリ変更と同じ仕組みのため、ChangeKey も不要になった。

なお PowerToys 本体は FancyZones などで引き続き使用している。**Keyboard Manager モジュールのみ無効化**しておくと、常駐プロセスが減りフック層での競合の芽も消える。

# 参考

- [Keyboard and mouse class drivers](https://learn.microsoft.com/ja-jp/windows-hardware/drivers/hid/keyboard-and-mouse-class-drivers)
  > Scancode Map レジストリ値は、キーボード クラス ドライバーによって読み取られます
- [About Keyboard Input](https://learn.microsoft.com/ja-jp/windows/win32/inputdev/about-keyboard-input)
  > スキャン コードは、キーボード ドライバーによって仮想キー コードに変換されます

# キーボードの入力速度設定

1 打目から 2 打目の間隔を短くする。

コントロールパネル → キーボード → 表示までの待ち時間
