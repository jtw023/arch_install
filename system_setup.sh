#!/usr/bin/env bash

if [[ $UID -ne 0 ]]; then

	echo "Please switch to the root user first."

else
	echo "################## Editing doas config file ##################"

	su -c "touch /etc/doas.conf"
	su -c "echo 'permit $USER as root' >> /etc/doas.conf"
	cat /etc/doas.conf
	echo "If this is not 'permit $USER as root' please come back to modify /etc/doas.conf"
	sleep 5

    echo "################## Syncing Timezones ##################"

    timedatectl set-timezone America/Los_Angeles
    systemctl enable systemd-timesyncd


    echo "################## Finding Mirrors ##################"

    reflector --verbose -l 200 -n 10 --sort rate --save /etc/pacman.d/mirrorlist


    echo "################## Updating Pacman ##################"

    pacman -Syy


    echo "################## Cloning Git Repos ##################"

    echo " ------------------------------- "
    echo "| cd to /usr/share/backgrounds/ |"
    echo " ------------------------------- "
    
    cd /usr/share/backgrounds/
    git clone https://gitlab.com/dwt1/wallpapers.git
    
    echo " ------------------------- "
    echo "| cd to /usr/share/fonts/ |"
    echo " ------------------------- "

    cd /usr/share/fonts/
    git clone https://github.com/jtw023/fonts.git

    echo " ------------- "
    echo "| cd to /opt/ |"
    echo " ------------- "

    cd /opt/
    git clone https://aur.archlinux.org/yay.git

    echo " -------------------------------- "
    echo "| cd to the users home directory |"
    echo " -------------------------------- "

    cd $HOME

    echo " --------------------------- "
    echo "| Installing zsh extensions |"
    echo " --------------------------- "

    rm -rfv .config/
    git clone https://github.com/jtw023/.config.git
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --all
    mkdir -pv /usr/share/zsh/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

    echo " ------------------------------------- "
    echo "| Installing Random-Scripts directory |"
    echo " ------------------------------------- "

    git clone https://github.com/jtw023/Random-Scripts.git
    chmod -v +x $HOME/Random-Scripts/*


    echo "################## Moving packages ##################"

    if [ -d "/usr/share/zsh/themes" ]; then
        cp -v $HOME/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    else
        mkdir -pv /usr/share/zsh/themes
        cp -v $HOME/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
    fi

    if [ -d "/usr/share/rofi/themes" ]; then
         cp -v $HOME/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
     else
         mkdir -pv /usr/share/rofi/themes
         cp -v $HOME/.config/rofi/arthur.rasi /usr/share/rofi/themes/arthur.rasi
     fi

    cp -v $HOME/.config/Xresources/.Xresources $HOME/.Xresources
    cp -v $HOME/.config/xinit/.xinitrc $HOME/.xinitrc
    cp -v $HOME/.config/Xauthority/.Xauthority $HOME/.Xauthority
    cp -v $HOME/.config/zsh/.zshrc.root /root/.zshrc
    cp -v $HOME/.config/zsh/.zshenv $HOME/.zshenv


    echo "################## Installing psutil ##################"

    pip3 install psutil

    echo "################## Installing yapf ##################"

    pip3 install yapf

    echo "################## Changing ownership of the entire home directory ##################"

    chown -Rv $USER:wheel $HOME/

    echo "################## Finished. Please check home folder permissions then run the yay_and_lunarvim_setup script. ##################"

fi
