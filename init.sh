#!/bin/bash

rm ~/.bashrc 
rm -rf ~/nvim/
mkdir ~/nvim/colors/ -p 
mkdir ~/nvim/autoload -p 
ln -sr .vimrc ~/nvim/init.vim 
ln -sr .vimrc ~/.vimrc
ln -sr .bashrc ~/.bashrc
ln -sr .tmux.conf ~/.tmux.conf
source ~/.bashrc
nvim -c 'quit' 
cp colo1.vim ~/nvim/colors/1.vim 
mkdir -p ~/nvim/pack/nvim/start/nvim-lspconfig
git clone https://github.com/neovim/nvim-lspconfig ~/nvim/pack/nvim/start/nvim-lspconfig
