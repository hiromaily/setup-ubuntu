#!/bin/bash


sudo apt update && sudo apt upgrade -y

# basic
sudo apt install software-properties-common apt-transport-https ca-certificates \
         snapd net-tools curl wget vim git gcc build-essential xclip xsel screen \
         htop libsecret-tools -y

#zsh
sudo apt install zsh git-core -y
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
sudo shutdown -r 0

git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
# .zshrc should be modified
#plugins=(… zsh-completions)
#autoload -U compinit && compinit
#echo "plugins=(… zsh-completions)" >> ~/.zhsrc
#echo "autoload -U compinit && compinit" >> ~/.zhsrc

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

cat << "EOT" > ~/.gitconfig

[alias]
	# alias
	al = config --get-regexp alias # show git alias list
	# status
	st = status
	# branch
	br = branch
	brt = branch -vv # show upstream branch name with minor
	tb = rev-parse --abbrev-ref --symbolic-full-name @{u} # show upstream branch name
	cb = rev-parse --abbrev-ref HEAD # show current branch name
	brn = "!f(s){ git branch | head -n $1 | tail -n 1;};f" # get `n`th branch name from the top in branch list
	brdn = "!f(){ brname=$(git branch | head -n $1 | tail -n 1); git branch -D $brname;};f" # delete branch by number in branch list
	brnm = branch -r --no-merged origin/develop # check no-merged branches to origin/develop from remote
	brm = branch -r --merged origin/develop # check merged branches to origin/develop from remote
	# checkout
	ch = checkout
	chnew = "!f(){ git ch -b $1 origin/master;};f" # create new branch
	chn = "!f(){ brname=$(git branch | head -n $1 | tail -n 1); git checkout $brname;};f" # change branch by number from the top in branch list , `gitbr`command can get branch list
	# add
	addm = "!f(){ git diff --name-only --diff-filter=M | xargs git add;};f" # git add files without untracked files (= git add -u)
	# commit
	cm = commit -m # commit with message
	coam = "!f(){ git commit -am \"$1\";};f" # commit with add all modified files and message
	# push
	pushf = push --force-with-lease # push with safe push
	pum = push origin master
	pumf = push -f origin master
	puc = "!f(){ br=$(git rev-parse --abbrev-ref HEAD);git push origin \"${br}\";};f" # get current branch name, and push there.
	pucu = "!f(){ br=$(git rev-parse --abbrev-ref HEAD);git push -u origin \"${br}\";};f" # get current branch name, and push there with setting upstream
	pucf = "!f(){ br=$(git rev-parse --abbrev-ref HEAD);git push -f origin \"${br}\";};f" # get current branch name, and push there with force
	# reset
	canadd = reset HEAD # cancel files by git add
	rs = reset --soft HEAD~ # reset commit and add action
	rsm = reset --hard origin/master # reset by origin/master condition
	rscurrent = "!f(){ tracebranch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u}); git reset --hard $tracebranch;};f" # git reset by current upstream branch
	recm = "!f(){ cmt=$(git log -n 1 --pretty=format:%s);git reset --soft HEAD~;git commit -am \"${cmt}\";};f" #reset and commit with same message again.
	canmerge = git reset --hard ORIG_HEAD # cancel merge by previous commit
	# rebase
	rbm = rebase origin/master # this rebase means, try to marge from latest origin/master
	# remove
	rmc = rm --cached # leave files, but exclude that file from git management.
	cln = clean -dn # remove Remove untracked files and directories but `n` means dry-run
	clnok = clean -fd # remove files, but make sure by git cln in advance
	cln2 = clean -dnx # remove Remove untracked files and directories including files set in .gitignore but `n` means dry-run
	clnok2 = clean -fdx # remove files, but make sure by git cln in advance
	# log
	lg = log --oneline --graph --decorate # show log with oneline
	last = log -1 HEAD # show latest log
	cmmsg = log -n 1 --pretty=format:\"%s\" # show latest commit message
	cmtid = log -n 1 --pretty=format:\"%H\" # show latest commit id
	showhis = "!f(){ id=$(git log -n $1 --pretty=format:%h);git show ${id} $2;};f" # git showhis 1 => show latest modification of code
	dellist = log --diff-filter=D --summary # show deleted file histories in git log
	pushor = "!f(){ brc=$(git rev-parse --abbrev-ref HEAD); git log origin/$brc..$brc;};f" # get current branch and make sure if I've already push or not
	rewritelog = "!f(){ git filter-branch --commit-filter ' if [ \"\" = wrong@address.local ]; then GIT_AUTHOR_NAME=myname; GIT_AUTHOR_EMAIL=right@address.com; fi; git commit-tree \"\";' HEAD; };f" # rewrite log histories
	# diff
	dfc = diff --cached # diff between index and committed file in HEAD
	dff = "!f(){ git diff $1:$3 $2:$3;};f" # dff $1:branch A, $2:branch B, $3:file path
	diffbr = difftool --dir-diff # diff current entire changes in work directory
	# fetch
	ft = fetch origin
	fta = fetch --all
	clnf = fetch -p origin # Before fetching, remove any remote-tracking references that no longer exist on the remote
	# remote
	delremote = push --delete origin # delete remote branch
	renameremote = "!f(){ git checkout -b $1 origin/$1; git branch -m $1 $2; git push origin --delete $1; git push origin $2;};f" # change remote branch
	# worktree
	wt = worktree
	wtlist = worktree list
	wtadd = "!f(){ git worktree add worktree/$1 $1;};f"
	wtrm = "!f(){ rm -rf worktree/$1; git worktree prune;};f"
	# other
	nottrace = "!f(){ git update-index --assume-unchanged $1;};f" #ignore files like gitignore
	changeurl = "!f(){ url=$(git remote -v | head -n 1 | sed -e \"s/(fetch)//\" -e \"s/https:\\/\\//git@/\" -e \"s/https:\\/\\//git@/\");git remote set-url \"${url}\";};f"
	echo = "!f(){ url=$(git remote -v | head -n 1 | sed -e \"s/(fetch)//\" -e \"s/https:\\/\\//git@/\" -e \"s/https:\\/\\//git@/\");echo \"${url}\";};f"
	chtag = checkout -b $1 refs/tags/$1
	cmtrank = shortlog -sn origin/master --after=\"date +%Y/%m/01\" --before=\"date +%Y/%m/%d\"
	cmtrankall = shortlog -s origin/master
	cm2 = commit -S -m
	difcm = "!f(){ tb=$(git rev-parse --abbrev-ref --symbolic-full-name @{u});git diff HEAD..${tb};};f"
	updsub = submodule update --init --recursive

EOT


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

# Terminator
sudo add-apt-repository ppa:gnome-terminator
sudo apt update
sudo apt install terminator

# for bash
#cp alacritty-completions.bash ~/.alacritty
#echo "source ~/.alacritty" >> ~/.bashrc
# for zsh
cp alacritty-completions.zsh /usr/share/zsh/functions/Completion/X/_alacritty

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

# Edit $HOME/.config/libinput-gestures.conf


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
