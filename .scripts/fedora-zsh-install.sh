#!/usr/bin/env bash
# curl https://raw.githubusercontent.com/ipv6tech/.dotfiles/main/.scripts/change-to-zsh.sh | bash

# clone zsh config
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh &&
# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k &&
# syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting &&
# installs zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &&
# grabs the zsh-autosuggestions and adds it in .zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions &&

# clone dotfiles repo
git clone --bare https://github.com/ipv6tech/.dotfiles.git $HOME/.dotfiles &&

# define config alias locally since the dotfiles
# aren't installed on the system yet
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

# create a directory to backup existing dotfiles to
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles from https://github.com/ipv6tech/.dotfiles.git";
  else
    echo "Moving existing dotfiles to ~/.dotfiles-backup";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi

# checkout dotfiles from repo
dotfiles checkout
dotfiles config status.showUntrackedFiles no

# change zsh theme
sed -i -e 's!ZSH_THEME="robbyrussell"!ZSH_THEME="powerlevel10k/powerlevel10k"!g' ~/.zshrc &&

# change shell to zsh
sudo chsh -s $(which zsh) $(whoami)
