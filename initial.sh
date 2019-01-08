#!/bin/bash


sudo apt update && sudo apt upgrade -y

# basic
sudo apt update
sudo apt install software-properties-common apt-transport-https \
         curl wget vim git xclip xsel -y


# install ansible
sudo apt update
sudo apt-add-repository ppa:ansible/ansible
sudo apt update
sudo apt install ansible

ansible --version


# chrome
sudo apt install gdebi-core
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome-stable_current_amd64.deb
#google-chrome


# visual studio code
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install code


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
git config --global user.name "hiromaily"
git config --global user.email "hiromaily2@gmail.com"
git config --global core.editor 'vim -c "set fenc=utf-8"'
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto


# docker
#  delete old one
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt update
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


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

libinput-gestures-setup autostart
libinput-gestures-setup start

sudo apt install python3 python3-setuptools xdotool python3-gi libinput-tools python-gobject
git clone https://gitlab.com/cunidev/gestures
cd gestures
sudo python3 setup.py install


# add to .bashrc
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
#echo "abc" | pbcopy

# check
apt list --upgradable
