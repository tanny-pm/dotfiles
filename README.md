# dotfiles

macOS の個人設定を [GNU Stow](https://www.gnu.org/software/stow/) で管理するリポジトリ。

## 構成

各ディレクトリが stow の「パッケージ」で、中身はホーム（`~`）のミラーになっている。

| パッケージ | 内容 |
| --- | --- |
| `zsh` | `.zshrc` `.zshenv` `.zprofile` `.profile` |
| `git` | `.config/git/ignore`（グローバル gitignore） |
| `starship` | `.config/starship.toml`（プロンプト） |
| `zed` | `.config/zed/`（settings, keymap） |
| `claude` | `.claude/`（settings, statusline, hooks, skills） |
| `Brewfile` | Homebrew で入れているツール一覧 |

## セットアップ（新しい Mac で）

```sh
git clone git@github.com:tanny-pm/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
make install     # Brewfile 一括導入 + stow でシンボリックリンク作成
```

個別に実行する場合:

```sh
make brew        # Brewfile からツールを一括インストール
make stow        # ホームにシンボリックリンクを作成
make check       # 衝突チェック（dry-run）
make unstow      # リンクを解除
make restow      # リンクを張り直す（ファイル追加/削除の反映）
```

## 仕組み

- ホーム側の `~/.zshrc` などは、このリポジトリ内のファイルへのシンボリックリンク。
- 設定を変えたいときは**このリポジトリ内のファイルを編集**すれば即反映され、そのまま git 管理下になる。

## 管理対象外（セキュリティ・状態系）

以下はコミットしない（`.gitignore` で防御）:

- 認証情報: `~/.config/gh/hosts.yml`、`~/.claude.json`、`*.credentials.json` など
- `~/.gitconfig`（`user.name` / `user.email`）: PC ごとに異なるので各自のマシンで直接作成する
- 履歴・状態: `~/.zsh_history`、`~/.claude/` の `projects/ sessions/ history.jsonl` ほか
- バイナリ状態: Zed の `prompts/`（LMDB DB）

## クレジット

- `claude/.claude/skills/stop-ai-slop-jp/` は第三者製スキル（MITライセンス）を取り込んだもの。
  詳細は同ディレクトリ内の `LICENSE` / `README.md` を参照。
