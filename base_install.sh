#!/usr/bin/env bash

func_install() {

	if pacman -Qi $1 &> /dev/null; then

  		echo "################## The package "$1" is already installed ##################"

	else

    	pacman -S --noconfirm $1

    fi

}

echo "################## Setting the english locale ##################"

ln -sf /usr/share/zoneinfo/US/Pacific /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
cat /etc/locale.gen | grep en_US
echo "The second line: 'en_US.UTF-8 UTF-8' should be uncommented. If not, please fix /etc/locale.gen."
echo "Sleeping for 20 seconds while you read this."
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
grub
grub-btrfs
gvfs-smb
htop
imagemagick
# intel-ucode
jgmenu
libreoffice-fresh
libvirt
lightdm
lightdm-webkit2-greeter
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
nss-mdns
nvidia
nvidia-dkms
nvidia-lts
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
	echo "Installing package number  "$count " " $name;
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
    echo -e "127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
else
    touch /etc/hosts
    echo -e "127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
fi

cat /etc/hosts
echo -e "The above file should contain the following:\n\n# Static table lookup for hostnames.\n# See hosts(5) for details.\n127.0.0.1 localhost\n::1 localhost ip6-localhost ip6-loopback\n127.0.1.1 archybangbang\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters\n\nIf not, please come back to edit /etc/hosts"
echo "Sleeping for 30 seconds while you read this."
sleep 30

echo "################## Editing /etc/libvirt/libvirtd.conf ##################"
sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g' /etc/libvirt/libvirtd.conf
sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g' /etc/libvirt/libvirtd.conf
cat /etc/libvirt/libvirtd.conf | grep unix_sock_group
echo "The above line should be: unix_sock_group = 'libvirt'"
cat /etc/libvirt/libvirtd.conf | grep unix_sock_rw_perms
echo "The above line should be: unix_sock_rw_perms = '0770'"
echo "If either of those are wrong, please come back to edit /etc/libvirt/libvirtd.conf"
echo "Sleeping for 20 seconds while you read this."
sleep 20

echo "################## Editing /etc/lightdm/lightdm.conf ##################"
sed -i 's/#greeter-session=.*/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
cat /etc/lightdm/lightdm.conf | grep greeter-session=
echo "The above line should be 'greeter-session=lightdm-webkit2-greeter'. If it is not, please come back to edit /etc/lightdm/lightdm.conf"
echo "Sleeping for 20 seconds while you read this."
sleep 20

echo "################## Editing /etc/pacman.conf ##################"
sed -i 's/#Color/Color/g' /etc/pacman.conf
cat /etc/pacman.conf | grep Color
echo "The above line should be 'Color'. If it is not, please come back to edit /etc/pacman.conf"
echo "Sleeping for 20 seconds while you read this."
sleep 20

echo "################## Enabling systemctl ##################"
systemctl enable sshd
systemctl enable NetworkManager
systemctl enable lightdm
systemctl enable tlp
systemctl enable libvirtd
# systemctl enable bluetooth
virsh net-autostart default

echo "################## Editing mkinitcpio.conf ##################"

sed -i 's/MODULES=.*/MODULES=(btrfs nvidia)/g' /etc/mkinitcpio.conf
cat /etc/mkinitcpio.conf | grep MODULES
echo "The above line should be 'MODULES=(btrfs nvidia)'. If it is not, please come back to edit /etc/mkinitcpio.conf"
echo "Sleeping for 20 seconds while you read this."
sleep 20

mkinitcpio -p linux

echo "################## Setting users and passwords ##################"

echo "Create a password for the root user."
passwd

echo "Enter a username for the normal user."
read user

addgroup libvirtd
addgroup wheel
addgroup users

useradd -m -g users -G wheel,libvirt $user

echo "Add a password for $user."
passwd $user

echo "################## Installing grub ##################"

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# echo "################## Copying grub locale ##################"

# cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

echo "################## Making grub ##################"

grub-mkconfig -o /boot/grub/grub.cfg

echo "Finished! Please type 'exit' and then 'umount -R /mnt' and reboot. Run the system_setup script next."

