#!/bin/bash
#set -e

func_install() {

	if pacman -Qi $1 &> /dev/null; then

  		echo "################## The package "$1" is already installed ##################"

	else

    	pacman -S --noconfirm --needed $1

    fi

}

echo "################## Generating FStab file ##################"

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

echo "################## Setting the english locale ##################"

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
cat /etc/locale.gen | grep en_US
echo "The second line: 'en_US.UTF-8 UTF-8' should be uncommented. If not, please fix /etc/locale.gen."
echo "Sleeping for 10 seconds while you read this."
sleep 10

locale-gen

echo "################## Installing Software ##################"

list=(
adapta-gtk-theme
alacritty
alsa-lib
archlinux-wallpaper
avahi
awesome-terminal-fonts
base-devel
bash
bat
# blueberry
# bluez
# bluez-libs
# bluez-utils
bridge-utils
btrfs-progs
ctags
dialog
doas
dosfstools
dunst
ebtables
ecryptfs-utils
efibootmgr
ffmpeg
flameshot
gedit
grub
gvfs-smb
htop
imagemagick
intel-ucode
jgmenu
kitty
libreoffice-fresh
libvirt
lightdm
lightdm-webkit2-greeter
linux-lts-headers
lolcat
lsd
lxappearance
lxsession
lua
lynx
man-db
mpv
mtools
netctl
networkmanager
nitrogen
nss-mdns
nvidia
nvidia-dkms
nvidia-lts
nvidia-settings
nvidia-utils
openssh
os-prober
pacman-contrib
pass
pavucontrol
pcmanfm
picom
powerline-fonts
pulseaudio
pulseaudio-alsa
# pulseaudio-bluetooth
python3
python-pillow
python-pip
python-pynvim
qemu
qtile
qutebrowser
r
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
unzip
virt-manager
wget
wireless_tools
wpa_supplicant
xorg-server
xorg-xrandr
xorg-xrdb
xorg-xprop
youtube-dl
zsh
zsh-syntax-highlighting
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	echo "Installing package number  "$count " " $name;
	func_install $name
done

echo "################## Setting hostname to 'archybangbang' ##################"
if [[ -f "/etc/hostname" ]]; then
    hostnamectl set-hostname archybangbang
    echo "archybangbang" >> /etc/hostname
else
    touch /etc/hostname
    hostnamect set-hostname archybangbang
    echo "archybangbang" >> /etc/hostname
fi

echo "################## Setting up wifi ##################"
if [[ -f "/etc/hosts" ]]; then
    echo "127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
else
    touch /etc/hosts
    echo "127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
fi

cat /etc/hosts
echo "The above file should contain the following:\n\n# Static table lookup for hostnames.\n# See hosts(5) for details.\n127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters\n\nIf not, please come back to edit /etc/hosts"
echo "Sleeping for 10 seconds while you read this."
sleep 10

echo "################## Editing /etc/lightdm/lightdm.conf ##################"
sed -i 's/#greeter-session=.*/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
cat /etc/lightdm/lightdm.conf | grep greeter-session=
echo "The above line should be 'greeter-session=lightdm-webkit2-greeter'. If it is not, please come back to edit /etc/lightdm/lightdm.conf"
echo "Sleeping for 10 seconds while you read this."
sleep 10

echo "################## Enabling systemctl ##################"
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable lightdm
# systemctl enable bluetooth
	
echo "Finished. Please set your root password using the command 'passwd', then create a user for yourself using 'useradd -m -g users -g wheel *yourusername*' and be sure to set a password for that new user using 'passwd *yourusername*'.\n\nOnce done, add 'btrfs nvidia' between the parentheses on the MODULES line in /etc/mkinitcpio.conf and then run the command 'mkinitcpio -p linux-lts'.\n\nFinally, reboot and then run the system_setup script."
