#!/usr/bin/env bash
# Symlink the dotfiles in this repo into $HOME.
# Each ln fails on its own if anything already exists at its target.

cd "$(dirname "$0")" || exit

mkdir -p ~/.config
ln -sT "$PWD/nvim" ~/.config/nvim
ln -sT "$PWD/.tmux.conf" ~/.tmux.conf
exit 0
