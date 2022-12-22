#!/bin/bash

## Install ZSH, Git, Nano, etc
sudo dnf install -y zsh git nano wget

## Install thefuck and ansible
sudo python3 -m pip install --upgrade pip
sudo python3 -m pip install --upgrade thefuck ansible

export SHELL="/bin/zsh"

## Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh/" ]; then
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

## Install Powerlevel10k
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  CUR_THEME=$(grep "^ZSH_THEME=" ~/.zshrc)
  sed -i "s|${CUR_THEME}|ZSH_THEME=\"powerlevel10k\/powerlevel10k\"|g" ~/.zshrc
fi

## Install Nerd Fonts
if [ ! -d "$HOME/.local/share/fonts/nerd-fonts" ]; then
  mkdir -p ~/.local/share/fonts/
  cd ~/.local/share/fonts/
  git clone --depth 1 https://github.com/ryanoasis/nerd-fonts
  cd nerd-fonts
  ./install.sh
fi