# Dotfiles

This repository contains my personal dotfiles, managed using [chezmoi](https://www.chezmoi.io/). It's a work in progress as I continue to refine my development environment.

## What's Included

- **Git**: Configuration (`.gitconfig`) and global ignore file (`.gitignore_global`)
- **Zsh**: Shell configuration (`.zshrc`)
- **Neovim**: Custom Neovim setup with plugins and configurations
- **Direnv**: Directory-specific environment variables (`.config/direnv/direnv.toml`)

## Setup

1. Install chezmoi:
   ```bash
   # On macOS with Homebrew
   brew install chezmoi

   # On Arch Linux
   sudo pacman -S chezmoi
   ```

2. Initialize and apply dotfiles:
   ```bash
   chezmoi init https://github.com/your-username/your-dotfiles-repo.git
   chezmoi apply
   ```

For detailed instructions and advanced usage, see the [chezmoi documentation](https://www.chezmoi.io/quick-start/).