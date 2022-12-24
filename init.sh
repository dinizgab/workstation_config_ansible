#!/usr/bin/env bash

init_log_file="./init.log"

# Installing the dependencies to run the ansible playbook
printf "Installing dependencies\n"
apt update && apt install -y curl git python3-pip

# Installing ansible
printf "Installing ansible\n"
if python3 -m pip -V;
    then python3 -m pip install --user ansible
    else 
        printf "[$(date)] - ERROR: pip is not installed!\n" >> $init_log_file
        exit 1
fi 

# Adding ansible files to the root path
echo "export PATH=$HOME/.local/bin:$PATH" >> $HOME/.bashrc
source $HOME/.bashrc

# Main git configuration
printf "Configurating git\n"
git config --global user.email "your_email"
git config --global user.name "your_name"

# Cloning the repository with the ansible playbook
printf "Cloning the ansible playbook and running it\n"
if git clone https://github.com/dinizgab/workstation_config_ansible;
    then cd workstation_config_ansible && ansible-playbook ws_ansible_playbook.yaml --user your_user
    else
        printf "[$(date)] - ERROR: git clone failed!\n" >> $init_log_file
        exit 1
fi


# Installing oh-my-zsh
printf "Installing oh-my-zsh\n"
if which zsh; 
    then curl -fsL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
    else
        printf "[$(date)] - ERROR: zsh is not installed!\n" >> $init_log_file
        exit 1
fi
# Turning zsh the main shell
printf "Changing default shell\n"
chsh -s $(which zsh) your_user

# Configuring zsh path
# Add new paths to your $PATH variable with the following settings
# echo "export PATH=/home/gabriel/binaries/maven/bin:$PATH" >> /home/gabriel/.zshrc
# echo "export PATH=/home/gabriel/binaries/go/bin:$PATH" >> /home/gabriel/.zshrc

# Installing Brave Browser
# Getting Brave keyring
printf "Installing Brave\n"
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

# Adding brave repository to sources
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

# Updating apt repositories
apt update

# Installing Brave
apt install brave-browser

# Configuring the backup script so that crontab runs it every day ate 22:22
# and moving it to /usr/local/sbin so that it can be run normally
printf "Configuring the backup script\n"
mv ./backup_script.sh /usr/local/sbin
(crontab -l 2>/dev/null; echo "*/22 22 * * * /usr/local/sbin") | crontab -

# Installing nodejs and NPM
printf "Installing nodejs and npm\n"
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

printf "Configuration made successfully"