# ===== Path =====
. "$HOME/.local/bin/env"

# ===== Aliases =====
alias ls='ls -G'
alias ll='ls -lah'
alias grep='grep --color=auto'

# ===== Prompt =====
eval "$(starship init zsh)"

# ===== History =====
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY          # 複数シェル間で履歴をリアルタイム共有
setopt HIST_IGNORE_ALL_DUPS   # 重複コマンドは古い方を削除して1つだけ残す
setopt HIST_IGNORE_SPACE      # 先頭が空白のコマンドは履歴に残さない
setopt HIST_REDUCE_BLANKS     # 余分な空白を除いて履歴に保存
setopt EXTENDED_HISTORY       # 実行時刻・所要時間も併せて記録
setopt HIST_NO_STORE          # history コマンド自体は履歴に残さない

# ===== Directory =====
setopt AUTO_CD                # ディレクトリ名だけの入力で cd する
setopt AUTO_PUSHD             # cd 時に自動でディレクトリスタックへ積む
setopt PUSHD_IGNORE_DUPS      # スタックに同じディレクトリを重複させない

# ===== Completion =====
autoload -Uz compinit && compinit
setopt CORRECT                # コマンドのスペルミスを訂正候補として提案
setopt COMPLETE_IN_WORD       # 単語の途中でもカーソル位置で補完する
setopt MAGIC_EQUAL_SUBST      # --prefix=/path の = 以降もパス補完する
setopt GLOB_DOTS              # ドット始まりの隠しファイルも補完・グロブ対象にする
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
# 補完候補を ls と同じ色分けで表示（BSD ls とは別に LS_COLORS を定義）
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ===== Keybindings =====
bindkey -e # emacsモード

# 入力中の文字列で始まる履歴を ↑↓ でたどる（前方一致インクリメンタル）
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search    # ↑
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search  # ↓
bindkey "^[[A" up-line-or-beginning-search                  # ↑（フォールバック）
bindkey "^[[B" down-line-or-beginning-search                # ↓（フォールバック）

# Ctrl-R の履歴検索を部分一致・パターン検索に強化
bindkey '^r' history-incremental-pattern-search-backward

# ===== Misc =====
setopt PRINT_EIGHT_BIT        # 日本語などマルチバイトのファイル名を正しく表示
setopt NO_BEEP                # 補完・エラー時のビープ音を鳴らさない

# ===== Plugins =====
# サジェスト文字の色
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=248'
# オートサジェスト
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# シンタックスハイライト
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
