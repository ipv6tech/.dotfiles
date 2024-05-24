#!/usr/bin/env bash
# curl https://raw.githubusercontent.com/ipv6tech/.dotfiles/main/.scripts/dotfile-init.sh | bash

# base system update/upgrade
sudo apt update &&
sudo apt upgrade &&

# install packages that aren't in the base cloud image install
sudo apt install -y git gh nmap finger curl neofetch glances lshw net-tools ca-certificates gnupg fonts-powerline parted htop \
 hwinfo lynx mtr nfs-common tmux whois gnupg2 unzip cloud-guest-utils lsof zsh lsd thefuck netcat-openbsd dnsutils qemu-guest-agent &&

# Docker
sudo install -m 0755 -d /etc/apt/keyrings &&
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
sudo chmod a+r /etc/apt/keyrings/docker.gpg &&

# OpenTofu
curl -fsSL https://get.opentofu.org/opentofu.gpg | sudo tee /etc/apt/keyrings/opentofu.gpg >/dev/null
curl -fsSL https://packages.opentofu.org/opentofu/tofu/gpgkey | sudo gpg --no-tty --batch --dearmor -o /etc/apt/keyrings/opentofu-repo.gpg >/dev/null
sudo chmod a+r /etc/apt/keyrings/opentofu.gpg /etc/apt/keyrings/opentofu-repo.gpg
echo "deb [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main
deb-src [signed-by=/etc/apt/keyrings/opentofu.gpg,/etc/apt/keyrings/opentofu-repo.gpg] https://packages.opentofu.org/opentofu/tofu/any/ any main" | \
sudo tee /etc/apt/sources.list.d/opentofu.list > /dev/null
sudo chmod a+r /etc/apt/sources.list.d/opentofu.list

# Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# install packages with new sources above
sudo apt update &&
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin terraform tofu &&

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