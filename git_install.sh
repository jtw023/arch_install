#!/usr/bin/env bash

if [ $(whoami) = 'root' ]; then

	echo "################## Syncing Timezones ##################"

	timedatectl set-timezone America/Los_Angeles
	systemctl enable systemd-timesyncd


	echo "################## Finding Mirrors ##################"

	reflector --verbose -l 200 -n 10 --sort rate --save /etc/pacman.d/mirrorlist


	echo "################## Updating Pacman ##################"

	pacman -Syy


	echo "################## Cloning Git Repos ##################"

	echo "----------------------------------------------------------------"
	echo "cd to /usr/share/backgrounds/"
	echo "----------------------------------------------------------------"
    
	cd /usr/share/backgrounds/
	git clone https://gitlab.com/dwt1/wallpapers.git
    
	echo "----------------------------------------------------------------"
	echo "cd to /usr/share/fonts/"
	echo "----------------------------------------------------------------"

	cd /usr/share/fonts/
	git clone https://github.com/jtw023/fonts.git

	echo "----------------------------------------------------------------"
	echo "cd to /opt/"
	echo "----------------------------------------------------------------"

	cd /opt/
	git clone https://aur.archlinux.org/yay.git

	echo "----------------------------------------------------------------"
	echo "cd to $HOME/"
	echo "----------------------------------------------------------------"

	cd $HOME

	echo "----------------------------------------------------------------"
	echo "Installing zsh extensions"
	echo "----------------------------------------------------------------"

	rm -rfv .config/
	git clone https://github.com/jtw023/.config.git
	git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
	$HOME/.fzf/install --all
	mkdir -pv /usr/share/zsh/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/

	echo "----------------------------------------------------------------"
	echo "Installing Random-Scripts directory"
	echo "----------------------------------------------------------------"

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

    echo "################## Changing ownership ##################"

    chown -R jordan:wheel $HOME/

	echo "################## Finished. Please check home folder permissions then run mkpkg_install.sh. ##################"

else
	echo "Please switch to the root user first."
fi
