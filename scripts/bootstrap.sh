#!/usr/bin/env bash

# base system update/upgrade
sudo apt update &&
sudo apt upgrade &&

# install packages that aren't in the base cloud image install
sudo apt install sudo git gh nmap finger curl neofetch glances lshw net-tools ca-certificates gnupg fonts-powerline parted htop \
 hwinfo lynx mtr nfs-common tmux whois gnupg2 unzip cloud-guest-utils lsof zsh zplug netcat-openbsd dnsutils qemu-guest-agent -y &&

# enable qemu
# sudo systemctl enable qemu-guest-agent &&
# sudo systemctl start qemu-guest-agent &&

# add Docker and Eza repo to apt sources
sudo echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
sudo echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list &&

# Download and set permissions for the Docker and Eza gpg keys
sudo install -m 0755 -d /etc/apt/keyrings &&
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&
curl -fsSL https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg &&
sudo chmod a+r /etc/apt/keyrings/docker.gpg &&
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list &&

# Update apt and install Docker and Eza
sudo apt update &&
sudo apt install -y eza docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&

# install zsh config
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh &&
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k &&

# Clone dotfiles repo
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
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi

# checkout dotfiles from repo
dotfiles checkout
dotfiles config status.showUntrackedFiles no

# change shell
#chsh -s $(which zsh)
