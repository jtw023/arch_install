#!/usr/bin/env bash

BLUE='\033[1;34m' # Blue color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No color

if [[ $UID -ne 0 ]]; then

	echo "Please switch to the root user first."

else

    echo "################## Syncing Timezones ##################"

    timedatectl set-timezone America/Los_Angeles
    systemctl enable systemd-timesyncd

    echo "################## Finding Mirrors ##################"

    reflector --verbose -l 200 -n 10 --sort rate --save /etc/pacman.d/mirrorlist

    echo "################## Updating Pacman ##################"

    pacman -Syy

    echo "################## Cloning Git Repos ##################"

    echo " ------------------------- "
    echo "| cd to /usr/share/fonts/ |"
    echo " ------------------------- "

    cd /usr/share/fonts/
    git clone https://github.com/jtw023/fonts.git

    echo " ------------- "
    echo "| cd to /opt/ |"
    echo " ------------- "

    cd /opt/
    git clone https://aur.archlinux.org/paru.git

    echo " -------------------------------- "
    echo "| cd to the users home directory |"
    echo " -------------------------------- "

    cd ~$USER

    echo " --------------------------- "
    echo "| Installing zsh extensions |"
    echo " --------------------------- "

    rm -rfv .config/
    git clone https://github.com/jtw023/.config.git

    mkdir -pv /usr/share/zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

    git clone --depth 1 https://github.com/junegunn/fzf.git ~$USER/.fzf
    ~$USER/.fzf/install --all

    echo " ------------------------------------- "
    echo "| Installing Random-Scripts directory |"
    echo " ------------------------------------- "

    git clone https://github.com/jtw023/Random-Scripts.git
    chmod -v +x ~$USER/Random-Scripts/*


    echo "################## Making directories and moving packages ##################"

	mkdir -pv /home/jordan/session

    if [ -d "/usr/share/zsh/themes" ]; then
        cp -v ~$USER/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    else
        mkdir -pv /usr/share/zsh/themes
        cp -v ~$USER/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    fi

    if [ -d "/usr/share/rofi/themes" ]; then
        cp -v ~$USER/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
    else
        mkdir -pv /usr/share/rofi/themes
        cp -v ~$USER/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
    fi

    cp -v ~$USER/.config/Xresources/.Xresources ~$USER/.Xresources
    cp -v ~$USER/.config/xinit/.xinitrc ~$USER/.xinitrc
    cp -v ~$USER/.config/Xauthority/.Xauthority ~$USER/.Xauthority
    cp -v ~$USER/.config/zsh/.zshrc.root /root/.zshrc
    cp -v ~$USER/.config/zsh/.zshenv ~$USER/.zshenv
	cp -v ~$USER/Random-Scripts/set_screens.sh /usr/local/bin/set_screens.sh

echo "################## Editing /etc/lightdm/lightdm.conf ##################"
sed -i 's;#display-setup-script=;display-setup-script=/usr/local/bin/set_screens.sh;g' /etc/lightdm/lightdm.conf
cat /etc/lightdm/lightdm.conf | grep display-setup-script
echo -e "${BLUE}The above line should be 'display-setup-script=/usr/local/bin/set_screens.sh'. If it is not, please come back to edit /etc/lightdm/lightdm.conf${NC}."
echo "Sleeping for 20 seconds while you read this."
sleep 20


    echo "################## Changing ownership of the entire home directory ##################"

    chown -Rv $USER:wheel ~$USER/

    echo -e "${GREEN} Finished. Please check home folder permissions then run the yay_and_lunarvim_setup script${NC}."

fi
