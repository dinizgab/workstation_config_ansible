#!/usr/bin/env bash

# Installing the dependencies to run the ansible playbook
apt update && apt install -y curl git python3-pip

# Installing ansible
if python3 -m pip -V;
    then python3 -m pip install --user ansible
    else 
        printf "ERROR: pip is not installed!\n"
        exit 1
fi 

# Adding ansible files to the path
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
source $HOME/.bashrc

# Main git configutation
git config --global user.email "gabrielpombodiniz@gmail.com"
git config --global user.name "Gabriel Diniz"

# Cloning the repository with the ansible playbook
if git clone https://github.com/dinizgab/workstation_config_ansible;
    then cd workstation_config_ansible && ansible-playbook ws_ansible_playbook.yaml --user gabriel
    else
        printf "ERROR: git clone failed!\n"
fi

# Turning zsh the main shell
chsh -s $(which zsh) gabriel

# Installing Brave Browser
# Getting Brave keyring
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# Adding brave repository to sources
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Updating apt repositories
apt update

# Installing Brave
apt install brave-browser