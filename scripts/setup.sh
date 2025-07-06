#!/bin/zsh
set -e
echo "🔧 環境をセットアップしています..."

# Homebrewのインストールチェック
if ! command -v brew &> /dev/null; then
  echo "📦 Homebrewをインストールしています..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Brewfileからインストール
echo "🍺 Brewfileからパッケージをインストールしています..."
brew bundle --file="$PWD/../Brewfile"

# dotfilesをホームにリンク
echo "🔗 dotfilesをリンクしています..."
ln -sf "$PWD/../.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/../.gitconfig" "$HOME/.gitconfig"

# 🔐 SSH鍵の確認・作成・登録
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

# すでに存在するSSH鍵（秘密鍵）を検出
EXISTING_KEY=$(find "$HOME/.ssh" -type f -name "id_*" ! -name "*.pub" | head -n 1)
if [[ -n "$EXISTING_KEY" ]]; then
  echo "✅ 既存のSSH鍵が見つかりました: $EXISTING_KEY"
  SSH_KEY="$EXISTING_KEY"
else
  echo "🆕 SSH鍵が見つかりません。新しく作成します..."
  read -p "📧 GitHubで使うメールアドレスを入力してください: " EMAIL
  SSH_KEY="$HOME/.ssh/id_ed25519"
  ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY" -N ""
fi

# ssh-agent 起動と鍵登録（macOS専用）
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain "$SSH_KEY"

# 公開鍵の表示
PUB_KEY="${SSH_KEY}.pub"
echo ""
echo "📋 以下のSSH公開鍵をGitHubに登録してください:"
echo "--------------------------------------------"
cat "$PUB_KEY"
echo "--------------------------------------------"
echo ""
echo "✅ セットアップが完了しました！"
echo "💡 新しい設定を有効にするため、以下のコマンドを実行してください:"
echo "   source ~/.zshrc"
