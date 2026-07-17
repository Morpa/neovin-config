#!/usr/bin/env bash
# Instala esta configuração de Neovim (rodando no terminal Ghostty) num Mac novo.
# Uso: ./install.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_CONFIG_DIR="$HOME/.config/nvim"

echo "==> Verificando Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew não encontrado. Instale primeiro em https://brew.sh e rode este script de novo."
  exit 1
fi

echo "==> Instalando dependências via Homebrew..."
brew install neovim fd ripgrep tree-sitter-cli make fish
brew install --cask ghostty

# Fonte Nerd Font (necessária pros ícones da árvore de arquivos e statusline).
# Só instala se nenhuma nerd font já estiver presente, pra não duplicar.
if ! ls "$HOME/Library/Fonts" 2>/dev/null | grep -qi "nerdfont"; then
  echo "==> Instalando fonte Iosevka Nerd Font..."
  brew install --cask font-iosevka-nerd-font
else
  echo "==> Nerd Font já encontrada em ~/Library/Fonts, pulando instalação de fonte."
fi

echo "==> TypeScript global (necessário pro ts_ls funcionar em projetos sem node_modules local)..."
# Pinado em @5: a v7 é a reescrita nativa ("tsgo"/native preview) e não tem
# mais o tsserver.js clássico que o typescript-language-server precisa —
# instalar sem pin quebra o ts_ls com "Could not find a valid TypeScript
# installation" em qualquer arquivo fora de um pacote com typescript local
# (ex: scripts soltos na raiz de monorepos pnpm).
if command -v npm >/dev/null 2>&1; then
  npm install -g typescript@5
else
  echo "npm não encontrado — instale o Node.js (ex: via fnm/nvm) e rode 'npm install -g typescript@5' depois."
fi

echo "==> Copiando configuração para $NVIM_CONFIG_DIR..."
if [ -e "$NVIM_CONFIG_DIR" ] || [ -L "$NVIM_CONFIG_DIR" ]; then
  backup="$NVIM_CONFIG_DIR.bak.$(date +%Y%m%d%H%M%S)"
  echo "    Já existe uma config em $NVIM_CONFIG_DIR — movendo para $backup"
  mv "$NVIM_CONFIG_DIR" "$backup"
fi
cp -R "$REPO_DIR/nvim" "$NVIM_CONFIG_DIR"

echo "==> Instalando plugins (lazy.nvim) e parsers do treesitter..."
nvim --headless "+Lazy! sync" +qa

echo "==> Instalando language servers e formatters via Mason..."
nvim --headless "+MasonInstall typescript-language-server rust-analyzer gopls lua-language-server biome tailwindcss-language-server prettier stylua" +qa

echo ""
echo "Tudo pronto! Abra um projeto com: nvim <caminho-do-projeto>"
echo "Se usar GitHub Copilot, autentique uma vez com ':Copilot auth' dentro do Neovim."
echo "Cheat sheet completa disponível dentro do Neovim com :Cheatsheet (ou <leader>?)."
