#!/bin/bash
#set -e


func_install() {
	if pacman -Qi $1 &> /dev/null; then
  		echo "###############################################################################"
  		echo "################## The package "$1" is already installed"
      	echo "###############################################################################"
	else
    	echo "###############################################################################"
    	echo "##################  Installing package "  $1
    	echo "###############################################################################"
    	pacman -S --noconfirm --needed $1
    fi
}

###############################################################################
echo "Installing Software"
###############################################################################

list=(
adapta-gtk-theme
alacritty
arandr
archlinux-wallpaper
avahi
awesome-terminal-fonts
base-devel
bash
blueberry
bluez
bluez-libs
bluez-utils
bridge-utils
clementine
dialog
dosfstools
dunst
ebtables
ecryptfs-utils
efibootmgr
ffmpeg
flameshot
gedit
gksu
grub
gvfs-smb
htop
imagemagick
jgmenu
libreoffice-fresh
libvirt
lightdm
lightdm-webkit2-greeter
linux-lts-headers
lolcat
lsd
lxappearance
lxsession
lynx
mpv
mtools
netctl
networkmanager
nitrogen
nss-mdns
nvidia-dkms
nvidia-lts
nvidia-settings
nvidia-utils
openssh
os-prober
pass
pcmanfm
picom
playerctl
pulseaudio-bluetooth
python3
qemu
qtile
ranger
redshift
reflector
rofi
rsync
rtorrent
signal-desktop
simplescreenrecorder
sxiv
systemd-manager
tlp
ufw
virt-manager
wireless_tools
wpa_supplicant
xf86-video-intel
xorg-server
xorg-xprop
xorg-xrandr
youtube-dl
zsh
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	echo "Installing package number  "$count " " $name;
	func_install $name
done

###############################################################################

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
git clone https://github.com/jtw023/.config.git
git clone --depth 1 https://github.com/junegunn/fzf.git
echo "----------------------------------------------------------------"
echo "Install zsh fuzzy finder"
echo "----------------------------------------------------------------"
/home/jordan/.fzf/install --all
mkdir -v /usr/share/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/zsh/plugins/zsh-autosuggestions/
mkdir -v /home/jordan/.local/bin
git clone https://github.com/holman/spark.git /home/jordan/.local/bin/
chmod -v +x /home/jordan/.local/bin/spark.sh
git clone https://github.com/jtw023/Random-Scripts.git
chmod -v +x /home/jordan/Random-Scripts/*
curl -fLo /home/jordan/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -Vc ':PlugInstall | quit'

echo "################################################################"
echo "Moving packages"
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
mkdir -v /opt/shell-color-scripts
cp -v /home/jordan/.config/Xresources/.Xresources /home/jordan/
cp -v /home/jordan/.config/xinit/.xinitrc /home/jordan/
cp -v /home/jordan/.config/Xauthority/.Xauthority /home/jordan/
cp -vr /home/jordan/.config/colorscripts/ /opt/shell-color-scripts/
cp -v /home/jordan/.config/vim/.vimrc.root /root/.vimrc
cp -v /home/jordan/.config/zsh/.zshrc.root /root/.zshrc


echo "################################################################"
echo "Enabling yay."
echo "################################################################"
echo "----------------------------------------------------------------"
echo "cd to /opt/"
echo "----------------------------------------------------------------"
cd /opt/
chown -Rv jordan:users ./yay

echo "################################################################"
echo "Finished running. Please modify /etc/lightdm/lightdm.conf and set 'greeter-session' in the [Seat:*] group. Then run 'systemctl enable sshd; systemctl enable NetworkManager; systemctl enable lightdm; systemctl enable bluetooth"
echo "################################################################"
