# ========================================
# 基本設定
# ========================================

# Homebrew 環境設定 (Apple Silicon)
eval "$(/opt/homebrew/bin/brew shellenv)"

# PATH 追加（必要に応じて）
export PATH="$HOME/bin:$PATH"

# Zsh の補完機能
autoload -Uz compinit && compinit

# カラー出力
autoload -Uz colors && colors

# GitHub CLI alias
alias g='gh'

# ls を見やすく（カラー表示）
alias ls='ls -G'

# ========================================
# asdf (バージョン管理ツール)
# ========================================
if [[ -d "$(brew --prefix asdf)" ]]; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# ========================================
# zsh プラグイン系（Homebrew経由でインストールした場合）
# ========================================

# 入力補完候補を過去のコマンドから提案
if [[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# コマンドのシンタックスハイライト
if [[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ========================================
# Starship プロンプト
# ========================================
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

