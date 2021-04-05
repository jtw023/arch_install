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
qutebrowser
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

echo "################################################################"
echo "Finished installing. Please modify /etc/lightdm/lightdm.conf and set 'greeter-session' in the [Seat:*] group. Then run 'systemctl enable sshd; systemctl enable NetworkManager; systemctl enable lightdm; systemctl enable bluetooth"
echo "################################################################"
