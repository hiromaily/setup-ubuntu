#!/bin/bash


sudo apt update && sudo apt upgrade -y

# basic
sudo apt install software-properties-common apt-transport-https ca-certificates \
         snapd curl wget vim git gcc build-essential xclip xsel screen -y


# install ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible

ansible --version


# ssh
ssh-keygen -t rsa -b 4096 -C "my@gmail.com"

# ssh-agent
# https://www.server-memo.net/server-setting/ssh/ssh-agent.html
eval "$(ssh-agent -s)"
ssh-add -k ~/.ssh/id_rsa


# git
xclip -selection clipboard < ~/.ssh/id_rsa.pub
# add key on mypage of github.com
# check
#ssh -T git@github.com

# git settings
git config --global user.name "username"
git config --global user.email "my@gmail.com"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto


# chrome
sudo apt install gdebi-core
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome-stable_current_amd64.deb
#google-chrome



# docker
#  delete old one
sudo apt remove docker docker-engine docker.io containerd runc

#sudo apt install \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update
sudo apt install docker-ce

sudo usermod -aG docker ${USER}
# or
#sudo gpasswd -a $USER docker
# Then log out or restart is required
# check here: https://docs.docker.com/install/linux/linux-postinstall/

# docker by snap
#https://github.com/docker/docker-snap
#sudo snap install docker
#sudo addgroup --system docker
##sudo adduser $USER docker
#newgrp docker
#sudo snap disable docker
#sudo snap enable docker


# docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# visual studio code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code

# vscode by snap
#sudo snap install vscode --classic


# golang
wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.11.4.linux-amd64.tar.gz
mkdir ~/go/src ~/go/pkg ~/go/bin
mkdir ~/go/src/github.com/hiromaily

# modified ~/.profile
#PATH=$PATH:/usr/local/go/bin

# golang by snap
#sudo snap install go --classic


# IintelliJ Idea
sudo snap install intellij-idea-community --classic

# Slack
sudo snap install slack --classic

# Skype
sudo snap install skype --classic

# TeamSQL
wget https://teamsql.io/latest/linux -O TeamSQL.AppImage
chmod a+x TeamSQL.AppImage
./TeamSQL.AppImage
#sudo chown -R ~/.config/TeamSQL/

#Under your .config file you should see TeamSQL File.
#Open terminal and type sudo chown -R .config/TeamSQL/
#After that, reboot your Ubuntu and then TeamSQL App will be able to access your config files.


# Alacritty
sudo curl https://sh.rustup.rs -sSf | sh
source ~/.profile
rustup update

sudo apt install cmake libfreetype6-dev libfontconfig1-dev xclip

cd ~/Downloads
git clone https://github.com/jwilm/alacritty.git
cd alacritty
cargo build --release

sudo cp target/release/alacritty /usr/local/bin
cp alacritty.desktop ~/.local/share/applications
sudo desktop-file-install alacritty.desktop
sudo update-desktop-database

sudo mkdir -p /usr/local/share/man/man1
gzip -c alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

cp alacritty-completions.bash  ~/.alacritty
echo "source ~/.alacritty" >> ~/.bashrc



# gesture
# https://www.omgubuntu.co.uk/2018/09/linux-touchpad-gestures-app
# https://github.com/bulletmark/libinput-gestures
# https://gitlab.com/cunidev/gestures
sudo gpasswd -a $USER input
sudo apt install xdotool wmctrl
sudo apt install libinput-tools
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install (or sudo ./libinput-gestures-setup install)

# logout is required
#libinput-gestures-setup autostart
libinput-gestures-setup start

sudo apt install python3 python3-setuptools xdotool python3-gi libinput-tools python-gobject
git clone https://gitlab.com/cunidev/gestures
cd gestures
sudo python3 setup.py install


# add to .bashrc
cat << "EOT" > ~/.bashrc

alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

EOT

#echo "abc" | pbcopy


# service
sudo service docker start

# or systemctl
#sudo systemctl enable docker
#sudo systemctl disable docker

# check
apt list --upgradable
