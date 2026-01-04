#!/bin/bash

rm ~/.bashrc 
rm -rf ~/nvim/
mkdir ~/nvim/colors/ -p 
mkdir ~/nvim/autoload -p 
ln -sr .vimrc ~/nvim/init.vim 
ln -sr .vimrc ~/.vimrc
ln -sr .bashrc ~/.bashrc
ln -sr .tmux.conf ~/.tmux.conf
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
source ~/.bashrc
nvim -c 'quit' 
cp colo1.vim ~/nvim/colors/1.vim 
mkdir -p ~/nvim/pack/nvim/start/nvim-lspconfig
git clone https://github.com/neovim/nvim-lspconfig ~/nvim/pack/nvim/start/nvim-lspconfig
curl -fsSL https://claude.ai/install.sh | bash
sudo apt install dconf-cli
bash ./kasugano.sh 
