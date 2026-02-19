---
name: commit
description: "変更内容を確認し、適切なコミットメッセージを生成してコミットする。「コミットして」「変更をコミット」などの依頼時に使用。"
argument-hint: "[single] [cc] [ja] [scope]"
disable-model-invocation: false
---

# コミットスキル

現在の変更内容を確認し、コミットメッセージを生成してコミットする。
引数により形式・言語・粒度を切り替え可能。

## 引数パース

`$ARGUMENTS` を以下のルールで解釈する:

- `single` が含まれる → 全変更を1コミットにまとめる
- `cc` が含まれる → Conventional Commits 形式を使用
- `ja` が含まれる → 日本語でメッセージを記述
- 上記以外の単語 → scope として扱う（Conventional Commits 形式時のみ有効）
- 引数なし → Imperative style、英語、自動分割（デフォルト）

### 使用例

| コマンド | 形式 | 言語 | 粒度 | 例 |
|----------|------|------|------|----|
| `/commit` | Imperative | 英語 | 自動分割 | `Add user validation` |
| `/commit single` | Imperative | 英語 | 1コミット | `Add user validation` |
| `/commit cc` | Conventional Commits | 英語 | 自動分割 | `feat: add user validation` |
| `/commit ja` | Imperative | 日本語 | 自動分割 | `ユーザーバリデーションを追加` |
| `/commit cc ja` | Conventional Commits | 日本語 | 自動分割 | `feat: ユーザーバリデーションを追加` |
| `/commit cc auth` | Conventional Commits | 英語 | 自動分割 | `feat(auth): add user validation` |
| `/commit single cc ja` | Conventional Commits | 日本語 | 1コミット | `feat: ユーザーバリデーションを追加` |

## コミット粒度

### デフォルト（自動分割）

変更内容を分析し、目的が異なる変更群を検出した場合は複数コミットに分割する。

- ファイル単位・変更目的（機能追加、バグ修正、リファクタリング等）で分割を判断
- 分割案をユーザーに提示し、承認を得てからコミットを実行
- すべての変更が同一目的であれば1コミットにまとめる

### `single` 指定時

全変更を1コミットにまとめる。分割判断をスキップする。

## 実行手順

1. `git status` と `git diff --staged` で変更内容を確認（staged がなければ `git diff` も確認）
2. 変更の種類と範囲を分析
3. `single` 指定でない場合、目的が異なる変更群を識別し分割案を作成
4. 分割案またはコミット内容をユーザーに提示して確認
5. 承認後、引数に基づいた形式でコミットを実行

## メッセージ形式

### タイトル（1行目）

- 英語: 50文字以内
- 日本語: 25文字以内（全角文字の表示幅を考慮）
- CC 形式の場合は type/scope を含めた文字数
- 末尾にピリオドを付けない

### 本文（3行目以降） - 任意

タイトルだけで変更内容が十分に伝わる場合は本文を省略する。
以下のような場合にのみ本文を追加する:

- 変更の「なぜ（why）」がタイトルから読み取れない場合
- 複数の関連する変更を1コミットにまとめた場合
- 破壊的変更や注意が必要な副作用がある場合
- リファクタリングで設計判断の理由を残したい場合

本文のルール:

- タイトルと本文の間に空行を1行入れる
- 英語: 72文字で折り返す / 日本語: 36文字で折り返す
- 「何を変えたか」ではなく「なぜ変えたか」を書く
- 箇条書き可（`-` を使用）

### デフォルト: 英語・Imperative style

```
<verb> <description>

[optional body]
```

- 動詞で始める: `Add`, `Fix`, `Update`, `Remove`, `Refactor` など

### Conventional Commits 形式（`cc` 指定時）

```
type(scope): description

[optional body]
```

#### type

| type | 説明 |
|------|------|
| feat | 新機能 |
| fix | バグ修正 |
| docs | ドキュメントのみの変更 |
| style | コードの意味に影響しない変更（空白、フォーマット等） |
| refactor | バグ修正や機能追加ではないコード変更 |
| perf | パフォーマンス改善 |
| test | テストの追加・修正 |
| chore | ビルドプロセスや補助ツールの変更 |

#### scope

引数で scope が指定された場合のみ付与。例: `auth`, `api`, `ui`

## 注意事項

- 機密情報を含むファイル（`.env` など）は除外
- `--amend` は明示的に指示された場合のみ使用
- push は自動で行わない（明示的に指示された場合のみ）
- Co-Authored-By 行を追加しない
