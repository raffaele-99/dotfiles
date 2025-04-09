#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y zsh
sudo chsh -s $(which zsh) $USER

sudo apt install -y caffeine
sudo apt install -y xrdp
sudo apt install -y tasksel


sudo apt-get install -y nmap

mkdir ~/tools && cd ~/tools
sudo apt-get install xsltproc && git clone https://github.com/ernw/nmap-parse-output.git && sudo ln -s ~/tools/nmap-parse-output/nmap-parse-output /usr/local/bin/
sudo apt-get install -y dnsenum


sudo apt-get install -y golang-go
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
go install github.com/projectdiscovery/cvemap/cmd/cvemap@latest

echo export PATH="$PATH:/home/$USER/go/bin" >> ~/.bashrc
source ~/.bashrc


sudo apt install -y ffuf
sudo apt install -y gobuster

## todo: fix this
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash -s $HOME/tools/
## --------------

cd /usr/share && git clone https://github.com/danielmiessler/SecLists.git


sudo apt install tmux
cd ~
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

sudo apt install -y yq

## todo: make a macOS version of this whole script

