#!/usr/bin/env bash

if [ $(whoami) = 'root' ]; then

	echo "################################################################"
	echo "Syncing timezones"
	echo "################################################################"
	timedatectl set-timezone America/Los_Angeles
	systemctl enable systemd-timesyncd

	echo "################################################################"
	echo "Finding mirrors"
	echo "################################################################"
	reflector --verbose -l 200 -n 10 --sort rate --save /etc/pacman.d/mirrorlist

	echo "################################################################"
	echo "Updating pacman"
	echo "################################################################"
	pacman -Syy

	echo "################################################################"
	echo "Cloning from git."
	echo "################################################################"
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
	echo "cd to /home/jordan/"
	echo "----------------------------------------------------------------"
	cd /home/jordan/
	echo "----------------------------------------------------------------"
	echo "Installing zsh extensions"
	echo "----------------------------------------------------------------"
	rm -rfv .config/
	git clone https://github.com/jtw023/.config.git
	git clone --depth 1 https://github.com/junegunn/fzf.git /home/jordan/.fzf
	/home/jordan/.fzf/install --all
	mkdir -v /usr/share/zsh/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/
	echo "----------------------------------------------------------------"
	echo "Installing spark and other executable scripts"
	echo "----------------------------------------------------------------"
	mkdir -v /home/jordan/.local/bin
	git clone https://github.com/holman/spark.git /home/jordan/.local/bin/
	chmod -v +x /home/jordan/.local/bin/spark
	git clone https://github.com/jtw023/Random-Scripts.git
	chmod -v +x /home/jordan/Random-Scripts/*
	echo "----------------------------------------------------------------"
	echo "Installing vim-plug"
	echo "----------------------------------------------------------------"
	curl -fLo /home/jordan/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


	echo "################################################################"
	echo "Moving packages to proper location"
	echo "################################################################"
	if [ -d "/usr/share/zsh/themes" ]; then
		cp -v /home/jordan/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
	elif [ -d "/usr/share/zsh" ]; then
		mkdir -v /usr/share/zsh/themes
		cp -v /home/jordan/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
	elif [ -d "/usr/share" ]; then
		mkdir -v /usr/share/zsh
		mkdir -v /usr/share/zsh/themes
		cp -v /home/jordan/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
	else
		mkdir -v /usr/share
		mkdir -v /usr/share/zsh
		mkdir -v /usr/share/zsh/themes
		cp -v /home/jordan/.config/zsh/bira.zsh-theme /usr/share/zsh/themes/
	fi
	cp -v /home/jordan/.config/Xresources/.Xresources /home/jordan/
	cp -v /home/jordan/.config/xinit/.xinitrc /home/jordan/
	cp -v /home/jordan/.config/Xauthority/.Xauthority /home/jordan/
	cp -vr /home/jordan/.config/colorscripts/ /opt/shell-color-scripts/
	cp -v /home/jordan/.config/vim/.vimrc.root /root/.vimrc
	cp -v /home/jordan/.config/zsh/.zshrc.root /root/.zshrc
	cp -v /home/jordan/.config/zsh/.zshrc /home/jordan/
	cp -v /home/jordan/.config/vim/.vimrc /home/jordan/


    echo "################################################################"
    echo "Installing psutil"
    echo "################################################################"
    pip3 install psutil


	echo "################################################################"
	echo "Finished the install process. Please run 'chown -R jordan:wheel /home/jordan/."
	echo "################################################################"
else
	echo "Please switch to the root user first."
fi
