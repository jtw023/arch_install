#!/usr/bin/env bash

RED='\033[0;31m' # Red color
BLUE='\033[0;36m' # Cyan color
GREEN='\033[0;32m' # Green color
NC='\033[0m' # No color

func_install() {

	if pacman -Qi $1 &> /dev/null; then

  		echo -e "${RED}################## The package "$1" is already installed ##################${NC}"

	else

    	pacman -S --noconfirm $1

    fi

}

echo "################## Setting the english locale ##################"

ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
cat /etc/locale.gen | grep en_US
echo -e "${BLUE}There should be an uncommented line: 'en_US.UTF-8 UTF-8'. If not, please fix /etc/locale.gen${NC}."
echo -e "${BLUE}Sleeping for 20 seconds while you read this${NC}."
sleep 20

locale-gen

if [[ -f "/etc/locale.conf" ]]; then
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
else
    touch /etc/locale.conf
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
fi


echo "################## Installing Software ##################"

list=(
adapta-gtk-theme
alacritty
alsa-lib
# archlinux-wallpaper
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
opendoas
dnsmasq
dosfstools
dunst
ebtables
ecryptfs-utils
edk2-ovmf
efibootmgr
efm-langserver
ffmpeg
flameshot
go
grub
grub-btrfs
gvfs-smb
htop
imagemagick
# intel-ucode
jgmenu
libreoffice-fresh
libvirt
# linux-lts-headers
linux-headers
lolcat
lsd
lxappearance
lxsession
lua
lynx
man-db
mlocate
mpv
mtools
netctl
networkmanager
nitrogen
nodejs
npm
nss-mdns
nvidia
nvidia-dkms
# nvidia-lts
nvidia-settings
nvidia-utils
openbsd-netcat
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
signal-desktop
# simplescreenrecorder
sxiv
systemd-manager
tlp
transmission-cli
ufw
unzip
vde2
# vim
virt-manager
wget
wireless_tools
wpa_supplicant
xorg-server
xorg-xinit
xorg-xkill
xorg-xrandr
xorg-xrdb
xorg-xprop
# youtube-dl
zathura
zathura-pdf-mupdf
zsh
zsh-syntax-highlighting
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	echo -e "${BLUE}Installing package number "$count" of ${#list[@]}${NC}" $name;
	func_install $name
done

echo "################## Setting hostname to 'archybangbang' ##################"
if [[ -f "/etc/hostname" ]]; then
    hostnamectl set-hostname archybangbang
    echo "archybangbang" >> /etc/hostname
else
    touch /etc/hostname
    hostnamectl set-hostname archybangbang
    echo "archybangbang" >> /etc/hostname
fi

echo "################## Setting up wifi ##################"
if [[ -f "/etc/hosts" ]]; then
    echo -e "127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
else
    touch /etc/hosts
    echo -e "127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
fi

cat /etc/hosts
echo -e "${BLUE}The above file should contain the following:\n\n# Static table lookup for hostnames.\n# See hosts(5) for details.\n127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters\n\nIf not, please come back to edit /etc/hosts${NC}."
echo -e "${BLUE}Sleeping for 30 seconds while you read this${NC}."
sleep 30

echo "################## Editing /etc/libvirt/libvirtd.conf ##################"
sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g' /etc/libvirt/libvirtd.conf
sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g' /etc/libvirt/libvirtd.conf
cat /etc/libvirt/libvirtd.conf | grep unix_sock_group
echo -e "${BLUE}The above line should be: unix_sock_group = 'libvirt'${NC}"
cat /etc/libvirt/libvirtd.conf | grep unix_sock_rw_perms
echo -e "${BLUE}The above line should be: unix_sock_rw_perms = '0770'${NC}"
echo -e "${BLUE}If either of those are wrong, please come back to edit /etc/libvirt/libvirtd.conf${NC}."
echo -e "${BLUE}Sleeping for 20 seconds while you read this${NC}."
sleep 20

echo "################## Editing /etc/pacman.conf ##################"
sed -i 's/#Color/Color/g' /etc/pacman.conf
cat /etc/pacman.conf | grep Color
echo -e "${BLUE}The above line should be 'Color'. If it is not, please come back to edit /etc/pacman.conf${NC}."
echo -e "${BLUE}Sleeping for 20 seconds while you read this${NC}."
sleep 20

echo "################## Enabling systemctl ##################"
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable tlp
systemctl enable libvirtd
# systemctl enable bluetooth
virsh net-autostart default

echo "################## Editing mkinitcpio.conf ##################"

sed -i 's/MODULES=.*/MODULES=(btrfs nvidia)/g' /etc/mkinitcpio.conf
cat /etc/mkinitcpio.conf | grep MODULES
echo -e "${BLUE}The above line should be 'MODULES=(btrfs nvidia)'. If it is not, please come back to edit /etc/mkinitcpio.conf${NC}."
echo -e "${BLUE}Sleeping for 20 seconds while you read this${NC}."
sleep 20

mkinitcpio -p linux

echo "################## Setting users and passwords ##################"

echo -e "${BLUE}Create a password for the root user${NC}."
passwd

echo -e "${BLUE}Enter a username for the normal user${NC}."
echo "Username:"
read user

groupadd libvirtd
groupadd wheel
groupadd users

useradd -m -g users -G wheel,libvirt $user

echo "Add a password for $user."
passwd $user

echo "################## Installing grub ##################"

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

echo "################## Making grub ##################"

grub-mkconfig -o /boot/grub/grub.cfg

echo "################## Editing sudoers config file ##################"

sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
cat /etc/sudoers | grep %wheel
echo -e "${BLUE}The above line should be '%wheel ALL=(ALL) ALL'. If it is not, please fix${NC}."
echo -e "${BLUE}Sleeping for 20 seconds while you read this${NC}."
sleep 20

echo "################## Moving install script to users home directory ##################"

mv -v arch_install/ /home/$user/

echo "################## Inserting echo command into bashrc for next steps ##################"

echo "echo 'command for next script(to be run with su NOT sudo): ./arch_install/system_setup.sh'" >> /home/$user/.bashrc

echo -e "${GREEN}Finished! Please type 'exit', then 'umount -R /mnt', and reboot${NC}."

