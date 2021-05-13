This is collection of install scripts. If you would like bluetooth functionality, simply uncomment the relevant parts of the script before running.

For this to work, the user must be running an nvidia graphics card. If not, Please comment out the nvidia packages and install with your appropriate graphics packages. I also have an intel processor. If you have an amd processor, please add 'amd-ucode' to the base_install script. These scripts are also assuming a btrfs file system. If that is not what you are looking for you can comment the btrfs-progs package and modify it as you please. As always, please verify what this is actually doing to your system before running it. 

# Installtion:
~~~
git clone https://github.com/jtw023/arch_install.git
~~~

Run the first script "base_install.sh" after the initial pacstrap command. For example:

After formatting your drive run the command:

~~~
pacstrap /mnt base linux linux-firmware intel-ucode btrfs-progs git vim
~~~

When each script finishes it will tell you what to do and which script to run next.  
